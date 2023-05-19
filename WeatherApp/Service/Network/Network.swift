//
//  Network.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 19.05.2023.
//

import Foundation

protocol Network {
    func fetchCities(query: String, completion: @escaping (Result<[City], FetchError>) -> Void)
    func fetchForecast(lat: Double, lon: Double, completion: @escaping (Result<GeneralForecast, FetchError>) -> Void)
}
