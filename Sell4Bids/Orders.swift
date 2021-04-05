//
//  Orders.swift
//  Sell4Bids
//
//  Created by admin on 11/1/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
class OrderModel {
  var name:String?
  var boughtPrice:String?
  var boughtQuantity:String?
  var rating:String?
  var uid:String?
  var location: orderLocation?
  var sellerMarkedPaid : Bool = false
  
  init(name:String?,boughtPrice:String?,boughtQuantity:String?,rating:String?,uid:String?, sellerMarkedPaid : Bool = false) {
    self.name = name
    self.boughtPrice = boughtPrice
    self.boughtQuantity = boughtQuantity
    self.rating = rating
    self.uid = uid
    self.sellerMarkedPaid = sellerMarkedPaid
  }
}

struct orderLocation {
  
  let address: String
  let latitude : Double
  let longitude: Double
  let dictlatLong : [String:Any]
  
  
}

struct orderModel {
    public private(set) var orderId : String
    public private(set) var sellerId : String
    public private(set) var OfferCount : Int
    public private(set) var OfferArray : [offerModel]
}

struct offerModel {
    public private(set) var message :  String
    public private(set) var role : String
    public private(set) var price : String
    public private(set) var quantity : String
    public private(set) var time : String
}


