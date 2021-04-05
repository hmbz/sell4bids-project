//
//  Products.swift
//  Sell4Bids
//
//  Created by admin on 2/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import SDWebImage

class Products {
    var total_count = Int()
    var status = Bool()
    var quantity = Double()
    var item_id = String()
    var old_images = [String]()
    var item_title = String()
    var item_category = String()
    var item_zipcode = String()
    var item_latitude = Double()
    var item_longtitude = Double()
    var item_seller_id = String()
    var item_start_time = Int64()
    var old_small_images = [String]()
    var item_auction_type = String()
    var item_condition = String()
    var item_endTime = Int64()
    var item_city = String()
    var item_state = String()
    var item_startPrice = Double()
    var item_image = UIImageView()
    var item_image_height = Float()
    var item_image_width = Float()
    var item_image_ratio = Float()
    var currency_string = String()
    var currency_symbol = String()
    var isListingEnded = Bool()
    
    
    init(total_count : Int , status : Bool , quantity : Double , item_id : String , old_images : [String] ,  item_title : String , item_category : String , item_zipcode : String , item_latitude : Double ,  item_longtitude : Double ,  item_seller_id : String , item_start_time : Int64 , old_small_images : [String] ,item_auction_type : String, item_condition : String ,  item_endTime : Int64 , item_city : String ,  item_state : String , item_startPrice : Double , currency_symbol : String , currency_string : String, isListingEnded: Bool) {
        
        self.total_count = total_count
        self.status = status
        self.quantity = quantity
        self.item_id = item_id
        self.old_images = old_images
        self.item_title = item_title
        self.item_category = item_category
        self.item_zipcode = item_zipcode
        self.item_longtitude = item_longtitude
        self.item_latitude = item_latitude
        self.item_seller_id = item_seller_id
        self.item_start_time = item_start_time
        self.old_small_images = old_images
        self.item_auction_type = item_auction_type
        self.item_condition = item_condition
        self.item_endTime = item_endTime
        self.item_city = item_city
        self.item_state = item_state
        self.item_startPrice = item_startPrice
        self.currency_string = currency_string
        self.currency_symbol = currency_symbol
        self.isListingEnded = isListingEnded
        
        
    }
    
}
