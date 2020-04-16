//
//  ResultViewController.swift
//  BMI Calculator
//
//  Created by Giorgi Shukakidze on 12/16/19.
//  Copyright © 2019 Giorgi Shukakidze. All rights reserved.

import UIKit

class ResultViewController: UIViewController {
    var bmiValue: String?
    var advice: String?
    var color: UIColor?
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bmiLabel.text = bmiValue
        adviceLabel.text = advice
        view.backgroundColor = color
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
