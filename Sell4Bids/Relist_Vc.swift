//
//  Relist_Vc.swift
//  Sell4Bids
//
//  Created by admin on 13/06/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class RelistViewVC: UIView {
    
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
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
