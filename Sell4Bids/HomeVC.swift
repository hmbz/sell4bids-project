//
//  HomeVC.swift
//  Sell4Bids
//
//  Created by EHTISHAM on 8/6/19.
//  Copyright © 2019 EHTISHAM. All rights reserved.


import UIKit
import CoreLocation
import SocketIO
import NotificationCenter
import UserNotifications
import SwiftyJSON
import AuthenticationServices


class HomeVC: UIViewController,CLLocationManagerDelegate,UNUserNotificationCenterDelegate ,ASAuthorizationControllerDelegate{
    
    //MARK:- Properties and Outlets
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var drawerTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileEmailLbl: UILabel!
    @IBOutlet weak var drawerLeading: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var fidgetSpinner: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var sellBtn: UIButton!
    @IBOutlet weak var networkErrorImg: UIImageView!
    
    //MARK:- Variable
     var titleview = Bundle.main.loadNibNamed("NavigationBarMainView", owner: self, options: nil)?.first as! NavigationBarMainView // used for Navigation Bar
    let customview = Bundle.main.loadNibNamed("CustomSellNowActionBar", owner: self, options: nil)?.first as! CustomSellNowActionBar // Used for SellNow Functiobality
    lazy var drawerArray = [[drawerModel]]() // Drawer Array
    lazy var drawerSection = [""] // Drawer Sections Array
    let locationManager = CLLocationManager() // Location manager for getting current location
    // Below variables are used for location given to Networking 
    var currentLongitude : Double?
    var currentLatitude : Double?
    var currentCountry : String?
    var currentCity :String?
    var gameTimer: Timer?

