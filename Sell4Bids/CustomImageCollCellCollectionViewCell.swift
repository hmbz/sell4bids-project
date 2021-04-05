//
//  CustomImageCollCellCollectionViewCell.swift
//  Sell4Bids
//
//  Created by admin on 09/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CustomImageCollCellCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var ItemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ItemImage.makeRedAndRound()
    }
}
