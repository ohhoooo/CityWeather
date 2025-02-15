//
//  WeatherRequest.swift
//  CityWeather
//
//  Created by 김정호 on 2/13/25.
//

import Foundation

struct WeatherRequest: Encodable {
    let id: String
    let lang: String
    let units: String
    let appid: String
}
