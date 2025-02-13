//
//  BaseTableViewCell.swift
//  CityWeather
//
//  Created by 김정호 on 2/13/25.
//

import UIKit

class BaseTableViewCell: UITableViewCell, BaseViewProtocol {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        configureHierarchy()
        configureConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() { }
    
    func configureHierarchy() { }
    
    func configureConstraints() { }
}
