//
//  sellingModel.swift
//  Sell4Bids
//
//  Created by admin on 2/13/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct drawerModel {
    let name: String?
    let image: UIImage?
}

class sellingModel{
    
    var id = String()
    var coordinates = [Double]()
    var chargeTime = Int64()
    var images_path = [String]()
    var images_small_path = [String]()
    var height = [Double]()
    var widht = [Double]()
    var ratio = [Double]()
    var startTime = Int64()
    var visibility = Bool()
    var ordering = Bool()
    var listingEnded = Bool()
    var old_small_images = [String]()
    var old_images = [String]()
    var image = [String]()
    var token = String()
    var country_code = String()
    var city = String()
    var title = String()
    var startPrice = Int()
    var itemCategory = String()
    var itemAuctionType = String()
    var uid = String()
    var condition = String()
    var conditionValue = String()
    var description = String()
    var endTime = Int64()
    var currency_string = String()
    var currency_symbol = String()
    var autoReList = Bool()
    var acceptOffers = Bool()
    var quantity = Int()
    var platform = String()
    var item_id = String()
    var state = String()
    var companyName = String()
    var companyDescription = String()
    var jobCategory = String()
    var payPeriod = String()
    var employmentType = String()
    var reservePrice = String()
    var timeRemaining = Int64()
    var userRole = String()
    var negotiable = Bool()
    var serviceType = String()
    var servicePrice = String()
    var year = String()
    var make = String()
    var model = String()
    var trim = String()
    var milesDriven = String()
    var fuelType = String()
    var color = String()
    var latitude = Double()
    var longtitude = Double()
    var itemKey = String()
    var watchBool = Bool()
    var watch_uid = String()
    var watch_token = String()
    var zipcode = String()
    var medical = String()
    var PTO = String()
    var FZOK = String()
    var OrderArray = [orderModel]()
    var admin_verify = String()
    
    
    init(id : String ,coordinates : [Double] , chargeTime : Int64 , images_path : [String] , images_small_path : [String] , height : [Double] , widht : [Double] , ratio : [Double] , startTime : Int64 , visibility : Bool , ordering : Bool , listingEnded : Bool , old_small_images : [String] , old_images : [String] , token : String , country_code : String , city : String , title : String ,  startPrice : Int , itemCategory : String ,    itemAuctionType : String ,uid : String , condition : String , description : String , endTime : Int64 , currency_string : String ,  currency_symbol : String , autoReList : Bool , acceptOffers : Bool , quantity : Int , platform : String , item_id : String , state : String , timeRemaining : Int64 , zipcode : String , OrderArray : [orderModel] , admin_verify : String) {
        
        self.zipcode = zipcode
        self.id = id
        self.coordinates = coordinates
        self.chargeTime = chargeTime
        self.images_path = images_path
        self.images_small_path = images_small_path
        self.height = height
        self.widht = widht
        self.ratio = ratio
        self.startTime = startTime
        self.visibility = visibility
        self.ordering = ordering
        self.listingEnded = listingEnded
        self.old_small_images = old_small_images
        self.old_images = old_images
        self.token = token
        self.country_code = country_code
        self.city = city
        self.title = title
        self.startPrice = startPrice
        self.itemCategory = itemCategory
        self.itemAuctionType = itemAuctionType
        self.uid = uid
        self.condition = condition
        self.description = description
        self.endTime = endTime
        self.timeRemaining = timeRemaining
        self.quantity = quantity
        self.acceptOffers = acceptOffers
        self.autoReList = autoReList
        self.OrderArray = OrderArray
        self.currency_string = currency_string
        self.currency_symbol = currency_symbol
        self.admin_verify = admin_verify
    }
    
    
    init(id : String ,coordinates : [Double] , chargeTime : Int64 , images_path : [String] , images_small_path : [String] , height : [Double] , widht : [Double] , ratio : [Double] , startTime : Int64 , visibility : Bool , ordering : Bool , listingEnded : Bool , old_small_images : [String] , old_images : [String] , token : String , country_code : String , city : String , title : String ,  startPrice : Int , itemCategory : String ,uid : String , condition : String , description : String , endTime : Int64 , currency_string : String ,  currency_symbol : String , autoReList : Bool , acceptOffers : Bool , quantity : Int , platform : String , item_id : String , state : String , companyName : String , companyDescription : String , jobCategory : String , payPeriod : String , employmentType : String ,timeRemaining : Int64 , zipcode : String , medical: String , PTO: String , FZOK: String , itemAuctionType : String , admin_verify : String) {
        
        self.zipcode = zipcode
        self.companyName = companyName
        self.companyDescription = companyDescription
        self.jobCategory = jobCategory
        self.payPeriod = payPeriod
        self.employmentType = employmentType
        self.quantity = quantity
        self.platform = platform
        self.id = id
        self.coordinates = coordinates
        self.chargeTime = chargeTime
        self.images_path = images_path
        self.images_small_path = images_small_path
        self.height = height
        self.widht = widht
        self.ratio = ratio
        self.startTime = startTime
        self.visibility = visibility
        self.ordering = ordering
        self.listingEnded = listingEnded
        self.old_small_images = old_small_images
        self.old_images = old_images
        self.token = token
        self.country_code = country_code
        self.city = city
        self.title = title
        self.startPrice = startPrice
        self.itemCategory = itemCategory
        self.uid = uid
        self.condition = condition
        self.description = description
        self.endTime = endTime
        self.timeRemaining = timeRemaining
        self.medical = medical
        self.PTO = PTO
        self.FZOK = FZOK
        self.acceptOffers = acceptOffers
        self.autoReList = autoReList
        self.currency_string = currency_string
        self.currency_symbol = currency_symbol
        self.itemAuctionType = itemAuctionType
        self.admin_verify = admin_verify
        
    }
    
