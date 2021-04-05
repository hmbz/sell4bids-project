//
//  JobDetails.swift
//  Sell4Bids
//
//  Created by admin on 20/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
class JobDetails {
    
    var employmentType = String()
    var autoReList = Bool()
    var itemAuctionType = String()
    var old_images = [String]()
    var payPeriod = String()
    var state = String()
    var companyName = String()
    var startPrice = Int64()
    var image = [String]()
    var acceptOffers = Bool()
    var zipcode = String()
    var quantity = Int64()
    var description = String()
    var startTime = Int64()
    var jobCategory = String()
    var chargeTime = Int64()
    var city = String()
    var latitude = Double()
    var longtitude = Double()
    var itemKey = String()
    var companyDescription = String()
    var visibility = Bool()
    var condition = String()
    var uid = String()
    var country_code = String()
    var id = String()
    var timeRemaining = Int64()
    var conditionValue = Int()
    var endTime = Int64()
    var token = String()
    var itemCategory = String()
    var title = String()
    var medical = String()
    var PTO = String()
    var FZOK = String()
    var Experience = String()
    var userName = String()
    var watchBool = Bool()
    var watch_uid = String()
    var watch_token = String()
    var jobApplied = Bool()
    var currency_string = String()
    var currency_symbol = String()
    var admin_verify = String()
    
    
    
    init(employmentType : String , autoReList : Bool , itemAuctionType : String ,old_images : [String] , payPeriod : String , state : String , companyName : String , startPrice : Int64 , image : [String] , acceptOffers : Bool , zipcode : String , quantity : Int64 , description : String , startTime : Int64 ,jobCategory : String , chargeTime : Int64 , city : String , latitude : Double , longtitude : Double , itemKey : String , companyDescription : String , visibility : Bool , condition : String , uid : String , country_code : String , id : String , timeRemaining : Int64 , conditionValue : Int , endTime : Int64 , token : String , itemCategory : String , title : String , medical : String , PTO : String , FZOK : String , Experience : String , userName : String, watchBool : Bool, watch_uid : String, watch_token : String , jobApplied : Bool , currency_string : String , currency_symbol : String , admin_verify : String) {
        
        self.employmentType = employmentType
        self.autoReList = autoReList
        self.itemAuctionType = itemAuctionType
        self.old_images = old_images
        self.payPeriod = payPeriod
        self.state = state
        self.companyName = companyName
        self.startTime = startTime
        self.image = image
        self.acceptOffers = acceptOffers
        self.zipcode = zipcode
        self.quantity = quantity
        self.city = city
        self.latitude = latitude
        self.longtitude = longtitude
        self.itemKey = itemKey
        self.companyDescription = companyDescription
        self.visibility = visibility
        self.condition = condition
        self.uid = uid
        self.country_code = country_code
        self.id = id
        self.timeRemaining = timeRemaining
        self.conditionValue = conditionValue
        self.endTime = endTime
        self.token = token
        self.itemCategory = itemCategory
        self.title = title
        self.description = description
        self.medical = medical
        self.PTO = PTO
        self.FZOK = FZOK
        self.Experience = Experience
        self.userName = userName
        self.jobCategory = jobCategory
        self.watchBool = watchBool
        self.watch_uid = watch_uid
        self.watch_token = watch_token
        self.startPrice = startPrice
        self.chargeTime = chargeTime
        self.jobApplied = jobApplied
        self.currency_string = currency_string
        self.currency_symbol = currency_symbol
        self.admin_verify = admin_verify
    }
    
    
}
