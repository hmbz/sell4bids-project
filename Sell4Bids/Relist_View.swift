//
//  Relist_View.swift
//  Sell4Bids
//
//  Created by Admin on 03/06/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Relist_View : UIView {
    
    @IBOutlet weak var Header0_Title: UILabel!
    @IBOutlet weak var CloseBtn: UIButton!
    @IBOutlet weak var AmountPerItemtxt: UITextField!
    @IBOutlet weak var Header1_Title: UILabel!
    @IBOutlet weak var DollarSign: UILabel!
    @IBOutlet weak var Quantitytxt: UITextField!
    @IBOutlet weak var SendOfferBtn: UIButton!
    
    
    override func awakeFromNib() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    
    
}
