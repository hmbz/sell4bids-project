//
//  ItemOrderandItemOfferVC.swift
//  Sell4Bids
//
//  Created by admin on 01/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import SwipeMenuViewController

class ItemOrderandItemOfferVC: UIViewController , SwipeMenuViewDelegate , SwipeMenuViewDataSource,UINavigationControllerDelegate {
     
    var isReload = false
    var selectedProduct : ProductDetails?
    
//
    @IBOutlet weak var MainView: SwipeMenuView!
    //MARK: - Variables
    
    //var pageMenu : CAPSPageMenu?
    var nav = UINavigationController().navigationBar
    
    let options : SwipeMenuViewOptions = .init()
    var titlearray = ["Offer","Orders"]
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let storyboardv = UIStoryboard.init(name: "ItemDetail", bundle: Bundle.main)
        let controller1 = storyboardv.instantiateViewController(withIdentifier: "Offer")   as! OfferView
        controller1.navi = self.nav
        controller1.selectedProduct = selectedProduct
        controller1.title = "Offers"
        self.controllers.append(controller1)
      
        print("ViewController Added")
                let controller2 = storyboardv.instantiateViewController(withIdentifier: "OrderView") as! ViewOffersVc
                controller2.navi = self.nav
                controller2.title = "Orders"
                controller2.productDetail = selectedProduct
                self.controllers.append(controller2)
        
        MainView.delegate = self
        MainView.dataSource = self
        
        MainView.reloadData(options: options)
        
        
        //Button with image example
        //let buttonOne = SwipeButtonWithImage(image: UIImage(named: "Hearts"), selectedImage: UIImage(named: "YellowHearts"), size: CGSize(width: 40, height: 40))
        //setButtonsWithImages([buttonOne, buttonOne, buttonOne])
        // Do any additional setup after loading the view.
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return self.titlearray[index]
    }
    
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        return self.controllers[index]
    
    }
    
    
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return self.titlearray.count
    }
    
    fileprivate func setupViews() {
        navigationItem.title = "Orders"
        // Do any additional setup after loading the view.
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        let barBtnDone = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(backBtnTap))
        
        navigationItem.leftBarButtonItem = barBtnDone
    }
    
    
    
    
    @objc func backBtnTap() {
        // self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // Change By Osama Mansoori
   
    
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
