//
//  Storage.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 19.05.2023.
//

import Foundation
import RealmSwift

protocol Storage {
    func fetch(completion: @escaping (Results<ForecastEntity>) -> (Void))
    func add(forecastJson: GeneralForecast)
}
