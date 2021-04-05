//
//  AnimatedSplashScreenVC.swift
//  Sell4Bids
//
//  Created by admin on 30/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

//.......................... Code Refactor by Ehtisham ....................

import UIKit
import SwiftGifOrigin
import SwiftyGif


class AnimatedSplashScreenVC: UIViewController {
    
    //MARK:- Properties and Outlets
    @IBOutlet weak var AnimatedSplashImg: UIImageView!
    
    //MARK:- View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGif()
        setRootView()
        let edbot = UserDefaults.standard.bool(forKey: SessionManager.shared.edBot)
        if edbot == true {
            print("Edbot = \(edbot)")
        }else if edbot == false {
            print("Edbot = \(edbot)")
        }else {
            UserDefaults.standard.set(true, forKey: SessionManager.shared.edBot)
        }
    }
    
    //MARK:- Private Function
    

    
    private func loadGif() {
        do {
            let gifName = Env.isIpad ? "12.9.gif" : "5.5.gif"
            let gif = try UIImage(gifName: gifName)
            self.AnimatedSplashImg.setGifImage(gif, manager: .defaultManager, loopCount: 1)
        } catch {
            print(error)
        }
    }
    
    private func setRootView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
//            if SessionManager.shared.isUserLoggedIn  {
//                let appDelegate = UIApplication.shared.delegate! as! AppDelegate
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//                appDelegate.window?.rootViewController = initialViewController
//                appDelegate.window?.makeKeyAndVisible()
//            }
//            else {
//                let appdelegate = UIApplication.shared.delegate as! AppDelegate
//                let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVc") as! WelcomeVc
//                let nav = UINavigationController(rootViewController: homeViewController)
//                appdelegate.window!.rootViewController = nav
//                appdelegate.window?.makeKeyAndVisible()
//                homeViewController.reloadInputViews()
//            }
        }
    }
    
    
}
