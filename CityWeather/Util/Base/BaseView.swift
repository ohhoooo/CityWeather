//
//  BaseView.swift
//  CityWeather
//
//  Created by 김정호 on 2/13/25.
//

import UIKit

protocol BaseViewProtocol: AnyObject {
    func configureUI()
    func configureHierarchy()
    func configureConstraints()
}

class BaseView: UIView, BaseViewProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
