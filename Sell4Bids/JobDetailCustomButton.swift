//
//  JobDetailCustomButton.swift
//  Sell4Bids
//
//  Created by Admin on 20/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class ButtonStacksJob: UIView {
    
    
    @IBOutlet weak var ChatWithSellerBtn: UIButton!
    
    @IBOutlet weak var Apply_Now_Btn: UIButton!
    
    
    override func awakeFromNib() {
        
        Apply_Now_Btn.addShadowAndRoundNew()
        ChatWithSellerBtn.addShadowAndRoundNew()
        
    }
    
}
