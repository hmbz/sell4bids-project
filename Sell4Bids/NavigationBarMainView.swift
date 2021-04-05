//
//  NavigationBarMainView.swift
//  Sell4Bids
//
//  Created by admin on 09/11/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class NavigationBarMainView: UIView {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var searchBarButton: UIButton!
    @IBOutlet weak var micBtn: UIButton!
    @IBOutlet weak var filterbtn: UIButton!
    @IBOutlet weak var citystateZIpcode: UILabel!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var pizzaBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var homeImg: UIImageView!
    
    
//    override var intrinsicContentSize: CGSize {
//
//        return CGSize(width: UIScreen.main.bounds.width, height: 25)
//    }
    
    override var intrinsicContentSize: CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad{
            return CGSize(width: UIScreen.main.bounds.width - 10, height: 40)
        }else {
            return CGSize(width: UIScreen.main.bounds.width - 8, height: 40)
        }
        
        //    return UILayoutFittingExpandedSize
        
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
          frame =  superview.bounds
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
