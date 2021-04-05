//
//  Photo.swift
//  Sell4Bids
//
//  Created by admin on 12/19/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
    
    //MARK:- Properties
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bidNowBtn: DesignableButton!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryPriceLabel: UILabel!
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var ServiceTagtxt: UILabel!
    @IBOutlet weak var ServiceView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainBidNowBtn: UIButton!
    
    
    
    // MARK:- Cell LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        //   self.mainImageView.contentMode = .scaleToFill
        //self.containerView.fadeIn()
        
    }
    
    
    //TODO:- Set the Color of the Bid Button
    func setColorOfBidButton(model: Products) {
        print(model.item_category)
        print(model.item_auction_type)
        //[SERVICES]
        /*Services are always not dependent on Stock*/
        if model.item_category.lowercased() == "Services"{
            if model.item_endTime == 0 || model.item_endTime < -1 {
                self.mainBidNowBtn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }else {
                self.mainBidNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
        }
            
        //[BUY NOW]
        else if model.item_auction_type == "buy-it-now"{
            if model.item_endTime == -1 {
                self.mainBidNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
            if model.quantity == 0 && model.item_category != "Jobs" {
                self.mainBidNowBtn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
            if model.item_endTime == 0 || model.item_endTime < -1 {
                self.mainBidNowBtn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }

       //[AUCTION NOW]
        else if model.item_auction_type == "reserve" {
            if model.item_endTime < -1 {
                self.mainBidNowBtn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }else {
                self.mainBidNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
        }
        
        else if model.item_auction_type == "non-reserve" {
            if model.item_endTime < -1 {
                self.mainBidNowBtn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }else {
                self.mainBidNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
        }
    }
    
}
