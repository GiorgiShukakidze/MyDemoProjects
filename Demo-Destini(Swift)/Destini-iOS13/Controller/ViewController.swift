//
//  ViewController.swift
//  Destini
//
//  Created by Giorgi Shukakidze on 12/12/19.
//  Copyright © 2019 Giorgi Shukakidze. All rights reserved.

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var storyText: UILabel!
    @IBOutlet weak var choiceOne: UIButton!
    @IBOutlet weak var choiceTwo: UIButton!
    
    var storyBrain = StoryBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func choiceMade(_ sender: UIButton) {
        let userAnswer = sender.currentTitle!
        storyBrain.nextStory(userChoice: userAnswer)
        updateUI()
    }
    
    func updateUI(){
        storyText.text = storyBrain.getStoryText()
        choiceOne.setTitle(storyBrain.getAnswersTexts()[0], for: .normal)
        choiceTwo.setTitle(storyBrain.getAnswersTexts()[1], for: .normal)
    }
}

