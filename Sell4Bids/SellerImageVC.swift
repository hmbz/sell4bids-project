//
//  SellerImageVC.swift
//  Sell4Bids
//
//  Created by MAC on 03/09/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class SellerImageVC: UIViewController {
  
  var userImage : UIImage? = nil
  @IBOutlet weak var btnDone: ButtonLarge!
  @IBOutlet weak var userImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Changes by Osama Mansoori
    ForLanguageChange()
    btnDone.layer.borderColor = UIColor.black.cgColor
    btnDone.layer.borderWidth = 2
    btnDone.layer.cornerRadius = 8
    
    userImageView.image = userImage
    btnDone.addShadowAndRound()
    // Do any additional setup after loading the view.
  }
    
    // Change by Osama Mansoori
    func ForLanguageChange(){
        btnDone.setTitle("DoneBtnFVC".localizableString(loc: LanguageChangeCode), for: .normal)
    }
  
    // Change sby OSama Mansoori
    @IBAction func TouchCancel(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.clear
        sender.setTitleColor(UIColor.black, for: .normal)
        
    }
  // Changes By Osama Mansoori
  @IBAction func btnDoneTapped(_ sender: UIButton) {
    
    sender.backgroundColor = UIColor.black
    sender.setTitleColor(UIColor.white, for: .normal)
    
    dismiss(animated: true)
  }
  
}
