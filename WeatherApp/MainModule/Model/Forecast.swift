//
//  Forecast.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 19.05.2023.
//

import Foundation

struct Forecast {
    let cityName: String
    let time: Double
    let temperature: Int
    let condition: WeatherCondition
    let humidity: Int
    
    init(from jsonModel: GeneralForecast) {
        cityName = jsonModel.location.name
        time = jsonModel.location.localtimeEpoch ?? Double(Date().timeIntervalSince1970)
        temperature = Int(jsonModel.current.tempC)
        condition = Self.conditionByCode(jsonModel.current.condition.code)
        humidity = jsonModel.current.humidity
    }

    static func conditionByCode(_ code: Int) -> WeatherCondition {
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

enum WeatherCondition: String {
    case sunny, cloudy, overcast, rainy, snowy, undefined
}
