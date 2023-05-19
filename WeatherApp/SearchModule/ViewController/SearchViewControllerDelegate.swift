//
//  SearchViewControllerDelegate.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 19.05.2023.
//

import Foundation

protocol SearchViewControllerDelegate: AnyObject {
    func addForecast(_ sender: SearchViewController, forecast: GeneralForecast)
}
