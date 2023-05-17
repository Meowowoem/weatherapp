//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 16.05.2023.
//

import UIKit

final class ForecastView: UIView {
    private var forecast: ForecastModel
    private var mainStackView: UIStackView!
    private var cityNameLabel: UILabel!
    private var temperatureLabel: UILabel!
    private var conditionLabel: UILabel!
    private var humidityLabel: UILabel!
    private var bgImageView: UIImageView!
    
    init(_ forecast: ForecastModel) {
        self.forecast = forecast
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupViews() {
        bgImageView = UIImageView()
        bgImageView.image = UIImage(named: conditionFromValue(forecast.condition))
        bgImageView.contentMode = .scaleToFill
        addSubview(bgImageView)
        
        mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        addSubview(mainStackView)
        
        cityNameLabel = UILabel()
        cityNameLabel.text = forecast.cityName
        cityNameLabel.font = .systemFont(ofSize: 36, weight: .medium)
        cityNameLabel.textColor = .black
        mainStackView.addArrangedSubview(cityNameLabel)
        
        temperatureLabel = UILabel()
        temperatureLabel.text = "\(forecast.temperature)℃"
        temperatureLabel.font = .systemFont(ofSize: 96, weight: .bold)
        temperatureLabel.textColor = .black
        mainStackView.addArrangedSubview(temperatureLabel)
        
        conditionLabel = UILabel()
        conditionLabel.text = conditionFromValue(forecast.condition).capitalized
        conditionLabel.font = .systemFont(ofSize: 24, weight: .medium)
        conditionLabel.textColor = .black
        mainStackView.addArrangedSubview(conditionLabel)
        
        humidityLabel = UILabel()
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
