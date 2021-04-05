//
//  UserProfileTableViewCell.swift
//  Sell4Bids
//
//  Created by admin on 7/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos

class UserProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var cardview: UIView!
    @IBOutlet weak var sellerImg: UIImageView!
    @IBOutlet weak var sellerNameLbl: UILabel!
    @IBOutlet weak var ratingControl: CosmosView!
    @IBOutlet weak var ratingLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
