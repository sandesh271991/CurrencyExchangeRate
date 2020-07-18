//
//  Helper.swift
//  CurrencyExchangeRate
//
//  Created by Sandesh on 16/07/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//


import Foundation
import Alamofire

func isConnectedToInternet() -> Bool {
    return NetworkReachabilityManager()!.isReachable
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

