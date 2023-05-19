//
//  MainAssembly.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

enum MainAssembly {
    static func make(
        networkService: Network,
        locationService: LocationService,
        storageService: Storage
    ) -> MainViewController {
        let model = MainModel(
            networkService: networkService,
            locationService: locationService,
            storageService: storageService
        )
        
        return MainViewController(model: model) {
            SearchAssembly.make(networkService: networkService)
        }
    }
}
