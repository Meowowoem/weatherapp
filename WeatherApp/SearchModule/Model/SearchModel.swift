//
//  SearchModel.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation

final class SearchModel {
    private var networkService: Network
    
    init(networkService: Network) {
        self.networkService = networkService
    }
    
    func fetchCities(query: String, completion: @escaping (Result<[City], FetchError>) -> (Void)) {
        networkService.fetchCities(query: query, completion: completion)
    }
    
    func loadForecast(for city: City, completion: @escaping (Result<GeneralForecast, FetchError>) -> (Void)) {
        networkService.fetchForecast(lat: city.lat, lon: city.lon, completion: completion)
    }
}
