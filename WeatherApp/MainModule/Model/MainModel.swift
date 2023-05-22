//
//  MainModel.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation
import RealmSwift

enum LocationStatus {
    case autorized, denied
}

final class MainModel {
    private let networkService: Network
    private let locationService: LocationService
    private let storageService: Storage
    
    init(
        networkService: Network,
        locationService: LocationService,
        storageService: Storage
    ) {
        self.networkService = networkService
        self.locationService = locationService
        self.storageService = storageService
    }
    
    func getForecastForCurrentLocation(completion: @escaping (Result<GeneralForecast, FetchError>) -> Void) {
        guard locationService.unknownLocation == false else { return  completion(.failure(.locationFailed)) }
        locationService.handlerLocation = { [weak self] location in
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            self?.networkService.fetchForecast(lat: lat, lon: lon, completion: completion)
        }
    }
    
    func getForecastForCachedLocation(_ cachedForecasts: [Forecast], completion: @escaping (Result<GeneralForecast, FetchError>) -> Void) {
        for forecast in cachedForecasts {
            networkService.fetchForecast(lat: forecast.lat, lon: forecast.lon, completion: completion)
        }
    }
    
    func getForecastFromCache(completion: @escaping (Results<ForecastEntity>) -> Void) {
        storageService.fetch(completion: completion)
    }
    
    func saveToCache(forecastJson: GeneralForecast) {
        storageService.add(forecastJson: forecastJson)
    }
    
    func requestForAuthorization(completion: @escaping (Result<LocationStatus, FetchError>) -> Void) {
        let status = locationService.getAutorizationStatus()
        locationService.handlerStatus = { status in
            if status == .denied {
                return completion(.success(.denied))
            }
        }
        switch status {
        case .notDetermined:
            locationService.requestForAutorization()
            completion(.success(.autorized))
        case .restricted, .denied:
            completion(.success(.denied))
        case .authorizedWhenInUse, .authorizedAlways:
            completion(.success(.autorized))
        @unknown default:
            completion(.failure(.locationFailed))
        }
    }
}
