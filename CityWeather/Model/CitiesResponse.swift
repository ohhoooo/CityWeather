//
//  CitiesResponse.swift
//  CityWeather
//
//  Created by 김정호 on 2/16/25.
//

import Foundation

struct CitiesResponse: Decodable {
    let cities: [CityResponse]
}

extension CitiesResponse {
    struct CityResponse: Decodable {
        let city: String
        let koCityName: String
        let country: String
        let koCountryName: String
        let id: Int
        
        enum CodingKeys: String, CodingKey {
            case city
            case koCityName = "ko_city_name"
            case country
            case koCountryName = "ko_country_name"
            case id
        }
    }
}

extension CitiesResponse.CityResponse {
    func toDomain() -> Region {
        return .init(id: id,
                     city: city,
                     koCityName: koCityName,
                     country: country,
                     koCountryName: koCountryName)
    }
}
