//
//  MainAssembly.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import UIKit
import CoreLocation

enum MainAssembly {
    static func make(networkService: Network,
                     locationService: LocationService,
                     storageService: Storage) -> MainViewController {
        let model = MainModel(networkService: networkService,
                              locationService: locationService,
                              storageService: storageService)
        let vc = MainViewController(model: model, searchVC: {
            SearchAssembly.make(networkService: networkService)
        })
        
        return vc
    }
}
