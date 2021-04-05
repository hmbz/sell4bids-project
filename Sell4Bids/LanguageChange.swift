//
//  LanguageChange.swift
//  Sell4Bids
//
//  Created by admin on 1/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class LanguageChange{
    
    func languageChangeAction(strLng:String){
     //   HelloTxt.text = "helloText".localizableString(loc: strLng)
//WorldTxt.text = "worldText".localizableString(loc: strLng)
    }
    
    
}


extension String{
    
    func localizableString(loc:String) -> String {
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
      
  }
}

extension UILabel{
    
    func rightAlign(LanguageCode : String){
        if LanguageCode == "ur-PK"{
            self.textAlignment = .right
        }else if LanguageCode == "en"{
            self.textAlignment = .left
        }
    }
    
}
