//
//  CitySearchViewController.swift
//  CityWeather
//
//  Created by 김정호 on 2/14/25.
//

import UIKit

final class CitySearchViewController: BaseViewController {
    
    // MARK: - properties
    private let citySearchView = CitySearchView()
    let viewModel = CitySearchViewModel()
    
    // MARK: - life cycles
    override func loadView() {
        view = citySearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - methods
    override func configureStyle() {
        configureNavigation()
    }
    
    override func configureDelegate() {
        
    }
    
    override func configureAddTarget() {
        
    }
    
    override func bind() {
        
    }
    
    private func configureNavigation() {
        navigationItem.title = "도시 검색"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
    }
}
