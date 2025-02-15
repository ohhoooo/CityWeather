//
//  CityViewModel.swift
//  CityWeather
//
//  Created by 김정호 on 2/14/25.
//

import Foundation
import Alamofire

final class CityViewModel: BaseViewModel {
    
    // MARK: - properties
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        let willAppearView = Observable(())
        let tappedRefreshBarButtonItem = Observable(())
        let tappedSearchBarButtonItem = Observable(())
    }
    
    struct Output {
        let region = Observable<Region?>(nil)
        let weather = Observable<Weather?>(nil)
        let iconImage = Observable<Data>(Data())
        let photoImage = Observable<Data>(Data())
        let citySearchView = Observable(())
    }
    
    // MARK: - life cycles
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    // MARK: - methods
    func transform() {
        input.willAppearView.lazyBind { [weak self] _ in
            let id = UserDefaults.standard.integer(forKey: "id")
            
            if id == 0 {
                self?.fetchWeather(id: "1835848")
            } else {
                self?.fetchWeather(id: String(id))
            }
            
            guard let data = self?.loadData() else { return }
            guard let citiesResponse = self?.fetchCitiesResponse(data: data) else { return }
            guard let region = citiesResponse.cities.filter({ $0.id == id }).first?.toDomain() else { return }
            
            self?.output.region.value = region
        }
        
        input.tappedSearchBarButtonItem.lazyBind { [weak self] _ in
            self?.output.citySearchView.value = ()
        }
        
        input.tappedRefreshBarButtonItem.lazyBind { [weak self] _ in
            self?.input.willAppearView.value = ()
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
    
    private func fetchWeather(id: String) {
        let request = WeatherRequest(id: id,
                                     lang: "kr",
                                     units: "metric",
                                     appid: Bundle.main.infoDictionary?["OpenWeatherAPIKey"] as! String)
        
        NetworkManager.shared.request(WeatherResponse.self, router: .fetchWeather(request: request)) { [weak self] result in
            switch result {
            case .success(let success):
                self?.output.weather.value = success.list.first.map { $0.toDomain() }
                
                if let query = success.list.first?.weather.first?.icon {
                    self?.fetchIconImage(query: query)
                }
                
                if let query = success.list.first?.weather.description {
                    self?.fetchPhoto(query: query)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func fetchIconImage(query: String) {
        let request = IconImageRequest(query: query)
        
        AF.request(NetworkRouter.fetchIconImage(request: request)).responseData { [weak self] response in
            switch response.result {
            case .success(let success):
                self?.output.iconImage.value = success
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func fetchPhoto(query: String) {
        let request = PhotoRequest(query: query)
        
        NetworkManager.shared.request(PhotoResponse.self, router: .fetchPhoto(request: request)) { [weak self] result in
            switch result {
            case .success(let success):
                if let query = success.urlsResponse.first?.urls.thumb {
                    print(query)
                    self?.fetchPhotoImage(query: query)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func fetchPhotoImage(query: String) {
        let request = PhotoImageRequest(query: query)
        
        AF.request(NetworkRouter.fetchPhotoImage(request: request)).responseData { [weak self] response in
            switch response.result {
            case .success(let success):
                self?.output.photoImage.value = success
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
