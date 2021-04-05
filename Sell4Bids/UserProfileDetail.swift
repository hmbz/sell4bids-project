//
//  UserProfileDetailVc.swift
//  Sell4Bids
//
//  Created by admin on 10/19/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import Cosmos


var defaults = UserDefaults.standard

import AVFoundation
import SwiftyJSON


class UserProfileDetail:UITableViewController, ImageUrlDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //MARK:- Properties
    
    @IBOutlet weak var switchchatmessagesemail: UISwitch!
    @IBOutlet weak var userImageview: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var watchingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var totalListingLabel: UILabel!
    @IBOutlet weak var boughtLabel: UILabel!
    @IBOutlet weak var buyingLabel: UILabel!
    @IBOutlet weak var unReadMessagedLabel: UILabel!
    @IBOutlet weak var unReadNotifyLabel: UILabel!
    @IBOutlet weak var userEditImageView: UIImageView!
    @IBOutlet weak var totalRatingLabel: UILabel!
    @IBOutlet weak var cosmosViewrating: CosmosView!
    @IBOutlet weak var edBotSwitch: UISwitch!
    
    // @ AK 29-jan
    @IBOutlet weak var editDetailBtn: UIButton!
    @IBOutlet weak var changePhoto: UIButton!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var detailInfoLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var zipCodeLbl: UILabel!
    @IBOutlet weak var stateLocationLbl: UILabel!
    @IBOutlet weak var emailNotificationPreferenceLbl: UILabel!
    @IBOutlet weak var buyingActivityLbl: UILabel!
    @IBOutlet weak var chatMesageEmailLbl: UILabel!
    @IBOutlet weak var sellingActivityLbl: UILabel!
    @IBOutlet weak var sell4bidsInfoLbl: UILabel!
    @IBOutlet weak var watchingLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var totalListingsInfo: UILabel!
    @IBOutlet weak var buyingandBidsLbl: UILabel!
    @IBOutlet weak var boughtandWinsLbl: UILabel!
    @IBOutlet weak var unreadMessageLbl: UILabel!
    @IBOutlet weak var unreadNotificationLbl: UILabel!
    
    
    //Mark: - variables
    var headerView:UIView!
    var newHeaderLayer: CAShapeLayer!
    var dbRef: DatabaseReference!
    var db = DatabaseReference()
    var imageUrl = ""
    var userData:UserModel?
    var imagePicker = UIImagePickerController()
    var picker2 = UIImagePickerController()
    var userImageData:UIImage!
    var fidgetImageView: UIImageView!
    var MainApi = MainSell4BidsApi()
    var UserDetails : UserDetailModel?
    var UserActivitys : UserActivity?
    
    
    @IBOutlet weak var switchBuyingActivities: UISwitch!
    @IBOutlet weak var switchSellingActivities: UISwitch!
//    fileprivate func addDoneLeftBarBtn() {
//
//
//        addLogoWithLeftBarButton()
//        let doneBarBtn = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(backBtnTap))
//
//        let button = UIButton.init(type: .custom)
//
//        button.setImage(  #imageLiteral(resourceName: "mysell4bids")  , for: UIControlState.normal)
//        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
//        let barButton = UIBarButtonItem.init(customView: button)
//        self.navigationItem.leftBarButtonItems = [doneBarBtn , barButton ]
//    }
    
    //MARK:- View Life Cycle
