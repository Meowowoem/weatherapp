//
//  MainModel.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation

struct Forecast {
    let cityName: String
    let temperature: Int
    let condition: WeatherCondition
    let humidity: Int
    
    init(from jsonModel: ForecastJson) {
        self.cityName = jsonModel.location.name
        self.temperature = Int(jsonModel.forecast.forecastday[0].hour[0].tempC)
        self.condition = .cloudy
        self.humidity = jsonModel.forecast.forecastday[0].hour[0].humidity
    }
}

enum WeatherCondition {
    case sunny
    case cloudy
    case windy
    case rainy
    case snowy
}

final class MainModel {
    public var networkService: Network
    
    init(networkService: Network) {
        self.networkService = networkService
    }
    
    func getForecastForCurrentLocation(completion: @escaping (Result<ForecastJson, Error>) -> (Void)) {
        networkService.fetchForecast(lat: 0, lon: 0) { result in
            completion(result)
        }
    }
}
