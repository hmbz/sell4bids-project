//
//  LoginModel.swift
//  Sell4Bids
//
//  Created by admin on 2/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class LoginModel{
    
    var startTime = String()
    var userID = String()
    var city = String()
    var country = String()
    var email = String()
    var fcmToken = String()
    var followingsCount = String()
    var name = String()
    var newNotifications = String()
    var state = String()
    var token = String()
    var unreadCount = String()
    var unreadNotifications = String()
    var zipCode = String()
    var longitude = String()
    var latitude = String()
    var image = String()
    
    init(starttime: String , userid : String , city : String , country : String , email : String ,fcmtoken : String , followingcount : String , name : String , newnotification : String , state : String , token : String , unreadcount : String , unreadnotification : String , zipcode : String , longitude : String , latitude : String , image : String ) {
        self.startTime = starttime
        self.userID = userid
        self.city = city
        self.country = country
        self.email = email
        self.fcmToken = fcmtoken
        self.followingsCount = followingcount
        self.name = name
        self.newNotifications = newnotification
        self.state = state
        self.token = token
        self.unreadCount = unreadcount
        self.unreadNotifications = unreadnotification
        self.zipCode = zipcode
        self.longitude = longitude
        self.latitude = latitude
        self.image = image
        
    }
}


