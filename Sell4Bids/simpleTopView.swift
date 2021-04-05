//
//  simpleTopView.swift
//  Sell4Bids
//
//  Created by admin on 6/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class simpleTopView: UIView {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var homeImg: UIImageView!
    @IBOutlet weak var backBtnWidth: NSLayoutConstraint!
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }

}
