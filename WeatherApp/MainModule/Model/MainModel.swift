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
    
    func requestForAuthorization(completion: (LocationStatus) -> Void) {
        let status = locationService.getAutorizationStatus()
        
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
