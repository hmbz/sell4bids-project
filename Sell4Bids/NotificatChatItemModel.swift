//
//  NotificatChatItemModel.swift
//  Sell4Bids
//
//  Created by admin on 23/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class NotifcatChatItemModel {
    
    var itemAuctionType : String?
    var itemCategory : String?
    var itemID : String?
    var itemImage : String?
    var itemState : String?
    var itemTitle : String?
    
    init(itemAuctionType : String ,itemCategory : String , itemID : String , itemImage : String , itemState : String , itemTitle : String  ) {
        self.itemAuctionType = itemAuctionType
        self.itemID = itemID
        self.itemCategory = itemCategory
        self.itemImage = itemImage
        self.itemState = itemState
        self.itemTitle = itemTitle
        
    }
    
}

