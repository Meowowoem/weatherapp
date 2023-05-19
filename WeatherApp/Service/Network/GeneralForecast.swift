//
//  GeneralForecast.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 19.05.2023.
//

import Foundation

struct City: Decodable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    let localtimeEpoch: Double?
}

struct GeneralForecast: Decodable {
    let location: City
    let current: Current
    let forecast: ForecastRaw
}

struct Current: Decodable {
    let tempC: Double
    let humidity: Int
    let condition: Condition
}

struct ForecastRaw: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let hour: [HourForecast]
}

struct HourForecast: Decodable {
    let timeEpoch: Double
    let tempC: Double
    let humidity: Int
    let condition: Condition
}

struct Condition: Decodable {
    let code: Int
}
