//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation
import Alamofire

enum FetchError: LocalizedError {
    case responseError, networkError, decodingError, unknownError
}

extension FetchError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .responseError:
            return "Response error"
        case .networkError:
            return "Network error"
        case .decodingError:
            return "Decoding error"
        case .unknownError:
            return "Unknown error"
        }
    }
}

protocol Network {
    func fetchCities(query: String,
                     completion: @escaping (Result<[City], FetchError>) -> (Void))
    func fetchForecast(lat: Double,
                       lon: Double,
                       completion: @escaping (Result<ForecastJson, FetchError>) -> (Void))
}

final class AlamofireService: Network {
    private let key = "42d074f43e4d4b4485793642231705"
    
    func fetchCities(query: String,
                     completion: @escaping (Result<[City], FetchError>) -> (Void)) {
        AF.request(createURLStringForSearch(query))
            .validate()
            .response { [weak self] response in
                guard let self = self else { return }
                if let error = response.error?.underlyingError as? URLError, error.code == .notConnectedToInternet {
                    completion(.failure(.networkError))
                    return
                }
                if let _ = response.error {
                    completion(.failure(.responseError))
                    return
                }
                guard let data = response.data else {
                    completion(.failure(.responseError))
                    return
                }
                completion(self.decode(data))
            }
    }
    
    func fetchForecast(lat: Double,
                       lon: Double,
                       completion: @escaping (Result<ForecastJson, FetchError>) -> (Void)) {
        AF.request(createURLStringForForecast(lat: lat,
                                              lon: lon))
            .validate()
            .response { [weak self] response in
                guard let self = self else { return }
                if let error = response.error?.underlyingError as? URLError, error.code == .notConnectedToInternet {
                    completion(.failure(.networkError))
                    return
                }
                if let _ = response.error {
                    completion(.failure(.responseError))
                    return
                }
                guard let data = response.data else {
                    completion(.failure(.responseError))
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
            URLQueryItem(name: "days", value: "1")
        ]
        
        return components.url?.absoluteString ?? ""
    }
    
    func decode<T: Decodable>(_ data: Data) -> Result<T, FetchError> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let result = try? decoder.decode(T.self, from: data) else {
            return .failure(.decodingError)
        }
        return .success(result)
    }
}
