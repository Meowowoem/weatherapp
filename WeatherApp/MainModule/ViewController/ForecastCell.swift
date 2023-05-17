//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 16.05.2023.
//

import UIKit

final class ForecastCell: UICollectionViewCell {
    private let mainStackView = UIStackView()
    private let cityNameLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let conditionLabel = UILabel()
    private let humidityLabel = UILabel()
    private let bgImageView = UIImageView()

    public func setupViews(_ forecast: Forecast) {
        bgImageView.image = UIImage(named: conditionFromValue(forecast.condition))
        contentView.backgroundColor = .green
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        contentView.addSubview(bgImageView)
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        bgImageView.addSubview(mainStackView)
        
        cityNameLabel.text = forecast.cityName
        cityNameLabel.font = .systemFont(ofSize: 36, weight: .medium)
        cityNameLabel.textColor = .black
        mainStackView.addArrangedSubview(cityNameLabel)
        
        temperatureLabel.text = "\(forecast.temperature)℃"
        temperatureLabel.font = .systemFont(ofSize: 96, weight: .bold)
        temperatureLabel.textColor = .black
        mainStackView.addArrangedSubview(temperatureLabel)
        
        conditionLabel.text = conditionFromValue(forecast.condition).capitalized
        conditionLabel.font = .systemFont(ofSize: 24, weight: .medium)
        conditionLabel.textColor = .black
        mainStackView.addArrangedSubview(conditionLabel)
        
        humidityLabel.text = "Humidity: \(forecast.humidity) %"
        humidityLabel.font = .systemFont(ofSize: 24, weight: .medium)
        humidityLabel.textColor = .black
        mainStackView.addArrangedSubview(humidityLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: rightAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            bgImageView.topAnchor.constraint(equalTo: topAnchor),
            bgImageView.widthAnchor.constraint(equalTo: widthAnchor),
            bgImageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    private func conditionFromValue(_ rawCondition: WeatherCondition) -> String {
        switch rawCondition {
        case .sunny:
            return "sunny"
        case .cloudy:
            return "cloudy"
        case .windy:
            return "windy"
        case .rainy:
            return "rainy"
        case .snowy:
            return "snowy"
        }
    }
}
