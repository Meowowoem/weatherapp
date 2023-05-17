//
//  MainAssembly.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import UIKit

enum MainAssembly {
    static func make(networkService: Network) -> MainViewController {
        let model = MainModel(networkService: networkService)
        let vc = MainViewController(model: model, searchVC: {
            SearchAssembly.make(networkService: networkService)
        })
        
        return vc
    }
}
