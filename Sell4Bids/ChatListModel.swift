//
//  ChatListModel.swift
//  Sell4Bids
//
//  Created by admin on 09/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class ChatListModel {
    var buyer_uid_id = String()
    var item_id_buyer_uid = String()
    var item_price = String()
    var created_at = Int64()
    var receiver = String()
    var item_title = String()
    var itemCategory = String()
    var buyer_uid = String()
    var id = String()
    var seller_uid = String()
    var read = Bool()
    var sender_uid = String()
    var item_id = String()
    var item_image = String()
    var message = String()
    var itemAuctionType = String()
    var sender = String()
    var receiver_uid = String()
    var delivered_time = Int64()
  

    init(buyer_uid_id : String , item_id_buyer_uid : String , item_price : String , created_at : Int64 , receiver_uid : String , item_title : String , receiver : String , itemCategory : String , buyer_uid : String , id : String , seller_uid : String , item_id : String , item_image : String , message : String , itemAuctionType : String , sender : String , read : Bool , sender_uid : String , delivered_time : Int64 ){
        
        self.created_at = created_at
        self.read = read
        self.buyer_uid_id = buyer_uid_id
        self.item_id_buyer_uid = item_id_buyer_uid
        self.item_price = item_price
        self.item_title = item_title
        self.receiver = receiver
        self.itemCategory = itemCategory
        self.buyer_uid = buyer_uid
        self.id = id
        self.seller_uid = seller_uid
        self.item_id = item_id
        self.item_image = item_image
        self.message = message
        self.itemAuctionType = itemAuctionType
        self.sender = sender
        self.sender_uid = sender_uid
        self.receiver_uid = receiver_uid
        self.delivered_time = delivered_time
    }
    
}
