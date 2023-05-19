//
//  Location.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 19.05.2023.
//

import Foundation
import CoreLocation

protocol Location {
    func requestForAutorization()
    func getAutorizationStatus() -> CLAuthorizationStatus
}
