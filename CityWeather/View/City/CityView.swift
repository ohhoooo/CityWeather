//
//  CityView.swift
//  CityWeather
//
//  Created by 김정호 on 2/14/25.
//

import UIKit
import SnapKit
import Then

final class CityView: BaseView {
    
    // MARK: - properties
    let refreshBarButtonItem = UIBarButtonItem().then {
        $0.style = .done
        $0.image = UIImage(systemName: "arrow.clockwise")
    }
    
    let searchBarButtonItem = UIBarButtonItem().then {
        $0.style = .done
        $0.image = UIImage(systemName: "magnifyingglass")
    }
    
    private let dateTimeLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - methods
    override func configureUI() {
        backgroundColor = UIColor(red: 246/255, green: 237/255, blue: 254/255, alpha: 1)
    }
    
    override func configureHierarchy() {
        addSubview(dateTimeLabel)
        addSubview(tableView)
    }
    
    override func configureConstraints() {
        dateTimeLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(dateTimeLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func bindDate(date: Date) {
        dateTimeLabel.text = date.formatToCity()
    }
}
