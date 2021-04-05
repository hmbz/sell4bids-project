//
//  Users.swift
//  Sell4Bids
//
//  Created by admin on 10/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
class UserModel {
    
    static func ==(lhs: UserModel, rhs: UserModel) -> Bool {
        guard let lhsKey = lhs.userId else {
            return false
        }
        guard let rhsKey = rhs.userId else {
            return false
        }
        
        return lhsKey == rhsKey
    }
    var name:String?
    var image:String?
    var userId:String?
    var averageRating:Float?
    var totalRating:Float?
    var email:String?
    var zipCode:String?
    var state:String?
    var watching:Int?
    var follower:Int?
    var following:Int?
    var totalListing:Int?
    var buying:Int?
    var bought:Int?
    var unReadMessage:Int?
    var unReadNotify:Int?
   
    
    
    init(name:String?,image:String?,userId:String?,  averageRating:Float?,totalRating:Float?,email:String?, zipCode:String?, state:String?,watching:Int?,follower:Int?,following:Int?, totalListing:Int?, buying:Int?, bought:Int?,unReadMessage:Int?,unReadNotify:Int?) {
        self.name = name
        self.userId = userId
        self.image =  image
        self.averageRating = averageRating
        self.totalRating =  totalRating
        self.email = email
        self.zipCode = zipCode
        self.state = state
        self.watching = watching
        self.follower = follower
        self.following = following
        self.totalListing = totalListing
        self.buying = buying
        self.bought = bought
        self.unReadMessage = unReadMessage
        self.unReadNotify = unReadNotify
    
    }
  init(userId:String,userDict:[String:AnyObject]) {
    if let userName = userDict["name"] as? String {
      self.name = userName
    }
    if let userImage = userDict["image"] as? String{
      self.image = userImage
    }
    if let averageRating = userDict["averagerating"] as? String{
      self.averageRating = Float(averageRating)
    }
    if let totalRating = userDict["totalratings"] as? String{
      self.totalRating = Float(totalRating)
    }
    if let email = userDict["email"] as? String{
      self.email = email
    }
    if let zipCode = userDict["zipCode"] as? String{
      self.zipCode = zipCode
    }
    if let follower = userDict["followersCount"] as? String{
      self.follower = Int(follower)
    }else {
      self.follower = 0
    }
    if let following = userDict["followingsCount"] as? String{
      self.following = Int(following)
    }else {
      self.following = 0
    }
    if let stateName = userDict["state"] as? String {
      self.state = stateName
    }
    if  let productDict = userDict["products"] as? NSDictionary{
      if let selling = productDict["selling"] as? NSDictionary{
        self.totalListing = selling.count
      }
    if let buying = productDict["buying"] as? NSDictionary{
      self.buying  = buying.count
      }
    }
    
    
    self.userId = userId
    
  }
  
    
}


class UserDetailModel {
    
    var email = String()
    var unreadNotifications = Int()
    var fcmToken = String()
    var averagerating = Double()
    var unreadCount = Int()
    var country = String()
    var buyingActivities = Bool()
    var sellingActivities = Bool()
    var chatActivities = Bool()
    var uid = String()
    var followingCount = Int()
    var latitude = Double()
    var longitude = Double()
    var zipCode = String()
    var name = String()
    var newNotifications = Int()
    var city = String()
    var state = String()
    var startTime = Int64()
    var followingsCount = Int()
    var totalratings = Double()
    var id = String()
    var token = String()
    var image = String()
    
    init(email : String , unreadNotifications : Int , fcmToken : String , averagerating : Double , unreadCount : Int , country : String , buyingActivities : Bool , sellingActivities : Bool , chatActivities : Bool , uid : String , followersCount : Int , latitude : Double , longitude : Double , zipCode : String , name : String , newNotifications : Int , city : String , state : String , startTime : Int64 , followingCount : Int , totalratings : Double , id : String , token : String , image : String) {
        
        self.email = email
        self.unreadNotifications = unreadNotifications
        self.fcmToken = fcmToken
        self.averagerating = averagerating
        self.unreadCount = unreadCount
        self.country = country
        self.buyingActivities = buyingActivities
        self.sellingActivities = sellingActivities
        self.chatActivities = chatActivities
        self.uid = uid
        self.followingCount = followingCount
        self.latitude = latitude
        self.longitude = longitude
        self.zipCode = zipCode
        self.name = name
        self.newNotifications = newNotifications
        self.city = city
        self.state = state
        self.startTime = startTime
        self.followingCount = followingCount
        self.totalratings = totalratings
        self.id = id
        self.token = token
        self.image = image
        
        
    }
}



class UserActivity {
    
    var unreadNotifications = Int()
    var winsCount = Int()
    var totalItemCount = Int()
    var message = Int()
    var watchingCount = Int()
    var boughtCount = Int()
    var bidsCount = Int()
    var buyingCount = Int()
    var followingCount = Int()
    var followerCount = Int()
    
    init(unreadNotifications : Int ,winsCount : Int , totalItemCount : Int , message : Int , watchingCount : Int , boughtCount : Int , bidsCount : Int , buyingCount : Int , followingCount : Int , followerCount : Int   ) {

        self.unreadNotifications = unreadNotifications
        self.winsCount = winsCount
        self.totalItemCount = totalItemCount
        self.message = message
        self.watchingCount = watchingCount
        self.boughtCount = boughtCount
        self.buyingCount = buyingCount
        self.followingCount = followingCount
        self.followerCount = followerCount
        
    }
}

