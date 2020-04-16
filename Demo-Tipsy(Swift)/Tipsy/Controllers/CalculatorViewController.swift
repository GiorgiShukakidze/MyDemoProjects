//
//  ViewController.swift
//  Tipsy
//
//  Created by Giorgi Shukakidze on 12/26/19.
//  Copyright © 2019 Giorgi Shukakidze. All rights reserved.

import UIKit

class CalculatorViewController: UIViewController {
    var tipsyBrain = TipsyBrain()
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    @IBAction func tipChanged(_ sender: UIButton) {
        billTextField.endEditing(true)
        zeroPctButton.isSelected = false
        tenPctButton.isSelected = false
        twentyPctButton.isSelected = false
        sender.isSelected = true
        let selectedTip = String(sender.currentTitle!).dropLast()
        tipsyBrain.calculateTip(enteredAmount: String(selectedTip))
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        billTextField.endEditing(true)
        splitNumberLabel.text = String(format: "%.0f", sender.value)
        tipsyBrain.numberOfPeople = Int(sender.value)
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        if billTextField.text == "" {
            noAmountAlert()
        } else {
            let billAmount = Double(billTextField.text!)!
            tipsyBrain.splitBill(billAmount: billAmount)
            performSegue(withIdentifier: "goToResults", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            let resultsVC = segue.destination as! ResultsViewController
            resultsVC.calculatedTotal = tipsyBrain.splittedAmount
            let tipText = String(format: "%.0f", tipsyBrain.tip * 100)
            if tipsyBrain.numberOfPeople > 2 {
                resultsVC.resultText = "Split among \(tipsyBrain.numberOfPeople) people, with \(tipText)% tip."
            } else {
                resultsVC.resultText = "Split between \(tipsyBrain.numberOfPeople) people, with \(tipText)% tip."
            }
        }
    }
    
    func noAmountAlert(){
        let alert = UIAlertController(title: "", message: "Please, enter total amount of bill!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

