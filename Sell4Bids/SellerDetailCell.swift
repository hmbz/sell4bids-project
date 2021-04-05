//
//  SellerDetailCell.swift
//  Sell4Bids
//
//  Created by admin on 04/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos

class SellerDetailCell: UICollectionReusableView {
        
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var productCount: UILabel!
    
    @IBOutlet weak var FollowingCount: UILabel!
    @IBOutlet weak var FollowerCount: UILabel!
    
    @IBOutlet weak var cosmosViewRating: CosmosView!
    
    @IBOutlet weak var sellerImage: UIImageView!
    
    @IBOutlet weak var totalAverageRating: UILabel!
    
    @IBOutlet weak var BlockBtn: UIButton!
    
    @IBOutlet weak var FollowingBtn: UIButton!
    
    
}

