//
//  ViewController.swift
//  Concentration
//
//  Created by Giorgi Shukakidze on 4/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairs)
 
    private var numberOfPairs: Int {
            return (cardButtons.count + 1) / 2
    }

    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var newGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newGameButton.layer.cornerRadius = 5
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        if let currentCardIndex = cardButtons.firstIndex(of: sender) {
            game.choseCard(at: currentCardIndex)
            updateViewModel()
        } else {
            print("No such card found in cards")
        }
    }
    
    @IBAction private func startNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        emojiChoices = game.emojis[game.gameTheme]
        
        updateViewModel()
    }
    
    private func updateViewModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private lazy var emojiChoices = game.emojis[game.gameTheme]
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        
        if emoji[card] == nil, emojiChoices!.count > 0 {
            emoji[card] = emojiChoices!.remove(at: Int.random(in: 0..<emojiChoices!.count))
        }
        
        return emoji[card] ?? "?"
    }
}

