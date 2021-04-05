//
//  EdHeaderView.swift
//  Sell4Bids
//
//  Created by admin on 12/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EdHeaderView: UICollectionReusableView {
    @IBOutlet weak var greetingImg: UIImageView!
    @IBOutlet weak var greetingLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 220)
    }
    
}
