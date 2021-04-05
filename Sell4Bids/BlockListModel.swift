//
//  BlockListModel.swift
//  Sell4Bids
//
//  Created by admin on 2/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class BlockListModel{
    
    var Name = String()
    var userID = String()
    var totalratings = String()
    var averagerating = String()
    var image = String()
    
    init(name : String , userid : String , totalrating : String , averagerating : String , image : String) {
        self.Name = name
        self.userID = userid
        self.totalratings = totalrating
        self.averagerating = averagerating
        self.image = image
    }
}
