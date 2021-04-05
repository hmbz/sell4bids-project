//
//  RejectedOrderView.swift
//  Sell4Bids
//
//  Created by admin on 12/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class RejectedOrderView: UIView, UITextViewDelegate {
    
    
    @IBOutlet weak var Close_Btn: UIButton!
    
    @IBOutlet weak var Reasontxt: UITextView!
    @IBOutlet weak var SubmitBtn: UIButton!
    @IBOutlet weak var Mainview: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        SubmitBtn.addShadowAndRound()
        self.addShadowAndRound()
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        Reasontxt.text = ""
    }
    
    

}
