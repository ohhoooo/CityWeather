//
//  PhotoResponse.swift
//  CityWeather
//
//  Created by 김정호 on 2/13/25.
//

import Foundation

struct PhotoResponse: Decodable {
    let urlsResponse: [UrlsResponse]
    
    enum CodingKeys: String, CodingKey {
        case urlsResponse = "results"
    }
}

struct UrlsResponse: Decodable {
    let urls: Urls
}

struct Urls: Decodable {
    let thumb: String
    let small: String
}
