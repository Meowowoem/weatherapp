//
//  ForecastEntity.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 19.05.2023.
//

import Foundation
import RealmSwift

final class ForecastEntity: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var cityName: String
    @Persisted var countryName: String
    @Persisted var lat: Double
    @Persisted var lon: Double
    @Persisted var unixDates: List<Double>
    @Persisted var temps: List<Double>
    @Persisted var humiditys: List<Int>
    @Persisted var conditionCodes: List<Int>
    
    convenience init(
        cityName: String,
        countryName: String,
        lat: Double,
        lon: Double,
        unixDates: List<Double>,
        temps: List<Double>,
        humiditys: List<Int>,
        conditionCodes: List<Int>
    ) {
        self.init()
        self.cityName = cityName
        self.countryName = countryName
        self.lat = lat
        self.lon = lon
        self.unixDates = unixDates
        self.temps = temps
        self.humiditys = humiditys
        self.conditionCodes = conditionCodes
    }
    
    convenience init (
        cityName: String,
        countryName: String,
        lat: Double,
        lon: Double
    ) {
        self.init()
        self.cityName = cityName
        self.countryName = countryName
        self.lat = lat
        self.lon = lon
    }
}

extension Forecast {
    init(from forecastEntity: ForecastEntity) {
        cityName = forecastEntity.cityName
        lat = forecastEntity.lat
        lon = forecastEntity.lon
        time = forecastEntity.unixDates[Self.calculateIndexFrom(forecastEntity)]
        temperature = Int(forecastEntity.temps[Self.calculateIndexFrom(forecastEntity)])
        condition = Self.conditionByCode(forecastEntity.conditionCodes[Self.calculateIndexFrom(forecastEntity)])
        humidity = forecastEntity.humiditys[Self.calculateIndexFrom(forecastEntity)]
        currentLocation = false
    }
    
    static func calculateIndexFrom(_ forecastEntity: ForecastEntity) -> Int {
        return forecastEntity.unixDates.firstIndex {
            $0 >= Double(Date().timeIntervalSince1970)
        } ?? .zero
    }
}
