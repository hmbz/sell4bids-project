//
//  UserProfileVc.swift
//  Sell4Bids
//
//  Created by admin on 10/17/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import Cosmos
import XLPagerTabStrip

class SellerProfileVC: UIViewController, IndicatorInfoProvider {
    
    //MARK:- Properties
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var emptyProductMessage: UILabel!
    @IBOutlet weak var imgeView: UIImageView!
    @IBOutlet weak var fidgetImageView: UIImageView!
    var MainAPi = MainSell4BidsApi()
     var MainApis = MainSell4BidsApi()
    @IBOutlet weak var errorImg: UIImageView!
    @IBOutlet weak var UserView: UIView!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var ratingControl: CosmosView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var blockBtn: DesignableButton!
    @IBOutlet weak var followBtn: DesignableButton!
    @IBOutlet weak var userSegmentControl: UISegmentedControl!
    @IBOutlet weak var sellerTableView: UITableView!
    
    
    weak var delegate : sellerProfileVCDelegate?
    let detailView = false
    //MARK:- Variables
    var userData:UserModel!
    var userProductArray = [ProductModel]()
//    var dbRef: DatabaseReference!
    private let leftAndRightPaddings: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 30.0
    var nav:UINavigationController?
    var productsCount:Int = 0
    var followersCount:Int = 0
    var followingCount:Int = 0
    var isfollowing:Bool = false
    var isblock : Bool = false
//    var currentUserId = Auth.auth().currentUser?.uid
    var userIdToDisplayData : String?
    var sellerProfileImage : UIImage? = nil
    var UserDetails : FollowersModel?
    var UserFollowingDetails : FollowingModel?
    var sellerDetail : SellerDetailModel?
    var Myselling  = [sellingModel]()
    var followingArr = [FollowingModel]()
    var followerArr = [FollowersModel]()
    lazy var orderArray = [orderModel]()
    lazy var offerArray = [offerModel]()
    
