//
//  SearchAssembly.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import UIKit

enum SearchAssembly {
    static func make(networkService: Network) -> SearchViewController {
        let model = SearchModel()
        model.networkService = networkService
        let vc = SearchViewController()
        vc.model = model
        return vc
    }
}
