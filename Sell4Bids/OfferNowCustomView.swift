//
//  OfferNowCustomView.swift
//  Sell4Bids
//
//  Created by admin on 05/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class OfferNowCustomView: UIView {
    
    @IBOutlet weak var Header0_Title: UILabel!
    @IBOutlet weak var CloseBtn: UIButton!
    @IBOutlet weak var AmountPerItemtxt: UITextField!
    @IBOutlet weak var Header1_Title: UILabel!
    @IBOutlet weak var Quantitytxt: UITextField!
    @IBOutlet weak var SendOfferBtn: UIButton!
    @IBOutlet weak var cardView: UIView!
    
  
    override func awakeFromNib() {
        cardView.shadowView()
        layer.cornerRadius = 12
        layer.masksToBounds = true
        AmountPerItemtxt.layer.borderWidth = 1.5
        AmountPerItemtxt.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Quantitytxt.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Quantitytxt.layer.borderWidth = 1.5
        AmountPerItemtxt.layer.cornerRadius = 6
        Quantitytxt.layer.cornerRadius = 6
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
