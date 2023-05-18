//
//  DatabaseService.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
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
    
    convenience init(cityName: String,
                     countryName: String,
                     lat: Double,
                     lon: Double,
                     unixDates: List<Double>,
                     temps: List<Double>,
                     humiditys: List<Int>,
                     conditionCodes: List<Int>) {
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
    
    convenience init (cityName: String,
                      countryName: String,
                      lat: Double,
                      lon: Double) {
        self.init()
        self.cityName = cityName
        self.countryName = countryName
        self.lat = lat
        self.lon = lon
    }
}


protocol Storage {
    func fetch(completion: @escaping (Results<ForecastEntity>) -> (Void))
    func add(forecastJson: ForecastJson)
    func delete()
    func update()
}

final class RealmStorage: Storage {
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func fetch(completion: @escaping (Results<ForecastEntity>) -> (Void)) {
        let forecastEntity = realm.objects(ForecastEntity.self)
        completion(forecastEntity)
    }
    
    func add(forecastJson: ForecastJson) {
        let forecast = realm.objects(ForecastEntity.self).where {
            $0.lat == forecastJson.location.lat && $0.lon == forecastJson.location.lon
        }
        if !forecast.isEmpty {
            try! realm.write({
                realm.delete(forecast)
            })
        }
        
        let forecastEntity = createEntity(forecastJson: forecastJson)
        try! realm.write({
            realm.add(forecastEntity)
        })
    }

    func delete() {
        
    }
    
    func update() {
        
    }
    
    private func createEntity(forecastJson: ForecastJson) -> ForecastEntity {
        let entity = ForecastEntity(cityName: forecastJson.location.name, countryName: forecastJson.location.country, lat: forecastJson.location.lat, lon:forecastJson.location.lon)
        
        guard let dayForecast = forecastJson.forecast.forecastday.first else { return entity }
        
        for forecast in dayForecast.hour {
            entity.unixDates.append(forecast.timeEpoch)
            entity.temps.append(forecast.tempC)
            entity.humiditys.append(forecast.humidity)
            entity.conditionCodes.append(forecast.condition.code)
        }
        
        return entity
    }
    
}
