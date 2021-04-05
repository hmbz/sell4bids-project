//
//  BoughtAndWinsVc.swift
//  Sell4Bids
//
//  Created by admin on 10/10/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import XLPagerTabStrip

class BoughtAndWinsVc: UIViewController, IndicatorInfoProvider {
    
    
    //MARK: - Properties
    
    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var emptyProductMessage: UILabel!
    @IBOutlet weak var imgeView: UIImageView!
    @IBOutlet weak var fidgetImageView: UIImageView!
    
    
    //MARK: - Variables
    private let leftAndRightPaddings: CGFloat = 32.0
    private var numberOfItemsPerRow: CGFloat  {
        if UIDevice.current.userInterfaceIdiom == .phone { return 2 }
        else { return 3 }
    }
    private let heightAdjustment: CGFloat = 30.0
    var nav:UINavigationController?
    var boughtProductsArray = [ProductModel]()
    var MyBuying = [BuyingModel]()
    var dbRef: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    var blockedUserIdArray = [String]()
    var currency = String()
    var country = String()
    var MainApis = MainSell4BidsApi()
    lazy var responseStatus = false
    lazy var orderArray = [orderModel]()
    lazy var offerArray = [offerModel]()
    lazy var MyCollectionViewCellId: String = "productCollectionViewCell"
    lazy var bottomBar = false
    
    //MARK:- Functions
    
