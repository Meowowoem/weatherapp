//
//  MainViewModel.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 16.05.2023.
//

import Foundation

final class MainViewModel {
    var forecast = [ForecastModel]()
    
    
    func getForecast(completion: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.forecast = [ForecastModel(cityName: "Moscow", temperature: 30, condition: .sunny, humidity: 55),
                        ForecastModel(cityName: "Sochi", temperature: 35, condition: .sunny, humidity: 76),
                        ForecastModel(cityName: "Ufa", temperature: 24, condition: .cloudy, humidity: 61),
                        ForecastModel(cityName: "Tokyo", temperature: 16, condition: .rainy, humidity: 89)]
            completion()
        }
    }
}
