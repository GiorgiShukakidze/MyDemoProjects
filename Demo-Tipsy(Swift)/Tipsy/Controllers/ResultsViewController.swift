//
//  ResultsViewController.swift
//  Tipsy
//
//  Created by Giorgi Shukakidze on 12/26/19.
//  Copyright © 2019 Giorgi Shukakidze. All rights reserved.

import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    var calculatedTotal = "0.00"
    var resultText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = calculatedTotal
        settingsLabel.text = resultText
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
