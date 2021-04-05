//
//  ButtonStacksItem.swift
//  Sell4Bids
//
//  Created by admin on 28/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ButtonStacksItem: UIView {
    
    @IBOutlet weak var Chat_Now_Btn: UIButton!
    @IBOutlet weak var Buy_Now_Btn: UIButton!
    @IBOutlet weak var Offer_Now_Btn: UIButton!
    @IBOutlet weak var Bid_Now_Btn: UIButton!
    
    
    
    override func awakeFromNib() {
        Chat_Now_Btn.shadowView()
        Chat_Now_Btn.layer.cornerRadius = 30
        Buy_Now_Btn.shadowView()
        Buy_Now_Btn.layer.cornerRadius = 30
        Offer_Now_Btn.shadowView()
        Offer_Now_Btn.layer.cornerRadius = 30
        Bid_Now_Btn.shadowView()
        Bid_Now_Btn.layer.cornerRadius = 30
        
        
    }

}
