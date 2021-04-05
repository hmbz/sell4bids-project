//
//  Spinner.swift
//  Sell4Bids
//
//  Created by admin on 19/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

class Spinner {
    
    static func load_Spinner(image : UIImageView , view : UIView) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            image.loadGif(name: "red")
            image.isHidden = false
            view.isHidden = false
            
        }
        
    }
    
    
   static  func stop_Spinner(image : UIImageView , view : UIView) {
    
    
        image.isHidden = true
        view.isHidden = true
    

    }
}
