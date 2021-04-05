//
//  ShowSellerCounterOffer.swift
//  Sell4Bids
//
//  Created by Admin on 20/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class SellerCounerOffer : UIView {
    
    
    @IBOutlet weak var CloseBtn: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var counterOfferBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        acceptBtn.shadowView()
        rejectBtn.shadowView()
        counterOfferBtn.shadowView()
        
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
