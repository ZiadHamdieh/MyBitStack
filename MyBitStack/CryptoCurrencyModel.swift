//
//  CryptoCurrencyDataModel.swift
//  MyBitStack
//
//  Created by Ziad Hamdieh on 2018-05-27.
//  Copyright © 2018 Ziad Hamdieh. All rights reserved.
//

struct CryptoCurrencyModel {
    
    // [Price this HOUR, Price TODAY, Price this WEEK]
    var price = [0.00, 0.00, 0.00]
    
    // [Price change this HOUR, Price change TODAY, Price change this WEEK]
    var priceChange = [0.00, 0.00, 0,00]
    
    // [% change this HOUR, % change TODAY, % change this WEEK]
    var percentChange = [0.00, 0.00, 0.00]
    
    var currencySymbol = ""

}

