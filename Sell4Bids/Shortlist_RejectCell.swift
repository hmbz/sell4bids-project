//
//  Shortlist_RejectCell.swift
//  Sell4Bids
//
//  Created by Admin on 02/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class Shortlist_RejectCell: UITableViewCell {

    @IBOutlet weak var backgroundCardViewF: UIView!
    @IBOutlet weak var ShortlistuserImage: UIImageView!
    @IBOutlet weak var rightArrowLBl: UIImageView!
    
    @IBOutlet weak var ShortlistExperienceLbl: UILabel!
    @IBOutlet weak var ShortlistUserNameLbl: UILabel!
    @IBOutlet weak var ShortlistCurrentSalaryLbl: UILabel!

    @IBOutlet weak var YearsLbl: UILabel!
    @IBOutlet weak var currencySignLbl: UILabel!
    @IBOutlet weak var CurrentSalaryPriceLbl: UILabel!
    @IBOutlet weak var contentVieww: UIView!

    func updateUIForFollower()
    {
        backgroundCardViewF.backgroundColor = UIColor.white
//        contentVieww.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        backgroundCardViewF.layer.cornerRadius = 3.0
        backgroundCardViewF.layer.masksToBounds = false
        backgroundCardViewF.layer.shadowColor = UIColor.black.cgColor
        backgroundCardViewF.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardViewF.layer.shadowOpacity = 0.8
        
        ShortlistuserImage.layer.borderWidth = 2
        ShortlistuserImage.layer.borderColor = UIColor.red.cgColor
        ShortlistuserImage.layer.cornerRadius = ShortlistuserImage.frame.width/2
        ShortlistuserImage.layer.masksToBounds = false
        ShortlistuserImage.clipsToBounds = true
    }
    
    
    override func awakeFromNib() {
        
    }
}
