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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        fromCurrencyDropdown.optionArray = ["John", "James", "Jane", "Jones"]
        targetCurrencyDropdown.optionArray = ["USD", "EURO", "PLN", "NGN"]
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
    
}

