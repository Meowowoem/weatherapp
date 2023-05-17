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
        self.condition = Self.conditionByCode(jsonModel.forecast.forecastday[0].hour[0].condition.code)
        self.humidity = jsonModel.forecast.forecastday[0].hour[0].humidity
    }
    
    private static func conditionByCode(_ code: Int) -> WeatherCondition {
        switch code {
        case 1000:
            return .sunny
        case 1003, 1006:
            return .cloudy
        case 1009:
            return .overcast
        case 1183, 1180, 1186, 1189, 1192, 1195:
            return .rainy
        case 1210, 1214, 1216, 1219, 1222, 1225:
            return .snowy
        default:
            return .undefined
        }
    }
}

enum WeatherCondition {
    case sunny
    case cloudy
    case overcast
    case rainy
    case snowy
    case undefined
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
