//
//  Card.swift
//  Concentration
//
//  Created by Giorgi Shukakidze on 4/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

struct Card {
    
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var uniqueIdentifier = 0
    
    static func generateUiqueIdentifier() -> Int {
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
    
    init () {
        self.identifier = Card.generateUiqueIdentifier()
    }
    
}
