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
}

enum WeatherCondition {
    case sunny
    case cloudy
    case windy
    case rainy
    case snowy
}

final class MainModel {
    var forecast = [Forecast]()
    
    func getForecast(completion: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.forecast = [Forecast(cityName: "Moscow", temperature: 30, condition: .sunny, humidity: 55),
                        Forecast(cityName: "Sochi", temperature: 35, condition: .sunny, humidity: 76),
                        Forecast(cityName: "Ufa", temperature: 24, condition: .cloudy, humidity: 61),
                        Forecast(cityName: "Tokyo", temperature: 16, condition: .rainy, humidity: 89)]
            completion()
        }
    }
}
