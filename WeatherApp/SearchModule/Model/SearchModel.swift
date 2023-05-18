//
//  SearchModel.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation
import CoreLocation

struct City: Decodable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    let localtimeEpoch: Double?
}

struct ForecastJson: Decodable {
    let location: City
    let current: Current
    let forecast: ForecastRaw
}

struct Current: Decodable {
    let tempC: Double
    let humidity: Int
    let condition: Condition
}

struct ForecastRaw: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let hour: [HourForecast]
}

struct HourForecast: Decodable {
    let timeEpoch: Double
    let tempC: Double
    let humidity: Int
    let condition: Condition
}

struct Condition: Decodable {
    let code: Int
}


final class SearchModel {
    public var networkService: Network
    
    init(networkService: Network) {
        self.networkService = networkService
    }
    
    public func fetchCities(query: String,
                            completion: @escaping (Result<[City], FetchError>) -> (Void)) {
        networkService.fetchCities(query: query,
                                    completion: { result in
            completion(result)
        })
    }
    
    public func loadForecast(for city: City,
                             completion: @escaping (Result<ForecastJson, FetchError>) -> (Void)) {
        networkService.fetchForecast(lat: city.lat,
                                      lon: city.lon,
                                      completion: { result in
            completion(result)
        })
    }
}
