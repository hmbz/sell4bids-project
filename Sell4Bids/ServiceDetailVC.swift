//
//  ServiceDetailVC.swift
//  Sell4Bids
//
//  Created by admin on 11/5/19.
//  Copyright © 2019 admin. All rights reserved.
//


import UIKit
import Cosmos
import MapKit
import SDWebImage
import GoogleMaps

class ServiceDetailVC: UIViewController,GMSMapViewDelegate,UIGestureRecognizerDelegate {
    
    //MARK:- Properties and Otlets
    @IBOutlet weak var housingScrollView: UIScrollView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var watchlistBtn: UIButton!
    @IBOutlet weak var appShareBtn: UIButton!
    @IBOutlet weak var itemShareBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var imageCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    @IBOutlet weak var OfferOrderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewOfferBtn: UIButton!
    @IBOutlet weak var viewOrderBtn: UIButton!
    @IBOutlet weak var thumbnailCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var listedByYouLbl: UILabel!
    @IBOutlet weak var listedByYouLblHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var itemPostedTimeLbl: UILabel!
    @IBOutlet weak var listedEndedLbl: UILabel!
    @IBOutlet weak var listedEndedLblHeight: NSLayoutConstraint!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userRatingControl: CosmosView!
    @IBOutlet weak var userRatingLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    @IBOutlet weak var mapAddressLbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var shareItemBottomBtn: UIButton!
    @IBOutlet weak var addedToWatchlistBtn: UIButton!
    @IBOutlet weak var reportListingBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var buyNowBtn: UIButton!
    @IBOutlet weak var offerNowBtn: UIButton!
    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var remainingTimeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var daysLbl: UILabel!
    @IBOutlet weak var daysTextLbl: UILabel!
    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var hourTextLbl: UILabel!
    @IBOutlet weak var minuteLbl: UILabel!
    @IBOutlet weak var minTextLbl: UILabel!
    @IBOutlet weak var secLbl: UILabel!
    @IBOutlet weak var secTextLbl: UILabel!
    
    // User Button
    @IBOutlet weak var acceptOfferBtn: UIButton!
    @IBOutlet weak var newOrderBtn: UIButton!
    @IBOutlet weak var showHideItemBtn: UIButton!
    @IBOutlet weak var reListItemBtn: UIButton!
    @IBOutlet weak var automaticRelistBtn: UIButton!
    @IBOutlet weak var turboChargeBtn: UIButton!
    @IBOutlet weak var endListingBtn: UIButton!
    @IBOutlet weak var userButtonStackHeight: NSLayoutConstraint!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var loadDataView: UIView!
    @IBOutlet weak var userViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rightArrowImg: UIImageView!
    
    
    //MARK:- Variables and constants
    var cordinates = CLLocationCoordinate2D()
    // For custom Collection View Cell Id
    lazy var MyCollectionViewCellId: String = "itemDetailCollectionViewCell"
    // Previous View Data getting Variables
    var itemId : String?
    var sellerId: String?
    var itemName : String?
    var ImageArray = [String]()
    // Models
    lazy var orderArray = [orderModel]()
    lazy var offerArray = [offerModel]()
    lazy var ChatMessage = [ChatMessageList]()
    var UserDetail : SellerDetailModel?
    var selectedProduct : serviceDetailModel?
    var ReportItemTxt = String()
    var timer:Timer?
    
     //    Custom View For Offer Now functionality
    let offerNowDialogue = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    let OfferNowCustomView = Bundle.main.loadNibNamed("singleTextFieldView", owner: self, options: nil)?.first as! singleTextFieldView
    //    Custom View For Bid Now functionality
    let bidNowDialogue = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    let BidNowCustomView = Bundle.main.loadNibNamed("Buy_Now_Custom_View", owner: self, options: nil)?.first as! BuyNowCustomView
    //    Custom View For report listing functionality
    let Report_Item_View = Bundle.main.loadNibNamed("ReportItemCustomView", owner: self, options: nil)?.first as! ReportItemView
    let Report_Alert_View = UIAlertController(title: "", message: "", preferredStyle: .alert)
    //item set quantity
    let setItemQuanityDialogue = UIAlertController(title: "", message: "", preferredStyle: .alert)
    let setItemQuantityCustomView = Bundle.main.loadNibNamed("Buy_Now_Custom_View", owner: self, options: nil)?.first as! BuyNowCustomView
    
    //Relist item custom View
    let relistItemCustomView = Bundle.main.loadNibNamed("ItemRelistView", owner: self, options: nil)?.first as! itemRelist_ViewVC
    let relistItemDialogue = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    //Counter offer button tapped
    var SendCounterOffer = Bundle.main.loadNibNamed("OfferNow_Custom_View", owner: self, options: nil)?.first as! OfferNowCustomView
    var SendCounterOfferAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    let ShowSellerCounteOffer = Bundle.main.loadNibNamed("ShowSellerCounterOffer", owner: self, options: nil)?.first as! SellerCounerOffer
    let ShowSellerCounteOffer_View = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    // Reject Offer View
    let RejectOfferView = Bundle.main.loadNibNamed("Reject_Order_View", owner: self, options: nil)?.first as! RejectedOrderView
    var RejectOfferViewAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    
    let list1 = ["3 Days","5 Days","7 Days","10 Days", "15 Days","21 Days","30 Days"]
    var selectedDate = Int()
    
