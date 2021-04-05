//
//  boughtModel.swift
//  Sell4Bids
//
//  Created by admin on 2/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class boughtModel{
    
    var userid = String()
    var title = String()
    var image = String()
    var price = Int()
    var qunatity = Int()
    var seller_uid = String()
    var buyer_uid = String()
    var status = String()
    var sellerName = String()
    var buyerName = String()
    var totalAmount = Int()
    var seller_marked_paid = Bool()
    var buyer_item_recieved = Bool()
    var rating = Int()
    var itemId = String()
    var itemCategory = String()
    
    init(userid : String , title : String , image : String , price : Int , quantity : Int , seller_uid : String , buyer_uid : String , status : String , sellername : String , buyername : String , totalamount : Int , sellermarkedpaid : Bool , buyeritemreceiver : Bool , rating : Int , itemid : String , itemcategory : String  ) {
        self.userid = userid
        self.title = title
        self.image = image
        self.price = price
        self.qunatity = quantity
        self.seller_uid = seller_uid
        self.buyer_uid = buyer_uid
        self.status = status
        self.sellerName = sellername
        self.buyerName = buyername
        self.totalAmount = totalamount
        self.seller_marked_paid = sellermarkedpaid
        self.buyer_item_recieved = buyeritemreceiver
        self.rating = rating
        self.itemId = itemid
        self.itemCategory = itemcategory
        
        
    }
    
}