    init(id : String , latitude : Double , longtitude : Double , chargeTime : Int64 , images_path : [String] , images_small_path : [String] , startTime : Int64 , visibility : Bool , old_small_images : [String] , image : [String] , token : String , country_code : String , city : String , title : String , startPrice : Int , itemCategory : String  ,uid : String ,  description : String , endTime : Int64 , currency_string : String ,  currency_symbol : String , autoReList : Bool , acceptOffers : Bool , platform : String , item_id : String , state : String  , userRole : String , negotiable : Bool , serviceType : String , servicePrice : String , timeRemaining : Int64 , ordering : Bool , quantity : Int , zipcode : String , OrderArray : [orderModel] , itemAuctionType : String , admin_verify : String) {
        
        self.zipcode = zipcode
        self.userRole = userRole
        self.negotiable = negotiable
        self.serviceType = serviceType
        self.servicePrice = servicePrice
        self.platform = platform
        self.id = id
        self.longtitude = longtitude
        self.latitude = latitude
        self.chargeTime = chargeTime
        self.images_path = images_path
        self.images_small_path = images_small_path
        self.image = image
        self.startTime = startTime
        self.visibility = visibility
        self.old_small_images = old_small_images
        self.token = token
        self.country_code = country_code
        self.city = city
        self.title = title
        self.startPrice = startPrice
        self.itemCategory = itemCategory
        self.uid = uid
        self.description = description
        self.endTime = endTime
        self.timeRemaining = timeRemaining
        self.item_id = item_id
        self.ordering = ordering
        self.quantity = quantity
        self.acceptOffers = acceptOffers
        self.autoReList = autoReList
        self.OrderArray = OrderArray
        self.currency_string = currency_string
        self.currency_symbol = currency_symbol
        self.itemAuctionType = itemAuctionType
        self.admin_verify = admin_verify
    }
    
    init(id : String , chargeTime : Int64 , images_path : [String] , images_small_path : [String] , startTime : Int64 , visibility : Bool , ordering : Bool , old_small_images : [String] , token : String , country_code : String , city : String , title : String ,  startPrice : Int , itemCategory : String , itemAuctionType : String , uid : String , condition : String , conditionValue : String , description : String , endTime : Int64 , currency_string : String ,  currency_symbol : String , autoReList : Bool , acceptOffers : Bool ,  platform : String , item_id : String , state : String , timeRemaining : Int64 , year : String , make : String , model : String , trim : String , milesDriven : String , fuelType : String , color : String , latitude : Double , longtitude : Double , image : [String], watchBool : Bool, watch_uid : String, watch_token : String , itemKey : String , quantity : Int , zipcode : String , OrderArray : [orderModel] , admin_verify : String){
        
        self.zipcode = zipcode
        self.id = id
        self.itemKey = itemKey
        self.latitude = latitude
        self.longtitude = longtitude
        self.chargeTime = chargeTime
        self.image = image
        self.images_path = images_path
        self.images_small_path = images_small_path
        self.conditionValue = conditionValue
        self.startTime = startTime
        self.visibility = visibility
        self.ordering = ordering
        self.old_small_images = old_small_images
        self.token = token
        self.country_code = country_code
        self.city = city
        self.title = title
        self.startPrice = startPrice
        self.itemCategory = itemCategory
        self.itemAuctionType = itemAuctionType
        self.uid = uid
        self.condition = condition
        self.description = description
        self.endTime = endTime
        self.timeRemaining = timeRemaining
        self.year = year
        self.make = make
        self.model = model
        self.trim = trim
        self.milesDriven = milesDriven
        self.fuelType = fuelType
        self.color = color
        self.watchBool = watchBool
        self.watch_uid = watch_uid
        self.watch_token = watch_token
        self.quantity = quantity
        self.acceptOffers = acceptOffers
        self.autoReList = autoReList
        self.OrderArray = OrderArray
        self.currency_string = currency_string
        self.currency_symbol = currency_symbol
        self.admin_verify = admin_verify
    }
    
}
