//
//  UIViewController+Extension.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 19.05.2023.
//

import UIKit

extension UIViewController {
    func showAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController (title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
