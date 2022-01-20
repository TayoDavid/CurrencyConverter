//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Omotayo on 17/01/2022.
//

import UIKit
import iOSDropDown
import Charts

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
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var getAlertLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currenciesList: [String] = []
    var baseCurrency: CurrencyRate?
    var allCurrencyRates: [CurrencyRate] = []
    var lineChartEntries = [ChartDataEntry]()
    
    var fromCurrencyHistory = [CurrencyRate]()
    var targetCurrencyHistory = [CurrencyRate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLatestCurrency()
        prepareDropdowns()
        fromCurrencyTextField.delegate = self
        
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.setLabelCount(5, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .white
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
                    DispatchQueue.main.async { [self] in
                        self.allCurrencyRates = exchangeData.currencyRates
                        let base = exchangeData.baseCurrency
                        let randomPosition = Int.random(in: 1..<self.allCurrencyRates.count)
                        let randomCurrency = self.allCurrencyRates[randomPosition]
                        
                        let baseCurrencyRate = self.allCurrencyRates.first(where: { $0.currencyCode.localizedCaseInsensitiveContains(base) })?.rate
                        self.currenciesList = self.allCurrencyRates.map { " ".flag(country: $0.currencyCode) + " " + $0.currencyCode }
                        
                        self.fromCurrencyDropdown.optionArray = self.currenciesList
                        self.targetCurrencyDropdown.optionArray = self.currenciesList
                        
                        self.fromCurrencyDropdown.text = self.currenciesList.first(where: { $0.localizedCaseInsensitiveContains(base)})
                        self.targetCurrencyDropdown.text = self.currenciesList[randomPosition]
                        
                        self.fromCurrencySymbolLabel.text = base
                        self.targetCurrencySymbolLabel.text = randomCurrency.currencyCode
                        
                        self.fromCurrencyTextField.text = "\(baseCurrencyRate ?? 0)"
                        self.targetCurrencyTextField.text = "\(randomCurrency.rate)"
                        
                        self.setupChartData(self.targetCurrencySymbolLabel.text!)
                        
                        self.fromCurrencyDropdown.didSelect { selectedText, index, id in
                            self.fromCurrencyTextField.text = "\(self.allCurrencyRates[index].rate)"
                            self.fromCurrencySymbolLabel.text = self.allCurrencyRates[index].currencyCode
                        }
                        
                        self.targetCurrencyDropdown.didSelect { selectedText, index, id in
                            self.targetCurrencyTextField.text = "\(self.allCurrencyRates[index].rate)"
                            self.targetCurrencySymbolLabel.text = self.allCurrencyRates[index].currencyCode
                        }
                    
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func setupChartData(_ target: String) {
        let currenciesDataFromDB = DBManager.getAllRates()
        for rate in currenciesDataFromDB {
            if rate.isBaseCurrency == true {
                fromCurrencyHistory.append(.init(currencyCode: rate.currencyCode, rate: rate.rateValue))
            } else if rate.currencyCode == target {
                targetCurrencyHistory.append(.init(currencyCode: rate.currencyCode, rate: rate.rateValue))
            }
        }
        populateChart()
    }
    
    private func populateChart() {
        for i in fromCurrencyHistory.indices {
            let entry = ChartDataEntry(x: fromCurrencyHistory[i].rate, y: targetCurrencyHistory[i].rate)
            lineChartEntries.append(entry)
        }
        let dataSet = LineChartDataSet(entries: lineChartEntries, label: "Currency")
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
    
}

extension CurrencyConverterViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == fromCurrencyTextField && fromCurrencyTextField.text != "" {
            let targetCurrencyCode = targetCurrencySymbolLabel.text
            let fromCurrencyCode = fromCurrencySymbolLabel.text
            guard let targetCurrencyCode = targetCurrencyCode, let fromCurrencyCode = fromCurrencyCode else { return }
            let targetRateToBaseCurrency = (self.allCurrencyRates.first { $0.currencyCode == targetCurrencyCode }?.rate)!
            let fromRateToBaseCurrency = (self.allCurrencyRates.first { $0.currencyCode == fromCurrencyCode }?.rate)!
            
            let valueToConvert = (fromCurrencyTextField.text! as NSString).doubleValue
            let result = (valueToConvert * targetRateToBaseCurrency) / fromRateToBaseCurrency
            self.targetCurrencyTextField.text = "\(result)"
        }
    }
}
