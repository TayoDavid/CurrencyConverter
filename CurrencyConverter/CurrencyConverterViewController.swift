//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Omotayo on 17/01/2022.
//

import UIKit
import DropDown

class CurrencyConverterViewController: UIViewController {

    @IBOutlet weak var hamburgerButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var fromCurrencyView: UIView!
    @IBOutlet weak var targetCurrencyView: UIView!
    
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var targetCurrencyTextField: UITextField!
    
    @IBOutlet weak var fromCurrencySymbolLabel: UILabel!
    @IBOutlet weak var targetCurrencySymbolLabel: UILabel!
    
    @IBOutlet weak var fromCurrencyDropdownView: UIView!
    @IBOutlet weak var targetCurrencyDropdownView: UIView!
    
    @IBOutlet weak var fromCurrencyLogoImgView: UIImageView!
    @IBOutlet weak var selectedFromCurrencyLabel: UILabel!
    
    @IBOutlet weak var targetCurrencyLogoImgView: UIImageView!
    @IBOutlet weak var selectedTargetCurrencyLabel: UILabel!
    
    @IBOutlet weak var convertButton: UIButton!
    let fromCurrencyDropdown = DropDown()
    let targetCurrencyDropdown = DropDown()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromCurrencyView.layer.cornerRadius = 8
        targetCurrencyView.layer.cornerRadius = 8
    
        fromCurrencyDropdown.anchorView = fromCurrencyDropdownView
        targetCurrencyDropdown.anchorView = targetCurrencyDropdownView
    
        fromCurrencyDropdown.dataSource = ["USD", "EURO", "PLN"]
        targetCurrencyDropdown.dataSource = ["USD", "EURO", "PLN"]
        
        fromCurrencyDropdown.bottomOffset = CGPoint(x: 0, y: (fromCurrencyDropdown.anchorView?.plainView.bounds.height)!)
        fromCurrencyDropdown.topOffset = CGPoint(x: 0, y:-((fromCurrencyDropdown.anchorView?.plainView.bounds.height)!))
        fromCurrencyDropdown.direction = .bottom

        targetCurrencyDropdown.bottomOffset = CGPoint(x: 0, y:(targetCurrencyDropdown.anchorView?.plainView.bounds.height)!)
        targetCurrencyDropdown.topOffset = CGPoint(x: 0, y:-(targetCurrencyDropdown.anchorView?.plainView.bounds.height)!)
        targetCurrencyDropdown.direction = .bottom
        
        
        fromCurrencyDropdownView.isUserInteractionEnabled = true
        
        fromCurrencyDropdownView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTapFromCurrencyDropdown)))
        
        targetCurrencyDropdownView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTapTargetCurrencyDropdown)))
        
    }

    @IBAction func didTapConvertButton(_ sender: UIButton) {
        
    }
        
    @objc func didTapFromCurrencyDropdown() {
        fromCurrencyDropdown.show(onTopOf: nil, beforeTransform: nil, anchorPoint: nil)
    }
    
    @objc func didTapTargetCurrencyDropdown() {
        targetCurrencyDropdown.show()
    }
    
}

