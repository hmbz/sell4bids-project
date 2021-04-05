//
//  productModelNew.swift
//  Sell4Bids
//
//  Created by admin on 8/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct ImageInfoModel {
    var height : Float?
    var ratio : Float?
    var width : Float?
    
    init(height: Float, ratio: Float, width: Float) {
        self.height = height
        self.ratio = ratio
        self.width = width
    }
}

class productModelNew {
    var status : Bool?
    var totalCount : Int?
    var coordinates : [Any]?
    var type :String?
    var ImagePath : [Any]?
    var ImagePathSmall : [Any]?
    var imageInfoArray : [ImageInfoModel]?
    var startTime : Int64?
    var visibility : Bool?
    var oldSmallImages : [Any]?
    var oldImages : [Any]?
    var itemId : String?
    var chargeTime : Int64?
    var city : String?
    var title : String?
    var startPrice : Float?
    var itemCategory : String?
    var zipcode : Int?
    var itemAuctionType :String?
    var uid : String?
    var condition :String?
    var endTime :Int64?
    var quantity :Int?
    var state :String?
    var currencyString :String?
    var currencySymbol : String?
    var itemImage : UIImageView?
    var adminRejected: String?
    
    init(status : Bool, totalCount: Int, coordinates : [Any], type: String,ImagePath:[Any],ImagePathSmall:[Any],imageInfoArray: [ImageInfoModel],startTime: Int64,visibility: Bool,oldSmallImages:[Any],oldImages:[Any],itemId:String,chargeTime:Int64,city: String,title: String, startPrice: Float, itemCategory: String, zipcode: Int, itemAuctionType: String, uid: String, condition: String, endTime: Int64, quantity: Int, state: String, currencyString: String, currencySymbol :String, adminRejected: String) {
        self.status = status
        self.totalCount = totalCount
        self.coordinates = coordinates
        self.type = type
        self.ImagePath = ImagePath
        self.ImagePathSmall = ImagePathSmall
        self.imageInfoArray = imageInfoArray
        self.startTime = startTime
        self.visibility = visibility
        self.oldSmallImages = oldSmallImages
        self.oldImages = oldImages
        self.itemId = itemId
        self.chargeTime = chargeTime
        self.city = city
        self.title = title
        self.startPrice = startPrice
        self.itemCategory = itemCategory
        self.zipcode = zipcode
        self.itemAuctionType = itemAuctionType
        self.uid = uid
        self.condition = condition
        self.endTime = endTime
        self.quantity = quantity
        self.state = state
        self.currencyString = currencyString
        self.currencySymbol = currencySymbol
        self.adminRejected = adminRejected
    }
    
}
