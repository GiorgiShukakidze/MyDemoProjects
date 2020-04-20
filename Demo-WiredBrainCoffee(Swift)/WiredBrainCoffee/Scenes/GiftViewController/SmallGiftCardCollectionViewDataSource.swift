//
//  SmallGiftCardCollectionViewDataSource.swift
//  WiredBrainCoffee
//
//  Created by Giorgi Shukakidze on 4/19/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class SmallGiftCardCollectionViewDataSource: NSObject {
    
    fileprivate var thankYouCards = [GiftCardModel]()
    
    init(giftCards: [GiftCardModel]) {
        thankYouCards = giftCards
    }
}

extension SmallGiftCardCollectionViewDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thankYouCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCardCell", for: indexPath) as! GiftCardCollectionViewCell
        let card = thankYouCards[indexPath.item]
        cell.setUpCell(withCard: card)
        
        return cell
    }
}

extension SmallGiftCardCollectionViewDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width / 2) - 50
        let height = width / 1.5
        
        return CGSize(width: width, height: height)
    }
}