    func segmentStyle() {
        let font = UIFont.boldSystemFont(ofSize: 15)
        userSegmentControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                               for: .normal)
    }

    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        let getIndex = userSegmentControl.selectedSegmentIndex
        print(getIndex)
        switch getIndex {
        case 0:
          print("At Listing")
            self.collView.isHidden = false
            self.sellerTableView.isHidden = true
        case 1 :
           print("At Following")
           self.collView.isHidden = true
            self.sellerTableView.isHidden = false
            self.sellerTableView.tag = 1
           followingArr.removeAll()
            getFollowingListItem()
        case 2:
           print("At Follower")
           self.collView.isHidden = true
           self.sellerTableView.isHidden = false
           self.sellerTableView.tag = 0
           followerArr.removeAll()
           getFollowersListItem()
        default:
            print("No Index")
        }
    }
    
    
    @IBOutlet weak var DimView: UIView!
    
    
    func getFollowingListItem(){
//        followerArr.removeAll()
        followingArr.removeAll()
        
        let start = followingArr.count
        
        MainAPi.Following_Api(user_ID: self.sellerDetail!.id, country: "USA", start: "\(start)", limit: "10", completionHandler: { (status, swifymessage, error) in
            
            self.fidgetImageView.isHidden = true
            
            if status {
                             Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                             let errormessage = swifymessage!["message"].stringValue
                             if errormessage.contains("No selling items found") {
                                 self.emptyProductMessage.isHidden = false
                                 self.emptyProductMessage.text = errormessage
                                 self.errorImg.isHidden = false
                                 
                             }else {
                                 self.emptyProductMessage.isHidden = true
                                 self.errorImg.isHidden = true
                                 
                             }
                self.followingArr.removeAll()
                let totalCount = swifymessage!["totalCount"].int!
                let message = swifymessage!["message"]
                print("message1 = \(message)")
                if totalCount > 0 {
                    
                    for item in 0...totalCount-1{
                        
                        
                        let data = message[item]
                        
                        let userID = data["_id"].stringValue
                        let name = data["name"].stringValue
                        let image = data["image"].stringValue
                        var averageRating = ""
                        var totalRatings = ""
                        
                        if data["averagerating"].exists(){
                            averageRating = data["averagerating"].stringValue
                        }else{
                        }
                        
                        if data["totalratings"].exists(){
                            totalRatings = data["totalratings"].stringValue
                        }else{
                        }
                        let followingItems = FollowingModel.init(name: name, userid: userID, totalrating: totalRatings, averagerating: averageRating, image: image)
                        
                        self.followingArr.append(followingItems)
                    }
                    self.sellerTableView.tag = 1
                    self.sellerTableView.reloadData()
                    
                }else{
                 
                }
                self.sellerTableView.reloadData()
            }else{
                
            }
            
            if error.contains("The network connection was lost"){
                
                let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                self.present(alert, animated: true, completion: nil)
                
                
            }
            
            
            if error.contains("The Internet connection appears to be offline.") {
                
                let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            if error.contains("A server with the specified hostname could not be found."){
                
                let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                
                self.present(alert, animated: true, completion: nil)
            }
            
            if error.contains("The request timed out.") {
                
                let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        })
        
    }
    
    func getFollowersListItem(){
        followerArr.removeAll()
        followingArr.removeAll()
        let start = followerArr.count
//        self.fidgetImageView.toggleRotateAndDisplayGif()
        Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
        MainAPi.Follower_Api(user_ID: self.sellerDetail!.id, country: "USA", start: "\(start)", limit: "10", completionHandler: { (status, swifymessage, error) in
//            self.fidgetImageView.isHidden = true
            if status {
              
                             Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                             let errormessage = swifymessage!["message"].stringValue
                             if errormessage.contains("No selling items found") {
                                 self.emptyProductMessage.isHidden = false
                                 self.emptyProductMessage.text = errormessage
                                 self.errorImg.isHidden = false
                                 
                             }else {
                                 self.emptyProductMessage.isHidden = true
                                 self.errorImg.isHidden = true
                                 
                             }
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                self.followerArr.removeAll()
                let totalCount = swifymessage!["totalCount"].int!
                if totalCount == 0 {
//                    self.errorImg.isHidden = false
//                    self.emptyProductMessage.isHidden = false
                }else {
//                    self.errorImg.isHidden = true
//                    self.emptyProductMessage.isHidden = true
                }
                let message = swifymessage!["message"]
                print("message1 = \(message)")
                for msg in message {
                    let uid = msg.1["uid"].stringValue
                    let name = msg.1["name"].stringValue
                    let averagerating = msg.1["averagerating"].doubleValue
                    let image = msg.1["image"].stringValue
                    let totalrating = msg.1["totalrating"].doubleValue
                    let id = msg.1["_id"].stringValue
                    
                    let userdata = FollowersModel.init(uid: uid, name: name, averagerating: averagerating, image: image, totalratings: totalrating, id: id)
                    self.followerArr.append(userdata)
                    self.sellerTableView.tag = 0
                    self.sellerTableView.reloadData()
                }
                 self.sellerTableView.reloadData()
                if error.contains("The network connection was lost"){
                    
                    let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                    alert.addAction(ok)
                    fidget.stopfiget(fidgetView: self.fidgetImageView)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
                
                if error.contains("The Internet connection appears to be offline.") {
                    
                    let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                    fidget.stopfiget(fidgetView: self.fidgetImageView)
                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                if error.contains("A server with the specified hostname could not be found."){
                    
                    let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
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
                
            }
            
        })
    }
    
    func getUserdetails() {
        
        MainAPi.Seller_Detail_Api(buyer_uid: SessionManager.shared.userId, seller_uid: self.sellerDetail!.id) { (status, data, error) in
            
            if status {
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                let message = data!["message"]
                let blocked = data!["blocked"].boolValue
                let following = data!["following"].boolValue
                let productCount = data!["productCount"].stringValue
                let followerCount = data!["followerCount"].stringValue
                let followingCount = data!["followingCount"].stringValue
                
                
                
                let id = message["_id"].stringValue
                let image = message["image"].stringValue
                let totalrating = message["totalratings"].doubleValue
                let averagerating = message["averagerating"].doubleValue
                let name = message["name"].stringValue
                let sellerdata = SellerDetailModel.init(blocked: blocked, following: following, id: id, image: image, totalrating: totalrating, averagerating: averagerating, name: name , productCount: productCount , followerCount: followerCount , followingCount: followingCount)
                
                
                self.sellerDetail = sellerdata
                self.setUpUserProfile()
                self.collView.reloadData()
                
                
                //                if (self.currentUserId == sellerdata.id) {
                //
                //                    let cancel = UIBarButtonItem.init(image:UIImage(named: "stepBack") , style:.plain, target: self, action: #selector(self.backBtnTap))
                //                    self.navigationItem.leftBarButtonItem = cancel
                //                    self.navigationItem.title = sellerdata.name
                //                }
                
                
                
              
            }
            
            
       
    }
    }
    
    func getSellingItem(){
        
        fidgetImageView.toggleRotateAndDisplayGif()
        Spinner.load_Spinner(image: fidgetImageView, view: DimView)
        Myselling.removeAll()
        let start = Myselling.count
        var type = String()
        print("SellerID == \(sellerDetail!.id)")
        print("SellerUID == \(SessionManager.shared.userId)")
        if sellerDetail!.id == SessionManager.shared.userId {
            type = "owner"
        }else {
            type = "user"
        }
        
        MainAPi.Selling_Api(user_ID: sellerDetail!.id, country: "USA", start: "\(start)", limit: "100", type: type, completionHandler: { (status, swifymessage, error) in
            
            if status {
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                let errormessage = swifymessage!["message"].stringValue
                if errormessage.contains("No selling items found") {
                    self.emptyProductMessage.isHidden = false
                    self.emptyProductMessage.text = errormessage
                    self.errorImg.isHidden = false
                    
                }else {
                    self.emptyProductMessage.isHidden = true
                    self.errorImg.isHidden = true
                    
                }
                
                print("userid.. = \(SessionManager.shared.userId)")
                let totalCount = swifymessage!["totalCount"].int!
                let message = swifymessage!["message"]
                print("message1 = \(message)")
                
                for msg in message {
                    //Item Object
                    let itemCategory = msg.1["itemCategory"].stringValue
                    _ = msg.1["itemAuctionType"].stringValue
                    
                    
                    //Services Object
                    if itemCategory.contains("Services") {
                        
                        // Service Detail View
                        let startPrice = msg.1["startPrice"].intValue
                        let visibility = msg.1["visibility"].boolValue
                        let image_0 = msg.1["images_small_path"]
                        var image_array = [String]()
                        for image in image_0 {
                            image_array.append(image.1.stringValue)
                        }
                        let chargeTime = msg.1["chargeTime"].int64Value
                        let token = msg.1["token"].stringValue
                        let description = msg.1["description"].stringValue
                        let uid = msg.1["uid"].stringValue
                        _ = swifymessage!["watching"].boolValue
                        let itemKey = msg.1["_id"].stringValue
                        let loc = msg.1["loc"]
                        _ = loc["coordinates"]
                        let id = msg.1["_id"].stringValue
                        
                        var watch_uid = String()
                        var watch_token = String()
                        var ItemimagesArr = [String]()
                        
                        let itemAuctionType = msg.1["itemAuctionType"].stringValue
                        let country_code = msg.1["country_code"].stringValue
                        _ = msg.1["startTime"].stringValue
                        let timeRemaining = msg.1["timeRemaining"].int64Value
                        let title = msg.1["title"].stringValue
                        let watching = msg.1["watching"]
                        for watch in watching {
                            let watch_uidvalue = watch.1["uid"].stringValue
                            let watch_tokenvalue = watch.1["token"].stringValue
                            watch_uid = watch_uidvalue
                            watch_token = watch_tokenvalue
                            
                        }
                        let zipcode = msg.1["zipcode"].stringValue
                        let city = msg.1["city"].stringValue
                        let endTime = msg.1["endTime"].int64Value
                        let state = msg.1["state"].stringValue
                        let autoReList = msg.1["autoReList"].boolValue
                        let acceptOffers = msg.1["acceptOffers"].boolValue
                        var latitude = Double()
                        var londtitude = Double()
                        let itemimages = msg.1["old_images"]
                        let coordinates = loc["coordinates"].array
                        for itemimg in itemimages {
                            ItemimagesArr.append(itemimg.1.stringValue)
                            print("Item Image Url Backhand == \(itemimg.1.stringValue)")
                        }
                        let serviceType = msg.1["serviceType"].stringValue
                        let servicePrice = msg.1["servicePrice"].stringValue
                        let negotiable = msg.1["negotiable"].boolValue
                        let userRole = msg.1["userRole"].stringValue
                        let image = msg.1["images_path"]
                        var imageArray = [String]()
                        for img in image {
                            imageArray.append(img.1.stringValue)
                        }
                        let quantity = msg.1["quantity"].intValue
                        let ordering = msg.1["ordering"].boolValue
                        let currency_string = msg.1["currency_string"].stringValue
                        let currency_symbol = msg.1["currency_symbol"].stringValue
                        let admin_verify = msg.1["admin_verify"].stringValue
                        self.orderArray.removeAll()
                        self.offerArray.removeAll()
                        let OrderArray = msg.1["orders"].arrayValue
                        for item in OrderArray {
                            guard let OrderDic = item.dictionary else {return}
                            let orderId = OrderDic["_id"]?.string ?? ""
                            let sellerId = OrderDic["seller_uid"]?.string ?? ""
                            let buyerOfferCount = OrderDic["buyerOfferCount"]?.int ?? -1
                            let offersTypeArray = OrderDic["offers"]?.array ?? []
                            for item in offersTypeArray {
                                guard let Dic = item.dictionary else {return}
                                let message = Dic["message"]?.string ?? ""
                                let role = Dic["role"]?.string ?? ""
                                let price = Dic["price"]?.string ?? ""
                                let quantity = Dic["quantity"]?.string ?? ""
                                let time = OrderDic["time"]?.string ?? ""
                                let object = offerModel.init(message: message, role: role, price: price, quantity: quantity, time: time)
                                self.offerArray.append(object)
                            }
                            print(self.offerArray)
                            let obj = orderModel.init(orderId: orderId, sellerId: sellerId, OfferCount: buyerOfferCount, OfferArray: self.offerArray)
                            self.orderArray.append(obj)
                        }
                        print(self.orderArray)
                        
                        latitude = coordinates![1].doubleValue
                        londtitude = coordinates![0].doubleValue
                        
                        let ServiceDetail = sellingModel.init(id: id, latitude: latitude, longtitude: londtitude, chargeTime: chargeTime, images_path: imageArray, images_small_path: image_array, startTime: Int64(startPrice), visibility: visibility, old_small_images: ItemimagesArr, image: imageArray, token: token, country_code: country_code, city: city, title: title, startPrice: startPrice, itemCategory: itemCategory, uid: uid, description: description, endTime: endTime, currency_string: currency_string, currency_symbol: currency_symbol, autoReList: autoReList, acceptOffers: acceptOffers, platform: "iOS", item_id: itemKey, state: state, userRole: userRole, negotiable: negotiable, serviceType: serviceType, servicePrice: servicePrice, timeRemaining: timeRemaining, ordering: ordering , quantity: quantity , zipcode: zipcode , OrderArray: self.orderArray ,itemAuctionType: itemAuctionType , admin_verify: admin_verify)
                        
                        
                        self.Myselling.append(ServiceDetail)
                        self.collView.reloadData()
                        
                        
                    }else if itemCategory.contains("Jobs") {
                        let id = msg.1["_id"].stringValue
                        let loc = msg.1["loc"]
                        let coordinates = loc["coordinates"]
                        var coordinates_arr = [Double]()
                        for coordninatesValue in  coordinates {
                            coordinates_arr.append(coordninatesValue.1.doubleValue)
                        }
                        let chargeTime = msg.1["chargeTime"].int64Value
                        let images_path = msg.1["images_path"]
                        var images_path_arr = [String]()
                        for images_pathvalues in images_path {
                            images_path_arr.append(images_pathvalues.1.stringValue)
                        }
                        let images_small_path = msg.1["images_small_path"]
                        var images_small_path_arr = [String]()
                        for images_small_pathvalues in  images_small_path {
                            images_small_path_arr.append(images_small_pathvalues.1.stringValue)
                            
                        }
                        let images_info = msg.1["images_info"]
                        var height = [Double]()
                        var widht = [Double]()
                        var ratio = [Double]()
                        for images_info_values in images_info {
                            ratio.append(images_info_values.1["ratio"].doubleValue)
                            widht.append(msg.1["ratio"].doubleValue)
                            height.append(msg.1["height"].doubleValue)
                        }
                        let startTime = msg.1["startTime"].int64Value
                        let visibility = msg.1["visibility"].boolValue
                        let ordering = msg.1["ordering"].boolValue
                        let listingEnded = msg.1["listingEnded"].boolValue
                        let old_small_images = msg.1["old_small_images"]
                        var old_small_images_arr = [String]()
                        for old_small_imagesvalues in old_small_images {
                            old_small_images_arr.append(old_small_imagesvalues.1.stringValue)
                        }
                        let old_images = msg.1["old_images"]
                        var old_images_arr = [String]()
                        for old_imagesvalue in  old_images {
                            old_images_arr.append(old_imagesvalue.1.stringValue)
                        }
                        let country_code = msg.1["country_code"].stringValue
                        let city = msg.1["city"].stringValue
                        let title = msg.1["title"].stringValue
                        let zipcode = msg.1["zipcode"].stringValue
                        let itemAuctionType = msg.1["itemAuctionType"].stringValue
                        let uid = msg.1["uid"].stringValue
                        let description = msg.1["description"].stringValue
                        let endTime = msg.1["endTime"].int64Value
                        let item_id = msg.1["item_id"].stringValue
                        let startPrice = msg.1["startPrice"].intValue
                        let itemCategory = msg.1["itemCategory"].stringValue
                        let acceptOffers = msg.1["acceptOffers"].boolValue
                        let autoReList = msg.1["autoReList"].boolValue
                        let condition = msg.1["condition"].stringValue
                        let conditionValue = msg.1["conditionValue"].stringValue
                        let quantity = msg.1["quantity"].intValue
                        let state = msg.1["state"].stringValue
                        let token = msg.1["token"].stringValue
                        let companyName = msg.1["companyName"].stringValue
                        let companyDescription = msg.1["companyDescription"].stringValue
                        let jobCategory = msg.1["jobCategory"].stringValue
                        let payPeriod = msg.1["payPeriod"].stringValue
                        let employmentType = msg.1["employmentType"].stringValue
                        let reservePrice = msg.1["reservePrice"].stringValue
                        let timeRemaining = msg.1["timeRemaining"].int64Value
                        let admin_verify = msg.1["admin_verify"].stringValue
                        let benefits = msg.1["benefits"]
                        var medical = String()
                        var PTO = String()
                        var FZOK = String()
                        for benefit in benefits {
                            
                            if benefit.1 == "Medical" {
                                medical = benefit.1.stringValue
                            }
                            if benefit.1 == "PTO" {
                                PTO = benefit.1.stringValue
                            }
                            if benefit.1 == "FZOk"{
                                FZOK = benefit.1.stringValue
                            }
                            
                            print("Selling_Benefit_0 == \(benefit.0)")
                            print("Selling_Benefit_1 == \(benefit.1)")
                            
                            
                        }
                        
                        
                        let job = sellingModel.init(id: id, coordinates: coordinates_arr, chargeTime: chargeTime, images_path: images_path_arr, images_small_path: images_small_path_arr, height: height, widht: widht, ratio: ratio, startTime: startTime, visibility: visibility, ordering: ordering, listingEnded: listingEnded, old_small_images: old_small_images_arr, old_images: old_images_arr, token: token, country_code: country_code, city: city, title: title, startPrice: startPrice, itemCategory: itemCategory, uid: uid, condition: condition, description: description, endTime: endTime, currency_string: "", currency_symbol: "", autoReList: autoReList, acceptOffers: acceptOffers, quantity: quantity, platform: "ios", item_id: item_id, state: state, companyName: companyName, companyDescription: companyDescription, jobCategory: jobCategory, payPeriod: payPeriod, employmentType: employmentType, timeRemaining: timeRemaining, zipcode: zipcode , medical: medical , PTO: PTO , FZOK: FZOK , itemAuctionType: itemAuctionType , admin_verify: admin_verify)
                        
                        self.Myselling.append(job)
                        self.collView.reloadData()
                    }else if itemCategory.contains("Vechicles") {
                        
                        // Vehicles_Details_View
                        
                        let id = msg.1["_id"].stringValue
                        let loc = msg.1["loc"]
                        let corrdinate = loc["coordinates"]
                        
                        var maxBid = Int64()
                        var askPrice = Int64()
                        var winner = String()
                        var u_id = String()
                        var bid = Int64()
                        var watch_uid = String()
                        var watch_token = String()
                        var ItemimagesArr = [String]()
                        
                        let bids = msg.1["bids"]
                        for values in bids {
                            let maxBidvalue = values.1["maxBid"].int64Value
                            let askPricevalue = values.1["askPrice"].int64Value
                            let winnervalue = values.1["winner"].stringValue
                            maxBid = maxBidvalue
                            askPrice = askPricevalue
                            winner = winnervalue
                        }
                        
                        let bidList = msg.1["bidList"]
                        for bidlst in bidList {
                            let uidvalue = bidlst.1["uid"].stringValue
                            let bidvalue = bidlst.1["bid"].int64Value
                            u_id = uidvalue
                            bid = bidvalue
                        }
                        
                        let chargeTime = msg.1["chargeTime"].int64Value
                        let city = msg.1["city"].stringValue
                        let conditionValue = msg.1["conditionValue"].stringValue
                        let condition = msg.1["condition"].stringValue
                        let country_code = msg.1["country_code"].stringValue
                        let description = msg.1["description"].stringValue
                        let endTime = msg.1["endTime"].int64Value
                        let image = msg.1["images_path"]
                        var imageArray = [String]()
                        for img in image {
                            imageArray.append(img.1.stringValue)
                        }
                        let itemAuctionType = msg.1["itemAuctionType"].stringValue
                        let itemCategory = msg.1["itemCategory"].stringValue
                        let itemKey = msg.1["_id"].stringValue
                        let state = msg.1["itemState"].stringValue
                        let startPrice = msg.1["startPrice"].intValue
                        let startTime = msg.1["startTime"].stringValue
                        let timeRemaining = msg.1["timeRemaining"].int64Value
                        let reservePrice = msg.1["reservePrice"].intValue
                        let title = msg.1["title"].stringValue
                        let token = msg.1["token"].stringValue
                        let uid = msg.1["uid"].stringValue
                        let visibility = msg.1["visibility"].boolValue
                        let zipcode = msg.1["zipcode"].stringValue
                        let autoReList = msg.1["autoReList"].boolValue
                        let acceptOffers = msg.1["acceptOffers"].boolValue
                        let currency_string = msg.1["currency_string"].stringValue
                        let currency_symbol = msg.1["currency_symbol"].stringValue
                        let year = msg.1["year"].stringValue
                        let make = msg.1["make"].stringValue
                        let model = msg.1["model"].stringValue
                        let trim = msg.1["trim"].stringValue
                        let milesDriven = msg.1["miles_driven"].stringValue
                        let fuelType = msg.1["fuel_type"].stringValue
                        let color = msg.1["color"].stringValue
                        
                        
                        let image_0 = msg.1["images_small_path"]
                        var image_array = [String]()
                        for image in image_0 {
                            image_array.append(image.1.stringValue)
                        }
                        
                        let watchingbool = swifymessage!["watching"].boolValue
                        let watching = msg.1["watching"]
                        for watch in watching {
                            let watch_uidvalue = watch.1["uid"].stringValue
                            let watch_tokenvalue = watch.1["token"].stringValue
                            watch_uid = watch_uidvalue
                            watch_token = watch_tokenvalue
                        }
                        let quantity = msg.1["quantity"].intValue
                        let ordering = msg.1["ordering"].boolValue
                        let admin_verify = msg.1["admin_verify"].stringValue
                        var latitude = Double()
                        var londtitude = Double()
                        let itemimages = msg.1["images_info"]
                        let coordinates = loc["coordinates"].array
                        for itemimg in itemimages {
                            ItemimagesArr.append(itemimg.1.stringValue)
                            print("Item Image Url Backhand == \(itemimg.1.stringValue)")
                        }
                        self.orderArray.removeAll()
                        self.offerArray.removeAll()
                        let OrderArray = msg.1["orders"].arrayValue
                        for item in OrderArray {
                            guard let OrderDic = item.dictionary else {return}
                            let orderId = OrderDic["_id"]?.string ?? ""
                            let sellerId = OrderDic["seller_uid"]?.string ?? ""
                            let buyerOfferCount = OrderDic["buyerOfferCount"]?.int ?? -1
                            let offersTypeArray = OrderDic["offers"]?.array ?? []
                            for item in offersTypeArray {
                                guard let Dic = item.dictionary else {return}
                                let message = Dic["message"]?.string ?? ""
                                let role = Dic["role"]?.string ?? ""
                                let price = Dic["price"]?.string ?? ""
                                let quantity = Dic["quantity"]?.string ?? ""
                                let time = OrderDic["time"]?.string ?? ""
                                let object = offerModel.init(message: message, role: role, price: price, quantity: quantity, time: time)
                                self.offerArray.append(object)
                            }
                            print(self.offerArray)
                            let obj = orderModel.init(orderId: orderId, sellerId: sellerId, OfferCount: buyerOfferCount, OfferArray: self.offerArray)
                            self.orderArray.append(obj)
                        }
                        print(self.orderArray)
                        
                        
                        latitude = coordinates![1].doubleValue
                        londtitude = coordinates![0].doubleValue
                        
                        let VehicleDetail = sellingModel.init(id: id , chargeTime: chargeTime, images_path: imageArray, images_small_path: image_array, startTime: Int64(startPrice), visibility: visibility, ordering: ordering, old_small_images: ItemimagesArr, token: token, country_code: country_code, city: city, title: title, startPrice: startPrice, itemCategory: itemCategory, itemAuctionType: itemAuctionType, uid: uid, condition: condition, conditionValue: conditionValue, description: description, endTime: endTime, currency_string: currency_string, currency_symbol: currency_symbol, autoReList: autoReList, acceptOffers: acceptOffers, platform: "iOS", item_id: id, state: state, timeRemaining: timeRemaining, year: year, make: make, model: model, trim: trim, milesDriven: milesDriven, fuelType: fuelType, color: color, latitude: latitude, longtitude: londtitude, image: imageArray, watchBool: watchingbool, watch_uid: watch_uid, watch_token: watch_token, itemKey: itemKey , quantity: quantity, zipcode: zipcode , OrderArray: self.orderArray , admin_verify: admin_verify)
                        
                        self.Myselling.append(VehicleDetail)
                        self.collView.reloadData()
                        
                    }else {
                        let id = msg.1["_id"].stringValue
                        let loc = msg.1["loc"]
                        let coordinates = loc["coordinates"]
                        var coordinates_arr = [Double]()
                        for coordninatesValue in  coordinates {
                            coordinates_arr.append(coordninatesValue.1.doubleValue)
                        }
                        let chargeTime = msg.1["chargeTime"].int64Value
                        let images_path = msg.1["images_path"]
                        var images_path_arr = [String]()
                        for images_pathvalues in images_path {
                            images_path_arr.append(images_pathvalues.1.stringValue)
                        }
                        let images_small_path = msg.1["images_small_path"]
                        var images_small_path_arr = [String]()
                        for images_small_pathvalues in  images_small_path {
                            images_small_path_arr.append(images_small_pathvalues.1.stringValue)
                            
                        }
                        let images_info = msg.1["images_info"]
                        var height = [Double]()
                        var widht = [Double]()
                        var ratio = [Double]()
                        for images_info_values in images_info {
                            ratio.append(images_info_values.1["ratio"].doubleValue)
                            widht.append(msg.1["ratio"].doubleValue)
                            height.append(msg.1["height"].doubleValue)
                        }
                        let startTime = msg.1["startTime"].int64Value
                        let visibility = msg.1["visibility"].boolValue
                        let ordering = msg.1["ordering"].boolValue
                        let listingEnded = msg.1["listingEnded"].boolValue
                        let old_small_images = msg.1["old_small_images"]
                        var old_small_images_arr = [String]()
                        for old_small_imagesvalues in old_small_images {
                            old_small_images_arr.append(old_small_imagesvalues.1.stringValue)
                        }
                        let old_images = msg.1["old_images"]
                        var old_images_arr = [String]()
                        for old_imagesvalue in  old_images {
                            old_images_arr.append(old_imagesvalue.1.stringValue)
                        }
                        let country_code = msg.1["country_code"].stringValue
                        let city = msg.1["city"].stringValue
                        let title = msg.1["title"].stringValue
                        let zipcode = msg.1["zipcode"].stringValue
                        let itemAuctionType = msg.1["itemAuctionType"].stringValue
                        let uid = msg.1["uid"].stringValue
                        let description = msg.1["description"].stringValue
                        let endTime = msg.1["endTime"].int64Value
                        let token = msg.1["token"].stringValue
                        let startPrice = msg.1["startPrice"].intValue
                        let itemCategory = msg.1["itemCategory"].stringValue
                        let condition = msg.1["condition"].stringValue
                        let currency_string = msg.1["currency_string"].stringValue
                        let currency_symbol = msg.1["currency_symbol"].stringValue
                        let admin_verify = msg.1["admin_verify"].stringValue
                        let autoReList = msg.1["autoReList"].boolValue
                        let acceptOffers = msg.1["acceptOffers"].boolValue
                        let quantity = msg.1["quantity"].intValue
                        let platform = msg.1["platform"].stringValue
                        let state = msg.1["state"].stringValue
                        self.orderArray.removeAll()
                        self.offerArray.removeAll()
                        let OrderArray = msg.1["orders"].arrayValue
                        for item in OrderArray {
                            guard let OrderDic = item.dictionary else {return}
                            let orderId = OrderDic["_id"]?.string ?? ""
                            let sellerId = OrderDic["seller_uid"]?.string ?? ""
                            let buyerOfferCount = OrderDic["buyerOfferCount"]?.int ?? -1
                            let offersTypeArray = OrderDic["offers"]?.array ?? []
                            for item in offersTypeArray {
                                guard let Dic = item.dictionary else {return}
                                let message = Dic["message"]?.string ?? ""
                                let role = Dic["role"]?.string ?? ""
                                let price = Dic["price"]?.string ?? ""
                                let quantity = Dic["quantity"]?.string ?? ""
                                let time = OrderDic["time"]?.string ?? ""
                                let object = offerModel.init(message: message, role: role, price: price, quantity: quantity, time: time)
                                self.offerArray.append(object)
                            }
                            print(self.offerArray)
                            let obj = orderModel.init(orderId: orderId, sellerId: sellerId, OfferCount: buyerOfferCount, OfferArray: self.offerArray)
                            self.orderArray.append(obj)
                        }
                        print(self.orderArray)
                        
                        let item = sellingModel.init(id: id, coordinates: coordinates_arr, chargeTime: chargeTime, images_path: images_path_arr, images_small_path: images_small_path_arr, height: height, widht: widht, ratio: ratio, startTime: startTime, visibility: visibility, ordering: ordering, listingEnded: listingEnded, old_small_images: old_small_images_arr, old_images: old_images_arr, token: token, country_code: country_code, city: city, title: title, startPrice: startPrice, itemCategory: itemCategory, itemAuctionType: itemAuctionType, uid: uid, condition: condition, description: description, endTime: endTime, currency_string: currency_string, currency_symbol: currency_symbol, autoReList: autoReList, acceptOffers: acceptOffers, quantity: quantity, platform: platform, item_id: id, state: "", timeRemaining: startTime, zipcode: zipcode , OrderArray: self.orderArray , admin_verify: admin_verify)
                        
                        self.Myselling.append(item)
                        self.collView.reloadData()
                        self.setUpUserProfile()
                    }
                    
                    
                }
                
            }
        })
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.isHidden = true
    }
     lazy var MyCollectionViewCellId: String = "productCollectionViewCell"
    
       lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
        
        // top bar function
        private func topMenu() {
            self.navigationItem.titleView = titleview
            titleview.titleLbl.text = "Seller Profile"
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
            dismiss(animated: true, completion: nil)
        }
        // going back directly towards the home
        @objc func homeBtnTapped(sender: UIButton) {
            print("Home Button Tapped")
            
        }
        
        override func viewLayoutMarginsDidChange() {
            titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
            print("titleview width = \(titleview.frame.width)")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        self.collView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        
       segmentStyle()
       getSellingItem()
        self.getUserdetails()
        sellerTableView.delegate = self
        sellerTableView.dataSource = self
//        setUpUserProfile()
        
        _ = "HeaderView"
        collView.register(UINib(nibName: "SellerDetailView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        self.title = "\(sellerDetail!.name)".localizableString(loc: LanguageChangeCode)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        collView.reloadData()
        self.navigationController?.navigationBar.topItem?.title = "";
        cutomizeCollectionView()
    }
    
    @objc func backBtnTap(){
        if detailView == false {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
        
//        dismiss(animated: true, completion: nil)
    }
    
    func cutomizeCollectionView(){
        //custom collectionView Cell size
        
        let bounds = UIScreen.main.bounds
        let width = (bounds.size.width - leftAndRightPaddings) / numberOfItemsPerRow
        let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
        //layout.itemSize = CGSize(width, width + heightAdjustment)
        layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
    }
    
    var downloadCompleted = false
    
    func getUserProducts() {
        
        
        
    }
    
    @objc func followButtontapped() {
        print("pressed")
        if isfollowing == false{
            
         
            
            
            MainAPi.Follow_User(follower_Id: sellerDetail!.id , following_id:SessionManager.shared.userId ) { (status, data, error) in
                
                if status {
                    _ = SweetAlert().showAlert("Follow User", subTitle: "You now follow \(self.sellerDetail!.name)", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                        
                        self.getUserdetails()
                
                        
                    })
                    
                }
                
            }
        
        }else if isfollowing == true{
            
            
            MainAPi.UnFollow_User(follower_Id: sellerDetail!.id , following_id:SessionManager.shared.userId ) { (status, data, error) in
                
                if status {
                    _ = SweetAlert().showAlert("Unfollow User", subTitle: "You have un-followed \(self.sellerDetail!.name)", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                        
                        self.getUserdetails()
                        
                        
                    })
                    
                    
                }
                
            }
            
//            MainAPi.UnFollow_User(follower_Id: sellerDetail!.id, following_id: SessionManager.shared.userId) { (status, data, error) in
//
//                print("status == \(status)")
//                print("data == \(data)")
//                print("error == \(error)")
//
//            }
//
        }
        
        
        
    }
    
    @objc func blockedButtontapped(){
        
        
        
        
        if isblock {
            let alert = UIAlertController(title: "Un-block Seller".localizableString(loc: LanguageChangeCode), message: "Do you want to un-block this seller?".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
            let actionBlock = UIAlertAction(title: "Un-block".localizableString(loc: LanguageChangeCode), style: .default) { (action) in
                
                
                self.MainAPi.Unblock_Api(user_ID: SessionManager.shared.userId, blockUserID: self.sellerDetail!.id, completionHandler: { (status, data, error) in
                    
                    
                    if status {
                        // Osama Mansoori 3-june-2019
                        self.isblock = true
                        _ = SweetAlert().showAlert("Un-block Seller", subTitle: "You have successfully un-blocked this seller.", style: .success, buttonTitle: "Thanks", action: { (status) in
                            
                            self.getUserdetails()
                            
                            
                        })
                        
                       
                    }
                    
                })
                
                
            }
            let actionCancel = UIAlertAction(title: "Cancel".localizableString(loc: LanguageChangeCode), style: .cancel)
            
            alert.addAction(actionBlock)
            alert.addAction(actionCancel)
            self.present(alert, animated: true)
            
        }else {
            let alert = UIAlertController(title: "Block Seller".localizableString(loc: LanguageChangeCode), message: "Do you want to block this seller?".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
            let actionBlock = UIAlertAction(title: "Block".localizableString(loc: LanguageChangeCode), style: .default) { (action) in
                
                
                self.MainAPi.block_Api(user_ID: SessionManager.shared.userId, blockUserID: self.sellerDetail!.id, completionHandler: { (status, data, error) in
                    
                    if status {
                        self.isblock = true
                      NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier12"), object: nil)

                        _ = SweetAlert().showAlert("Block Seller", subTitle: "You have successfully blocked this seller. You can un-block the seller anytime." , style: .success, buttonTitle: "Thanks", action: { (status) in
                            
                            self.getUserdetails()
                            
                            
                        })
                        
                    }
                })
                
                
            }
            let actionCancel = UIAlertAction(title: "Cancel".localizableString(loc: LanguageChangeCode), style: .cancel)
            
            alert.addAction(actionBlock)
            alert.addAction(actionCancel)
            self.present(alert, animated: true)
        }
        
        
        
       
        
        
        
    }
    
    
    
    //MARK:- Actions
    @objc func userImageTapped() {
        guard let image = self.sellerProfileImage else {
            return
        }
        let sellerImageVC = storyboard?.instantiateViewController(withIdentifier: "SellerImageVC") as! SellerImageVC
        sellerImageVC.userImage = image
        self.present(sellerImageVC, animated: true)
    }
    
    private func setUpUserProfile() {
        
        UserView.applyShadowOnView(cornerRadius: 6)
        followBtn.applyShadowOnView(cornerRadius: 20)
        blockBtn.applyShadowOnView(cornerRadius: 20)
        blockBtn.layer.borderWidth = 1.5
        blockBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        blockBtn.layer.masksToBounds = true
        
        if sellerDetail!.following {
            followBtn.setTitle("UnFollow", for: .normal)
            isfollowing = true
        }else {
            followBtn.setTitle("Follow", for: .normal)
            isfollowing = false
        }
        
        followBtn.addTarget(self, action: #selector(followButtontapped), for: .touchUpInside)
        blockBtn.addTarget(self, action: #selector(blockedButtontapped), for: .touchUpInside)
        
        if sellerDetail!.blocked {
            blockBtn.setTitle("Un-block", for: .normal)
            isblock = true
            followBtn.isEnabled = false
            followBtn.backgroundColor = UIColor.gray
        }else {
            blockBtn.setTitle("Block", for: .normal)
            isblock = false
            followBtn.isEnabled = true
            followBtn.backgroundColor = UIColor.black
        }

        userNameLbl.text = self.sellerDetail!.name
        let listing = self.sellerDetail!.productCount
        let follower = self.sellerDetail!.followerCount
        let following = self.sellerDetail!.followingCount
        userSegmentControl.setTitle("Listings \(listing)", forSegmentAt: 0)
        userSegmentControl.setTitle("Following \(following)", forSegmentAt: 1)
        userSegmentControl.setTitle("Followers \(follower)", forSegmentAt: 2)
        let downloader = SDWebImageDownloader.init()
        downloader.downloadImage(with: URL.init(string:  self.sellerDetail!.image), options: .highPriority, progress: nil) { (image_, data, error, success) in
            if let imagedownloded = image_ {
                self.userProfileImg.image = imagedownloded
                self.userProfileImg.isUserInteractionEnabled = true
                self.userProfileImg.image = imagedownloded
            }
        }
        
        if self.sellerDetail!.avertagerating != 0 {
            if let Rating = self.sellerDetail?.avertagerating {
                print(Rating)
                ratingControl.rating = Double(Rating)
                ratingControl.isUserInteractionEnabled = false
            }
            if let totalrating = self.sellerDetail?.totalrating {
                ratingLbl.text = "( Total Ratings : \(totalrating)  )"
            }
        }
        else {
            ratingControl.rating = 0
            ratingControl.isUserInteractionEnabled = false
            ratingLbl.text = "Not rated yet"
        }
    }
    
    
    
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SellerProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Myselling.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! productCollectionViewCell
        cell.quantityLbl.text = ""
        let product = Myselling[indexPath.row]
        //    cell.setupWith(product: product)
        let price = "\(product.currency_symbol)\(product.startPrice)"
        cell.buyNowBtn.setTitle(price, for: .normal)
        
        
        cell.titleLbl.text = "\(product.title)"
       
        if product.itemCategory == "Services" {
            cell.titleLbl.text = "\(product.title)"
            
            if product.old_small_images.count > 0 {
                let downloader = SDWebImageDownloader.init()
              downloader.downloadImage(with: URL.init(string: product.old_small_images[0]), options: .highPriority, progress: nil) { (image_, data, error, success) in
                    if let imagedownloded = image_ {
                        cell.itemImage.image = imagedownloded
                        cell.itemImage.isUserInteractionEnabled = true
                        self.sellerProfileImage = imagedownloded
                    }
                }
                
            }
//            cell.categoryBidNowBtn.setTitle(product.servicePrice, for: .normal)
           
//            cell.categoryBidNowBtn.tag = indexPath.row
//            cell.categoryBidNowBtn.addTarget(self, action: #selector(bidNowBtnTapped), for: .touchUpInside)
            
            
        }else if product.itemCategory == "Jobs" {
            
            cell.titleLbl.text = product.title
            let price = "\(product.currency_symbol)\(product.startPrice)"
            cell.buyNowBtn.setTitle(price, for: .normal)
//            cell.categoryBidNowBtn.setTitle(String(product.startPrice), for: .normal)
            let downloader = SDWebImageDownloader.init()
            downloader.downloadImage(with: URL.init(string: product.old_images.last!), options: .highPriority, progress: nil) { (image_, data, error, success) in
                if let imagedownloded = image_ {
                    cell.itemImage.image = imagedownloded
                    cell.itemImage.isUserInteractionEnabled = true
                    self.sellerProfileImage = imagedownloded
                }
            }
            
//            cell.categoryBidNowBtn.tag = indexPath.row
//            cell.categoryBidNowBtn.addTarget(self, action: #selector(bidNowBtnTapped), for: .touchUpInside)
            
            
        }
            
        else {
//            cell.categoryPriceLabel.text = product.title
//            cell.categoryBidNowBtn.setTitle(product.itemAuctionType, for: .normal)
            let downloader = SDWebImageDownloader.init()
            if product.old_images.last != nil {
                downloader.downloadImage(with: URL.init(string: product.old_images.last!), options: .highPriority, progress: nil) { (image_, data, error, success) in
                    if let imagedownloded = image_ {
                        cell.itemImage.image = imagedownloded
                        cell.itemImage.isUserInteractionEnabled = true
                        self.sellerProfileImage = imagedownloded
                    }
                }
            }
        
            
//            cell.categoryBidNowBtn.tag = indexPath.row
//            cell.categoryBidNowBtn.addTarget(self, action: #selector(bidNowBtnTapped), for: .touchUpInside)
            
            
        }
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let instance = Myselling
        guard indexPath.row < instance.count else {return}
        let Category = instance[indexPath.row].itemCategory
        if Category.lowercased() == "jobs" {
             let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
             let controller = storyBoard_.instantiateViewController(withIdentifier: "JobsDetailVC") as! JobsDetailVC
             controller.ImageArray = instance[indexPath.row].images_path as! [String]
             controller.itemName = instance[indexPath.row].title
             controller.itemId = instance[indexPath.row].id
             controller.sellerId = instance[indexPath.row].uid
             controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
         }
        else if Category.lowercased() == "services" {
             let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
             let controller = storyBoard_.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
          controller.ImageArray = instance[indexPath.row].images_path
             controller.itemName = instance[indexPath.row].title
             controller.itemId = instance[indexPath.row].id
             controller.sellerId = instance[indexPath.row].uid
             controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
         }
        else if Category.lowercased() == "vehicles" {
             let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
             let controller = storyBoard_.instantiateViewController(withIdentifier: "VehicleDetailVC") as! VehicleDetailVC
             controller.ImageArray = instance[indexPath.row].images_path as! [String]
             controller.itemName = instance[indexPath.row].title
             controller.itemId = instance[indexPath.row].id
             controller.sellerId = instance[indexPath.row].uid
             controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
         }
        else if Category.lowercased() == "housing" {
             
             let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
             let controller = storyBoard_.instantiateViewController(withIdentifier: "HousingDetailVC") as! HousingDetailVC
             controller.ImageArray = instance[indexPath.row].images_path as! [String]
             controller.itemName = instance[indexPath.row].title
          controller.itemId = instance[indexPath.row].id
             controller.sellerId = instance[indexPath.row].uid
          controller.ImageArray = instance[indexPath.row].images_path as! [String]
             controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
         }
        
         else {
             let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
             let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
             controller.itemName = instance[indexPath.row].title
             controller.itemId = instance[indexPath.row].id
             controller.sellerId = instance[indexPath.row].uid
             controller.ImageArray = instance[indexPath.row].images_path as! [String]
             controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
         }
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! SellerDetailCell
//
//        header.FollowingBtn.addShadowAndRoundNew()
////        header.BlockBtn.addShadowAndRoundNew()
//        header.BlockBtn.layer.borderWidth = 2
//        header.BlockBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        header.BlockBtn.layer.masksToBounds = true
//
//
//        if kind == UICollectionElementKindSectionHeader {
//
//            if sellerDetail!.following {
//                header.FollowingBtn.setTitle("UnFollow", for: .normal)
//                isfollowing = true
//            }else {
//                header.FollowingBtn.setTitle("Follow", for: .normal)
//                isfollowing = false
//            }
//
//            header.FollowingBtn.addTarget(self, action: #selector(followButtontapped), for: .touchUpInside)
//
//
//            header.BlockBtn.addTarget(self, action: #selector(blockedButtontapped), for: .touchUpInside)
//
//
//            if sellerDetail!.blocked {
//                header.BlockBtn.setTitle("Un-block", for: .normal)
//                isblock = true
//                header.FollowingBtn.isEnabled = false
//                header.FollowingBtn.backgroundColor = UIColor.gray
//            }else {
//                header.BlockBtn.setTitle("Block", for: .normal)
//                isblock = false
//                header.FollowingBtn.isEnabled = true
//                header.FollowingBtn.backgroundColor = UIColor.black
//            }
//
//
//
////            if isfollowing {
////                 header.FollowingBtn.setTitle("UnFollow", for: .normal)
////            }else {
////                 header.FollowingBtn.setTitle("Follow", for: .normal)
////            }
//
//                    header.name.text = self.sellerDetail!.name
//                    header.productCount.text = self.sellerDetail!.productCount
//                    header.FollowerCount.text = self.sellerDetail!.followerCount
//                    header.FollowingCount.text = self.sellerDetail!.followingCount
//
//                    let downloader = SDWebImageDownloader.init()
//                    downloader.downloadImage(with: URL.init(string:  self.sellerDetail!.image), options: .highPriority, progress: nil) { (image_, data, error, success) in
//                        if let imagedownloded = image_ {
//                            header.sellerImage.image = imagedownloded
//                            header.sellerImage.isUserInteractionEnabled = true
//                            header.sellerImage.image = imagedownloded
//                        }
//                    }
//
//                    if self.sellerDetail!.avertagerating != 0 {
//                        if let Rating = self.sellerDetail?.avertagerating {
//                            print(Rating)
//                            header.cosmosViewRating.rating = Double(Rating)
//                            header.cosmosViewRating.isUserInteractionEnabled = false
//
//                        }
//
//                        // Osama Mansoori 3-June-2019
//                        if let totalrating = self.sellerDetail?.totalrating {
//                            header.totalAverageRating.text = "( Total Ratings : \(totalrating)  )"
//                        }
//                    }
//                    else {
//                        header.cosmosViewRating.rating = 0
//                        header.cosmosViewRating.isUserInteractionEnabled = false
//                        header.totalAverageRating.text = "Not rated yet"
//                    }
//
//
//
//
//    }
//        return header
//    }
    
    
    
    
    
    @objc func bidNowBtnTapped( _ sender : UIButton) {
        let tag = sender.tag
//        print(userProductArray[tag])
//        let selectedProduct = userProductArray
        let storyBoard_ = UIStoryboard.init(name: storyBoardNames.prodDetails , bundle: nil)
        let controller = storyBoard_.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
//            controller.productDetail = selectedProduct[tag]
        controller.flagWasPushedFromSellerProfile = true
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

protocol sellerProfileVCDelegate: class {
    func productTapped(_ product : ProductDetails )
}

extension SellerProfileVC {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "My Profile".localizableString(loc: LanguageChangeCode))
    }
}
extension SellerProfileVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sellerTableView.tag == 1 {
            return followingArr.count
        }else {
            return followerArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sellerTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserProfileTableViewCell
        if sellerTableView.tag == 1 {
            let followingInfo = followingArr[indexPath.row]
            cell.sellerNameLbl.text = followingInfo.Name
            cell.sellerImg.sd_setImage(with: URL(string: followingInfo.image), placeholderImage: UIImage(named:"emptyImage"))
            if followingInfo.averagerating != "" {
                cell.ratingControl.rating = Double(followingInfo.averagerating)!
            }
            else {
                cell.ratingControl.rating = 0
                cell.ratingLbl.text = "Not rated yet"
            }
            if followingInfo.totalratings != ""{
                cell.ratingLbl.text = "( Total ratings- \(followingInfo.totalratings)  )"
            }else{
                cell.ratingLbl.text = "( Not rated yet )"
            }
        }else {
            let follwersInfo = followerArr[indexPath.row]
            cell.sellerNameLbl.text = follwersInfo.name
            cell.sellerImg.sd_setImage(with: URL(string: follwersInfo.image), placeholderImage: UIImage(named:"emptyImage"))
            
            
            if follwersInfo.averagerating != 0 {
                if  follwersInfo.averagerating != 0 {
                    
                    cell.ratingControl.rating = follwersInfo.averagerating
                    
                }
                if  follwersInfo.totalratings != 0 {
                    cell.ratingLbl.text = "( Total ratings- \(follwersInfo.totalratings)  )"
                }
            }
            else {
                cell.ratingControl.rating = 0
                cell.ratingLbl.text = "Not rated yet"
            }
        }
        cell.cardview.applyShadowOnView(cornerRadius: 6)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("here is my code")
    if sellerTableView.tag == 1 {
      let followingInfo = followingArr[indexPath.row]
      userProfile(id: followingInfo.userID, index: indexPath.row, Arrayname: "following")
    }else{
      let follwersInfo = followerArr[indexPath.row]
      userProfile(id: follwersInfo.id, index: indexPath.row, Arrayname:"followers" )
      
    }
    
    
    
  }
  func userProfile(id:String,index:Int,Arrayname:String){

        MainApis.Seller_Detail_Api(buyer_uid: SessionManager.shared.userId, seller_uid: id) { (status, data, error) in
            
            if status {
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
//                self.responseStatus = true
                let message = data!["message"]
                let blocked = data!["blocked"].boolValue
                let following = data!["following"].boolValue
                let productCount = data!["productCount"].stringValue
                let followerCount = data!["followerCount"].stringValue
                let followingCount = data!["followingCount"].stringValue
                
                
                
                    let id = message["_id"].stringValue
                    let image = message["image"].stringValue
                    let totalrating = message["totalratings"].doubleValue
                    let averagerating = message["averagerating"].doubleValue
                    let name = message["name"].stringValue
                    let sellerdata = SellerDetailModel.init(blocked: blocked, following: following, id: id, image: image, totalrating: totalrating, averagerating: averagerating, name: name , productCount: productCount , followerCount: followerCount , followingCount: followingCount)
                    
                    
                    self.sellerDetail = sellerdata
                    
                   
    //                if (self.currentUserId == sellerdata.id) {
    //
    //                    let cancel = UIBarButtonItem.init(image:UIImage(named: "stepBack") , style:.plain, target: self, action: #selector(self.backBtnTap))
    //                    self.navigationItem.leftBarButtonItem = cancel
    //                    self.navigationItem.title = sellerdata.name
    //                }
                    
                
                
                let storyboard = UIStoryboard.init(name: "UserDetails", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
              if Arrayname == "followers"{
                
                controller.UserDetails = self.followerArr[index]
              }else{

                controller.UserFollowingDetails = self.followingArr[index]
              }
                
                controller.sellerDetail = self.sellerDetail
                controller.title = self.sellerDetail!.name
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            
        }
  }
    
    
}

