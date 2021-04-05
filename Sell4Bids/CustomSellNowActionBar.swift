//
//  CustomSellNowActionBar.swift
//  Sell4Bids
//
//  Created by admin on 04/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CustomSellNowActionBar: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    
    @IBOutlet weak var Items_Image: UIImageView!
    @IBOutlet weak var OthersItemsLbl: UILabel!
    
    @IBOutlet weak var Job_Image: UIImageView!
    @IBOutlet weak var JobsLbl: UILabel!
    
    @IBOutlet weak var Vehciles_Image: UIImageView!
    @IBOutlet weak var VehiclesLbl: UILabel!
    
    @IBOutlet weak var Services_Image: UIImageView!
    @IBOutlet weak var ServiceLbl: UILabel!
    
    @IBOutlet weak var Housing_Image: UIImageView!
    @IBOutlet weak var HousingLbl: UILabel!
    
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 200)
    }
    
    
}
