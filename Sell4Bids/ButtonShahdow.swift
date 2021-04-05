//
//  ButtonShahdow.swift
//  Sell4Bids
//
//  Created by admin on 04/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ButtonShahdow: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    

    
    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }
    
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = true
        
        self.layer.cornerRadius = 20
        
    }
}
