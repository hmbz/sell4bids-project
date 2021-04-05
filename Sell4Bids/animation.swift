//
//  animation.swift
//  OgreSpace
//
//  Created by Ehtisham on 6/29/19.
//  Copyright © 2019 brainplow. All rights reserved.
//

import Foundation
import UIKit
//MARK:- Button
extension UIButton {
    
    //TODO:- creating the shadow for the button
    func applyShadowOnBlackButton(cornerRadius : CGFloat, backColor: UIColor, titleColor : UIColor) {
        // applying the color
        
        setTitleColor(titleColor, for: .normal)
        backgroundColor = backColor
        
        // applying the shadow
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.cornerRadius = cornerRadius

    }
    
    func makeBlackBorder(){
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.masksToBounds = true
    }
    
    
}

//MARK:- UIView
extension UIView {
    
    //TODO:- creating the shadow for the UIView
    func applyShadowOnView(cornerRadius: CGFloat) {
        // applying the shadow
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.cornerRadius = cornerRadius
    }
    
    
}
extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}
