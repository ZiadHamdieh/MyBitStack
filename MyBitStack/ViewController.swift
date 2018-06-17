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
    var chosenCurrency = ""
    var chosenCurrencySymbol = ""
    
    let URL_ROOT = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    var CRYPTO_EXTENSION = "BTC"
    var API_URL = ""
    
    var cryptoCurrencyModel = CryptoCurrencyModel()
    
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var timeFrameSegment: UISegmentedControl!
    @IBOutlet weak var currencyLogo: UIImageView!
    @IBOutlet weak var currencySwitch: UISwitch!
    
    //MARK: - IBActions
    /*****************************************************************/
    
    @IBAction func timeFrameSegmentPressed(_ sender: UISegmentedControl) {
        
        updateUI(selectedTimeFrame: timeFrameSegment.selectedSegmentIndex);
        
    }
    
    @IBAction func currencySwitchPressed(_ sender: UISwitch) {
        
        // ethereum
        if currencySwitch.isOn {
            
            CRYPTO_EXTENSION = "ETH"
            currencyLogo.image = UIImage(named: "ethereum.png")

        }
        // bitcoin
        else {

            CRYPTO_EXTENSION = "BTC"
            currencyLogo.image = UIImage(named: "bitcoin.png")

        }
        
        API_URL = URL_ROOT + CRYPTO_EXTENSION + chosenCurrency
        getCryptoCurrencyPrice(url: API_URL)
        
    }
    
    //MARK: - View Lifecycle
    /*****************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set this class as the delegate for UIPicker
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        chosenCurrency = currencies[0]
        chosenCurrencySymbol = currencySymbols[0]
        API_URL = URL_ROOT + CRYPTO_EXTENSION + chosenCurrency
        
        getCryptoCurrencyPrice(url: API_URL)
        
    }
    
    //MARK: - Networking
    /*****************************************************************/
    
    func getCryptoCurrencyPrice(url: String) {
        
        if API_URL == (URL_ROOT + CRYPTO_EXTENSION) {
            
            priceLabel.text = ""
            
        }
        else {
            
            Alamofire.request(url, method: .get).responseJSON {
                response in
                
                if response.result.isSuccess {
                    
                    let cryptoCurrencyJSON : JSON = JSON(response.result.value!)
                    self.updateCryptoCurrencyData(data: cryptoCurrencyJSON)
                    print("\(cryptoCurrencyJSON)")
                    
                }
                else {
                    
                    print("coult not get cryptocurrency data")
                    self.priceLabel.text = "Fetch Error"
                    
                }
            }
        }
    }

    //MARK: - JSON Parsing
    /*****************************************************************/
    
    func updateCryptoCurrencyData(data: JSON) {
        // optional binding used here to avoid forced unwrapping
        if  let hourPriceResult = data["open"]["hour"].double,
            let weekPriceResult = data["open"]["week"].double,
            let dayPriceResult = data["open"]["day"].double {
            
            cryptoCurrencyModel.price[0] = hourPriceResult.rounded(toPlaces: 2)
            cryptoCurrencyModel.price[1] = dayPriceResult.rounded(toPlaces: 2)
            cryptoCurrencyModel.price[2] = weekPriceResult.rounded(toPlaces: 2)
            
            cryptoCurrencyModel.priceChange[0] = abs(data["changes"]["price"]["hour"].doubleValue).rounded(toPlaces: 2)
            cryptoCurrencyModel.priceChange[1] = abs(data["changes"]["price"]["day"].doubleValue).rounded(toPlaces: 2)
            cryptoCurrencyModel.priceChange[2] = abs(data["changes"]["price"]["week"].doubleValue).rounded(toPlaces: 2)
            
            cryptoCurrencyModel.percentChange[0] = data["changes"]["percent"]["hour"].doubleValue.rounded(toPlaces: 2)
            cryptoCurrencyModel.percentChange[1] = data["changes"]["percent"]["day"].doubleValue.rounded(toPlaces: 2)
            cryptoCurrencyModel.percentChange[2] = data["changes"]["percent"]["week"].doubleValue.rounded(toPlaces: 2)
            
            cryptoCurrencyModel.currencySymbol = chosenCurrencySymbol
            
            updateUI(selectedTimeFrame: timeFrameSegment.selectedSegmentIndex)
            
        }
        else {
            
            print("cryptocurrency prices currently unavailable")
            priceLabel.text = "Unavailable"
            
        }
    }
    
    //MARK: - UI Update
    /*****************************************************************/
    
    func updateUI(selectedTimeFrame: Int) {
        
        // if crypto currency prices have fallen since last time period, display in red
        if cryptoCurrencyModel.percentChange[selectedTimeFrame] < 0 {
            
            priceLabel.textColor = .red
            priceChangeLabel.textColor = .red
            priceChangeLabel.text = "-\(cryptoCurrencyModel.currencySymbol)" +
                                    "\(cryptoCurrencyModel.priceChange[selectedTimeFrame]) " +
                                    "(\(cryptoCurrencyModel.percentChange[selectedTimeFrame])%)"
            
        }
        // else display value in green
        else if cryptoCurrencyModel.percentChange[selectedTimeFrame] > 0 {
            
            priceLabel.textColor = .green
            priceChangeLabel.textColor = .green
            priceChangeLabel.text = "+\(cryptoCurrencyModel.currencySymbol)" +
                                    "\(cryptoCurrencyModel.priceChange[selectedTimeFrame]) " +
                                    "(+\(cryptoCurrencyModel.percentChange[selectedTimeFrame])%)"
            
        }
        
        priceLabel.text = "\(cryptoCurrencyModel.currencySymbol)" +
                          "\(cryptoCurrencyModel.price[selectedTimeFrame])"
        
    }
    
}

//MARK: - Extensions
/*****************************************************************/

extension ViewController: UIPickerViewDataSource {
    
    // returns the number of columns in the UIPicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    // number of rows in the UIPicker is equal to the number of elements in the
    // currency array
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return currencies.count
        
    }
    
}

extension ViewController: UIPickerViewDelegate {
    
    // place each element in the currency array into its respective row within the UIPicker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return currencies[row]
        
    }
    
    // print the currency in the row currently selected within the UIPicker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        chosenCurrency = currencies[row]
        API_URL = URL_ROOT + CRYPTO_EXTENSION + chosenCurrency
        chosenCurrencySymbol = currencySymbols[row]
        getCryptoCurrencyPrice(url: API_URL)
        
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

extension Double {
    
    /// Rounds a double to selected # of decimal places
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
        
    }
    
}





