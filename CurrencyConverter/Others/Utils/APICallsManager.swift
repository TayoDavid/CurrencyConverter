//
//  APICallsManager.swift
//  CurrencyConverter
//
//  Created by Omotayo on 18/01/2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

final class APICallsManager {
    
    static let shared = APICallsManager()
    let localRealm = DBManager.sharedLocalRealm
    var currencyRates: [CurrencyRate] = []
    
    private struct Constants {
        static let accessKey = "a40287ce6c377c00ec78b1b3e49fb960"
        static let baseUrl = "http://data.fixer.io/api/"
    }
    
    private enum Endpoint: String {
        case latest
        case convert
        case fluctuation
    }
    
    public func latest(completion: @escaping (Result<ExchangeData, Error>) -> Void) {
        let urlString = Constants.baseUrl + Endpoint.latest.rawValue
        let params = ["access_key": Constants.accessKey]
        AF.request(urlString, parameters: params)
            .validate()
            .responseJSON { response in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        let baseCurrency = json["base"].stringValue
                        let rates: Dictionary<String, JSON> = json["rates"].dictionaryValue
                        try! self.localRealm.write({
                            for rate in rates {
                                self.currencyRates.append(.init(currencyCode: rate.key, rate: rate.value.doubleValue))
                                let rateRecord = Rates()
                                rateRecord.currencyCode = rate.key
                                rateRecord.rateValue = rate.value.doubleValue
                                if rate.key == baseCurrency {
                                    rateRecord.isBaseCurrency = true
                                }
                                self.localRealm.add(rateRecord)
                            }
                            
                        })
                
                        completion(.success(ExchangeData(baseCurrency: baseCurrency, currencyRates: self.currencyRates)))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    
    }
    
    public func convert(from: String, to: String, amount: String) {
        let params = ["from": from, "to": to, "amount": amount]
        print(params)
    }
    
}
