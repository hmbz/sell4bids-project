//
//  BidingHistoryModel.swift
//  Sell4Bids
//
//  Created by Admin on 02/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class BiddingHistory{
    
    var Bid_Amount =  String()
    var image = String()
    var _id = String()
    var totalRating = Double()
    var averageRating = Double()
    var name = String()
    
    
    init(Bid_Amount : String , image : String , _id : String , totalRating : Double , averageRating : Double , name : String) {
        
        self.Bid_Amount = Bid_Amount
        self.image = image
        self._id = _id
        self.totalRating = totalRating
        self.averageRating = averageRating
        self.name = name
        
    }
}

struct userModelForBidding {
    let itemId :String?
    let bidAmount :String?
    let userImg :String?
    let userName :String?
    let userTotalRatings :Int?
    let userId :String?
    let userAverageRating :Float?
}

struct biddingHistoryModel {
    public private(set) var totalCount:Int?
    public private(set) var maxBid :String?
    public private(set) var status :Bool?
    public private(set) var winner :String?
    public private(set) var userDetails = [userModelForBidding]()
    
}
