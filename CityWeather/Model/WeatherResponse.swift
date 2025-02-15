//
//  WeatherResponse.swift
//  CityWeather
//
//  Created by 김정호 on 2/13/25.
//

import Foundation

struct WeatherResponse: Decodable {
    let cnt: Int
    let list: [List]
}

extension WeatherResponse {
    struct List: Decodable {
        let sys: SysResponse
        let main: MainResponse
        let wind: WindResponse
        let weather: [WeatherDetailResponse]
    }
}

extension WeatherResponse.List {
    struct SysResponse: Decodable {
        let sunrise: Int
        let sunset: Int
    }
    
    struct MainResponse: Decodable {
        let temp: Double
        let tempMin: Double
        let tempMax: Double
        let feelsLike: Double
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case feelsLike = "feels_like"
            case humidity
        }
    }
    
    struct WeatherDetailResponse: Decodable {
        let description: String
        let icon: String
    }
    
    struct WindResponse: Decodable {
        let speed: Double
    }
}

extension WeatherResponse.List {
    func toDomain() -> Weather {
        return .init(icon: weather[0].icon,
                     description: weather[0].description,
                     temp: "\(main.temp)°",
                     tempMin: "최저 \(Int(main.tempMin))°",
                     tempMax: "최고 \(Int(main.tempMax))°",
                     tempFeelsLike: "\(Int(main.feelsLike))°",
                     sunset: String(sys.sunset),
                     sunrise: String(sys.sunrise),
                     humidity: "\(main.humidity)%",
                     windSpeed: "\(wind.speed)m/s")
    }
}
