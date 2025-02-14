//
//  String+Extension.swift
//  CityWeather
//
//  Created by 김정호 on 2/18/25.
//

import Foundation

extension String {
    func formatToCity() -> String {
        guard let timeInterval = TimeInterval(self) else { return "" }
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h시 m분"
        
        return formatter.string(from: date)
    }
}
