//
//  ChatNavi.swift
//  Sell4Bids
//
//  Created by admin on 06/11/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ChatNavi: UIView {

  
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var inviteBtn: UIButton!
    
    var navi = UINavigationController()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
    


}
