//
//  MainAssembly.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import UIKit
import CoreLocation

enum MainAssembly {
    static func make(networkService: Network, locationService: LocationService) -> MainViewController {
        let model = MainModel(networkService: networkService,
                              locationService: locationService)
        let vc = MainViewController(model: model, searchVC: {
            SearchAssembly.make(networkService: networkService)
        })
        
        return vc
    }
}
