//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Omotayo on 17/01/2022.
//

import UIKit

class CurrencyConverterViewController: UIViewController {

    @IBOutlet weak var hamburgerButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var fromCurrencyView: UIView!
    @IBOutlet weak var targetCurrencyView: UIView!
    
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var targetCurrencyTextField: UITextField!
    
    @IBOutlet weak var fromCurrencySymbolLabel: UILabel!
    @IBOutlet weak var targetCurrencySymbolLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromCurrencyView.layer.cornerRadius = 8
        targetCurrencyView.layer.cornerRadius = 8
    }


}

