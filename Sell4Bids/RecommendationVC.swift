//
//  RecommendationVC.swift
//  Sell4Bids
//
//  Created by admin on 7/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class RecommendationVC: UIViewController {
    
    //MARK:- Properties.
    @IBOutlet weak var webview: UIWebView!
    
    //MARK:- Variables
    var value = "https://www.sell4bids.com/"
    var name = ""
    
    //View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
        let pdf = value.replacingOccurrences(of: " ", with: "%20")
        let url = URL (string: pdf)
        if url != URL (string: "") {
            let requestObj = URLRequest(url: url!)
            webview.loadRequest(requestObj)
        }else {
            showSwiftMessageWithParams(theme: .info, title: "PDF", body: "No PDF Found")
        }
    }
    
    //MARK:- Actions
    
    //MARK:- Functions
    
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = name
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
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
    
    
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    

}
