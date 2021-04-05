//
//  CustomSearchView.swift
//  Sell4Bids
//
//  Created by admin on 06/12/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class CustomSearchView: UIView {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var menubtn: UIButton!
    @IBOutlet weak var micbtn: UIButton!
    
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var invitebtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    
    
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: UIScreen.main.bounds.width, height: 25)
//    }
//
//    override func awakeFromNib() {
//        layer.cornerRadius =
//
//        layer.masksToBounds = true
//
//    }
    override var intrinsicContentSize: CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: UIScreen.main.bounds.width - 10, height: 40)
        }else {
            return CGSize(width: UIScreen.main.bounds.width - 8, height: 40)
        }
    }
    
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue.insetBy(dx: -newValue.minX, dy: 1)
        }
    }
    
    override func didMoveToSuperview() {
        if let superview = superview {
            frame = superview.bounds
            translatesAutoresizingMaskIntoConstraints = true
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        /// remove autolayout warning in iOS11
        superview?.constraints.forEach { constraint in
            if fabs(constraint.constant) == 8 {
                constraint.isActive = false
            }
        }
    }

    override func awakeFromNib() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }

}

