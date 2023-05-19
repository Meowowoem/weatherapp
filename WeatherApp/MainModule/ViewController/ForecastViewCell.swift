//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 16.05.2023.
//

import UIKit

final class ForecastViewCell: UICollectionViewCell {
    //MARK: - Private properties
    private let bgImageView: UIImageView = {
        let bg = UIImageView()
        bg.contentMode = .scaleAspectFill
        bg.clipsToBounds = true
        bg.translatesAutoresizingMaskIntoConstraints = false
        return bg
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 96, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    static var id: String {
        String(describing: self)
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    func setup(_ forecast: Forecast) {
        bgImageView.image = UIImage(named: forecast.condition.rawValue)
        cityNameLabel.text = forecast.cityName
        temperatureLabel.text = "\(forecast.temperature)℃"
        conditionLabel.text = forecast.condition.rawValue.capitalized
        humidityLabel.text = "Humidity: \(forecast.humidity) %"
    }
    
    //MARK: - Private methods
    private func setupViews() {
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(cityNameLabel)
        mainStackView.addArrangedSubview(temperatureLabel)
        mainStackView.addArrangedSubview(conditionLabel)
        mainStackView.addArrangedSubview(humidityLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: rightAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: topAnchor),
            bgImageView.widthAnchor.constraint(equalTo: widthAnchor),
            bgImageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}
