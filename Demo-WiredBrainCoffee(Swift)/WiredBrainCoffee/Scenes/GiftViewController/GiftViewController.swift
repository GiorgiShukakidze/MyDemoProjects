//
//  GiftViewController.swift
//  WiredBrainCoffee
//
//  Created by Giorgi Shukakidze on 4/17/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class GiftViewController: UIViewController {
    
    @IBOutlet weak var seasonalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var thankYouHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var thankYouCollectionView: UICollectionView!
    @IBOutlet weak var seasonalCollectionView: UICollectionView!
    var seasonalGiftCards = [GiftCardModel]()
    var thankYouCardsDataSource: SmallGiftCardCollectionViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        GiftCardFunctions.getSeasonalGiftCards { [weak self] (cards) in
            guard let self = self else {return}
            self.seasonalGiftCards = cards
            self.seasonalCollectionView.reloadData()
        }
        
        GiftCardFunctions.getThankYouGiftCards { [weak self] (cards) in
            guard let self = self else {return}
            self.thankYouCardsDataSource = SmallGiftCardCollectionViewDataSource(giftCards: cards)
            self.thankYouCollectionView.dataSource = self.thankYouCardsDataSource
            self.thankYouCollectionView.delegate = self.thankYouCardsDataSource
            self.thankYouCollectionView.reloadData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setHeightConstraints()
    }
    
    func setHeightConstraints () {
        let width = seasonalCollectionView.bounds.width - 30
        let height = width / 1.5
        
        seasonalHeightConstraint.constant = height
        thankYouHeightConstraint.constant = height / 2
    }
    
}

extension GiftViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasonalGiftCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCardCell", for: indexPath) as! GiftCardCollectionViewCell
        let card = seasonalGiftCards[indexPath.item]
        cell.setUpCell(withCard: card)
        
        return cell
    }
}

extension GiftViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width - 50
        let height = width / 1.5
        
        return CGSize(width: width, height: height)
    }
}


