//
//  Product.swift
//  Sell4Bids
//
//  Created by H.M.Ali on 10/13/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

class Vehicles {
    
    var images: [UIImage]?
    var title: String
    var category: String
    var condition: String
    var conditionValue: Int
    var Made_in : String?
    var Year : String?
    var Trim : String?
    var OverallLenght : String?
    var HighwayMiles : String?
    var AntibrakeSystem : String?
    var Make : String?
    var Steering : String?
    var Cylinders : String?
    var Engine : String?
    var Model : String?
    var price: Int?
    var quantity: Int?
    var duration: Int
    var acceptOffer: String?
    var productType: String?
    var city: String
    var state: String
    var startingPrice: Int?
    var endPrice: Int?
    var currency_string : String?
    var currency_symbol : String?
    init(images: [UIImage]?,title: String, category: String,condition: String,conditionValue: Int,Made_in : String, Year : String , Trim : String , OverallLenght : String , HighwayMiles : String , AntibrakeSystem : String , Make : String , Steering : String , Cylinders : String , Engine : String ,Model : String ,price: Int?,quantity: Int?,duration: Int,acceptOffer: String?,productType: String?, city: String, state: String,startingPrice:Int?,endPrice:Int?,currency_string : String , currency_symbol : String) {
        self.images = images
        self.title = title
        self.category = category
        self.condition = condition
        self.conditionValue = conditionValue
        self.Made_in = Made_in
        self.Year = Year
        self.Trim = Trim
        self.OverallLenght = OverallLenght
        self.HighwayMiles = HighwayMiles
        self.AntibrakeSystem = AntibrakeSystem
        self.Make = Make
        self.Steering = Steering
        self.Cylinders = Cylinders
        self.Engine = Engine
        self.Model = Model
        self.price = price
        self.quantity = quantity
        self.duration = duration
        self.acceptOffer = acceptOffer
        self.productType = productType
        self.city = city
        self.state = state
        self.startingPrice = startingPrice
        self.endPrice = endPrice
        self.currency_string = currency_string
        self.currency_symbol = currency_symbol
    }
    
    
}
