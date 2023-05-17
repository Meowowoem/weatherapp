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
}

struct ForecastJson: Decodable {
    let location: City
    let forecast: ForecastRaw
}

struct ForecastRaw: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let hour: [HourForecast]
}

struct HourForecast: Decodable {
    let time_epoch: Double
    let temp_c: Double
    let humidity: Int
    
}


final class SearchModel {
    public var networkService: Network?
    
    public func fetchCities(query: String,
                            completion: @escaping (Result<[City], Error>) -> (Void)) {
        networkService?.fetchCities(query: query,
                                    completion: { result in
            completion(result)
        })
    }
    
    public func loadForecast(for city: City) {
        networkService?.fetchForecast(lat: city.lat,
                                      lon: city.lon,
                                      completion: { result in
            
        })
    }
}
