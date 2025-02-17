//
//  CitySearchViewModel.swift
//  CityWeather
//
//  Created by 김정호 on 2/14/25.
//

import Foundation
import Alamofire

final class CitySearchViewModel: BaseViewModel {
    
    // MARK: - properties
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        let didLoadView = Observable(())
        let didScrollScrollView = Observable(())
        let didSelectRowAt = Observable<IndexPath?>(nil)
        let searchBarSearchButtonClicked = Observable<String?>(nil)
    }
    
    struct Output {
        let end = Observable(-1)
        let isLoadingLast = Observable(false)
        let regions = Observable<[Region]>([])
        let weathers = Observable<[Weather]>([])
        let iconImages = Observable<[Data]>([])
        let cityView = Observable(())
    }
    
    // MARK: - life cycles
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    // MARK: - methods
    func transform() {
        input.didLoadView.lazyBind { [weak self] _ in
            guard let data = self?.loadData() else { return }
            guard let citiesResponse = self?.fetchCitiesResponse(data: data) else { return }
            
            self?.output.regions.value = citiesResponse.cities.map { $0.toDomain() }
            
            if citiesResponse.cities.count > 19 {
                self?.output.end.value += 20
                self?.fetchWeather(start: 0, end: 19)
            }
        }
        
        input.didScrollScrollView.lazyBind { [weak self] _ in
            guard let end = self?.output.end.value else { return }
            guard let regions = self?.output.regions.value else { return }
            
            if regions.count - 1 >= end + 20 {
                self?.output.end.value += 20
                self?.fetchWeather(start: end - 19, end: end)
            } else if regions.count - 1 > end && regions.count - 1 < end + 20 {
                self?.fetchWeather(start: end + 1, end: regions.count - 1)
                self?.output.end.value = regions.count - 1
            } else {
                self?.output.isLoadingLast.value = true
            }
        }
        
        input.didSelectRowAt.lazyBind { [weak self] indexPath in
            guard let indexPath else { return }
            guard let id = self?.output.regions.value[indexPath.row].id else { return }
            
            UserDefaults.standard.set(id, forKey: "id")
            
            self?.output.cityView.value = ()
        }
        
        input.searchBarSearchButtonClicked.lazyBind { [weak self] query in
            self?.output.end.value = -1
            self?.output.isLoadingLast.value = false
            self?.output.regions.value.removeAll()
            self?.output.weathers.value.removeAll()
            self?.output.iconImages.value.removeAll()
            
            if let query, !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                guard let data = self?.loadData() else { return }
                guard let citiesResponse = self?.fetchCitiesResponse(data: data) else { return }
                
                self?.output.regions.value = citiesResponse.cities.filter { $0.city.contains(query) || $0.country.contains(query) || $0.koCityName.contains(query) || $0.koCountryName.contains(query) }.map { $0.toDomain() }
                
                guard let end = self?.output.end.value else { return }
                guard let regions = self?.output.regions.value else { return }
                
                if regions.count - 1 >= end + 20 {
                    self?.output.end.value += 20
                    self?.fetchWeather(start: end - 19, end: end)
                } else if regions.count - 1 > end && regions.count - 1 < end + 20 {
                    self?.fetchWeather(start: end + 1, end: regions.count - 1)
                    self?.output.end.value = regions.count - 1
                } else {
                    self?.output.isLoadingLast.value = true
                }
            } else {
                self?.input.didLoadView.value = ()
            }
        }
    }
    
    private func loadData() -> Data? {
        guard let url = Bundle.main.url(forResource: "CityInfo", withExtension: "json") else { return nil }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            return nil
        }
    }
    
    private func fetchCitiesResponse(data: Data) -> CitiesResponse? {
        do {
            return try JSONDecoder().decode(CitiesResponse.self, from: data)
        } catch {
            return nil
        }
    }
    
    private func fetchWeather(start: Int, end: Int) {
        let request = WeatherRequest(
            id: fetchIds(start: start, end: end),
            lang: "kr",
            units: "metric",
            appid: Bundle.main.infoDictionary?["OpenWeatherAPIKey"] as! String
        )
        
        NetworkManager.shared.request(WeatherResponse.self, router: .fetchWeather(request: request)) { [weak self] result in
            switch result {
            case .success(let success):
                self?.output.weathers.value.append(contentsOf: success.list.map { $0.toDomain() })
                self?.fetchIconImages(start: start, end: end)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func fetchIds(start: Int, end: Int) -> String {
        var ids = ""
        
        for i in start...end {
            if i == start {
                ids += "\(output.regions.value[i].id)"
            } else {
                ids += ",\(output.regions.value[i].id)"
            }
        }
        
        return ids
    }
    
    private func fetchIconImages(start: Int, end: Int) {
        var datas: [Data] = []
        let group = DispatchGroup()
        
        for i in start...end {
            let query = output.weathers.value[i].icon
            let request = IconImageRequest(query: query)
            
            group.enter()
            
            AF.request(NetworkRouter.fetchIconImage(request: request)).responseData { response in
                switch response.result {
                case .success(let success):
                    datas.append(success)
                    group.leave()
                case .failure(let failure):
                    print(failure)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.output.iconImages.value.append(contentsOf: datas)
        }
    }
}
