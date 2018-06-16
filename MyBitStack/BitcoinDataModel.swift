//
//  BitcoinDataModel.swift
//  MyBitStack
//
//  Created by Ziad Hamdieh on 2018-05-27.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

import UIKit

class BitcoinDataModel {
    
    // [Price this hour, Price Today, Price this week ]
    var price : [Double] = [0.00, 0.00, 0.00]
    
    // [% change this hour, % change today, % change this week]
    var percentChange : [Double] = [0.00, 0.00, 0.00]
    
    var currencySymbol = ""

}

