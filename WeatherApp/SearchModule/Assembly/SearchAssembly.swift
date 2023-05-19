//
//  SearchAssembly.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

enum SearchAssembly {
    static func make(networkService: Network) -> SearchViewController {
        return SearchViewController(model: SearchModel(networkService: networkService))
    }
}
