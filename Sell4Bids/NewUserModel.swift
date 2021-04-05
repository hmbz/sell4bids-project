//
//  NewUserModel.swift
//  Sell4Bids
//
//  Created by admin on 05/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class NewUserModel {
    
    var country = String()
    var totalrating = Double()
    var averagerating = Double()
    var state = String()
    var city = String()
    var buyingActivities = Bool()
    var selleingActivities = Bool()
    var chatActivities = Bool()
    var name = String()
    var token = String()
    var email = String()
    var startTime = Int64()
  
    var id = String()
    
    
    init(country : String , totalrating : Double , averagerating : Double , state : String , city : String , buyingActivities : Bool , sellingActivities : Bool , chatActivities : Bool , name : String , token : String , email : String , stateTime : Int64 , id : String) {
        
        self.country = country
        self.totalrating = totalrating
        self.averagerating = averagerating
        self.buyingActivities = buyingActivities
        self.selleingActivities = sellingActivities
        self.chatActivities = chatActivities
        self.name = name
        self.token = token
        self.email = email
        self.startTime = stateTime
        self.id = id
        
    }
    
    
}
