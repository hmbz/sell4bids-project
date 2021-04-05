//
//  Notifications.swift
//  Sell4Bids
//
//  Created by admin on 10/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
class NotificationModel {
  
  var auctionType = String()
  var category = String()
  var productKey = String()
  var message = String()
  var read = String()
  var senderName = String()
  var stateName = String()
  var startTime = Int64()
  var notifyKey = String()
  var itemImage = String()
  var itemTitle = String()
  var itemID = String()
  
  var senderUId : String?
  var senderImage: String?
  var type: String?
  //variables for chat dictionary
  
  var product : ProductModel!
  
  
    init(notifyKey:String,itemImage : String , itemTitle : String , itemID : String ,notificationDict:[String:AnyObject]){
    
    if let auctionType = notificationDict["auctionType"] as? String {
      self.auctionType = auctionType
    }
    if  let categoryName = notificationDict["category"] as? String {
      self.category = categoryName
    }
    if let productkey = notificationDict["key"] as? String{
      self.productKey = productkey
    }
    if let message = notificationDict["message"] as? String{
      self.message = message
    }
    
    //  var readNoti:Int = 0
    if let read =  notificationDict["read"] as? String{
      self.read = read
    }else {
      self.read = "0"
    }
    if let senderName =  notificationDict["senderName"] as? String {
      self.senderName = senderName
    }else {
      self.senderName = "Sell4Bids"
    }
    if let state = notificationDict["state"] as? String{
      self.stateName = state
    }
    if let startTime = notificationDict["time"]  as? Int64 {
      //checkTime = startTime as? Int64
      self.startTime = startTime
    }else {
      self.startTime = 0
    }
    self.notifyKey = notifyKey
    
    //parsing for chat notification variables
    if let senderUId = notificationDict["senderUid"]  as? String {
      self.senderUId = senderUId
    }
    
    if let senderImage = notificationDict["senderImage"]  as? String {
      self.senderImage = senderImage
    }
    
    if let type = notificationDict["type"]  as? String {
      self.type = type
    }
    
     self.itemTitle = itemTitle
        self.itemImage = itemImage
        self.itemID = itemID
        
        
  }
}


class NewNotification_Model {
    var category : String?
    var SenderName : String?
    var item_id : String?
    var id : String?
    var delivered : Bool?
    var message : String?
    var created_at : Int64?
    var receiver_uid : String?
    var auctionType : String?
    var read : Bool?
    var title : String?
    var image_small_path : Array<Any>?
    var image_path : Array<Any>?
    var notificationType : String?
    var seller_uid : String?
    var price : Int?
    var buyerId : String?
    
    
  init(category : String , item_id : String , id : String , delivered : Bool , message : String , created_at : Int64 , receiver_uid : String , auctionType : String  , read : Bool,title : String , image_small_path : Array<Any> , image_path : Array<Any> , notificationType : String, seller_uid: String, price: Int,buyerId:String,SenderName:String) {
        self.notificationType = notificationType
        self.read = read
        self.category = category
        self.item_id = item_id
        self.id = id
       self.SenderName = SenderName
        self.delivered = delivered
        self.message = message
        self.created_at = created_at
        self.receiver_uid = receiver_uid
        self.auctionType = auctionType
        self.title = title
        self.image_small_path = image_small_path
        self.image_path = image_path
        self.seller_uid = seller_uid
        self.price = price
        self.buyerId = buyerId
    }
}

class Item_details_noti_model {
    var title = String()
    var image_small_path = [String]()
    var image_path = [String]()
    
    init(title : String , image_small_path : [String] , image_path : [String]) {
        
        self.title = title
        self.image_small_path = image_small_path
        self.image_path = image_path
        
    }
}
