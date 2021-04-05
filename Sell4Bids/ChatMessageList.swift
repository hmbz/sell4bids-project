//
//  ChatMessageList.swift
//  Sell4Bids
//
//  Created by admin on 11/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class ChatMessageList {
    var read = Bool()
    var delivered_time = Int64()
    var created_at = Int64()
    var buyer_uid = String()
    var message = String()
    var itemCategory = String()
    var sender_uid = String()
    var item_id = String()
    var role = String()
    var item_price = Int()
    var sender = String()
    var itemAuctionType = String()
    var receiver_uid = String()
    var images_small_path = String()
    var delivered = Bool()
    var seller_uid = String()
    var id = String()
    var images_path = String()
    var title = String()
    var receiver = String()
    var iserror = Bool()
    
    
    init(read : Bool , delivered_time : Int64 , created_at : Int64 , buyer_uid : String , message : String , itemCategory : String , sender_uid : String , item_id : String , item_price : Int , sender : String , itemAuctionType : String , receiver_uid : String , images_small_path : String , delivered : Bool , seller_uid : String , id : String , images_path : String , title : String , receiver : String , role : String , iserror : Bool) {
        
        self.read = read
        self.role = role
        self.delivered = delivered
        self.created_at = created_at
        self.buyer_uid = buyer_uid
        self.message = message
        self.itemCategory = itemCategory
        self.sender_uid = sender_uid
        self.item_id = item_id
        self.item_price = item_price
        self.sender = sender
        self.itemAuctionType = itemAuctionType
        self.receiver_uid = receiver_uid
        self.images_small_path = images_small_path
        self.delivered_time = delivered_time
        self.item_price = item_price
        self.seller_uid = seller_uid
        self.id = id
        self.images_path = images_path
        self.title = title
        self.receiver = receiver
        self.iserror = iserror
        
    }
}

class SendMessage {
    var message = String()
    var buyer_uid = String()
    var item_id = String()
    var receiver = String()
    var sender = String()
    var receiver_uid = String()
    var seller_uid = String()
    var role = String()
    var sender_uid = String()
    var itemCategory = String()
    var itemAuctionType = String()
    var item_title = String()
    var item_image = String()
    var item_price = Int()
    var delivered_time = Int64()
    var iserror = Bool()
    
    init(message : String , buyer_uid : String , item_id : String , receiver_uid : String , sender : String ,receiver : String , seller_uid : String , role : String , sender_uid : String , itemCategory : String , itemAuctionType : String , item_title : String , item_image : String , item_price : Int , delivered_time : Int64, iserror : Bool) {
        
        self.message = message
        self.buyer_uid = buyer_uid
        self.item_id = item_id
        self.receiver_uid = receiver_uid
        self.sender = sender
        self.receiver_uid = receiver_uid
        self.seller_uid = seller_uid
        self.role = role
        self.sender_uid = sender_uid
        self.itemCategory = itemCategory
        self.itemAuctionType = itemAuctionType
        self.item_title = item_title
        self.item_image = item_image
        self.item_price = item_price
        self.delivered_time = delivered_time
        self.receiver = receiver
        self.iserror = iserror
    }
    
}
