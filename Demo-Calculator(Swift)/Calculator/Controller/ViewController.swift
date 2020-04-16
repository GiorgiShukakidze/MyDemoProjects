//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Giorgi Shukakidze on 3/18/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var calculator = CalculatorBrain()
    private var didFinishEditing = true
    private var numericValue: Double {
        get {
            guard let numValue = Double(displayLabel.text!) else {
                fatalError("Can not convert label value to Double")
            }
            return numValue
        }
        set {
            displayLabel.text = floor(newValue) == newValue ? String(newValue).replacingOccurrences(of: ".0", with: "") : String(newValue)
        }
    }
    
    override func viewDidLoad() {
        deleteButton.isHidden = true
        displayLabel.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text"{
            if calculator.isClear {
                deleteButton.isHidden = true
                clearButton.isHidden = false
            } else {
                deleteButton.isHidden = false
                clearButton.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
        
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        calculator.setNumber(numericValue)
        if let operation = sender.currentTitle, let result = calculator.calculate(with: operation) {
            numericValue = result
        }
        didFinishEditing = true
    }
    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        calculator.isClear = false
        if let numValue = sender.currentTitle {
            if didFinishEditing {
                displayLabel.text! = numValue
                didFinishEditing = false
            } else {
                if numValue == "." && displayLabel.text!.contains("."){
                    return
                } else {
                    displayLabel.text! += numValue
                }
            }
        }
    }
}
