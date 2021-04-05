//
//  watchListModel.swift
//  Sell4Bids
//
//  Created by admin on 2/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class watchListModel{
    
    var Latitude = Int()
    var Longitude = Int()
    var ItemId = String()
    var city = String()
    var title = String()
    var startPrice = Int()
    var startTime = Int()
    var oldSmallImage = [String]()
    var oldImage = [String]()
    var itemCategory = String()
    var zipCode = Int()
    var itemAuctionType = String()
    var uid = String()
    var condition = String()
    var endTime = Int()
    var quantity = String()
    var state = String()
    var currencyString = String()
    
    init(latitude : Int , longitude : Int, Itemid : String , city : String , title : String , startprice : Int , starttime : Int , oldsmallimage : [String] ,  oldimage : [String], itemcategory : String , zipcode : Int , itemauctiontype : String , condition : String  ,  endtime : Int , quantity : String , state : String , uid : String, currencyString: String) {
        
        self.uid = uid
        self.Latitude = latitude
        self.Longitude = longitude
        self.ItemId = Itemid
        self.city = city
        self.title = title
        self.startPrice = startprice
        self.startTime = starttime
        self.oldSmallImage = oldsmallimage
        self.oldImage = oldimage
        self.itemCategory = itemcategory
        self.zipCode = zipcode
        self.itemAuctionType = itemauctiontype
        self.condition = condition
        self.endTime = endtime
        self.quantity = quantity
        self.state = state
        self.currencyString = currencyString
    }
    
    
    
}
