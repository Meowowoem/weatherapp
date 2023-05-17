//
//  MainAssembly.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import UIKit

enum MainAssembly {
    static func make(networkService: Network) -> MainViewController {
        let model = MainModel()
        let vc = MainViewController {
            SearchAssembly.make(networkService: networkService)
        }
        vc.model = model
        
        return vc
    }
}
