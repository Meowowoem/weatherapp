//
//  LocationService.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation
import CoreLocation

final class LocationService: NSObject,
                             Location {
    private let locationManager = CLLocationManager()
    var handlerLocation: ((CLLocation) -> ())?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestForAutorization()
    }
    
    func requestForAutorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getAutorizationStatus() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first,
              let handler = handlerLocation else { return }
        handler(location)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .notDetermined else { return }
        requestForAutorization()
    }
}
