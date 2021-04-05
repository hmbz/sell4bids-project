//
//  BidingHistoryCellVC.swift
//  Sell4Bids
//
//  Created by Admin on 02/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
class BidingHistoryCellVC: UITableViewCell {

    @IBOutlet weak var bidingUserName: UILabel!
    @IBOutlet weak var rateUserLabel: UILabel!
    @IBOutlet weak var bidPrice: UILabel!
    @IBOutlet weak var bidingContenView: UIView!
    @IBOutlet weak var bidingCardView: UIView!
    @IBOutlet weak var highestbidder: UILabel!
    @IBOutlet weak var lblCeilingAmount: UILabel!
    @IBOutlet weak var lblCeilingAmountStatic: UILabel!
    @IBOutlet weak var constraintBidNameToCenter: NSLayoutConstraint!
    @IBOutlet weak var constraintBidNameTopToHighestBidder: NSLayoutConstraint!
    @IBOutlet weak var seperateLbl: UILabel!
    @IBOutlet weak var celingLblHeight: NSLayoutConstraint!
    @IBOutlet weak var ceilingAmountHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUIForBiding(){
        bidingCardView.backgroundColor = UIColor.white
        bidingContenView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        bidingCardView.layer.cornerRadius = 3.0
        bidingCardView.layer.masksToBounds = false
        bidingCardView.layer.shadowColor = UIColor.black.cgColor
        bidingCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bidingCardView.layer.shadowOpacity = 0.4
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
