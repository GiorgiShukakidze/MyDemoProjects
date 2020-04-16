//
//  Question.swift
//  Quizzler-iOS13
//
//  Created by Giorgi Shukakidze on 12/8/19.
//  Copyright © 2019 Giorgi Shukakidze. All rights reserved.

import Foundation

struct Question {
    let text: String
    let answers: [String]
    let correctAnswer: String
    
    
    init (q: String, a: [String], c: String){
        text = q
        answers = a
        correctAnswer = c
    }
}
