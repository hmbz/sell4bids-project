//
//  OrderViewModel.swift
//  Sell4Bids
//
//  Created by admin on 11/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


class OrderViewModel {
    var order_status = String()
    var image = String()
    var user_id = String()
    var user_averagerating = Double()
    var name = String()
    var order_id = String()
    var type = String()
    var buyer_item_recieved = Bool()
    var price = Int()
    var seller_marked_paid = Bool()
    var quantity = Int()
    var item_id = String()
    var isLocationShared = Bool()
    var address = String()
    var seller_rating = Double()
    var averagerating = Double()
    var orderRejectReason = String()
    
    init(item_id : String ,order_status : String , image : String , user_id : String , user_averagerating : Double , name : String , order_id : String , type : String , buyer_item_recieved : Bool , price : Int , seller_marked_paid : Bool , quantity : Int  , isLocationShared : Bool, address : String , seller_rating : Double , averagerating : Double , orderRejectReason : String) {
        
        self.item_id = item_id
        self.order_status = order_status
        self.image = image
        self.user_id = user_id
        self.user_averagerating = user_averagerating
        self.name = name
        self.order_id = order_id
        self.buyer_item_recieved = buyer_item_recieved
        self.price = price
        self.seller_marked_paid = seller_marked_paid
        self.quantity = quantity
        self.isLocationShared = isLocationShared
        self.address = address
        self.seller_rating = seller_rating
        self.averagerating = averagerating
        self.orderRejectReason = orderRejectReason
        
    }
}
