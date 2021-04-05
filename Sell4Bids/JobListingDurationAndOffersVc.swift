//
//  JobListingDurationAndOffersVC.swift
//  Sell4Bids
//
//  Created by Admin on 11/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class TakeDurationAndOffersCustomCell: UIView{
    
    // UI Labels
    @IBOutlet weak var listIndefinitelyLbl: UILabel!
    @IBOutlet weak var listDurationLbl: UILabel!
    @IBOutlet weak var acceptOfferLbl: UILabel!
    @IBOutlet weak var payPeriodLbl: UILabel!
    
    @IBOutlet weak var listDurationHeight: NSLayoutConstraint!
    
    @IBOutlet weak var DropDownArrowKeyImage: UIButton!
    @IBOutlet weak var DropDownArrowKeyImagePayPeriod: UIButton!
    
    
    // UI Switches & PickerView
    
    @IBOutlet weak var listIndefinitelySwitch: UISwitch!
    @IBOutlet weak var acceptOfferSwitch: UISwitch!
    
    @IBOutlet weak var listingDurationTextField: UITextField!
    
    @IBOutlet weak var payPeriodTextField: UITextField!
    
    // UI Stack Views
    
    @IBOutlet weak var listIndefinitelyStackView: UIStackView!
    @IBOutlet weak var listDurationStackView: UIStackView!
    @IBOutlet weak var acceptsOfferStackView: UIStackView!
    @IBOutlet weak var payPeriodStackView: UIStackView!
    @IBOutlet weak var listIndefinitelyImage: UIImageView!
    @IBOutlet weak var listingDurationImage: UIImageView!
    @IBOutlet weak var acceptOffersImage: UIImageView!
    @IBOutlet weak var autoRelistingImage: UIImageView!
    
}

