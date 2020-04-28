//
//  Concentration.swift
//  Concentration
//
//  Created by Giorgi Shukakidze on 4/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

struct Concentration {
    
    var cards = [Card]()
    private(set) var flipCount = 0
    private(set) var score = 0
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
    private var oneAndOnlyFaceUpCardIndex: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func choseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = oneAndOnlyFaceUpCardIndex, matchIndex != index {
                if cards[index] == cards[matchIndex] {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                }
                cards[index].isFaceUp = true
                updateScore(forIndex: index)
            } else {
                oneAndOnlyFaceUpCardIndex = index
            }
        }
        
        if flippedCardIndices.firstIndex(of: index) == nil {
            flippedCardIndices.append(index)
        }
        
        flipCount += 1
    }
    
    private mutating func updateScore(forIndex index: Int) {
        if cards[index].isMatched {
            score += 2
        } else if flippedCardIndices.firstIndex(of: index) != nil {
            score -= 1
        }
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
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

enum Theme: CaseIterable {
    case Countries, Haloween, Sports, Animals, Faces, Food
}
