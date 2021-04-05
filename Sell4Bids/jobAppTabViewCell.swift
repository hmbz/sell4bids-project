//
//  jobAppTabViewCell.swift
//  Sell4Bids
//
//  Created by admin on 6/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class jobAppTabViewCell: UITableViewCell {
    
    //MARK:- Properties
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var experienceLbl: UILabel!
    @IBOutlet weak var salaryLbl: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.shadowView()
        
        cardView.layer.cornerRadius = 6
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}
