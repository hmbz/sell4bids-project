//
//  WatchingListVc.swift
//  Sell4Bids
//
//  Created by admin on 10/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip
class ActiveWatchListVc: UIViewController , IndicatorInfoProvider{
    
    
    
    //MARK: - Properties
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var errorimg: UIImageView!
    
    //MARK: - variables
    private var leftAndRightPaddings: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone { return 20 }
        else { return 32 }
    }
    private var numberOfItemsPerRow: CGFloat{
        if UIDevice.current.userInterfaceIdiom == .phone { return 2 }
        else { return 3 }
    }
    private let heightAdjustment: CGFloat = 30.0
    var productsitem = [String]()
    var nav:UINavigationController?
    var watchListArray = [ProductModel]()
    var watchListArr = [watchListModel]()
    var MainApis = MainSell4BidsApi()
    var productsArray = [Products]()
    var serverTime:NSNumber = 0
    lazy var responseStatus = false
    lazy var orderArray = [orderModel]()
    lazy var offerArray = [offerModel]()
    // creating Cell variable
    lazy var MyCollectionViewCellId: String = "productCollectionViewCell"
    lazy var bottomBar =  false
    
    //MARK:-  View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
      NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)

        cutomizeCollectionView()
        navigationController?.navigationBar.barTintColor = UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
       getWatchListItem()
        // registering Xib file to Product Col View
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        self.collView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        if bottomBar == true {
            self.tabBarController?.tabBar.isHidden = true
          
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
  @objc func methodOfReceivedNotification(notification: Notification) {
    watchListArr.removeAll()
     getWatchListItem()
    if self.watchListArr.count > 0 {
                         self.collView.reloadData()
                           self.errorimg.isHidden = true
                           self.emptyMessage.isHidden = true
                       }
                       else {
                           self.errorimg.isHidden = false
                           self.emptyMessage.isHidden = false
                           self.emptyMessage.text = "Item not added in Wishlist."
                       }
    collView.reloadData()
    print("here is my method call")
  }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       self.watchListArr.removeAll()
    }
    
    //TODO:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "My WatchList"
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
    
    
    //MARK:-  Private Function
    private func getWatchListItem(){
        let start = watchListArr.count
        print(start)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.isHidden = false
                self.DimView.isHidden = false
            }
        }
        MainApis.WatchList_Api(user_ID: SessionManager.shared.userId, country: "USA", start: "\(start)", limit: "50", completionHandler: { (status, swifymessage, error) in
            
            
            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
            self.responseStatus = true
//            self.watchListArr.removeAll()
            self.fidgetImageView.isHidden = true
            
            print("status == \(status)")
            print("swiftymessage == \(swifymessage!)")
            print("error ==\(error)")
            
            
            if status{
                
                let totalCount = swifymessage!["totalCount"].int!
                let message = swifymessage!["message"]
                print("message1 = \(message)")
                if totalCount > 0{
                    
                    self.errorimg.isHidden = true
                    self.emptyMessage.isHidden = true
                    for item in 0...totalCount-1{
                        print("watch_check \(item)")
                        
                        let data = message[item]
                        
                        let currencyString = data["currency_string"].string ?? ""
                        let Location = data["loc"]
                        let loc = Location["coordinates"].arrayValue
                        let Latitude = loc[0].int
                        let Longitude = loc[1].int
                        let uid = data["uid"].stringValue
                        let itemID = data["_id"].stringValue
                        let city1 = data["city"].stringValue
                        let title1 = data["title"].stringValue
                        let startPrice = data["startPrice"].int
                        let startTime = data["startTime"].int
                        let itemCategory = data["itemCategory"].stringValue
                        let zipCode = data["zipcode"].int
                        let itemAuctionType = data["itemAuctionType"].stringValue
                        let condition = data["condition"].stringValue
                        let endTime = data["endTime"].int
                        let quantity = data["quantity"].stringValue
                        let state = data["state"].stringValue
                        var old_images_1 = [String]()
                        var old_small_images_1 = [String]()
                        let old_small_images = data["old_small_images"]
                        let old_images = data["old_images"]
                        
                        for items1 in old_small_images {
                            print("old_images = \(items1)")
                            old_small_images_1.append(items1.1.stringValue)
                        }
                        
                        for items in old_images {
                            print("old_images = \(items)")
                            old_images_1.append(items.1.stringValue)
                        }
                        
                        print("img.. \(old_small_images) \n ff \(old_images)")
                        
                        let watchItems = watchListModel.init(latitude: Latitude ?? 0, longitude: Longitude ?? 0, Itemid: itemID, city: city1, title: title1, startprice: startPrice ?? 0, starttime: startTime ?? 0, oldsmallimage: old_small_images_1, oldimage: old_images_1, itemcategory: itemCategory, zipcode: zipCode ?? 0, itemauctiontype: itemAuctionType, condition: condition, endtime: endTime ?? 0, quantity: quantity , state: state , uid: uid, currencyString: currencyString)
                        
                        self.watchListArr.append(watchItems)
                        
                        
                    }
                    print("watchlistnew = \(self.watchListArr)")
                    if self.watchListArr.count > 0 {
                      self.collView.reloadData()
                        self.errorimg.isHidden = true
                        self.emptyMessage.isHidden = true
                    }
                    else {
                        self.errorimg.isHidden = false
                        self.emptyMessage.isHidden = false
                        self.emptyMessage.text = "Item not added in Wishlist."
                    }
                    
                }else{
//                    self.errorimg.isHidden = false
//                    self.emptyMessage.text = "Item not added in Wishlist."
                    
                }
            }else{
                
            }
        })
    }
    
    
    

    
    private func cutomizeCollectionView(){
        //custom collectionView Cell size
        
        let bounds = UIScreen.main.bounds
        let width = (bounds.size.width - leftAndRightPaddings) / numberOfItemsPerRow
        let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
        //layout.itemSize = CGSize(width, width + heightAdjustment)
        layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
    }
    
    private func hideCollectionView(hideYesNo : Bool) {
        
        emptyMessage.text = "Active Watch List is Empty"
        if hideYesNo == false {
            collView.isHidden = false
            
            fidgetImageView.isHidden = false
            emptyMessage.isHidden = true
            errorimg.isHidden = true
        }
        else  {
            fidgetImageView.isHidden = true
            fidgetImageView.image = nil
            collView.isHidden = true
            
            emptyMessage.isHidden = false
            errorimg.isHidden = false
        }
    }
    
    
    private func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    internal func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Watch List".localizableString(loc: LanguageChangeCode))
    }
    
    
}

