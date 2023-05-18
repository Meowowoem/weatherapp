//
//  MainModel.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation
import CoreLocation

struct Forecast {
    let cityName: String
    let time: Double
    let temperature: Int
    let condition: WeatherCondition
    let humidity: Int
    
    init(from jsonModel: ForecastJson) {
        self.cityName = jsonModel.location.name
        self.time = jsonModel.location.localtimeEpoch ?? Date().timeIntervalSince1970
        self.temperature = Int(jsonModel.current.tempC)
        self.condition = Self.conditionByCode(jsonModel.current.condition.code)
        self.humidity = jsonModel.current.humidity
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

enum LocationStatus {
    case autorized, denied
}

final class MainModel: NSObject {
    private var networkService: Network
    private var locationService: LocationService
    
    init(networkService: Network,
         locationService: LocationService) {
        self.networkService = networkService
        self.locationService = locationService
    }
    
    func getForecastForCurrentLocation(completion: @escaping (Result<ForecastJson, FetchError>) -> (Void)) {
        locationService.handlerLocation = { location in
            self.networkService.fetchForecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { result in
                completion(result)
            }
        }
        
    }
    
    public func requestForAuthorization(completion: (LocationStatus) -> (Void)) {
        let status = locationService.locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationService.requestForAutorization()
            completion(.autorized)
        case .restricted, .denied:
            completion(.denied)
        case .authorizedWhenInUse, .authorizedAlways:
            completion(.autorized)
        @unknown default:
            completion(.denied)
        }
    }
    
}
