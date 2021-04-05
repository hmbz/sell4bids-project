//
//  FollowersModel.swift
//  Sell4Bids
//
//  Created by admin on 2/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class FollowersModel{
    
   var uid = String()
    var name = String()
    var averagerating = Double()
    var image = String()
    var totalratings = Double()
    var id = String()
    
    init(uid : String , name : String , averagerating : Double , image : String , totalratings : Double , id : String) {
        
        self.uid = uid
        self.name = name
        self.averagerating = averagerating
        self.image = image
        self.totalratings = totalratings
        self.id = id
        
        
    }
}
