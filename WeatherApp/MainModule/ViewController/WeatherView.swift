//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 16.05.2023.
//

import UIKit

final class WeatherView: UIView {
    private var city: CityModel
    private var mainStackView: UIStackView!
    private var cityNameLabel: UILabel!
    private var temperatureLabel: UILabel!
    private var conditionLabel: UILabel!
    private var humidityLabel: UILabel!
    
    init(city: CityModel) {
        self.city = city
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupViews() {
        mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        addSubview(mainStackView)
        
        cityNameLabel = UILabel()
        cityNameLabel.text = city.name
        cityNameLabel.font = .systemFont(ofSize: 36, weight: .medium)
        cityNameLabel.textColor = .systemGray
        mainStackView.addArrangedSubview(cityNameLabel)
        
        temperatureLabel = UILabel()
        temperatureLabel.text = "\(city.weather.temperature)℃"
        temperatureLabel.font = .systemFont(ofSize: 96, weight: .bold)
        temperatureLabel.textColor = .systemMint
        mainStackView.addArrangedSubview(temperatureLabel)
        
        conditionLabel = UILabel()
        conditionLabel.text = conditionFromValue(city.weather.condition)
        conditionLabel.font = .systemFont(ofSize: 24, weight: .medium)
        conditionLabel.textColor = .systemGray
        mainStackView.addArrangedSubview(conditionLabel)
        
        humidityLabel = UILabel()
        humidityLabel.text = "Влажность: \(city.weather.humidity) %"
        humidityLabel.font = .systemFont(ofSize: 24, weight: .medium)
        humidityLabel.textColor = .systemGray
        mainStackView.addArrangedSubview(humidityLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: rightAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func conditionFromValue(_ rawCondition: WeatherCondition) -> String {
        switch rawCondition {
        case .sunny:
            return "Sunny"
        case .cloudy:
            return "Cloudy"
        case .windy:
            return "Windy"
        case .rainy:
            return "Rainy"
        case .snowy:
            return "Snowy"
        }
    }
}
