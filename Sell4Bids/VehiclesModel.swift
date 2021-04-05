//
//  VehiclesModel.swift
//  Sell4Bids
//
//  Created by Admin on 01/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class VehiclesModel {
    
    var year = String()
    var make = String()
    var model = String()
    var trim = String()
    var millage = String()
    var fuel_type = String()
    var color = String()
    
    
    init(year: String , make : String , model : String , trim : String , millage : String ,fuel_type : String , color : String) {
        
        self.year = year
        self.make = make
        self.model = model
        self.trim = trim
        self.millage = millage
        self.fuel_type = fuel_type
        self.color = color
       
        
    }
}