//    func getLoginUserData(completion : @escaping (Bool) -> () ){
//        guard let userId = Auth.auth().currentUser?.uid else {
//
//            print("ERROR: While getting User ID")
//            return
//        }
//
//        dbRef.child("users").child(userId).observe(.value, with:{ [weak self] (snapshot) in
//            guard let this = self else { return }
//            // Get user value
//            if let dict = snapshot.value as? NSDictionary {
//                var name = String()
//                if let checkname = dict["name"]{
//                    name = checkname as! String
//                    defaults.set(name, forKey: "FullName")
//
//                }
//                if let image = dict["image"] {
//                    this.imageUrl = image as! String
//                }
//                let email = dict["email"]
//                var city = "Edit Profile to update location "
//                if let state = dict["city"]{
//                    city = state as! String
//                }
//                var code = ""
//                if let zipCode = dict["zipCode"]  {
//                    code = zipCode as! String
//                    defaults.set(code, forKey: "ZipCode")
//                }
//                var follow = "0"
//                if let  followers = dict["followersCount"] as? String {
//                    follow = String(describing: Int(followers))
//
//                }
//                var following = "0"
//                if let  followings = dict["followingsCount"] {
//                    following = followings as! String
//
//                }
//
//
//
//
//                var  checkSelling = 0
//                var  checkbuying = 0
//                var  checkBought = 0
//                var  checkWatching = 0
//                if let products = dict.value(forKey: "products") {
//                    let productValues  = products as! NSDictionary
//
//                    let sellingKey = productValues.value(forKey: "selling") as? NSDictionary
//
//                    if   let sellingKeyCount = sellingKey?.count
//                    {
//                        checkSelling = sellingKeyCount
//                    }
//
//                    let buyingKey = productValues.value(forKey: "buying") as? NSDictionary
//
//                    if   let buyingKeyCount = buyingKey?.count
//                    {
//                        checkbuying = buyingKeyCount
//                    }
//
//                    let boughtKey = productValues.value(forKey: "bought") as? NSDictionary
//
//                    if let boughtKeyCount = boughtKey?.count
//                    {
//                        checkBought = boughtKeyCount
//                    }
//
//                    let watchingKey = productValues.value(forKey: "watching") as? NSDictionary
//
//                    if   let watchingKeyCount = watchingKey?.count
//                    {
//                        checkWatching = watchingKeyCount
//                    }
//
//                }
//                var checkNotify = "0"
//                if let notify = dict.value(forKey: "unreadNotifications") as? String {
//                    checkNotify = notify
//                }
//                var checkMessages = "0"
//                if let messages = dict.value(forKey: "unreadCount") {
//
//                    checkMessages = (messages as? String)!
//                }
//                var checkRating = "0"
//                if let rating = dict.value(forKey: "averagerating") as? String{
//                    checkRating = rating
//
//                }
//                var checkTotalRating = "0"
//                if let rating = dict.value(forKey: "totalratings") {
//                    checkTotalRating = rating as! String
//
//                }
//                let followInt = (follow as NSString).integerValue
//                let followingInt = (following as NSString).integerValue
//                let notifyInt = (checkNotify as NSString).integerValue
//                let messageInt = (checkMessages as NSString).integerValue
//                print("Messages = \(messageInt)")
//                let ratingInt = (checkRating as NSString).floatValue
//                let totalRatingInt = (checkTotalRating as NSString).floatValue
//
//                let userData:UserModel = UserModel(name: name , image: this.imageUrl , userId:"", averageRating: ratingInt, totalRating: totalRatingInt, email: email as? String, zipCode: code, state: city, watching: checkWatching, follower: followInt, following: followingInt, totalListing: checkSelling, buying: checkbuying, bought: checkBought, unReadMessage: messageInt, unReadNotify: notifyInt )
//
//                this.userData = userData
//
//
//                completion(true)
//
//                DispatchQueue.main.async {
//
//                    self!.tableView.reloadData()
//                }
//            }
//        })
//
//    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Ahmed")
//        getLoginUserData { (completed) in
//            if completed {
//                print("Changed")
//            }
//        }
        getUserData()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        let edBot = UserDefaults.standard.bool(forKey: SessionManager.shared.edBot)
        
        if edBot == true {
            edBotSwitch.isOn = true
        }else {
            edBotSwitch.isOn = false
        }
        
        edBotSwitch.addTarget(self, action: #selector(edbotSwitchTapped(sender:)), for: .valueChanged)
        

        
        MainApi.UserActivityDetails(uid: SessionManager.shared.userId) { (status, data, error) in

            if status {
                let datanewunreadNotification = data!["unreadNotification"].intValue
                let winscount = data!["winsCount"].intValue
                let totalItemCount = data!["totalItemCount"].intValue
                let message = data!["message"].intValue
                let watchingCount = data!["watchingCount"].intValue
                let boughtCount = data!["boughtCount"].intValue
                let bidsCount = data!["bidsCount"].intValue
                let buyingCount = data!["buyingCount"].intValue
                let followingCount = data!["followingCount"].intValue
                let followerCount = data!["followerCount"].intValue
                
                let UserActivitydata = UserActivity.init(unreadNotifications: datanewunreadNotification, winsCount: winscount, totalItemCount: totalItemCount, message: message, watchingCount: watchingCount, boughtCount: boughtCount, bidsCount: bidsCount, buyingCount: buyingCount, followingCount: followingCount, followerCount: followerCount)
                
                self.UserActivitys = UserActivitydata
                self.unReadNotifyLabel.text = String(describing: self.UserActivitys!.unreadNotifications)
                self.unReadMessagedLabel.text = String(describing: self.UserActivitys!.message)
                let boughtandwinds = self.UserActivitys!.winsCount + self.UserActivitys!.boughtCount
                self.boughtLabel.text = String(describing: boughtandwinds)
                let buyingandBids = self.UserActivitys!.buyingCount + self.UserActivitys!.bidsCount
                self.buyingLabel.text = String(describing: buyingandBids)
                self.totalListingLabel.text = String(describing: self.UserActivitys!.totalItemCount)
                self.followerLabel.text = String(describing: self.UserActivitys!.followerCount)
                self.followingLabel.text = String(describing: self.UserActivitys!.followingCount)
                self.watchingLabel.text = String(describing: self.UserActivitys!.watchingCount)
            }
        }
        
        
        
      
        
        MainApi.Get_User_Detail(uid: SessionManager.shared.userId) { (status, data, error) in
            
            if status {
                let message = data!["message"]
                let zipCode = message["zipCode"].stringValue
                let id = message["_id"].stringValue
                let followingsCount = message["followingsCount"].intValue
                let latitude = message["latitude"].doubleValue
                let longitude = message["longitude"].doubleValue
                let unreadCount = message["unreadCount"].intValue
                let state = message["state"].stringValue
                let uid = message["uid"].stringValue
                let totalratings = message["totalratings"].doubleValue
                let name = message["name"].stringValue
                let country = message["country"].stringValue
                let fcmToken = message["fcmToken"].stringValue
                let averagerating = message["averagerating"].doubleValue
                let unreadNotifications = message["unreadNotifcations"].intValue
                let startTime = message["startTime"].int64Value
                let newNotifications = message["newNotifications"].intValue
                let token = message["token"].stringValue
                let city = message["city"].stringValue
                let followersCount = message["followersCount"].intValue
                let configs = message["configs"]
                let buyingActivities = configs["buyingActivities"].boolValue
                let chatActivities = configs["charActivities"].boolValue
                let sellingActivities = configs["sellingActivities"].boolValue
                let email = message["email"].stringValue
                let image = message["image"].stringValue
                
                let data = UserDetailModel.init(email: email, unreadNotifications: unreadNotifications, fcmToken: fcmToken, averagerating: averagerating, unreadCount: unreadCount, country: country, buyingActivities: buyingActivities, sellingActivities: sellingActivities, chatActivities: chatActivities, uid: uid, followersCount: followersCount, latitude: latitude, longitude: longitude, zipCode: zipCode, name: name, newNotifications: newNotifications, city: city, state: state, startTime: startTime, followingCount: followersCount, totalratings: totalratings, id: id, token: token, image: image)
                print(data.country)
            
                self.UserDetails = data
                
                self.userNameLabel.text = self.UserDetails!.name
                self.titleview.titleLbl.text = self.UserDetails!.name
                
                  self.userImageview.sd_setImage(with: URL(string: self.UserDetails?.image ?? "" ), placeholderImage: #imageLiteral(resourceName: "Profile-image-for-sell4bids-App-1"))
                self.totalRatingLabel.text = "Total Rating : \(self.UserDetails!.totalratings)"
                
                self.cosmosViewrating.rating = self.UserDetails!.averagerating
                self.emailLabel.text = self.UserDetails!.email
                self.zipCodeLabel.text = self.UserDetails!.zipCode
                self.stateLabel.text = self.UserDetails!.state
                self.switchBuyingActivities.isOn = self.UserDetails!.buyingActivities
                self.switchSellingActivities.isOn = self.UserDetails!.sellingActivities
                self.switchchatmessagesemail.isOn = self.UserDetails!.chatActivities
                
                
            }
            
        }
        
        
        ForLanguageChange()
        cosmosViewrating.settings.filledColor = UIColor(red: 252.0/255.0 , green: 194.0/255.0, blue: 0, alpha: 1)
        topMenu()
//        addDoneLeftBarBtn()
        imagePicker.delegate = self
        let id = SessionManager.shared.userId
        db = FirebaseDB.shared.dbRef
        let ref = db.child("users").child(id).child("configs")
        ref.observe(DataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            
            guard let buyingactivities = dict?["buyingActivities"] as? String else {
                print("data not found from firebase.")
                return
            }
            if  buyingactivities == "on" {
                self.switchBuyingActivities.isOn = true
            }else {
                self.switchBuyingActivities.isOn = false
            }
            
            
            guard let sellingactivites = dict!["sellingActivities"] as? String else {
                print("data not found from firebase")
                return
            }
            if sellingactivites == "on" {
                self.switchSellingActivities.isOn = true
            }else {
                self.switchSellingActivities.isOn = false
            }
            
            
            guard let chatactivities = dict!["chatActivities"] as? String else {
                print("data not found from firebase")
                return
            }
            if chatactivities == "on" {
                self.switchchatmessagesemail.isOn = true
            }else {
                self.switchchatmessagesemail.isOn = false
            }
            
            print("value == \(buyingactivities)")
            
            
            
        })
        dbRef = FirebaseDB.shared.dbRef
        // Do any additional setup after loading the view.
        setupViews()
//        checkInternet()
        
    }
    
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
//        titleview.titleLbl.text = "Orders"
        titleview.backBtn.setImage(nil, for: .normal)
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.backBtn.setTitle("Done", for: .normal)
        titleview.backBtnWidth.constant = 60
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        
        self.navigationItem.hidesBackButton = true
    }
    
    //MARK:-  Actions
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
//        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        
    }
    
    @objc func edbotSwitchTapped(sender: UISwitch){
        if sender.isOn == true {
            edBotSwitch.isOn = false
            UserDefaults.standard.set(false, forKey: SessionManager.shared.edBot)
            print("Ed Bot Status =",UserDefaults.standard.bool(forKey: SessionManager.shared.edBot))
        }else {
            edBotSwitch.isOn = true
            UserDefaults.standard.set(true, forKey: SessionManager.shared.edBot)
            print("Ed Bot Status =",UserDefaults.standard.bool(forKey: SessionManager.shared.edBot))
        }
    }
    
    func ForLanguageChange(){
        editDetailBtn.setTitle("editDetailBtnUPD".localizableString(loc: LanguageChangeCode), for: .normal)
        changePhoto.setTitle("changePhotoUPD".localizableString(loc: LanguageChangeCode), for: .normal)
//        totalRatingLabel.text = "ratingLblUPD".localizableString(loc: LanguageChangeCode)
        detailInfoLbl.text = "detailInfoLblUPD".localizableString(loc: LanguageChangeCode)
        emailLbl.text = "emailLblUPD".localizableString(loc: LanguageChangeCode)
        zipCodeLbl.text = "zipCodeLblUPD".localizableString(loc: LanguageChangeCode)
        stateLocationLbl.text = "stateLocationLblUPD".localizableString(loc: LanguageChangeCode)
        emailNotificationPreferenceLbl.text = "emailNotificationPreferenceLblUPD".localizableString(loc: LanguageChangeCode)
        buyingActivityLbl.text = "buyingActivityLblUPD".localizableString(loc: LanguageChangeCode)
        chatMesageEmailLbl.text = "chatMesageEmailLblUPD".localizableString(loc: LanguageChangeCode)
        sellingActivityLbl.text = "sellingActivityLblUPD".localizableString(loc: LanguageChangeCode)
        sell4bidsInfoLbl.text = "sell4bidsInfoLblUPD".localizableString(loc: LanguageChangeCode)
        watchingLbl.text = "watchingLblUPD".localizableString(loc: LanguageChangeCode)
        followersLbl.text = "followersLblUPD".localizableString(loc: LanguageChangeCode)
        followingLbl.text = "followingLblUPD".localizableString(loc: LanguageChangeCode)
        totalListingsInfo.text = "totalListingsInfoUPD".localizableString(loc: LanguageChangeCode)
        buyingandBidsLbl.text = "buyingandBidsLblUPD".localizableString(loc: LanguageChangeCode)
        boughtandWinsLbl.text = "boughtandWinsLblUPD".localizableString(loc: LanguageChangeCode)
        unreadMessageLbl.text = "unreadMessageLblUPD".localizableString(loc: LanguageChangeCode)
        unreadNotificationLbl.text = "unreadNotificationLblUPD".localizableString(loc: LanguageChangeCode)
        // followersLbl.rightAlign(LanguageCode : LanguageChangeCode)
    }
    
    func setupViews() {
        
//        tableView.estimatedRowHeight = 60
        
        cosmosViewrating.settings.updateOnTouch =  false
        
        //    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //    navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        let editIconTap = UITapGestureRecognizer(target: self, action: #selector(editProfileImageTapped))
        userEditImageView.addGestureRecognizer(editIconTap)
        userEditImageView.isUserInteractionEnabled = true
        
        let userImageTap = UITapGestureRecognizer(target: self, action: #selector(editPhotoTapped))
        userImageview.addGestureRecognizer(userImageTap)
        userImageview.isUserInteractionEnabled = true
        userImageview.layer.borderColor = UIColor.black.cgColor
        userImageview.layer.borderWidth = 2
        userImageview.layer.cornerRadius = userImageview.frame.width/2
        userImageview.layer.masksToBounds = false
        userImageview.makeRound()
        userImageview.clipsToBounds = true
        
        changePhoto.layer.borderColor = UIColor.black.cgColor
        changePhoto.layer.borderWidth = 2
        
        //    let doneBarBtn = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(backBtnTap))
        //    navigationItem.leftBarButtonItem = doneBarBtn
    }
    
    var downloadCompleted = false
    //MARK:- Private functions
    func addFidgetImageView() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        fidgetImageView = UIImageView(frame: frame)
        fidgetImageView.toggleRotateAndDisplayGif()
        self.view.addSubview(fidgetImageView)
        DispatchQueue.main.async {
            self.fidgetImageView.isHidden = true
        }
        
    }
    
    func toggleActivitiesOfUser(flag: Bool, flagBuyingOrSelling: Int) {
        var statusString = "off"
        if flag {
            statusString = "on"
        }
        let activitiesChildString = flagBuyingOrSelling == 0 ? "buyingActivities" : (flagBuyingOrSelling == 1 ? "sellingActivities" : "chatActivities" )
        let activitiesString = flagBuyingOrSelling == 0 ? "Buying Activities" : (flagBuyingOrSelling == 1 ? "Selling Activities" : "Chat Activities")
        
        let ref = dbRef.child("users").child(SessionManager.shared.userId).child("configs")
        toggleFidgetVisibility(flag: true)
        ref.child(activitiesChildString).setValue(statusString) { (error:Error?, dbRef) in
            self.toggleFidgetVisibility(flag: false)
            if let error = error {
                showSwiftMessageWithParams(theme: .error, title: activitiesString, body: "Oops. Some thing went wrong. \(error.localizedDescription)")
            }else {
                var mes = ""
                if flag{ mes = "You will receive all emails regarding \(activitiesString)" }
                else {  mes = "You Won't receive any emails regarding \(activitiesString)" }
                
                showSwiftMessageWithParams(theme: .success, title: activitiesString, body: mes)
            }
        }
    }
    
    func toggleFidgetVisibility(flag : Bool) {
        
    }
    
    @objc func backBtnTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func editPhotoTapped(){
        self.performSegue(withIdentifier: "showimage", sender: self)
    }
    
