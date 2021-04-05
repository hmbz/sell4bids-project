//
//  extensions.swift
//  socialLogins
//
//  Created by H.M.Ali on 9/27/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
extension UIView{
  
  func fadeIn(){
    
    self.isHidden = false
    
    UIView.animate(withDuration: 0.9, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
      self.alpha = 1
    }) { (finished) in
      self.isHidden = false
    }
  }
  
  func fadeOut(){
    
    
    UIView.animate(withDuration: 1.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
      self.alpha = 0
    }) { (finished) in
      //self.isHidden = true
    }
  }
  
  ///irfan
  func addShadowView(width:CGFloat=0.2, height:CGFloat=0.2, Opacidade:Float=0.7, maskToBounds:Bool=false, radius:CGFloat=0.5){
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: width, height: height)
    self.layer.shadowRadius = radius
    self.layer.shadowOpacity = Opacidade
    self.layer.masksToBounds = maskToBounds
  }
  
    func roundEdgedViewForHomeCollectionViewRow () {
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.masksToBounds = true
        
    }
    
    func viewForHomeShowCaseCollectionView () {
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = true
    }
    
    func cardViewBorder(){
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 7.0
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.1
        
    }
    
    func borderView(){
        
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.cornerRadius =
        9.0
        self.layer.masksToBounds = false
        
    }
    
    func collection(){
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 10.0
        //   self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.4
        //  self.clipsToBounds = true
    }
    
    func cornerView(){
        
        self.layer.borderWidth = 2
        self.layer.shadowOpacity = 3
        self.layer.shadowRadius = 5
        //        self.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        
    }
    
    
    func shakeView() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    
}


extension UIColor {
  convenience init(hex: String) {
    let scanner = Scanner(string: hex)
    scanner.scanLocation = 0
    
    var rgbValue: UInt64 = 0
    
    scanner.scanHexInt64(&rgbValue)
    
    let r = (rgbValue & 0xff0000) >> 16
    let g = (rgbValue & 0xff00) >> 8
    let b = rgbValue & 0xff
    
    self.init(
      red: CGFloat(r) / 0xff,
      green: CGFloat(g) / 0xff,
      blue: CGFloat(b) / 0xff, alpha: 1
    )
  }
}


extension String {
  func capitalizingFirstLetter() -> String {
    return prefix(1).uppercased() + dropFirst()
  }
  
  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}
extension UIViewController {
  // @ Ak
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
  func alert(message: String, title: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "Ok".localizableString(loc: LanguageChangeCode), style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true) {
      
    }
  }
  
  func clearBackButtonText() {
    let backItem = UIBarButtonItem()
    backItem.title = ""
    self.navigationItem.backBarButtonItem = backItem
  }

  func addLogoWithLeftBarButton() {
    
    navigationItem.leftItemsSupplementBackButton = true
    let button = UIButton.init(type: .custom)
    button.setImage( #imageLiteral(resourceName: "Icon-App-29x29")  , for: UIControlState.normal)
    button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
    let barButton = UIBarButtonItem.init(customView: button)
    self.navigationItem.leftBarButtonItems = [barButton]
  }
  
  
}


extension UIScrollView {
  
  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.next?.touchesBegan(touches, with: event)
    //print("touchesBegan")
  }
  
  override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.next?.touchesMoved(touches, with: event)
    //print("touchesMoved")
  }
  
  override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.next?.touchesEnded(touches, with: event)
    //print("touchesEnded")
  }
  
  
}
public extension DispatchQueue {
  
  private static var _onceTracker = [String]()
  
  /**
   Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
   only execute the code once even in the presence of multithreaded calls.
   
   - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
   - parameter block: Block to execute once
   */
  public class func once(token: String, block:()->Void) {
    objc_sync_enter(self); defer { objc_sync_exit(self) }
    
    if _onceTracker.contains(token) {
      return
    }
    
    _onceTracker.append(token)
    block()
  }
}

extension UIImage{
  var decompressedImage: UIImage {
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    draw(at: CGPoint.zero)
    let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return decompressedImage!
  }
}
extension UIImage {
  class func scaleImageToSize(img: UIImage, size: CGSize) -> UIImage {
    UIGraphicsBeginImageContext(size)
    img.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: size))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return scaledImage!
  }
  
}
func downloadImage(from url: String, completion: @escaping(UIImage?)->() ) {
  if let webUrl = URL(string: url) {
    let urlRequest = URLRequest(url: webUrl)
    let task = URLSession.shared.dataTask(with: urlRequest)  { (imgData, responce, error) in
      if error != nil {
        print(error!)
        completion(nil)
        return
      }
    
      if let data = imgData, let image = UIImage(data: data)?.decompressedImage  {
        completion(image)
      }else {
        completion(nil)
      }
    
    }
    task.resume()
  }else {
    completion(nil)
  }
}



func resizeImageUrl (sourceImage:UIImage, completion: @escaping (UIImage)->()){
  let oldWidth = sourceImage.size.width
  let scaleFactor = 190 / oldWidth
  
  let newHeight = sourceImage.size.height * scaleFactor
  let newWidth = oldWidth * scaleFactor
  
  UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
  sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
  if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
    UIGraphicsEndImageContext()
    
    
    completion (newImage)
  }
}

//for making the button round with shadows
extension UIView {
  
    func addShadowAndRoundChat(offset: CGSize = CGSize.init(width: 1, height: 3), color: UIColor = UIColor.black, radius: CGFloat = 22, opacity: Float = 0.2) {
        
        let layer = self.layer
        layer.cornerRadius = radius
        // corner radius
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        //shadow
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = 1.3
        
    }
    
    
    func addShadowAndRoundTextChat(offset: CGSize = CGSize.init(width: 1, height: 3), color: UIColor = UIColor.black, radius: CGFloat = 25, opacity: Float = 0.2) {
        
        let layer = self.layer
        layer.cornerRadius = radius
        // corner radius
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        //shadow
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = 1.3
        
    }
    
    
    
  func addShadowAndRound(offset: CGSize = CGSize.init(width: 1, height: 3), color: UIColor = UIColor.black, radius: CGFloat = 17, opacity: Float = 0.5) {
    
    let layer = self.layer
    layer.cornerRadius = radius
    // corner radius
    layer.borderWidth = 1
    layer.borderColor = UIColor.clear.cgColor
    //shadow
    layer.shadowColor = color.cgColor
    layer.shadowOffset = offset
    layer.shadowOpacity = opacity
    layer.shadowRadius = 3
    
  }
    
   
    
    
    
    func addShadowAndRoundNew(offset: CGSize = CGSize.init(width: 1, height: 3), color: UIColor = UIColor.black, radius: CGFloat = 20, opacity: Float = 0.5) {
        
        let layer = self.layer
        layer.cornerRadius = radius
        // corner radius
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        //shadow
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = 3
        
    }
    
  
  func addShadow(offset: CGSize = CGSize.init(width: 1, height: 3), color: UIColor = UIColor.black, radius: CGFloat = 8, opacity: Float = 0.5) {
    
    let layer = self.layer
    
    // corner radius
    layer.borderWidth = 0
    layer.borderColor = UIColor.clear.cgColor
    //shadow
    layer.shadowColor = color.cgColor
    layer.shadowOffset = offset
    layer.shadowOpacity = opacity
    layer.shadowRadius = 3
    
  }
    
    func shadowView() {
        let layer = self.layer
        layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 2
    }
    
     func applyBlackCorner() {
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = false
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    func AddshadowViewToButton() {
        let layer = self.layer
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 3
    }
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

