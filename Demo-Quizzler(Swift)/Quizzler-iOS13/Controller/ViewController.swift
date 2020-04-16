//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Giorgi Shukakidze on 12/8/19.
//  Copyright © 2019 Giorgi Shukakidze. All rights reserved.

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var answerOne: UIButton!
    @IBOutlet weak var answerTwo: UIButton!
    @IBOutlet weak var answerThree: UIButton!
    
    var quizBrain = QuizBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        let userAnswer = sender.currentTitle!
        let userGotItRight = quizBrain.checkAnswer(userAnswer)
        
        if userGotItRight {
            sender.backgroundColor = UIColor.green
        } else {
            sender.backgroundColor = UIColor.red
        }
        
        quizBrain.nextQuestion()
                
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
        
    @objc func updateUI() {
        let answers = quizBrain.getAnswersText()
        print(answers)
        questionLabel.text = quizBrain.getQuestionText()
        progressBar.progress = quizBrain.getProgress()
        scoreLabel.text = "Score: \(quizBrain.getScore())"
        answerOne.setTitle(answers[0], for: .normal)
        answerTwo.setTitle(answers[1], for: .normal)
        answerThree.setTitle(answers[2], for: .normal)
        answerOne.backgroundColor = UIColor.clear
        answerTwo.backgroundColor = UIColor.clear
        answerThree.backgroundColor = UIColor.clear
    }

}

