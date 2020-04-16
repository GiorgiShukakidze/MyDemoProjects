//
//  ViewController.swift
//  Dicee
//
//  Created by Giorgi Shukakidze on 12/04/19.
//  Copyright © 2019 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var totalScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(totalScore)"
        }
    }
    let allDice = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix")]
    
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            scoreLabel.text = "Score: \(totalScore)"
        }
    }
    
    @IBOutlet weak var diceImageView1: UIImageView! {
        didSet {
            diceImageView1.image = allDice[0]
        }
    }
    
    @IBOutlet weak var diceImageView2: UIImageView! {
        didSet {
            diceImageView2.image = allDice[0]
        }
    }
    
    @IBAction func rollButtonPressed(_ sender: UIButton) {
        
        let diceOneRandom = Int.random(in: 0...5)
        let diceTwoRandom = Int.random(in: 0...5)
        
        diceImageView1.image = allDice[diceOneRandom]
        diceImageView2.image = allDice[diceTwoRandom]
        
        totalScore += (diceOneRandom + 1) + (diceTwoRandom + 1)
    }
    
    @IBAction func resetScorePressed(_ sender: UIButton) {
        
        totalScore = 0
    }
    
}

