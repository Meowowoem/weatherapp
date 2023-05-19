//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation
import Alamofire

final class AlamofireService: Network {
    private let key = "42d074f43e4d4b4485793642231705"
    
    func fetchCities(query: String, completion: @escaping (Result<[City], FetchError>) -> Void) {
        guard let urlString = createURLStringForSearch(query) else { return completion(.failure(.badResponce)) }
        AF.request(urlString)
            .validate()
            .response { [weak self] response in
                self?.handle(response, completion: completion)
            }
    }
    
    func fetchForecast(lat: Double, lon: Double, completion: @escaping (Result<GeneralForecast, FetchError>) -> Void) {
        guard let urlString = createURLStringForForecast(lat: lat, lon: lon) else { return completion(.failure(.badResponce)) }
        AF.request(urlString)
            .validate()
            .response { [weak self] response in
                self?.handle(response, completion: completion)
            }
    }
}

private extension AlamofireService {
    func createURLStringForSearch(_ query: String) -> String? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weatherapi.com"
        components.path = "/v1/search.json"
        
        components.queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "q", value: query)
        ]
        
        return components.url?.absoluteString
    }
    
    func createURLStringForForecast(lat: Double, lon: Double) -> String? {
        let coordString = "\(lat),\(lon)"
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weatherapi.com"
        components.path = "/v1/forecast.json"
        
        components.queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "q", value: coordString),
            URLQueryItem(name: "days", value: "1")
        ]
        
        return components.url?.absoluteString
    }
    
    func handle<T: Decodable>(_ response: AFDataResponse<Data?>, completion: @escaping (Result<T, FetchError>) -> Void) {
        if let error = response.error?.underlyingError as? URLError, error.code == .notConnectedToInternet {
            return completion(.failure(.networkFailure))
        }
        guard response.error == nil else {
            return completion(.failure(.badResponce))
        }
        guard let data = response.data else {
            return completion(.failure(.invalidData))
        }
        completion(decode(data))
    }
    
    func decode<T: Decodable>(_ data: Data) -> Result<T, FetchError> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let result = try? decoder.decode(T.self, from: data) else {
            return .failure(.decodingFailure)
        }
        return .success(result)
    }
}
