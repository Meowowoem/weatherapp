//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation

struct CityModel {
    let name: String
    let weather: WeatherModel
}

struct WeatherModel {
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
