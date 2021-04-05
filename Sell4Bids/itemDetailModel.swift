//
//  itemDetailModel.swift
//  Sell4Bids
//
//  Created by admin on 11/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

// Model for Item Detail
struct itemDetailModel {
    public private(set) var watchlistStatus :Bool?
    public private(set) var status :Bool?
    public private(set) var sellerIsBlocked :Bool?
    public private(set) var unauthorized :Bool?
    // ID's Used in the Data
    public private(set) var itemId :String?
    public private(set) var uid :String?
    // Set Data on Data
    public private(set) var startPrice :Int?
    public private(set) var condition :String?
    public private(set) var imagePath :Array<Any>?
    public private(set) var imagePathSmall :Array<Any>?
    public private(set) var title :String?
    public private(set) var itemCategory :String?
    public private(set) var quantity :Int?
    public private(set) var description :String?
    // Curency
    public private(set) var currencyString :String?
    public private(set) var currenySymbol :String?
    // Time Used
    public private(set) var chargeTime :Int64?
    public private(set) var startTime :Int64?
    public private(set) var endTime :Int64?
    // Location
    public private(set) var city :String?
    public private(set) var zipCode :Int?
    public private(set) var state :String?
    public private(set) var countryCode :String?
    public private(set) var longitude :Double?
    public private(set) var latitude :Double?
    //For Condition
    public private(set) var itemAuctionType :String?
    public private(set) var acceptOffers :Bool?
    public private(set) var ordering :Bool?
    public private(set) var visibility :Bool?
    public private(set) var autoReList :Bool?
    public private(set) var platform :String?
    public private(set) var listingEnded :Bool?
    public private(set) var autoListingCount :Int?
    public private(set) var adminVerify :String?
    // Offer Order
    public private(set) var orderArray = [orderModel]()
    public private(set) var offerArray = [offerModel]()
}

// Model for Vehicle Detail
struct vehicleDetailModel {
    public private(set) var watchlistStatus :Bool?
    public private(set) var status :Bool?
    public private(set) var sellerIsBlocked :Bool?
    public private(set) var unauthorized :Bool?
    // ID's Used in the Data
    public private(set) var itemId :String?
    public private(set) var uid :String?
    // Set Data on Data
    public private(set) var startPrice :Int?
    public private(set) var condition :String?
    public private(set) var imagePath :Array<Any>?
    public private(set) var imagePathSmall :Array<Any>?
    public private(set) var title :String?
    public private(set) var itemCategory :String?
    public private(set) var quantity :Int?
    public private(set) var description :String?
    // Vehicle Detail
    public private(set) var year :Int?
    public private(set) var make :String?
    public private(set) var color :String
    public private(set) var trim :String?
    public private(set) var model :String?
    public private(set) var fuelType :String?
    public private(set) var milesDriven :Int64?
    // Curency
    public private(set) var currencyString :String?
    public private(set) var currenySymbol :String?
    // Time Used
    public private(set) var chargeTime :Int64?
    public private(set) var startTime :Int64?
    public private(set) var endTime :Int64?
    // Location
    public private(set) var city :String?
    public private(set) var zipCode :Int?
    public private(set) var state :String?
    public private(set) var countryCode :String?
    public private(set) var longitude :Double?
    public private(set) var latitude :Double?
    //For Condition
    public private(set) var itemAuctionType :String?
    public private(set) var acceptOffers :Bool?
    public private(set) var ordering :Bool?
    public private(set) var visibility :Bool?
    public private(set) var autoReList :Bool?
    public private(set) var platform :String?
    public private(set) var listingEnded :Bool?
    public private(set) var autoListingCount :Int?
    public private(set) var adminVerify :String?
    // Offer Order
    public private(set) var orderArray = [orderModel]()
    public private(set) var offerArray = [offerModel]()
}

