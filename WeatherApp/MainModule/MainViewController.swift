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
    private var humidityLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        mainStackView = UIStackView()
        view.addSubview(mainStackView)
        
        cityNameLabel = UILabel()
        cityNameLabel.text = "Moscow"
        mainStackView.addArrangedSubview(cityNameLabel)
    }
    
    private func setupConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
}

