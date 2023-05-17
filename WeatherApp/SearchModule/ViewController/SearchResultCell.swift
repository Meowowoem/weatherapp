//
//  SearchResultCell.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation
import UIKit

class SearchResultCell: UITableViewCell {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        return button
    }()
    
    public func setupViews(name: String, country: String) {
        addSubview(stackView)
        
        let nameString = name + ", " + country
        nameLabel.text = nameString
        stackView.addArrangedSubview(nameLabel)
        stackView.isUserInteractionEnabled = true
        
        addButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        addButton.isUserInteractionEnabled = true
        stackView.addArrangedSubview(addButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc
    private func addButtonPressed(_ sender: UIButton) {
        
    }
}
