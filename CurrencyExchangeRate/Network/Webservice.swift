//
//  Webservice.swift
//  CurrencyExchangeRate
//
//  Created by Sandesh on 16/07/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
import Alamofire

class Webservice: NSObject {
    
    static let shared = Webservice()
    
    func getCurreniesData(with url: String, completion:@escaping (_ data: CurrencyData?, _ error: Error?) -> Void) {
        
        AF.request(url).responseData { (responseData) in
            switch responseData.result {
            case .success(let data):
                
                //Apply string encoding as response is not UTF 8 formatted
                let string = String(decoding: data, as: UTF8.self)
                
                if let datastr = string.data(using: String.Encoding.utf8) {
                    do {
                        let currencyData = try JSONDecoder().decode(CurrencyData.self, from: datastr)
                        completion(currencyData, nil)
                        print(currencyData)
                        
                    } catch let error as NSError {
                        print(error)
                        completion(nil, error)
                    }
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    
    func getExchangeRateData(with url: String, completion:@escaping (_ data: ExchangeRateData?, _ error: Error?) -> Void) {
        
        AF.request(url).responseData { (responseData) in
            switch responseData.result {
            case .success(let data):
                
                let string = String(decoding: data, as: UTF8.self)
                
                if let datastr = string.data(using: String.Encoding.utf8) {
                    do {
                        let exchangeRateData = try JSONDecoder().decode(ExchangeRateData.self, from: datastr)
                        completion(exchangeRateData, nil)
                        print("sardar \(exchangeRateData)")
                        
                    } catch let error as NSError {
                        print(error)
                        completion(nil, error)
                    }
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

