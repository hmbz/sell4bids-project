//
//  ImageView.swift
//  Sell4Bids
//
//  Created by admin on 11/10/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ImageView: UIViewController{
    
    //MARK:- Properties
    @IBOutlet weak var userImg: UIImageView!
    
    //MARK:- Variable
    var image =  String()
    var userName = String()
    var controller = ""
    var selectedImage = UIImage()
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if controller == "listing" {
            self.userImg.image = selectedImage
        }else {
          self.userImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "emptyImage" ))
        }
        topMenu()
    }
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = userName
        titleview.backBtn.setImage(nil, for: .normal)
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.backBtn.setTitle("Done", for: .normal)
        titleview.backBtnWidth.constant = 60
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
    }
    
}