    // Endlisting Custom View.
    let endListingCustomView = Bundle.main.loadNibNamed("EndlistingCustomView", owner: self, options: nil)?.first as! EndListingView
    let endListingDialogue = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    var EndlistReason = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailViews()
        performActionOnButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadData()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            if let layout = self.imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                var itemHeight = CGFloat()
                if UIDevice.current.model.contains("iPhone") {
                    itemHeight = 350
                }
                else if UIDevice.current.model.contains("iPad") {
                    itemHeight =  400
                }
                layout.itemSize = CGSize(width: self.imageCollectionView.frame.width, height: itemHeight)
                layout.invalidateLayout()
            }
        }
        
    }
    
    //MARK:- Private function
    private func setupDetailViews() {
        
        // giving shadow to the buttons
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        //        imageCollectionView.layout
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
        chatBtn.shadowView()
        offerNowBtn.shadowView()
        buyNowBtn.shadowView()
        viewOfferBtn.shadowView()
        viewOrderBtn.shadowView()
        itemNameLbl.layer.masksToBounds = true
        //UserButton
        acceptOfferBtn.shadowView()
        newOrderBtn.shadowView()
        showHideItemBtn.shadowView()
        reListItemBtn.shadowView()
        automaticRelistBtn.shadowView()
        turboChargeBtn.shadowView()
        endListingBtn.shadowView()
        // setting up Price Shadow for White background Images
        priceLbl.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        priceLbl.layer.shadowRadius = 2.0
        priceLbl.layer.shadowOpacity = 1.0
        priceLbl.layer.shadowOffset = CGSize(width: 0, height: 1)
        priceLbl.layer.masksToBounds = false
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        self.imageCollectionView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        self.thumbnailCollectionView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        // giving tag to the Button for animation
        watchlistBtn.tag = 5
        
    }
    
    private func showDataOnView() {
        
        self.loadDataView.isHidden = true
        
        let timestamp = Date().currentTimeMillis()
        let timeRemaining = ((selectedProduct?.endTime ?? 0) - timestamp)
        var currencySymbol = ""
        if selectedProduct?.currenySymbol != "" {
            currencySymbol = selectedProduct?.currenySymbol ?? ""
        }else {
            currencySymbol = selectedProduct?.currencyString ?? ""
        }
        self.priceLbl.text = "\(currencySymbol) \(selectedProduct?.startPrice ?? 0)"
        self.nameLbl.text = self.itemName ?? ""
        self.descriptionLbl.text = selectedProduct?.description
        self.categoryLbl.text = selectedProduct?.serviceType
        let address = "\(selectedProduct?.city ?? ""), \(selectedProduct?.state ?? "") \(selectedProduct?.zipCode ?? 0)"
        self.addressLbl.text = address
        self.mapAddressLbl.text = address
        self.pageControl.numberOfPages = selectedProduct?.imagePath?.count ?? 0
        self.itemNameLbl.text = " \(selectedProduct?.title ?? "")"
        let startTime:TimeInterval = Double(selectedProduct?.chargeTime ?? 0)
        let miliToDate = Date(timeIntervalSince1970:startTime/1000)
        let calender  = NSCalendar.current as NSCalendar
        let unitflags = NSCalendar.Unit([.day,.hour,.minute,.second,.month,.year])
        let diffDate = calender.components(unitflags, from:miliToDate, to: Date())
        let days = diffDate.day
        let hours = diffDate.hour
        let minutes = diffDate.minute
        let seconds = diffDate.second
        let months = diffDate.month
        if months ?? 0 > 1 {
            itemPostedTimeLbl.text = "\(months!) months ago."
        }
        else if days ?? 0 > 1 {
            itemPostedTimeLbl.text = "\(days!) days ago."
        }
        else if  hours ?? 0 < 24 && hours ?? 0 > 1{
            itemPostedTimeLbl.text = "\(hours!) hours ago."
        }
        else if minutes ?? 0 < 60 && minutes ?? 0 > 1 {
            itemPostedTimeLbl.text = "\(minutes!) minutes ago."
        }
        else if seconds ?? 0 < 60 && seconds ?? 0 > 1{
            itemPostedTimeLbl.text = "\(seconds!) seconds ago."
        }else {
            itemPostedTimeLbl.text = ""
        }
        
        updateTimer(currentTime: nil)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(currentTime: )), userInfo: nil, repeats: true)
        
        
        GetUserDetails(uid: selectedProduct?.uid ?? "")
        self.conditionLbl.text = selectedProduct?.condition
        
        cordinates.latitude = selectedProduct?.latitude ?? 0
        cordinates.longitude = selectedProduct?.longitude ?? 0
        self.mapView.delegate = self
        let  circleCenter = CLLocationCoordinate2D(latitude: cordinates.latitude, longitude: cordinates.longitude)
        var cirlce: GMSCircle!
        cirlce = GMSCircle(position: circleCenter, radius: 500)
        cirlce.fillColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 250.0/255.0, alpha:1.0)
        cirlce.map = mapView
        let GMSCameraPos = GMSCameraPosition.init(latitude: cordinates.latitude, longitude: cordinates.longitude, zoom: 14)
        self.mapView.camera = GMSCameraPos
        
        if ImageArray.count > 1 {
            thumbnailCollectionViewHeight.constant = 60
            self.pageControl.isHidden = false
        }else {
            thumbnailCollectionViewHeight.constant = 0
            self.pageControl.isHidden = true
        }
        
        let userId = SessionManager.shared.userId
        if userId == self.selectedProduct?.uid {
            
            //Showing User view
            self.userViewHeight.constant = 0
            self.rightArrowImg.isHidden = true
            self.userNameLbl.isHidden = true
            self.userRatingLbl.isHidden = true
            self.userRatingControl.isHidden = true
            self.userProfileImage.isHidden = true
            
            // If User is Seller
            self.offerNowBtn.isHidden = true
            self.buyNowBtn.isHidden = true
            self.chatBtn.isHidden = true
            
            self.listedByYouLblHeight.constant = 25
            self.listedByYouLbl.isHidden = false
            

            
            if selectedProduct?.acceptOffers == true{
                self.acceptOfferBtn.setTitle("StrStopAcceptingOffer".localizableString(loc: LanguageChangeCode), for: .normal)
                self.acceptOfferBtn.backgroundColor = UIColor.white
                self.acceptOfferBtn.setTitleColor(UIColor.black, for: .normal)
            }else {
                self.acceptOfferBtn.setTitle("StrAcceptOffer".localizableString(loc: LanguageChangeCode), for: .normal)
                self.acceptOfferBtn.backgroundColor = UIColor.black
                self.acceptOfferBtn.setTitleColor(UIColor.white, for: .normal)
            }
            
            if selectedProduct?.ordering == true {
                self.newOrderBtn.setTitle(StrStopNewOrders, for: .normal)
                self.newOrderBtn.backgroundColor = UIColor.white
                self.newOrderBtn.setTitleColor(UIColor.black, for: .normal)
            }else {
                self.newOrderBtn.setTitle("StrGetNewOrders".localizableString(loc: LanguageChangeCode), for: .normal)
                self.newOrderBtn.backgroundColor = UIColor.black
                self.newOrderBtn.setTitleColor(UIColor.white, for: .normal)
            }
            
            if selectedProduct?.visibility == true {
                self.showHideItemBtn.setTitle("StrHideItem".localizableString(loc: LanguageChangeCode), for: .normal)
                self.showHideItemBtn.backgroundColor = UIColor.white
                self.showHideItemBtn.setTitleColor(UIColor.black, for: .normal)
            }else {
                self.showHideItemBtn.setTitle("StrShowItem".localizableString(loc: LanguageChangeCode), for: .normal)
                self.showHideItemBtn.backgroundColor = UIColor.black
                self.showHideItemBtn.setTitleColor(UIColor.white, for: .normal)
            }
            
            if selectedProduct?.autoReList == true {
                self.automaticRelistBtn.setTitle("StrStopAutomaticallyRelisting".localizableString(loc: LanguageChangeCode), for: .normal)
                self.automaticRelistBtn.backgroundColor = UIColor.white
                self.automaticRelistBtn.setTitleColor(UIColor.black, for: .normal)
            }else {
                self.automaticRelistBtn.setTitle("StrAutomaticallyRelisting".localizableString(loc: LanguageChangeCode), for: .normal)
                self.automaticRelistBtn.backgroundColor = UIColor.black
                self.automaticRelistBtn.setTitleColor(UIColor.white, for: .normal)
            }

            if timeRemaining == 0 || timeRemaining < -1 && selectedProduct?.endTime != -1  {
                self.reListItemBtn.isHidden = false
                self.endListingBtn.isHidden = true
                self.listedEndedLbl.text = "Listing Ended"
            }else {
                self.reListItemBtn.isHidden = true
                self.endListingBtn.isHidden = false
            }
            
            self.userButtonStackHeight.constant = 297
            self.acceptOfferBtn.isHidden = false
            self.newOrderBtn.isHidden = false
            self.showHideItemBtn.isHidden = false
            self.automaticRelistBtn.isHidden = false
            self.turboChargeBtn.isHidden = false
           
            self.OfferOrderViewHeight.constant = 40
            self.viewOfferBtn.isHidden = false
            self.viewOrderBtn.isHidden = false
            if selectedProduct?.quantity ?? 0 > 0 {
                self.quantityLbl.text = "(\(selectedProduct?.quantity ?? 0) Available)"
            }else {
                self.quantityLbl.text = "Out of stock"
            }

            
        }else {
            
            //Showing User view
            self.userViewHeight.constant = 100
            self.rightArrowImg.isHidden = false
            self.userNameLbl.isHidden = false
            self.userRatingLbl.isHidden = false
            self.userRatingControl.isHidden = false
            self.userProfileImage.isHidden = false
            
            // If user is buyer
            self.userButtonStackHeight.constant = 0
            self.acceptOfferBtn.isHidden = true
            self.newOrderBtn.isHidden = true
            self.showHideItemBtn.isHidden = true
            self.automaticRelistBtn.isHidden = true
            self.turboChargeBtn.isHidden = true
            self.OfferOrderViewHeight.constant = 0
            self.listedByYouLblHeight.constant = 0
            
            self.reListItemBtn.isHidden = true
            self.endListingBtn.isHidden = true
            
            self.viewOfferBtn.isHidden = true
            self.viewOrderBtn.isHidden = true
            self.listedByYouLbl.isHidden = true
            
            if selectedProduct?.acceptOffers == true{
                self.offerNowBtn.isHidden = false
            }else {
                self.offerNowBtn.isHidden = true
            }
            self.listedEndedLbl.text = ""
            self.buyNowBtn.isHidden = false
            self.OfferOrderViewHeight.constant = 0
        }
        
        
        if selectedProduct?.orderArray.count ?? 0 > 0 {
            self.offerNowBtn.isUserInteractionEnabled = false
            self.buyNowBtn.isUserInteractionEnabled = false

            self.offerNowBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
        else if selectedProduct?.offerArray.count ?? 0 > 0 {
                self.offerNowBtn.isUserInteractionEnabled = false
                self.buyNowBtn.isUserInteractionEnabled = false

                self.offerNowBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }
        else {
            self.offerNowBtn.isUserInteractionEnabled = true
            self.buyNowBtn.isUserInteractionEnabled = true
            
            self.offerNowBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.buyNowBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }

            // ckecking for simple Listing
            // setting up the colors of the Buttons
      if selectedProduct?.endTime == -1{
        
      }else{
            if timeRemaining == 0 || timeRemaining < -1  {
                self.offerNowBtn.isUserInteractionEnabled = false
                self.buyNowBtn.isUserInteractionEnabled = false
                self.offerNowBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                
                self.listedEndedLblHeight.constant = 25
            }
            else{
//                self.offerNowBtn.isUserInteractionEnabled = true
//                self.buyNowBtn.isUserInteractionEnabled = true
//                self.offerNowBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//                self.buyNowBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//
//                self.listedEndedLblHeight.constant = 0
            }

  }
      
        if selectedProduct!.watchlistStatus ?? false {
            self.addedToWatchlistBtn.setTitle("StrRemoveFromWatchlist".localizableString(loc: LanguageChangeCode), for: .normal)
            self.watchlistBtn.setImage(UIImage(named: "Heart Filled"), for: .normal)
        }else {
            self.addedToWatchlistBtn.setTitle("StrAddToWatchlist".localizableString(loc: LanguageChangeCode), for: .normal)
            self.watchlistBtn.setImage(UIImage(named: "Heart"), for: .normal)
        }
        if selectedProduct?.offerArray.count ?? 0 > 0 {
            if selectedProduct?.offerArray.last?.role ?? "" == "seller" {
                self.offerNowBtn.backgroundColor = UIColor.gray
                self.buyNowBtn.backgroundColor = UIColor.gray
                self.buyNowBtn.isEnabled = false
                self.offerNowBtn.isEnabled = false
                if selectedProduct?.orderArray.last?.OfferCount == 5 {
                    showSwiftMessageWithParams(theme: .info, title: "Counter Offer", body: "You exceed the limit of counter offer.")
                }else {
                    self.showCounterOfferView()
                }
            }else if selectedProduct?.offerArray.last?.role ?? "" == "buyer" {
                self.offerNowBtn.backgroundColor = UIColor.gray
                self.buyNowBtn.backgroundColor = UIColor.gray
                self.buyNowBtn.isEnabled = false
                self.offerNowBtn.isEnabled = false
            }else {
                self.offerNowBtn.backgroundColor = UIColor.black
                self.buyNowBtn.backgroundColor = UIColor.black
                self.buyNowBtn.isEnabled = true
                self.offerNowBtn.isEnabled = true
            }
        }else {
            print("No offer placed yet")
        }
    }
    
    private func performActionOnButtons() {
        self.backBtn.addTarget(self, action: #selector(backBtnTapped(sender:)), for: .touchUpInside)
        self.appShareBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.shareItemBottomBtn.addTarget(self, action: #selector(itemShareBtnTapped(sender:)), for: .touchUpInside)
        self.itemShareBtn.addTarget(self, action: #selector(itemShareBtnTapped(sender:)), for: .touchUpInside)
        self.addedToWatchlistBtn.addTarget(self, action: #selector(addToWatchListBtnTapped(sender:)), for: .touchUpInside)
        self.watchlistBtn.addTarget(self, action: #selector(addToWatchListBtnTapped(sender:)), for: .touchUpInside)
        self.reportListingBtn.addTarget(self, action: #selector(reportListingBtnTapped(sender:)), for: .touchUpInside)
        self.chatBtn.addTarget(self, action: #selector(chatBtnTapped(sender:)), for: .touchUpInside)
        self.buyNowBtn.addTarget(self, action: #selector(buyNowBtnTapped(sender:)), for: .touchUpInside)
        self.offerNowBtn.addTarget(self, action: #selector(offerNowBtnTapped(sender:)), for: .touchUpInside)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.moveToUserProfile(sender:)))
        self.userProfileView.addGestureRecognizer(gesture)
        
        self.viewOfferBtn.addTarget(self, action: #selector(viewOfferBtnTapped(sender:)), for: .touchUpInside)
        self.viewOrderBtn.addTarget(self, action: #selector(viewOrderBtnTapped(sender:)), for: .touchUpInside)
        
        // UserDetail
        self.acceptOfferBtn.addTarget(self, action: #selector(acceptOfferBtnTapped(sender:)), for: .touchUpInside)
        self.newOrderBtn.addTarget(self, action: #selector(newOrderBtnTapped(sender:)), for: .touchUpInside)
        self.showHideItemBtn.addTarget(self, action: #selector(hideshowItemBtnTapped(sender:)), for: .touchUpInside)
        self.reListItemBtn.addTarget(self, action: #selector(reListItemBtnTapped(sender:)), for: .touchUpInside)
        self.automaticRelistBtn.addTarget(self, action: #selector(AutomaticallyListItemBtnTapped(sender:)), for: .touchUpInside)
        self.turboChargeBtn.addTarget(self, action: #selector(turboChanrgeBtnTapped(sender:)), for: .touchUpInside)
        self.endListingBtn.addTarget(self, action: #selector(endListingBtnTapped(sender:)), for: .touchUpInside)
    }
    
    private func reloadData() {
        
        if SessionManager.shared.isUserLoggedIn == true {
            let parameter:[String:Any] = ["uid": SessionManager.shared.userId, "item_id" : self.itemId ?? "" ,"seller_uid" : self.sellerId ?? "","platform" : "iOS"]
            
            Networking.instance.postApiCall(url: itemDetailUrl, param: parameter) { (response, error, statusCode) in
                print(response)
                let status = response["status"].bool ?? false
                if status {
                    guard let jsonDic = response.dictionary else {return}
                    let watchlistStatus = jsonDic["watching"]?.bool ?? false
                    let status = jsonDic["status"]?.bool ?? false
                    let sellerIsBlocked = jsonDic["sellerIsBlocked"]?.bool ?? false
                    let unauthorized = jsonDic["unauthorized"]?.bool ?? false
                    let msgArray = jsonDic["message"]?.array ?? []
                    for item in msgArray {
                        guard let msgDic = item.dictionary else {return}
                        // ID's Used in the Data
                        let itemId = msgDic["_id"]?.string ?? ""
                        let uid = msgDic["uid"]?.string ?? ""
                        // Set Data on Data
                        let startPrice = msgDic["startPrice"]?.int ?? 0
                        let condition = msgDic["condition"]?.string ?? ""
                        let imagePath = msgDic["images_path"]?.array ?? []
                        let imagePathSmall = msgDic["images_small_path"]?.array ?? []
                        let title = msgDic["title"]?.string ?? ""
                        let itemCategory = msgDic["itemCategory"]?.string ?? ""
                        let quantity = msgDic["quantity"]?.int ?? 0
                        let description = msgDic["description"]?.string ?? ""
                        // Data Used in Service
                        let serviceType = msgDic["serviceType"]?.string ?? ""
                        let userRole = msgDic["userRole"]?.string ?? ""
                        
                        // Curency
                         let currencyString = msgDic["currency_string"]?.string ?? ""
                        let currenySymbol = msgDic["currency_symbol"]?.string ?? ""
                       // Time Used
                        let chargeTime = msgDic["chargeTime"]?.int64 ?? 0
                        let startTime = msgDic["startTime"]?.int64 ?? 0
                        let endTime = msgDic["endTime"]?.int64 ?? 0
                        // Location
                        let city = msgDic["city"]?.string ?? ""
                        let zipCode = msgDic["zipcode"]?.int ?? 0
                        let state = msgDic["state"]?.string ?? ""
                        let countryCode = msgDic["country_code"]?.string ?? ""
                        guard let locDic = msgDic["loc"]?.dictionary else {return}
                        let coordinates = locDic["coordinates"]?.array ?? []
                        let longitude = coordinates[0].double ?? 0
                        let latitude = coordinates[1].double ?? 0
                        //For Condition
                        let itemAuctionType = msgDic["itemAuctionType"]?.string ?? ""
                        let acceptOffers = msgDic["acceptOffers"]?.bool ?? false
                        let ordering = msgDic["ordering"]?.bool ?? false
                        let visibility = msgDic["visibility"]?.bool ?? false
                         let autoReList = msgDic["autoReList"]?.bool ?? false
                        let platform = msgDic["platform"]?.string ?? ""
                        let listingEnded = msgDic["listingEnded"]?.bool ?? false
                        let autoListingCount = msgDic["autoListingCount"]?.int ?? -1
                        let adminVerify = msgDic["admin_verify"]?.string ?? ""
                        // Offer Order
                        self.orderArray.removeAll()
                        self.offerArray.removeAll()
                        let OrderArray = msgDic["orders"]?.array ?? []
                        for item in OrderArray {
                            let OrderDic = item.dictionary
                            let orderId = OrderDic?["_id"]?.string ?? ""
                            let sellerId = OrderDic?["seller_uid"]?.string ?? ""
                            let buyerOfferCount = OrderDic?["buyerOfferCount"]?.int ?? -1
                            let offersTypeArray = OrderDic?["offers"]?.array ?? []
                            for item in offersTypeArray {
                                let Dic = item.dictionary
                                let message = Dic?["message"]?.string ?? ""
                                let role = Dic?["role"]?.string ?? ""
                                let price = Dic?["price"]?.string ?? ""
                                let quantity = Dic?["quantity"]?.string ?? ""
                                let time = OrderDic?["time"]?.string ?? ""
                                let object = offerModel.init(message: message, role: role, price: price, quantity: quantity, time: time)
                                self.offerArray.append(object)
                            }
                            print(self.offerArray)
                            let obj = orderModel.init(orderId: orderId, sellerId: sellerId, OfferCount: buyerOfferCount, OfferArray: self.offerArray)
                            self.orderArray.append(obj)
                        }
                       // Final Data
                        self.selectedProduct =  serviceDetailModel.init(watchlistStatus: watchlistStatus, status: status, sellerIsBlocked: sellerIsBlocked, unauthorized: unauthorized, itemId: itemId, uid: uid, startPrice: startPrice, condition: condition, imagePath: imagePath, imagePathSmall: imagePathSmall, title: title, itemCategory: itemCategory, quantity: quantity, description: description,serviceType: serviceType,userRole: userRole, currencyString: currencyString, currenySymbol: currenySymbol, chargeTime: chargeTime, startTime: startTime, endTime: endTime, city: city, zipCode: zipCode, state: state, countryCode: countryCode, longitude: longitude, latitude: latitude, itemAuctionType: itemAuctionType, acceptOffers: acceptOffers, ordering: ordering, visibility: visibility, autoReList: autoReList, platform: platform, listingEnded: listingEnded, autoListingCount: autoListingCount, adminVerify: adminVerify, orderArray: self.orderArray, offerArray: self.offerArray)
                        if self.selectedProduct?.sellerIsBlocked == true {
                            self.dismiss(animated: true, completion: nil)
                            showSwiftMessageWithParams(theme: .info, title: appName, body: "strSellerBlocked".localizableString(loc: LanguageChangeCode))
                        }else {
                          self.showDataOnView()
                        }
                    }
                }
                else {
                    showSwiftMessageWithParams(theme: .info, title: appName, body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                }
            }
        }else {
            let parameter:[String:Any] = ["uid": SessionManager.shared.userId, "item_id" : self.itemId ?? "" ,"seller_uid" : self.sellerId ?? "","platform" : "iOS"]
            
            Networking.instance.postApiCall(url: itemDetailUrl, param: parameter) { (response, error, statusCode) in
                print(response)
                let status = response["status"].bool ?? false
                if status {
                    guard let jsonDic = response.dictionary else {return}
                    let watchlistStatus = jsonDic["watching"]?.bool ?? false
                    let status = jsonDic["status"]?.bool ?? false
                    let sellerIsBlocked = jsonDic["sellerIsBlocked"]?.bool ?? false
                    let unauthorized = jsonDic["unauthorized"]?.bool ?? false
                    guard let msgDic = jsonDic["message"]?.dictionary else {return}
                        // ID's Used in the Data
                        let itemId = msgDic["_id"]?.string ?? ""
                        let uid = msgDic["uid"]?.string ?? ""
                        // Set Data on Data
                        let startPrice = msgDic["startPrice"]?.int ?? 0
                        let condition = msgDic["condition"]?.string ?? ""
                        let imagePath = msgDic["images_path"]?.array ?? []
                        let imagePathSmall = msgDic["images_small_path"]?.array ?? []
                        let title = msgDic["title"]?.string ?? ""
                        let itemCategory = msgDic["itemCategory"]?.string ?? ""
                        let quantity = msgDic["quantity"]?.int ?? 0
                        let description = msgDic["description"]?.string ?? ""
                        // Data Used in Service
                        let serviceType = msgDic["serviceType"]?.string ?? ""
                        let userRole = msgDic["userRole"]?.string ?? ""
                        
                        // Curency
                         let currencyString = msgDic["currency_string"]?.string ?? ""
                        let currenySymbol = msgDic["currency_symbol"]?.string ?? ""
                       // Time Used
                        let chargeTime = msgDic["chargeTime"]?.int64 ?? 0
                        let startTime = msgDic["startTime"]?.int64 ?? 0
                        let endTime = msgDic["endTime"]?.int64 ?? 0
                        // Location
                        let city = msgDic["city"]?.string ?? ""
                        let zipCode = msgDic["zipcode"]?.int ?? 0
                        let state = msgDic["state"]?.string ?? ""
                        let countryCode = msgDic["country_code"]?.string ?? ""
                        guard let locDic = msgDic["loc"]?.dictionary else {return}
                        let coordinates = locDic["coordinates"]?.array ?? []
                        let longitude = coordinates[0].double ?? 0
                        let latitude = coordinates[1].double ?? 0
                        //For Condition
                        let itemAuctionType = msgDic["itemAuctionType"]?.string ?? ""
                        let acceptOffers = msgDic["acceptOffers"]?.bool ?? false
                        let ordering = msgDic["ordering"]?.bool ?? false
                        let visibility = msgDic["visibility"]?.bool ?? false
                         let autoReList = msgDic["autoReList"]?.bool ?? false
                        let platform = msgDic["platform"]?.string ?? ""
                        let listingEnded = msgDic["listingEnded"]?.bool ?? false
                        let autoListingCount = msgDic["autoListingCount"]?.int ?? -1
                        let adminVerify = msgDic["admin_verify"]?.string ?? ""
                        // Offer Order
                        self.orderArray.removeAll()
                        self.offerArray.removeAll()
                        let OrderArray = msgDic["orders"]?.array ?? []
                        for item in OrderArray {
                            let OrderDic = item.dictionary
                            let orderId = OrderDic?["_id"]?.string ?? ""
                            let sellerId = OrderDic?["seller_uid"]?.string ?? ""
                            let buyerOfferCount = OrderDic?["buyerOfferCount"]?.int ?? -1
                            let offersTypeArray = OrderDic?["offers"]?.array ?? []
                            for item in offersTypeArray {
                                let Dic = item.dictionary
                                let message = Dic?["message"]?.string ?? ""
                                let role = Dic?["role"]?.string ?? ""
                                let price = Dic?["price"]?.string ?? ""
                                let quantity = Dic?["quantity"]?.string ?? ""
                                let time = OrderDic?["time"]?.string ?? ""
                                let object = offerModel.init(message: message, role: role, price: price, quantity: quantity, time: time)
                                self.offerArray.append(object)
                            }
                            print(self.offerArray)
                            let obj = orderModel.init(orderId: orderId, sellerId: sellerId, OfferCount: buyerOfferCount, OfferArray: self.offerArray)
                            self.orderArray.append(obj)
                        }
                       // Final Data
                        self.selectedProduct =  serviceDetailModel.init(watchlistStatus: watchlistStatus, status: status, sellerIsBlocked: sellerIsBlocked, unauthorized: unauthorized, itemId: itemId, uid: uid, startPrice: startPrice, condition: condition, imagePath: imagePath, imagePathSmall: imagePathSmall, title: title, itemCategory: itemCategory, quantity: quantity, description: description,serviceType: serviceType,userRole: userRole, currencyString: currencyString, currenySymbol: currenySymbol, chargeTime: chargeTime, startTime: startTime, endTime: endTime, city: city, zipCode: zipCode, state: state, countryCode: countryCode, longitude: longitude, latitude: latitude, itemAuctionType: itemAuctionType, acceptOffers: acceptOffers, ordering: ordering, visibility: visibility, autoReList: autoReList, platform: platform, listingEnded: listingEnded, autoListingCount: autoListingCount, adminVerify: adminVerify, orderArray: self.orderArray, offerArray: self.offerArray)
                        if self.selectedProduct?.sellerIsBlocked == true {
                            self.dismiss(animated: true, completion: nil)
                            showSwiftMessageWithParams(theme: .info, title: appName, body: "strSellerBlocked".localizableString(loc: LanguageChangeCode))
                        }else {
                          self.showDataOnView()
                        }
                }
                else {
                    showSwiftMessageWithParams(theme: .info, title: appName, body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                }
            }
        }
    }
    
    
    private func GetUserDetails(uid : String){
        let parameter = [
            "seller_uid" : uid,
            "buyer_uid" : SessionManager.shared.userId
        ]
        Networking.instance.postApiCall(url: sellerDetailsUrl, param: parameter) { (response, Error, StatusCode) in
            print(response)
            self.userProfileView.isUserInteractionEnabled = false
            let status = response["status"].bool ?? false
            if status == true{
                guard let jsonDic = response.dictionary else {return}
                let productCount = jsonDic["productCount"]?.int ?? 0
                let following = jsonDic["following"]?.bool ?? false
                let followingCount = jsonDic["followingCount"]?.int ?? 0
                let blocked = jsonDic["blocked"]?.bool ?? false
                let messageDic =  jsonDic["message"]?.dictionary
                let image = messageDic?["image"]?.string ?? ""
                let name = messageDic?["name"]?.string ?? ""
                let userId = messageDic?["_id"]?.string ?? ""
                let followerCount = jsonDic["followerCount"]?.int ?? 0
                //                let status = jsonDic["status"]?.bool ?? false
                self.UserDetail = SellerDetailModel.init(blocked: blocked, following: following, id: userId, image: image, totalrating: 0, averagerating: 0, name: name, productCount: "\(productCount)", followerCount: "\(followerCount)", followingCount: "\(followingCount)")
                self.userProfileView.isUserInteractionEnabled = true
                
                DispatchQueue.main.async {
                    
                    self.userNameLbl.text = self.UserDetail?.name
                    self.userRatingControl.rating = self.UserDetail!.totalrating
                    self.userRatingControl.isUserInteractionEnabled = false
                    
                    let downloader = SDWebImageDownloader.init()
                    
                    downloader.downloadImage(with: URL.init(string: self.UserDetail!.image), options: .highPriority, progress: nil) { (image_, data, error, success) in
                        if let imagedownloded = image_ {
                            self.userProfileImage.image = imagedownloded
                            
                        }
                        let averageratings = Double(round(1000*self.UserDetail!.avertagerating)/1000)
                        self.userRatingLbl.text = "Total Rating: \(averageratings)"
                    }
                }
            }
            else {
                self.userProfileView.isUserInteractionEnabled = false
            }
        }
    }
    
    private func showCounterOfferView(){
        
    ShowSellerCounteOffer_View.view.frame = ShowSellerCounteOffer.frame
    ShowSellerCounteOffer_View.view.addSubview(ShowSellerCounteOffer)
    ShowSellerCounteOffer.rejectBtn.addTarget(self, action: #selector(rejectOfferBuyerBtnTapped(sender:)), for: .touchUpInside)
    ShowSellerCounteOffer.acceptBtn.addTarget(self, action: #selector(acceptOfferOnCounterOfferBtnTapped(sender:)), for: .touchUpInside)
        let quantity = selectedProduct?.offerArray.last?.quantity ?? ""
        let currencySymbol = selectedProduct?.currenySymbol ?? ""
        let amount = selectedProduct?.offerArray.last?.price ?? ""
        ShowSellerCounteOffer.textLabel.text = "You Recieved Counter Offer for Check Item. Seller is ready to sell \(quantity) item(s) at \(currencySymbol)\(amount)"
    ShowSellerCounteOffer.CloseBtn.addTarget(self, action: #selector(closeShowOfferView), for: .touchUpInside)
    ShowSellerCounteOffer.counterOfferBtn.addTarget(self, action: #selector(counterOfferBtnTapped(sender:)), for: .touchUpInside)
    self.present(ShowSellerCounteOffer_View, animated: true, completion: nil)
        
    }
    
    
    //MARK:- Actions
    
    @objc func updateTimer(currentTime: NSNumber?){
        
        let timestamp = Date().currentTimeMillis()
        let timeRemaining = ((selectedProduct?.endTime ?? 0) - timestamp)
        if timeRemaining == 0 || timeRemaining < -1{
            self.daysLbl.isHidden = true
            self.daysTextLbl.isHidden = true
            self.hourLbl.isHidden = true
            self.hourTextLbl.isHidden = true
            self.minuteLbl.isHidden = true
            self.minTextLbl.isHidden = true
            self.secLbl.isHidden = true
            self.secTextLbl.isHidden = true
            self.remainingTimeViewHeight.constant = 0
        }else{
            self.remainingTimeViewHeight.constant = 50
            self.daysLbl.isHidden = false
            self.daysTextLbl.isHidden = false
            self.hourLbl.isHidden = false
            self.hourTextLbl.isHidden = false
            self.minuteLbl.isHidden = false
            self.minTextLbl.isHidden = false
            self.secLbl.isHidden = false
            self.secTextLbl.isHidden = false
            
            let endTimeInterval:TimeInterval = TimeInterval(selectedProduct?.endTime ?? 0)
            //Convert to Date
            let endDate = Date(timeIntervalSince1970: Double(endTimeInterval) / 1000)
            //Difference between servertime and endtime
            let calendar = NSCalendar.current as NSCalendar
            let unitFlags = NSCalendar.Unit([.day,.hour,.minute,.second])
            let components = calendar.components(unitFlags, from: Date(), to: endDate )
            if let days = components.day, let hours = components.hour, let minutes = components.minute, let secs = components.second {
                if days < 0 && hours < 0 && minutes < 0 && secs < 0 {
                    //no time left to show
                }else {
                    //some time left to show
                    if days > 0 {
                        self.daysLbl.text = String(format: "%2i",days)
                    }else {
                        self.daysLbl.text = String(format: "%2i", days)
                    }
                    if hours > 0{
                        self.hourLbl.text = String(format: "%2i",hours)
                    }else {
                        self.hourLbl.text = String(format: "%2i",hours)
                    }
                    if minutes > 0 {
                        self.minuteLbl.text =  String(format: "%2i",minutes)
                    }else {
                        self.minuteLbl.text =  String(format: "%2i",minutes)
                    }
                    if secs > 0 {
                        self.secLbl.text = String(format: "%2i",secs)
                    }else {
                        self.secLbl.text = String(format: "%2i",secs)
                    }
                    
                    self.daysLbl.text = String(format: "%2i",days)
                    self.hourLbl.text = String(format: "%2i",hours)
                    self.minuteLbl.text =  String(format: "%2i",minutes)
                    self.secLbl.text = String(format: "%2i",secs)
                    
                    self.daysTextLbl.text = days > 1  ? "Days" : " Day"
                    self.hourTextLbl.text = hours > 1  ? "Hrs" : "Hr"
                    self.minTextLbl.text = minutes > 1  ? "Mins" : "Min"
                    self.secTextLbl.text = secs > 1  ? "Secs" : "Sec"
                }
            }
        }
    }
    @objc func backBtnTapped(sender: UIButton) {
        print("Back button tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func moveToUserProfile(sender: UIButton) {
        print("User Profile button tapped")
        
        if SessionManager.shared.isUserLoggedIn == true {
            let storyboard = UIStoryboard.init(name: "UserDetails", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
            controller.sellerDetail = self.UserDetail
            controller.title = self.UserDetail?.name ?? "Sell4Bid User"
            let navController = UINavigationController(rootViewController: controller)
            self.present(navController, animated: true, completion: nil)
        }else {
            SweetAlert().showAlert("strLoginRequired".localizableString(loc: LanguageChangeCode), subTitle: "strLoginRequiredForListing".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrLogIn".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: strCancel, otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let SB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    vc.modalPresentationStyle = .fullScreen
                    vc.DetailPageStatus = true
                    let navController = UINavigationController(rootViewController: vc)
                    self.present(navController, animated: true, completion: nil)
                }
            }
        }
    }
       
       @objc func viewOfferBtnTapped(sender: UIButton) {
           print("View Offer Button Tapped")
           let vc = storyboard?.instantiateViewController(withIdentifier: "OfferViewController") as! OfferViewController
           vc.itemId = self.selectedProduct?.itemId ?? ""
           vc.itemCategory = self.selectedProduct?.itemCategory ?? ""
           vc.modalPresentationStyle = .fullScreen
            let navController = UINavigationController(rootViewController: vc)
           self.present(navController, animated: true, completion: nil)
       }
       
       @objc func viewOrderBtnTapped(sender: UIButton) {
           print("View Order button tapped")
           let vc = storyboard?.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
           vc.itemId = self.selectedProduct?.itemId ?? ""
           vc.modalPresentationStyle = .fullScreen
           let navController = UINavigationController(rootViewController: vc)
           self.present(navController, animated: true, completion: nil)
       }
       
       @objc func viewBidsBtnTapped(sender: UIButton) {
           print("View Order button tapped")
           let vc = storyboard?.instantiateViewController(withIdentifier: "BidingHistoryViewVC") as! BidingHistoryViewVC
           vc.itemId = self.selectedProduct?.itemId ?? ""
           vc.currencySymbol = self.selectedProduct?.currenySymbol ?? ""
           vc.modalPresentationStyle = .fullScreen
           let navController = UINavigationController(rootViewController: vc)
           self.present(navController, animated: true, completion: nil)
       }
    
    // Offer Now Functionality
    @objc func offerNowBtnTapped(sender: UIButton) {
        print("Offer Now Button Tapped")
        if SessionManager.shared.isUserLoggedIn == true {
            OfferNowCustomView.firstTextField.delegate = self
            OfferNowCustomView.textFieldTitleLbl.text = ""
            OfferNowCustomView.titleLbl.text = "Offer"
            OfferNowCustomView.firstTextField.placeholder = "\(selectedProduct?.currenySymbol ?? "")"
            OfferNowCustomView.firstTextField.keyboardType = .numberPad
            OfferNowCustomView.sendBtn.addTarget(self, action: #selector(offerNowApiCall), for: .touchUpInside)
            OfferNowCustomView.crossBtn.addTarget(self, action: #selector(offerNowCloseBtnTapped), for: .touchUpInside)
            offerNowDialogue.view.frame = OfferNowCustomView.frame
            offerNowDialogue.view.addSubview(OfferNowCustomView)
            self.present(offerNowDialogue, animated: true, completion: nil)
        }else {
            SweetAlert().showAlert("strLoginRequired".localizableString(loc: LanguageChangeCode), subTitle: "strLoginRequiredForListing".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrLogIn".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "strCancel".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let SB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    vc.modalPresentationStyle = .fullScreen
                    vc.DetailPageStatus = true
                    let navController = UINavigationController(rootViewController: vc)
                    self.present(navController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func offerNowCloseBtnTapped(){
        offerNowDialogue.dismiss(animated: true, completion: nil)
    }
    
    @objc func offerNowApiCall() {
        let price = Int(OfferNowCustomView.firstTextField.text!) ?? 0
        if OfferNowCustomView.firstTextField.text!.isEmpty || price <= 0 {
            self.view.makeToast("Price can't be empty or less than 0", position: .top)
        }
        else {
            let parameter:[String:Any] = [
                "buyer_uid": SessionManager.shared.userId,
                "offer_price" : OfferNowCustomView.firstTextField.text!,
                "item_id" : selectedProduct?.itemId ?? "",
                "offerType" : "offers",
                "buyer_name" : SessionManager.shared.name,
                "buyer_image" : SessionManager.shared.image,
                "offer_quantity" : "1",
                "itemCategory" : selectedProduct?.itemCategory ?? ""
            ]
            Networking.instance.postApiCall(url: buyerOfferUrl, param: parameter) { (response, Error, StatusCode) in
                guard let jsonDic = response.dictionary else {return}
                let jsonStatus = jsonDic["status"]?.bool ?? false
                if jsonStatus == true {
                    let message = jsonDic["message"]?.string ?? ""
                    showSwiftMessageWithParams(theme: .success, title: "StrUpdateQuantity".localizableString(loc: LanguageChangeCode), body: message)
                    self.OfferNowCustomView.firstTextField.text = nil
                    self.reloadData()
                    self.offerNowDialogue.dismiss(animated: true, completion: nil)
                }else {
                    showSwiftMessageWithParams(theme: .info, title: "StrUpdateQuantity".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                }
            }
        }
    }
    
    //Buy Now Button Functionality
    @objc func buyNowBtnTapped(sender: UIButton) {
        print("Buy Now Button tapped")
        if SessionManager.shared.isUserLoggedIn == true {
          SweetAlert().showAlert("StrBuyNow".localizableString(loc: LanguageChangeCode), subTitle: "StrQWantToBuyItem".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrYes".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let parameter:[String:Any] = [
                        "bought_quantity" : 1,
                        "buyer_name" : SessionManager.shared.name,
                        "seller_uid" : self.selectedProduct?.uid ?? "",
                        "buyer_uid" : SessionManager.shared.userId,
                        "item_id" : self.selectedProduct?.itemId ?? "",
                        "buyer_email" : SessionManager.shared.email,
                        "buyer_image" : SessionManager.shared.image
                    ]
                    Networking.instance.postApiCall(url: buyItemUrl, param: parameter) { (response, Error, StatusCode) in
                        print(response)
                        guard let jsonDic = response.dictionary else {return}
                        let jsonStatus = jsonDic["status"]?.bool ?? false
                        if jsonStatus == true {
                            showSwiftMessageWithParams(theme: .success, title: StrOrders, body: "StrOrderPlacedSuccessfully".localizableString(loc: LanguageChangeCode))
                            self.BidNowCustomView.Quantitytxt.text = nil
                            self.reloadData()
                            self.bidNowDialogue.dismiss(animated: true, completion: nil)
                        }else {
                            showSwiftMessageWithParams(theme: .info, title: "StrUpdateQuantity".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                        }
                    }
                }
            }
        }else {
            SweetAlert().showAlert("strLoginRequired".localizableString(loc: LanguageChangeCode), subTitle: "strLoginRequiredForListing".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrLogIn".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "strCancel".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let SB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    vc.modalPresentationStyle = .fullScreen
                    vc.DetailPageStatus = true
                    let navController = UINavigationController(rootViewController: vc)
                    self.present(navController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    // Watchlist Action Button
    @objc func addToWatchListBtnTapped(sender: UIButton) {
        print("Watchlist button tapped")
        
        if SessionManager.shared.isUserLoggedIn == true {
//            let uid = self.selectedProduct?.uid ?? ""
          let a =  SessionManager.shared.userId
                   let uid = a
            let itemId = self.selectedProduct?.itemId ?? ""
            if sender.tag == 5 {
                // Applying Animation to the Top Watchlist Button :)
                sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                UIView.animate(withDuration: 2.0,
                               delay: 0,
                               usingSpringWithDamping: CGFloat(0.20),
                               initialSpringVelocity: CGFloat(6.0),
                               options: UIViewAnimationOptions.allowUserInteraction,
                               animations: {sender.transform = CGAffineTransform.identity})
            }
            
            if self.addedToWatchlistBtn.titleLabel!.text == "StrRemoveFromWatchlist".localizableString(loc: LanguageChangeCode) {
                
                let url = "\(unwatchedUrl)\(uid)/\(itemId)"
                Networking.instance.getApiCall(url: url) { (response, Error, StatusCode) in
                    print(response)
                    guard let jsonDic = response.dictionary else {return}
                    let jsonStatus = jsonDic["status"]?.bool ?? false
                    if jsonStatus == true {
                        let message = jsonDic["message"]?.string ?? ""
                        showSwiftMessageWithParams(theme: .success, title: "StrWatchlist".localizableString(loc: LanguageChangeCode), body: message)
                        self.addedToWatchlistBtn.setTitle("StrAddToWatchlist".localizableString(loc: LanguageChangeCode), for: .normal)
                       NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                        self.watchlistBtn.setImage(UIImage(named: "Heart"), for: .normal)
                    }else {
                        showSwiftMessageWithParams(theme: .info, title: "StrWatchlist".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                    }
                }
            }
            else {
                
                let url = "\(watchedUrl)\(uid)/\(itemId)"
                Networking.instance.getApiCall(url: url) { (response, Error, StatusCode) in
                    print(response)
                    guard let jsonDic = response.dictionary else {return}
                    let jsonStatus = jsonDic["status"]?.bool ?? false
                    if jsonStatus == true {
                        let message = jsonDic["message"]?.string ?? ""
                        showSwiftMessageWithParams(theme: .success, title: "StrWatchlist".localizableString(loc: LanguageChangeCode), body: message)
                        self.addedToWatchlistBtn.setTitle("StrRemoveFromWatchlist".localizableString(loc: LanguageChangeCode), for: .normal)
                        self.watchlistBtn.setImage(UIImage(named: "Heart Filled"), for: .normal)
                    }else {
                        showSwiftMessageWithParams(theme: .info, title: "StrWatchlist".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                    }
                }
            }
        }else {
            SweetAlert().showAlert("strLoginRequired".localizableString(loc: LanguageChangeCode), subTitle: "strLoginRequiredForListing".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrLogIn".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "strCancel".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let SB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    vc.modalPresentationStyle = .fullScreen
                    vc.DetailPageStatus = true
                    let navController = UINavigationController(rootViewController: vc)
                    self.present(navController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func itemShareBtnTapped(sender: UIButton) {
        print("Share Item Button tapped")
        let textToShare = "StrItemShare".localizableString(loc: LanguageChangeCode).localizableString(loc: LanguageChangeCode)
        let cat = selectedProduct?.itemCategory ?? ""
        let auction = selectedProduct?.itemAuctionType ?? ""
        let state =  selectedProduct?.state ?? ""
        let prodId = selectedProduct?.itemId ?? ""
        guard let catEncoded = cat.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        var urlString = "\(BaseUrl)/item?cat=\(catEncoded)"
        urlString.append("&auction=\(auction)")
        urlString.append("&state=\(state)")
        urlString.append("&pid=\(prodId)")
        guard let url = URL.init(string: urlString ) else { return }
        let objectsToShare = [textToShare, url] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func reportListingBtnTapped(sender: UIButton) {
        print("Report listing Button tapped")
        Report_Alert_View.view.frame = Report_Item_View.frame
               
        Report_Item_View.addShadowAndRound()
        Report_Item_View.CancelBtn.addShadowAndRound()
        Report_Item_View.SubmitBtn.addShadowAndRound()
        
        Report_Item_View.RadioImg1.tag = 1
        Report_Item_View.RadioImg2.tag = 2
        Report_Item_View.RadioImg3.tag = 3
        Report_Item_View.ReportImg4.tag = 4
        Report_Item_View.ReportImg5.tag = 5
        Report_Item_View.ReportImg6.tag = 6
        
        let RadioAction1 = UITapGestureRecognizer()
        let RadioAction2 = UITapGestureRecognizer()
        let RadioAction3 = UITapGestureRecognizer()
        let RadioAction4 = UITapGestureRecognizer()
        let RadioAction5 = UITapGestureRecognizer()
        let RadioAction6 = UITapGestureRecognizer()
        
        RadioAction1.addTarget(self, action: #selector(RadioAction1_Func))
        RadioAction2.addTarget(self, action: #selector(RadioAction2_Func))
        RadioAction3.addTarget(self, action: #selector(RadioAction3_Func))
        RadioAction4.addTarget(self, action: #selector(RadioAction4_Func))
        RadioAction5.addTarget(self, action: #selector(RadioAction5_Func))
        RadioAction6.addTarget(self, action: #selector(RadioAction6_Func))
        
        Report_Item_View.RadioImg1.addGestureRecognizer(RadioAction1)
        Report_Item_View.RadioImg2.addGestureRecognizer(RadioAction2)
        Report_Item_View.RadioImg3.addGestureRecognizer(RadioAction3)
        Report_Item_View.ReportImg4.addGestureRecognizer(RadioAction4)
        Report_Item_View.ReportImg5.addGestureRecognizer(RadioAction5)
        Report_Item_View.ReportImg6.addGestureRecognizer(RadioAction6)
        
        Report_Item_View.RadioImg1.isUserInteractionEnabled = true
        Report_Item_View.RadioImg2.isUserInteractionEnabled = true
        Report_Item_View.RadioImg3.isUserInteractionEnabled = true
        Report_Item_View.ReportImg4.isUserInteractionEnabled = true
        Report_Item_View.ReportImg5.isUserInteractionEnabled = true
        Report_Item_View.ReportImg6.isUserInteractionEnabled = true
        
        Report_Item_View.CancelBtn.addTarget(self, action: #selector(Cancel_Btn_Report), for: .touchUpInside)
        Report_Item_View.SubmitBtn.addTarget(self, action: #selector(Submit_Btn_Report), for: .touchUpInside)
        
        Report_Alert_View.view.addSubview(Report_Item_View)
        present(Report_Alert_View, animated: true, completion: nil)
    }
    
    @objc func chatBtnTapped(sender: UIButton) {
        print("chat Button tapped")
        if SessionManager.shared.isUserLoggedIn == true {
            let parameter:[String:Any] = [
                "buyer_uid" : SessionManager.shared.userId,
                "item_id" : selectedProduct?.itemId ?? "",
                "start" : 0,
                "limit" : 15
            ]
            
            Networking.instance.postApiCall(url: getChatUrl, param: parameter) { (response, Error, StatusCode) in
                self.ChatMessage.removeAll()
                print("Response Status",response)
                guard let jsonDic = response.dictionary else {return}
                let jsonStatus = jsonDic["status"]?.bool ?? false
                if jsonStatus == true {
                    let msgArray = jsonDic["message"]?.array ?? []
                    for item in msgArray{
                        guard let msgDic = item.dictionary else {return}
                        // Id's Used in the chat
                        let id = msgDic["_id"]?.string ?? ""
                        let receiverUid = msgDic["receiver_uid"]?.string ?? ""
                        let senderUid = msgDic["sender_uid"]?.string ?? ""
                        let sellerUid = msgDic["seller_uid"]?.string ?? ""
                        let buyerUid = msgDic["buyer_uid"]?.string ?? ""
                        let itemId = msgDic["item_id"]?.string ?? ""
                        
                        // Time For creation the chat
                        let createdAt = msgDic["created_at"]?.int64 ?? 0
                        let deliverTime = msgDic["delivered_time"]?.int64 ?? 0
                        
                        // Item Data on which chat is going to begin
                        let title = msgDic["title"]?.string ?? ""
                        let price = msgDic["item_price"]?.int ?? 0
                        let imagePathSmall = msgDic["images_small_path"]?.string ?? ""
                        let imagesPath = msgDic["images_path"]?.string ?? ""
                        //                    let currencyString = msgDic["currency_string"]?.string ?? ""
                        let itemCategory = msgDic["itemCategory"]?.string ?? ""
                        
                        // Details of person who send Message
                        let senderName = msgDic["sender"]?.string ?? ""
                        //                    let senderImage = msgDic["image"]?.string ?? ""
                        // Details of person who recieve message
                        let receiverName = msgDic["receiver"]?.string ?? ""
                        
                        // Chat Specific Data
                        let deliver = msgDic["delivered"]?.bool ?? false
                        let read = msgDic["read"]?.bool ?? false
                        let ItemAuctionType = msgDic["itemAuctionType"]?.string ?? ""
                        let message = msgDic["message"]?.string ?? ""
                        //                    let isTyping = msgDic["isTyping"]?.bool ?? false
                        
                        // If somebody does not read the msg make them to read
                        if receiverUid == SessionManager.shared.userId && read == false {
                            socket?.emit("read", [
                                "item_id" : itemId,
                                "receiver_uid" : receiverUid,
                                "delivered_time" : deliverTime,
                                "sender_uid" : senderUid
                            ])
                        }
                        
                        let ChatObject = ChatMessageList.init(read: read, delivered_time: deliverTime, created_at: createdAt, buyer_uid: buyerUid, message: message, itemCategory: itemCategory, sender_uid: senderUid, item_id: itemId, item_price: price, sender: senderName, itemAuctionType: ItemAuctionType, receiver_uid: receiverUid, images_small_path: imagePathSmall, delivered: deliver, seller_uid: sellerUid, id: id, images_path: imagesPath, title: title, receiver: receiverName, role: "", iserror: false)
                        self.ChatMessage.append(ChatObject)
                    }
                    // take the view towards chat Module
                    let storyboard = UIStoryboard.init(name: "chat", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogVC
                    controller.ChatMesssage = self.ChatMessage
                    controller.movetochat = true
                    controller.detailStatus = true
                    controller.modalPresentationStyle = .fullScreen
                    let navController = UINavigationController(rootViewController: controller)
                    self.present(navController, animated: true, completion: nil)
                    
                }else {
                    let newchat = ChatMessageList.init(read: false, delivered_time: 0, created_at: 0, buyer_uid: SessionManager.shared.userId, message: "", itemCategory: self.selectedProduct?.itemCategory ?? "", sender_uid: SessionManager.shared.userId, item_id: self.selectedProduct?.itemId ?? "", item_price: self.selectedProduct?.startPrice ?? 0, sender: SessionManager.shared.name, itemAuctionType: self.selectedProduct?.itemAuctionType ?? "", receiver_uid: self.selectedProduct?.uid ?? "", images_small_path: "", delivered: false, seller_uid: self.selectedProduct?.uid ?? "", id: self.selectedProduct?.itemId ?? "", images_path: "", title: self.selectedProduct?.title ?? "", receiver: self.userNameLbl.text!, role: "", iserror: false)
                    self.ChatMessage.append(newchat)
                    
                    let storyboard = UIStoryboard.init(name: "chat", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogVC
                    controller.ChatMesssage = self.ChatMessage
                    controller.movetochat = true
                    controller.detailStatus = true
                    controller.modalPresentationStyle = .fullScreen
                    let navController = UINavigationController(rootViewController: controller)
                    self.present(navController, animated: true, completion: nil)
                }
            }
        }else {
            SweetAlert().showAlert("strLoginRequired".localizableString(loc: LanguageChangeCode), subTitle: "strLoginRequiredForListing".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrLogIn".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "strCancel".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let SB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    vc.modalPresentationStyle = .fullScreen
                    vc.DetailPageStatus = true
                    let navController = UINavigationController(rootViewController: vc)
                    self.present(navController, animated: true, completion: nil)
                }
            }
        }
    }
    
   
    @objc func RadioAction1_Func() {
        Report_Item_View.RadioImg1.image = UIImage(named: "radioOn")
        Report_Item_View.RadioImg2.image =  UIImage(named: "radioOff")
        Report_Item_View.RadioImg3.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg4.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg5.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg6.image = UIImage(named: "radioOff")
        ReportItemTxt = Report_Item_View.RadioTxt1.text!
    }
    
    
    
    @objc func RadioAction2_Func() {
        Report_Item_View.RadioImg1.image = UIImage(named: "radioOff")
        Report_Item_View.RadioImg2.image =  UIImage(named: "radioOn")
        Report_Item_View.RadioImg3.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg4.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg5.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg6.image = UIImage(named: "radioOff")
        ReportItemTxt = Report_Item_View.RadioTxt2.text!
    }
    
    
    
    @objc func RadioAction3_Func() {
        Report_Item_View.RadioImg1.image = UIImage(named: "radioOff")
        Report_Item_View.RadioImg2.image =  UIImage(named: "radioOff")
        Report_Item_View.RadioImg3.image = UIImage(named: "radioOn")
        Report_Item_View.ReportImg4.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg5.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg6.image = UIImage(named: "radioOff")
        ReportItemTxt = Report_Item_View.ReportTxt3.text!
    }
    
    
    
    @objc func RadioAction4_Func() {
        Report_Item_View.RadioImg1.image = UIImage(named: "radioOff")
        Report_Item_View.RadioImg2.image =  UIImage(named: "radioOff")
        Report_Item_View.RadioImg3.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg4.image = UIImage(named: "radioOn")
        Report_Item_View.ReportImg5.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg6.image = UIImage(named: "radioOff")
        ReportItemTxt = Report_Item_View.RadioTxt4.text!
    }
    
    @objc func RadioAction5_Func() {
        Report_Item_View.RadioImg1.image = UIImage(named: "radioOff")
        Report_Item_View.RadioImg2.image =  UIImage(named: "radioOff")
        Report_Item_View.RadioImg3.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg4.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg5.image = UIImage(named: "radioOn")
        Report_Item_View.ReportImg6.image = UIImage(named: "radioOff")
        ReportItemTxt = Report_Item_View.ReportTxt5.text!
    }
    
    @objc func RadioAction6_Func() {
        Report_Item_View.RadioImg1.image = UIImage(named: "radioOff")
        Report_Item_View.RadioImg2.image =  UIImage(named: "radioOff")
        Report_Item_View.RadioImg3.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg4.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg5.image = UIImage(named: "radioOff")
        Report_Item_View.ReportImg6.image = UIImage(named: "radioOn")
        ReportItemTxt = Report_Item_View.ReportTxt6.text!
    }
    
    
    @objc func Cancel_Btn_Report() {
        Report_Alert_View.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func Submit_Btn_Report() {
      if ReportItemTxt == ""{
                    _ = SweetAlert().showAlert("Report Item", subTitle: "please Selet a reason" , style: .error)
      }else{
        let parameter = [
                   "uid" : SessionManager.shared.userId,
                   "report" : ReportItemTxt,
                   "item_id" : selectedProduct?.itemId ?? "",
                   "seller_uid" : selectedProduct?.uid ?? ""
               ]
               Networking.instance.postApiCall(url: reportItemUrl, param: parameter) { (response, Error, StatusCode) in
                   guard let jsonDic = response.dictionary else {return}
                   let jsonStatus = jsonDic["status"]?.bool ?? false
                   if jsonStatus == true {
                       let message = jsonDic["message"]?.string ?? ""
                       showSwiftMessageWithParams(theme: .success, title: "StrOrderStatus".localizableString(loc: LanguageChangeCode), body: message)
                       self.Report_Alert_View.dismiss(animated: true, completion: nil)
                   }else {
                       showSwiftMessageWithParams(theme: .info, title: "StrOrderStatus".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                   }
               }
      }
        
    }
    
    // User buttons actions
    @objc func acceptOfferBtnTapped(sender: UIButton){
        print("Accept Offer Button Tapped")
        if self.acceptOfferBtn.titleLabel?.text == StrStopAcceptingOffer {
            SweetAlert().showAlert("StrStopAcceptingOffer".localizableString(loc: LanguageChangeCode), subTitle: "StrQStopBuyerToSendOffer".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrYes".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let parameter:[String:Any] = ["acceptOffers" : false, "item_id" : self.selectedProduct?.itemId ?? ""]
                    
                    Networking.instance.postApiCall(url: acceptOfferStatusChangeUrl, param: parameter) { (response, Error, StatusCode) in
                        print(response)
                        guard let jsonDic = response.dictionary else {return}
                        let jsonStatus = jsonDic["status"]?.bool ?? false
                        if jsonStatus == true {
                            let message = jsonDic["message"]?.string ?? ""
                            showSwiftMessageWithParams(theme: .success, title: "StrOfferStatus".localizableString(loc: LanguageChangeCode), body: message)
                            self.reloadData()
                        }else {
                            showSwiftMessageWithParams(theme: .info, title: "StrOfferStatus".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                        }
                    }
                }
            }
        }
            
        else if self.acceptOfferBtn.titleLabel?.text == StrAcceptOffer{
            SweetAlert().showAlert("StrAcceptOffer".localizableString(loc: LanguageChangeCode), subTitle: "StrQAllowBuyerToSendOffer".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle:"StrYes".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let parameter:[String:Any] = ["acceptOffers" : true, "item_id" : self.selectedProduct?.itemId ?? ""]
                    Networking.instance.postApiCall(url: acceptOfferStatusChangeUrl, param: parameter) { (response, Error, StatusCode) in
                        print(response)
                        guard let jsonDic = response.dictionary else {return}
                        let jsonStatus = jsonDic["status"]?.bool ?? false
                        if jsonStatus == true {
                            let message = jsonDic["message"]?.string ?? ""
                            showSwiftMessageWithParams(theme: .success, title: "StrOfferStatus".localizableString(loc: LanguageChangeCode), body: message)
                            self.reloadData()

                        }else {
                            showSwiftMessageWithParams(theme: .info, title: "StrOfferStatus".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                        }
                    }
                }
            }
        }
    }
    
    // Stop and get New Orders buttons
    @objc func newOrderBtnTapped(sender: UIButton){
        print("Get New Order Button Tapped")
        if self.newOrderBtn.titleLabel?.text == StrStopNewOrders {
            SweetAlert().showAlert(StrStopNewOrders, subTitle: "StrQStopBuyerToSendOrder".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle:"StrYes".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let parameter:[String:Any] = ["ordering" : false, "item_id" : self.selectedProduct?.itemId ?? ""]
                    Networking.instance.postApiCall(url: ordersStatusChangeUrl, param: parameter) { (response, Error, StatusCode) in
                        guard let jsonDic = response.dictionary else {return}
                        let jsonStatus = jsonDic["status"]?.bool ?? false
                        if jsonStatus == true {
                            let message = jsonDic["message"]?.string ?? ""
                            showSwiftMessageWithParams(theme: .success, title: "StrOrderStatus".localizableString(loc: LanguageChangeCode), body: message)
                            self.reloadData()
                        }else {
                            showSwiftMessageWithParams(theme: .info, title: "StrOrderStatus".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                        }
                    }
                }
            }
        }else if self.newOrderBtn.titleLabel?.text == "StrGetNewOrders".localizableString(loc: LanguageChangeCode) {
            SweetAlert().showAlert("StrGetNewOrders".localizableString(loc: LanguageChangeCode), subTitle: "StrQAllowBuyerToSendOrder".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle:"StrYes".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (status) -> Void in
                
                if(status==true){
                    let parameter:[String:Any] = ["ordering" : true, "item_id" : self.selectedProduct?.itemId ?? ""]
                    Networking.instance.postApiCall(url: ordersStatusChangeUrl, param: parameter) { (response, Error, StatusCode) in
                        guard let jsonDic = response.dictionary else {return}
                        let jsonStatus = jsonDic["status"]?.bool ?? false
                        if jsonStatus == true {
                            let message = jsonDic["message"]?.string ?? ""
                            showSwiftMessageWithParams(theme: .success, title: "StrOrderStatus".localizableString(loc: LanguageChangeCode), body: message)
                            self.reloadData()
                        }else {
                            showSwiftMessageWithParams(theme: .info, title: "StrOrderStatus".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                        }
                    }
                }
            }
        }
    }
    
    @objc func hideshowItemBtnTapped(sender: UIButton){
        print("Show Item  Button Tapped")
        if showHideItemBtn.titleLabel!.text == "StrHideItem".localizableString(loc: LanguageChangeCode) {
            SweetAlert().showAlert("StrItemVisibility".localizableString(loc: LanguageChangeCode), subTitle: "StrQHideItemFromBuyers".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle:"StrYes".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let parameter:[String:Any] = [
                        "visibility" : false,
                        "item_id" : self.selectedProduct?.itemId ?? ""]
                    Networking.instance.postApiCall(url: itemVisibilityUrl, param: parameter) { (response, Error, StatusCode) in
                        guard let jsonDic = response.dictionary else {return}
                        let jsonStatus = jsonDic["status"]?.bool ?? false
                        if jsonStatus == true {
                            let message = jsonDic["message"]?.string ?? ""
                            showSwiftMessageWithParams(theme: .success, title: "StrItemVisibility".localizableString(loc: LanguageChangeCode), body: message)
                            self.reloadData()
                        }else {
                            showSwiftMessageWithParams(theme: .info, title: "StrItemVisibility".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                        }
                    }
                }
            }
        }else if showHideItemBtn.titleLabel!.text == "StrShowItem".localizableString(loc: LanguageChangeCode) {
            SweetAlert().showAlert("StrItemVisibility".localizableString(loc: LanguageChangeCode), subTitle: "StrQShowItemToBuyer".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle:"StrYes".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let parameter:[String:Any] = [
                        "visibility" : true,
                        "item_id" : self.selectedProduct?.itemId ?? ""]
                    Networking.instance.postApiCall(url: itemVisibilityUrl, param: parameter) { (response, Error, StatusCode) in
                        guard let jsonDic = response.dictionary else {return}
                        let jsonStatus = jsonDic["status"]?.bool ?? false
                        if jsonStatus == true {
                            let message = jsonDic["message"]?.string ?? ""
                            showSwiftMessageWithParams(theme: .success, title: "StrItemVisibility".localizableString(loc: LanguageChangeCode), body: message)
                            self.reloadData()
                        }else {
                            showSwiftMessageWithParams(theme: .info, title: "StrItemVisibility".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                        }
                    }
                }
            }
        }
    }
    
    // Relist Item View
      // Relist Item View
     @objc func reListItemBtnTapped(sender: UIButton){
            print("Re-List Button Tapped")
            selectCreatePicker(textField: relistItemCustomView.Quantitytxt, tag: 1)
            createToolBar(textField: relistItemCustomView.Quantitytxt)
            relistItemDialogue.view.frame = relistItemCustomView.frame
            relistItemCustomView.CloseBtn.addTarget(self, action: #selector(closeRelistItem), for: .touchUpInside)
            relistItemCustomView.SendOfferBtn.addTarget(self, action: #selector(relistItemApiCall), for: .touchUpInside)
            relistItemCustomView.Header1_Title.text = "Duration"
            relistItemCustomView.Quantitytxt.text = "3 Days"
            relistItemCustomView.Quantitytxt.delegate = self
            relistItemCustomView.SendOfferBtn.setTitle("Re-list", for: .normal)
            let symbol = selectedProduct?.currencyString ?? ""
            relistItemCustomView.priceTextField.placeholder = "\(symbol) Price"
         relistItemCustomView.priceTextField.becomeFirstResponder()
            relistItemCustomView.SendOfferBtn.shadowView()
            relistItemDialogue.view.addSubview(relistItemCustomView)
            self.present(relistItemDialogue, animated: true, completion: nil)
        }
     
     @objc func closeRelistItem() {
         relistItemDialogue.dismiss(animated: true, completion: nil)
     }
     
     
     //TODO:- Problem in function
     @objc func relistItemApiCall () {
         if relistItemCustomView.priceTextField.text!.isEmpty{
             showSwiftMessageWithParams(theme: .info, title: "StrRelistItem".localizableString(loc: LanguageChangeCode), body: strEmptyPriceField)
         }else if relistItemCustomView.Quantitytxt.text!.isEmpty {
             showSwiftMessageWithParams(theme: .info, title: "StrRelistItem".localizableString(loc: LanguageChangeCode), body: StrUpodateEmptyQuantity)
         }else {
             SweetAlert().showAlert("StrRelistItem".localizableString(loc: LanguageChangeCode), subTitle: "StrQDoRelistItem".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle:"StrYes".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                 if(ifYes == true){
                     let startPrice = Int(self.relistItemCustomView.priceTextField.text!)!
                     let parameter:[String:Any] = [
                         "startPrice" : startPrice,
                         "endTime" : self.selectedDate,
                         "item_id" : self.selectedProduct?.itemId ?? "",
                         "itemCategory" : self.selectedProduct?.itemCategory ?? ""
                     ]
                     Networking.instance.postApiCall(url: itemRelistUrl, param: parameter) { (response, Error, StatusCode) in
                         guard let jsonDic = response.dictionary else {return}
                         let jsonStatus = jsonDic["status"]?.bool ?? false
                         if jsonStatus == true {
                             let message = jsonDic["message"]?.string ?? ""
                             showSwiftMessageWithParams(theme: .success, title: "StrRelistItem".localizableString(loc: LanguageChangeCode), body: message)
                             self.relistItemDialogue.dismiss(animated: true, completion: nil)
                             self.relistItemCustomView.priceTextField.text = ""
                             self.relistItemCustomView.Quantitytxt.text = ""
                             self.reloadData()
                         }else {
                             showSwiftMessageWithParams(theme: .info, title: "StrRelistItem".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                         }
                     }
                 }
             }
         }
     }
    
    @objc func AutomaticallyListItemBtnTapped(sender: UIButton){
        print("Automatically Re-List Button Tapped")
        if self.automaticRelistBtn.titleLabel?.text == "StrStopAutomaticallyRelisting".localizableString(loc: LanguageChangeCode){
            SweetAlert().showAlert("StrAutomaticallyRelisting".localizableString(loc: LanguageChangeCode), subTitle: "StrQDisableAutomaticallyRelisting".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle:"StrYes".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (status) -> Void in
                if(status == true){
                    
                    let parameter:[String:Any] = [
                    "autoReList" : false,
                    "item_id" : self.selectedProduct?.itemId ?? ""
                    ]
                    Networking.instance.postApiCall(url: automaticallyRelistingUrl, param: parameter) { (response, Error, StatusCode) in
                        guard let jsonDic = response.dictionary else {return}
                        let jsonStatus = jsonDic["status"]?.bool ?? false
                        if jsonStatus == true {
                            let message = jsonDic["message"]?.string ?? ""
                            showSwiftMessageWithParams(theme: .success, title: "StrAutomaticallyRelisting".localizableString(loc: LanguageChangeCode), body: message)
                            self.reloadData()
                        }else {
                            showSwiftMessageWithParams(theme: .info, title: "StrAutomaticallyRelisting".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                        }
                    }
                }
            }
        }
            
        else if self.automaticRelistBtn.titleLabel?.text == "StrAutomaticallyRelisting".localizableString(loc: LanguageChangeCode){
            
          SweetAlert().showAlert("StrAutomaticallyRelisting".localizableString(loc: LanguageChangeCode), subTitle: "StrQEnableAutomaticallyRelisting".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrYes".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if( ifYes==true ){
                    let parameter:[String:Any] = [
                    "autoReList" : true,
                    "item_id" : self.selectedProduct?.itemId ?? ""
                    ]
                    Networking.instance.postApiCall(url: automaticallyRelistingUrl, param: parameter) { (response, Error, StatusCode) in
                        guard let jsonDic = response.dictionary else {return}
                        let jsonStatus = jsonDic["status"]?.bool ?? false
                        if jsonStatus == true {
                            let message = jsonDic["message"]?.string ?? ""
                            showSwiftMessageWithParams(theme: .success, title: "StrAutomaticallyRelisting".localizableString(loc: LanguageChangeCode), body: message)
                            self.reloadData()
                        }else {
                            showSwiftMessageWithParams(theme: .info, title: "StrAutomaticallyRelisting".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                        }
                    }
                }
            }
        }
    }
    
    @objc func turboChanrgeBtnTapped(sender: UIButton){
        print("Turbo Charge Button Tapped")
        SweetAlert().showAlert("StrTurboCharge".localizableString(loc: LanguageChangeCode), subTitle: "StrQTurboChargeItem".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle:"StrYes".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
            if ifYes == true {
                let parameter = ["item_id" : self.selectedProduct?.itemId ?? ""]
                Networking.instance.postApiCall(url: turboChargeUrl, param: parameter) { (response, Error, StatusCode) in
                    print(response)
                    guard let jsonDic = response.dictionary else {return}
                    let jsonStatus = jsonDic["status"]?.bool ?? false
                    if jsonStatus == true {
                        let message = jsonDic["message"]?.string ?? ""
                        showSwiftMessageWithParams(theme: .success, title: "StrTurboCharge".localizableString(loc: LanguageChangeCode), body: message)
                        self.reloadData()
                    }else {
                        showSwiftMessageWithParams(theme: .info, title: "StrTurboCharge".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                    }
                }
            }
        }
    }
    
    @objc func endListingBtnTapped(sender: UIButton){
        print("Turbo Charge Button Tapped")
        endListingDialogue.view.frame = endListingCustomView.frame
        endListingCustomView.addShadowAndRound()
        endListingDialogue.view.addSubview(endListingCustomView)
        endListingCustomView.CancelBtn.addShadowAndRound()
        endListingCustomView.addShadowAndRound()
        endListingCustomView.SubmitBtn.addShadowAndRound()
        
        let radiobtn1 = UITapGestureRecognizer()
        let radiobtn2 = UITapGestureRecognizer()
        let radiobtn3 = UITapGestureRecognizer()
        let radiobtn4 = UITapGestureRecognizer()
        let radiobtn5 = UITapGestureRecognizer()
        let radiobtn6 = UITapGestureRecognizer()
        
        radiobtn1.addTarget(self, action: #selector(radiobtnfun1))
        radiobtn2.addTarget(self, action: #selector(radiobtnfun2))
        radiobtn3.addTarget(self, action: #selector(radiobtnfun3))
        radiobtn4.addTarget(self, action: #selector(radiobtnfun4))
        radiobtn5.addTarget(self, action: #selector(radiobtnfun5))
        radiobtn6.addTarget(self, action: #selector(radiobtnfun6))
        
        radiobtn1.delegate = self
        radiobtn2.delegate = self
        radiobtn3.delegate = self
        radiobtn4.delegate = self
        radiobtn5.delegate = self
        radiobtn6.delegate = self
        
        endListingCustomView.RadioImg1.addGestureRecognizer(radiobtn1)
        endListingCustomView.RadioImg2.addGestureRecognizer(radiobtn2)
        endListingCustomView.RadioImg3.addGestureRecognizer(radiobtn3)
        endListingCustomView.RadioImg4.addGestureRecognizer(radiobtn4)
        endListingCustomView.RadioImg5.addGestureRecognizer(radiobtn5)
        endListingCustomView.RadioImg6.addGestureRecognizer(radiobtn6)
        
        endListingCustomView.RadioImg1.isUserInteractionEnabled = true
        endListingCustomView.RadioImg2.isUserInteractionEnabled = true
        endListingCustomView.RadioImg3.isUserInteractionEnabled = true
        endListingCustomView.RadioImg4.isUserInteractionEnabled = true
        endListingCustomView.RadioImg5.isUserInteractionEnabled = true
        endListingCustomView.RadioImg6.isUserInteractionEnabled = true
        
        endListingCustomView.RadioImg1.tag = 1
        endListingCustomView.RadioImg2.tag = 2
        endListingCustomView.RadioImg3.tag = 3
        endListingCustomView.RadioImg4.tag = 4
        endListingCustomView.RadioImg5.tag = 5
        endListingCustomView.RadioImg6.tag = 6
        
        endListingCustomView.SubmitBtn.addTarget(self, action: #selector(endListingApiCall), for: .touchUpInside)
        endListingCustomView.CancelBtn.addTarget(self, action: #selector(endListingCloseBtnTapped), for: .touchUpInside)
        
        self.present(endListingDialogue, animated: true, completion: nil)
    }
    
    @objc func radiobtnfun1() {
          
          endListingCustomView.RadioImg1.image = UIImage(named: "radioOn")
          endListingCustomView.RadioImg2.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg3.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg4.image = UIImage(named : "radioOff")
          endListingCustomView.RadioImg5.image = UIImage(named : "radioOff")
          endListingCustomView.RadioImg6.image = UIImage(named : "radioOff")
          EndlistReason = endListingCustomView.Optiontext1.text!
          
      }
      
      @objc func radiobtnfun2() {
          
          endListingCustomView.RadioImg1.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg2.image = UIImage(named: "radioOn")
          endListingCustomView.RadioImg3.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg4.image = UIImage(named : "radioOff")
          endListingCustomView.RadioImg5.image = UIImage(named : "radioOff")
          endListingCustomView.RadioImg6.image = UIImage(named : "radioOff")
          EndlistReason = endListingCustomView.Optiontext2.text!
          
      }
      
      @objc func radiobtnfun3() {
          
          endListingCustomView.RadioImg1.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg2.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg3.image = UIImage(named: "radioOn")
          endListingCustomView.RadioImg4.image = UIImage(named : "radioOff")
          endListingCustomView.RadioImg5.image = UIImage(named : "radioOff")
          endListingCustomView.RadioImg6.image = UIImage(named : "radioOff")
          EndlistReason = endListingCustomView.Optiontext3.text!
          
      }
      
      
      
      @objc func radiobtnfun4() {
          
          endListingCustomView.RadioImg1.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg2.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg3.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg4.image = UIImage(named : "radioOn")
          endListingCustomView.RadioImg5.image = UIImage(named : "radioOff")
          endListingCustomView.RadioImg6.image = UIImage(named : "radioOff")
          EndlistReason = endListingCustomView.OptionIext4.text!
          
      }
      
      @objc func radiobtnfun5() {
          
          endListingCustomView.RadioImg1.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg2.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg3.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg4.image = UIImage(named : "radioOff")
          endListingCustomView.RadioImg5.image = UIImage(named : "radioOn")
          endListingCustomView.RadioImg6.image = UIImage(named : "radioOff")
          EndlistReason = endListingCustomView.Optiontext5.text!
          
      }
      
      @objc func radiobtnfun6() {
          
          endListingCustomView.RadioImg1.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg2.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg3.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg4.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg5.image = UIImage(named: "radioOff")
          endListingCustomView.RadioImg6.image = UIImage(named: "radioOn")
          EndlistReason = endListingCustomView.Optiontext6.text!
          
      }
    
    @objc func endListingCloseBtnTapped() {
        endListingDialogue.dismiss(animated: true, completion: nil)
    }
    
    @objc func endListingApiCall() {
        let parameter = [
            "reason" : EndlistReason,
            "item_id" : self.selectedProduct?.itemId ?? ""
        ]
        Networking.instance.postApiCall(url: endListingUrl, param: parameter) { (response, Error, StatusCode) in
            print(response)
            guard let jsonDic = response.dictionary else {return}
            let jsonStatus = jsonDic["status"]?.bool ?? false
            if jsonStatus == true {
                let message = jsonDic["message"]?.string ?? ""
                showSwiftMessageWithParams(theme: .success, title: "StrEndListItem".localizableString(loc: LanguageChangeCode), body: message)
                self.endListingDialogue.dismiss(animated: true, completion: nil)
                self.reloadData()
            }else {
                showSwiftMessageWithParams(theme: .info, title: "StrEndListItem".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
            }
        }
    }
    
    //TODO:- Counter Offer Full Scenario
    
    // Close Open Counter View
    @objc func closeShowOfferView(sender: UIButton) {
        ShowSellerCounteOffer_View.dismiss(animated: true, completion: nil)
    }
    
    // Reject Offer  Button
    @objc func rejectOfferBuyerBtnTapped(sender: UIButton){
        ShowSellerCounteOffer_View.dismiss(animated: true, completion: nil)
        RejectOfferViewAlert.view.frame = RejectOfferView.frame
        RejectOfferViewAlert.view.addSubview(RejectOfferView)
        RejectOfferView.SubmitBtn.addTarget(self, action: #selector(submitReasonTappedonCounterOffer), for: .touchUpInside)
        RejectOfferView.Close_Btn.addTarget(self, action: #selector(closeRejectReason), for: .touchUpInside)
        self.present(RejectOfferViewAlert, animated: true, completion: nil)
    }
    
    @objc func submitReasonTappedonCounterOffer(sender: UIButton){
        let body:[String: Any] = [
            "buyer_name":SessionManager.shared.name,
            "buyer_image":SessionManager.shared.image,
            "buyer_uid": SessionManager.shared.userId,
            "item_id":selectedProduct?.itemId ?? "",
            "order_id":selectedProduct?.orderArray.last?.orderId ?? "",
            "orderRejectReason": RejectOfferView.Reasontxt.text!
        ]
        print(body)
        Networking.instance.postApiCall(url: rejectBuyerCounterOfferUrl, param: body) { (response, Error, Status) in
            print(response)
            guard let jsonDic = response.dictionary else {return}
            let jsonStatus = jsonDic["status"]?.bool ?? false
            if jsonStatus == true {
                let message = jsonDic["message"]?.string ?? ""
                showSwiftMessageWithParams(theme: .success, title: "StrCounterOffer".localizableString(loc: LanguageChangeCode), body: message)
                self.RejectOfferViewAlert.dismiss(animated: true, completion: nil)
                self.reloadData()
            }else {
                showSwiftMessageWithParams(theme: .info, title: "StrCounterOffer".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
            }
        }
    }
    
    @objc func closeRejectReason(){
        RejectOfferViewAlert.dismiss(animated: true, completion: nil)
    }
    
    // Accept Offer Sceanrio
    @objc func acceptOfferOnCounterOfferBtnTapped(sender: UIButton){
        SweetAlert().showAlert("StrCounterOffer".localizableString(loc: LanguageChangeCode), subTitle: "StrQWantToAcceptOffer".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrYes".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "strCancel".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
            if(ifYes == true){
                let body:[String:Any] = [
                    "buyer_name":SessionManager.shared.name,
                    "seller_image":SessionManager.shared.image,
                    "item_id":self.selectedProduct?.itemId ?? "",
                    "order_id":self.selectedProduct?.orderArray.last?.orderId ?? ""
                ]
                Networking.instance.postApiCall(url: acceptBuyerCounterOfferUrl, param: body) { (response, Error, StatusCode) in
                    print(response)
                    guard let jsonDic = response.dictionary else {return}
                    let jsonStatus = jsonDic["status"]?.bool ?? false
                    if jsonStatus == true {
                        let message = jsonDic["message"]?.string ?? ""
                        showSwiftMessageWithParams(theme: .success, title: "StrCounterOffer".localizableString(loc: LanguageChangeCode), body: message)
                        self.ShowSellerCounteOffer_View.dismiss(animated: true, completion: nil)
                        self.reloadData()
                    }else {
                        showSwiftMessageWithParams(theme: .info, title: "StrCounterOffer".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                    }
                }
            }
        }
    }

    
     @objc func counterOfferBtnTapped(sender: UIButton){
          ShowSellerCounteOffer_View.dismiss(animated: true, completion: nil)
          self.SendCounterOfferAlert.view.frame = self.SendCounterOffer.frame
          self.SendCounterOffer.CloseBtn.addTarget(self, action: #selector(SendCounterOfferclose), for: .touchUpInside)
          self.SendCounterOffer.SendOfferBtn.addTarget(self, action: #selector(sendCounterOfferTapped), for: .touchUpInside)
          self.SendCounterOfferAlert.view.addSubview(SendCounterOffer)
          self.present(SendCounterOfferAlert, animated: true, completion: nil)
      }
      
      @objc func SendCounterOfferclose() {
        self.SendCounterOfferAlert.dismiss(animated: true, completion: nil)
      }
    
    
    @objc func sendCounterOfferTapped(sender: UIButton){
        
        if SendCounterOffer.AmountPerItemtxt.text == "" {
            showSwiftMessageWithParams(theme: .error, title: "", body: "Please Enter Amount")
            SendCounterOffer.SendOfferBtn.shakeView()
        }else if SendCounterOffer.Quantitytxt.text == "" {
            showSwiftMessageWithParams(theme: .error, title: "", body: "Please Enter quantity")
            SendCounterOffer.SendOfferBtn.shakeView()
        }else {
            let body:[String:Any] = [
                "item_id": self.selectedProduct?.itemId ?? "",
                "order_id": self.selectedProduct?.orderArray.last?.orderId ?? "",
                "seller_uid": self.selectedProduct?.uid ?? "",
                "buyer_uid": SessionManager.shared.userId,
                "buyer_name": SessionManager.shared.name,
                "buyer_image": SessionManager.shared.image,
                "product_title": self.selectedProduct?.title ?? "",
                "product_state": self.selectedProduct?.state ?? "",
                "product_auction_type": self.selectedProduct?.itemAuctionType ?? "",
                "offer_price":self.selectedProduct?.offerArray.last?.price ?? "",
                "offer_quantity": self.SendCounterOffer.Quantitytxt.text!,
                "offer_count": self.selectedProduct?.offerArray.count ?? 0
            ]
            Networking.instance.postApiCall(url: buyerCounterOfferUrl, param: body) { (response, Error, Status) in
                guard let jsonDic = response.dictionary else {return}
                let jsonStatus = jsonDic["status"]?.bool ?? false
                if jsonStatus == true {
                    let message = jsonDic["message"]?.string ?? ""
                    showSwiftMessageWithParams(theme: .success, title: "StrCounterOffer".localizableString(loc: LanguageChangeCode), body: message)
                    self.SendCounterOfferAlert.dismiss(animated: true, completion: nil)
                    self.reloadData()
                }else {
                    showSwiftMessageWithParams(theme: .info, title: "StrCounterOffer".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                }
            }
        }
        
    }
    
}
extension ServiceDetailVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Textfield did begin editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  textField == OfferNowCustomView.firstTextField{
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }
        else if textField.tag == 1 || textField.tag == 2{
            if (textField.text?.count)! > 5 {
                let maxLength = 6
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }

            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)

            return replacementText.isValidDecimal(maximumFractionDigits: 2)
        }
        return true
    }
}
extension ServiceDetailVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ImageArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView{
            let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! itemDetailCollectionViewCell
            cell.userImage.sd_setImage(with: URL(string: ImageArray[indexPath.row]), placeholderImage: #imageLiteral(resourceName: "Profile-image-for-sell4bids-App-1"))
            
            return cell
        }else {
            let cell = thumbnailCollectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! itemDetailCollectionViewCell
            cell.userImage.layer.cornerRadius = 6
            cell.userImage.layer.masksToBounds = true
            cell.userImage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.userImage.layer.borderWidth = 0.5
            cell.userImage.sd_setImage(with: URL(string: ImageArray[indexPath.row]), placeholderImage: #imageLiteral(resourceName: "Profile-image-for-sell4bids-App-1"))
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCollectionView {
            return imageCollectionView.frame.size
        }else {
            return CGSize(width: 50, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "ItemDetail", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ImageViewerPopUpVc")  as! ImageViewerPopUpVc
        controller.selectedIndex = indexPath
        print("controller.selectedIndex : \(String(describing: controller.selectedIndex))")
        controller.view.backgroundColor = UIColor.white
        controller.imagesArray = ImageArray
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(collectionView == self.imageCollectionView){
            var page:Int =  Int(collectionView.contentOffset.x / collectionView.frame.size.width)
            page = page % ImageArray.count
            print("page = \(page)")
            pageControl.currentPage = Int (page)
        }
    }
}
extension ServiceDetailVC: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list1.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list1[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        relistItemCustomView.Quantitytxt.text! = list1[row]
        let days = list1[row].split(separator: " ")
        self.selectedDate = Int(days[0])!
        print("Selected_Date == \(selectedDate)")
        print("Days = \(days[0])")
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label : UILabel
        if let view = view as? UILabel{
            label = view
        }else{
            label = UILabel()
            label.textColor = UIColor.black
            label.font = AdaptiveLayout.normalBold
            label.textAlignment = .center
            label.text = list1[row]
        }
        return label
    }
    
    func selectCreatePicker(textField: UITextField , tag : Int){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.tag = tag
        textField.inputView = pickerView
    }
    
    func createToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.tintColor = UIColor.red
        textField.inputAccessoryView = toolBar
    }
    
    @objc func handleDone(){
        relistItemCustomView.Quantitytxt.endEditing(true)
    }
}
//TODO:- Scroll View Functionality
//extension ServiceDetailVC{
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//            if(velocity.y>0) {
//                //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
//                UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
//
//                    self.itemNameLbl.isHidden = true
//                    self.tabBarController?.tabBar.isHidden = true
//                }, completion: nil)
//
//            } else {
//                UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
//
//                    self.itemNameLbl.isHidden = false
//                    print("Unhide")
//                }, completion: nil)
//            }
//    }
//}

