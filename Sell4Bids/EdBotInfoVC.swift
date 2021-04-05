//
//  EdBotInfoVC.swift
//  Sell4Bids
//
//  Created by admin on 12/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class EdBotInfoVC: UIViewController {
lazy var titleview = Bundle.main.loadNibNamed("EdTopBarView", owner: self, options: nil)?.first as! EdTopBarView
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
        // Do any additional setup after loading the view.
    }
    

   @objc func backbtnTapped(sender: UIButton){
           print("Back button tapped")
           self.navigationController?.popViewController(animated: true)
       }
       // going back directly towards the home
       
    
    private func topMenu() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.titleView = titleview
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
        titleview.infoBtn.isHidden = true
    }

}
