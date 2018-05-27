//
//  ViewController.swift
//  MyBitStack
//
//  Created by Ziad Hamdieh on 2018-04-07.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let currencies : [String] = []
    let BITCOIN_URL : String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let locationManager = CLLocationManager()
    
    // Networking
    func getBitcoinData() {
        
    }
    
    func updateBitcoinData() {
    }
    
    func updateUI() {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

