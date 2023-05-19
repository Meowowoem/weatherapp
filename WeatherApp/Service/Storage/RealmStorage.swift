//
//  RealmStorage.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation
import RealmSwift

final class RealmStorage: Storage {
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func fetch(completion: @escaping (Results<ForecastEntity>) -> (Void)) {
        let forecastEntity = realm.objects(ForecastEntity.self)
        completion(forecastEntity)
    }
    
    func add(forecastJson: GeneralForecast) {
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
    
    private func createEntity(forecastJson: GeneralForecast) -> ForecastEntity {
        let entity = ForecastEntity(
            cityName: forecastJson.location.name,
            countryName: forecastJson.location.country,
            lat: forecastJson.location.lat,
            lon:forecastJson.location.lon
        )
        
        guard let dayForecast = forecastJson.forecast.forecastday.first else {
            return entity
        }
        
        for forecast in dayForecast.hour {
            entity.unixDates.append(forecast.timeEpoch)
            entity.temps.append(forecast.tempC)
            entity.humiditys.append(forecast.humidity)
            entity.conditionCodes.append(forecast.condition.code)
        }
        
        return entity
    }
}
