//
//  ExchangeData.swift
//  CurrencyConverter
//
//  Created by Omotayo on 18/01/2022.
//

import Foundation
import SwiftyJSON

struct ExchangeData {
    let baseCurrency: String
    let currencyRates: [CurrencyRate]
}

