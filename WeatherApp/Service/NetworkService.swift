//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation
import Alamofire

protocol Network {
    func fetchCities(query: String,
                     completion: @escaping (Result<[City], Error>) -> (Void))
    func fetchForecast(lat: Double,
                       lon: Double,
                       completion: @escaping (Result<ForecastJson, Error>) -> (Void))
}

final class AlamofireService: Network {
    private let key = "42d074f43e4d4b4485793642231705"
    
    func fetchCities(query: String,
                     completion: @escaping (Result<[City], Error>) -> (Void)) {
        AF.request(createURLStringForSearch(query))
            .validate()
            .response { [weak self] response in
                guard let self = self else { return }
                guard let data = response.data else {
                    if let error = response.error {
                        completion(.failure(error))
                    }
                    return
                }
                
                completion(self.decode(data))
            }
    }
    
    func fetchForecast(lat: Double,
                       lon: Double,
                       completion: @escaping (Result<ForecastJson, Error>) -> (Void)) {
        AF.request(createURLStringForForecast(lat: lat,
                                              lon: lon))
            .validate()
            .response { [weak self] response in
                guard let self = self else { return }
                guard let data = response.data else {
                    if let error = response.error {
                        completion(.failure(error))
                    }
                    return
                }
                completion(self.decode(data))
            }
    }
}

private extension AlamofireService {
    private func createURLStringForSearch(_ query: String) -> String {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weatherapi.com"
        components.path = "/v1/search.json"
        
        components.queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "q", value: query)
        ]
        
        return components.url?.absoluteString ?? ""
    }
    
    private func createURLStringForForecast(lat: Double, lon: Double) -> String {
        let coordString = String(lat) + "," + String(lon)
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weatherapi.com"
        components.path = "/v1/forecast.json"
        
        components.queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "q", value: coordString),
            URLQueryItem(name: "days", value: "10")
        ]
        
        return components.url?.absoluteString ?? ""
    }
    
    func decode<T: Decodable>(_ data: Data) -> Result<T, Error> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let result = try? decoder.decode(T.self, from: data) else { return .failure(NSError(domain: "", code: 1)) }
        return .success(result)
    }
}
