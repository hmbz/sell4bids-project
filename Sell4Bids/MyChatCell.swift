//
//  MyChatCell.swift
//  Sell4Bids
//
//  Created by H.M.Ali on 11/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class MyChatCell: UITableViewCell {
    
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var onlineTextLabel: UILabel!
    @IBOutlet weak var unreadCountLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var Timeshow: UILabel!
    @IBOutlet weak var readImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupViews() {
        unreadCountLabel.layer.cornerRadius = unreadCountLabel.frame.height/2
        userImageView.layer.cornerRadius = 40
        userImageView.layer.masksToBounds = true
        userImageView.layer.borderWidth = 0.5
        userImageView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
}
