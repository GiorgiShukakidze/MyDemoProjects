//
//  ViewController.swift
//  Twittermenti
//
//  Created by Giorgi Shukakidze on 3/25/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import SwifteriOS
import SwiftyJSON


class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let emojis = ["😍", "😁", "🙂", "😐", "😕", "😡", "🤮"]
    let tweetCount = 100
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: Keys.consumerKey, consumerSecret: Keys.consumerSecret)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        sentimentLabel.text = "Measuring..."
        fetchTweets()
    }
    
    private func fetchTweets() {
        
        if let searchText = textField.text {
                        
            self.swifter.searchTweet(using: searchText,
                                     lang: "en",
                                     count: self.tweetCount,
                                     tweetMode: .extended,
                                     success: { (results, metadata) in
                                        
                                        var tweets = [TweetSentimentClassifierInput]()

                                        for i in 0..<self.tweetCount {
                                            if let tweet = results[i]["full_text"].string {
                                                tweets.append(TweetSentimentClassifierInput(text: tweet))
                                            }
                                        }
                                        self.makePredictions(for: tweets)
            }) { (error) in
                print("Erro fething Data: \(error)")
            }
        }
    }
    
    private func makePredictions(for tweets: [TweetSentimentClassifierInput]) {
        
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            var sentimentScore = 0
            for pred in predictions {
                let sentiment = pred.label
                switch sentiment {
                case "Pos":
                    sentimentScore += 1
                    print(sentimentScore)
                case "Neg":
                    sentimentScore -= 1
                    print(sentimentScore)
                default:
                    break
                }
            }
            print("Final score: \(sentimentScore)")
            updateUI(for: sentimentScore)
        }catch {
            print("There was error making prediction: \(error)")
        }
    }
    
    private func updateUI(for sentimentScore: Int) {
        
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😁"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore > -5 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😕"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
    }
}

