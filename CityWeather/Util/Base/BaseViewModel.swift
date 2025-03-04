//
//  BaseViewModel.swift
//  CityWeather
//
//  Created by 김정호 on 2/13/25.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform()
}
