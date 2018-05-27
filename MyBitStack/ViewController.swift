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
    
    let currencies : [String] = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbols : [String] = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    let BITCOIN_URL_ROOT : String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var API_URL : String = ""
    var currentCurrency : String = ""
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let bitcoinDataModel = BitcoinDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set this class as the delegate for UIPicker
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    // Networking
    func getBitcoinPrice(url: String) {
        if API_URL == BITCOIN_URL_ROOT {
            priceLabel.text = ""
        }
        else {
            Alamofire.request(url, method: .get).responseJSON {
                response in
                if response.result.isSuccess {
                    print("bitcoin prices successfully retrieved!")
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    self.updateBitcoinData(data: bitcoinJSON)
                }
                else {
                    print("coult not get bitcoin data")
                    self.priceLabel.text = "Fetch Error"
                }
            }
        }
    }

    // parse the JSON for desired information
    func updateBitcoinData(data: JSON) {
        print(data)
        // optional binding used here to avoid force unwrapping
        if let hourPriceResult : Double = data["open"]["hour"].double {
            bitcoinDataModel.priceThisHour = hourPriceResult
            bitcoinDataModel.percentChangeThisHour = data["changes"]["percent"]["hour"].doubleValue
            bitcoinDataModel.currencySymbol = currentCurrency
            updateUI()
        }
        else {
            print("Bitcoin prices currently unavailable")
            priceLabel.text = "Unavailable"
        }
    }
    
    func updateUI() {
        
        priceLabel.text = "\(bitcoinDataModel.currencySymbol)\(bitcoinDataModel.priceThisHour)"
        print("price change since last hour : \(bitcoinDataModel.percentChangeThisHour)")
        // if bitcoin prices have fallen since last hour, display in red
        if bitcoinDataModel.percentChangeThisHour < 0 {
            priceLabel.textColor = UIColor.red
        }
        // else display value in green
        else if bitcoinDataModel.percentChangeThisHour > 0{
            priceLabel.textColor = UIColor.green
        }
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // number of columns in the UIPicker
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
    
    // prints the currency in the row currently selected within the UIPicker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        API_URL = BITCOIN_URL_ROOT + currencies[row]
        currentCurrency = currencySymbols[row]
        print("API_URL is now: \(API_URL)")
        getBitcoinPrice(url: API_URL)
    }
    
}
