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
    private var identifier: Int
    
    private static var uniqueIdentifier = 0
    
    private static func generateUiqueIdentifier() -> Int {
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
    
    init () {
        self.identifier = Card.generateUiqueIdentifier()
    }
}

extension Card: Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
