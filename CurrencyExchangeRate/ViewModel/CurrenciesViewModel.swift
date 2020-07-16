//
//  CurrenciesViewModel.swift
//  CurrencyExchangeRate
//
//  Created by Sandesh on 16/07/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//




import Foundation
import UIKit


class CurrenciesViewModel: NSObject {
    var currencyData: CurrencyData?
    
    var currencies: [String: String] {
        return currencyData?.currencies ?? ["":""]
    }
    
    
    init(currencyData: CurrencyData) {
        self.currencyData = currencyData
    }
}
