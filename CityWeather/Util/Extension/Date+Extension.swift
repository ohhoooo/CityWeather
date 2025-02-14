//
//  Date+Extension.swift
//  CityWeather
//
//  Created by 김정호 on 2/18/25.
//

import Foundation

extension Date {
    func formatToCity() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "M월 dd일(E) a h시 m분"
        
        return formatter.string(from: self)
    }
}
