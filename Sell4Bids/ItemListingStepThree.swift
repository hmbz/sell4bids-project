//
//  ItemListingStepThree.swift
//  Sell4Bids
//
//  Created by admin on 06/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

var ListingStoryBoard = UIStoryboard.init(name: "ItemsSell", bundle: nil)

class ItemListingStepThree: UIViewController  {
    
    @IBOutlet weak var Change_View: UISegmentedControl!
    @IBOutlet weak var BuyNowandAuctionView: UIView!
    @IBAction func Segment_Value(_ sender: UISegmentedControl) {
          buyingView.view.frame = CGRect(x: 0, y: 0, width: BuyNowandAuctionView.frame.width, height: BuyNowandAuctionView.frame.height)
        AuctionView.view.frame = CGRect(x: 0, y: 0, width: BuyNowandAuctionView.frame.width, height: BuyNowandAuctionView.frame.height)
        
       BuyNowandAuctionView.addSubview(ArrayViewController[sender.selectedSegmentIndex].view)


    }
    
    var ArrayViewController = [UIViewController]()
    var Segement_Selected_Value = Int()
    var buyingView =  ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "Buying") as! ItemListingStepThreeContainerVC
    var AuctionView = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "Auction") as! ReservePriceListingStepThree
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Change_View.endEditing(true)
        BuyNowandAuctionView.endEditing(true)
        
        
        buyingView.view.frame = CGRect(x: 0, y: 0, width: BuyNowandAuctionView.frame.width, height: BuyNowandAuctionView.frame.height)
   

        ArrayViewController.append(buyingView)
        ArrayViewController.append(AuctionView)
      
        BuyNowandAuctionView.addSubview(ArrayViewController[0].view)
      
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

}
