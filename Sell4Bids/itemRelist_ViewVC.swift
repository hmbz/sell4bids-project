//
//  itemRelist_ViewVC.swift
//  Sell4Bids
//
//  Created by Admin on 19/06/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class itemRelist_ViewVC: UIView {
    
    @IBOutlet weak var CloseBtn: UIButton!
    @IBOutlet weak var Header1_Title: UILabel!
    @IBOutlet weak var Quantitytxt: UITextField!
    @IBOutlet weak var SendOfferBtn: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    
    
    
    override func awakeFromNib() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }

/*
 // Only override draw() if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func draw(_ rect: CGRect) {
 // Drawing code
 }
 */
}
