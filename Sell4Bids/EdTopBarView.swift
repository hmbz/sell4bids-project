//
//  EdTopBarView.swift
//  Sell4Bids
//
//  Created by admin on 12/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EdTopBarView: UIView {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    
     override var intrinsicContentSize: CGSize {
           return CGSize(width: UIScreen.main.bounds.width, height: 40)
       }
}
