//
//  CitySearchView.swift
//  CityWeather
//
//  Created by 김정호 on 2/14/25.
//

import UIKit
import SnapKit
import Then

final class CitySearchView: BaseView {
    
    // MARK: - properties
    let searchBar = UISearchBar().then {
        $0.placeholder = "지금, 날씨가 궁금한 곳은?"
        $0.searchBarStyle = .minimal
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    private let infoLabel = UILabel().then {
        $0.text = "원하는 도시를 찾지 못했습니다."
        $0.textAlignment = .center
    }
    
    // MARK: - methods
    override func configureUI() {
        backgroundColor = UIColor(red: 246/255, green: 237/255, blue: 254/255, alpha: 1)
    }
    
    override func configureHierarchy() {
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(infoLabel)
    }
    
    override func configureConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func hasData(hasData: Bool) {
        tableView.isHidden = !hasData
        infoLabel.isHidden = hasData
    }
}