    // creating Cell variable
    lazy var MyCollectionViewCellId: String = "productCollectionViewCell"
    //Status Used for status of the Api Response
    lazy var responseStatus = false
    //Getting Parent Class
    lazy var MainApis = MainSell4BidsApi()
    //Didselect Product Api Model-Variable
    lazy var orderArray = [orderModel]()
    lazy var offerArray = [offerModel]()
    //Model Arrays.
    lazy var imageInfoArray = [ImageInfoModel]()
    lazy var productArray = [productModelNew]()
    //Dictionary For Api Call
    lazy var ApiDic:[String:Any] = [:]
    // creating floating Button
    private lazy var edBotButton: UIButton = {
        let minimumTappableHeight: CGFloat?
        if Env.isIpad {
            minimumTappableHeight = 70
        }else {
            minimumTappableHeight = 60
        }
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: minimumTappableHeight!,
                                            height: minimumTappableHeight!))
        button.center = self.view.center
        button.layer.cornerRadius = minimumTappableHeight! / 2
        button.layer.masksToBounds = true
        button.setImage(UIImage(named: "ed_bot"), for: .normal)
        return button
    }()
    
    var edBotButtonFliped: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.50) {
                if self.edBotButtonFliped {
                    self.edBotButton.transform = CGAffineTransform.identity
                } else {
                    self.edBotButton.transform = CGAffineTransform(rotationAngle: .pi)
                    UIView.animate(withDuration: 0.50){
                        self.edBotButton.transform = .identity
                    }
                }
            }
        }
    }
    
    var timer = Timer()
    
    //for Notification center declaration
    var notificationCenter  = UNUserNotificationCenter.current()
    
    // For refreshing Views
    var refreshControl = UIRefreshControl()
    
    // For implementing the Transition
    // Will implement in future...for transition
    let transition = TransitionAnimator()
    var selectedCell = UICollectionViewCell()
    
    
    
    //MARK:- View Life Cycle
    //Call Once in the View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        StoreReviewHelper.checkAndAskForReview()
        topView()
        setupViews()
        if tabBarController?.selectedIndex == 2 {
            sellBtnTapped()
        }
      gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(getNotifications), userInfo: nil, repeats: true)
      gameTimer?.fire()

        // Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayUnReadNotifInTabBadge(_:)), name: NSNotification.Name("updateTabBadgeNumber"), object: nil)
        
        // Apply network call after checking network call
        if InternetAvailability.isConnectedToNetwork() == true {
            self.networkErrorImg.isHidden = true
            if SessionManager.shared.isUserLoggedIn == true {
                setupLocationViews()
                LoadApiData()
                // For sending fcm token to server
                let param:[String:Any] = [
                    "token":SessionManager.shared.fcmToken,
                    "uid": SessionManager.shared.userId
                ]
                self.sendTokenToServer(param: param)
            }else {
                
                if self.responseStatus == false {
                    self.fidgetSpinner.toggleRotateAndDisplayGif()
                    Spinner.load_Spinner(image: self.fidgetSpinner, view: self.shadowView)
                }
                setupLocationViews()
                
            }
            reloadCollectionView()
            socketSetUp()
        }
        else {
            self.productCollectionView.isHidden = true
            self.fidgetSpinner.isHidden = true
            self.networkErrorImg.isHidden = false
            do {
                let gif = try UIImage(gifName: "networkError.gif")
                self.networkErrorImg.setGifImage(gif)
            } catch {
                print(error)
            }
        }
    }
    
    // Calls Every times in the View Life
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        selectedCell.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
        self.navigationController?.navigationBar.isHidden = false
        setupViewsForPizzaMenu()
        self.tabBarController?.tabBar.isHidden = false
        sellBtn.isHidden = true
        let edBot = UserDefaults.standard.bool(forKey: SessionManager.shared.edBot)
        if edBot == true {
            edBotSetup()
        }else {
            edBotButton.removeFromSuperview()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // hiding the cell when the View disappesrs for transition purpose 
        selectedCell.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.hidesBottomBarWhenPushed = true
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        productCollectionView.collectionViewLayout.invalidateLayout()
//    }
    
    //..........................................................//
    
    //MARK:- Action
    
    // Refreshing the views
    @objc func refresh(sender:AnyObject) {
        // Code to refresh Collection view
        self.productArray.removeAll()
        productCollectionView.reloadData()
        self.ApiDic["start"] = "\(0)"
        self.getProductData(param: self.ApiDic)
        refreshControl.endRefreshing()
    }
    
    // Notification observer Count
    @objc private func displayUnReadNotifInTabBadge(_ notification: Notification) {
        if let userInfo = notification.userInfo as? [String:Int] {
            if let unRead = userInfo["unRead"]  {
                if unRead > 0 {
                    DispatchQueue.main.async {
                        var count = ""
                        if unRead > 9 {
                            count = "9+"
                        }else {
                            count = "\(unRead)"
                        }
                        self.tabBarController?.tabBar.items![4].badgeValue = "\(count)"
                    }
                }else {
                    DispatchQueue.main.async {
                        self.tabBarController?.tabBar.items![4].badgeValue = nil
                    }
                }
            }
        }
    }
    
    // EdBot Animation Timer
    @objc func timerAction() {
        self.edBotButtonFliped = !self.edBotButtonFliped
    }
    
    //TODO:- Perform action on the floating button
    @objc func drag(control: UIControl, event: UIEvent) {
        if let center = event.allTouches?.first?.location(in: self.view) {
            control.center = center
        }
    }
    @objc func btnfunc(sender: UIButton){
        //        performSegue(withIdentifier: "homeToAssist", sender: self)
        print("Move to chat")
//        let alert = UIAlertController(title: "Ed bot", message: "Hi I am Ed Bot\nYou can ask me anything", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Chat", style: .default) { (alert) in
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AssistViewController") as! AssistViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//        let layout = UICollectionViewFlowLayout()
//        let controller = ChatLogController(collectionViewLayout: layout)
//        self.navigationController?.pushViewController(controller, animated: true)
        if sender.isTouchInside {
            let SB = UIStoryboard(name: "Home", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "EdBotViewController") as! EdBotViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }

//        }
//        alert.addAction(action)
//        let close = UIAlertAction(title: "Close", style: .default) { (close) in
//            showSwiftMessageWithParams(theme: .info, title: "Ed Bot", body: "You can reactivate Ed Bot from Profile Settings")
//            UserDefaults.standard.set(false, forKey: SessionManager.shared.edBot)
//            self.edBotButton.removeFromSuperview()
//        }
//        alert.addAction(close)
//        let Cancel = UIAlertAction(title: "Cancel", style: .destructive) { (close) in
//        }
//        alert.addAction(Cancel)
//        self.present(alert, animated: true, completion: nil)
    }
    
    //TODO:- Bottom Sell or auction now btn tapped
    @objc func sellBtnTapped() {
        alertActionBarSellNow = UIAlertController(title:"", message: "Select Sell Now Option", preferredStyle: .actionSheet)
        
        //item Sell Now Gesture
        let Items_Gesture = UITapGestureRecognizer(target: self, action: #selector(ItemSellNow))
        //Job Sell Now Gesture
        let Job_Gesture = UITapGestureRecognizer(target: self, action: #selector(JobSellNow))
        //Vehicles Sell Now Gesture
        let Vehicles_Gesture = UITapGestureRecognizer(target: self, action: #selector(VehicaleSellNow))
        //Services Sell Now Gesture
        let Services_Gesture = UITapGestureRecognizer(target: self, action: #selector(ServiceSellNow))
        //Services Sell Now Gesture
        let Housing_Gesture = UITapGestureRecognizer(target: self, action: #selector(HousingSellNow))
        customview.OthersItemsLbl.isUserInteractionEnabled = true
        customview.OthersItemsLbl.addGestureRecognizer(Items_Gesture)
        //Job Sell Now Details
        customview.JobsLbl.isUserInteractionEnabled = true
        customview.JobsLbl.addGestureRecognizer(Job_Gesture)
        //Housing Sell Now Details
        customview.HousingLbl.isUserInteractionEnabled = true
        customview.HousingLbl.addGestureRecognizer(Housing_Gesture)
        //Vehicles Sell Now Details
        customview.VehiclesLbl.isUserInteractionEnabled = true
        customview.VehiclesLbl.addGestureRecognizer(Vehicles_Gesture)
        //Services Sell Now Details
        customview.isUserInteractionEnabled = true
        customview.ServiceLbl.isUserInteractionEnabled = true
        customview.ServiceLbl.addGestureRecognizer(Services_Gesture)
        customview.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: 200)
        alertActionBarSellNow.view.addSubview(customview)
        alertActionBarSellNow.view.frame = CGRect(x: 0, y: 0,width :  UIScreen.main.bounds.width, height: 100)
        alertActionBarSellNow.popoverPresentationController?.sourceView = self.view
        alertActionBarSellNow.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.minX, y: self.view.bounds.maxY, width: UIScreen.main.bounds.width, height: 0)
        self.present(alertActionBarSellNow, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
        alertActionBarSellNow.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func HousingImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
        _ = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard.init(name: "Main_Listing_Sell", bundle: nil)
        let HousingListing = storyboard.instantiateViewController(withIdentifier: "Hosing_Listing_Main")
        self.navigationController?.pushViewController(HousingListing, animated: true)
    }
    
    @objc func ServiceImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
        _ = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard.init(name: "Main_Listing_Sell", bundle: nil)
        let ServiceListing = storyboard.instantiateViewController(withIdentifier: "ServiceListingStepMainIdentifier")
        self.navigationController?.pushViewController(ServiceListing, animated: true)
    }
    
    
    @objc func VehiclesImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
        _ = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard.init(name: "Main_Listing_Sell", bundle: nil)
        let ItemListing = storyboard.instantiateViewController(withIdentifier: "MainVehicleListing")
        self.navigationController?.pushViewController(ItemListing, animated: true)
    }
    
    
    @objc func jobImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
        _ = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard.init(name: "Main_Listing_Sell", bundle: nil)
        let JobListing = storyboard.instantiateViewController(withIdentifier: "JobListingMain")
        self.navigationController?.pushViewController(JobListing, animated: true)
    }
    
    
    @objc func othersItemsImageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
        _ = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard.init(name: "Main_Listing_Sell", bundle: nil)
        let ItemListing = storyboard.instantiateViewController(withIdentifier: "MainItemListing")
        self.navigationController?.pushViewController(ItemListing, animated: true)
    }
    
    //TODO:- Moving Towards the Search View Controller
    @objc func searchbtnaction() {
        let searchVCStoryBoard = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchVCStoryBoard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVc
        searchVC.countryName = currentCity ?? "USA"
        searchVC.latitude = self.currentLatitude ?? 36.778259
        searchVC.longitude = self.currentLongitude ?? -119.417931
        searchVC.apiDic = self.ApiDic
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    //mic button Pressed on Top
    @objc func mikeTapped(){
        let searchSB = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchSB.instantiateViewController(withIdentifier: "SearchVC") as! SearchVc
        searchVC.countryName = currentCity ?? "USA"
        searchVC.latitude = self.currentLatitude ?? 36.778259
        searchVC.longitude = self.currentLongitude ?? -119.417931
        searchVC.apiDic = self.ApiDic
        searchVC.flagShowSpeechRecBox = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    //TODO:- Moving towards the Filter View Controller
    @objc func filterbtnaction(sender: UIButton) {
        let controller = UIStoryboard(name: "homeTab", bundle: nil).instantiateViewController(withIdentifier: "FiltersVc") as! FiltersVc
        controller.delegate = self
        controller.selfWasPushed = true
        controller.countryName = currentCity ?? "USA"
        controller.latitude = self.currentLatitude ?? 36.778259
        controller.longitude = self.currentLongitude ?? -119.417931
        controller.apiDic = self.ApiDic
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //TODO:- Open the PopOver for the Invitation of the Application
    @objc func invitebtnaction(_ sender : AnyObject) {
      let items =  ["shareString".localizableString(loc: LanguageChangeCode), urlAppStore] as [ Any ]
        let activityVC = UIActivityViewController(activityItems: items , applicationActivities: [])
        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        if let popoverController = activityVC.popoverPresentationController{
            popoverController.barButtonItem = sender as? UIBarButtonItem
            popoverController.permittedArrowDirections = .up
        }
        self.present(activityVC, animated:true , completion: nil)
    }
    
    //TODO:- Pizza Menu Open and close Action
    @objc func pizzaMenuTapped() {
        if drawerLeading.constant == 0 {
            self.shadowView.isHidden = true
            drawerLeading.constant = -280
        }else {
            drawerLeading.constant = 0
            self.shadowView.isHidden = false
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //TODO:- Provide action to the Swipe
    @objc func RepondtoGesture(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.left:
            swipeLeft()
        case UISwipeGestureRecognizer.Direction.right:
            swipeRight()
        default:
            break
        }
    }
    
    //TODO:- Action of the Sell Now Btn
    @objc func ItemSellNow() {
        dismiss(animated: true, completion: nil)
        if SessionManager.shared.isUserLoggedIn == true {
            let SB = UIStoryboard(name: "Listing", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "ItemListingStepOneVC") as! ItemListingStepOneVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
          SweetAlert().showAlert("strLoginRequired".localizableString(loc: LanguageChangeCode), subTitle: "strLoginRequiredForListing".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: StrLogIn, buttonColor: UIColor.black, otherButtonTitle: "strCancel".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let SB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc func JobSellNow() {
        self.dismiss(animated: true, completion: nil)
        if SessionManager.shared.isUserLoggedIn == true {
            let SB = UIStoryboard(name: "Listing", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "JobListingStepOneVC") as! JobListingStepOneVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
          SweetAlert().showAlert("strLoginRequired".localizableString(loc: LanguageChangeCode), subTitle: "strLoginRequiredForListing".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrLogIn".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "strCancel".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let SB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc func VehicaleSellNow() {
        self.dismiss(animated: true, completion: nil)
        if SessionManager.shared.isUserLoggedIn == true {
            let SB = UIStoryboard(name: "Listing", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "VehicleListingStepOneVC") as! VehicleListingStepOneVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            SweetAlert().showAlert("strLoginRequired".localizableString(loc: LanguageChangeCode), subTitle: strLoginRequiredForListing, style: AlertStyle.warning, buttonTitle: "StrLogIn".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "strCancel".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let SB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc func ServiceSellNow() {
        self.dismiss(animated: true, completion: nil)
        if SessionManager.shared.isUserLoggedIn == true {
            let SB = UIStoryboard(name: "Listing", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "ServiceListingStepOneVC") as! ServiceListingStepOneVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            SweetAlert().showAlert("strLoginRequired".localizableString(loc: LanguageChangeCode), subTitle: "strLoginRequiredForListing".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrLogIn".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "strCancel".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let SB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc func HousingSellNow() {
        self.dismiss(animated: true, completion: nil)
        if SessionManager.shared.isUserLoggedIn == true {
            let SB = UIStoryboard(name: "Listing", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "HousingListingStepOneVC") as! HousingListingStepOneVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            SweetAlert().showAlert("strLoginRequired".localizableString(loc: LanguageChangeCode), subTitle: "strLoginRequiredForListing".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrLogIn".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "strCancel".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                if(ifYes == true){
                    let SB = UIStoryboard(name: "Main", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //........................................................//
    
    //MARK:- Function
    
    private func sendTokenToServer(param:[String:Any]) {
        print("Push Notification Dic",param)
        Networking.instance.postApiCall(url: setUserTokenUrl, param: param) { (response, Error, StatusCode) in
            print(response)
        }
    }
    
  @objc private func getNotifications(){
        MainApis.Notification_Count(User_Id: SessionManager.shared.userId) { (status, data, error) in
            if status {
                let message = data!["message"].intValue
                if message > 0 {
                    let Count : String = String(message)
                    self.tabBarController!.tabBar.items![4].badgeValue = Count
                }
            }
        }
    }
    
    //TODO:- Socket Implemtaion for notifications
    private func socketSetUp() {
        socket = manager.defaultSocket
        notificationCenter.delegate = self
        socket?.on("notifications") {data, ack in
            var message = String()
            let stringnewdata = data.last! as! NSDictionary
            let data = stringnewdata["notification"] as! NSDictionary
            _ = stringnewdata["data"] as! NSDictionary
            message = data["body"] as! String
            let title = data["title"] as! String
            let identifiernew = ""
            let identifier = identifiernew
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = message
            content.sound = UNNotificationSound.default()
            content.badge = 1
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            self.notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
        
        socket?.on("new_chat", callback: { (data, error) in
            let data  = JSON(data).array ?? []
            for item in data {
                guard let chatDic = item.dictionary else {return}
                guard let dataDic = chatDic["data"]?.dictionary else {return}
                let buyerId = dataDic["buyer_uid"]?.string ?? ""
//                let count = dataDic["count"]?.int ?? -1
                let createdAt = dataDic["created_at"]?.double ?? -1
//                let deliverStatus = dataDic["delivered"]?.bool ?? false
                let deliveredTime = dataDic["delivered_time"]?.double ?? -1
                let itemAuctionType = dataDic["itemAuctionType"]?.string ?? ""
                let itemCategory = dataDic["itemCategory"]?.string ?? ""
                let itemId = dataDic["item_id"]?.string ?? ""
                let identifier = itemId
                let itemImage = dataDic["item_image"]?.string ?? ""
                let itemPrice = dataDic["item_price"]?.int ?? -1
                let itemTitle =  dataDic["item_title"]?.string ?? ""
                let message = dataDic["message"]?.string ?? ""
                let readStatus = dataDic["read"]?.bool ?? false
                let receiverName = dataDic["receiver"]?.string ?? ""
                let receiverUid = dataDic["receiver_uid"]?.string ?? ""
//                let role =  dataDic["role"]?.string ?? ""
                let sellerUid = dataDic["seller_uid"]?.string ?? ""
                let senderName = dataDic["sender"]?.string ?? ""
                let senderUid = dataDic["sender_uid"]?.string ?? ""
//                guard let notificationDic = chatDic["notification"]?.dictionary else {return}
//                let body  = notificationDic["body"]?.string ?? ""
//                let sound =  notificationDic["sound"]?.string ?? ""
//                let title = notificationDic["title"]?.string ?? ""
                
                let chat = ChatListModel.init(buyer_uid_id: buyerId, item_id_buyer_uid: itemId, item_price: "\(itemPrice)", created_at: Int64(createdAt), receiver_uid: receiverUid, item_title: itemTitle, receiver: receiverName, itemCategory: itemCategory, buyer_uid: buyerId, id: itemId, seller_uid: sellerUid, item_id: itemId, item_image: itemImage, message: message, itemAuctionType: itemAuctionType, sender: senderName, read: readStatus, sender_uid: senderUid, delivered_time: Int64(deliveredTime))
                print(chat)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let content = UNMutableNotificationContent()
                content.title = itemTitle
                content.body = message
                content.sound = UNNotificationSound.default()
                content.badge = 1
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                self.notificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Error \(error.localizedDescription)")
                    }else {
                        print("Success")
                    }
                }
            }
        })
        socket?.connect()
    }
    
    //TODO:-  LoadData
    
    private func LoadApiData(){
        let session = SessionManager.shared
        let Longitude = session.longitude
        let Latitude = session.latitude
        let City = session.City
        let state = session.State
        let zipcode =  session.ZipCode
        let currentLocation = "\(City), \(state) \(zipcode)"
        let Country = session.Country
        print(currentLocation)
        if Longitude != "" && Latitude != "" && Country != "" {
            self.currentLongitude = Double(Longitude) //Type Casting
            self.currentLatitude = Double(Latitude) // Type Casting
            self.currentCountry = Country
            self.currentCity = currentLocation
            let body:[String:Any] = ["start": "\(0)", "lng": self.currentLongitude!, "country": self.currentCountry!, "lat": self.currentLatitude!, "limit": "30"]
            self.titleview.citystateZIpcode.text = currentLocation
            self.ApiDic = body
            self.getProductData(param: self.ApiDic)
        }else {
            self.currentCountry = "USA"
            self.currentLatitude = 31.520632
            self.currentLongitude = 74.405401
            let body:[String:Any] = ["start": "\(0)","country": "USA", "lat" : 31.520632 , "lng" : 74.405401, "limit": "30"]
            self.titleview.citystateZIpcode.text = self.currentCountry
            self.ApiDic = body
            self.getProductData(param: self.ApiDic)
        }
    }
    
    
    //TODO:- Reload Collection View
    private func reloadCollectionView() {
        if let layout = productCollectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.flagKeepHeaderHeightForHomeLayout = true
        }
        let layout = self.productCollectionView.collectionViewLayout as! PinterestLayout
        layout.prepare() 
        layout.cache.removeAll()
        DispatchQueue.main.async {
            self.productCollectionView.reloadData()
        }
    }
    
    //TODO:- Network Call
    // facebook login get token api function
    func UpdateProfile(user: [String:Any]){
        let url = updateProfileURL
        loginService.instance.postApiCall(URL: url, param: user) { (success) in
            if success{
                let status = loginService.instance.status
                if status == 200 || status == 201 || status == 202{
                    SessionManager.shared.latitude = "\(self.currentLatitude!)"
                    SessionManager.shared.longitude = "\(self.currentLongitude!)"
                    SessionManager.shared.Country = self.currentCountry!
                    let body:[String:Any] = ["start": "\(0)", "lng": self.currentLongitude!, "country": self.currentCountry!, "lat": self.currentLatitude!, "limit": "30"]
                    self.ApiDic = body
                    self.getProductData(param: self.ApiDic)
                }
                else{
                    // Eroor
                }
            }
            else{
                let status = loginService.instance.status
                print(status)
            }
        }
    }
    
    
    
    private func  getProductData(param: [String:Any]){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetSpinner.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetSpinner, view: self.shadowView)
            }
        }
        Networking.instance.postApiCall(url: getFilterUrl, param: param) { (response, error, statusCode) in
            if statusCode == 502 {
                if self.drawerLeading.constant == 0 {
                    self.shadowView.isHidden = false
                }
                Spinner.stop_Spinner(image: self.fidgetSpinner, view: self.shadowView)
                self.responseStatus = true
              SweetAlert().showAlert(appName, subTitle: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode), style: .error, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black)
            }else {
                let a = response["totalCount"].int ?? 0
              if a == 0{
                SweetAlert().showAlert(appName, subTitle: "No Item Avaibable", style: .error, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black)
                self.LoadApiData()
              }
                let responseStatus = response["status"].bool ?? false
                if responseStatus {
                    guard let jsonDic = response.dictionary else {return}
                    let status = jsonDic["status"]?.bool ?? false
                    let totalCount = jsonDic["totalCount"]?.int ?? -1
                    let messageArray = jsonDic["message"]?.array ?? ["N/A"]
                    let msg = jsonDic["message"]?.string ?? ""
                    if msg != "" {
                        print(msg)
                    }
                    //Main Array
                    for item in messageArray {
                        //Main Dictionary
                        guard let MessageDic = item.dictionary else {return}
                        let adminRejected = MessageDic["admin_verify"]?.string ?? ""
                        let locDic = MessageDic["loc"]?.dictionary
                        let coordinates = locDic?["coordinates"]?.array ?? []
                        let type = locDic?["type"]?.string ?? ""
                        
                        let ImagePath = MessageDic["images_path"]?.arrayObject ?? []
                        let ImagePathSmall = MessageDic["images_small_path"]?.arrayObject ?? []
                        
                        //Array for Getting Image Info
                        self.imageInfoArray.removeAll()
                        let imagesInfoArray = MessageDic["images_info"]?.array ?? []
                        if imagesInfoArray.count > 0 {
                            for itemImages in imagesInfoArray {
                                let ImageInfoDic = itemImages.dictionary
                                let height = ImageInfoDic?["height"]?.float ?? -1
                                let ratio = ImageInfoDic?["ratio"]?.float ?? -1
                                let width = ImageInfoDic?["width"]?.float ?? -1
                                let obj = ImageInfoModel.init(height: height, ratio: ratio, width: width)
                                self.imageInfoArray.append(obj)
                            }
                        }
                        let startTime = MessageDic["startTime"]?.int64 ?? -1
                        let visibility = MessageDic["visibility"]?.bool ?? false
                        let oldSmallImages = MessageDic["old_small_images"]?.arrayObject ?? []
                        let oldImages = MessageDic["old_images"]?.arrayObject ?? []
                        let itemId = MessageDic["_id"]?.string ?? ""
                        let chargeTime = MessageDic["chargeTime"]?.int64 ?? -1
                        let city = MessageDic["city"]?.string ?? ""
                        let title = MessageDic["title"]?.string ?? ""
                        let startPrice = MessageDic["startPrice"]?.float ?? 0.0
                        let itemCategory = MessageDic["itemCategory"]?.string ?? ""
                        let zipcode = MessageDic["zipcode"]?.int ?? -1
                        let itemAuctionType = MessageDic["itemAuctionType"]?.string ?? ""
                        let uid = MessageDic["uid"]?.string ?? ""
                        let condition = MessageDic["condition"]?.string ?? ""
                        let endTime = MessageDic["endTime"]?.int64 ?? -1
                        let quantity = MessageDic["quantity"]?.int ?? -1
                        let state = MessageDic["state"]?.string ?? ""
                        let currencyString = MessageDic["currency_string"]?.string ?? ""
                        let currencySymbol = MessageDic["currency_symbol"]?.string ?? ""
                        
                        let object = productModelNew.init(status: status, totalCount: totalCount, coordinates: coordinates, type: type, ImagePath: ImagePath, ImagePathSmall: ImagePathSmall, imageInfoArray: self.imageInfoArray, startTime: startTime, visibility: visibility, oldSmallImages: oldSmallImages, oldImages: oldImages, itemId: itemId, chargeTime: chargeTime, city: city, title: title, startPrice: startPrice, itemCategory: itemCategory, zipcode: zipcode, itemAuctionType: itemAuctionType, uid: uid, condition: condition, endTime: endTime, quantity: quantity, state: state, currencyString: currencyString, currencySymbol: currencySymbol, adminRejected: adminRejected)
                        self.productArray.append(object)
                    }
                    self.reloadCollectionView()
                    self.responseStatus = true
                    self.productCollectionView.isHidden = false
                    Spinner.stop_Spinner(image: self.fidgetSpinner, view: self.shadowView)
                    if self.drawerLeading.constant == 0 {
                        self.shadowView.isHidden = false
                    }
                }
                else{
                    if error?.contains("The request timed out.") ?? false{
                        self.responseStatus = true
                        Spinner.stop_Spinner(image: self.fidgetSpinner, view: self.shadowView)
                        showSwiftMessageWithParams(theme: .info, title: "\(statusCode)", body: error ?? "")
                    }else {
                        self.responseStatus = true
                        self.productCollectionView.isHidden = false
                        Spinner.stop_Spinner(image: self.fidgetSpinner, view: self.shadowView)
                        showSwiftMessageWithParams(theme: .info, title: appName, body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                    }
                }
            }
        }
    }
    
    
    //TODO:- Fetch the Location through Logitude and latitude
    private func setupLocationViews() {
        // new code
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        // Here you can check whether you have allowed the permission or not.
        if CLLocationManager.locationServicesEnabled(){
            switch(CLLocationManager.authorizationStatus()){
            case .authorizedAlways, .authorizedWhenInUse:
                print("Authorize.")
                break
            case .notDetermined:
                print("Not determined.")
                break
            case .restricted:
                print("Restricted.")
                break
            case .denied:
                print("Denied.")
                titleview.citystateZIpcode.text = "Location Service : Off"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            guard let locValue:CLLocationCoordinate2D = manager.location?.coordinate else {return}
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler:
                {
                    placemarks, error -> Void in
                    // Place details
                    guard let placeMark = placemarks?.first else { return }
                    let city = placeMark.locality
                    // Zip code
                    let zip = placeMark.postalCode
                    // Country
                    let country = placeMark.country
                    // State
                    let state = placeMark.administrativeArea
                    
                    let lat = locValue.latitude
                    let long = locValue.longitude
                    if self.currentLongitude != long && self.currentLatitude != lat {
                        print("Updating the Profile")
                        self.currentLatitude = lat
                        self.currentLongitude = long
                        SessionManager.shared.latitude = "\(lat)"
                        SessionManager.shared.longitude = "\(long)"
                        SessionManager.shared.City = city ?? ""
                        SessionManager.shared.State = state ?? ""
                        SessionManager.shared.ZipCode = zip ?? ""
                        let currentcntry = "\(city ?? ""), \(state ?? "") \(zip ?? "")"
                        self.titleview.citystateZIpcode.text = currentcntry
                        SessionManager.shared.Country = country ?? ""
                        self.currentCountry = country
                        if SessionManager.shared.isUserLoggedIn {
                            let body:[String:Any] = ["country":country ?? "","lat":lat,"lng":long,"uid":SessionManager.shared.userId, "city" : city ?? "", "state" : state ?? "","zipcode": zip ?? ""]
                            print("Upadte Body",body)
                            self.UpdateProfile(user: body)
                        }else {
                            let body:[String:Any] = ["start": "\(0)", "lng": self.currentLongitude!, "country": self.currentCountry!, "lat": self.currentLatitude!, "limit": "30"]
                            self.ApiDic = body
                            self.getProductData(param: self.ApiDic)
                        }
                    }else {
                        print("Already In Current Location")
                    }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    
    //TODO:- SetUp Image and User Email in pizza Menu
    private func setupViewsForPizzaMenu() {
        
        if SessionManager.shared.isUserLoggedIn == true {
            getNotifications()
            profileImage.sd_setImage(with:URL(string: SessionManager.shared.image) , placeholderImage: #imageLiteral(resourceName: "Profile-image-for-sell4bids-App"), options: [.refreshCached], completed: nil)
            let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(ProfileimageTapped))
            profileImage?.isUserInteractionEnabled = true
            profileImage?.addGestureRecognizer(tapOnImage)
            profileNameLbl.text = SessionManager.shared.name
            drawerSection = ["", "Sell4Bids Special", "About Sell4Bids", "Legal", "Others"]
            setupDrawer()
        }else {
            profileImage.image = #imageLiteral(resourceName: "Sell4Bids-Icon@100")
            profileNameLbl.text = appName
            drawerSection = ["","About Sell4Bids", "Legal", "Others"]
            setupDrawerWithoutLogin()
        }
        
        
        if SessionManager.shared.email == "" {
            profileEmailLbl.text = "www.sell4bids.com"
        }else {
            profileEmailLbl.text = SessionManager.shared.email
        }
        
        profileImage.layer.borderWidth = 0.5
        profileImage.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        profileImage.layer.masksToBounds = true
        
    }
    
    //Moving towards the Profile View After pressing action in the above Function.
    @objc func ProfileimageTapped(){
        self.drawerLeading.constant = -280
        let storyBoard = UIStoryboard(name: "myProfileSB", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "profileViewController") as! profileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //TODO:- Setting up drawer item in the Model
    private func setupDrawer() {
        // For Section 0
        let home = drawerModel.init(name: "Home".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Home"))
        let sellNow = drawerModel.init(name: "Sell Now".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Sell now"))
        let category = drawerModel.init(name: "Browse Categories".localizableString(loc: LanguageChangeCode), image: UIImage(named: "categories_top"))
        let filter = drawerModel.init(name: "Search Filters".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Filter"))
        let MySell4bids = drawerModel.init(name: "My Sell4Bids".localizableString(loc: LanguageChangeCode), image: UIImage(named: "My Sell4Bids"))
        let jobs = drawerModel.init(name: "Jobs".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Jobs@32px"))
        let chat = drawerModel.init(name: "My Chat".localizableString(loc: LanguageChangeCode), image: UIImage(named: "chat"))
        let profile = drawerModel.init(name: "My Profile".localizableString(loc: LanguageChangeCode), image: UIImage(named: "My Profile"))
      let notifications = drawerModel.init(name: "Notifications".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Notification"))
        
        //For Section 1
        
        let Selling = drawerModel.init(name: "Selling".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Sell now"))
        let MyWatchlist = drawerModel.init(name: "My Watch List".localizableString(loc: LanguageChangeCode), image: UIImage(named: "ic_unwatch"))
        let Buying = drawerModel.init(name: "Buying".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Bought & bids"))
        let Bought = drawerModel.init(name: "Bought".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Bought & wins"))
        let Bids = drawerModel.init(name: "Bids".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Bid or Buy"))
        let Wins = drawerModel.init(name: "Wins".localizableString(loc: LanguageChangeCode), image: UIImage(named: "win"))
        let Followers = drawerModel.init(name: "Followers".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Followers"))
        let Followings = drawerModel.init(name: "Followings".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Following"))
        let BlockList = drawerModel.init(name: "Block List".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Block list"))
        
        // for section 2
        let What = drawerModel.init(name: "What is Sell4Bids?", image: UIImage(named: "My Sell4Bids"))
      let How = drawerModel.init(name: "How it Works?".localizableString(loc:LanguageChangeCode ), image: UIImage(named: "How it works"))
      let Contact = drawerModel.init(name: "Establish Contact".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Establish contact"))
        
        
        // for section 3
        let Term = drawerModel.init(name: "Terms of Use", image: UIImage(named: "terms and condition"))
      let Privacy = drawerModel.init(name: "Privacy Policy".localizableString(loc: LanguageChangeCode), image: UIImage(named: "privacy policy"))
        
        //for section 4
      let rate = drawerModel.init(name: "Rate Us".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Rate us"))
        let share = drawerModel.init(name: "Share".localizableString(loc: LanguageChangeCode), image: UIImage(named: "Share"))
        let logout = drawerModel.init(name: "Logout".localizableString(loc: LanguageChangeCode), image: UIImage(named: "log out"))
        let empty = drawerModel.init(name: "", image: UIImage(named: ""))
        
        drawerArray = [[home,sellNow,category,filter,MySell4bids,jobs,chat,profile,notifications],[Selling,MyWatchlist,Buying,Bought,Bids,Wins,Followers,Followings,BlockList],[What,How,Contact],[Term, Privacy],[rate,share,logout,empty]]
        drawerTableView.reloadData()
    }
    
    private func setupDrawerWithoutLogin() {
        // For Section 0
        let login = drawerModel.init(name: "LogIn", image: UIImage(named: "log out"))
        let category = drawerModel.init(name: "Browse Categories", image: UIImage(named: "categories_top"))
        let filter = drawerModel.init(name: "Search Filters", image: UIImage(named: "Filter"))
        let jobs = drawerModel.init(name: "Jobs", image: UIImage(named: "Jobs@32px"))
        
        
        // for section 2
        let What = drawerModel.init(name: "What is Sell4Bids?", image: UIImage(named: "My Sell4Bids"))
        let How = drawerModel.init(name: "How It Works?", image: UIImage(named: "How it works"))
        let Contact = drawerModel.init(name: "Establish Contact", image: UIImage(named: "Establish contact"))
        
        
        // for section 3
        let Term = drawerModel.init(name: "Terms of Use", image: UIImage(named: "terms and condition"))
        let Privacy = drawerModel.init(name: "Privacy Policy", image: UIImage(named: "privacy policy"))
        
        //for section 4
        let rate = drawerModel.init(name: "Rate Us", image: UIImage(named: "Rate us"))
        let share = drawerModel.init(name: "Share", image: UIImage(named: "Share"))
        let empty = drawerModel.init(name: "", image: UIImage(named: ""))
        
        drawerArray = [[login,category,filter,jobs],[What,How,Contact],[Term, Privacy],[rate,share,empty]]
        drawerTableView.reloadData()
    }
    
    //TODO:- this function is used to dismiss the drawer view by pressing the ShadowView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with:event)
        let touch = touches.first
        if touch?.view == shadowView {
            drawerLeading.constant = -280
            shadowView.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // setting up the views in the View Controller
    private func setupViews() {
        self.view.endEditing(true)
        self.drawerView.shadowView()
        self.drawerLeading.constant = -280
        tabBarController?.delegate = self
        sellBtn.AddshadowViewToButton()
        sellBtn.addTarget(self, action: #selector(sellBtnTapped), for: .touchUpInside)
        // registering Xib file to Product Col View
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        self.productCollectionView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        
        // Register the header for categories
        let headerNib = UINib(nibName: "HeaderView", bundle: nil)
        productCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        //Timer For EdBot
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        // implemting Sell now Images Tapped
        let othersItemTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(othersItemsImageTapped(tapGestureRecognizer:)))
        customview.Items_Image.isUserInteractionEnabled = true
        customview.Items_Image.addGestureRecognizer(othersItemTapGestureRecognizer)
        
        let jobImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(jobImageTapped(tapGestureRecognizer:)))
        customview.Job_Image.isUserInteractionEnabled = true
        customview.Job_Image.addGestureRecognizer(jobImageTapGestureRecognizer)
        
        let ServiceTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VehiclesImageTapped(tapGestureRecognizer:)))
        customview.Vehciles_Image.isUserInteractionEnabled = true
        customview.Vehciles_Image.addGestureRecognizer(ServiceTapGestureRecognizer)
        
        let VehiclesTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ServiceImageTapped(tapGestureRecognizer:)))
        customview.Services_Image.isUserInteractionEnabled = true
        customview.Services_Image.addGestureRecognizer(VehiclesTapGestureRecognizer)
        
        let HousingTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HousingImageTapped(tapGestureRecognizer:)))
        customview.Housing_Image.isUserInteractionEnabled = true
        customview.Housing_Image.addGestureRecognizer(HousingTapGestureRecognizer)
        
        // Implemnting Refresh Views
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        productCollectionView.addSubview(refreshControl)
    }
    
    private func edBotSetup() {
        // action of the floating button
        view.addSubview(edBotButton)
        edBotButton.addTarget(self,
                              action: #selector(drag(control:event:)),
                              for: UIControl.Event.touchDragInside)
        edBotButton.addTarget(self,
                              action: #selector(drag(control:event:)),
                              for: [UIControl.Event.touchDragExit,
                                    UIControl.Event.touchDragOutside])
        edBotButton.addTarget(self, action: #selector(btnfunc(sender: )), for: .touchUpInside)
    }
    
    
    
    // setting up the Top Bar Actions
    private func topView() {
        self.navigationItem.titleView = titleview
        titleview.menuBtn.addTarget(self, action: #selector(pizzaMenuTapped), for: .touchUpInside)
        titleview.searchBarButton.addTarget(self, action: #selector(searchbtnaction), for: .touchUpInside)
        titleview.filterbtn.addTarget(self, action: #selector(filterbtnaction), for: .touchUpInside)
        titleview.inviteBtn.addTarget(self, action:  #selector(self.inviteBarBtnTapped), for: .touchUpInside)
        titleview.micBtn.addTarget(self, action: #selector(mikeTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchbtnaction))
        titleview.citystateZIpcode.isUserInteractionEnabled = true
        titleview.citystateZIpcode.addGestureRecognizer(tap)
    }
    
    // TODO: Used for swiping drawer left and right.
    private func swipe() {
        let Rightswipe = UISwipeGestureRecognizer(target: self, action: #selector(self.RepondtoGesture))
        Rightswipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(Rightswipe)
        
        let Leftswipe = UISwipeGestureRecognizer(target: self, action: #selector(self.RepondtoGesture))
        Leftswipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(Leftswipe)
    }
    
    private func swipeRight() {
        drawerLeading.constant = 0
        shadowView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func swipeLeft() {
        drawerLeading.constant = -300
        shadowView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

//MARK:- Collection View Stub Functions
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    // Adding Collection View as header in the View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
        headerView.collView.delegate = self
        headerView.collView.dataSource = self
        headerView.buttonView.addShadowView()
        headerView.collView.register(UINib(nibName: "CategoriesCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        if UIDevice.modelName.contains("iPhone") {
            headerView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 90)
        }else {
            headerView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 120)
        }
        return headerView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCollectionView {
            return self.productArray.count
        }else {
            return categoriesArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCollectionView {
            let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! productCollectionViewCell
            let instance = self.productArray
            guard indexPath.row < instance.count else {return cell}
            cell.setupDataIntheCollectionView(product: instance[indexPath.item])
            cell.getButtonText(product: instance[indexPath.item])
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCell
            cell.categoriesNameLabel.text = categoriesArray[indexPath.item]
            cell.imageView.image = categoriesImagesArray[indexPath.item]
            cell.imageView.contentMode = .scaleAspectFit
            cell.imageView.clipsToBounds = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.productCollectionView {
            let instance = self.productArray
            guard indexPath.row < instance.count else {return}
            let Category = instance[indexPath.row].itemCategory
            selectedCell = productCollectionView.cellForItem(at: indexPath) as! productCollectionViewCell
            
            
            if Category?.lowercased() == "jobs" {
                let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
                let controller = storyBoard_.instantiateViewController(withIdentifier: "JobsDetailVC") as! JobsDetailVC
                controller.ImageArray = instance[indexPath.row].ImagePath as! [String]
                controller.itemName = instance[indexPath.row].title
                controller.itemId = instance[indexPath.row].itemId
                controller.sellerId = instance[indexPath.row].uid
                controller.transitioningDelegate = self
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
            else if Category?.lowercased() == "services" {
                let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
                let controller = storyBoard_.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
                controller.ImageArray = instance[indexPath.row].ImagePath as! [String]
                controller.itemName = instance[indexPath.row].title
                controller.itemId = instance[indexPath.row].itemId
                controller.sellerId = instance[indexPath.row].uid
                controller.transitioningDelegate = self
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
            else if Category?.lowercased() == "vehicles" {
                let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
                let controller = storyBoard_.instantiateViewController(withIdentifier: "VehicleDetailVC") as! VehicleDetailVC
                controller.ImageArray = instance[indexPath.row].ImagePath as! [String]
                controller.itemName = instance[indexPath.row].title
                controller.itemId = instance[indexPath.row].itemId
                controller.sellerId = instance[indexPath.row].uid
                controller.transitioningDelegate = self
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
            else if Category?.lowercased() == "housing" {
                
                let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
                let controller = storyBoard_.instantiateViewController(withIdentifier: "HousingDetailVC") as! HousingDetailVC
                controller.ImageArray = instance[indexPath.row].ImagePath as! [String]
                controller.itemName = instance[indexPath.row].title
                controller.itemId = instance[indexPath.row].itemId
                controller.sellerId = instance[indexPath.row].uid
                controller.transitioningDelegate = self
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
           
            else {
                let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
                let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
                controller.itemName = instance[indexPath.row].title
                controller.itemId = instance[indexPath.row].itemId
                controller.sellerId = instance[indexPath.row].uid
                controller.ImageArray = instance[indexPath.row].ImagePath as! [String]
                controller.transitioningDelegate = self
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
        else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
            let selectedCat = categoriesArray[indexPath.item]
            vc.catName = selectedCat
            vc.currentCountry = self.currentCountry ?? ""
            vc.currentLatitude = "\(self.currentLatitude ?? 0)"
            vc.currentLongitude = "\(self.currentLongitude ?? 0)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var headerheight = CGFloat()
        let size: CGSize = categoriesArray[indexPath.row].size(withAttributes: nil)
        if UIDevice.modelName.contains("iPhone") {
            headerheight = CGFloat(85)
        }else {
            headerheight = CGFloat(140)
        }
        let heightForLabel = headerheight * 0.29
        let cellHeight = headerheight - heightForLabel + 10
        var additionalWidth = CGFloat()
        additionalWidth = Env.isIpad ? 70 : 60.5
        return CGSize(width: size.width + additionalWidth, height: cellHeight)
    }
    
    // Called before the cell is displayed
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // This is used Pagination Purpose
        let start = self.productArray.count
        if indexPath.row == start - 1 {  //number of item count
            self.ApiDic["start"] = "\(start)"
            self.getProductData(param: self.ApiDic)
        }
    }
}

//MARK:- PinterstLayout Delegate
extension HomeVC: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        var ratio = Float()
        var height : CGFloat = 0
        var title = String()
        let width = CGFloat(UIScreen.main.bounds.width) / 3
        let productsArray = self.productArray
        if productsArray[indexPath.row].imageInfoArray?.count ?? 0 > 0 {
            ratio = productsArray[indexPath.row ].imageInfoArray![0].ratio!
        }else {
            ratio = 1
        }
        title = productsArray[indexPath.row].title!
        height = width  / CGFloat(ratio)
        let btnHeight : CGFloat = 50
        let numberOfColumns = 3
        let insets = collectionView.contentInset
        let contentWidth = collectionView.bounds.width - (insets.left + insets.right)
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        let font = UIFont.boldSystemFont(ofSize: 17)
        let estimatedHeight = title.height(withConstrainedWidth: columnWidth, font: font)
        return height + estimatedHeight + btnHeight
    }
}

//MARK:- Table View Stub Functions
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return drawerSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return drawerSection[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawerArray[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = drawerTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let image =  drawerArray[indexPath.section][indexPath.row].image
        cell.imageView!.image = image?.maskWithColor(color: UIColor.white)
        cell.textLabel?.text = drawerArray[indexPath.section][indexPath.row].name
        cell.detailTextLabel?.text = "Ehtisham"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.text = drawerSection[section]
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        view.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if SessionManager.shared.isUserLoggedIn == true {
            // Drawer Selection on Login
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    print("Home")
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 1 {
                    print("Sell Now")
                    //Sell Now
                    self.drawerLeading.constant = -280
                    alertActionBarSellNow = UIAlertController(title:"", message: "Select Sell Now Option here is text for testing purpose", preferredStyle: .actionSheet)
                    
                    //item Sell Now Gesture
                    let Items_Gesture = UITapGestureRecognizer(target: self, action: #selector(ItemSellNow))
                    
                    //Job Sell Now Gesture
                    let Job_Gesture = UITapGestureRecognizer(target: self, action: #selector(JobSellNow))
                    
                    //Vehicles Sell Now Gesture
                    let Vehicles_Gesture = UITapGestureRecognizer(target: self, action: #selector(VehicaleSellNow))
                    
                    //Services Sell Now Gesture
                    let Services_Gesture = UITapGestureRecognizer(target: self, action: #selector(ServiceSellNow))
                    
                    //Services Sell Now Gesture
                    let Housing_Gesture = UITapGestureRecognizer(target: self, action: #selector(HousingSellNow))
                    
                    //Changes by OsamaMansoori(12-04-2019)
                    //item Sell Now Details
                    
                    customview.OthersItemsLbl.isUserInteractionEnabled = true
                    customview.OthersItemsLbl.addGestureRecognizer(Items_Gesture)
                    
                    //Job Sell Now Details
                    
                    customview.JobsLbl.isUserInteractionEnabled = true
                    customview.JobsLbl.addGestureRecognizer(Job_Gesture)
                    
                    //Housing Sell Now Details
                    
                    customview.HousingLbl.isUserInteractionEnabled = true
                    customview.HousingLbl.addGestureRecognizer(Housing_Gesture)
                    
                    //Vehicles Sell Now Details
                    
                    customview.VehiclesLbl.isUserInteractionEnabled = true
                    customview.VehiclesLbl.addGestureRecognizer(Vehicles_Gesture)
                    
                    
                    //Services Sell Now Details
                    
                    customview.isUserInteractionEnabled = true
                    
                    customview.ServiceLbl.isUserInteractionEnabled = true
                    customview.ServiceLbl.addGestureRecognizer(Services_Gesture)
                    
                    customview.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: 200)
                    
                    alertActionBarSellNow.view.addSubview(customview)
                    
                    alertActionBarSellNow.view.frame = CGRect(x: 0, y: 0,width :  UIScreen.main.bounds.width, height: 100)
                    alertActionBarSellNow.popoverPresentationController?.sourceView = self.view
                    alertActionBarSellNow.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.minX, y: self.view.bounds.maxY, width: UIScreen.main.bounds.width, height: 0)
                    
                    self.present(alertActionBarSellNow, animated: true) {
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
                        alertActionBarSellNow.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
                    }
                }
                else if indexPath.row == 2 {
                    print("Categories")
                    self.tabBarController?.selectedIndex = 3
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 3 {
                    print("Search Filters")
                    let story = UIStoryboard(name: "homeTab", bundle: nil)
                    guard let controller = story.instantiateViewController(withIdentifier: "FiltersVc") as? FiltersVc else {return}
                    controller.delegate = self
                    controller.selfWasPushed = true
                    controller.countryName = currentCountry ?? "USA"
                    controller.latitude = self.currentLatitude ?? 36.778259
                    controller.longitude = self.currentLongitude ??     -119.417931
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 4 {
                    print("My Sell$bids")
                    self.tabBarController?.selectedIndex = 1
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 5 {
                    print("Jobs")
                    let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
                    vc.catName = "Jobs"
                    vc.currentCountry = self.currentCountry ?? ""
                    vc.currentLatitude = "\(self.currentLatitude ?? 0)"
                    vc.currentLongitude = "\(self.currentLongitude ?? 0)"
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 6 {
                    print("My Chat")
                    let chatSB = getStoryBoardByName(storyBoardNames.chat)
                    let chatListVC = chatSB.instantiateViewController(withIdentifier: "MyChatList") as! MyChatListVC
                    chatListVC.flagUsedInMySell4Bids = false
                    self.navigationController?.pushViewController(chatListVC, animated: true)
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 7 {
                    print("My Profile")
                    self.drawerLeading.constant = -280
                    let storyBoard = UIStoryboard(name: "myProfileSB", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "profileViewController") as! profileViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if indexPath.row == 8 {
                    print("Notifications")
                    self.tabBarController?.selectedIndex = 4
                    self.drawerLeading.constant = -280
                }
                
            }
                
            else if indexPath.section == 1 {
                if indexPath.row == 0 {
                    print("Selling")
                    let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let chatListVC = chatSB.instantiateViewController(withIdentifier: "MySellVc") as! SellingVC
                    chatListVC.bottomBar = true
                    self.navigationController?.pushViewController(chatListVC, animated: true)
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 1 {
                    print("My Watchlist")
                    let chatSB = UIStoryboard(name: "myWatchList", bundle: nil)
                    let chatListVC = chatSB.instantiateViewController(withIdentifier: "ActiveWatchListVc") as! ActiveWatchListVc
                    chatListVC.bottomBar = true
                    self.navigationController?.pushViewController(chatListVC, animated: true)
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 2 {
                    print("Buying")
                    let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let chatListVC = chatSB.instantiateViewController(withIdentifier: "BidsVc") as! BuyingAndBidsVC
                    chatListVC.bottomBar = true
                    self.navigationController?.pushViewController(chatListVC, animated: true)
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 3 {
                    print("Bought")
                    let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let chatListVC = chatSB.instantiateViewController(withIdentifier: "BoughtAndWinsVc") as! BoughtAndWinsVc
                    chatListVC.bottomBar = true
                    self.navigationController?.pushViewController(chatListVC, animated: true)
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 4 {
                    print("Bids")
                    let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let chatListVC = chatSB.instantiateViewController(withIdentifier: "BidsItemsVC") as! BidsVC
                    chatListVC.bottomBar = true
                    self.navigationController?.pushViewController(chatListVC, animated: true)
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 5 {
                    print("Wins")
                    let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let chatListVC = chatSB.instantiateViewController(withIdentifier: "WinsVc") as! WinsVc
                    chatListVC.bottomBar = true
                    self.navigationController?.pushViewController(chatListVC, animated: true)
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 6 {
                    print("Followers")
                    let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let chatListVC = chatSB.instantiateViewController(withIdentifier: "FollowersVc") as! FollowersVc
                    chatListVC.bottomBar = true
                    self.navigationController?.pushViewController(chatListVC, animated: true)
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 7 {
                    print("Followings")
                    let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let chatListVC = chatSB.instantiateViewController(withIdentifier: "FollowingVc") as! FollowingVc
                    chatListVC.bottomBar = true
                    self.navigationController?.pushViewController(chatListVC, animated: true)
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 8 {
                    print("Block List")
                    let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let chatListVC = chatSB.instantiateViewController(withIdentifier: "BlockUserVc") as! BlockUserVc
                    chatListVC.bottomBar = true
                    self.navigationController?.pushViewController(chatListVC, animated: true)
                    self.drawerLeading.constant = -280
                }
            }
            else if indexPath.section == 2 {
                if indexPath.row == 0 {
                    print("What is Sell4bids")
                    let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
                    
                    let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "whatIsSell4Bids") as! AboutSell4BidsTableVC
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.drawerLeading.constant = -280
                }
                    
                else if indexPath.row == 1 {
                    print("How It Works")
                    let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
                    let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "howItWorksTableVC") as! howItWorksTableVC
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.drawerLeading.constant = -280
                }
                    
                else if indexPath.row == 2 {
                    print("Establish Contact")
                    let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
                    let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "establishContact") as! EstablishContactVC
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.drawerLeading.constant = -280
                }
            }
                
            else if indexPath.section == 3 {
                if indexPath.row == 0 {
                    print("Term of Use")
                    self.drawerLeading.constant = -280
                    let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                    vc.urlString = termOfUseUrl
                    vc.screenName = "Term of use"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                    
                else if indexPath.row == 1 {
                    print("Privacy Policy")
                    self.drawerLeading.constant = -280
                    let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                    vc.urlString = privacyPolicyUrl
                    vc.screenName = "Privacy Policy"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
                
            else if indexPath.section == 4 {
                if indexPath.row == 0 {
                    print("Rate Us")
                    guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1304176306") else {
                        return
                    }
                    guard #available(iOS 10, *) else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:])
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 1 {
                    print("Share")
                    let messageStr = "Did you install the Official Sell4Bids App? You wil find Stuff, Services, Jobs, Offers, Counter-Offers, Auctions & Bidding and a whole lot more.\n\n"
                    
                    let itunesLink = URL.init(string: "https://itunes.apple.com/us/app/sell4bids/id1304176306?mt=8")!
                    
                    let activityItems = [ messageStr, itunesLink] as [Any]
                    let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                    
                    self.present(activityViewController, animated: true, completion: nil)
                    self.drawerLeading.constant = -280
                }
                else if indexPath.row == 2 {
                    print("Logout")
                    _ = SweetAlert().showAlert("Signing Out", subTitle: "Do you want to sign out?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (action) -> Void in
                        if(action == true) {
                            let param:[String:Any] = [
                                "token":"",
                                "uid": SessionManager.shared.userId
                            ]
                            self.sendTokenToServer(param: param)
                            SessionManager.logOut()
                          UserDefaults.standard.set(nil, forKey: "housingTitleDic")
                                              UserDefaults.standard.set(nil, forKey: "housingImagesArray")
                          //                  serDefaults.standard.dictionary(forKey: "housingDescriptionDic")
                                            UserDefaults.standard.removeObject(forKey: "housingDescriptionDic")
                          UserDefaults.standard.set(nil, forKey: "vehicleTitleDic")
                          UserDefaults.standard.set(nil, forKey: "vehicleImagesArray")
                          UserDefaults.standard.set(nil, forKey: "serviceTitleDic")
                          UserDefaults.standard.set(nil, forKey: "serviceDescriptionDic")
                          UserDefaults.standard.set(nil, forKey: "serviceImagesArray")
                          UserDefaults.standard.set(nil, forKey: "itemTitleDic")
                                             UserDefaults.standard.set(nil, forKey: "itemDescriptionDic")
                                             UserDefaults.standard.set(nil, forKey: "itemImagesArray")
                          UserDefaults.standard.set(nil, forKey: "jobTitleDic")
                                             UserDefaults.standard.set(nil, forKey: "jobDescriptionDic")
                          
                                UserDefaults.standard.set(nil, forKey: "category")
                                 UserDefaults.standard.set(nil, forKey: "buyingoption")
                                UserDefaults.standard.set(nil, forKey: "condition")
                                UserDefaults.standard.set(nil, forKey: "slidervalue")
                                UserDefaults.standard.set(nil, forKey: "min")
                                UserDefaults.standard.set(nil, forKey: "max")
                                UserDefaults.standard.set(nil, forKey: "location")
                                UserDefaults.standard.value(forKey: "symbol")
                          
                            let appdelegate = UIApplication.shared.delegate as! AppDelegate
                            let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVc") as! WelcomeVc
                            let nav = UINavigationController(rootViewController: homeViewController)
                            appdelegate.window!.rootViewController = nav
                            appdelegate.window?.makeKeyAndVisible()
                            homeViewController.reloadInputViews()
                        }
                        
                    }
                }
            }
        }else {
            // Drawer Selection Without Login
            if indexPath.section == 0 {
                  if indexPath.row == 0 {
                      print("Login")
                     let SB = UIStoryboard(name: "Main", bundle: nil)
                     let vc = SB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                     self.navigationController?.pushViewController(vc, animated: true)
                     self.drawerLeading.constant = -280
                  }
                  else if indexPath.row == 1 {
                      print("Categories")
                      self.tabBarController?.selectedIndex = 3
                      self.drawerLeading.constant = -280
                  }
                  else if indexPath.row == 2 {
                      print("Search Filters")
                      let story = UIStoryboard(name: "homeTab", bundle: nil)
                      guard let controller = story.instantiateViewController(withIdentifier: "FiltersVc") as? FiltersVc else {return}
                      controller.delegate = self
                      controller.selfWasPushed = true
                      controller.countryName = currentCountry ?? "USA"
                      controller.latitude = self.currentLatitude ?? 36.778259
                      controller.longitude = self.currentLongitude ??     -119.417931
                      self.navigationController?.pushViewController(controller, animated: true)
                      self.drawerLeading.constant = -280
                  }
                  else if indexPath.row == 3 {
                      print("Jobs")
                      let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
                      vc.catName = "Jobs"
                      vc.currentCountry = self.currentCountry ?? ""
                      vc.currentLatitude = "\(self.currentLatitude ?? 0)"
                      vc.currentLongitude = "\(self.currentLongitude ?? 0)"
                      self.navigationController?.pushViewController(vc, animated: true)
                      self.drawerLeading.constant = -280
                  }
              }
              else if indexPath.section == 1 {
                  if indexPath.row == 0 {
                      print("What is Sell4bids")
                      let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
                      
                      let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "whatIsSell4Bids") as! AboutSell4BidsTableVC
                      self.navigationController?.pushViewController(controller, animated: true)
                      self.drawerLeading.constant = -280
                  }
                      
                  else if indexPath.row == 1 {
                      print("How It Works")
                      let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
                      let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "howItWorksTableVC") as! howItWorksTableVC
                      self.navigationController?.pushViewController(controller, animated: true)
                      self.drawerLeading.constant = -280
                  }
                      
                  else if indexPath.row == 2 {
                      print("Establish Contact")
                      let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
                      let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "establishContact") as! EstablishContactVC
                      self.navigationController?.pushViewController(controller, animated: true)
                      self.drawerLeading.constant = -280
                  }
              }
                  
              else if indexPath.section == 2 {
                  if indexPath.row == 0 {
                      print("Term of Use")
                      self.drawerLeading.constant = -280
                      let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                      let vc = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                      vc.urlString = termOfUseUrl
                      vc.screenName = "Term of use"
                      self.navigationController?.pushViewController(vc, animated: true)
                  }
                      
                  else if indexPath.row == 1 {
                      print("Privacy Policy")
                      self.drawerLeading.constant = -280
                     let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                      let vc = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                      vc.urlString = privacyPolicyUrl
                      vc.screenName = "Privacy Policy"
                      self.navigationController?.pushViewController(vc, animated: true)
                  }
              }
                  
              else if indexPath.section == 3 {
                  if indexPath.row == 0 {
                      print("Rate Us")
                      guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1304176306") else {
                          return
                      }
                      guard #available(iOS 10, *) else {
                          return
                      }
                      UIApplication.shared.open(url, options: [:])
                      self.drawerLeading.constant = -280
                  }
                  else if indexPath.row == 1 {
                      print("Share")
                      let messageStr = "Did you install the Official Sell4Bids App? You wil find Stuff, Services, Jobs, Offers, Counter-Offers, Auctions & Bidding and a whole lot more.\n\n"
                      
                      let itunesLink = URL.init(string: "https://itunes.apple.com/us/app/sell4bids/id1304176306?mt=8")!
                      
                      let activityItems = [ messageStr, itunesLink] as [Any]
                      let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                      activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                      
                      self.present(activityViewController, animated: true, completion: nil)
                      self.drawerLeading.constant = -280
                  }
              }
        }
    }
}

//MARK:- Scroll view Functionality
extension HomeVC {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView == productCollectionView {
            
            if(velocity.y>0) {
                //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
                UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.sellBtn.isHidden = false
                    self.tabBarController?.tabBar.isHidden = true
                }, completion: nil)
                
            } else {
                UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.tabBarController?.tabBar.isHidden = false
                    self.sellBtn.isHidden = true
                }, completion: nil)
            }
        }
    }
}

//MARK:-  Filter Delegates
extension HomeVC : filtersVCDelegate {
    func getFilterData(param: [String : Any]) {
        self.productArray.removeAll()
        productCollectionView.reloadData()
        let country = param["country"]
        let lat = param["lat"]
        let long = param["lng"]
        self.currentCountry = "\(country ?? "USA")"
        self.currentLatitude = lat as? Double
        self.currentLongitude = long as? Double
        self.titleview.citystateZIpcode.text = self.currentCountry
        self.ApiDic = param
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetSpinner.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetSpinner, view: self.shadowView)
            }
        }
        self.getProductData(param: self.ApiDic)
    }
}

//MARK:-  Custom Tab bar
extension HomeVC : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
         if tabBarController.selectedIndex == 2{
            tabBarController.selectedIndex = 0
            alertActionBarSellNow = UIAlertController(title:"", message: "Select Sell Now Option", preferredStyle: .actionSheet)
            //item Sell Now Gesture
            let Items_Gesture = UITapGestureRecognizer(target: self, action: #selector(ItemSellNow))
            
            //Job Sell Now Gesture
            let Job_Gesture = UITapGestureRecognizer(target: self, action: #selector(JobSellNow))
            
            
            //Vehicles Sell Now Gesture
            let Vehicles_Gesture = UITapGestureRecognizer(target: self, action: #selector(VehicaleSellNow))
            
            //Services Sell Now Gesture
            let Services_Gesture = UITapGestureRecognizer(target: self, action: #selector(ServiceSellNow))
            
            //Services Sell Now Gesture
            let Housing_Gesture = UITapGestureRecognizer(target: self, action: #selector(HousingSellNow))
            
            //Changes by OsamaMansoori(12-04-2019)
            //item Sell Now Details
            
            customview.OthersItemsLbl.isUserInteractionEnabled = true
            customview.OthersItemsLbl.addGestureRecognizer(Items_Gesture)
            
            //Job Sell Now Details
            
            customview.JobsLbl.isUserInteractionEnabled = true
            customview.JobsLbl.addGestureRecognizer(Job_Gesture)
            
            //Vehicles Sell Now Details
            
            customview.VehiclesLbl.isUserInteractionEnabled = true
            customview.VehiclesLbl.addGestureRecognizer(Vehicles_Gesture)
            
            
            //Services Sell Now Details
            
            customview.isUserInteractionEnabled = true
            
            customview.ServiceLbl.isUserInteractionEnabled = true
            customview.ServiceLbl.addGestureRecognizer(Services_Gesture)
            
            //Housing Sell Now Details
            
            customview.HousingLbl.isUserInteractionEnabled = true
            customview.HousingLbl.addGestureRecognizer(Housing_Gesture)
            
            customview.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: 200)
            
            
            alertActionBarSellNow.view.addSubview(customview)
            
            
            
            alertActionBarSellNow.view.frame = CGRect(x: 0, y: 0,width :  UIScreen.main.bounds.width, height: 100)
            alertActionBarSellNow.popoverPresentationController?.sourceView = self.view
            alertActionBarSellNow.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.minX, y: self.view.bounds.maxY, width: UIScreen.main.bounds.width, height: 0)
            
            self.present(alertActionBarSellNow, animated: true) {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
                alertActionBarSellNow.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            }
        }
    }
}

// Implemented in future........ for transition

extension HomeVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let originFrame = selectedCell.superview?.convert(selectedCell.frame, to: nil) else {
            return transition
        }
        transition.originFrame = originFrame
        transition.presenting = true
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}