// Model for Housing Details
struct housingDetailModel {
    // Universal Checks
    public private(set) var watchlistStatus :Bool?
    public private(set) var sellerIsBlocked :Bool?
    public private(set) var status :Bool?
    public private(set) var unauthorized :Bool?
    // All Id's Used in Model
    public private(set) var uid :String?
    public private(set) var itemId :String?
    // Time
    public private(set) var startTime :Int64?
    public private(set) var chargeTime :Int64?
    public private(set) var endTime :Int64?
    // Data to Display in every Detail
    public private(set) var title :String?
    public private(set) var startPrice :Int?
    public private(set) var quantity :Int?
    public private(set) var description :String?
    public private(set) var itemCategory :String?
    public private(set) var imagesPath :Array<Any>?
    public private(set) var imagePathSmall :Array<Any>?
    // Data to Display Specific to Housing
    public private(set) var bedrooms :Int?
    public private(set) var noSmoking :Bool?
    public private(set) var wheelChairAccess :Bool?
    public private(set) var parking :String?
    public private(set) var petsAccepted :Bool?
    public private(set) var housingType :String?
    public private(set) var availableOn : Int64?
    public private(set) var openHouseDate :Array<Any>?
    public private(set) var bathrooms :Int?
    public private(set) var housingCategory :String?
    public private(set) var furnished :Bool?
    public private(set) var laundry :String?
    public private(set) var squareFeet :Double?
    // Currency Strings
    public private(set) var currencyString :String?
    public private(set) var currencySymbol :String?
    // Item Location
    public private(set) var state :String?
    public private(set) var longitude :Double?
    public private(set) var latitude :Double?
    public private(set) var countryCode :String?
    public private(set) var zipCode :Int?
    public private(set) var city :String?
    // for Conditions
    public private(set) var itemAuctionType :String?
    public private(set) var visibility :Bool?
    public private(set) var isExpiredNotified :Bool?
    public private(set) var autoListingCount :Int?
    public private(set) var acceptOffers :Bool?
    public private(set) var ordering :Bool?
    public private(set) var listingEnded :Bool?
    public private(set) var autoReList :Bool?
    public private(set) var adminVerify :String?
    public private(set) var platform :String?
    // Offer Order
    public private(set) var offerArray = [offerModel]()
    public private(set) var orderArray = [orderModel]()
}

// Model for Services
struct serviceDetailModel {
    public private(set) var watchlistStatus :Bool?
    public private(set) var status :Bool?
    public private(set) var sellerIsBlocked :Bool?
    public private(set) var unauthorized :Bool?
    // ID's Used in the Data
    public private(set) var itemId :String?
    public private(set) var uid :String?
    // Set Data on Data
    public private(set) var startPrice :Int?
    public private(set) var condition :String?
    public private(set) var imagePath :Array<Any>?
    public private(set) var imagePathSmall :Array<Any>?
    public private(set) var title :String?
    public private(set) var itemCategory :String?
    public private(set) var quantity :Int?
    public private(set) var description :String?
    // Service Data
    public private(set) var  serviceType :String?
    public private(set) var  userRole :String?
    // Curency
    public private(set) var currencyString :String?
    public private(set) var currenySymbol :String?
    // Time Used
    public private(set) var chargeTime :Int64?
    public private(set) var startTime :Int64?
    public private(set) var endTime :Int64?
    // Location
    public private(set) var city :String?
    public private(set) var zipCode :Int?
    public private(set) var state :String?
    public private(set) var countryCode :String?
    public private(set) var longitude :Double?
    public private(set) var latitude :Double?
    //For Condition
    public private(set) var itemAuctionType :String?
    public private(set) var acceptOffers :Bool?
    public private(set) var ordering :Bool?
    public private(set) var visibility :Bool?
    public private(set) var autoReList :Bool?
    public private(set) var platform :String?
    public private(set) var listingEnded :Bool?
    public private(set) var autoListingCount :Int?
    public private(set) var adminVerify :String?
    // Offer Order
    public private(set) var orderArray = [orderModel]()
    public private(set) var offerArray = [offerModel]()
}

//Model for Job Detail
struct jobsDetailModel {
    public private(set) var watchlistStatus :Bool?
    public private(set) var status :Bool?
    public private(set) var sellerIsBlocked :Bool?
    public private(set) var unauthorized :Bool?
    public private(set) var jobApplied :Bool?
    // ID's Used in the Data
    public private(set) var itemId :String?
    public private(set) var uid :String?
    // Set Data on Data
    public private(set) var startPrice :Int?
    public private(set) var condition :String?
    public private(set) var imagePath :Array<Any>?
    public private(set) var imagePathSmall :Array<Any>?
    public private(set) var title :String?
    public private(set) var itemCategory :String?
    public private(set) var quantity :Int?
    public private(set) var description :String?
    //Job Sepecific data
    public private(set) var jobExperience :String?
    public private(set) var companyDescription :String?
    public private(set) var companyName :String?
    public private(set) var employmentType :String?
    public private(set) var payPeriod :String?
    public private(set) var jobCategory :String?
    public private(set) var benefitsArray :Array<Any>?
    // Curency
    public private(set) var currencyString :String?
    public private(set) var currenySymbol :String?
    // Time Used
    public private(set) var chargeTime :Int64?
    public private(set) var startTime :Int64?
    public private(set) var endTime :Int64?
    // Location
    public private(set) var city :String?
    public private(set) var zipCode :Int?
    public private(set) var state :String?
    public private(set) var countryCode :String?
    public private(set) var longitude :Double?
    public private(set) var latitude :Double?
    //For Condition
    public private(set) var itemAuctionType :String?
    public private(set) var acceptOffers :Bool?
    public private(set) var ordering :Bool?
    public private(set) var visibility :Bool?
    public private(set) var autoReList :Bool?
    public private(set) var platform :String?
    public private(set) var listingEnded :Bool?
    public private(set) var autoListingCount :Int?
    public private(set) var adminVerify :String?
    // Offer Order
    public private(set) var orderArray = [orderModel]()
    public private(set) var offerArray = [offerModel]()
}



