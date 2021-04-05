//
//  OfferTableViewCell.swift
//  Sell4Bids
//
//  Created by admin on 7/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos

class OfferTableViewCell: UITableViewCell {

    //MARK:- Properties
    @IBOutlet weak var userStackView: UIStackView!
    @IBOutlet weak var actualStackView: UIStackView!
    @IBOutlet weak var sellerStackView: UIStackView!
    @IBOutlet weak var buyerStackview: UIStackView!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var offerTypeLbl: UILabel!
    @IBOutlet weak var auctualLbl: UILabel!
    @IBOutlet weak var actualPriceLbl: UILabel!
    @IBOutlet weak var sellerNameLbl: UILabel!
    @IBOutlet weak var sellerPriceLbl: UILabel!
    @IBOutlet weak var buyerNameLbl: UILabel!
    @IBOutlet weak var buyerPriceLbl: UILabel!
    @IBOutlet weak var ratingControl: CosmosView!
    @IBOutlet weak var rateUsBtn: UIButton!
    @IBOutlet weak var acceptRejectStackView: UIStackView!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var counterBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var rejectStatusLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var shareLocationBtn: UIButton!
    @IBOutlet weak var paidBtn: UIButton!
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var paidStackView: UIStackView!
    @IBOutlet weak var sellerPaid: UIView!
    @IBOutlet weak var buyerPaid: UIView!
    @IBOutlet weak var cardView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.shadowView()
        acceptBtn.shadowView()
        rejectBtn.shadowView()
        rateUsBtn.shadowView()
        counterBtn.shadowView()
        historyBtn.shadowView()
        shareLocationBtn.shadowView()
        paidBtn.shadowView()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