//MARK:- Collection View Life Cylce.
extension ActiveWatchListVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return watchListArray.count
        return watchListArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! productCollectionViewCell
        
        let instance = watchListArr
        guard indexPath.row < instance.count else {return cell}
        let product = instance[indexPath.row]
        
        var Image = ""
        if product.oldImage.count > 0 {
            Image = product.oldImage[0]
        }
        
        cell.itemImage.sd_setImage(with: URL(string: Image), placeholderImage: UIImage(named: "emptyImage"))
        cell.titleLbl.text = product.title
        // @ AK jan-16
        
        let symbol = product.currencyString
        let Price = product.startPrice
        let finalPrice = "\(symbol) \(Price)"
        
        if self.watchListArr[indexPath.row].itemAuctionType == "buy-it-now" {
            cell.buyNowBtn.setTitle(finalPrice, for: .normal)
            cell.quantityLbl.text = "\(product.quantity) Avaialble"
            cell.quantityLbl.isHidden = false
        }else {
            cell.buyNowBtn.setTitle(finalPrice, for: .normal)
            cell.quantityLbl.isHidden = true
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let instance = watchListArr
         guard indexPath.row < instance.count else {return}
         let Category = instance[indexPath.row].itemCategory
        if Category.lowercased() == "jobs" {
              let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
              let controller = storyBoard_.instantiateViewController(withIdentifier: "JobsDetailVC") as! JobsDetailVC
            controller.ImageArray = instance[indexPath.row].oldImage
              controller.itemName = instance[indexPath.row].title
              controller.itemId = instance[indexPath.row].ItemId
              controller.sellerId = instance[indexPath.row].uid
              controller.modalPresentationStyle = .fullScreen
              self.present(controller, animated: true, completion: nil)
          }
        else if Category.lowercased() == "services" {
              let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
              let controller = storyBoard_.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
              controller.ImageArray = instance[indexPath.row].oldImage
              controller.itemName = instance[indexPath.row].title
              controller.itemId = instance[indexPath.row].ItemId
              controller.sellerId = instance[indexPath.row].uid
              controller.modalPresentationStyle = .fullScreen
              self.present(controller, animated: true, completion: nil)
          }
        else if Category.lowercased() == "vehicles" {
              let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
              let controller = storyBoard_.instantiateViewController(withIdentifier: "VehicleDetailVC") as! VehicleDetailVC
              controller.ImageArray = instance[indexPath.row].oldImage
              controller.itemName = instance[indexPath.row].title
              controller.itemId = instance[indexPath.row].ItemId
              controller.sellerId = instance[indexPath.row].uid
              controller.modalPresentationStyle = .fullScreen
              self.present(controller, animated: true, completion: nil)
          }
        else if Category.lowercased() == "housing" {
              
              let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
              let controller = storyBoard_.instantiateViewController(withIdentifier: "HousingDetailVC") as! HousingDetailVC
              controller.ImageArray = instance[indexPath.row].oldImage
              controller.itemName = instance[indexPath.row].title
              controller.itemId = instance[indexPath.row].ItemId
              controller.sellerId = instance[indexPath.row].uid
              controller.modalPresentationStyle = .fullScreen
              self.present(controller, animated: true, completion: nil)
          }
         
          else {
              let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
              let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
              controller.itemName = instance[indexPath.row].title
              controller.itemId = instance[indexPath.row].ItemId
              controller.sellerId = instance[indexPath.row].uid
              controller.ImageArray = instance[indexPath.row].oldImage
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
                   getWatchListItem()
                }
    
            }
        }
    
    
    
    
}

