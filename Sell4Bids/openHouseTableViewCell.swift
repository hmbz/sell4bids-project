//
//  openHouseTableViewCell.swift
//  Sell4Bids
//
//  Created by admin on 12/13/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class openHouseTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkImg.layer.cornerRadius = 6
        checkImg.layer.borderWidth = 1.0
        checkImg.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        checkImg.layer.masksToBounds = true
    }

}
