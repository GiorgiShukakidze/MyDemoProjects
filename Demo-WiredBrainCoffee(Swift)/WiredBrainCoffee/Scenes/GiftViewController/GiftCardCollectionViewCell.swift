//
//  GiftCardCollectionViewCell.swift
//  WiredBrainCoffee
//
//  Created by Giorgi Shukakidze on 4/17/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class GiftCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var giftCardImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        giftCardImage.layer.cornerRadius = layer.cornerRadius
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func setUpCell(withCard giftCard: GiftCardModel) {
        giftCardImage.image = giftCard.image
    }
}
