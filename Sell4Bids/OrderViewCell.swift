//
//  OrderViewCell.swift
//  Sell4Bids
//
//  Created by admin on 11/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos

class OrderViewCell: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var BuyerName: UILabel!
    @IBOutlet weak var ItemQuantity_Price: UILabel!
    @IBOutlet weak var RattingDetailView: UIStackView!
    @IBOutlet weak var RattingView: CosmosView!
    @IBOutlet weak var RattingLabel: UILabel!
    @IBOutlet weak var BuyerAcceptAndRejectBtns: UIStackView!
    @IBOutlet weak var ShareLocation: UIButton!
    @IBOutlet weak var MarkPaid: UIButton!
    @IBOutlet weak var BuyerPaidStatusView: UIStackView!
    @IBOutlet weak var SellerPaidRecived: UIView!
    @IBOutlet weak var SellerTicImg: UIImageView!
    @IBOutlet weak var SellerPaidtxt: UILabel!
    @IBOutlet weak var BuyerItemRecivedView: UIView!
    @IBOutlet weak var BuyerItemRecivedTic: UIImageView!
    @IBOutlet weak var BuyerItemReviedTxt: UILabel!
    @IBOutlet weak var AcceptOrRejectBtnsView: UIStackView!
    @IBOutlet weak var AcceptOrder: UIButton!
    @IBOutlet weak var RejectOrder: UIButton!
    @IBOutlet weak var RejectedView: UIStackView!
    @IBOutlet weak var RejectedStatustxt: UILabel!
    @IBOutlet weak var locationtxt: UILabel!
    @IBOutlet weak var actualPriceLbl: UILabel!
    @IBOutlet weak var actualNameLbl: UILabel!
  @IBOutlet weak var chatBtn:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RattingView.rating = 0
//   contentView.cardViewBorder()
        cardView.shadowView()
        cardView.layer.cornerRadius = 6
   
   AcceptOrder.shadowView()
        AcceptOrder.layer.cornerRadius = 18
   RejectOrder.shadowView()
        RejectOrder.layer.cornerRadius = 18
      chatBtn.shadowView()
      chatBtn.layer.cornerRadius = 18
   ShareLocation.shadowView()
        ShareLocation.layer.cornerRadius = 20
   MarkPaid.shadowView()
        MarkPaid.layer.cornerRadius = 20
 
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
