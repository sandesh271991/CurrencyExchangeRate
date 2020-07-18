//
//  ViewController+PickerView.swift
//  CurrencyExchangeRate
//
//  Created by Sandesh on 18/07/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
import UIKit

extension ViewController :  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let currencyCodes = currencyList[row].currencyCode, let currencyCountrys = currencyList[row].currencyCountry {
            
            return currencyCodes! + "-" + currencyCountrys!
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let currencyCodes = currencyList[row].currencyCode {
            let exchnageRateCode = "USD" + currencyCodes!  // get currency Code
            
            let exchnageRateCodeIndex = exchangeRateList.firstIndex {
                $0.exchangeRateCode == exchnageRateCode
            }
            
            if let exchangeRate = exchangeRateList[exchnageRateCodeIndex ?? 0].exchangeRateValue {
                relativeToDoller  = getRateRelativeToDoller(exchangeRate: exchangeRate, amount: (txtAmount.text! as NSString).doubleValue)
                selectedCurrency = currencyCodes!
                btnSelectedCurrency.setTitle(currencyCodes!, for: .normal)
            }
        }
    }
}

