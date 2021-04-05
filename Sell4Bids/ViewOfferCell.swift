//
//  ViewOfferCell.swift
//  Sell4Bids
//
//  Created by admin on 27/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos

class ViewOfferCell: UITableViewCell {

    
    //MARK:- Properties
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var OfferDetailView: UIStackView!
    @IBOutlet weak var RattingDetailView: UIStackView!
    @IBOutlet weak var BuyerAcceptRejectBtnView: UIStackView!
    @IBOutlet weak var remaingOfferLbl: UILabel!
    
    @IBOutlet weak var BuyerandSellerPaidView: UIStackView!
    @IBOutlet weak var RejectStatusView: UIStackView!
    @IBOutlet weak var BuyerAcceptRejectCounterView: UIStackView!
    @IBOutlet weak var sellerNameLbl: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var Ratting: CosmosView!
    @IBOutlet weak var RattingLabel: UILabel!
    @IBOutlet weak var AcceptOrder: UIButton!
    @IBOutlet weak var RejectOrder: UIButton!
    @IBOutlet weak var RejectedStatuslbl: UILabel!
    @IBOutlet weak var SendCounterOffer: UIButton!
    @IBOutlet weak var ShareLocationbtn: UIButton!
    @IBOutlet weak var MarkasPaidbtn: UIButton!
    @IBOutlet weak var Chat: UIButton!
    @IBOutlet weak var SellerPaidView: UIView!
    @IBOutlet weak var BuyerItemRecivedView: UIView!
    @IBOutlet weak var SellerPaidTic: UIImageView!
    @IBOutlet weak var SellerPaidLbl: UILabel!
    @IBOutlet weak var AcceptRejectOfferHistorybtn: UIButton!
    @IBOutlet weak var ViewHIstorybtn: UIButton!
    @IBOutlet weak var BuyerItemTic: UIImageView!
    @IBOutlet weak var BuyerItemLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var buyerNameLbl: UILabel!
    @IBOutlet weak var buyerOfferPriceLbl: UILabel!
    @IBOutlet weak var buyerOfferStackView: UIStackView!
    @IBOutlet weak var youOfferLbl: UILabel!
    @IBOutlet weak var yourOfferPriceLbl: UILabel!
    @IBOutlet weak var yourOfferStack: UIStackView!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var shareLocationLbl: UILabel!
    @IBOutlet weak var acceptRejectStack: UIStackView!
    
    
    //MARK:- Cell Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        AcceptOrder.shadowView()
        AcceptOrder.layer.cornerRadius = 20
        RejectOrder.shadowView()
        RejectOrder.layer.cornerRadius = 20
        ShareLocationbtn.shadowView()
        ShareLocationbtn.layer.cornerRadius = 20
        SendCounterOffer.shadowView()
        SendCounterOffer.layer.cornerRadius = 20
        MarkasPaidbtn.shadowView()
        MarkasPaidbtn.layer.cornerRadius = 20
        Chat.shadowView()
        Chat.layer.cornerRadius = 20
        AcceptRejectOfferHistorybtn.shadowView()
        AcceptRejectOfferHistorybtn.layer.cornerRadius = 20
   
        cardView.shadowView()
        cardView.layer.cornerRadius = 5
        // Initialization code
    }

  override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
