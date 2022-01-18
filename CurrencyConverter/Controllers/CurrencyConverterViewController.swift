//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Omotayo on 17/01/2022.
//

import UIKit
import iOSDropDown

class CurrencyConverterViewController: UIViewController {

    @IBOutlet weak var hamburgerButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var fromCurrencyView: UIView!
    @IBOutlet weak var targetCurrencyView: UIView!
    
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var targetCurrencyTextField: UITextField!
    
    @IBOutlet weak var fromCurrencySymbolLabel: UILabel!
    @IBOutlet weak var targetCurrencySymbolLabel: UILabel!
    
    @IBOutlet weak var fromCurrencyDropdown: DropDown!
    @IBOutlet weak var targetCurrencyDropdown: DropDown!
    
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var convertButton: UIButton!
    
    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var lastThirtyDaysButton: UIButton!
    @IBOutlet weak var lastThirtyDaysActiveIndicator: UIView!
    
    @IBOutlet weak var lastNinetyDaysButton: UIButton!
    @IBOutlet weak var lastNinetyDaysActiveIndicator: UIView!
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var getAlertLabel: UILabel!
    
    var currenciesList: [String] = []
    var baseCurrency: CurrencyRate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLatestCurrency()
        prepareDropdowns()
    }

    @IBAction func didTapConvertButton(_ sender: UIButton) {
        
    }
    
    override func viewWillLayoutSubviews() {
        fromCurrencyView.layer.cornerRadius = 8
        targetCurrencyView.layer.cornerRadius = 8
        convertButton.layer.cornerRadius = 8
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Mid-market exchange rate at 13:38 UTC", attributes: underlineAttribute)
        linkLabel.attributedText = underlineAttributedString
        
        let alertUnderlineAttributedString = NSAttributedString(string: "Get rate alerts straight to your email inbox", attributes: underlineAttribute)
        getAlertLabel.attributedText = alertUnderlineAttributedString
        
        lastNinetyDaysActiveIndicator.layer.cornerRadius = lastNinetyDaysActiveIndicator.frame.size.width / 2
        lastThirtyDaysActiveIndicator.layer.cornerRadius = lastThirtyDaysActiveIndicator.frame.size.width / 2
        
        chartContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 24)
    }
    
    private func prepareDropdowns() {
        fromCurrencyDropdown.arrowSize = 12
        fromCurrencyDropdown.arrowColor = .systemGray4
        targetCurrencyDropdown.arrowSize = 12
        targetCurrencyDropdown.arrowColor = .systemGray4
    }
    
    
    @IBAction func didTapButton(_ sender: UIButton) {
        if sender == lastThirtyDaysButton {
            lastThirtyDaysButton.setTitleColor(.white, for: .normal)
            lastThirtyDaysActiveIndicator.isHidden = false
            
            lastNinetyDaysButton.setTitleColor(.systemGray3, for: .normal)
            lastNinetyDaysActiveIndicator.isHidden = true
        } else if sender == lastNinetyDaysButton {
            lastNinetyDaysButton.setTitleColor(.white, for: .normal)
            lastNinetyDaysActiveIndicator.isHidden = false
            
            lastThirtyDaysButton.setTitleColor(.systemGray3, for: .normal)
            lastThirtyDaysActiveIndicator.isHidden = true
        }
    }
    
    private func fetchLatestCurrency() {
        APICallsManager.shared.latest { result in
            switch result {
                case .success(let exchangeData):
                    DispatchQueue.main.async {
                        
                        let base = exchangeData.baseCurrency
                        let baseCurrencyRate = exchangeData.currencyRates.first(where: { $0.currencyCode.localizedCaseInsensitiveContains(base) })?.rate
                        self.currenciesList = exchangeData.currencyRates.map { " ".flag(country: $0.currencyCode) + " " + $0.currencyCode }
                        self.fromCurrencyDropdown.optionArray = self.currenciesList
                        self.targetCurrencyDropdown.optionArray = self.currenciesList
                        
                        self.fromCurrencyDropdown.text = self.currenciesList.first(where: { $0.localizedCaseInsensitiveContains(base)})
                        
                        self.fromCurrencySymbolLabel.text = base
                        self.fromCurrencyTextField.text = "\(baseCurrencyRate ?? 0)"
                        
                        let randomPosition = Int.random(in: 1..<self.currenciesList.count)
                        let randomCurrency = exchangeData.currencyRates[randomPosition]
                        self.targetCurrencySymbolLabel.text = randomCurrency.currencyCode
                        self.targetCurrencyDropdown.text = self.currenciesList[randomPosition]
                        self.targetCurrencyTextField.text = "\(randomCurrency.rate)"
                        
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
}

