//
//  SearchAssembly.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import UIKit

enum SearchAssembly {
    static func make(networkService: Network) -> SearchViewController {
        let model = SearchModel(networkService: networkService)
        let vc = SearchViewController(model: model)
        return vc
    }
}
