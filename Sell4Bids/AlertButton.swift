//
//  AlertButton.swift
//  Alert-Refactor
//
//  Created by Sean Allen on 7/15/18.
//  Copyright © 2018 Sean Allen. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
class AlertButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    private func setupButton() {
        setTitleColor(.white, for: .normal)
        backgroundColor     = Colors.seanRed
        titleLabel?.font    = UIFont.boldSystemFont(ofSize: 20)
        layer.cornerRadius  = frame.size.height/2
        let layer = self.layer
        layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 3
    }
}

//Image View
extension UIImageView {
    public func sd_setImageWithURLWithFade(url: URL!, placeholderImage placeholder: UIImage!) {
        self.sd_setImage(with: url, placeholderImage: placeholder) { (image, error, cacheType, url) -> Void in
            if let downLoadedImage = image {
                if cacheType == .none {
                    self.alpha = 0
                    UIView.transition(with: self, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
                        self.image = downLoadedImage
                        self.alpha = 1
                    }, completion: nil)
                }
            } else {
                self.image = placeholder
            }
        }
    }
}
