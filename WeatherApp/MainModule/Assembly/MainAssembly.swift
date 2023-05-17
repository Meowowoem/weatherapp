//
//  MainAssembly.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import UIKit

struct MainAssembly {
    public func make() -> UIViewController {
        let model = MainModel()
        let vc = MainViewController()
        vc.model = model
        
        return vc
    }
}
