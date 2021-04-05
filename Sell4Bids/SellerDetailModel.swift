//
//  SellerDetailModel.swift
//  Sell4Bids
//
//  Created by admin on 04/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class SellerDetailModel {
    
    var blocked = Bool()
    var following = Bool()
    var followerCount = String()
    var followingCount = String()
    var productCount = String()
    
    var id = String()
    var image = String()
    var totalrating = Double()
    var avertagerating = Double()
    var name = String()
    
    init(blocked : Bool , following : Bool , id : String , image : String , totalrating  : Double , averagerating : Double , name : String, productCount : String , followerCount : String , followingCount : String) {
        
        self.blocked = blocked
        self.following = following
        self.productCount = productCount
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.id = id
        self.image = image
        self.totalrating = totalrating
        self.avertagerating = averagerating
        self.name = name
        
        
    }
 
}
