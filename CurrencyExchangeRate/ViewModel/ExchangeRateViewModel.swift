//
//  ExchangeRateViewModel.swift
//  CurrencyExchangeRate
//
//  Created by Sandesh on 16/07/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//


import Foundation
import UIKit

class ExchangeRateViewModel: NSObject {
    var exchangeRateData: ExchangeRateData?
    
    var exchangeRate: [String: Double] {
        return exchangeRateData?.quotes ?? ["": 0]
    }
    
    
    init(exchangeRateData: ExchangeRateData) {
        self.exchangeRateData = exchangeRateData
    }
}

