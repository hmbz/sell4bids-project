//
//  Item_Header.swift
//  Sell4Bids
//
//  Created by admin on 01/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AACarousel

class Item_Header: UIView {

    @IBOutlet weak var ItemImage: AACarousel!
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 25)
    }
    
    override func awakeFromNib() {
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
