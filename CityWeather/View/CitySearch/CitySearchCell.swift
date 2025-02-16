//
//  CitySearchCell.swift
//  CityWeather
//
//  Created by 김정호 on 2/14/25.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class CitySearchCell: BaseTableViewCell {
    
    // MARK: - properties
    static let identifier = "CitySearchCell"
    
    private let basedView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor(red: 233/255, green: 223/255, blue: 253/255, alpha: 1)
        $0.layer.cornerRadius = 8
    }
    
    private let countryLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    private let cityLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    private let tempMinLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    private let tempMaxLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let tempLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    // MARK: - life cycles
    override func prepareForReuse() {
        super.prepareForReuse()
        
        countryLabel.text = nil
        cityLabel.text = nil
        tempMinLabel.text = nil
        tempMaxLabel.text = nil
        iconImageView.image = nil
        tempLabel.text = nil
    }
    
    // MARK: - methods
    override func configureUI() {
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        contentView.addSubview(basedView)
        basedView.addSubview(countryLabel)
        basedView.addSubview(cityLabel)
        basedView.addSubview(tempMinLabel)
        basedView.addSubview(tempMaxLabel)
        basedView.addSubview(iconImageView)
        basedView.addSubview(tempLabel)
    }
    
    override func configureConstraints() {
        basedView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        countryLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
        }
        
        cityLabel.snp.makeConstraints {
            $0.top.equalTo(countryLabel.snp.bottom).offset(4)
            $0.leading.equalTo(countryLabel)
        }
        
        tempMinLabel.snp.makeConstraints {
            $0.leading.equalTo(countryLabel)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        tempMaxLabel.snp.makeConstraints {
            $0.leading.equalTo(tempMinLabel.snp.trailing).offset(4)
            $0.bottom.equalTo(tempMinLabel)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(16)
        }
        
        tempLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(16)
            $0.trailing.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func bind(region: Region, weather: Weather, iconImage: Data) {
        countryLabel.text = region.koCountryName
        cityLabel.text = region.koCityName
        tempMinLabel.text = weather.tempMin
        tempMaxLabel.text = weather.tempMax
        iconImageView.image = UIImage(data: iconImage)
        tempLabel.text = weather.temp
    }
}
