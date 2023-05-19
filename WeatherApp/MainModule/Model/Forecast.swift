//
//  Forecast.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 19.05.2023.
//

import Foundation

struct Forecast {
    let cityName: String
    let lat: Double
    let lon: Double
    let time: Double
    let temperature: Int
    let condition: WeatherCondition
    let humidity: Int
    let currentLocation: Bool
    
    init(from jsonModel: GeneralForecast, currentLocation: Bool) {
        cityName = jsonModel.location.name
        lat = jsonModel.location.lat
        lon = jsonModel.location.lon
        time = jsonModel.location.localtimeEpoch ?? Double(Date().timeIntervalSince1970)
        temperature = Int(jsonModel.current.tempC)
        condition = Self.conditionByCode(jsonModel.current.condition.code)
        humidity = jsonModel.current.humidity
        self.currentLocation = currentLocation
    }

    static func conditionByCode(_ code: Int) -> WeatherCondition {
        switch code {
        case 1000:
            return .sunny
        case 1003, 1006:
            return .cloudy
        case 1009:
            return .overcast
        case 1063, 1150, 1153, 1168, 1171, 1183, 1180, 1186, 1189, 1192, 1195:
            return .rainy
        case 1210, 1214, 1216, 1219, 1222, 1225:
            return .snowy
        default:
            return .undefined
        }
    }
}

enum WeatherCondition: String {
    case sunny, cloudy, overcast, rainy, snowy, undefined
}
