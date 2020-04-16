//
//  ViewController.swift
//  EggTimer
//
//  Created by Giorgi Shukakidze on 12/7/19.
//  Copyright © 2019 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    let eggTimes = ["Soft" : 300, "Medium" : 420, "Hard" : 720]
    var timer = Timer()
    var player : AVAudioPlayer!
    var secondsPassed = 0
    var timeNeeded = 0
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        let buttonValue = sender.currentTitle!
        timeNeeded = eggTimes[buttonValue]!
        
        progressBar.progress = 0.0
        secondsPassed = 0
        titleLabel.text = buttonValue
                
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }

    @objc func updateTimer() {
        if timeNeeded > secondsPassed {
            secondsPassed += 1
            progressBar.progress = Float(secondsPassed) / Float(timeNeeded)
        } else {
            timer.invalidate()
            playSound()
            titleLabel.text = "Done!"        }
    }
    
}
