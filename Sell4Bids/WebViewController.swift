//
//  WebViewController.swift
//  Sell4Bids
//
//  Created by admin on 11/18/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    //MARK:-  Properties
    @IBOutlet weak var webView: WKWebView!
    
    //MARK:- Variables
    var urlString = "https://sell4bids.com/privacy"
    var screenName = ""
    var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    //MARK:- View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        topView()
        webView.load(URLRequest(url: URL(string: urlString)!))
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    //MARK:- Private Function
    private func topView() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = screenName
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        titleview.backBtn.addTarget(self, action: #selector(homeBtnTapped(sender:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        //        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }


}
