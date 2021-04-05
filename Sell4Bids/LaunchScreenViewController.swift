//
//  LaunchScreenViewController.swift
//  Sell4Bids
//
//  Created by admin on 02/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var SplashScreenImg: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SplashScreenImg.loadGif(name: "iPhone.gif")
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
