//
//  CityCell.swift
//  CityWeather
//
//  Created by 김정호 on 2/14/25.
//

import UIKit
import SnapKit
import Then

final class CityCell: BaseTableViewCell {
    
    // MARK: - properties
    static let identifier = "CityCell"
    
    private let basedView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    private let weatherInfoButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .black
        config.background.backgroundColor = .clear
        $0.configuration = config
    }
    
    // MARK: - life cycles
    override func prepareForReuse() {
        super.prepareForReuse()
        
        weatherInfoButton.configuration?.title = nil
        weatherInfoButton.configuration?.image = nil
    }
    
    // MARK: - methods
    override func configureUI() {
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        contentView.addSubview(basedView)
        basedView.addSubview(weatherInfoButton)
    }
    
    override func configureConstraints() {
        basedView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        weatherInfoButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(4)
        }
    }
    
    func bindIcon(weather: Weather?, data: Data) {
        guard let weather else { return }
        
        weatherInfoButton.configuration?.image = UIImage(data: data)
        weatherInfoButton.configuration?.imagePlacement = .leading
        weatherInfoButton.configuration?.attributedTitle = AttributedString("오늘의 날씨는 \(weather.description)입니다",
                                                                            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 16, weight: .medium)]))
        
        weatherInfoButton.snp.remakeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(4)
        }
    }
    
    func bindPhoto(data: Data) {
        weatherInfoButton.configuration?.image = UIImage(data: data)
        weatherInfoButton.configuration?.titleAlignment = .leading
        weatherInfoButton.configuration?.imagePlacement = .bottom
        weatherInfoButton.configuration?.attributedTitle = AttributedString("오늘의 사진",
                                                                            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 16, weight: .medium)]))
    }
    
    func bindWeather(weather: Weather?, index: Int) {
        guard let weather else { return }
        
        switch index {
        case 1:
            weatherInfoButton.configuration?.attributedTitle = AttributedString("현재 온도는 \(weather.temp)입니다 \(weather.tempMin) \(weather.tempMax)",
                                                                                attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 16, weight: .medium)]))
        case 2:
            weatherInfoButton.configuration?.attributedTitle = AttributedString("체감 온도는 \(weather.tempFeelsLike)입니다",
                                                                                attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 16, weight: .medium)]))
        case 3:
            weatherInfoButton.configuration?.attributedTitle = AttributedString("서울의 일출 시각은 \(weather.sunrise.formatToCity()), 일몰 시각은 \(weather.sunset.formatToCity())입니다",
                                                                                attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 16, weight: .medium)]))
        default:
            weatherInfoButton.configuration?.attributedTitle = AttributedString("습도는 \(weather.humidity)이고, 풍속은 \(weather.windSpeed)입니다",
                                                                                attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 16, weight: .medium)]))
        }
    }
}
