//
//  IconImageRequest.swift
//  CityWeather
//
//  Created by 김정호 on 2/15/25.
//

import Foundation

struct IconImageRequest {
    let query: String
    
    init(query: String) {
        self.query = query + ".png"
    }
}
