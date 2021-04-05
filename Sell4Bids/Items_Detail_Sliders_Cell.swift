//
//  Items_Detail_Sliders_Cell.swift
//  Sell4Bids
//
//  Created by admin on 26/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class Items_Detail_Sliders_Cell: UICollectionViewCell {
    
    @IBOutlet weak var ItemSliderImages: UIImageView!
    
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 5
//        self.contentView.layer.borderColor = UIColor.red.cgColor
        self.contentView.layer.borderWidth = 1
        
        self.ItemSliderImages.layer.cornerRadius = 5
        
        
        
    }
}


