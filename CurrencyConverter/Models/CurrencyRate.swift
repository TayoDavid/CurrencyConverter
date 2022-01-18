//
//  CurrencyRate.swift
//  CurrencyConverter
//
//  Created by Omotayo on 18/01/2022.
//

import Foundation
import RealmSwift

struct CurrencyRate {
    let currencyCode: String
    let rate: Double
}

class Rates: Object {
    @Persisted var currencyCode = ""
    @Persisted var rateValue = 0.0
    @Persisted var date = Date()
    @Persisted var isBaseCurrency = false
    
    convenience init(currencyCode: String, rateValue: Double) {
        self.init()
        self.currencyCode = currencyCode
        self.rateValue = rateValue
    }
}
