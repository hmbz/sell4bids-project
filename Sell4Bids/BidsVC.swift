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

class BidsVC: UIViewController, IndicatorInfoProvider {
    
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
    var Winner = [WinnerModel]()
    var BidsItem =  [BidsItemModel]()
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
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        self.collView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
//        dbRef = FirebaseDB.shared.dbRef
//        fidgetImageView.toggleRotateAndDisplayGif()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        //custom collectionView Cell size
        let bounds = UIScreen.main.bounds
        let width = (bounds.size.width - leftAndRightPaddings) / numberOfItemsPerRow
        let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
        
        if bottomBar == true {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
         getBoughtItem()
       
        
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
        titleview.titleLbl.text = "Bids"
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
//        self.BidsItem.removeAll()
        let start = BidsItem.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.isHidden = false
                self.DimView.isHidden = false
            }
        }
//        self.fidgetImageView.toggleRotateAndDisplayGif()
//        Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
        MainApis.BidItems_Api(user_ID: SessionManager.shared.userId, country: gpscountry, start: "\(start)", limit: "10", completionHandler: { (status, data, error) in
            
            
            if status {
                
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                self.responseStatus = true
                let message = data!["message"].stringValue
                
                let totalCount = data!["totalCount"].intValue
                
                
                if totalCount > 0 {
                   
                    let message = data!["message"]
                    print(message)
                for msg in  message {
                    let bid = msg.1["bid"].stringValue
                    let currencySymbol = msg.1["currency_symbol"].stringValue
                    let biddingDetails = msg.1["biddingDetails"]
                    let item_id = msg.1["item_id"].stringValue
                    let status = msg.1["status"].stringValue
                    let winner = msg.1["winner"].stringValue
                    let bidsCount = msg.1["bidsCount"].stringValue
                    let endTime = msg.1["endTime"].int64Value
                    let startTime = msg.1["startTime"].int64Value
                    let itemAuctionType = msg.1["itemAuctionType"].stringValue
                    let image = msg.1["image"].stringValue
                    let startPrice = msg.1["item_price"].stringValue
                    let title = msg.1["item_title"].stringValue
                    let uid = msg.1["_id"].stringValue
                    let id = msg.1["id"].stringValue
                    let maxBid = msg.1["maxBid"].stringValue
                    let itemCategory = msg.1["itemCategory"].stringValue
                    
                    let data = BidsItemModel.init(bid: bid, item_id: item_id, status: status, winner: winner, bidsCount: bidsCount, endTime: endTime, startTime: startTime, itemAuctionType: itemAuctionType, image: image, startPrice: startPrice, title: title, uid: uid, id: id, maxBid: maxBid, currency_symbol: currencySymbol, itemCategory: itemCategory)
                    
                    self.BidsItem.append(data)
                    self.collView.reloadData()
                }
                }else {
                    if self.BidsItem.count > 0 {
                        self.imgeView.isHidden = true
                        self.emptyProductMessage.isHidden = true
                        
//                        self.emptyProductMessage.text = message
                    }else {
                        self.imgeView.isHidden = false
                        self.emptyProductMessage.isHidden = false
                        
                        self.emptyProductMessage.text = message
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
    
    //Mark:- get user blocked list from firebase .
    //  func getUserBlockedList(completion : @escaping (Bool) -> ()) {
    //
    //    guard let userId = Auth.auth().currentUser?.uid else {return}
    //    dbRef.child("users").child(userId).observeSingleEvent(of: .value) { (userSnapshot) in
    //      guard let dictObj = userSnapshot.value as? NSDictionary else{return}
    //      guard let blockedPerson = dictObj.value(forKeyPath: "blockedPersons") as? NSDictionary else {return}
    //      for value in blockedPerson {
    //        guard let blockedPerson = value.key as? String else {
    //          print("ERROR: while getting user Blocked user Id's ")
    //          return
    //        }
    //        self.blockedUserIdArray.append(blockedPerson)
    //      }
    //    }
    //    completion(true)
    //  }
    
    //Mark:- get user buying data from firebase node.
    //  func getUserBuyingData(){
    //  fidgetImageView.isHidden = false
    //
    //    guard let userId = Auth.auth().currentUser?.uid else {
    //      self.hideCollectionView(hideYesNo: true)
    //      print("ERROR : user id is nil in MySellVC")
    //      fatalError()
    //    }
    //    boughtProductsArray.removeAll()
    //
    //    dbRef.child("users").child(userId).child("products").child("bought").observeSingleEvent(of: .value) { (productsSnapshot) in
    //      guard let userProducts = productsSnapshot.value as? [String:AnyObject] else {
    //        self.fidgetImageView.isHidden = true
    //        self.fidgetImageView.image = nil
    //        self.hideCollectionView(hideYesNo: true)
    //        return
    //      }
    //        //Mark :- get buying products form productsSnapshot node.
    //      guard let buyingProduct = productsSnapshot.value as? [String:AnyObject] else {
    //        self.fidgetImageView.isHidden = true
    //        self.fidgetImageView.image = nil
    //        self.hideCollectionView(hideYesNo: true)
    //
    //        print("ERROR : while getting user selling data")
    //        return
    //      }
    //        //Mark :- get productskey from buying products keys.
    //      for productKey in buyingProduct.keys.sorted() {
    //
    //        guard let prodDict =  buyingProduct[productKey] as? [String:AnyObject] else {
    //          print("ERROR : while getting user selling data")
    //          return
    //        }
    //        //Mark:- get and set products details .
    //        if let stateName = prodDict["state"] as? String {
    //          if let categoryName = prodDict["category"] as? String {
    //            if let auctionType = prodDict["auctionType"]   as? String {
    //              self.dbRef.child("products").child(categoryName ).child(auctionType).child(stateName).child(productKey).observeSingleEvent(of: .value, with: { (productSnapshot) in
    //                if productSnapshot.childrenCount > 0 {
    //                  guard let productDict = productSnapshot.value as? [String:AnyObject] else {
    //                    print("ERROR: while fetchinh products Dicts")
    //                    return
    //                  }
    //                  let product = ProductModel(categoryName: categoryName , auctionType: auctionType, prodKey: productKey, productDict: productDict)
    //                  if product.categoryName != nil && product.auctionType != nil && product.state != nil{
    //                    guard let userId = product.userId else {return}
    //                    if (!self.blockedUserIdArray.contains(userId)){
    //                      self.boughtProductsArray.append(product)
    //                    }
    //
    //
    //
    //                  }
    //                    //Mark:- collection view reload and hide false.
    //                  DispatchQueue.main.async {
    //                    self.hideCollectionView(hideYesNo: false)
    //                    self.fidgetImageView.isHidden = true
    //                    self.fidgetImageView.image = nil
    //                    self.collView.reloadData()
    //
    //                  }
    //                }
    //              })
    //            }else {
    //                //Mark : - if products details not found hide collection view true.
    //              self.hideCollectionView(hideYesNo: true)
    //            }
    //          }else {
    //            //Mark : - if products details not found hide collection view true.
    //            self.hideCollectionView(hideYesNo: true)
    //          }
    //        }else {
    //            //Mark : - if products details not found hide collection view true.
    //          self.hideCollectionView(hideYesNo: true)
    //        }
    //      }
    //    }
    //
    //  }
    //Mark set title on slider bar .
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Bids".localizableString(loc: LanguageChangeCode))
    }
    
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension BidsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Mark :- define number of items in section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BidsItem.count
    }
    //Mark:- define cell on collectionview and define it properties
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! productCollectionViewCell
//        cell.sellImagevView.addShadowAndRound()
//        cell.layer.cornerRadius = 3.0
//        cell.layer.masksToBounds = false
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
//        cell.layer.shadowOpacity = 0.6
//
//        let baseView = cell.viewShadow!
//        baseView.layer.cornerRadius = 8
//        baseView.clipsToBounds = true
        
        
        guard indexPath.row > -1 else {
            print("guard indexPath.row > -1 failed in \(self)")
            return UICollectionViewCell()
        }
        
        let product = BidsItem[indexPath.row]
        
        
        cell.itemImage.sd_setImage(with: URL(string: product.image), placeholderImage: UIImage(named: "emptyImage"))
        
      
            
            cell.titleLbl.text = product.title
            if  product.startPrice != "0" {
                let price = "\(product.currency_symbol) \(product.startPrice)"
          cell.buyNowBtn.setTitle(price, for: .normal)
            
        }
        
        cell.quantityLbl.isHidden = true
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let instance = BidsItem
        guard indexPath.row < instance.count else {return}
        let Category = instance[indexPath.row].itemCategory
        if Category.lowercased() == "jobs" {
              let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
              let controller = storyBoard_.instantiateViewController(withIdentifier: "JobsDetailVC") as! JobsDetailVC
            controller.ImageArray = [instance[indexPath.row].image]
              controller.itemName = instance[indexPath.row].title
              controller.itemId = instance[indexPath.row].item_id
              controller.sellerId = instance[indexPath.row].uid
              controller.modalPresentationStyle = .fullScreen
              self.present(controller, animated: true, completion: nil)
          }
        else if Category.lowercased() == "services" {
              let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
              let controller = storyBoard_.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
            controller.ImageArray = [instance[indexPath.row].image]
              controller.itemName = instance[indexPath.row].title
              controller.itemId = instance[indexPath.row].item_id
              controller.sellerId = instance[indexPath.row].uid
              controller.modalPresentationStyle = .fullScreen
              self.present(controller, animated: true, completion: nil)
          }
        else if Category.lowercased() == "vehicles" {
              let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
              let controller = storyBoard_.instantiateViewController(withIdentifier: "VehicleDetailVC") as! VehicleDetailVC
            controller.ImageArray = [instance[indexPath.row].image]
              controller.itemName = instance[indexPath.row].title
              controller.itemId = instance[indexPath.row].item_id
              controller.sellerId = instance[indexPath.row].uid
              controller.modalPresentationStyle = .fullScreen
              self.present(controller, animated: true, completion: nil)
          }
        else if Category.lowercased() == "housing" {

              let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
              let controller = storyBoard_.instantiateViewController(withIdentifier: "HousingDetailVC") as! HousingDetailVC
            controller.ImageArray = [instance[indexPath.row].image]
              controller.itemName = instance[indexPath.row].title
              controller.itemId = instance[indexPath.row].item_id
              controller.sellerId = instance[indexPath.row].uid
              controller.modalPresentationStyle = .fullScreen
              self.present(controller, animated: true, completion: nil)
          }

          else {
              let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
              let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
              controller.ImageArray = [instance[indexPath.row].image]
              controller.itemName = instance[indexPath.row].title
              controller.itemId = instance[indexPath.row].item_id
              controller.sellerId = instance[indexPath.row].uid
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