//    func checkInternet(){
//        if  InternetAvailability.isConnectedToNetwork() == true {
//            guard let userData = self.userData else {
//                return
//            }
//            if let userName =  userData.name {
//                defaults.set(userName, forKey: "UserName")
////                self.navigationItem.title = userName
//                self.titleview.titleLbl.text = userName
//                getUserData()
//            }
//        }
//        else {
////            self.navigationItem.title = "Sell4Bids"
//            self.titleview.titleLbl.text = "Sell4Bids"
//            self.alert(message: "Make sure your Device is connected to Internet", title: "No Internet Connection")
//        }
//    }
    
    @objc func editProfileImageTapped(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "EditUserProfileVc") as? EditUserProfileVc
        navigationController?.pushViewController(controller!, animated: true)
    }
    
    func getUserData(){
        //self.navigationItem.title = self.userArray[0].name
        guard let userData = self.userData else { return }
        self.userNameLabel.text = userData.name
        self.emailLabel.text = userData.email
        defaults.set(userData.image, forKey: "UserImage")
        
        self.userImageview.sd_setImage(with: URL(string: userData.image ?? ""), placeholderImage: UIImage(named: "Profile-image-for-sell4bids-App" ))
        
        self.stateLabel.text = userData.state
        if let zipCode = userData.zipCode {
            self.zipCodeLabel.text = "\(zipCode)"
        }
        else {
            self.zipCodeLabel.text = "Edit Profile to update ZipCode"
        }
        
        if let followerNumber = userData.follower  {
            var followerNumbertxt = String()
            if followerNumber == 1 {
                followerNumbertxt = "Memebers"
            }else {
                followerNumbertxt = "Member"
            }
            self.followerLabel.text = "\(followerNumber) \(followerNumbertxt)"
        }
        if let followingNumber = userData.following  {
            var followingNumbertxt = String()
            if followingNumber == 1 {
                followingNumbertxt = "Members"
            } else {
                followingNumbertxt = "Member"
            }
            self.followingLabel.text =  "\(followingNumber) \(followingNumbertxt)"
        }
        if let totalSelling =  userData.totalListing  {
            var totalSellingtxt = String()
            if totalSelling > 1 {
                totalSellingtxt = "Items"
            }else {
                totalSellingtxt = "Item"
            }
            self.totalListingLabel.text = "\(totalSelling) \(totalSellingtxt)"
        }
        if let totalBuying =  userData.buying  {
            var totalBuyingtxt = String()
            if totalBuying > 1 {
                totalBuyingtxt = "Items"
            }else {
                totalBuyingtxt = "Item"
            }
            self.buyingLabel.text = "\(totalBuying) \(totalBuyingtxt)"
        }
        if let totalWatching =  userData.watching  {
            var itemtxt = String()
            if totalWatching > 1 {
                itemtxt = "Items"
            }else {
                itemtxt = "Item"
            }
            self.watchingLabel.text = "\(totalWatching) \(itemtxt)"
        }
        if let totalBought =  userData.bought  {
            var totalBoughttxt = String()
            if totalBought > 1 {
                totalBoughttxt = "Items"
            }else {
                totalBoughttxt = "Item"
            }
            
            self.boughtLabel.text = "\(totalBought) \(totalBoughttxt)"
        }
        if let totalNotify = userData.unReadNotify  {
            var totalNotifytxt = String()
            if totalNotify > 1 {
                totalNotifytxt = "Notifications"
            }else {
                totalNotifytxt = "Notification"
            }
            
            self.unReadNotifyLabel.text = "\(totalNotify) \(totalNotifytxt) "
        }
        if let totalmesage = userData.unReadMessage  {
            var totalmessagetxt = String()
            if totalmesage > 1 {
                totalmessagetxt = "Messages"
            }else {
                totalmessagetxt = "Message"
            }
            self.unReadMessagedLabel.text = "\(totalmesage) \(totalmessagetxt)"
        }
        if userData.averageRating != 0 {
            if let totalRating = userData.averageRating  {
                
                self.cosmosViewrating.rating = Double(totalRating)
                print("totalrating == \(totalRating)")
                let formatted = String(format: "%.2f", totalRating)
                self.totalRatingLabel.text = "(Ratings: \(formatted))"
                self.cosmosViewrating.reloadInputViews()
            }
            if let totalRatings = userData.totalRating  {
                
                let totalRatingsInt = Int(totalRatings)
                
            }
        }
        else {
            
            
            self.cosmosViewrating.rating = 5
            self.totalRatingLabel.text = "No ratings Yet"
        }
        self.cosmosViewrating.settings.updateOnTouch = false
        
    }
    //MARK:- IBActions and user interaction
    
    @IBAction func btnEditDetailsTapped(_ sender: UIButton) {
        editProfileImageTapped()
    }
    
    @IBAction func btnChangePhotoTapped(_ sender: UIButton) {
        editphotoButtonTapped(sender)
    }
    
    @IBAction func switchBuyingActivitiesTouched(_ sender: UISwitch) {
        print("buying activies touches")
        if sender.isOn {
            toggleActivitiesOfUser(flag: true, flagBuyingOrSelling: 0)
        }//end if sender.isOn
        else {
            toggleActivitiesOfUser(flag: false, flagBuyingOrSelling: 0)
        }
    }
    
    
    
    
    
    @IBAction func switchSellingActivitiesTapped(_ sender: UISwitch) {
        if sender.isOn {
            toggleActivitiesOfUser(flag: true, flagBuyingOrSelling: 1)
        }//end if sender.isOn
        else {
            toggleActivitiesOfUser(flag: false, flagBuyingOrSelling: 1)
        }
    }
    
    
    @IBAction func ChatActivitiesTouched(_ sender: UISwitch) {
        print("buying activies touches")
        if sender.isOn {
            toggleActivitiesOfUser(flag: true, flagBuyingOrSelling: 2)
        }//end if sender.isOn
        else {
            toggleActivitiesOfUser(flag: false, flagBuyingOrSelling: 2)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as? ChangeImagePopUpVc
        
        dest?.delegate = self
    }
    
    func dataChanged(UserImage: UIImage) {
        userImageview.image = UserImage
    }
    
    @IBAction func editphotoButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "changePhotoPopUp", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.addShadowView()
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            return Env.isIpad ? 80 : 90
        }
        else if indexPath.row == 6 {
            return Env.isIpad ? 250 : 200
            
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}









