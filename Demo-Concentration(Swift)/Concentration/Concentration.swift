//
//  Concentration.swift
//  Concentration
//
//  Created by Giorgi Shukakidze on 4/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    var flipCount = 0
    var score = 0
    let gameTheme: Theme
    let emojis = [
        Theme.Countries: ["🇬🇪","🇫🇮", "🇬🇷", "🇨🇿", "🇱🇷", "🇺🇸", "🇬🇧", "🇧🇷"],
        Theme.Haloween: ["👻", "💀", "🎃", "🤡", "🙀", "🤖", "👽", "👺"],
        Theme.Sports: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉"],
        Theme.Animals: ["🐶", "🐰", "🦊", "🐼", "🐵", "🦉", "🦄", "🦕"],
        Theme.Faces: ["😄", "😂", "😜", "🤩", "🥳", "😱", "😴", "🤠"],
        Theme.Food:["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇"]
    ]
    
    private var flippedCardIndices = [Int]()
    private var oneAndOnlyFaceUpCardIndex: Int?
    
    func choseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = oneAndOnlyFaceUpCardIndex, matchIndex != index {
                // Match cards
                if cards[index].identifier == cards[matchIndex].identifier {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                }
                cards[index].isFaceUp = true
                oneAndOnlyFaceUpCardIndex = nil
                updateScore(forIndex: index)
            } else {
                for i in cards.indices {
                    cards[i].isFaceUp = false
                }
                cards[index].isFaceUp = true
                oneAndOnlyFaceUpCardIndex = index
            }
        }
        
        if flippedCardIndices.firstIndex(of: index) == nil {
            flippedCardIndices.append(index)
        }
        
        flipCount += 1
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // Shuffle Cards
        cards.shuffle()
        gameTheme = Theme.allCases.randomElement()!
    }
    
    private func updateScore(forIndex index: Int) {
        
        if cards[index].isMatched {
            score += 2
        } else if flippedCardIndices.firstIndex(of: index) != nil {
            score -= 1
        }
    }
}

enum Theme: CaseIterable {
    case Countries, Haloween, Sports, Animals, Faces, Food
}
