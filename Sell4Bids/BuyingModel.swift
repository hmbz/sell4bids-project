//
//  BuyingModel.swift
//  Sell4Bids
//
//  Created by admin on 2/21/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class BuyingModel{
    

    
    var seller_Rating = Double()
    var boughtQuantity = String()
    var seller_uid = String()
    var isLocationShared = Bool()
    var status = String()
    var buyerName = String()
    var auctionType = String()
    var boughtPrice = String()
    var type = String()
    var sellerName = String()
    var totalAmount = String()
    var item_id = String()
    var buyer_uid = String()
    var seller_marked_paid = Bool()
    var image = String()
    var orderTime = Int64()
    var itemCategory = String()
    var id = String()
    var price = String()
    var buyer_Rating = Double()
    var buyerOfferCount = String()
    var quantity = String()
    var lastQuantityBuyer = String()
    var lastOfferTime = Int64()
    var sellerOfferCount = String()
    var lastOfferBuyer = String()
    var title = String()
    var offers : [offers]?
    var currencyString = String()
    var currencySymbol =  String()
  
    
    //init for Orders
    init(buyer_Rating : Double , seller_Rating : Double , boughtQuantity : String , seller_uid : String , isLocationShared : Bool , status : String , buyerName : String , auctionType : String , boughtPrice : String , type : String , sellerName : String , totalAmount : String , item_id : String , buyer_uid : String , seller_marked_paid : Bool , image : String , orderTime : Int64 , itemCategory : String , id : String , title : String, currencyString: String, currencySymbol: String) {
        
        self.buyer_Rating = buyer_Rating
        self.seller_Rating = seller_Rating
        self.boughtQuantity = boughtQuantity
        self.seller_uid = seller_uid
        self.isLocationShared = isLocationShared
        self.status = status
        self.buyerName = buyerName
        self.auctionType = auctionType
        self.boughtPrice = boughtPrice
        self.type = type
        self.sellerName = sellerName
        self.totalAmount = totalAmount
        self.item_id = item_id
        self.buyer_uid = buyer_uid
        self.seller_marked_paid = seller_marked_paid
        self.image = image
        self.orderTime = orderTime
        self.itemCategory = itemCategory
        self.id = id
        self.title = title
        self.currencyString = currencyString
        self.currencySymbol = currencySymbol
        
        
    }
    
    //init Offers Item
    
    init(price : String , seller_Rating : Double , boughtQuantity : String , buyer_Rating : Double , buyerOfferCount : String , seller_uid : String , isLocationShared : Bool , status : String , quantity : String , lastQuantityBuyer : String , boughtPrice : String , type : String , lastOfferTime : Int64 , sellerOfferCount : String , lastOfferBuyer : String , buyer_uid : String , seller_marked_paid : Bool , title : String , image : String , item_id : String , id : String , orderTime : Int64 , offers : [offers],currencyString: String,currencySymbol: String) {
        
        self.price = price
        self.seller_Rating = seller_Rating
        self.boughtQuantity = boughtQuantity
        self.buyer_Rating = buyer_Rating
        self.buyerOfferCount = buyerOfferCount
        self.seller_uid = seller_uid
        self.isLocationShared = isLocationShared
        self.status = status
        self.quantity = quantity
        self.lastQuantityBuyer = lastQuantityBuyer
        self.boughtPrice = boughtPrice
        self.type = type
        self.lastOfferTime = lastOfferTime
        self.sellerOfferCount = sellerOfferCount
        self.lastOfferBuyer = lastOfferBuyer
        self.buyer_uid = buyer_uid
        self.seller_marked_paid = seller_marked_paid
        self.title = title
        self.image = image
        self.item_id = item_id
        self.id = id
        self.orderTime = orderTime
        self.offers = offers
        self.currencyString = currencyString
        self.currencySymbol = currencySymbol
        
    }
    
    
}



class WinnerModel {
    
   var status = String()
    var item_id = String()
    var maxBid = String()
    var itemAuctionType = String()
    var title = String()
    var images_path = [String]()
    var itemCategory = String()
    var id = String()
    var currencyString = String()
    
    init(status : String , item_id : String , maxBid : String , itemAuctionType : String , title : String , images_path : [String] , itemCategory : String , id : String,currencyString:String) {
        
        self.status = status
        self.item_id = item_id
        self.maxBid = maxBid
        self.itemAuctionType = itemAuctionType
        self.title = title
        self.images_path = images_path
        self.itemCategory = itemCategory
        self.id = id
        self.currencyString = currencyString
        
        
    }
}



class BidsItemModel {
    
    var bid = String()
    var item_id = String()
    var status = String()
    var winner = String()
    var bidsCount = String()
    var endTime = Int64()
    var startTime = Int64()
    var itemAuctionType = String()
    var image = String()
    var startPrice = String()
    var title = String()
    var uid = String()
    var id = String()
    var maxBid = String()
    var currency_symbol = String()
    var itemCategory = String()
    
    
    init(bid : String , item_id : String , status : String , winner : String , bidsCount : String , endTime : Int64 , startTime : Int64 , itemAuctionType : String , image : String , startPrice : String , title : String , uid : String , id : String , maxBid : String ,currency_symbol:String,itemCategory:String){
        
        self.bid = bid
        self.item_id = item_id
        self.status = status
        self.winner = winner
        self.bidsCount = bidsCount
        self.endTime = endTime
        self.startTime = startTime
        self.itemAuctionType = itemAuctionType
        self.image = image
        self.startPrice = startPrice
        self.uid = uid
        self.maxBid = maxBid
        self.title = title
        self.currency_symbol = currency_symbol
        self.itemCategory = itemCategory
    }
}
