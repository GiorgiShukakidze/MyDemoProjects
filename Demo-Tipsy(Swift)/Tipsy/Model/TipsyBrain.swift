//
//  TipsyBrain.swift
//  Tipsy
//
//  Created by Giorgi Shukakidze on 12/26/19.
//  Copyright © 2019 Giorgi Shukakidze. All rights reserved.

import UIKit

struct TipsyBrain {
    var tip = 0.1
    var numberOfPeople = 2
    var billTotal: Double?
    var splittedAmount = "0.00"
    
    mutating func calculateTip(enteredAmount: String) {
        tip = Double(enteredAmount)!/100
    }
    mutating func splitBill(billAmount: Double){
        let calculatedAmount = (billAmount * (1 + tip)) / Double(numberOfPeople)
        splittedAmount = String(format: "%.2f", calculatedAmount)
    }
}
