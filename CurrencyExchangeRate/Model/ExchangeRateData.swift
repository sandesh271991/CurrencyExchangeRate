//
//  ExchangeRate.swift
//  CurrencyExchangeRate
//
//  Created by Sandesh on 16/07/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation

// MARK: - Currencies
struct ExchangeRateData: Codable {
    let success: Bool
    let terms, privacy: String
    let timestamp: Int
    let source: String
    let quotes: [String: Double]
}