    //Mark: - when view load on first time.
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
        let bounds = UIScreen.main.bounds
        let width = (bounds.size.width - leftAndRightPaddings) / numberOfItemsPerRow
        let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
        getBoughtItem()
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        self.collView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        if bottomBar == true {
            self.tabBarController?.tabBar.isHidden = true
        }
        navigationController?.navigationBar.barTintColor = UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //Mark:- When view will disappear this view cycle called.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        print("Disappear")
        self.MyBuying.removeAll()
        self.getBoughtItem()
    }
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Bought"
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
    
    func getBoughtItem(){
        //         self.MyBuying.removeAll()
        let start = MyBuying.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.isHidden = false
                self.DimView.isHidden = false
            }
        }
        MainApis.BoughtList_Api(user_ID: SessionManager.shared.userId, country: "USA", start: "\(start)", limit: "10", completionHandler: { (status, swifymessage, error) in
            if status {
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                self.responseStatus = true
                print("userid.. = \(SessionManager.shared.userId)")
                
                let message = swifymessage!["message"]
                let messageobj = swifymessage!["message"].stringValue
                
                if messageobj.contains("No items found") {
                    self.emptyProductMessage.isHidden = false
                    self.imgeView.isHidden = false
                }
                
                let totalCount = swifymessage!["totalCount"].intValue
                print(totalCount)
                if totalCount > 0 {
                    self.collView.isHidden = false
                    self.emptyProductMessage.isHidden = true
                    self.imgeView.isHidden = true
                    
                }else {
                    self.collView.isHidden = true
                    self.emptyProductMessage.isHidden = false
                    self.imgeView.isHidden = false
                }
                
                
                print("message1 = \(message)")
                
                if totalCount > 0 {
                    for msg in message{
                        guard let dict = msg.1.dictionary else {return}
                        let type = msg.1["type"].stringValue
                        let itemCategory = msg.1["itemCategory"].stringValue
                        let currencyString = dict["currency_string"]?.string ?? ""
                        let currencySymbol = dict["currency_symbol"]?.string ?? ""
                        
                        if itemCategory.contains("Services") {
                            
                            
                        }else if itemCategory.contains("Jobs") {
                            
                        }else if itemCategory.contains("Vehicles") {
                            
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
                                let title = msg.1["title"].stringValue
                                let buying_item = BuyingModel.init(buyer_Rating: buyer_Rating, seller_Rating: seller_Rating, boughtQuantity: boughtQuantity, seller_uid: seller_uid, isLocationShared: isLocationShared , status: status, buyerName: buyerName, auctionType: auctionType, boughtPrice: boughtPrice, type: type, sellerName: sellerName, totalAmount: totalAmount, item_id: item_id, buyer_uid: buyer_uid, seller_marked_paid: seller_marked_paid, image: image, orderTime: orderTime, itemCategory: itemCategory, id: id,title: title,currencyString: currencyString,currencySymbol: currencySymbol)
                                
                                self.MyBuying.append(buying_item)
                                print("Buying Item Orders == \(buying_item)")
                                self.collView.reloadData()
                            }else if type.contains("offers") {
                                
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
                                let title = msg.1["title"].stringValue
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
                                
                                let buyingitem = BuyingModel.init(price: price, seller_Rating: seller_Rating, boughtQuantity: boughtQuantity, buyer_Rating: buyer_Rating, buyerOfferCount: buyerOfferCount, seller_uid: seller_uid, isLocationShared: isLocationShared, status: status, quantity: quantity, lastQuantityBuyer: lastQuantityBuyer, boughtPrice: boughtPrice, type: type, lastOfferTime: lastOfferTime, sellerOfferCount: sellerOfferCount, lastOfferBuyer: lastOfferBuyer, buyer_uid: buyer_uid, seller_marked_paid: seller_marked_paid, title: title, image: image, item_id: item_id, id: id, orderTime: orderTime , offers : offer_arr,currencyString: currencyString,currencySymbol: currencySymbol)
                                
                                self.MyBuying.append(buyingitem)
                                print("Buying Item Offers == \(buyingitem)")
                                self.collView.reloadData()
                                
                            }
                            
                        }
                        
                        
                    }
                }else {
                    if self.MyBuying.count > 0 {
                        self.imgeView.isHidden = true
                        self.emptyProductMessage.isHidden = true
                    }else {
                        self.imgeView.isHidden = false
                        self.emptyProductMessage.isHidden = false
                        self.emptyProductMessage.text = "item doesn't bought."
                    }
                    
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
    
    //Mark:- hide collection view depands on boolean value.
    func hideCollectionView(hideYesNo : Bool) {
        
        emptyProductMessage.text = "Items you buy or win after bidding, appear here".localizableString(loc: LanguageChangeCode)
        print("HIde Yes No = \(hideYesNo)")
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
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Bought".localizableString(loc: LanguageChangeCode))
    }
    
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension BoughtAndWinsVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Mark :- define number of items in section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyBuying.count
    }
    //Mark:- define cell on collectionview and define it properties
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! productCollectionViewCell
        
        guard indexPath.row > -1 else {
            print("guard indexPath.row > -1 failed in \(self)")
            return UICollectionViewCell()
        }
        let product = MyBuying[indexPath.row]
        
        let currencySymbol : String?
        if product.currencySymbol != "" {
            currencySymbol = product.currencySymbol
        }else if product.currencyString != "" {
            currencySymbol = product.currencyString
        }else {
            currencySymbol = "$"
        }
        cell.itemImage.sd_setImage(with: URL(string: product.image), placeholderImage: UIImage(named: "emptyImage"))
        
        if product.type == "orders" {
            
            cell.titleLbl.text = product.title
            if  product.boughtPrice != "0" {
                cell.quantityLbl.text = "\(product.quantity) Available"
                let Price = "\(currencySymbol!) \(product.boughtPrice)"
                cell.buyNowBtn.setTitle(Price, for: .normal)
            }
        }else if product.type == "offers"{
            if product.status == "Pending" {
                let offerprice = product.price
                let offerquantity = product.quantity
                cell.titleLbl.text = product.title
                if  product.price != "0" {
                    cell.quantityLbl.text = "\(offerquantity) Available"
                    let price = "\(currencySymbol!) \(offerprice)"
                    cell.buyNowBtn.setTitle(price, for: .normal)
                }
            }else if product.status == "Accepted" {
                let offerprice = product.offers!.last!.price
                let offerquantity = product.offers!.last!.quantity
                cell.titleLbl.text = product.title
                if  product.price != "0" {
                    cell.quantityLbl.text = "\(offerquantity) Available"
                    let price = "\(currencySymbol!) \(offerprice)"
                    cell.buyNowBtn.setTitle(price, for: .normal)
                }
            }
            
        }
        
        
        
        return cell
        
    }
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
                getBoughtItem()
            }
        }
    }
    
    
    
    
}





