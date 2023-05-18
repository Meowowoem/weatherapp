//
//  LocationService.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    
    let locationManager = CLLocationManager()
    
    public var handlerLocation: ((CLLocation) -> ())?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestForAutorization()
    }
    
    public func requestForAutorization() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first,
              let handler = handlerLocation else {
                  return
              }
        handler(location)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            requestForAutorization()
        }
        
    }
}
