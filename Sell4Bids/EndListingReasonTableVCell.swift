//
//  EndListingReasonTableVCell.swift
//  Sell4Bids
//
//  Created by admin on 2/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class EndListingReasonTableVCell: UITableViewCell {
  
  
  @IBOutlet weak var lblEndListingReason: UILabel!
  @IBOutlet weak var imgRadio: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    ForLanguageChange()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
    func ForLanguageChange(){
         lblEndListingReason.text = "ReasontoenditemListingEVC".localizableString(loc: LanguageChangeCode)
    }
  
}
