//
//  DBManager.swift
//  CurrencyConverter
//
//  Created by Omotayo on 19/01/2022.
//

import Foundation
import RealmSwift

final class DBManager {
    
    static let sharedLocalRealm = try! Realm()
    
    static func addRates(rate: Rates) {
        sharedLocalRealm.add(rate)
    }
    
    static func getAllRates() -> Results<Rates> {
        return sharedLocalRealm.objects(Rates.self)
    }
}
