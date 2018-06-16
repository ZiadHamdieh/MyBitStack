//
//  ViewController.swift
//  MyBitStack
//
//  Created by Ziad Hamdieh on 2018-04-07.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let currencies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","ILS","INR","JPY","MXN","NOK","NZD","PLN","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "₪", "₹", "¥", "$", "kr", "$", "zł", "₽", "kr", "$", "$", "R"]
    let BITCOIN_URL_ROOT = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var API_URL = ""
    var chosenCurrency = ""
    
    
    @IBOutlet weak var percentageChangeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var timeFrameSegment: UISegmentedControl!
    
    
    @IBAction func timeFrameSegmentPressed(_ sender: UISegmentedControl) {
        
        switch timeFrameSegment.selectedSegmentIndex {
        case 0:
            
            priceLabel.text = "\(bitcoinDataModel.currencySymbol)\(bitcoinDataModel.priceThisHour)"
            break
            
        case 1:
            
            priceLabel.text = "\(bitcoinDataModel.currencySymbol)\(bitcoinDataModel.priceToday)"
            break
            
        case 2:
            priceLabel.text = "\(bitcoinDataModel.currencySymbol)\(bitcoinDataModel.priceThisWeek)"
            break
            
        default:
            
            print("error. Selected segment index is out of bounds")
            break
            
        }
    }
    
    
    
    let bitcoinDataModel = BitcoinDataModel()
    
    //MARK: - View Lifecycle
    /*****************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set this class as the delegate for UIPicker
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }
    
    //MARK: - Networking
    /*****************************************************************/
    
    func getBitcoinPrice(url: String) {
        
        if API_URL == BITCOIN_URL_ROOT {
            
            priceLabel.text = ""
            
        }
        else {
            
            Alamofire.request(url, method: .get).responseJSON {
                response in
                
                if response.result.isSuccess {
                    
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    self.updateBitcoinData(data: bitcoinJSON)
                    print("\(bitcoinJSON)")
                    
                }
                else {
                    
                    print("coult not get bitcoin data")
                    self.priceLabel.text = "Fetch Error"
                    
                }
            }
        }
    }

    //MARK: - JSON Parsing
    /*****************************************************************/
    
    func updateBitcoinData(data: JSON) {
        // optional binding used here to avoid forced unwrapping
        if let hourPriceResult = data["open"]["hour"].double, let weekPriceResult = data["open"]["week"].double,
            let dayPriceResult = data["open"]["day"].double {
            
            bitcoinDataModel.priceThisHour = hourPriceResult
            bitcoinDataModel.priceToday = dayPriceResult
            bitcoinDataModel.priceThisWeek = weekPriceResult
            
            bitcoinDataModel.hourPercentChange = data["changes"]["percent"]["hour"].doubleValue
            bitcoinDataModel.dayPercentChange = data["changes"]["percent"]["day"].doubleValue
            bitcoinDataModel.weekPercentChange = data["changes"]["percent"]["week"].doubleValue
            
            bitcoinDataModel.currencySymbol = chosenCurrency
            
            updateUI(selectedSegment: timeFrameSegment.selectedSegmentIndex)
        }
        else {
            
            print("Bitcoin prices currently unavailable")
            priceLabel.text = "Unavailable"
            
        }
    }
    
    //MARK: - UI Update
    /*****************************************************************/
    
    
    func updateUI(selectedSegment: Int) {
        
        // if bitcoin prices have fallen since last time period, display in red
        if bitcoinDataModel.percentChange[selectedSegment] < 0 {
            
            priceLabel.textColor = .red
            percentageChangeLabel.textColor = .red
            percentageChangeLabel.text = "-\(bitcoinDataModel.percentChange[selectedSegment])%"
            
        }
        // else display value in green
        else if bitcoinDataModel.percentChange > 0 {
            
            priceLabel.textColor = .green
            percentageChangeLabel.textColor = .green
            percentageChangeLabel.text = "+\(bitcoinDataModel.percentChange[selectedSegment)%"
            
        }
        
        
        priceLabel.text = "\(bitcoinDataModel.currencySymbol)\(bitcoinDataModel.price[selectedSegment])"
        
    }
    
}

//MARK: - Protocol Delegates
/*****************************************************************/

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // returns the number of columns in the UIPicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    // number of rows in the UIPicker is equal to the number of elements in the
    // currency array
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return currencies.count
        
    }
    
    // place each element in the currency array into its respective row within the UIPicker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return currencies[row]
        
    }
    
    // print the currency in the row currently selected within the UIPicker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        API_URL = BITCOIN_URL_ROOT + currencies[row]
        chosenCurrency = currencySymbols[row]
        getBitcoinPrice(url: API_URL)
        
    }
    
    // change color of each row to white
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label : UILabel
        
        if let view = view as? UILabel {
            
            label = view
            
        }
        else {
            
            label = UILabel()
            
        }
        
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 22)
        label.text = currencies[row]
        
        return label
        
    }
    
}
