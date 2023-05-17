//
//  SearchAssembly.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import UIKit

struct SearchAssembly {
    public func make() -> UIViewController {
        let model = SearchModel()
        model.networkService = AlamofireService()
        let vc = SearchViewController()
        vc.model = model
        return vc
    }
}
