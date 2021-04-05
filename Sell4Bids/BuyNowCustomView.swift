//
//  BuyNowCustomView.swift
//  Sell4Bids
//
//  Created by admin on 05/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import TRCurrencyTextField


class BuyNowCustomView: UIView {

    @IBOutlet weak var SendOfferBtn: UIButton!
    @IBOutlet weak var Quantitytxt: UITextField!
    @IBOutlet weak var Heading_Title: UILabel!
    
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var CloseBtn: UIButton!
    @IBOutlet weak var currency_constraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.Quantitytxt.textAlignment = .center
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        SendOfferBtn.shadowView()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
