//
//  ProductDetails.swift
//  Sell4Bids
//
//  Created by admin on 19/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class ProductDetails {
    
    var startPrice = Int()
    var visibility = Bool()
    var Image_0 = String()
    var Image_1 = String()
    var quantity = Int()
    var images_path = String()
    var chargeTime = Int64()
    var token = String()
    var description = String()
    var uid = String()
    var itemCategory = String()
    var itemAuctionType = String()
    var itemKey = String()
    var latitude = Double()
    var longtitude = Double()
    var OrderArray = [orderModel]()
    var country_code = String()
    var startTime = Int64()
    var maxBid = Int64()
    var askPrice = Int64()
    var winner = String()
    var winner_uid = String()
    var winner_bid = Int64()
    var timeRemaining = Int64()
    var conditionValue = String()
    var title = String()
    var watch_uid = String()
    var watch_token = String()
    var zipcode = String()
    var condition = String()
    var city = String()
    var endTime = Int64()
    var id = String()
    var state = String()
    var autoReList = String()
    var ItemImages = [String]()
    var ordering_status = Bool()
    var company_name = String()
    var employmentType = String()
    var benefits = String()
    var payPeriod = String()
    var jobToughness = String()
    var acceptOffers = Bool()
    var ordering = Bool()
    var watchBool = Bool()
    var currency_string = String()
    var currency_symbol = String()
    var admin_verify = String()
    
    
    init( itemkey : String ,itemAuctionType : String,visibility : Bool , startPrice : Int , quantity : Int ,chargeTime : Int64 , Image_0 : String , Image_1 : String , token : String , description : String ,uid : String , itemCategory : String , country_code : String , startTime : Int64 , maxBid : Int64 , askPrice : Int64 , winner : String , winner_uid : String , winner_bid : Int64 , timeRemaining : Int64 , conditionValue : String , title : String , watch_uid : String , watch_token : String , zipcode : String , condition : String, city : String, endTime : Int64 , id : String, state : String , autoReList : String , ItemImages : [String], latitude : Double , longtitude : Double ,ordering_status : Bool , company_name : String , benefits : String , payPeriod : String , jobToughness : String , employmentType : String , acceptOffers : Bool , ordering : Bool , watchingBool : Bool , OrderArray : [orderModel] , currency_string : String , currency_symbol : String , admin_verify : String) {
      
        self.OrderArray = OrderArray
        self.watchBool = watchingBool
        self.itemKey = itemkey
        self.itemAuctionType = itemAuctionType
        self.visibility = visibility
        self.startPrice = startPrice
        self.quantity = quantity
        self.chargeTime = chargeTime
        self.Image_0 = Image_0
        self.Image_1 = Image_1
        self.token = token
        self.description = description
        self.uid = uid
        self.itemCategory = itemCategory
        self.country_code = country_code
        self.startTime = startTime
        self.maxBid = maxBid
        self.askPrice = askPrice
        self.winner = winner
        self.winner_uid = winner_uid
        self.winner_bid = winner_bid
        self.timeRemaining = timeRemaining
        self.conditionValue = conditionValue
        self.title = title
        self.watch_uid = watch_uid
        self.watch_token = watch_token
        self.zipcode = zipcode
        self.conditionValue = conditionValue
        self.city = city
        self.endTime = endTime
        self.id = id
        self.state = state
        self.autoReList = autoReList
        self.condition = condition
        self.ItemImages = ItemImages
        self.latitude = latitude
        self.longtitude = longtitude
        self.ordering_status = ordering_status
        self.company_name = company_name
        self.employmentType = employmentType
        self.benefits = benefits
        self.payPeriod = payPeriod
        self.jobToughness = jobToughness
        self.acceptOffers = acceptOffers
        self.ordering = ordering
        self.currency_string = currency_string
        self.currency_symbol = currency_symbol
        self.admin_verify = admin_verify
    }
    
}
