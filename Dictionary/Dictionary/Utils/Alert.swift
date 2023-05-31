//
//  Alert.swift
//  Dictionary
//
//  Created by STARK on 29.05.2023.
//


import UIKit

final class Alert {
    static func showAlert(alertTitle: String,
                          alertMessage: String,
                          defaultTitle: String,
                          viewController: UIViewController) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultButton = UIAlertAction(title: defaultTitle, style: .default)
        alert.addAction(defaultButton)
        viewController.present(alert, animated: true,completion: nil)
        
    }
}
