//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 16.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    private var mainStackView: UIStackView!
    private var cityNameLabel: UILabel!
    private var temperatureLabel: UILabel!
    private var conditionLabel: UILabel!
    private var humidityLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        view.addSubview(mainStackView)
        
        cityNameLabel = UILabel()
        cityNameLabel.text = "Moscow"
        cityNameLabel.font = .systemFont(ofSize: 36, weight: .medium)
        cityNameLabel.textColor = .systemGray
        mainStackView.addArrangedSubview(cityNameLabel)
        
        temperatureLabel = UILabel()
        temperatureLabel.text = "+30℃"
        temperatureLabel.font = .systemFont(ofSize: 96, weight: .bold)
        temperatureLabel.textColor = .systemMint
        mainStackView.addArrangedSubview(temperatureLabel)
        
        conditionLabel = UILabel()
        conditionLabel.text = "Солнечно"
        conditionLabel.font = .systemFont(ofSize: 24, weight: .medium)
        conditionLabel.textColor = .systemGray
        mainStackView.addArrangedSubview(conditionLabel)
        
        humidityLabel = UILabel()
        humidityLabel.text = "Влажность: 75 %"
        humidityLabel.font = .systemFont(ofSize: 24, weight: .medium)
        humidityLabel.textColor = .systemGray
        mainStackView.addArrangedSubview(humidityLabel)
    }
    
    private func setupConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
}

