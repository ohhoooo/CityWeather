//
//  Encodable+Extension.swift
//  CityWeather
//
//  Created by 김정호 on 2/13/25.
//

import Foundation

extension Encodable {
    var toDictionary: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { return nil }
        
        return dictionary
    }
}
