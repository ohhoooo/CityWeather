//
//  CityWeather.swift
//  CityWeather
//
//  Created by 김정호 on 2/16/25.
//

import Foundation

struct CityWeather {
    let region: Region
    let weather: Weather
    let icon: Data
    let photo: Data
}

struct Region {
    let id: Int
    let city: String
    let koCityName: String
    let country: String
    let koCountryName: String
}

struct Weather {
    let icon: String
    let description: String
    let temp: String
    let tempMin: String
    let tempMax: String
    let tempFeelsLike: String
    let sunset: String
    let sunrise: String
    let humidity: String
    let windSpeed: String
}
