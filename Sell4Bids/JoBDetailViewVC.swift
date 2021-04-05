
//  JoBDetailViewVC.swift
//  Sell4Bids
//  Created by Admin on 14/03/2019.
//  Copyright © 2019 admin. All rights reserved.
import UIKit
import Kingfisher
import GoogleMaps
import GSKStretchyHeaderView
import AACarousel
import MobileCoreServices
import SocketIO
import SwiftyJSON
import Cosmos
import SDWebImage

class JoBDetailViewVC: UITableViewController,UICollectionViewDelegate , UICollectionViewDataSource , UITextFieldDelegate, GMSMapViewDelegate , UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    //MARK:- Properties
    @IBOutlet weak var crossNavigationBtn: UIButton!
    @IBOutlet weak var watchListConstraint: NSLayoutConstraint!
    @IBOutlet weak var AuctionandListingendedtxt: UILabel!
    @IBOutlet weak var WatchBtn: UIButton!
    @IBOutlet weak var EndlistingBtn: UIButton!
    @IBOutlet weak var ShareBtn: UIButton!
    @IBOutlet weak var ListedByYou: UILabel!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var cosmosRating: CosmosView!
    @IBOutlet weak var averageRatingUser: smallBold!
    @IBOutlet weak var UserProfileStackView: UIStackView!
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var Watchimg: UIImageView!
    @IBOutlet weak var shareimg: UIImageView!
    @IBOutlet weak var StartPrice: UILabel!
    @IBOutlet weak var CurrencyString_Label: UIImageView!
    @IBOutlet weak var Item_Title_txt: UILabel!
    @IBOutlet weak var itemTime: UILabel!
    @IBOutlet weak var Item_Category_txt: UILabel!
    @IBOutlet weak var Item_Description_lbl: UILabel!
    @IBOutlet weak var Item_City_lbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var benefitsTextLbl: UILabel!
    @IBOutlet weak var EmploymentTypeLbl: UILabel!
    @IBOutlet weak var experienceTextView: UILabel!
    @IBOutlet weak var payPeriodLbl: UILabel!
    @IBOutlet weak var Item_Map_View: GMSMapView!
    @IBOutlet weak var Days: UILabel!
    @IBOutlet weak var Minlbl: UILabel!
    @IBOutlet weak var secondslbl: UILabel!
    @IBOutlet weak var Hourslbl: UILabel!
    @IBOutlet weak var Daytxtlbl: UILabel!
    @IBOutlet weak var Hourtxtlbl: UILabel!
    @IBOutlet weak var Mintxtlbl: UILabel!
    @IBOutlet weak var Seclbltxt: UILabel!
    @IBOutlet weak var ViewApplication: UIButton!
    @IBOutlet weak var ShowItemBtn: UIButton!
    @IBOutlet weak var RelistItem: UIButton!
    @IBOutlet weak var AutomaticRelist: UIButton!
    @IBOutlet weak var TurboCharge: UIButton!
    @IBOutlet weak var MoveToSellerBtn: UIButton!
    @IBOutlet weak var RelistJobHeight: NSLayoutConstraint!
    @IBOutlet weak var EndlistBtn: NSLayoutConstraint!
    
    //MARK:- Variables
    var MainAPi = MainSell4BidsApi()
    var currenttime = Int64()
    var list1 = [String]()
    var selected_date = Int()
    var itemid = String()
    var productArray : productModelNew?
    var currentCountry : String?
    let Endlisting_Item = Bundle.main.loadNibNamed("EndlistingCustomView", owner: self, options: nil)?.first as! EndListingView
    let Endlisting_View = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    var EndlistReason = String()
    var ChatMessage = [ChatMessageList]()
    var TimerHeight = CGFloat()
    var AuctionandListingHeight = CGFloat()
    var UserDetail : SellerDetailModel?
    var Autorelist : Bool?
    var visibility : Bool?
    let Relist_Item = Bundle.main.loadNibNamed("DetailsRelistVC", owner: self, options: nil)?.first as! DetailsRelist_ViewC
    let Relist_Item_View = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    var itemId : String?
    var  sellerId : String?
    
    //MARK:- private Functions
   private func reloadData(){
        self.MainAPi.Item_Details(uid: SessionManager.shared.userId, country: "", seller_uid: self.sellerId ?? "", item_id: self.itemId ?? "") { (status, response, error) in
            if status {
                for message in response!["message"] {
                    
                    print(message)
                    let itemCategory = message.1["itemCategory"].stringValue
                    let jobApplied = response!["jobApplied"].boolValue
                    print("itemCategory_JobsDetails == \(itemCategory)")
                    
                    //Job Details Data
                    
                    let employmentType = message.1["employmentType"].stringValue
                    let autoReList = message.1["autoReList"].boolValue
                    let itemAuctionType = message.1["itemAuctionType"].stringValue
                    let old_images = message.1["old_images"]
                    let loc = message.1["loc"]
                    let coordinates = loc["coordinates"].array
                    var old_images_array = [String]()
                    
                    for oldimages in old_images {
                        
                        old_images_array.append(oldimages.1.stringValue)
                        
                    }
                    
                    let payPeriod = message.1["payPeriod"].stringValue
                    let state = message.1["state"].stringValue
                    let companyName = message.1["companyName"].stringValue
                    let startPrice = message.1["startPrice"].int64Value
                    let image = message.1["images_path"]
                    var imageArray = [String]()
                    
                    for img in image {
                        
                        imageArray.append(img.1.stringValue)
                        
                    }
                    
                    let acceptOffers = message.1["acceptOffers"].boolValue
                    let zipcode = message.1["zipcode"].stringValue
                    let quantity = message.1["quantity"].int64Value
                    let description = message.1["description"].stringValue
                    let startTime = message.1["startTime"].int64Value
                    let jobCategory = message.1["jobCategory"].stringValue
                    let chargeTime = message.1["chargeTime"].int64Value
                    let city = message.1["city"].stringValue
                    _ = message.1["ordering"].boolValue
                    
                    let benefits = message.1["benefits"]
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
                    }
                    
                    var latitude = Double()
                    var londtitude = Double()
                    var watch_uid = String()
                    var watch_token = String()
                    
                    latitude = coordinates![1].doubleValue
                    londtitude = coordinates![0].doubleValue
                    
                    let itemKey = message.1["itemKey"].stringValue
                    let companyDescription = message.1["companyDescription"].stringValue
                    let visibility = message.1["visibility"].boolValue
                    let condition = message.1["condition"].stringValue
                    let uid = message.1["uid"].stringValue
                    let country_code = message.1["country_code"].stringValue
                    let id = message.1["_id"].stringValue
                    let timeRemaining = message.1["timeRemaining"].int64Value
                    let conditionValue = message.1["conditionValue"].intValue
                    let endTime = message.1["endTime"].int64Value
                    let token = message.1["token"].stringValue
                    let title = message.1["title"].stringValue
                    let experience = message.1["jobExperience"].stringValue
                    let userName = message.1["name"].stringValue
                    let watching = message.1["watching"]
                    
                    for watch in watching {
                        
                        let watch_uidvalue = watch.1["uid"].stringValue
                        
                        let watch_tokenvalue = watch.1["token"].stringValue
                        
                        watch_uid = watch_uidvalue
                        
                        watch_token = watch_tokenvalue
                        
                    }
                    let currency_string = message.1["currency_string"].stringValue
                    let currency_symbol = message.1["currency_string"].stringValue
                    let admin_verify = message.1["admin_verify"].stringValue
                    
                    
                    let jobdetails = JobDetails.init(employmentType: employmentType, autoReList: autoReList, itemAuctionType: itemAuctionType, old_images: old_images_array, payPeriod: payPeriod, state: state, companyName: companyName, startPrice: startPrice, image: imageArray, acceptOffers: acceptOffers, zipcode: zipcode, quantity: quantity, description: description, startTime: startTime, jobCategory: jobCategory, chargeTime: chargeTime, city: city, latitude: latitude, longtitude: londtitude, itemKey: itemKey, companyDescription: companyDescription, visibility: visibility, condition: condition, uid: uid, country_code: country_code, id: id, timeRemaining: timeRemaining, conditionValue: conditionValue, endTime: endTime, token: token, itemCategory: itemCategory, title: title , medical: medical , PTO: PTO , FZOK: FZOK, Experience: experience, userName: userName, watchBool: true, watch_uid: watch_uid, watch_token: watch_token , jobApplied: jobApplied , currency_string: currency_string , currency_symbol: currency_symbol , admin_verify: admin_verify)
                    self.selectedProduct_Job = jobdetails
                    self.selectedProduct_Job!.startPrice = jobdetails.startPrice
                    self.showDataOnItem()
                }
            }
            if error.contains("The network connection was lost"){
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            if error.contains("The Internet connection appears to be offline.") {
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            if error.contains("A server with the specified hostname could not be found."){
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            if error.contains("The request timed out.") {
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func Get_time(){
        MainAPi.ServerTime { (status, data, error) in
            if status {
                self.currenttime = data!["time"].int64Value
            }
        }
    }
    
    private func GetUserDetails(uid : String)  {
        MainAPi.Seller_Detail_Api(buyer_uid: SessionManager.shared.userId, seller_uid: uid) { (status, data, error) in
            self.MoveToSellerBtn.isEnabled = false
            if status {
                let message = data!["message"]
                let totalratings = message["totalratings"].doubleValue
                let averagerating = message["averagerating"].doubleValue
                let name = message["name"].stringValue
                let image = message["image"].stringValue
                let id = message["_id"].stringValue
                let blocked = data!["blocked"].boolValue
                let following = data!["following"].boolValue
                self.MoveToSellerBtn.isEnabled = true
                let userdata = SellerDetailModel.init(blocked: blocked, following: following, id: id, image: image, totalrating: totalratings, averagerating: averagerating, name: name, productCount: "0", followerCount: "0", followingCount: "0")
                self.UserImage.makeCornersRound()
                self.UserDetail = userdata
                DispatchQueue.main.async {
                    self.UserName.text = self.UserDetail!.name
                    self.cosmosRating.rating = self.UserDetail!.totalrating
                    self.cosmosRating.isUserInteractionEnabled = false
                    let downloader = SDWebImageDownloader.init()
                    downloader.downloadImage(with: URL.init(string: self.UserDetail!.image), options: .highPriority, progress: nil) { (image_, data, error, success) in
                        if let imagedownloded = image_ {
                            self.UserImage.image = imagedownloded
                            self.UserImage.isUserInteractionEnabled = true
                            self.UserImage.image = imagedownloded
                        }
                        let averageratings = Double(round(1000*self.UserDetail!.avertagerating)/1000)
                        self.averageRatingUser.text = "Total Rating : \(averageratings)"
                    }
                }
            }else{
                self.MoveToSellerBtn.isEnabled = false
            }
        }
    }
    
   
    
    
    //MARK:- Actions
    
    @objc func cancel_Endlisting() {
        Endlisting_View.dismiss(animated: true, completion: nil)
    }
    
    @objc func radiobtnfun1() {
        Endlisting_Item.RadioImg1.image = UIImage(named: "radioOn")
        Endlisting_Item.RadioImg2.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg3.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg4.image = UIImage(named : "radioOff")
        Endlisting_Item.RadioImg5.image = UIImage(named : "radioOff")
        Endlisting_Item.RadioImg6.image = UIImage(named : "radioOff")
        EndlistReason = Endlisting_Item.Optiontext1.text!
    }
    
    @objc func radiobtnfun2() {
        Endlisting_Item.RadioImg1.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg2.image = UIImage(named: "radioOn")
        Endlisting_Item.RadioImg3.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg4.image = UIImage(named : "radioOff")
        Endlisting_Item.RadioImg5.image = UIImage(named : "radioOff")
        Endlisting_Item.RadioImg6.image = UIImage(named : "radioOff")
        EndlistReason = Endlisting_Item.Optiontext2.text!
    }
    
    @objc func radiobtnfun3() {
        Endlisting_Item.RadioImg1.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg2.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg3.image = UIImage(named: "radioOn")
        Endlisting_Item.RadioImg4.image = UIImage(named : "radioOff")
        Endlisting_Item.RadioImg5.image = UIImage(named : "radioOff")
        Endlisting_Item.RadioImg6.image = UIImage(named : "radioOff")
        EndlistReason = Endlisting_Item.Optiontext3.text!
    }
    
    @objc func radiobtnfun4() {
        Endlisting_Item.RadioImg1.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg2.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg3.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg4.image = UIImage(named : "radioOn")
        Endlisting_Item.RadioImg5.image = UIImage(named : "radioOff")
        Endlisting_Item.RadioImg6.image = UIImage(named : "radioOff")
        EndlistReason = Endlisting_Item.OptionIext4.text!
    }
    
    @objc func radiobtnfun5() {
        Endlisting_Item.RadioImg1.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg2.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg3.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg4.image = UIImage(named : "radioOff")
        Endlisting_Item.RadioImg5.image = UIImage(named : "radioOn")
        Endlisting_Item.RadioImg6.image = UIImage(named : "radioOff")
        EndlistReason = Endlisting_Item.Optiontext5.text!
    }
    
    @objc func radiobtnfun6() {
        Endlisting_Item.RadioImg1.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg2.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg3.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg4.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg5.image = UIImage(named: "radioOff")
        Endlisting_Item.RadioImg6.image = UIImage(named: "radioOn")
        EndlistReason = Endlisting_Item.Optiontext6.text!
    }
    
    @objc func endlisting_api() {
        MainAPi.End_Listing(reason: EndlistReason, item_id: selectedProduct_Job!.id) { (status, swiftdata, error) in
            if status {
                _ = SweetAlert().showAlert("End Listing", subTitle: "Buyers will not be able to send you orders or offers. Are you sure to end listing for this Job? ", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                    if(status == true) {
                        self.selectedProduct_Job!.endTime = -1
                        self.EndlistingBtn.isHidden = true
                        self.EndlistBtn.constant = 0
                        self.RelistItem.isHidden = false
                        self.RelistJobHeight.constant = 50
                        self.Endlisting_View.dismiss(animated: true, completion: nil)
                        _ = SweetAlert().showAlert("End Listing", subTitle: "Job listing has been ended successfully. You can re-list Job anytime.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    }
                }
            }
        }
    }
    
    @IBAction func EndListingAction(_ sender: Any) {
        Endlisting_View.view.frame = Endlisting_Item.frame
        Endlisting_Item.addShadowAndRound()
        Endlisting_View.view.addSubview(Endlisting_Item)
        Endlisting_Item.CancelBtn.addShadowAndRound()
        Endlisting_Item.addShadowAndRound()
        Endlisting_Item.SubmitBtn.addShadowAndRound()
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
        
        Endlisting_Item.RadioImg1.addGestureRecognizer(radiobtn1)
        Endlisting_Item.RadioImg2.addGestureRecognizer(radiobtn2)
        Endlisting_Item.RadioImg3.addGestureRecognizer(radiobtn3)
        Endlisting_Item.RadioImg4.addGestureRecognizer(radiobtn4)
        Endlisting_Item.RadioImg5.addGestureRecognizer(radiobtn5)
        Endlisting_Item.RadioImg6.addGestureRecognizer(radiobtn6)
        
        Endlisting_Item.RadioImg1.isUserInteractionEnabled = true
        Endlisting_Item.RadioImg2.isUserInteractionEnabled = true
        Endlisting_Item.RadioImg3.isUserInteractionEnabled = true
        Endlisting_Item.RadioImg4.isUserInteractionEnabled = true
        Endlisting_Item.RadioImg5.isUserInteractionEnabled = true
        Endlisting_Item.RadioImg6.isUserInteractionEnabled = true
        
        Endlisting_Item.RadioImg1.tag = 1
        Endlisting_Item.RadioImg2.tag = 2
        Endlisting_Item.RadioImg3.tag = 3
        Endlisting_Item.RadioImg4.tag = 4
        Endlisting_Item.RadioImg5.tag = 5
        Endlisting_Item.RadioImg6.tag = 6
        
        Endlisting_Item.SubmitBtn.addTarget(self, action: #selector(endlisting_api), for: .touchUpInside)
        Endlisting_Item.CancelBtn.addTarget(self, action: #selector(cancel_Endlisting), for: .touchUpInside)
        self.present(Endlisting_View, animated: true, completion: nil)
    }
    
    @objc func shareaction(){
        let textToShare = "Check out this item that i found on The Sell4Bids Marketplace.".localizableString(loc: LanguageChangeCode)
        let cat = selectedProduct_Job!.itemCategory
        guard let catEncoded = cat.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        var urlString = "https://www.sell4bids.com/item?cat=\(catEncoded)"
        urlString.append("&auction=(auction)")
        urlString.append("&state=(state)")
        urlString.append("&pid=(prodId)")
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
    
    @objc func WatchingFunc() {
        if self.WatchBtn.titleLabel!.text == "Remove from Watch List" {
            MainAPi.UnWatch_Item(uid: SessionManager.shared.userId, itemid: selectedProduct_Job!.id) { (status, data, error) in
                if status {
                    self.WatchBtn.setTitle("Add to Watch List", for: .normal)
                    self.WatchBtn.setImage(UIImage(named: "ic_watch"), for: .normal)
                    self.Watchimg.image = UIImage(named: "ic_watch")
                    showSwiftMessageWithParams(theme: .info, title: "Remove Watched" , body: "You have succesfully remove Job from watch list")
                }else {
                    showSwiftMessageWithParams(theme: .info, title: "ERROR".localizableString(loc: LanguageChangeCode) , body: "Some Thing is Wrong")
                }
            }
        }
        else {
            MainAPi.Watch_Item(uid: SessionManager.shared.userId, itemid: selectedProduct_Job!.id) { (status, data, error) in
                print("Add to Watchlist")
                if status {
                    self.WatchBtn.setTitle("Remove from Watch List", for: .normal)
                    self.WatchBtn.setImage(UIImage(named: "ic_unwatch"), for: .normal)
                    self.Watchimg.image = UIImage(named: "ic_unwatch")
                    showSwiftMessageWithParams(theme: .info, title: "Add Watched" , body: "You have succesfully Add Job from watch list")
                }else {
                    showSwiftMessageWithParams(theme: .info, title: "ERROR".localizableString(loc: LanguageChangeCode) , body: "Some Thing is Wrong")
                }
            }
        }
    }
    
    @IBAction func WatchBtnAction(_ sender: Any) {
        if self.WatchBtn.titleLabel!.text == "Remove from Watch List" {
            MainAPi.UnWatch_Item(uid: SessionManager.shared.userId, itemid: selectedProduct_Job!.id) { (status, data, error) in
                if status {
                    self.WatchBtn.setTitle("Add to Watch List", for: .normal)
                    self.WatchBtn.setImage(UIImage(named: "ic_watch"), for: .normal)
                    self.Watchimg.image = UIImage(named: "ic_watch")
                    _ = SweetAlert().showAlert("Un-watch", subTitle: "Job has been removed from watch-list successfully.", style: .success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                }else {
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle: "Some Thing is Wrong", style: .error ,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                }
            }
        }else {
            
            MainAPi.Watch_Item(uid: SessionManager.shared.userId, itemid: selectedProduct_Job!.id) { (status, data, error) in
                if status {
                    self.WatchBtn.setTitle("Remove from Watch List", for: .normal)
                    self.WatchBtn.setImage(UIImage(named: "ic_unwatch"), for: .normal)
                    self.Watchimg.image = UIImage(named: "ic_unwatch")
                    _ = SweetAlert().showAlert("Watch-List", subTitle: "Job has been added to watch-list successfully.", style: .success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                }else {
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle: "Some Thing is Wrong", style: .error ,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                }
            }
        }
    }
    
    @objc func ChatWithSeller() {
        MainAPi.Get_Chat(buyer_uid: SessionManager.shared.userId, item_id: selectedProduct_Job!.itemKey, start: 0, limit: 15) { (status, data, error) in
            if status {
                let message = data!["message"]
                if message.stringValue.contains("No chat available") {
                }else {
                    for msg in message {
                        let read = msg.1["read"].boolValue
                        let delivered_time = msg.1["delivered_time"].int64Value
                        let created_at = msg.1["created_at"].int64Value
                        let buyer_uid = msg.1["buyer_uid"].stringValue
                        let message = msg.1["message"].stringValue
                        let itemCategory = msg.1["itemCategory"].stringValue
                        let sender_uid = msg.1["sender_uid"].stringValue
                        let item_id = msg.1["item_id"].stringValue
                        let item_price = msg.1["item_price"].intValue
                        let sender = msg.1["sender"].stringValue
                        let itemAuctionType = msg.1["itemAuctionType"].stringValue
                        let receiver_uid = msg.1["receiver_uid"].stringValue
                        let images_small_path = msg.1["images_small_path"].stringValue
                        let delivered = msg.1["delivered"].boolValue
                        let seller_uid = msg.1["seller_uid"].stringValue
                        let id = msg.1["_id"].stringValue
                        let images_path = msg.1["images_path"].stringValue
                        let title = msg.1["title"].stringValue
                        let receiver = msg.1["receiver"].stringValue
                        let role = msg.1["role"].stringValue
                        if receiver_uid == SessionManager.shared.userId && read == false {
                            
                            socket?.emit("read", ["item_id" : item_id , "receiver_uid" : receiver_uid , "delivered_time" : delivered_time , "sender_uid" : sender_uid] )
                            
                        }
                        
                        let msgdata = ChatMessageList.init(read: read, delivered_time: delivered_time, created_at: created_at, buyer_uid: buyer_uid, message: message, itemCategory: itemCategory, sender_uid: sender_uid, item_id: item_id, item_price: item_price, sender: sender, itemAuctionType: itemAuctionType, receiver_uid: receiver_uid, images_small_path: images_small_path, delivered: delivered, seller_uid: seller_uid, id: id, images_path: images_path, title: title, receiver: receiver, role: role, iserror: false)
                        self.ChatMessage.append(msgdata)
                    }
                    let storyboard = UIStoryboard.init(name: "chat", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogVC
                    controller.ChatMesssage = self.ChatMessage
                    controller.movetochat = true
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }else {
                let msgnewdata = ChatMessageList.init(read: false, delivered_time: 0, created_at: 0, buyer_uid: SessionManager.shared.userId, message: "", itemCategory: self.selectedProduct_Job!.itemCategory, sender_uid: SessionManager.shared.userId, item_id: self.selectedProduct_Job!.id, item_price: Int(self.selectedProduct_Job!.startPrice), sender: SessionManager.shared.name, itemAuctionType: self.selectedProduct_Job!.itemAuctionType, receiver_uid: self.selectedProduct_Job!.uid, images_small_path: self.selectedProduct_Job!.image.last!, delivered: false, seller_uid: self.selectedProduct_Job!.uid, id: self.selectedProduct_Job!.id, images_path: self.selectedProduct_Job!.image.last!, title: self.selectedProduct_Job!.title, receiver: self.UserName.text!, role: "buyer", iserror: false)
                self.ChatMessage.append(msgnewdata)
                let storyboard = UIStoryboard.init(name: "chat", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogVC
                controller.ChatMesssage = self.ChatMessage
                controller.movetochat = true
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    
    @IBAction func MoveToUserDetail(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "UserDetails", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
        controller.sellerDetail = self.UserDetail
        controller.title = self.UserDetail?.name ?? "Sell4Bid User"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
 
    @objc func Close_Relist_item() {
        Relist_Item_View.dismiss(animated: true, completion: nil)
    }
    
    @objc func Relist_Item_Api_Call () {
        if (Relist_Item.AmountPerItemtxt.text!.isEmpty){
            _ = SweetAlert().showAlert("Invalid Price", subTitle: "Please enter a valid price to continue.", style: AlertStyle.error,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            return
        }
        if (Relist_Item.Quantitytxt.text!.isEmpty){
            _ = SweetAlert().showAlert("Invalid Quantity", subTitle: "Please enter a valid quantity to continue.", style: AlertStyle.error,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            return
        }
        if (!Relist_Item.AmountPerItemtxt.text!.isEmpty){
            let price : Int = Int(Relist_Item.AmountPerItemtxt.text!)!
            if (!Relist_Item.AmountPerItemtxt.text!.isEmpty) {
                if price <= 0 {
                    _ = SweetAlert().showAlert("Invalid Price", subTitle: "Please enter valid price more then 0.", style: AlertStyle.error,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    return
                }else{
                    
                    MainAPi.Relist_Item(country: gpscountry, startPrice: price, endTime: selected_date, item_id: selectedProduct_Job!.id, itemCategory: selectedProduct_Job!.itemCategory){ (status, swiftdata, error) in
                        if status {
                            
                            _ = SweetAlert().showAlert("Item Re-listing", subTitle: "Do you to re-list this Item?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                                
                                if(status == true){
                                    self.EndlistingBtn.isHidden = false
                                    self.EndlistBtn.constant = 50
                                    self.Relist_Item_View.dismiss(animated: true, completion: nil)
                                    self.RelistItem.isHidden = true
                                    self.RelistJobHeight.constant = 0
                                    self.reloadData()
                                    self.tableView.reloadData()
                                    _ = SweetAlert().showAlert("Item Re-listing", subTitle: "Item has been re-listed successfully.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                                }
                            }
                        }else {
                            _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle: swiftdata!["message"].stringValue, style: .success)
                        }
                        if error.contains("The network connection was lost"){
                            _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle: swiftdata!["message"].stringValue, style: .success)
                        }
                        if error.contains("The network connection was lost"){
                            _ = SweetAlert().showAlert("Item Re-listing", subTitle: "Item has not re-listed due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            _ = SweetAlert().showAlert("Item Re-listing", subTitle: "Item has not re-listed due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        }
                        if error.contains("The Internet connection appears to be offline.") {
                            _ = SweetAlert().showAlert("Item Re-listing", subTitle: "Item has not re-listed due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        }
                        if error.contains("A server with the specified hostname could not be found."){
                            _ = SweetAlert().showAlert("Item Re-listing", subTitle: "Item has not re-listed due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        }
                        if error.contains("The request timed out.") {
                            _ = SweetAlert().showAlert("Item Re-listing", subTitle: "Item has not re-listed due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    @IBAction func Relist_Item(_ sender: Any) {
        
        
        
        Relist_Item_View.view.frame = Relist_Item.frame
        
        Relist_Item.CloseBtn.addTarget(self, action: #selector(Close_Relist_item), for: .touchUpInside)
        
        Relist_Item.SendOfferBtn.addTarget(self, action: #selector(Relist_Item_Api_Call), for: .touchUpInside)
        
        Relist_Item.Header0_Title.text = "Salary"
        
        Relist_Item.AmountPerItemtxt.placeholder = "Salary"
        
        Relist_Item.Header1_Title.text = "Listing Duration"
        
        Relist_Item.DollarSign.text = "$"
        
        Relist_Item.SendOfferBtn.setTitle("Re-List Job", for: .normal)
        
        Relist_Item.Quantitytxt.placeholder = "3 Days"
        
        ChangeBtnStyle(Button: Relist_Item.SendOfferBtn)
        
        Relist_Item_View.view.addSubview(Relist_Item)
        
        
        
        self.present(Relist_Item_View, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    
    
    
    @IBAction func View_Applications_Item(_ sender: Any) {
        let vc = UIStoryboard.init(name: "JobDetail", bundle: nil).instantiateViewController(withIdentifier: "JobDetailSegmentControl_Identifier") as! JobDetailSegmentControl
        vc.itemId = selectedProduct_Job!.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //item turbo charged
    
    @IBAction func Turbo_Charge_Item(_ sender: Any) {
        
        
        
        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Job will be shown first to new users. Do you want to turbo charge the Job?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
            
            
            
            if status == true {
                
                self.MainAPi.Item_TurboCharge(country: gpscountry, item_id: self.selectedProduct_Job!.id) { (status, data, error) in
                    
                    
                    
                    if error.contains("The network connection was lost"){
                        
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Vehicle has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    if error.contains("The Internet connection appears to be offline.") {
                        
                        
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Job has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                        
                        
                    }
                    
                    
                    
                    if error.contains("A server with the specified hostname could not be found."){
                        
                        
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Job has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                    }
                    
                    
                    
                    if error.contains("The request timed out.") {
                        
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Job has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                        
                        
                    }
                    
                    
                    
                }
                
                _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Job has been turbo charged successfully.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                
                
                
            }
            
            
            
        }
        
    }
    
    
    
    
    
    
    
    //Show_Item_Hide
    
    @IBAction func Show_Item_Hide_Item(_ sender: Any) {
        
        if ShowItemBtn.titleLabel!.text == "Hide Job" {
            
            visibility = false
            
            
            
            _ = SweetAlert().showAlert("Job Visibility", subTitle: "Item will not be visible to buyers. Do you want to hide the Job?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status == true){
                    
                    self.MainAPi.Hide_Show_Item(country: gpscountry, visibility: self.visibility!, item_id: self.selectedProduct_Job!.id) { (status, data, error) in
                        
                        
                        
                        
                        
                        if status {
                            
                            if self.visibility == true {
                                
                                self.ShowItemBtn.setTitle("Hide Job", for: .normal)
                                
                                self.ShowItemBtn.backgroundColor = UIColor.white
                                
                                self.ShowItemBtn.setTitleColor(UIColor.black, for: .normal)
                                
                                self.reloadData()
                                
                                
                                
                            }else {
                                self.ShowItemBtn.setTitle("Show Job", for: .normal)
                                
                                self.ShowItemBtn.backgroundColor = UIColor.black
                                
                                self.ShowItemBtn.setTitleColor(UIColor.white, for: .normal)
                                
                                self.reloadData()
                                
                            }
                            
                        }
                        
                        
                        
                        
                        
                        if error.contains("The network connection was lost"){
                            
                            
                            
                            _ = SweetAlert().showAlert("Job Visibility", subTitle: "Job visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            _ = SweetAlert().showAlert("Job Visibility", subTitle: "Job has not been disabled due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            
                            
                            _ = SweetAlert().showAlert("Job Visibility", subTitle: "Job has not been disabled due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                        }
                        
                        
                        
                        if error.contains("The request timed out.") {
                            
                            
                            
                            _ = SweetAlert().showAlert("Vehicle Visibility", subTitle: "Vehicle has not been disabled due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                        }
                        
                        
                        
                    }
                    _ = SweetAlert().showAlert("Job Visibility", subTitle: " Job has been disabled successfully. You can un-hide the item anytime.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
                
                
                
            }
            
            
            
            
            
        }
        else if ShowItemBtn.titleLabel!.text == "Show Job" {
            
            visibility = true
            
            
            
            _ = SweetAlert().showAlert("Job Visibility", subTitle: "Job will be visible to new buyers. Do you want to un-hide the Job?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status == true){
                    
                    print("check")
                    
                    self.MainAPi.Hide_Show_Item(country: gpscountry, visibility: self.visibility!, item_id: self.selectedProduct_Job!.id) { (status, data, error) in
                        
                        
                        
                        
                        
                        if status {
                            
                            if self.visibility == false {
       
                                self.ShowItemBtn.setTitle("Show Job", for: .normal)
                                
                                self.ShowItemBtn.backgroundColor = UIColor.black
                                
                                self.ShowItemBtn.setTitleColor(UIColor.white, for: .normal)
                                
                                self.reloadData()
                                
                            }else {
                                self.ShowItemBtn.setTitle("Hide Job", for: .normal)
                                
                                self.ShowItemBtn.backgroundColor = UIColor.white
                                
                                self.ShowItemBtn.setTitleColor(UIColor.black, for: .normal)
                                
                                self.reloadData()
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        if error.contains("The network connection was lost"){
                            
                            
                            _ = SweetAlert().showAlert("Job Visibility", subTitle: "Job visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            
                            
                            _ = SweetAlert().showAlert("Vehicle Visibility", subTitle: "Vehicle visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                        }
                        
                        
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            
                            
                            _ = SweetAlert().showAlert("Job Visibility", subTitle: "Job visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                        }
                        
                        
                        
                        if error.contains("The request timed out.") {
                            
                            
                            _ = SweetAlert().showAlert("Job Visibility", subTitle: "Job visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    _ = SweetAlert().showAlert("Job Visibility", subTitle: "Succesfully updated. Job will be visible to buyers.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
                
            }
            
            
            
        }
        
    }
    
    
    
    
    
    
    
    //Item Autorelisting
    
    @IBAction func AutoRelisting_Item(_ sender: Any) {
        
        if self.AutomaticRelist.titleLabel?.text == "Stop Automatic Relisting" {
            
            self.Autorelist = false
            
            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Job will not be automatically re-listed for 03 more days after expiration. Do you want to disable automatic re-listing of the job?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status == true){
                    
                    
                    self.MainAPi.AutoRelist_Item(country: gpscountry, autoReList: self.Autorelist!, item_id: self.selectedProduct_Job!.id) { (status, data, error) in
                        
                        
                        
                        if status {
                            
                            if self.Autorelist == true {
                                
                                self.AutomaticRelist.setTitle("Stop Automatic Relisting", for: .normal)
                                
                                self.AutomaticRelist.backgroundColor = UIColor.white
                                
                                self.AutomaticRelist.setTitleColor(UIColor.black, for: .normal)
                                self.reloadData()
                                
                                
                            }else {
                                
                                self.AutomaticRelist.setTitle("Automatic Relisting", for: .normal)
                                
                                self.AutomaticRelist.backgroundColor = UIColor.black
                                
                                self.AutomaticRelist.setTitleColor(UIColor.white, for: .normal)
                                self.reloadData()
                            }
                            
                            
                        }
                        
                        if error.contains("The network connection was lost"){
                            
                            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing status has not been updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            
                            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing status has not been updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                        }
                        
                        
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            
                            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing status has not been updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        
                        
                        if error.contains("The request timed out.") {
                            
                            
                            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing status has not been updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing has been disabled for this job.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                    
                    
                }
                
                
                
            }
            
        }
            
        else if self.AutomaticRelist.titleLabel?.text == "Automatic Relisting"
        {
            
            Autorelist = true
            
            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Job will be automatically re-listed for 03 more days after expiration. Do you want automatic re-listing for the Job?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status==true){
                    
                    
                    
                    self.MainAPi.AutoRelist_Item(country: gpscountry, autoReList: self.Autorelist!, item_id: self.selectedProduct_Job!.id) { (status, data, error) in
                        
                        
                        
                        if status {
                            
                            if self.Autorelist == false {
                                
                                self.AutomaticRelist.setTitle("Automatic Relisting", for: .normal)
                                
                                self.AutomaticRelist.backgroundColor = UIColor.black
                                
                                self.AutomaticRelist.setTitleColor(UIColor.white, for: .normal)
                                
                                self.reloadData()
                                
                            }else {
                                
                                self.AutomaticRelist.setTitle("Stop Automatic Relisting", for: .normal)
                                
                                self.AutomaticRelist.backgroundColor = UIColor.white
                                
                                self.AutomaticRelist.setTitleColor(UIColor.black, for: .normal)
                                
                                self.reloadData()
                                
                            }
                            
                            
                        }
                        
                        if error.contains("The network connection was lost"){
                            
                            
                            
                            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing status has not been updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            
                            
                            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing status has not been updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                        }
                        
                        
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            
                            
                            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing status has not been updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        
                        
                        if error.contains("The request timed out.") {
                            
                            
                            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing status has not been updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing has been enabled for this job. Job will be re-listed for 03 days on expiration.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                }
                
            }
            
            
            
        }
        
    }
    
    
    
    @IBAction func ShareProduct(_ sender: Any) {
        
        let textToShare = "Check out this item that i found on The Sell4Bids Marketplace.".localizableString(loc: LanguageChangeCode)
        
        let cat = selectedProduct_Job!.itemCategory
        
        let auction = selectedProduct_Job!.itemAuctionType
        
        let state =  selectedProduct_Job!.state
        
        let prodId = selectedProduct_Job!.id
        
        
        
        
        
        
        
        guard let catEncoded = cat.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            
            return
            
        }
        
        var urlString = "https://www.sell4bids.com/item?cat=\(catEncoded)"
        
        urlString.append("&auction=(auction)")
        
        urlString.append("&state=(state)")
        
        urlString.append("&pid=(prodId)")
        
        
        
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
    
    
    
    var Report_Item : Bool?
    
    let Report_Item_View = Bundle.main.loadNibNamed("ReportItemCustomView", owner: self, options: nil)?.first as! ReportItemView
    
    
    
    let Report_Alert_View = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    var ReportItemTxt = String()
    
    
    
    
    
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
    
    
    @IBOutlet weak var ReportItem: UIButton!
    
    @objc func Submit_Btn_Report() {
        
        if ReportItemTxt == ""{
                           _ = SweetAlert().showAlert("Report Item", subTitle: "please Selet a reason" , style: .error)
        }else{

          MainAPi.Report_Item(uid: SessionManager.shared.userId , report: ReportItemTxt, item_id: selectedProduct_Job!.itemKey, seller_uid: selectedProduct_Job!.uid) { (status, data, error) in
              
              
              if status {
                  
                  _ = SweetAlert().showAlert("Report Item", subTitle: data!["message"].stringValue, style: .success)
                  
                  self.Report_Alert_View.dismiss(animated: true, completion: nil)
                  
              }else {
                  
                  _ = SweetAlert().showAlert("Report Item", subTitle: "\(error)", style: .error)
                  
              }
              
              
              
          }
      }
        
        
    }
    
    
    
    @IBAction func Report_Item(_ sender: Any) {
        
        
        
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
    
    
    
    
    
    
    
    func ChangeBtnStyle(Button : UIButton) {
        
        
        
        Button.addShadowAndRoundNew()
        
        
        
    }
    
    
    
    let testVC = UITableViewController(style: .grouped)
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("Item Image == \(itemimg.count)")
        
        if collectionView.tag == 0 {
            
            return selectedProduct_Job?.image.count ?? 0
            
        }else {
            
            return selectedProduct_Job?.image.count ?? 0
            
        }
        
        
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if collectionView.tag == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCell", for: indexPath) as! ItemImgSliderCell
            
            
            
            let urlStr = selectedProduct_Job?.image[indexPath.item] ?? ""
            
            print("url == \(urlStr)")
            
            
            
            cell.ItemImage.sd_setImage(with: URL(string: urlStr), placeholderImage:  UIImage(named: "emptyImage") )
            
            
            
            
            
            return cell
            
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideritemImage", for: indexPath) as! Items_Detail_Sliders_Cell
            
            
            
            
            
            let urlStr = selectedProduct_Job?.image[indexPath.item] ?? ""
            
            print("url == \(urlStr)")
            
            
            
            
            
            cell.ItemSliderImages.sd_setImage(with: URL(string: urlStr), placeholderImage:  UIImage(named: "emptyImage") )
            
            
            
            
            
            return cell
            
        }
        
        
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewerPopUpVc")  as! ImageViewerPopUpVc
        
        
        
        controller.selectedIndex = indexPath
        
        print("controller.selectedIndex : \(controller.selectedIndex)")
        
        controller.view.backgroundColor = UIColor.white
        
        controller.imagesArray = selectedProduct_Job!.image
        
        
        
        
        
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        controller.modalTransitionStyle = .coverVertical
        
        self.present(controller, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    
    
    
    var cordinates = CLLocationCoordinate2D()
    
    var selectedProduct_Job : JobDetails?
    
    var ItemImages = [String]()
    
    
    
    var itemimg = [UIImage]()
    
    var Title = String()
    
    
    
    let viewButton  = Bundle.main.loadNibNamed("JobDetailCustomButton", owner: self, options: nil)?.first as! ButtonStacksJob
    
    let item_header = Bundle.main.loadNibNamed("Item_Header", owner: self, options: nil)?.first as! Item_Header
    
    let navigationbar = Bundle.main.loadNibNamed("Item_Navigation_barview", owner: self, options: nil)?.first as! Item_Navigation_barview
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationbar.removeFromSuperview()
        
        self.viewButton.removeFromSuperview()
        
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    @objc func Back_btn() {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.reloadData()
        
        self.navigationController?.navigationBar.isHidden = true
        viewButton.frame = CGRect.init(x: 0, y: self.view.frame.maxY - 60 , width: UIScreen.main.bounds.width, height: 60)
        viewButton.backgroundColor = UIColor.clear
        viewButton.addShadowView()
        self.navigationController?.view.addSubview(navigationbar)
        self.navigationController?.view.addSubview(viewButton)
       
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func updateTimer(currentTime: NSNumber?){
        
        var timer = Int64()
        var dif = Int64()
        
        timer = selectedProduct_Job!.endTime
        dif = timer - currenttime
        
        
        if timer == -1 {
            
            TimerHeight = 0
            AuctionandListingHeight = 0
            
            if selectedProduct_Job!.jobApplied == true {
                
                viewButton.Apply_Now_Btn.isEnabled = false
                viewButton.Apply_Now_Btn.backgroundColor = UIColor.gray
                viewButton.ChatWithSellerBtn.isEnabled = true
                viewButton.ChatWithSellerBtn.backgroundColor = UIColor.black
            }else{
                viewButton.Apply_Now_Btn.isEnabled = true
                viewButton.Apply_Now_Btn.backgroundColor = UIColor.black
                viewButton.ChatWithSellerBtn.isEnabled = true
                viewButton.ChatWithSellerBtn.backgroundColor = UIColor.black
            }
            
            
        }else{
            
            if dif <= 0 || dif == -1 {
                
                self.Days.isHidden = true
                
                self.Daytxtlbl.isHidden = true
                
                self.Hourtxtlbl.isHidden = true
                
                self.Hourslbl.isHidden = true
                
                self.Mintxtlbl.isHidden = true
                
                self.Minlbl.isHidden = true
                
                self.Seclbltxt.isHidden = true
                
                self.secondslbl.isHidden = true
                
                viewButton.Apply_Now_Btn.isEnabled = false
                viewButton.Apply_Now_Btn.backgroundColor = UIColor.gray
                
                TimerHeight = 0
                
                AuctionandListingHeight = 50
                
                if selectedProduct_Job!.itemAuctionType == "buy-it-now" {
                    
                    AuctionandListingendedtxt.text = "Listing Ended"
                    
                    AuctionandListingendedtxt.textColor = UIColor.red
                    
                }else {
                    
                    AuctionandListingendedtxt.text = "Auction Ended"
                    
                    AuctionandListingendedtxt.textColor = UIColor.red
                    
                }
                
            }else{
                
                AuctionandListingHeight = 0
                
                TimerHeight = 50
                
                viewButton.Apply_Now_Btn.isEnabled = true
                
                viewButton.Apply_Now_Btn.backgroundColor = UIColor.black
                
                self.Days.isHidden = false
                
                self.Daytxtlbl.isHidden = false
                
                self.Hourtxtlbl.isHidden = false
                
                self.Hourslbl.isHidden = false
                
                self.Mintxtlbl.isHidden = false
                
                self.Minlbl.isHidden = false
                
                self.Seclbltxt.isHidden = false
                
                self.secondslbl.isHidden = false
                
                //Convert EndTime Milliseconds to DateFormat
                
                
                
                
                
                
                
                
                
                //list indefinitely
                
                let endTimeInterval:TimeInterval = TimeInterval(selectedProduct_Job!.endTime )
                
                //Convert to Date
                
                let endDate = Date(timeIntervalSince1970: Double(endTimeInterval) / 1000)
                
                //Difference between servertime and endtime
                
                let calendar = NSCalendar.current as NSCalendar
                
                let unitFlags = NSCalendar.Unit([.day,.hour,.minute,.second])
                
                var components = calendar.components(unitFlags, from: Date(), to: endDate )
                
                //print("calender components: \(components)")
                
                if let days = components.day, let hours = components.hour, let minutes = components.minute, let secs = components.second {
                    
                    if days < 0 && hours < 0 && minutes < 0 && secs < 0 {
                        
                        //no time left to show
                        
                    }else {
                        
                        //some time left to show
                        
                        if days > 0 {
                            
                            self.Days.text = String(format: "%2i",days)
                            
                        }else {
                            
                            self.Days.text = String(format: "%2i", days)
                            
                        }
                        
                        if hours > 0{
                            
                            self.Hourslbl.text = String(format: "%2i",hours)
                            
                        }else {
                            
                            self.Hourslbl.text = String(format: "%2i",hours)
                            
                        }
                        
                        if minutes > 0 {
                            
                            self.Minlbl.text =  String(format: "%2i",minutes)
                            
                        }else {
                            
                            self.Minlbl.text =  String(format: "%2i",minutes)
                            
                        }
                        
                        if secs > 0 {
                            
                            self.secondslbl.text = String(format: "%2i",secs)
                            
                            
                            
                        }else {
                            
                            self.secondslbl.text = String(format: "%2i",secs)
                            
                        }
                        
                        if days <= 0 && hours <= 0 && minutes <= 0 && secs <= 0 {
                            
                            if SessionManager.shared.userId == selectedProduct_Job!.uid {
                                
                                self.EndlistingBtn.isHidden = true
                                
                                self.EndlistBtn.constant = 0
                                
                                self.RelistItem.isHidden = false
                                
                                self.RelistJobHeight.constant = 50
                                
                                if tableView.tag == 13 {
                                    
                                    tableView.estimatedRowHeight = 0
                                    
                                }
                                
                            }
                            
                            if selectedProduct_Job!.itemAuctionType == "reserve" || selectedProduct_Job!.itemAuctionType == "non-reserve" {
                                
                                viewButton.Apply_Now_Btn.isEnabled = false
                                
                                viewButton.Apply_Now_Btn.backgroundColor = UIColor.gray
                                
                                TimerHeight = 0
                                
                                AuctionandListingHeight = 50
                                
                            }else {
                                
                                viewButton.Apply_Now_Btn.isEnabled = false
                                
                                viewButton.Apply_Now_Btn.backgroundColor = UIColor.gray
                                
                                TimerHeight = 0
                                
                                AuctionandListingHeight = 50
                                
                            }
                            
                            tableView.reloadUsingDispatch()
                            
                        }else {
                            
                            if SessionManager.shared.userId == selectedProduct_Job!.uid {
                                
                                self.EndlistingBtn.isHidden = false
                                
                                self.EndlistBtn.constant = 50
                                
                                self.RelistItem.isHidden = true
                                
                                self.RelistJobHeight.constant = 0
                                
                                
                            }
                            
                        }
                        
                        self.Days.text = String(format: "%2i",days)
                        
                        self.Hourslbl.text = String(format: "%2i",hours)
                        
                        self.Minlbl.text =  String(format: "%2i",minutes)
                        
                        self.secondslbl.text = String(format: "%2i",secs)
                        
                        self.Daytxtlbl.text = days > 1  ? "Days" : " Day"
                        
                        self.Hourtxtlbl.text = hours > 1  ? "Hrs" : "Hr"
                        
                        self.Mintxtlbl.text = minutes > 1  ? "Mins" : "Min"
                        
                        self.Seclbltxt.text = secs > 1  ? "Secs" : "Sec"
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
    @objc func Apply_Now_Btn_Action(){
        viewButton.removeFromSuperview()
        let vc = UIStoryboard.init(name: "JobDetail", bundle: nil).instantiateViewController(withIdentifier: "ApplyForJobIdentifier") as! JobDetailApplyForJob
        vc.products_DetailsApply = selectedProduct_Job
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func MovetoHome() {
        navigationController!.popViewController(animated: true)
    }
    
    
    var timer:Timer?
    
    @objc func actionClose(sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func showDataOnItem() {
        CollectionView.reloadData()
        if (selectedProduct_Job?.admin_verify.contains("pending"))!{
                   
                   ViewApplication.isEnabled = false
                   viewButton.isHidden = true
                   shareimg.isUserInteractionEnabled = false
                   Watchimg.isUserInteractionEnabled = false
                   WatchBtn.isEnabled = false
                   ShareBtn.isEnabled = false
                   
               }
               if (selectedProduct_Job?.admin_verify.contains("rejected"))!{
                   
                   ViewApplication.isEnabled = false
                   viewButton.isHidden = true
                   shareimg.isUserInteractionEnabled = false
                   Watchimg.isUserInteractionEnabled = false
                   WatchBtn.isEnabled = false
                   ShareBtn.isEnabled = false
                   
               }
               
               
               Endlisting_Item.RadioImg6.image = UIImage(named: "radioOn")
               Report_Item_View.ReportImg6.image = UIImage(named: "radioOn")
               
               Endlisting_Item.topHeading.text = "Why you want to end Job listing?"
               Endlisting_Item.itemOutOfStock.constant = 0
               
               Relist_Item.AmountPerItemtxt.delegate = self
               
               list1 = ["3 Days","5 Days","7 Days","10 Days", "15 Days","21 Days","30 Days"]
               
               Relist_Item.Quantitytxt.delegate = self
               
               selectCreatePicker(textField: Relist_Item.Quantitytxt, tag: 1)
               
               createToolBar(textField: Relist_Item.Quantitytxt)
               
               viewButton.Apply_Now_Btn.addTarget(self, action: #selector(Apply_Now_Btn_Action), for: .touchUpInside)
               
               self.MoveToSellerBtn.isEnabled = false
               
               let sharebtn = UITapGestureRecognizer()
               
               sharebtn.addTarget(self, action: #selector(shareaction))
               
               shareimg.addGestureRecognizer(sharebtn)
               
               shareimg.isUserInteractionEnabled = true
               
               
               
               let userProfile = UITapGestureRecognizer()
               userProfile.addTarget(self, action: #selector(MoveToUserDetail))
               UserProfileStackView.addGestureRecognizer(userProfile)
               UserProfileStackView.isUserInteractionEnabled = true
               
               let watchimgGesture = UITapGestureRecognizer()
               watchimgGesture.addTarget(self, action: #selector(WatchingFunc))
               Watchimg.addGestureRecognizer(watchimgGesture)
               Watchimg.isUserInteractionEnabled = true
               
               
               
               print("User ID == \(SessionManager.shared.userId) , Item User ID = \(selectedProduct_Job?.uid ?? "0") , CompanyName == \(selectedProduct_Job?.companyName ?? "0") , Benefits == \(selectedProduct_Job?.medical ?? "0") , Job Toughness == \(selectedProduct_Job?.condition ?? "0") , ConditionValue == \(selectedProduct_Job?.conditionValue ?? 0) , EmploymentType == \(selectedProduct_Job?.employmentType ?? "0") , Description == \(selectedProduct_Job?.description ?? "0") , City == \(selectedProduct_Job?.city ?? "0") , PayPeriod == \(selectedProduct_Job?.payPeriod ?? "0") , ZipCode == \(selectedProduct_Job?.zipcode ?? "0") , JobExperience == \(selectedProduct_Job?.Experience ?? "0")")
               
               
               
               if selectedProduct_Job!.chargeTime != nil {
                   
                   //print("time  is not nil")
                   
                   let startTime:TimeInterval = Double(selectedProduct_Job!.chargeTime)
                   
                   let miliToDate = Date(timeIntervalSince1970:startTime/1000)
                   
                   let calender  = NSCalendar.current as NSCalendar
                   
                   let unitflags = NSCalendar.Unit([.day,.hour,.minute,.second])
                   
                   var diffDate = calender.components(unitflags, from:miliToDate, to: Date())
                   
                   if let days = diffDate.day, let hours = diffDate.hour, let minutes = diffDate.minute, let seconds = diffDate.second {
                       
                       if days > 1 {
                           
                           itemTime.text = "\(days) days ago."
                           
                       }
                           
                       else if  hours < 24 && hours > 1{
                           
                           
                           
                           itemTime.text = "\(hours) hours ago."
                           
                       }
                           
                       else if minutes < 60 && minutes > 1 {
                           
                           itemTime.text = "\(minutes) minutes ago."
                           
                       }
                           
                       else if seconds < 60 && seconds > 1{
                           
                           
                           
                           itemTime.text = "\(seconds) seconds ago."
                           
                       }
                       
                   }
                   
               }else {
                   
                   itemTime.text = "NA"
                   
                   print("time is nil")
                   
               }
               
               
               self.viewButton.ChatWithSellerBtn.addTarget(self, action: #selector(ChatWithSeller), for: .touchUpInside)
               navigationbar.ItemTitle.text = self.selectedProduct_Job!.title
               navigationbar.MovetoHome.addTarget(self, action: #selector(MovetoHome), for: .touchUpInside)
               navigationbar.HomeBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
               print("jobApplied == \(selectedProduct_Job!.jobApplied)")
               if selectedProduct_Job!.jobApplied == true {
                   
                   viewButton.Apply_Now_Btn.isEnabled = false
                   viewButton.Apply_Now_Btn.backgroundColor = UIColor.gray
                   viewButton.ChatWithSellerBtn.isEnabled = true
                   viewButton.ChatWithSellerBtn.backgroundColor = UIColor.black
               }else{
                   viewButton.Apply_Now_Btn.isEnabled = true
                   viewButton.Apply_Now_Btn.backgroundColor = UIColor.black
                   viewButton.ChatWithSellerBtn.isEnabled = true
                   viewButton.ChatWithSellerBtn.backgroundColor = UIColor.black
               }
               
               if selectedProduct_Job!.watchBool {
                   
                   self.WatchBtn.setTitle("Remove from Watch List", for: .normal)
                   
                   self.WatchBtn.setImage(UIImage(named: "ic_unwatch"), for: .normal)
                   
                   self.Watchimg.image = UIImage(named: "ic_unwatch")
                   
               }else {
                   
                   self.WatchBtn.setTitle("Add to Watch List", for: .normal)
                   
                   self.WatchBtn.setImage(UIImage(named: "ic_watch"), for: .normal)
                   
                   self.Watchimg.image = UIImage(named: "ic_watch")
                   
               }
               
              
               
               Get_time()
               
               updateTimer(currentTime: nil)
               
               DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                   
                   self.tableView.reloadUsingDispatch()
                   
               }
               
               self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(currentTime: )), userInfo: nil, repeats: true)
               
               print("User ID == \(SessionManager.shared.userId) , Item User ID =\(self.selectedProduct_Job!.uid)")
               
               GetUserDetails(uid: selectedProduct_Job!.uid)
               
               visibility = selectedProduct_Job!.visibility
               
               print("selectedProduct_Job = \(selectedProduct_Job!.itemAuctionType)")
               
               if visibility == true {
                   
                   ShowItemBtn.setTitle("Hide Job", for: .normal)
                   
                   ShowItemBtn.backgroundColor = UIColor.white
                   
                   ShowItemBtn.setTitleColor(UIColor.black, for: .normal)
                   
                   
                   
               }else {
                   
                   ShowItemBtn.setTitle("Show Job", for: .normal)
                   
                   ShowItemBtn.backgroundColor = UIColor.black
                   
                   ShowItemBtn.setTitleColor(UIColor.white, for: .normal)
                   
               }
               
               if selectedProduct_Job!.autoReList == true {
                   print("selectedProduct_Vehicles!.autoReList")
                   
                   
                   AutomaticRelist.setTitle("Stop Automatic Relisting", for: .normal)
                   
                   AutomaticRelist.backgroundColor = UIColor.white
                   
                   AutomaticRelist.setTitleColor(UIColor.black, for: .normal)
                   
                   
                   
               }else {
                   print("selectedProduct_Vehicles!.autoReList_1")
                   AutomaticRelist.setTitle("Automatic Relisting", for: .normal)
                   
                   AutomaticRelist.backgroundColor = UIColor.black
                   
                   AutomaticRelist.setTitleColor(UIColor.white, for: .normal)
                   
               }
        let country = selectedProduct_Job?.country_code.uppercased()
               print("ItemDetail_country == \(country!)")
               let Detail_Currency_Symbol = CurrencyManager.instance.getCurrencySymbol(Country: country ?? "USA")
               print("Detail_Currency_Symbol == \(Detail_Currency_Symbol)")
               StartPrice.text = "  " + Detail_Currency_Symbol + "" + (selectedProduct_Job?.startPrice.description)!
               print("StartPrice == \(StartPrice.text!)")
               Item_Title_txt.text = selectedProduct_Job?.title
               
               Item_Title_txt.text = selectedProduct_Job?.title
               
               Item_Category_txt.text = selectedProduct_Job?.itemCategory
               
               Item_Description_lbl.text = selectedProduct_Job!.description
               
               companyLbl.text = self.selectedProduct_Job?.companyName ?? ""
               
               EmploymentTypeLbl.text = selectedProduct_Job?.employmentType ?? ""
               
               experienceTextView.text
                   
                   = selectedProduct_Job?.Experience ?? ""
               
               payPeriodLbl.text = selectedProduct_Job?.payPeriod ?? ""
               
               
               var address = ""
               if (selectedProduct_Job?.city != nil) && !(selectedProduct_Job?.city == ""){
                   address += selectedProduct_Job!.city
               }
               if (selectedProduct_Job?.state != nil) && !(selectedProduct_Job?.state == ""){
                   address += ", " + selectedProduct_Job!.state
               }
               if (selectedProduct_Job?.zipcode != nil) && !(selectedProduct_Job?.zipcode == ""){
                   address += ", " + selectedProduct_Job!.zipcode
               }
               
               Item_City_lbl.text = ("\(address)")
               
               var Benefits = ""
               if (selectedProduct_Job?.medical != nil) && !(selectedProduct_Job?.medical == ""){
                   Benefits += selectedProduct_Job!.medical
               }
               if (selectedProduct_Job?.PTO != nil) && !(selectedProduct_Job?.PTO == ""){
                   Benefits += ", " + selectedProduct_Job!.PTO
               }
               if (selectedProduct_Job?.FZOK != nil) && !(selectedProduct_Job?.FZOK == ""){
                   Benefits += ", " + selectedProduct_Job!.FZOK
               }
               
               benefitsTextLbl.text = ("\(Benefits)")
               
               
               print("Longtitude == \(selectedProduct_Job!.longtitude)")
               
               print("Latitude == \(selectedProduct_Job!.latitude)")
               
               cordinates.latitude = selectedProduct_Job!.latitude
               
               cordinates.longitude = selectedProduct_Job!.longtitude
               
               print("item lat ==\(selectedProduct_Job!.latitude ), item long == \(selectedProduct_Job!.longtitude)")
               
               self.Item_Map_View.delegate = self
               
               self.Item_Map_View.isUserInteractionEnabled = false
               
               
               
               
               if SessionManager.shared.userId.contains(selectedProduct_Job!.uid) {
                   
                   Watchimg.isHidden = true
                   watchListConstraint.constant = 0
                   self.viewButton.isHidden = true
                   
               }else{
                   self.viewButton.isHidden = false
                   watchListConstraint.constant = 35
               }
               
               ItemImages = (self.selectedProduct_Job?.image)!
               
               Title = (self.selectedProduct_Job?.description)!
        if SessionManager.shared.userId.contains(self.selectedProduct_Job!.uid) {
                   
                   print("User ID Same")
                   
               }
               
               cordinates.latitude = selectedProduct_Job!.latitude
               cordinates.longitude = selectedProduct_Job!.longtitude
               print("item lat ==\(selectedProduct_Job!.latitude ), item long == \(selectedProduct_Job!.longtitude)")
               
               self.Item_Map_View.delegate = self
               var cirlce: GMSCircle!
               let  circleCenter = CLLocationCoordinate2D(latitude: cordinates.latitude, longitude: cordinates.longitude)
               
               cirlce = GMSCircle(position: circleCenter, radius: 500)
               cirlce.fillColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 250.0/255.0, alpha:1.0)
               //        cirlce.strokeColor = .blue
               //        cirlce.strokeWidth = 1
               cirlce.map = Item_Map_View
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StartPrice.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        StartPrice.layer.shadowRadius = 2.0
        StartPrice.layer.shadowOpacity = 1.0
        StartPrice.layer.shadowOffset = CGSize(width: 0, height: 1)
        StartPrice.layer.masksToBounds = false
        
        crossNavigationBtn.layer.cornerRadius = 15
        crossNavigationBtn.layer.masksToBounds = true
        crossNavigationBtn.addTarget(self, action: #selector(actionClose(sender:)), for: .touchUpInside)
        crossNavigationBtn.shadowView()
        
       
        
        socket?.on("notifications") {data, ack in
                   
                   print("Socket Item Details == \(data)")
                   
               }
        
        ChangeBtnStyle(Button: RelistItem)
        ChangeBtnStyle(Button: AutomaticRelist)
        ChangeBtnStyle(Button: TurboCharge)
        ChangeBtnStyle(Button: ShowItemBtn)
        ChangeBtnStyle(Button: ViewApplication)
        ChangeBtnStyle(Button: EndlistingBtn)
        
        navigationbar.BackBtn.addTarget(self, action: #selector(Back_btn), for: .touchUpInside)
        
        navigationbar.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.isHidden = true
        
        let imageView = UIImageView()
         let framYposition = UIDevice.isMedium ? 20 : 50
        navigationbar.frame = CGRect.init(x: 0, y: framYposition, width: Int(UIScreen.main.bounds.width), height: 50)
        
        viewButton.frame = CGRect.init(x: 0, y: self.view.frame.maxY - 60 , width: UIScreen.main.bounds.width, height: 60)
        viewButton.backgroundColor = UIColor.clear
        
        viewButton.addShadowView()
        
        self.navigationController?.view.addSubview(navigationbar)
        
        self.navigationController?.view.addSubview(viewButton)
        
        navigationController?.delegate = self
        
        self.tabBarController?.tabBar.isHidden = true
        
        let myButton: UIButton = UIButton.init(frame: CGRect(x: self.view.bounds.width - 66, y: self.view.bounds.height - 66, width: 200, height: 50))
        
        self.tabBarController?.view.addSubview(myButton)
        
        testVC.view.frame = CGRect(x: 0, y: 0, width: 400, height: 700)
        
        testVC.view.backgroundColor = .white
        
       
        
        
        
        if let layout = CollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            var itemHeight = CGFloat()
            
            let itemWidth = view.bounds.width
            
            if UIDevice.current.model.contains("iPhone") {
                
                itemHeight = 300
                
            }else if UIDevice.current.model.contains("iPad") {
                
                itemHeight = 900
                
            }
            
            
            
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            
            layout.invalidateLayout()
            
        }
        
        navigationbar.HomeBtn.addShadow()
        
        navigationbar.BackBtn.addShadow()
        
        navigationbar.MovetoHome.addShadow()
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        if SessionManager.shared.userId.contains(selectedProduct_Job?.uid ?? "") {
            
            print("indexPath == 1")
            
            if indexPath.section == 0 {
                
                if UIDevice.current.model.contains("iPhone") {
                    
                    return 350
                    
                }else if UIDevice.current.model.contains("iPad") {
                    
                    return 450
                    
                }
                
            }else if indexPath.section == 1 {
                
                return 0
                
            }else if indexPath.section == 2 {
                
                return TimerHeight
                
            }else if indexPath.section == 3 {
                
                return 50
                
            }else if indexPath.section == 4 {
                
                return AuctionandListingHeight
                
            }else if indexPath.section == 5 {
                
                if (selectedProduct_Job?.admin_verify.contains("pending")) ?? false{
                    ListedByYou.text = "This Job listing is pending for the approval from Admin."
                    return 50
                }
                else if (selectedProduct_Job?.admin_verify.contains("rejected")) ?? false{
                    ListedByYou.text = "This Job listing is rejected for the approval from Admin."
                    return 50
                }else{
                    ListedByYou.text = "Listed By You"
                    return 50
                }
                
            }else if indexPath.section == 6 {
                return tableView.rowHeight
                
                
            }else if indexPath.section == 7{
                return 100
               
                
            }else if indexPath.section == 8 {
                
                 return 0
                
            }else if indexPath.section == 9{
                
                return tableView.rowHeight
                
            }else if indexPath.section == 10 {
                
                return 50
                
            }else if indexPath.section == 11 {
                
                return 50
                
            }else if indexPath.section == 12 {
            
                return 50
                
            }else if indexPath.section == 13 {
                
                return 50
                
            }else if indexPath.section == 14 {
                
                let GMSCameraPos = GMSCameraPosition.init(latitude: cordinates.latitude, longitude: cordinates.longitude, zoom: 14)
                
                self.Item_Map_View.camera = GMSCameraPos
                
                return 300
                
            }else if indexPath.section == 15 {
                
                return 0
                
            }else if indexPath.section == 16 {
                
                return 50
                
            }else if indexPath.section == 17 {
                
                return 0
                
            }else {
                
                return 50
                
            }
            
        }
            
        else {
            
            print("indexPath == 1")
            
            if indexPath.section == 0 {
                
                if UIDevice.current.model.contains("iPhone") {
                    
                    return 350
                    
                }else if UIDevice.current.model.contains("iPad") {
                    
                    return 450
                    
                }
                
            }else if indexPath.section == 1 {
                
                return 0
                
            }else if indexPath.section == 2 {
                
                return TimerHeight
                
            }else if indexPath.section == 3 {
                
                return 0
                
            }else if indexPath.section == 4 {
                
                return AuctionandListingHeight
                
            }else if indexPath.section == 5 {
                
                if (selectedProduct_Job?.admin_verify.contains("pending")) ?? false{
                    ListedByYou.text = "This Job listing is pending for the approval from Admin."
                    return 50
                }
                else if (selectedProduct_Job?.admin_verify.contains("rejected")) ?? false{
                    ListedByYou.text = "This Job listing is rejected for the approval from Admin."
                    return 50
                }else{
                    ListedByYou.text = "Listed By You"
                    return 0
                }
                
            }else if indexPath.section == 6 {
                return tableView.rowHeight
               
                
            }else if indexPath.section == 7{
                 return 100
               
                
            }else if indexPath.section == 8 {
                
                 return tableView.rowHeight
                
            }else if indexPath.section == 9{
                
                return tableView.rowHeight
                
            }else if indexPath.section == 10 {
                
                return 50
                
            }else if indexPath.section == 11 {
                
                return 50
                
            }else if indexPath.section == 12 {
                
                return 50
                
            }else if indexPath.section == 13 {
                
                return 50
                
            }else if indexPath.section == 14 {
                
                let GMSCameraPos = GMSCameraPosition.init(latitude: cordinates.latitude, longitude: cordinates.longitude, zoom: 14)
                
                self.Item_Map_View.camera = GMSCameraPos
                
                return 300
                
            }else if indexPath.section == 15 {
                
                return 50
                
            }else if indexPath.section == 16 {
                
                return 0
                
            }else if indexPath.section == 17 {
                
                return 60
                
            }else {
                
                return 50
                
            }
            
        }
        
        
        return 0
        
    }
    
    
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        self.navigationbar.MovetoHome.isHidden = false
        
        if(velocity.y>0) {
            
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            
            UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                
                
                
                self.navigationbar.ItemTitle.isHidden = false
                
//                self.navigationbar.backgroundColor =  UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
                self.navigationbar.backgroundColor = UIColor.clear
                
                
                
            }, completion: nil)
            
            
            
        } else {
            
            UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                
                self.navigationbar.ItemTitle.isHidden = true
                
                self.navigationbar.backgroundColor =  UIColor.clear
                
            }, completion: nil)
            
        }
        
    }
    
    
    
}// class End Brakets:



extension JoBDetailViewVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
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
        
        Relist_Item.Quantitytxt.text! = list1[row]
        
        let days = list1[row].split(separator: " ")
        
        self.selected_date = Int(days[0])!
        
        print("Selected_Date == \(selected_date)")
        
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
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone)
            
        )
        
        toolBar.setItems([doneBtn], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        
        
        
        //toolBar.barTintColor = UIColor.red
        
        toolBar.tintColor = UIColor.red
        
        
        
        textField.inputAccessoryView = toolBar
        
        
        
    }
    
    
    
    @objc func handleDone()
    {
        
        Relist_Item.Quantitytxt.endEditing(true)
        
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if Relist_Item.AmountPerItemtxt.tag == 2{
            
            if Relist_Item.AmountPerItemtxt.text!.count < 0  {
                Relist_Item.DollarSign.textColor = UIColor.gray
            }else {
                Relist_Item.DollarSign.textColor = UIColor.black
            }
            
            if (Relist_Item.AmountPerItemtxt.text?.count)! > 5 {
                let maxLength = 6
                let currentString: NSString = Relist_Item.AmountPerItemtxt.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
            let currentText = Relist_Item.AmountPerItemtxt.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            return replacementText.isValidDecimal(maximumFractionDigits: 2)
        }
        return true
        
    }
    
}

