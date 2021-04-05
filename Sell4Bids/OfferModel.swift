//
//  OfferModel.swift
//  Sell4Bids
//
//  Created by admin on 27/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


class users {
    
    var uid = String()
    var id = String()
    var name = String()
    var averagerating = Double()

    init(uid : String , id : String , name : String , averagerating : Double ) {
        
        self.uid = uid
        self.id = id
        self.name = name
        self.averagerating = averagerating
        
    }
    
}


class offers {
    
    var quantity = String()
    var price = String()
    var message = String()
    var role = String()
    var time = Int64()
    
    init(quantity : String , price : String , message : String , role : String , time : Int64) {
        
        self.quantity = quantity
        self.price = price
        self.message = message
        self.role = role
        self.time = time
        
    }
}

class OfferModel {
    
    var id = String()
    var user : [users]?
    var item_id = String()
    var type = String()
    var status = String()
    var sellerOfferCount = Int()
    var seller_uid = String()
    var seller_marked_paid = Bool()
    var buyerOfferCount = Int()
    var price = String()
    var offers : [offers]?
    var buyer_uid = String()
    var boughtPrice = String()
    var boughtQuantity = String()
    var orderRejectReason = String()
    var lastOfferBuyer :Int?
    var lastQuantityBuyer :Int?
    var lastOfferSeller :Int?
    var lastQuantitySeller :Int?
    var seller_Rating = Double()
    var buyer_Rating = Double()
    var isLocationShared = Bool()
    var address = String()
    var currencyString = String()
    var quantity = Int()
    
//    var lastQuantityBuyer = Int()
//    var lastOfferSeller = Int()
//    var lastQuantitySeller = Int()
    
    init(id : String , user : [users] , item_id : String , type : String , status : String , sellerOfferCount : Int , seller_uid : String , seller_marked_paid : Bool , buyerOfferCount : Int , price : String , offers : [offers] , buyer_uid : String , boughtPrice : String , boughtQuantity : String , orderRejectReason : String , lastOfferBuyer : Int , seller_Rating : Double , buyer_Rating : Double , isLocationShared : Bool , address : String, lastQuantityBuyer: Int,lastOfferSeller: Int,lastQuantitySeller:Int, currency_string:String,quantity:Int) {
        
        self.id = id
        self.user = user
        self.item_id = item_id
        self.type = type
        self.status = status
        self.sellerOfferCount = sellerOfferCount
        self.seller_uid = seller_uid
        self.seller_marked_paid = seller_marked_paid
        self.buyerOfferCount = buyerOfferCount
        self.price = price
        self.offers = offers
        self.buyer_uid = buyer_uid
        self.boughtPrice = boughtPrice
        self.boughtQuantity = boughtQuantity
        self.orderRejectReason = orderRejectReason
        self.lastOfferBuyer = lastOfferBuyer
        self.seller_Rating = seller_Rating
        self.buyer_Rating = buyer_Rating
        self.isLocationShared = isLocationShared
        self.address = address
        self.lastQuantityBuyer = lastQuantityBuyer
        self.lastOfferSeller = lastOfferSeller
        self.lastQuantitySeller = lastQuantitySeller
        self.currencyString = currency_string
        self.quantity = quantity
    }
    
}
