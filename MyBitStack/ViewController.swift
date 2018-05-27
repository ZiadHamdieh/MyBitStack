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
import SVProgressHUD

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let currencies : [String] = ["hello", "world", "CAD"]
    let BITCOIN_URL_ROOT : String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var API_URL : String = ""
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set this class as the delegate for UIPicker
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    // UIPicker
    
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
        print("API_URL is now: \(API_URL)")
        getBitcoinPrice(url: API_URL)
    }
    
    
    
    // Networking
    func getBitcoinPrice(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("bitcoin prices successfully retrieved!")
                let bitcoinJSON : JSON = JSON(response.result.value)
                self.updateBitcoinData(data: bitcoinJSON)
            }
            else {
                print("count not get bitcoin data")
                self.priceLabel.text = "Could Not Fetch Data"
            }
        }
    }

    // parse the JSON for required information
    func updateBitcoinData(data: JSON) {
        print(data)
        // optional binding used here to avoid force unwrapping
        if let priceThisHour = data["open"]["hour"].double {
            updateUI()
        }
        else {
            print("Bitcoin prices currently unavailable")
            priceLabel.text = "Prices Unavailable"
        }
        
    }
    
    func updateUI() {
    }
        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

}

