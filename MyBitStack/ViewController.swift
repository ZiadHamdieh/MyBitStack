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
    
    
    let currencies : [String] = ["hello", "world", "test"]
    let BITCOIN_URL : String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    // Networking
    func getBitcoinData() {
        
    }
    
    func updateBitcoinData() {
    }
    
    func updateUI() {
        priceLabel.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set this class as the delegate for UIPicker
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

