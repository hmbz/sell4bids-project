//
//  alertViewWithSingleTextField.swift
//  Sell4Bids
//
//  Created by admin on 11/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class alertViewWithSingleTextField: UIView {
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var textFieldLbl: UILabel!
    @IBOutlet weak var selectionTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    
     override func awakeFromNib() {
           layer.cornerRadius = 6
           layer.masksToBounds = true
       }

}
