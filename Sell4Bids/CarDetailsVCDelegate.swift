//
//  CarDetailsVCDelegate.swift
//  Sell4Bids
//
//  Created by Admin on 17/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

protocol CarDetailsVCDelegate{
    
    func CarDetailsVCTapped(getModelValue: String, getMakeValue: String, getYearValue: String, getTrimValue : String , getkmdDrivevalue: String, getfuelTypevalue: String, getColorvalue: String)
    
}
