//
//  UserBidsVc.swift
//  Sell4Bids
//
//  Created by admin on 10/10/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class BuyingAndBidsVC: UIViewController , IndicatorInfoProvider{
    //Mark: - Properties
    
    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var emptyProductMessage: UILabel!
    @IBOutlet weak var imgeView: UIImageView!
    
    //Mark: - Variables
    var nav:UINavigationController?
    var buyingProductsArray = [ProductModel]()
    var MyBuying = [BuyingModel]()
//    var dbRef: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    var MainApis = MainSell4BidsApi()
    lazy var responseStatus = false
    lazy var orderArray = [orderModel]()
    lazy var offerArray = [offerModel]()
    
    private let leftAndRightPaddings: CGFloat = 6.0
    private var numberOfItemsPerRow: CGFloat = 2
    private let heightAdjustment: CGFloat = 30.0
    var blockedUserIdArray = [String]()
    lazy var MyCollectionViewCellId: String = "productCollectionViewCell"
    lazy var bottomBar = false
    
    //MARK:- when view did load cycle called.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        topMenu()
        if UIDevice.current.userInterfaceIdiom == .pad { numberOfItemsPerRow = 3 }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        getBuyingItem()
        //passing data to of Selling Products to SellingViewController
        //custom collectionView Cell size
        let bounds = UIScreen.main.bounds
        let width = (bounds.size.width  / numberOfItemsPerRow) - (leftAndRightPaddings * 2)
        let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
        //layout.itemSize = CGSize(width, width + heightAdjustment)
        layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
        emptyProductMessage.text = "Items you are currently in the process of buying and have bid on, appear here".localizableString(loc: LanguageChangeCode)
        
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        self.collView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        if bottomBar == true {
            self.tabBarController?.tabBar.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
    }
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Buying"
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
//        dismiss(animated: true, completion: nil)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    
    
    //Mark:- When view will disappear this cycle is called.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        print("Disappear")
        self.MyBuying.removeAll()
        self.getBuyingItem()
        
        
    }
    
    func getBuyingItem(){
        
//        self.MyBuying.removeAll()
        let start = MyBuying.count
        
//        fidgetImageView.toggleRotateAndDisplayGif()
//        Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.isHidden = false
                self.DimView.isHidden = false
            }
        }
        MainApis.BuyingList_Api(user_ID: SessionManager.shared.userId, country: "USA", start: "\(start)", limit: "50", completionHandler: { (status, swifymessage, error) in
            
            if status {
                print(swifymessage)
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                self.responseStatus = true
                print("userid.. = \(SessionManager.shared.userId)")
                _ = swifymessage!["totalCount"].int!
                let message = swifymessage!["message"]
                let messageobj = swifymessage!["message"].stringValue
                
                if messageobj.contains("No items found") {
//                    self.emptyProductMessage.isHidden = false
//                    self.imgeView.isHidden = false
                }
                
                print("message1 = \(message)")
                
                for msg in message{
                    let type = msg.1["type"].stringValue
                    let itemCategory = msg.1["itemCategory"].stringValue
                    let itemDetails = msg.1["itemDetails"]
                    
                    let currencyString = itemDetails["currency_string"].string ?? ""
                    let currencySymbol = itemDetails["currency_symbol"].string ?? ""
                    
                    if itemCategory.contains("Services") {
                        let seller_marked_paid = msg.1["seller_marked_paid"].boolValue
                                                   let auctionType = msg.1["auctionType"].stringValue
                                                   let seller_uid = msg.1["seller_uid"].stringValue
                                                   let isLocationShared = msg.1["isLocationShared"].boolValue
                                                   let boughtQuantity = msg.1["boughtQuantity"].stringValue
                                                   let boughtPrice = msg.1["boughtPrice"].stringValue
                                                   let buyerName = msg.1["buyerName"].stringValue
                                                   let itemCategory = msg.1["itemCategory"].stringValue
                                                   let orderTime = msg.1["orderTime"].int64Value
                                                   let seller_Rating = msg.1["seller_Rating"].doubleValue
                                                   let sellerName = msg.1["sellerName"].stringValue
                                                   _ = msg.1["offers"]
                                                   let buyer_uid = msg.1["buyer_uid"].stringValue
                                                   let buyer_Rating = msg.1["buyer_Rating"].doubleValue
                                                   let image = msg.1["image"].stringValue
                                                   let status = msg.1["status"].stringValue
                                                   let totalAmount = msg.1["totalAmount"].stringValue
                                                   let item_id = msg.1["item_id"].stringValue
                                                   let id = msg.1["_id"].stringValue
                                                   let title = itemDetails["title"].stringValue
                                                   
                                                   let buying_item = BuyingModel.init(buyer_Rating: buyer_Rating, seller_Rating: seller_Rating, boughtQuantity: boughtQuantity, seller_uid: seller_uid, isLocationShared: isLocationShared , status: status, buyerName: buyerName, auctionType: auctionType, boughtPrice: boughtPrice, type: type, sellerName: sellerName, totalAmount: totalAmount, item_id: item_id, buyer_uid: buyer_uid, seller_marked_paid: seller_marked_paid, image: image, orderTime: orderTime, itemCategory: itemCategory, id: id,title: title, currencyString: currencyString, currencySymbol: currencySymbol)
                                                   
                                                   self.MyBuying.append(buying_item)
                                                   print("Buying Item Orders == \(buying_item)")
                                                   self.collView.reloadData()
                    }else if itemCategory.contains("Jobs") {
                        let seller_marked_paid = msg.1["seller_marked_paid"].boolValue
                                                   let auctionType = msg.1["auctionType"].stringValue
                                                   let seller_uid = msg.1["seller_uid"].stringValue
                                                   let isLocationShared = msg.1["isLocationShared"].boolValue
                                                   let boughtQuantity = msg.1["boughtQuantity"].stringValue
                                                   let boughtPrice = msg.1["boughtPrice"].stringValue
                                                   let buyerName = msg.1["buyerName"].stringValue
                                                   let itemCategory = msg.1["itemCategory"].stringValue
                                                   let orderTime = msg.1["orderTime"].int64Value
                                                   let seller_Rating = msg.1["seller_Rating"].doubleValue
                                                   let sellerName = msg.1["sellerName"].stringValue
                                                   _ = msg.1["offers"]
                                                   let buyer_uid = msg.1["buyer_uid"].stringValue
                                                   let buyer_Rating = msg.1["buyer_Rating"].doubleValue
                                                   let image = msg.1["image"].stringValue
                                                   let status = msg.1["status"].stringValue
                                                   let totalAmount = msg.1["totalAmount"].stringValue
                                                   let item_id = msg.1["item_id"].stringValue
                                                   let id = msg.1["_id"].stringValue
                                                   let title = itemDetails["title"].stringValue
                                                   
                                                   let buying_item = BuyingModel.init(buyer_Rating: buyer_Rating, seller_Rating: seller_Rating, boughtQuantity: boughtQuantity, seller_uid: seller_uid, isLocationShared: isLocationShared , status: status, buyerName: buyerName, auctionType: auctionType, boughtPrice: boughtPrice, type: type, sellerName: sellerName, totalAmount: totalAmount, item_id: item_id, buyer_uid: buyer_uid, seller_marked_paid: seller_marked_paid, image: image, orderTime: orderTime, itemCategory: itemCategory, id: id,title: title, currencyString: currencyString, currencySymbol: currencySymbol)
                                                   
                                                   self.MyBuying.append(buying_item)
                                                   print("Buying Item Orders == \(buying_item)")
                                                   self.collView.reloadData()
                    }else {
                        //items Orders and Offers
                        if type.contains("orders") {
                           
                            let seller_marked_paid = msg.1["seller_marked_paid"].boolValue
                            let auctionType = msg.1["auctionType"].stringValue
                            let seller_uid = msg.1["seller_uid"].stringValue
                            let isLocationShared = msg.1["isLocationShared"].boolValue
                            let boughtQuantity = msg.1["boughtQuantity"].stringValue
                            let boughtPrice = msg.1["boughtPrice"].stringValue
                            let buyerName = msg.1["buyerName"].stringValue
                            let itemCategory = msg.1["itemCategory"].stringValue
                            let orderTime = msg.1["orderTime"].int64Value
                            let seller_Rating = msg.1["seller_Rating"].doubleValue
                            let sellerName = msg.1["sellerName"].stringValue
                            _ = msg.1["offers"]
                            let buyer_uid = msg.1["buyer_uid"].stringValue
                            let buyer_Rating = msg.1["buyer_Rating"].doubleValue
                            let image = msg.1["image"].stringValue
                            let status = msg.1["status"].stringValue
                            let totalAmount = msg.1["totalAmount"].stringValue
                            let item_id = msg.1["item_id"].stringValue
                            let id = msg.1["_id"].stringValue
                            let title = itemDetails["title"].stringValue
                            
                            let buying_item = BuyingModel.init(buyer_Rating: buyer_Rating, seller_Rating: seller_Rating, boughtQuantity: boughtQuantity, seller_uid: seller_uid, isLocationShared: isLocationShared , status: status, buyerName: buyerName, auctionType: auctionType, boughtPrice: boughtPrice, type: type, sellerName: sellerName, totalAmount: totalAmount, item_id: item_id, buyer_uid: buyer_uid, seller_marked_paid: seller_marked_paid, image: image, orderTime: orderTime, itemCategory: itemCategory, id: id,title: title, currencyString: currencyString, currencySymbol: currencySymbol)
                            
                            self.MyBuying.append(buying_item)
                            print("Buying Item Orders == \(buying_item)")
                            self.collView.reloadData()
                        }else if type.contains("offers") {
//                            let currencyString = itemDetails["currency_string"].string ?? ""
//                            let currencySymbol = itemDetails["currency_symbol"].string ?? ""
                            let price = msg.1["price"].stringValue
                            let seller_Rating = msg.1["seller_Rating"].doubleValue
                            let boughtQuantity = msg.1["boughtQuantity"].stringValue
                            let buyer_Rating = msg.1["buyer_Rating"].doubleValue
                            let buyerOfferCount = msg.1["buyerOfferCount"].stringValue
                            let seller_uid = msg.1["seller_uid"].stringValue
                            let isLocationShared = msg.1["isLocationShared"].boolValue
                            let status =  msg.1["status"].stringValue
                            let quantity = msg.1["quantity"].stringValue
                            let lastQuantityBuyer = msg.1["lastQuantityBuyer"].stringValue
                            let boughtPrice = msg.1["boughtPrice"].stringValue
                            let lastOfferTime = msg.1["lastOfferTime"].int64Value
                            let sellerOfferCount = msg.1["sellerOfferCount"].stringValue
                            let lastOfferBuyer = msg.1["lastOfferBuyer"].stringValue
                            let buyer_uid = msg.1["buyer_uid"].stringValue
                            let seller_marked_paid = msg.1["seller_marked_paid"].boolValue
                            //                            let title = msg.1["title"].stringValue
                            let offersobjc = msg.1["offers"]
                            var offer_arr = [offers]()
                            for offer in offersobjc {
                                let price = offer.1["price"].stringValue
                                let quantity = offer.1["quantity"].stringValue
                                let role = offer.1["role"].stringValue
                                let time = offer.1["time"].int64Value
                                let message = offer.1["message"].stringValue
                                
                                if price.isEmpty && quantity.isEmpty && role.isEmpty && time == nil && message.isEmpty {
                                    
                                }else {
                                    let offervalue = offers.init(quantity: quantity, price: price, message: message, role: role, time: time)
                                    offer_arr.append(offervalue)
                                }
                                
                                
                            }
                            
                            let image = msg.1["image"].stringValue
                            let item_id = msg.1["item_id"].stringValue
                            let id = msg.1["_id"].stringValue
                            let orderTime = msg.1["orderTime"].int64Value
                            let title = itemDetails["title"].stringValue
                            
                            let buyingitem = BuyingModel.init(price: price, seller_Rating: seller_Rating, boughtQuantity: boughtQuantity, buyer_Rating: buyer_Rating, buyerOfferCount: buyerOfferCount, seller_uid: seller_uid, isLocationShared: isLocationShared, status: status, quantity: quantity, lastQuantityBuyer: lastQuantityBuyer, boughtPrice: boughtPrice, type: type, lastOfferTime: lastOfferTime, sellerOfferCount: sellerOfferCount, lastOfferBuyer: lastOfferBuyer, buyer_uid: buyer_uid, seller_marked_paid: seller_marked_paid, title: title, image: image, item_id: item_id, id: id, orderTime: orderTime , offers : offer_arr ,currencyString: currencyString,currencySymbol: currencySymbol)
                            
                            self.MyBuying.append(buyingitem)
                            print("Buying Item Offers == \(buyingitem)")
                            self.collView.reloadData()
                            
                            if self.MyBuying.count > 0 {
                                self.emptyProductMessage.isHidden = true
                                self.imgeView.isHidden = true
                            }else {
                                self.emptyProductMessage.isHidden = false
                                self.imgeView.isHidden = false
                            }
                            
                        }
                        
                    }
                    
                    
                }
                if self.MyBuying.count > 0 {
                                              self.emptyProductMessage.isHidden = true
                                              self.imgeView.isHidden = true
                                          }else {
                                              self.emptyProductMessage.isHidden = false
                                              self.imgeView.isHidden = false
                                          }
            }
            
            if error.contains("The network connection was lost"){
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
            if error.contains("The Internet connection appears to be offline.") {
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            if error.contains("A server with the specified hostname could not be found."){
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                
                self.present(alert, animated: true, completion: nil)
            }
            
            if error.contains("The request timed out.") {
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        })
        
        
    }
    
    //Mark:- function for collectionview is hide depand on boolean value.
    func hideCollectionView(hideYesNo : Bool) {
        
        if hideYesNo == false {
            collView.isHidden = false
            imgeView.isHidden = true
            fidgetImageView.isHidden = false
            fidgetImageView.image = nil
            emptyProductMessage.isHidden = true
        }
        else  {
            fidgetImageView.isHidden = true
            fidgetImageView.image = nil
            
            collView.isHidden = true
            imgeView.isHidden = false
            emptyProductMessage.isHidden = false
        }
    }
    
    
    //Mark:- Set title on top slider bar .
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Buying".localizableString(loc: LanguageChangeCode))
    }
  
  @objc func cancelapi(_ sender: UIButton){
    let alert = UIAlertController(title: "Delete Order!!", message: "Are you sure you want to delete your order", preferredStyle: UIAlertControllerStyle.alert)
    let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (result) in
      
      
      let a =  sender.tag
      let instance = self.MyBuying
       let parms = [ "sellerName":"","sellerImage":"","seller_uid":"\(instance[a].seller_uid)","item_id":"\(instance[a].item_id)","order_id":"\(instance[a].id)","quantity":1] as [String : Any]
      self.MainApis.postApiCall(URL: "https://apis.sell4bids.com/items/rejectOrder", param:parms) { (result) in
        print(result)
        if result == true{
           
          self.MyBuying.remove(at: a)
          if self.MyBuying.count > 0 {
                                                       self.emptyProductMessage.isHidden = true
                                                       self.imgeView.isHidden = true
                                                   }else {
                                                       self.emptyProductMessage.isHidden = false
                                                       self.imgeView.isHidden = false
                                                   }
           self.collView.reloadData()
         }
        }
        print(a)
        
      
    }
    let no = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
    alert.addAction(yes)
    alert.addAction(no)
    self.present(alert, animated: true, completion: nil)
  }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BuyingAndBidsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Mark: - define numbers of items in section in collectionview.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyBuying.count
    }
    
    //Mark:- define cell for collectionview and define it properties.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as? productCollectionViewCell else {
            print("\nError: Could not deque a cell in \(self). Going to return")
            return UICollectionViewCell()
        }
        guard indexPath.row < MyBuying.count else {
            print("guard indexPath.row > buyingProductsArray.count failed in \(self)")
            return cell
        }
        cell.cancelOrderBtn.isHidden = false
      cell.cancelOrderBtn.tag = indexPath.row
      cell.cancelOrderBtn.addTarget(self, action: #selector(cancelapi), for: UIControlEvents.touchUpInside)
      
        cell.itemImage.contentMode = .scaleAspectFit
        let product = MyBuying[indexPath.row]
        
        let currencySymbol : String?
        if product.currencySymbol != "" {
            currencySymbol = product.currencySymbol
        }else if product.currencyString != "" {
            currencySymbol = product.currencyString
        }else {
            currencySymbol = "$"
        }
        print(" IndexPath = \(indexPath.row)", currencySymbol)
        if !product.image.isEmpty {
            cell.itemImage.sd_setImage(with: URL(string: product.image), placeholderImage: UIImage(named: "emptyImage"))
        }
        //adding shadows and rounding\
        //setting title
        
        
        if product.type == "orders" {
            
            cell.titleLbl.text = product.title
            if  product.boughtPrice != "0" {
                cell.quantityLbl.text = "\(product.boughtQuantity) Available"
                let price = "\(currencySymbol ?? "$") \(product.boughtPrice)"
                cell.buyNowBtn.setTitle(price, for: .normal)
            }
        }else if product.type == "offers"{
            if product.status == "Pending" {
                let offerprice = product.price
                let offerquantity = product.quantity
                cell.titleLbl.text = product.title
                if  product.price != "0" {
                    cell.quantityLbl.text = "\(offerquantity) Available"
                    let price = "\(currencySymbol ?? "$") \(offerprice)"
                    cell.buyNowBtn.setTitle(price, for: .normal)
                }
            }else if product.status == "Accepted" {
                let offerprice = product.offers!.last!.price
                let offerquantity = product.offers!.last!.quantity
                cell.quantityLbl.text = "\(offerquantity) Available"
//                let price = "$\(product.boughtPrice)"
                cell.buyNowBtn.setTitle(offerprice, for: .normal)
                }
            }
        
        return cell
    }
    //Mark:- When user select an item from collectionview this function called.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let instance = MyBuying
        guard indexPath.row < instance.count else {return}
        let Category = instance[indexPath.row].itemCategory
        if Category.lowercased() == "jobs" {
            let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
            let controller = storyBoard_.instantiateViewController(withIdentifier: "JobsDetailVC") as! JobsDetailVC
            controller.ImageArray = [instance[indexPath.row].image]
            controller.itemName = instance[indexPath.row].title
            controller.itemId = instance[indexPath.row].item_id
            controller.sellerId = instance[indexPath.row].id
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        else if Category.lowercased() == "services" {
            let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
            let controller = storyBoard_.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
            controller.ImageArray = [instance[indexPath.row].image]
            controller.itemName = instance[indexPath.row].title
            controller.itemId = instance[indexPath.row].item_id
            controller.sellerId = instance[indexPath.row].id
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        else if Category.lowercased() == "vehicles" {
            let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
            let controller = storyBoard_.instantiateViewController(withIdentifier: "VehicleDetailVC") as! VehicleDetailVC
            controller.ImageArray = [instance[indexPath.row].image]
            controller.itemName = instance[indexPath.row].title
            controller.itemId = instance[indexPath.row].item_id
            controller.sellerId = instance[indexPath.row].id
            
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        else if Category.lowercased() == "housing" {
            
            let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
            let controller = storyBoard_.instantiateViewController(withIdentifier: "HousingDetailVC") as! HousingDetailVC
            controller.ImageArray = [instance[indexPath.row].image]
            controller.itemName = instance[indexPath.row].title
            controller.itemId = instance[indexPath.row].item_id
            controller.sellerId = instance[indexPath.row].id
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
            
        else {
            let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
            let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
            controller.itemName = instance[indexPath.row].title
            controller.itemId = instance[indexPath.row].item_id
            controller.sellerId = instance[indexPath.row].id
            controller.ImageArray = [instance[indexPath.row].image]
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        
        
//        fidget.toggleRotateAndDisplayItems(fidgetView: self.fidgetImageView, downloadcompleted: true)
        
//        self.DimView.isHidden = false
//        self.DimView.alpha = 1
//        self.DimView.backgroundColor = .clear
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            if self.responseStatus == false {
//                self.fidgetImageView.toggleRotateAndDisplayGif()
//                self.fidgetImageView.isHidden = false
//            }
//        }
//
//
//        MainApis.Item_Details(uid: SessionManager.shared.userId, country: gpscountry, seller_uid: MyBuying[indexPath.row].id, item_id: MyBuying[indexPath.row].item_id) { (status, response, error) in
//
//            if status {
//
//                fidget.stopfiget(fidgetView: self.fidgetImageView)
//                self.responseStatus = true
//                for message in response!["message"] {
//
//                    let itemCategory = message.1["itemCategory"].stringValue
//
//
//
//
//
//                    if  itemCategory == "Jobs" {
//                        //Job Details Data
//                        let jobApplied = response!["jobApplied"].boolValue
//                        let employmentType = message.1["employmentType"].stringValue
//                        let autoReList = message.1["autoReList"].boolValue
//                        let itemAuctionType = message.1["itemAuctionType"].stringValue
//                        let old_images = message.1["old_images"]
//                        let loc = message.1["loc"]
//                        let coordinates = loc["coordinates"].array
//                        var old_images_array = [String]()
//                        for oldimages in old_images {
//                            old_images_array.append(oldimages.1.stringValue)
//                        }
//                        let payPeriod = message.1["payPeriod"].stringValue
//                        let state = message.1["state"].stringValue
//                        let companyName = message.1["companyName"].stringValue
//                        let startPrice = message.1["startPrice"].int64Value
//                        let image = message.1["images_path"]
//                        var imageArray = [String]()
//                        for img in image {
//                            imageArray.append(img.1.stringValue)
//                        }
//                        let acceptOffers = message.1["acceptOffers"].boolValue
//                        let zipcode = message.1["zipcode"].stringValue
//                        let quantity = message.1["quantity"].int64Value
//                        let description = message.1["description"].stringValue
//                        let startTime = message.1["startTime"].int64Value
//                        let jobCategory = message.1["jobCategory"].stringValue
//                        let chargeTime = message.1["chargeTime"].int64Value
//                        let city = message.1["city"].stringValue
//                        _ = message.1["ordering"].boolValue
//                        let benefits = message.1["benefits"]
//                        let medical = String()
//                        let PTO = String()
//                        let FZOK = String()
//                        for benefit in benefits {
//                            _ = benefit.1["Medical"].stringValue
//                            _ = benefit.1["PTO"].stringValue
//                            _ = benefit.1["FZOK"].stringValue
//
//                        }
//                        var latitude = Double()
//                        var londtitude = Double()
//                        var watch_uid = String()
//                        var watch_token = String()
//
////                        print("coordinate == \(coordinates)")
//                        latitude = coordinates![1].doubleValue
//                        londtitude = coordinates![0].doubleValue
//
//
//
//
//
//                        let itemKey = message.1["itemKey"].stringValue
//                        let companyDescription = message.1["companyDescription"].stringValue
//                        let visibility = message.1["visibility"].boolValue
//                        let condition = message.1["condition"].stringValue
//                        let uid = message.1["uid"].stringValue
//                        let country_code = message.1["country_code"].stringValue
//                        let id = message.1["id"].stringValue
//                        let timeRemaining = message.1["timeRemaining"].int64Value
//                        let conditionValue = message.1["conditionValue"].intValue
//                        let endTime = message.1["endTime"].int64Value
//                        let token = message.1["token"].stringValue
//                        let title = message.1["title"].stringValue
//                        let experience = message.1["experience"].stringValue
//                        let username = message.1["name"].stringValue
//                        let watching = message.1["watching"]
//                        for watch in watching {
//                            let watch_uidvalue = watch.1["uid"].stringValue
//                            let watch_tokenvalue = watch.1["token"].stringValue
//                            watch_uid = watch_uidvalue
//                            watch_token = watch_tokenvalue
//
//                        }
//                        let currency_string = message.1["currency_string"].stringValue
//                        let currency_symbol = message.1["currency_string"].stringValue
//                        let admin_verify = message.1["admin_verify"].stringValue
//
//                        let jobdetails = JobDetails.init(employmentType: employmentType, autoReList: autoReList, itemAuctionType: itemAuctionType, old_images: old_images_array, payPeriod: payPeriod, state: state, companyName: companyName, startPrice: startPrice, image: imageArray, acceptOffers: acceptOffers, zipcode: zipcode, quantity: quantity, description: description, startTime: startTime, jobCategory: jobCategory, chargeTime: chargeTime, city: city, latitude: latitude, longtitude: londtitude, itemKey: itemKey, companyDescription: companyDescription, visibility: visibility, condition: condition, uid: uid, country_code: country_code, id: id, timeRemaining: timeRemaining, conditionValue: conditionValue, endTime: endTime, token: token, itemCategory: itemCategory, title: title , medical: medical , PTO: PTO , FZOK: FZOK, Experience: experience, userName: username, watchBool: true, watch_uid: watch_uid, watch_token: watch_token , jobApplied: jobApplied , currency_string: currency_string , currency_symbol: currency_symbol , admin_verify: admin_verify)
//
//                        print("Job Details = \(jobdetails.title)")
//
//                        self.tabBarController?.tabBar.isHidden = false
//
//                        let storyBoard_ = UIStoryboard.init(name: storyBoardNames.JobDetails , bundle: nil)
//                        let controller = storyBoard_.instantiateViewController(withIdentifier: "JoBDetailViewIdentifier") as! JoBDetailViewVC
//                        controller.selectedProduct_Job = jobdetails
//                        // controller.  = selectedProductKey
//                        self.navigationController?.pushViewController(controller, animated: true)
//                        self.navigationController?.setNavigationBarHidden(false, animated: true)
//
//
//                    }else {
//                        //Item Details Job
//                        let startPrice = message.1["startPrice"].intValue
//                        let visibility = message.1["visibility"].boolValue
//                        let quantity = message.1["quantity"].intValue
//                        let image_0 = message.1["old_images"]
//                        var image_array = [String]()
//                        for image in image_0 {
//                            image_array.append(image.1.stringValue)
//                        }
//                        let chargeTime = message.1["chargeTime"].int64Value
//                        let token = message.1["token"].stringValue
//                        let description = message.1["description"].stringValue
//                        let uid = message.1["uid"].stringValue
//
//                        let itemKey = message.1["_id"].stringValue
//                        let loc = message.1["loc"]
//                        _ = loc["coordinates"]
//
//                        var maxBid = Int64()
//                        var askPrice = Int64()
//                        var winner = String()
//                        var u_id = String()
//                        var bid = Int64()
//                        var watch_uid = String()
//                        var watch_token = String()
//                        var ItemimagesArr = [String]()
//
//
//                        let itemAuctionType = message.1["itemAuctionType"].stringValue
//                        let country_code = message.1["country_code"].stringValue
//                        _ = message.1["startTime"].stringValue
//                        let bids = message.1["bids"]
//                        for values in bids {
//                            let maxBidvalue = values.1["maxBid"].int64Value
//                            let askPricevalue = values.1["askPrice"].int64Value
//                            let winnervalue = values.1["winner"].stringValue
//                            maxBid = maxBidvalue
//                            askPrice = askPricevalue
//                            winner = winnervalue
//                        }
//                        let bidList = message.1["bidList"]
//                        for bidlst in bidList {
//                            let uidvalue = bidlst.1["uid"].stringValue
//                            let bidvalue = bidlst.1["bid"].int64Value
//                            u_id = uidvalue
//                            bid = bidvalue
//                        }
//                        let timeRemaining = message.1["timeRemaining"].int64Value
//                        let conditionValue = message.1["conditionValue"].stringValue
//                        let title = message.1["title"].stringValue
//                        let watching = message.1["watching"]
//                        for watch in watching {
//                            let watch_uidvalue = watch.1["uid"].stringValue
//                            let watch_tokenvalue = watch.1["token"].stringValue
//                            watch_uid = watch_uidvalue
//                            watch_token = watch_tokenvalue
//
//                        }
//                        self.orderArray.removeAll()
//                        self.offerArray.removeAll()
//                        let OrderArray = message.1["orders"].arrayValue
//                        for item in OrderArray {
//                            guard let OrderDic = item.dictionary else {return}
//                            let orderId = OrderDic["_id"]?.string ?? ""
//                            let sellerId = OrderDic["seller_uid"]?.string ?? ""
//                            let buyerOfferCount = OrderDic["buyerOfferCount"]?.int ?? -1
//                            let offersTypeArray = OrderDic["offers"]?.array ?? []
//                            for item in offersTypeArray {
//                                guard let Dic = item.dictionary else {return}
//                                let message = Dic["message"]?.string ?? ""
//                                let role = Dic["role"]?.string ?? ""
//                                let price = Dic["price"]?.string ?? ""
//                                let quantity = Dic["quantity"]?.string ?? ""
//                                let time = OrderDic["time"]?.string ?? ""
//                                let object = offerModel.init(message: message, role: role, price: price, quantity: quantity, time: time)
//                                self.offerArray.append(object)
//                            }
//                            print(self.offerArray)
//                            let obj = orderModel.init(orderId: orderId, sellerId: sellerId, OfferCount: buyerOfferCount, OfferArray: self.offerArray)
//                            self.orderArray.append(obj)
//                        }
//                        print(self.orderArray)
//
//                        let acceptOffers = message.1["acceptOffers"].boolValue
//                        let ordering = message.1["ordering"].boolValue
//                        let zipcode = message.1["zipcode"].stringValue
//                        let condition = message.1["condition"].stringValue
//                        let city = message.1["city"].stringValue
//                        let endTime = message.1["endTime"].int64Value
//                        let id = message.1["_id"].stringValue
//                        let state = message.1["state"].stringValue
//                        let autoReList = message.1["autoReList"].stringValue
//                        let admin_verify = message.1["admin_verify"].stringValue
//                        var latitude = Double()
//                        var londtitude = Double()
//                        let itemimages = message.1["old_images"]
//                        let coordinates = loc["coordinates"].array
//                        for itemimg in itemimages {
//                            ItemimagesArr.append(itemimg.1.stringValue)
//                            print("Item Image Url Backhand == \(itemimg.1.stringValue)")
//                        }
//
//                        latitude = coordinates![1].doubleValue
//                        londtitude = coordinates![0].doubleValue
//                        let watchingbool = response!["watching"].boolValue
//                        let currency_string = message.1["currency_string"].stringValue
//                        let currency_symbol = message.1["currency_string"].stringValue
//
//                        let productdetails = ProductDetails.init(itemkey: itemKey, itemAuctionType : itemAuctionType ,visibility: visibility, startPrice: startPrice, quantity: quantity, chargeTime: chargeTime, Image_0: image_0.stringValue, Image_1: image_0.stringValue, token: token, description: description, uid: uid, itemCategory: itemCategory, country_code: country_code, startTime: Int64(startPrice), maxBid: maxBid, askPrice: askPrice, winner: winner, winner_uid: watch_uid, winner_bid: Int64(startPrice), timeRemaining: timeRemaining, conditionValue: conditionValue, title: title, watch_uid: watch_uid, watch_token: watch_token, zipcode: zipcode, condition: condition, city: city, endTime: endTime, id: id, state: state, autoReList: autoReList, ItemImages: ItemimagesArr, latitude: latitude, longtitude: londtitude, ordering_status: true, company_name: "", benefits: "", payPeriod: "", jobToughness: "", employmentType: "" , acceptOffers: acceptOffers , ordering: ordering, watchingBool: watchingbool, OrderArray: self.orderArray , currency_string: currency_string, currency_symbol: currency_symbol , admin_verify: admin_verify)
//
//                        selectedProduct = productdetails
//
//
//
//                        self.tabBarController?.tabBar.isHidden = false
//
//                        let storyBoard_ = UIStoryboard.init(name: storyBoardNames.ItemDetails , bundle: nil)
//                        let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailsVC") as! ItemDetailsTableView
//                        controller.selectedProduct = selectedProduct
//                        // controller.  = selectedProductKey
//                        self.navigationController?.pushViewController(controller, animated: true)
//                        self.navigationController?.setNavigationBarHidden(false, animated: true)
//
//                    }
//
//
//
//
//
//
//
//
//
//
//                    if error.contains("The network connection was lost"){
//
//                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
//                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
//                        alert.addAction(ok)
//
//                        fidget.stopfiget(fidgetView: self.fidgetImageView)
//                        self.present(alert, animated: true, completion: nil)
//
//
//                    }
//
//                    if error.contains("The Internet connection appears to be offline.") {
//
//                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
//                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
//                        alert.addAction(ok)
//
//                        fidget.stopfiget(fidgetView: self.fidgetImageView)
//                        self.present(alert, animated: true, completion: nil)
//
//                    }
//
//                    if error.contains("A server with the specified hostname could not be found."){
//
//                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
//                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
//                        alert.addAction(ok)
//                        fidget.stopfiget(fidgetView: self.fidgetImageView)
//
//                        self.present(alert, animated: true, completion: nil)
//                    }
//
//                    if error.contains("The request timed out.") {
//
//                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
//                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
//                        alert.addAction(ok)
//                        fidget.stopfiget(fidgetView: self.fidgetImageView)
//
//                        self.present(alert, animated: true, completion: nil)
//
//                    }
//
//                }
//            }
//        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
        if scrollView == collView {
            let currentOffset = scrollView.contentOffset.y
            let maxOffset = scrollView.contentSize.height - scrollView.frame.height
            print("contentoffset = \(scrollView.contentOffset.y)")
            print("scrollview height = \(scrollView.frame.height )")
            self.fidgetImageView.isHidden = true
            fidget.stopfiget(fidgetView: fidgetImageView)
            scrollView.delegate = self
            print("Height == \(scrollView.contentSize.height)")
            print("maxoffset == \(maxOffset) // == Currentoffset = \(currentOffset)")
            print( "maxoffset- currentoffset = \(maxOffset - currentOffset)")
            
            if maxOffset - currentOffset < 50 {
               getBuyingItem()
            }
        }
    }
    
//     https://apis.sell4bids.com
 
}




