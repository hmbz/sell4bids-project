//
//  ItemDetailsTableView.swift
//  Sell4Bids
//
//  Created by Osama_Mansoori on 26/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//



import UIKit
import Kingfisher
import GoogleMaps
import AACarousel
import SocketIO
import SwiftyJSON
import Cosmos
import SDWebImage
import UserNotifications

class ItemDetailsTableView: UITableViewController,UICollectionViewDelegate , UICollectionViewDataSource , GMSMapViewDelegate , UINavigationControllerDelegate ,UIGestureRecognizerDelegate ,UIPopoverPresentationControllerDelegate , UITextFieldDelegate{
    
    @IBOutlet weak var crossNavigationBtn: UIButton!
    
    
    //MARK:- Variables
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    var list1 = [String]()
    var list2 = [String]()
    var selected_date = Int()
    var itemid = String()
    var cirlce: GMSCircle!
    var Downloaded_Item_Images = UIImageView()
    var MainAPi = MainSell4BidsApi()
    var currenttime = Int64()
    var ChatMessage = [ChatMessageList]()
    lazy var orderArray = [orderModel]()
    lazy var offerArray = [offerModel]()
    let RejectOfferView = Bundle.main.loadNibNamed("Reject_Order_View", owner: self, options: nil)?.first as! RejectedOrderView
    var RejectOfferViewAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    var SendCounterOffer = Bundle.main.loadNibNamed("OfferNow_Custom_View", owner: self, options: nil)?.first as! OfferNowCustomView
    var SendCounterOfferAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    var sellerId : String?
    var itemId : String?
    
    //MARK:- Functions
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0x000000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x000000) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x000000) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //Mark:- ReloadDataOnRunTime
    func reloadData() {
        self.MainAPi.Item_Details(uid: SessionManager.shared.userId, country: "", seller_uid: self.sellerId ?? "", item_id: self.itemId ?? "") { (status, response, error) in
            if status {
                self.orderArray.removeAll()
                for message in response!["message"] {
                    let itemCategory = message.1["itemCategory"].stringValue
                    print("itemCategory_ItemDetails == \(itemCategory)")
                    //Item Details View
                    let startPrice = message.1["startPrice"].intValue
                    let visibility = message.1["visibility"].boolValue
                    let quantity = message.1["quantity"].intValue
                    let image_0 = message.1["old_images"]
                    var image_array = [String]()
                    for image in image_0 {
                        image_array.append(image.1.stringValue)
                    }
                    let chargeTime = message.1["chargeTime"].int64Value
                    let token = message.1["token"].stringValue
                    let description = message.1["description"].stringValue
                    let uid = message.1["uid"].stringValue
                    let watchingbool = response!["watching"].boolValue
                    let itemKey = message.1["_id"].stringValue
                    let loc = message.1["loc"]
                    _ = loc["coordinates"]
                    var maxBid = Int64()
                    var askPrice = Int64()
                    var winner = String()
                    var u_id = String()
                    var bid = Int64()
                    var watch_uid = String()
                    var watch_token = String()
                    var ItemimagesArr = [String]()
                    
                    let itemAuctionType = message.1["itemAuctionType"].stringValue
                    let country_code = message.1["country_code"].stringValue
//                    let startTime = message.1["startTime"].stringValue
                    let bids = message.1["bids"]
                    for values in bids {
                        
                        let maxBidvalue = values.1["maxBid"].int64Value
                        let askPricevalue = values.1["askPrice"].int64Value
                        let winnervalue = values.1["winner"].stringValue
                        maxBid = maxBidvalue
                        askPrice = askPricevalue
                        winner = winnervalue
                        
                    }
                    print(maxBid,askPrice,winner)
                    let bidList = message.1["bidList"]
                    for bidlst in bidList {
                        let uidvalue = bidlst.1["uid"].stringValue
                        let bidvalue = bidlst.1["bid"].int64Value
                        u_id = uidvalue
                        bid = bidvalue
                    }
                    print(u_id,bid)
                    let timeRemaining = message.1["timeRemaining"].int64Value
                    let conditionValue = message.1["conditionValue"].stringValue
                    let title = message.1["title"].stringValue
                    let watching = message.1["watching"]
                    for watch in watching {
                        
                        let watch_uidvalue = watch.1["uid"].stringValue
                        let watch_tokenvalue = watch.1["token"].stringValue
                        watch_uid = watch_uidvalue
                        watch_token = watch_tokenvalue
                        
                    }
                    self.orderArray.removeAll()
                  
                    self.offerArray.removeAll()
                    let OrderArray = message.1["orders"].arrayValue
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
                    
                    let acceptOffers = message.1["acceptOffers"].boolValue
                    let ordering = message.1["ordering"].boolValue
                    let zipcode = message.1["zipcode"].stringValue
                    let condition = message.1["condition"].stringValue
                    let city = message.1["city"].stringValue
                    let endTime = message.1["endTime"].int64Value
                    let id = message.1["_id"].stringValue
                    let state = message.1["state"].stringValue
                    let autoReList = message.1["autoReList"].stringValue
                    var latitude = Double()
                    var londtitude = Double()
                    let itemimages = message.1["old_images"]
                    let coordinates = loc["coordinates"].array
                    for itemimg in itemimages {
                        
                        ItemimagesArr.append(itemimg.1.stringValue)
                        print("Item Image Url Backhand == \(itemimg.1.stringValue)")
                    }
                    
                    latitude = coordinates![1].doubleValue
                    londtitude = coordinates![0].doubleValue
                    let currency_string = message.1["currency_string"].stringValue
                    let currency_symbol = message.1["currency_string"].stringValue
                    let admin_verify = message.1["admin_verify"].stringValue
                    
                    let productdetails = ProductDetails.init(itemkey: itemKey, itemAuctionType : itemAuctionType ,visibility: visibility, startPrice: startPrice, quantity: quantity, chargeTime: chargeTime, Image_0: image_0.stringValue, Image_1: image_0.stringValue, token: token, description: description, uid: uid, itemCategory: itemCategory, country_code: country_code, startTime: Int64(startPrice), maxBid: maxBid, askPrice: askPrice, winner: winner, winner_uid: watch_uid, winner_bid: Int64(startPrice), timeRemaining: timeRemaining, conditionValue: conditionValue, title: title, watch_uid: watch_uid, watch_token: watch_token, zipcode: zipcode, condition: condition, city: city, endTime: endTime, id: id, state: state, autoReList: autoReList, ItemImages: ItemimagesArr, latitude: latitude, longtitude: londtitude, ordering_status: true, company_name: "", benefits: "", payPeriod: "", jobToughness: "", employmentType: "" , acceptOffers: acceptOffers , ordering: ordering , watchingBool: watchingbool, OrderArray: self.orderArray , currency_string: currency_string , currency_symbol: currency_symbol , admin_verify : admin_verify)
                    
                    self.selectedProduct = productdetails
                    self.selectedProduct!.startPrice = productdetails.startPrice
                    self.showItemData()
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
    
    // Mark:- ButtonOutletsConnections
    @IBOutlet weak var EndlistingBtn: UIButton!
    @IBOutlet weak var MoveToSellerBtn: UIButton!
    @IBOutlet weak var RelistItemHeight: NSLayoutConstraint!
    @IBOutlet weak var EndlistHeight: NSLayoutConstraint!
    
    //Mark:- EndlistingWork.
    let Endlisting_Item = Bundle.main.loadNibNamed("EndlistingCustomView", owner: self, options: nil)?.first as! EndListingView
    let Endlisting_View = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    var EndlistReason = String()
    
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
    
    
    //Mark:- API Funtion Calling Of EndListing.
    @objc func endlisting_api() {
        
        MainAPi.End_Listing(reason: EndlistReason, item_id: selectedProduct!.id) { (status, swiftdata, error) in
            if status {
                
                _ = SweetAlert().showAlert("End Listing", subTitle: "Buyers will not be able to send you orders or offers. Are you sure to end listing for this Item? ", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                    
                    if(status == true) {
                        
                        self.selectedProduct!.endTime = -1
                        self.EndlistingBtn.isHidden = true
//                        self.EndlistHeight.constant = 0
                        self.RelistItem.isHidden = false
//                        self.RelistItemHeight.constant = 50
                        
                        self.Endlisting_View.dismiss(animated: true, completion: nil)
                        _ = SweetAlert().showAlert("End Listing", subTitle: "Item listing has been ended successfully. You can re-list Item anytime.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                        
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
    
    
    // Mark:- ShowAlertView
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
        popoverPresentationController.permittedArrowDirections = .down
        
    }
    
    @IBOutlet weak var OrderBtn: UIButton!
    @IBOutlet weak var postedTimeLabel: UILabel!
    @IBOutlet weak var BidsBtn: UIButton!
    
    
    
    @IBAction func ShareProduct(_ sender: Any) {
        
        let textToShare = "Check out this item that i found on The Sell4Bids Marketplace.".localizableString(loc: LanguageChangeCode)
        let cat = selectedProduct!.itemCategory
        let auction = selectedProduct!.itemAuctionType
        let state =  selectedProduct!.state
        let prodId = selectedProduct!.itemKey
        
        guard let catEncoded = cat.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        var urlString = "https://www.sell4bids.com/item?cat=\(catEncoded)"
        urlString.append("&auction=\(auction)")
        urlString.append("&state=\(state)")
        urlString.append("&pid=\(prodId)")
        guard let url = URL.init(string: urlString ) else { return }
        let objectsToShare = [textToShare, url] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = sender as! UIView
        activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityVC.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    
    
    
    
    @IBOutlet weak var AuctionandListingendedtxt: UILabel!
    @IBOutlet weak var WatchBtn: UIButton!
    @IBOutlet weak var ShareBtn: UIButton!
    @IBOutlet weak var ListedByYou: UILabel!
    
    
    
    func loadnavi() {
        
        self.navigationController?.view.addSubview(navigationbar)
        
    }
    
    
    @IBAction func WatchBtnAction(_ sender: Any) {
        
        if self.WatchBtn.titleLabel!.text == "Remove from Watch List" {
            
            MainAPi.UnWatch_Item(uid: SessionManager.shared.userId, itemid: selectedProduct!.itemKey) { (status, data, error) in
                
                print("remove from Watchlist")
                
                if status {
                    
                    self.WatchBtn.setTitle("Add to Watch List", for: .normal)
                    self.WatchBtn.setImage(UIImage(named: "ic_watch"), for: .normal)
                    self.Watchimg.image = UIImage(named: "ic_watch")
                    showSwiftMessageWithParams(theme: .info, title: "Item Watched" , body: data!["message"].stringValue)
                    
                }else {
                    showSwiftMessageWithParams(theme: .info, title: "ERROR".localizableString(loc: LanguageChangeCode) , body: data!["message"].stringValue)
                }
                
            }
            
        }else {
            
            MainAPi.Watch_Item(uid: SessionManager.shared.userId, itemid: selectedProduct!.itemKey) { (status, data, error) in
                
                print("Add to Watchlist")
                
                if status {
                    self.WatchBtn.setTitle("Remove from Watch List", for: .normal)
                    self.WatchBtn.setImage(UIImage(named: "ic_unwatch"), for: .normal)
                    self.Watchimg.image = UIImage(named: "ic_unwatch")
                    showSwiftMessageWithParams(theme: .info, title: "Item Watched" , body: data!["message"].stringValue)
                    
                }else {
                    showSwiftMessageWithParams(theme: .info, title: "ERROR".localizableString(loc: LanguageChangeCode) , body: data!["message"].stringValue)
                }
            }
        }
        
    }
    
    
    
    
    //Mark:- MoveToProfilePage.
    @IBAction func MoveToUserDetail(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "UserDetails", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
        controller.sellerDetail = self.UserDetail
        controller.title = self.UserDetail?.name ?? "Sell4Bid User"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //Mark:- Calling Fuction for Get Time.
    func Get_time(){
        
        MainAPi.ServerTime { (status, data, error) in
            print("Current time ====== \(data)")
            
            if status {
                
                self.currenttime = data!["time"].int64Value
                
            }
            
        }
        
    }
    
    var TimerHeight = CGFloat()
    var AuctionandListingHeight = CGFloat()
    // Mark:- ItemDetailsConnections.
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var cosmosRating: CosmosView!
    @IBOutlet weak var averageRatingUser: smallBold!
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var Watchimg: UIImageView!
    @IBOutlet weak var watchListConstraint: NSLayoutConstraint!
    @IBOutlet weak var shareimg: UIImageView!
    @IBOutlet weak var StartPrice: UILabel!
    @IBOutlet weak var Item_Title_txt: UILabel!
    @IBOutlet weak var Item_Category_txt: UILabel!
    @IBOutlet weak var Item_Quantity: UILabel!
    @IBOutlet weak var Item_Description_lbl: UILabel!
    @IBOutlet weak var Item_condition_lbl: UILabel!
    @IBOutlet weak var Item_City_lbl: UILabel!
    @IBOutlet weak var Item_Map_View: GMSMapView!
    // Mark:- Durations Label/Outlets.
    @IBOutlet weak var Days: UILabel!
    @IBOutlet weak var Minlbl: UILabel!
    @IBOutlet weak var secondslbl: UILabel!
    @IBOutlet weak var Hourslbl: UILabel!
    @IBOutlet weak var Daytxtlbl: UILabel!
    @IBOutlet weak var Hourtxtlbl: UILabel!
    @IBOutlet weak var Mintxtlbl: UILabel!
    @IBOutlet weak var Seclbltxt: UILabel!
    //Mark:- SellerProfileModel Initilised.
    var UserDetail : SellerDetailModel?
    //Mark:- ButtonsOutletsInItemDetails.
    @IBOutlet weak var AcceptOffers: UIButton!
    @IBOutlet weak var SetStockQuantity: UIButton!
    @IBOutlet weak var ShowItemBtn: UIButton!
    @IBOutlet weak var GetNewOrders: UIButton!
    @IBOutlet weak var RelistItem: UIButton!
    @IBOutlet weak var AutomaticRelist: UIButton!
    @IBOutlet weak var TurboCharge: UIButton!
    
    var Autorelist : Bool?
    var visibility : Bool?
    var orderingstatus : Bool?
    var acceptsOffers : Bool?
    
    
    
    @IBOutlet weak var ViewOrders_ViewOfferBtn: UIButton!
    
    @IBAction func ViewOrdersBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "ItemDetail", bundle: nil)
        let controller2 = storyboard.instantiateViewController(withIdentifier: "OrderView") as! ViewOffersVc
        controller2.productDetail = selectedProduct
        self.navigationController?.pushViewController(controller2, animated: true)
        
    }
    
    
    @IBAction func ViewOrders_ViewOffers(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "ItemDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Offer") as! OfferView
        controller.selectedProduct = selectedProduct
        let maincontroller = storyboard.instantiateViewController(withIdentifier: "ViewOrdersandOffers") as! ItemOrderandItemOfferVC
        maincontroller.selectedProduct = selectedProduct
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    @IBAction func viewBidHistory(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "ItemDetail", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "BidingHistoryViewVC-identifier") as! BidingHistoryViewVC
        
//        controller.productDetail = selectedProduct
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    
    //Mark:- Api calling of UserDetails.
    func GetUserDetails(uid : String)  {
        
        print("Item Detail User ==\(uid)")
        
        MainAPi.Seller_Detail_Api(buyer_uid: SessionManager.shared.userId, seller_uid: uid) { (status, data, error) in
            
            print("status == \(status)")
            print("data == \(data)")
            print("error == \(error)")
            
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
                
            }else {
                
                self.MoveToSellerBtn.isEnabled = false
                
            }
        }
        
    }
    
    
    
    
    // Mark:- ItemRelistWork.
    let Relist_Item = Bundle.main.loadNibNamed("ItemRelistView", owner: self, options: nil)?.first as! itemRelist_ViewVC
    let Relist_Item_View = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    @objc func Close_Relist_item() {
        
        Relist_Item_View.dismiss(animated: true, completion: nil)
        
    }
    
    
    // Mark:- Relist Api Calling.
    @objc func Relist_Item_Api_Call () {
        
        if (Relist_Item.Quantitytxt.text!.isEmpty){
            _ = SweetAlert().showAlert("Invalid Quantity", subTitle: "Please enter a valid quantity to continue.", style: AlertStyle.error,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            return
            
        }else{
            
            MainAPi.Relist_Item(country: gpscountry, startPrice: selectedProduct!.startPrice, endTime: selected_date, item_id: selectedProduct!.id, itemCategory: selectedProduct!.itemCategory){ (status, swiftdata, error) in
                
                if status {
                    
                    _ = SweetAlert().showAlert("Item Re-listing", subTitle: "Do you to re-list this Item?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                        
                        if(status == true){
                            
                            self.EndlistingBtn.isHidden = false
//                            self.EndlistHeight.constant = 50
                            self.Relist_Item_View.dismiss(animated: true, completion: nil)
                            self.RelistItem.isHidden = true
//                            self.RelistItemHeight.constant = 0
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
    
    //Mark:- Relist Action Implementation.
    @IBAction func Relist_Item(_ sender: Any) {
        
        Relist_Item_View.view.frame = Relist_Item.frame
        Relist_Item.CloseBtn.addTarget(self, action: #selector(Close_Relist_item), for: .touchUpInside)
        Relist_Item.SendOfferBtn.addTarget(self, action: #selector(Relist_Item_Api_Call), for: .touchUpInside)
        Relist_Item.Header1_Title.text = "Listing Duration"
        Relist_Item.Quantitytxt.text = "3 Days"
        Relist_Item.SendOfferBtn.titleLabel?.text = "Re-list"
        ChangeBtnStyle(Button: Relist_Item.SendOfferBtn)
        Relist_Item_View.view.addSubview(Relist_Item)
        
        self.present(Relist_Item_View, animated: true, completion: nil)
        
    }
    
    // Mark:- AcceptOffers Action Implementation.
    @IBAction func AccpetOffers(_ sender: Any) {
        
        if self.AcceptOffers.titleLabel?.text == "Stop Accepting Offers" {
            
            self.acceptsOffers = false
            
            _ = SweetAlert().showAlert("Stop Offers", subTitle: "Do you want to stop buyers to send offers?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status==true){
                    
                    self.MainAPi.Offer_Status(country: gpscountry, acceptOffers: self.acceptsOffers!, item_id: self.selectedProduct!.id) { (status, data, error) in
                        
                        print("status == \(status)")
                        print("Data == \(data)")
                        print("error == \(error)")
                        
                        if status {
                            
                            if self.acceptsOffers == true {
                                
                                self.AcceptOffers.setTitle("Stop Accepting Offers", for: .normal)
                                self.AcceptOffers.setTitleColor(UIColor.black, for: .normal)
                                self.AcceptOffers.backgroundColor = UIColor.white
                                self.reloadData()
                                
                            }else {
                                
                                self.AcceptOffers.setTitle("Accept Offers", for: .normal)
                                self.AcceptOffers.setTitleColor(UIColor.white, for: .normal)
                                self.AcceptOffers.backgroundColor = UIColor.black
                                self.reloadData()
                                
                            }
                        }
                        
                        if error.contains("The network connection was lost"){
                            
                            _ = SweetAlert().showAlert("Offers", subTitle: "Unable to disable the offers due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            _ = SweetAlert().showAlert("Offers", subTitle: "Unable to disable the offers due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            _ = SweetAlert().showAlert("Offers", subTitle: "Unable to disable the offers due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("The request timed out.") {
                            
                            _ = SweetAlert().showAlert("Offers", subTitle: "Unable to disable the offers due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                    }
                    
                    _ = SweetAlert().showAlert("Offers", subTitle: "  Offers has been disabled successfully. You can enabled it anytime. ", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
            }
        }
            
        else if self.AcceptOffers.titleLabel?.text == "Accept Offers"{
            
            self.acceptsOffers = true
            
            _ = SweetAlert().showAlert("Offers", subTitle: "Do you want buyers to send offers?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status==true){
                    
                    self.MainAPi.Offer_Status(country: gpscountry, acceptOffers: self.acceptsOffers!, item_id: self.selectedProduct!.id) { (status, data, error) in
                        
                        if status {
                            
                            if self.acceptsOffers == false {
                                
                                self.AcceptOffers.setTitle("Accept Offers", for: .normal)
                                self.AcceptOffers.setTitleColor(UIColor.black, for: .normal)
                                self.AcceptOffers.backgroundColor = UIColor.white
                                
                            }else {
                                
                                self.AcceptOffers.setTitle("Stop Accepting Offers", for: .normal)
                                self.AcceptOffers.setTitleColor(UIColor.black, for: .normal)
                                self.AcceptOffers.backgroundColor = UIColor.white
                                
                            }
                        }
                        
                        if error.contains("The network connection was lost"){
                            
                            _ = SweetAlert().showAlert("Offers", subTitle: "Unable to enable the offers due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            _ = SweetAlert().showAlert("Offers", subTitle: "Unable to enable the offers due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            _ = SweetAlert().showAlert("Offers", subTitle: "Unable to enable the offers due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        }
                        
                        if error.contains("The request timed out.") {
                            
                            _ = SweetAlert().showAlert("Offers", subTitle: "Unable to enable the offers due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                    }
                    
                    _ = SweetAlert().showAlert("Offers", subTitle: "Offers has been enabled successfully. Buyers will be able send offers on this item. ", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    
    //Get orders - Stop orders
    @IBAction func Ordering_Status(_ sender: Any) {
        
        if self.GetNewOrders.titleLabel?.text == "Stop New Orders" {
            
            orderingstatus = false
            
            _ = SweetAlert().showAlert("Stop Orders", subTitle: "Do you want to stop buyers to send new orders?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status==true){
                    
                    self.MainAPi.Ordering_Status(country: gpscountry, ordering: self.orderingstatus!, item_id:self.selectedProduct!.id) { (status, data, error) in
                        
                        if status {
                            
                            if self.orderingstatus! {
                                self.GetNewOrders.setTitle("Stop New Orders", for: .normal)
                                self.GetNewOrders.setTitleColor(UIColor.black, for: .normal)
                                self.GetNewOrders.backgroundColor = UIColor.white
                                
                            }else {
                                
                                self.GetNewOrders.setTitle("Get New Orders", for: .normal)
                                self.GetNewOrders.setTitleColor(UIColor.white, for: .normal)
                                self.GetNewOrders.backgroundColor = UIColor.black
                                
                            }
                        }
                        
                        if error.contains("The network connection was lost"){
                            
                            _ = SweetAlert().showAlert("Stop Orders", subTitle: "Unable to disable the orders due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            _ = SweetAlert().showAlert("Stop Orders", subTitle: "Unable to disable the orders due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            _ = SweetAlert().showAlert("Stop Orders", subTitle: "Unable to disable the orders due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("The request timed out.") {
                            
                            _ = SweetAlert().showAlert("Stop Orders", subTitle: "Unable to disable the orders due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                    }
                    _ = SweetAlert().showAlert("Stop Orders", subTitle:"Orders has been disabled successfully. you can enabled it anytime.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
            }
            
        }
            
        else if self.GetNewOrders.titleLabel?.text == "Get New Orders" {
            
            orderingstatus = true
            
            _ = SweetAlert().showAlert("Orders", subTitle: "Do you want buyers to send new orders?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status==true){
                    
                    self.MainAPi.Ordering_Status(country: gpscountry, ordering: self.orderingstatus!, item_id:self.selectedProduct!.id) { (status, data, error) in
                        
                        
                        if status {
                            
                            if self.orderingstatus! {
                                
                                self.GetNewOrders.setTitle("Stop New Orders", for: .normal)
                                self.GetNewOrders.setTitleColor(UIColor.black, for: .normal)
                                self.GetNewOrders.backgroundColor = UIColor.white
                                self.reloadData()
                                
                            }else {
                                
                                self.GetNewOrders.setTitle("Get New Orders", for: .normal)
                                self.GetNewOrders.setTitleColor(UIColor.white, for: .normal)
                                self.GetNewOrders.backgroundColor = UIColor.black
                                
                            }
                        }
                        
                        if error.contains("The network connection was lost"){
                            
                            _ = SweetAlert().showAlert("Orders", subTitle: "Unable to enable the orders due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        }
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            _ = SweetAlert().showAlert("Orders", subTitle: "Unable to enable the orders due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            _ = SweetAlert().showAlert("Orders", subTitle: "Unable to enable the orders due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("The request timed out.") {
                            
                            _ = SweetAlert().showAlert("Orders", subTitle: "Unable to enable the orders due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                    }
                    
                    _ = SweetAlert().showAlert("Orders", subTitle: "Orders has been enabled successfully. Buyers will be able send orders on this Item. ", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
            }
        }}
    
    
    //item turbo charged
    @IBAction func Turbo_Charge_Item(_ sender: Any) {
        
        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Item will be shown first to new users. Do you want to turbo charge the Item?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
            
            if status == true {
                
                self.MainAPi.Item_TurboCharge(country: gpscountry, item_id: self.selectedProduct!.id) { (status, data, error) in
                    
                    if error.contains("The network connection was lost"){
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Item has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                    }
                    
                    if error.contains("The Internet connection appears to be offline.") {
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Item has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                    }
                    
                    if error.contains("A server with the specified hostname could not be found."){
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Item has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                    }
                    
                    if error.contains("The request timed out.") {
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Item has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                    }
                    
                }
                _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Item has been turbo charged successfully.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                
            }
            
        }
        
    }
    
    
    //item set quantity
    let Set_Item_Quantiy = UIAlertController(title: "", message: "", preferredStyle: .alert)
    let Set_Item_Quantity_View = Bundle.main.loadNibNamed("Buy_Now_Custom_View", owner: self, options: nil)?.first as! BuyNowCustomView
    
    //item set quantity
    @objc func Close_btn_Set_Item_Quantity() {
        
        Set_Item_Quantiy.dismiss(animated: true, completion: nil)
        
    }
    
    //item set quantity
    @objc func Set_Quantity_Api_Call() {
        
        if (Set_Item_Quantity_View.Quantitytxt.text!.isEmpty){
            _ = SweetAlert().showAlert("Quantity Error", subTitle: "Please enter Quantity.", style: AlertStyle.error,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            return
        }
        
        if (!Set_Item_Quantity_View.Quantitytxt.text!.isEmpty){
            
            let setquantity : Int = Int(Set_Item_Quantity_View.Quantitytxt.text!)!
            
            if (!Set_Item_Quantity_View.Quantitytxt.text!.isEmpty) {
                
                
                if setquantity <= 0 {
                    
                    _ = SweetAlert().showAlert("Invalid Quantity", subTitle: "Please enter valid Quantity more then 0.", style: AlertStyle.error,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    return
                    
                }
                else{
                    
                    MainAPi.Set_item_Quantity(country: gpscountry, quantity: setquantity, item_id: selectedProduct!.id) { (status, data, error) in
                        
                        if status == true {
                            
                            _ = SweetAlert().showAlert("Quantity Updated", subTitle: "You have succesfully Updated the stock quantity.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                            self.Set_Item_Quantiy.dismiss(animated: true, completion: nil)
                            
                        }else{
                            
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
                }
            }
        }
    }
    
    //item set quantity
    @IBAction func Set_Item_Quantity(_ sender: Any) {
        
        Set_Item_Quantity_View.Quantitytxt.delegate = self
        Set_Item_Quantiy.view.frame = Set_Item_Quantity_View.frame
        Set_Item_Quantity_View.CloseBtn.addTarget(self, action: #selector(Close_btn_Set_Item_Quantity), for: .touchUpInside)
        Set_Item_Quantity_View.SendOfferBtn.addTarget(self, action: #selector(Set_Quantity_Api_Call), for: .touchUpInside)
        Set_Item_Quantity_View.currency_constraint.constant = 0
        Set_Item_Quantity_View.Heading_Title.text = "Stock Quantity"
        Set_Item_Quantity_View.SendOfferBtn.setTitle("Set Quantity", for: .normal)
        ChangeBtnStyle(Button: Set_Item_Quantity_View.SendOfferBtn)
        Set_Item_Quantiy.view.addSubview(Set_Item_Quantity_View)
        self.present(Set_Item_Quantiy, animated: true, completion: nil)
        Set_Item_Quantity_View.Quantitytxt.placeholder = "Enter your quantity"
        
    }
    
    
    
    //Show_Item_Hide.
    @IBAction func Show_Item_Hide_Item(_ sender: Any) {
        
        if ShowItemBtn.titleLabel!.text == "Hide Item" {
            
            visibility = false
            
            _ = SweetAlert().showAlert("Item Visibility", subTitle: "Item will not be visible to buyers. Do you want to hide the Item?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status == true){
                    
                    self.MainAPi.Hide_Show_Item(country: gpscountry, visibility: self.visibility!, item_id: self.selectedProduct!.id) { (status, data, error) in
                        
                        if status {
                            
                            if self.visibility == true {
                                
                                self.ShowItemBtn.setTitle("Hide Item", for: .normal)
                                self.ShowItemBtn.backgroundColor = UIColor.white
                                self.ShowItemBtn.setTitleColor(UIColor.black, for: .normal)
                                self.reloadData()
                                
                            }else {
                                self.ShowItemBtn.setTitle("Show Item", for: .normal)
                                self.ShowItemBtn.backgroundColor = UIColor.black
                                self.ShowItemBtn.setTitleColor(UIColor.white, for: .normal)
                                self.reloadData()
                                
                            }
                            
                        }
                        
                        if error.contains("The network connection was lost"){
                            
                            _ = SweetAlert().showAlert("Item Visibility", subTitle: "Item visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            _ = SweetAlert().showAlert("Item Visibility", subTitle: "Item has not been disabled due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            _ = SweetAlert().showAlert("Item Visibility", subTitle: "Item has not been disabled due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("The request timed out.") {
                            
                            _ = SweetAlert().showAlert("Item Visibility", subTitle: "Item has not been disabled due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                    }
                    _ = SweetAlert().showAlert("Item Visibility", subTitle: " Item has been disabled successfully. You can un-hide the item anytime.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
                
            }
            
        }
        else if ShowItemBtn.titleLabel!.text == "Show Item" {
            
            visibility = true
            
            _ = SweetAlert().showAlert("Item Visibility", subTitle: "Item will be visible to new buyers. Do you want to un-hide the Item?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status == true){
                    
                    print("check")
                    
                    self.MainAPi.Hide_Show_Item(country: gpscountry, visibility: self.visibility!, item_id: self.selectedProduct!.id) { (status, data, error) in
                        
                        if status {
                            
                            if self.visibility == false {
                                
                                self.ShowItemBtn.setTitle("Show Item", for: .normal)
                                self.ShowItemBtn.backgroundColor = UIColor.black
                                self.ShowItemBtn.setTitleColor(UIColor.white, for: .normal)
                                self.reloadData()
                                
                            }else {
                                self.ShowItemBtn.setTitle("Hide Item", for: .normal)
                                self.ShowItemBtn.backgroundColor = UIColor.white
                                self.ShowItemBtn.setTitleColor(UIColor.black, for: .normal)
                                self.reloadData()
                                
                            }
                            
                        }
                        
                        if error.contains("The network connection was lost"){
                            
                            _ = SweetAlert().showAlert("Item Visibility", subTitle: "Item visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            _ = SweetAlert().showAlert("Item Visibility", subTitle: "Item visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            _ = SweetAlert().showAlert("Item Visibility", subTitle: "Item visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("The request timed out.") {
                            
                            _ = SweetAlert().showAlert("Item Visibility", subTitle: "Item visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                    }
                    
                    _ = SweetAlert().showAlert("Item Visibility", subTitle: "Succesfully updated. Item will be visible to buyers.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
            }
        }
    }
    
    
    //Item Autorelisting.
    @IBAction func AutoRelisting_Item(_ sender: Any) {
        print("(AutoRelisting_Item)")
        if self.AutomaticRelist.titleLabel?.text == "Stop Automatic Relisting" {
            
            self.Autorelist = false
            
            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Item will not be automatically re-listed for 03 more days after expiration. Do you want to disable automatic re-listing of the Item?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status == true){
                    
                    self.MainAPi.AutoRelist_Item(country: gpscountry, autoReList: self.Autorelist!, item_id: self.selectedProduct!.id) { (status, data, error) in
                        
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
                    
                    _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing has been disabled for this Item.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
            }
        }
            
        else if self.AutomaticRelist.titleLabel?.text == "Automatic Relist"{
            
            Autorelist = true
            
            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Item will be automatically re-listed for 03 more days after expiration. Do you want automatic re-listing for the Item?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status==true){
                    
                    self.MainAPi.AutoRelist_Item(country: gpscountry, autoReList: self.Autorelist!, item_id: self.selectedProduct!.id) { (status, data, error) in
                        
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
                    
                    _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing has been enabled for this Item. Item will be re-listed for 03 days on expiration.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                }
            }
        }
    }
    
    //Mark:- Report Item.
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
    
    
    
    @objc func Submit_Btn_Report() {
        
        if ReportItemTxt == ""{
                      _ = SweetAlert().showAlert("Report Item", subTitle: "please Selet a reason" , style: .error)
        }else{

          MainAPi.Report_Item(uid: SessionManager.shared.userId , report: ReportItemTxt, item_id: selectedProduct!.itemKey, seller_uid: selectedProduct!.uid) { (status, data, error) in
              
              
              
              if status {
                  
                  _ = SweetAlert().showAlert("Report Item", subTitle: "Successfully Reported", style: .success)
                  
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
        
        Button.addShadowAndRound()
        
    }
    
    
    
    let testVC = UITableViewController(style: .grouped)
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("Item Image == \(itemimg.count)")
        
        if collectionView.tag == 0 {
            
            return selectedProduct?.ItemImages.count ?? 0
            
        }else {
            
            return selectedProduct?.ItemImages.count ?? 0
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if collectionView.tag == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCell", for: indexPath) as! ItemImgSliderCell
            
            cell.contentView.isUserInteractionEnabled = true
            let urlStr = selectedProduct?.ItemImages[indexPath.item] ?? ""
            
            print("url == \(urlStr)")
            
            cell.ItemImage.sd_setImage(with: URL(string: urlStr), placeholderImage:  UIImage(named: "emptyImage") )
            
            cell.ItemImage.contentMode = .scaleAspectFill
            
            return cell
            
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideritemImage", for: indexPath) as! Items_Detail_Sliders_Cell
            
            let urlStr = selectedProduct?.ItemImages[indexPath.item] ?? ""
            
            print("url == \(urlStr)")
            
            cell.ItemSliderImages.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "emptyImage") )
            
            
            return cell
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewerPopUpVc")  as! ImageViewerPopUpVc
        //let  selectedImage = dataArray[indexPath.row]
        controller.selectedIndex = indexPath
        
        print("controller.selectedIndex : \(String(describing: controller.selectedIndex))")
        
        controller.view.backgroundColor = UIColor.white
        
        controller.imagesArray = selectedProduct!.ItemImages
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        controller.modalTransitionStyle = .coverVertical
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    var cordinates = CLLocationCoordinate2D()
    
    var selectedProduct : ProductDetails?
    
    var ItemImages = [String]()
    
    
    
    var itemimg = [UIImage]()
    
    var Title = String()
    
    
    
    let viewButton  = Bundle.main.loadNibNamed("ItemDetailBottomButtons", owner: self, options: nil)?.first as! ButtonStacksItem
    
    let item_header = Bundle.main.loadNibNamed("Item_Header", owner: self, options: nil)?.first as! Item_Header
    
    let navigationbar = Bundle.main.loadNibNamed("Item_Navigation_barview", owner: self, options: nil)?.first as! Item_Navigation_barview
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.reloadData()
    }
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.timer!.invalidate()
        
        viewButton.removeFromSuperview()
        
        navigationbar.removeFromSuperview()
        
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    
    
    let Buy_Now_Dialogue = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    let Offer_Now_Dailogue = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    let Bid_Now_Alert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    let BuyNowCustomView = Bundle.main.loadNibNamed("Buy_Now_Custom_View", owner: self, options: nil)?.first as! BuyNowCustomView
    
    let OfferNowCustomView = Bundle.main.loadNibNamed("OfferNow_Custom_View", owner: self, options: nil)?.first as! OfferNowCustomView
    
    let BidNowCustomView = Bundle.main.loadNibNamed("Buy_Now_Custom_View", owner: self, options: nil)?.first as! BuyNowCustomView
    
    
    var quantity : Int?
    @objc func SendOfferBtn() {
        
        quantity = Int(BuyNowCustomView.Quantitytxt.text!)
        
        if quantity == nil {
            
            SweetAlert().showAlert("Invalid Quantity", subTitle: "Please enter the quantity field to continue.", style: AlertStyle.error , buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            return
        }
        
        if quantity! <= 0{
            
            _ = SweetAlert().showAlert("Invalid Quantity", subTitle: "Please enter valid Quantity more then 0.", style: AlertStyle.error,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            return
            
        }
            
            
        else if quantity! > selectedProduct!.quantity{
            
            SweetAlert().showAlert("Invalid Quantity", subTitle: "Quantity must not be greater than available stock", style: AlertStyle.error , buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            return
            
        } else {
            
            MainAPi.Buy_Now_Item(country: gpscountry, boughtQuantity: quantity!, buyerName: SessionManager.shared.name, seller_uid: (selectedProduct?.uid)!, buyer_uid: SessionManager.shared.userId, itemId: (selectedProduct?.id)!, seller_email: SessionManager.shared.email , buyImage: SessionManager.shared.image) { (status, data, error) in
                
                print("status == \(status)")
                
                print("data == \(data)")
                
                print("error == \(error)")
                
                let datanew = data!["message"]
                
                let boughtQuantity = datanew["boughtQuantity"].intValue
                
                self.Item_Quantity.text = "Quantity : \(self.selectedProduct!.quantity - boughtQuantity ) items"
                
                self.tableView.reloadUsingDispatch()
                
                if status {
                    
                    _ = SweetAlert().showAlert("Buy Item", subTitle: "\(data!["message"].stringValue)", style: .success , buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                        
                        if self.selectedProduct!.quantity == 0  {
                            
                            self.viewButton.Buy_Now_Btn.isEnabled = false
                            self.viewButton.Buy_Now_Btn.backgroundColor = UIColor.gray
                            self.viewButton.Offer_Now_Btn.isEnabled = false
                            self.viewButton.Offer_Now_Btn.backgroundColor = UIColor.gray
                            
                        }
                        self.reloadData()
                        
                        self.Buy_Now_Dialogue.dismiss(animated: true, completion: nil)
                        
                        self.tableView.reloadData()
                    })
                    
                }else {
                    
                    showSwiftMessageWithParams(theme: .info, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "You order has not been placed due to some reasons, try again.")
                    
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
        
    }
    
    @objc func Offer_Now_Api() {
        
        let price = Int(OfferNowCustomView.AmountPerItemtxt.text!)
        
        let Quantity = Int(OfferNowCustomView.Quantitytxt.text!)
        
        if (OfferNowCustomView.AmountPerItemtxt.text!.isEmpty) {
            _ = SweetAlert().showAlert("Price Error", subTitle: "Price can't be empty.", style: AlertStyle.warning,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            return
        }
        else if (!OfferNowCustomView.AmountPerItemtxt.text!.isEmpty) {
            
            if price! <= 0 {
                
                _ = SweetAlert().showAlert("Invalid Price", subTitle: "Please enter valid Price more then 0.", style: AlertStyle.warning,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                return
                
            }
            else if (OfferNowCustomView.Quantitytxt.text!.isEmpty) {
                _ = SweetAlert().showAlert("Quantity Error", subTitle: "Quantity can't be empty.", style: AlertStyle.warning,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                return
            }
            else if (!OfferNowCustomView.Quantitytxt.text!.isEmpty){
                
                if Quantity! <= 0 {
                    
                    _ = SweetAlert().showAlert("Invalid Quantity", subTitle: "Please enter valid Quantity more then 0.", style: AlertStyle.warning,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    return
                    
                }
                
            }
        }
        
        MainAPi.Buy_Offer(buyer_uid: SessionManager.shared.userId, offer_price: OfferNowCustomView.AmountPerItemtxt.text!, item_id: selectedProduct!.id, offer_quantity: OfferNowCustomView.Quantitytxt.text!, offerType: "offers", buyer_name: SessionManager.shared.name, buyer_image: SessionManager.shared.image , itemCategory: selectedProduct!.itemCategory) { (status, data, error) in
            
            if status {
                
                showSwiftMessageWithParams(theme: .info, title: "Offer Sent", body: "\(data!["message"].stringValue)", durationSecs: 50, layout: .centeredView, position: .center)
                
                self.Offer_Now_Dailogue.dismiss(animated: true, completion: nil)
                self.reloadData()
                self.tableView.reloadData()
            }
            
            print("status = \(status)")
            
            print("data = \(data)")
            
            print("error == \(error)")
            
        }
        
        
    }
    
    @objc func Bid_Now_Api() {
        
        
        print("item ==\(selectedProduct!.itemKey)")
        
        if BidNowCustomView.Quantitytxt.text!.isEmpty {
            
            _ = SweetAlert().showAlert("Price Error", subTitle: "Price can't be empty.", style: AlertStyle.warning,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            
        }else {
            
            MainAPi.Bid_Now_Api(bidAmount:  "\(BidNowCustomView.Quantitytxt.text!)" , item_id: selectedProduct!.itemKey, buyerUid: SessionManager.shared.userId, buyerName: SessionManager.shared.name, buyerToken: SessionManager.shared.fcmToken, buyerEmail: SessionManager.shared.email) { (status, data, error) in
                
                if status {
                    
                    _ = SweetAlert().showAlert("", subTitle: "\(data!["message"].stringValue)", style: .none, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                        
                        self.reloadData()
                        
                        self.Bid_Now_Alert.dismiss(animated: true, completion: nil)
                        
                        self.tableView.reloadData()
                        
                    })
                    
                }else {
                    
                    _ = SweetAlert().showAlert("", subTitle: "\(data!["message"].stringValue)", style: .error, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                        
                        self.reloadData()
                        
                        self.Bid_Now_Alert.dismiss(animated: true, completion: nil)
                        
                        self.tableView.reloadData()
                        
                    })
                    
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
                
                print("status = \(status)")
                
                print("data = \(data)")
                
                print("error = \(error)")
                
            }
            
        }
        
    }
    
    
    
    @objc func Bid_Now_Close() {
        
        Bid_Now_Alert.dismiss(animated: true, completion: nil)
        
    }
    @objc func Closebtn() {
        
        Buy_Now_Dialogue.dismiss(animated: true, completion: nil)
        
    }
    @objc func OfferNoe_Closebtn(){
        
        Offer_Now_Dailogue.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    @objc func Offer_Now() {
        OfferNowCustomView.AmountPerItemtxt.delegate = self
        OfferNowCustomView.Quantitytxt.delegate = self
        OfferNowCustomView.SendOfferBtn.addShadowAndRound()
        OfferNowCustomView.SendOfferBtn.addTarget(self, action: #selector(Offer_Now_Api), for: .touchUpInside)
        OfferNowCustomView.CloseBtn.addTarget(self, action: #selector(OfferNoe_Closebtn), for: .touchUpInside)
        Offer_Now_Dailogue.view.frame = OfferNowCustomView.frame
        Offer_Now_Dailogue.view.addSubview(OfferNowCustomView)
        self.present(Offer_Now_Dailogue, animated: true, completion: nil)
    }
    
    
    
    
    @objc func Bid_Now() {
        BidNowCustomView.SendOfferBtn.addShadowAndRound()
        BidNowCustomView.Quantitytxt.delegate = self
        BidNowCustomView.SendOfferBtn.setTitle("Bid Now", for: .normal)
        let country = selectedProduct?.country_code.uppercased()
        print("ItemDetail_country == \(country!)")
        let Detail_Currency_Symbol = CurrencyManager.instance.getCurrencySymbol(Country: country ?? "USA")
        print("Detail_Currency_Symbol == \(Detail_Currency_Symbol)")
        BidNowCustomView.Heading_Title.text =  "Bid \(Detail_Currency_Symbol )\(selectedProduct!.startPrice) or more"
        BidNowCustomView.currencyTextField.text = Detail_Currency_Symbol
        BidNowCustomView.Quantitytxt.placeholder = "Enter Price"
        BidNowCustomView.CloseBtn.addTarget(self, action: #selector(Bid_Now_Close), for: .touchUpInside)
        Bid_Now_Alert.view.frame = BidNowCustomView.frame
        Bid_Now_Alert.view.addSubview(BidNowCustomView)
        BidNowCustomView.SendOfferBtn.addTarget(self, action: #selector(Bid_Now_Api), for: .touchUpInside)
        self.present(Bid_Now_Alert, animated: true, completion: nil)
    }
    
    
    
    @objc func Buy_Now() {
        
        BuyNowCustomView.Quantitytxt.delegate = self
        
        BuyNowCustomView.currencyTextField.text = selectedProduct?.currency_string
        
        BuyNowCustomView.CloseBtn.addTarget(self, action: #selector(Closebtn), for: .touchUpInside)
        
        BuyNowCustomView.SendOfferBtn.addTarget(self, action: #selector(SendOfferBtn), for: .touchUpInside)
        
        BuyNowCustomView.SendOfferBtn.addShadowAndRound()
        
        Buy_Now_Dialogue.view.frame = BuyNowCustomView.frame
        
        Buy_Now_Dialogue.view.addSubview(BuyNowCustomView)
        
        self.present(Buy_Now_Dialogue, animated: true, completion: nil)
        
        print("Selected")
        
    }
    
    
    @objc func Back_btn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func rejectOfferBuyerBtnTapped(sender: UIButton){
        
        ShowSellerCounteOffer_View.dismiss(animated: true, completion: nil)
        RejectOfferViewAlert.view.frame = RejectOfferView.frame
        RejectOfferViewAlert.view.addSubview(RejectOfferView)
        RejectOfferView.SubmitBtn.addTarget(self, action: #selector(submitReasonTapped), for: .touchUpInside)
        RejectOfferView.Close_Btn.addTarget(self, action: #selector(closeRejectReason), for: .touchUpInside)
        self.present(RejectOfferViewAlert, animated: true, completion: nil)
    }
    
    @objc func AcceptOfferBtnTapped(sender: UIButton){
        let body:[String:Any] = ["buyer_name":SessionManager.shared.name,
                                 "seller_image":SessionManager.shared.image,
                                 "item_id":selectedProduct?.id ?? "",
                                 "order_id":selectedProduct?.OrderArray.last?.orderId ?? ""]
        CallAcceptBuyerOfferApiCall(body: body)
    }
    
    
    @objc func submitReasonTapped(sender: UIButton){
        
        let body:[String: Any] = [ "buyer_name":SessionManager.shared.name,
                                   "buyer_image":SessionManager.shared.image,
                                   "buyer_uid": SessionManager.shared.userId,
                                   "item_id":selectedProduct?.id ?? "",
                                   "order_id":selectedProduct?.OrderArray.last?.orderId ?? "",
                                   "orderRejectReason": RejectOfferView.Reasontxt.text!]
        print(body)
        CallRejectBuyerOfferApiCall(body: body)
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
                "seller_uid": selectedProduct?.OrderArray.last?.sellerId ?? "",
                "buyer_uid": SessionManager.shared.userId ,
                "product_image":selectedProduct?.ItemImages[0] ?? [],
                "offer_price": SendCounterOffer.AmountPerItemtxt.text!,
                "item_id": selectedProduct?.OrderArray.last?.orderId ?? ""   ,
                "offer_quantity": SendCounterOffer.Quantitytxt.text!,
                "product_title": selectedProduct?.title ?? "",
                "buyer_name":SessionManager.shared.name,
                "product_category": selectedProduct?.itemCategory ?? "",
                "product_auction_type":selectedProduct?.itemAuctionType ?? "",
                "product_state": selectedProduct?.state ?? "",
                "buyer_image":SessionManager.shared.image ,
                "offer_count": selectedProduct?.OrderArray.last?.OfferCount ?? "",
                "order_id": selectedProduct?.OrderArray.last?.orderId ?? ""
            ]
            CallCounterOfferApiCall(body: body)
        }
        
    }
    
    
    @objc func closeRejectReason(){
        RejectOfferViewAlert.dismiss(animated: true, completion: nil)
    }
    
    
    func  CallRejectBuyerOfferApiCall(body: [String:Any]){
        
        let url  = "\(MainAPi.IP)/items/rejectOfferBuyer"
        MainAPi.postApiCall(URL: url, param: body) { (success) in
            if success{
                let status = self.MainAPi.status
                if status == 200{
                    print("200")
                    let message = self.MainAPi.message
                    print(message)
                    self.RejectOfferViewAlert.dismiss(animated: true, completion: nil)
                    showSwiftMessageWithParams(theme: .success, title: "", body: "Offer Rejected successfully")
                    self.reloadData()
                    
                }
                else{
                    print("Error")
                    
                }
            }
            else{
                let status = self.MainAPi.status
                print(status)
            }
            
        }
        
    }
    
    func  CallAcceptBuyerOfferApiCall(body: [String:Any]){
        let url  = "\(MainAPi.IP)/items/acceptOfferBuyer"
        MainAPi.postApiCall(URL: url, param: body) { (success) in
            if success{
                let status = self.MainAPi.status
                if status == 200{
                    print("200")
                    let message = self.MainAPi.message
                    print(message)
                    self.ShowSellerCounteOffer_View.dismiss(animated: true, completion: nil)
                    showSwiftMessageWithParams(theme: .success, title: "", body: "Offer Accepted successfully")
                    self.reloadData()
                    
                }
                else{
                    print("Error")
                    
                }
            }
            else{
                let status = self.MainAPi.status
                print(status)
            }
            
        }
    }
    
    func  CallCounterOfferApiCall(body: [String:Any]){
        
        let url  = "\(MainAPi.IP)/items/buyerCounterOffer"
        MainAPi.postApiCall(URL: url, param: body) { (success) in
            if success{
                let status = self.MainAPi.status
                if status == 200{
                    print("200")
                    let message = self.MainAPi.message
                    print(message)
                    self.SendCounterOfferAlert.dismiss(animated: true, completion: nil)
                    showSwiftMessageWithParams(theme: .success, title: "", body: "Your counter offer has been sent successfully")
                    self.reloadData()
                    
                }
                else{
                    print("Error")
                    
                }
            }
            else{
                let status = self.MainAPi.status
                print(status)
            }
            
        }
    }
    
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
        self.navigationController?.navigationBar.isHidden = true
        
        viewButton.frame = CGRect.init(x: 0, y: self.view.frame.maxY - 60 , width: UIScreen.main.bounds.width, height: 60)
        viewButton.backgroundColor = UIColor.clear
        viewButton.addShadowView()
        
        self.navigationController?.view.addSubview(viewButton)
        
        self.navigationController?.view.addSubview(navigationbar)
        
        
       
        
        
        
       
        
        
    }
    
    
    
    @objc func updateTimer(currentTime: NSNumber?){
        
        var timer = Int64()
        var dif = Int64()
        
        timer = selectedProduct!.endTime
        dif = timer - currenttime
        
        
        if timer == -1 {
            
            TimerHeight = 0
            AuctionandListingHeight = 0
            
            if ((selectedProduct?.OrderArray.isEmpty)!) {
                viewButton.Buy_Now_Btn.isEnabled = true
                self.viewButton.Buy_Now_Btn.backgroundColor = UIColor.black
                viewButton.Offer_Now_Btn.isEnabled = true
                self.viewButton.Offer_Now_Btn.backgroundColor = UIColor.black
            }else{
                viewButton.Buy_Now_Btn.isEnabled = false
                self.viewButton.Buy_Now_Btn.backgroundColor = UIColor.gray
                viewButton.Offer_Now_Btn.isEnabled = false
                self.viewButton.Offer_Now_Btn.backgroundColor = UIColor.gray
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
                
                
                
                if selectedProduct!.itemAuctionType == "reserve" || selectedProduct!.itemAuctionType == "non-reserve" {
                    
                    viewButton.Bid_Now_Btn.isEnabled = false
                    
                    viewButton.Bid_Now_Btn.backgroundColor = UIColor.gray
                    
                    TimerHeight = 0
                    
                    AuctionandListingHeight = 50
                    
                }else {
                    
                    viewButton.Buy_Now_Btn.isEnabled = false
                    
                    viewButton.Buy_Now_Btn.backgroundColor = UIColor.gray
                    
                    viewButton.Offer_Now_Btn.isEnabled = false
                    
                    viewButton.Offer_Now_Btn.backgroundColor = UIColor.gray
                    
                    TimerHeight = 0
                    
                    AuctionandListingHeight = 50
                    
                }
                
                viewButton.Bid_Now_Btn.isEnabled = false
                viewButton.Bid_Now_Btn.backgroundColor = UIColor.gray
                
                TimerHeight = 0
                AuctionandListingHeight = 50
                
                if selectedProduct!.itemAuctionType == "buy-it-now" {
                    
                    AuctionandListingendedtxt.text = "Listing Ended"
                    
                    AuctionandListingendedtxt.textColor = UIColor.red
                    
                }else {
                    
                    AuctionandListingendedtxt.text = "Auction Ended"
                    
                    AuctionandListingendedtxt.textColor = UIColor.red
                    
                }
                
            }else{
                
                AuctionandListingHeight = 0
                TimerHeight = 50
                
                viewButton.Bid_Now_Btn.isEnabled = true
                viewButton.Bid_Now_Btn.backgroundColor = UIColor.black
                
                self.Days.isHidden = false
                
                self.Daytxtlbl.isHidden = false
                
                self.Hourtxtlbl.isHidden = false
                
                self.Hourslbl.isHidden = false
                
                self.Mintxtlbl.isHidden = false
                
                self.Minlbl.isHidden = false
                
                self.Seclbltxt.isHidden = false
                
                self.secondslbl.isHidden = false
                
                let endTimeInterval:TimeInterval = TimeInterval(selectedProduct!.endTime )
                
                //Convert to Date
                let endDate = Date(timeIntervalSince1970: Double(endTimeInterval) / 1000)
                
                //Difference between servertime and endtime
                
                let calendar = NSCalendar.current as NSCalendar
                
                let unitFlags = NSCalendar.Unit([.day,.hour,.minute,.second])
                
                var components = calendar.components(unitFlags, from: Date(), to: endDate )
                
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
                            
                            if SessionManager.shared.userId == selectedProduct!.uid {
                                
                                self.EndlistingBtn.isHidden = true
                                
//                                self.EndlistHeight.constant = 0
                                
                                self.RelistItem.isHidden = false
                                
//                                self.RelistItemHeight.constant = 50
                                
                                if tableView.tag == 13 {
                                    
                                    tableView.estimatedRowHeight = 0
                                    
                                }
                                
                            }
                            
                            if selectedProduct!.itemAuctionType == "reserve" || selectedProduct!.itemAuctionType == "non-reserve" {
                                
                                viewButton.Bid_Now_Btn.isEnabled = false
                                
                                viewButton.Bid_Now_Btn.backgroundColor = UIColor.gray
                                
                                TimerHeight = 0
                                
                                AuctionandListingHeight = 50
                                
                            }else {
                                
                                viewButton.Buy_Now_Btn.isEnabled = false
                                
                                viewButton.Buy_Now_Btn.backgroundColor = UIColor.gray
                                
                                TimerHeight = 0
                                
                                AuctionandListingHeight = 50
                                
                            }
                            
                            tableView.reloadUsingDispatch()
                            
                        }else {
                            
                            if SessionManager.shared.userId == selectedProduct!.uid {
                                
                                self.EndlistingBtn.isHidden = false
                                
//                                self.EndlistHeight.constant = 50
                                
                                self.RelistItem.isHidden = true
                                
//                                self.RelistItemHeight.constant = 0
                                
                            }
                            
                        }
                        
                        
                        if ((selectedProduct?.OrderArray.isEmpty)!) {
                            viewButton.Buy_Now_Btn.isEnabled = true
                            self.viewButton.Buy_Now_Btn.backgroundColor = UIColor.black
                            viewButton.Offer_Now_Btn.isEnabled = true
                            self.viewButton.Offer_Now_Btn.backgroundColor = UIColor.black
                        }else{
                            viewButton.Buy_Now_Btn.isEnabled = false
                            self.viewButton.Buy_Now_Btn.backgroundColor = UIColor.gray
                            viewButton.Offer_Now_Btn.isEnabled = false
                            self.viewButton.Offer_Now_Btn.backgroundColor = UIColor.gray
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
    
    var timer:Timer?
    
    @objc func ChatWithSeller() {
        
        MainAPi.Get_Chat(buyer_uid: SessionManager.shared.userId, item_id: selectedProduct!.itemKey, start: 0, limit: 15) { (status, data, error) in
            
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
                
                let msgnewdata = ChatMessageList.init(read: false, delivered_time: 0, created_at: 0, buyer_uid: SessionManager.shared.userId, message: "", itemCategory: self.selectedProduct!.itemCategory, sender_uid: SessionManager.shared.userId, item_id: self.selectedProduct!.id, item_price: self.selectedProduct!.startPrice, sender: SessionManager.shared.name, itemAuctionType: self.selectedProduct!.itemAuctionType, receiver_uid: self.selectedProduct!.uid, images_small_path: self.selectedProduct!.ItemImages.last!, delivered: false, seller_uid: self.selectedProduct!.uid, id: self.selectedProduct!.id, images_path: self.selectedProduct!.ItemImages.last!, title: self.selectedProduct!.title, receiver: self.UserName.text!, role: "buyer", iserror: false)
                
                
                
                print("Itemimages == \(msgnewdata.images_path)")
                
                print("UserID == \(SessionManager.shared.userId)")
                
                self.ChatMessage.append(msgnewdata)
                
                
                
                let storyboard = UIStoryboard.init(name: "chat", bundle: nil)
                
                let controller = storyboard.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogVC
                
                controller.ChatMesssage = self.ChatMessage
                
                controller.movetochat = true
                
                self.navigationController?.pushViewController(controller, animated: true)
                
            }
            
        }
        
    }
    
    
    
    
    
    @objc func WatchingFunc() {
        
        if self.WatchBtn.titleLabel!.text == "Remove from Watch List" {
            
            MainAPi.UnWatch_Item(uid: SessionManager.shared.userId, itemid: selectedProduct!.itemKey) { (status, data, error) in
                
                print("remove from Watchlist")
                
                if status {
                    
                    self.WatchBtn.setTitle("Add to Watch List", for: .normal)
                    
                    self.WatchBtn.setImage(UIImage(named: "ic_watch"), for: .normal)
                    
                    self.Watchimg.image = UIImage(named: "ic_watch")
                    
                    
                    
                    showSwiftMessageWithParams(theme: .info, title: "Item Watched" , body: data!["message"].stringValue)
                    
                }else {
                    
                    showSwiftMessageWithParams(theme: .info, title: "ERROR".localizableString(loc: LanguageChangeCode) , body: data!["message"].stringValue)
                    
                }
                
                
                
            }
            
        }else {
            
            MainAPi.Watch_Item(uid: SessionManager.shared.userId, itemid: selectedProduct!.itemKey) { (status, data, error) in
                
                print("Add to Watchlist")
                
                if status {
                    
                    self.WatchBtn.setTitle("Remove from Watch List", for: .normal)
                    
                    self.WatchBtn.setImage(UIImage(named: "ic_unwatch"), for: .normal)
                    
                    self.Watchimg.image = UIImage(named: "ic_unwatch")
                    
                    showSwiftMessageWithParams(theme: .info, title: "Item Watched" , body: data!["message"].stringValue)
                    
                }else {
                    
                    showSwiftMessageWithParams(theme: .info, title: "ERROR".localizableString(loc: LanguageChangeCode) , body: data!["message"].stringValue)
                    
                }
                
                
                
            }
            
        }
        
        
        
    }
    
    
    
    @objc func shareaction() {
        
        let textToShare = "Check out this item that i found on The Sell4Bids Marketplace.".localizableString(loc: LanguageChangeCode)
        let cat = selectedProduct!.itemCategory
        let auction = selectedProduct!.itemAuctionType
        let state =  selectedProduct!.state
        let prodId = selectedProduct!.itemKey
        guard let catEncoded = cat.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        var urlString = "https://www.sell4bids.com/item?cat=\(catEncoded)"
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
    
    
    
    
    
    
    
    @objc func MovetoHome() {
        
        navigationController!.popViewController(animated: true)
        
        
        
    }
    //MARK:- Action
    //SellerCounterOfferWorking & Implementation.
    //ObjectCreated:
    let ShowSellerCounteOffer = Bundle.main.loadNibNamed("ShowSellerCounterOffer", owner: self, options: nil)?.first as! SellerCounerOffer
    
    let ShowSellerCounteOffer_View = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    //FunctionCalling For SellerCounterOfferWorking:
    @objc func SellerCounterOffer(){
        ShowSellerCounteOffer_View.view.frame = ShowSellerCounteOffer.frame
        ShowSellerCounteOffer_View.view.addSubview(ShowSellerCounteOffer)
        self.present(ShowSellerCounteOffer_View, animated: true, completion: nil)
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
        SendCounterOfferAlert.dismiss(animated: true, completion: nil)
    }
    
    
    //CounterOfferCloseButton:
    @objc func CloseButton(){
        
        
    }
    
    @objc func actionClose(sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func showItemData() {
        CollectionView.reloadData()
        if (selectedProduct?.admin_verify.contains("pending"))!{
            
            BidsBtn.isEnabled = false
            OrderBtn.isEnabled = false
            ViewOrders_ViewOfferBtn.isEnabled = false
            viewButton.isHidden = true
            shareimg.isUserInteractionEnabled = false
            Watchimg.isUserInteractionEnabled = false
            WatchBtn.isEnabled = false
            ShareBtn.isEnabled = false
            
        }
        
        if (selectedProduct?.admin_verify.contains("rejected"))!{
            
            BidsBtn.isEnabled = false
            OrderBtn.isEnabled = false
            ViewOrders_ViewOfferBtn.isEnabled = false
            viewButton.isHidden = true
            shareimg.isUserInteractionEnabled = false
            Watchimg.isUserInteractionEnabled = false
            WatchBtn.isEnabled = false
            ShareBtn.isEnabled = false
            
        }
               
               if SessionManager.shared.userId.contains(selectedProduct!.uid) {
                   
                   Watchimg.isHidden = true
                   watchListConstraint.constant = 0
                   self.viewButton.isHidden = true
                   
               }else{
                   self.viewButton.isHidden = false
                   watchListConstraint.constant = 35
               }
        
        if selectedProduct!.quantity <= 0  {
            
            self.viewButton.Buy_Now_Btn.isEnabled = false
            
            self.viewButton.Buy_Now_Btn.backgroundColor = UIColor.gray
            
            self.viewButton.Offer_Now_Btn.isEnabled = false
            
            self.viewButton.Offer_Now_Btn.backgroundColor = UIColor.gray
            
        }
        
        if selectedProduct!.chargeTime != nil {
            
            //print("time  is not nil")
            
            let startTime:TimeInterval = Double(selectedProduct!.chargeTime)
            
            let miliToDate = Date(timeIntervalSince1970:startTime/1000)
            
            let calender  = NSCalendar.current as NSCalendar
            
            let unitflags = NSCalendar.Unit([.day,.hour,.minute,.second,.month,.year])
            
            let diffDate = calender.components(unitflags, from:miliToDate, to: Date())
            
            if let days = diffDate.day, let hours = diffDate.hour, let minutes = diffDate.minute, let seconds = diffDate.second, let months = diffDate.month, let year = diffDate.year  {
                if year == 1 {
                   postedTimeLabel.text = "\(year) year ago."
                }
                else if year > 1 {
                   postedTimeLabel.text = "\(year) years ago."
                }
                else if months == 1 {
                    
                    postedTimeLabel.text = "\(months) month ago."
                    
                }
                else if months > 1 {
                    
                    postedTimeLabel.text = "\(months) months ago."
                    
                }
                    
                else if days == 1{
                    postedTimeLabel.text = "\(days) day ago."
                }
                    
                else if days > 1 {
                    
                    postedTimeLabel.text = "\(days) days ago."
                    
                }
                    
                else if  hours < 24 && hours > 1{
                    
                    
                    
                    postedTimeLabel.text = "\(hours) hours ago."
                    
                }
                    
                else if minutes < 60 && minutes > 1 {
                    
                    postedTimeLabel.text = "\(minutes) minutes ago."
                    
                }
                    
                else if seconds < 60 && seconds > 1{
                    
                    postedTimeLabel.text = "\(seconds) seconds ago."
                    
                }
                
                
                
            }
            
        }else {
            
            postedTimeLabel.text = "NA"
            
            print("time is nil")
            
        }
        
        if TimerHeight == 0 {
                   
                   AuctionandListingHeight = 50
                   
               }else {
                   
                   TimerHeight = 50
                   
               }
        
        navigationbar.ItemTitle.text = self.selectedProduct!.title
        
        if selectedProduct!.watchBool {
                   
                   self.WatchBtn.setTitle("Remove from Watch List", for: .normal)
                   
                   self.WatchBtn.setImage(UIImage(named: "ic_unwatch"), for: .normal)
                   
                   self.Watchimg.image = UIImage(named: "ic_unwatch")
                   
               }else {
                   
                   self.WatchBtn.setTitle("Add to Watch List", for: .normal)
                   
                   self.WatchBtn.setImage(UIImage(named: "ic_watch"), for: .normal)
                   
                   self.Watchimg.image = UIImage(named: "ic_watch")
                   
               }
               
               if ((selectedProduct?.OrderArray.isEmpty)!) {
                   viewButton.Buy_Now_Btn.isEnabled = true
                   self.viewButton.Buy_Now_Btn.backgroundColor = UIColor.black
                   viewButton.Offer_Now_Btn.isEnabled = true
                   self.viewButton.Offer_Now_Btn.backgroundColor = UIColor.black
                   
               }else{
                   viewButton.Buy_Now_Btn.isEnabled = false
                   self.viewButton.Buy_Now_Btn.backgroundColor = UIColor.gray
                   viewButton.Offer_Now_Btn.isEnabled = false
                   self.viewButton.Offer_Now_Btn.backgroundColor = UIColor.gray
                   
               }
               
               if selectedProduct?.OrderArray.last?.OfferArray.last?.role == "seller" {
                   self.viewButton.Offer_Now_Btn.backgroundColor = UIColor.gray
                   self.viewButton.Offer_Now_Btn.isEnabled = false
                   if selectedProduct?.OrderArray.last?.OfferCount == 5 {
                       showSwiftMessageWithParams(theme: .info, title: "Counter Offer", body: "You exceed the limit of counter offer.")
                   }else {
                       ShowSellerCounteOffer_View.view.frame = ShowSellerCounteOffer.frame
                       ShowSellerCounteOffer_View.view.addSubview(ShowSellerCounteOffer)
                       self.present(ShowSellerCounteOffer_View, animated: true, completion: nil)
                   }
                   
                   
               }else {
                   self.viewButton.Offer_Now_Btn.backgroundColor = UIColor.black
                   self.viewButton.Offer_Now_Btn.isEnabled = true
               }
               
               let offerPrice = selectedProduct?.OrderArray.last?.OfferArray.last?.price ?? ""
               let offerQuantity = selectedProduct?.OrderArray.last?.OfferArray.last?.quantity ?? ""
               let currencyString = selectedProduct?.currency_string ?? ""
               
               let finalStringToShow = "You recieved counter offer for check Item.\n Seller is ready to sell \(offerQuantity) item(s) at \(currencyString) \(offerPrice)"
               ShowSellerCounteOffer.textLabel.text = finalStringToShow
               GetUserDetails(uid: selectedProduct!.uid)
               
               
               
               
               
               visibility = selectedProduct!.visibility
               orderingstatus = selectedProduct!.ordering_status
               print("selected product = \(selectedProduct!.itemAuctionType)")
               
               if selectedProduct!.itemAuctionType.contains("buy-it-now") {
                   
                   self.viewButton.Offer_Now_Btn.isHidden = false
                   self.viewButton.Buy_Now_Btn.isHidden = false
                   self.viewButton.Chat_Now_Btn.isHidden = false
                   self.viewButton.Bid_Now_Btn.isHidden = true
                   
                   if selectedProduct!.ordering {
                       
                       self.viewButton.Buy_Now_Btn.isHidden = false
                       
                   }else {
                       
                       self.viewButton.Buy_Now_Btn.isHidden = true
                       
                   }
                   
                   
                   
                   
                   
                   if selectedProduct!.acceptOffers {
                       
                       self.viewButton.Offer_Now_Btn.isHidden = false
                       
                   }else {
                       
                       self.viewButton.Offer_Now_Btn.isHidden = true
                       
                   }
                   
               }else {
                   
                   self.viewButton.Bid_Now_Btn.isHidden = false
                   
                   self.viewButton.Chat_Now_Btn.isHidden = false
                   
                   self.viewButton.Buy_Now_Btn.isHidden = true
                   
                   self.viewButton.Offer_Now_Btn.isHidden = true
                   
                   
                   
               }
               
               if self.orderingstatus! {
                   
                   self.GetNewOrders.setTitle("Stop New Orders", for: .normal)
                   
                   self.GetNewOrders.setTitleColor(UIColor.black, for: .normal)
                   
                   
                   
                   self.GetNewOrders.backgroundColor = UIColor.white
                   
                   
                   
               }else {
                   
                   self.GetNewOrders.setTitle("Get New Orders", for: .normal)
                   
                   self.GetNewOrders.setTitleColor(UIColor.white, for: .normal)
                   
                   
                   
                   self.GetNewOrders.backgroundColor = UIColor.black
                   
               }
               
               
               
               if visibility == true {
                   
                   ShowItemBtn.setTitle("Hide Item", for: .normal)
                   
                   ShowItemBtn.backgroundColor = UIColor.white
                   
                   ShowItemBtn.setTitleColor(UIColor.black, for: .normal)
                   
                   
                   
               }else {
                   
                   ShowItemBtn.setTitle("Show Item", for: .normal)
                   
                   ShowItemBtn.backgroundColor = UIColor.black
                   
                   ShowItemBtn.setTitleColor(UIColor.white, for: .normal)
                   
               }
        let country = selectedProduct?.country_code.uppercased()
        print("ItemDetail_country == \(country!)")
        let Detail_Currency_Symbol = CurrencyManager.instance.getCurrencySymbol(Country: country ?? "USA")
        print("Detail_Currency_Symbol == \(Detail_Currency_Symbol)")
        StartPrice.text = "  " + Detail_Currency_Symbol + "" + (selectedProduct?.startPrice.description)!
        print("StartPrice == \(StartPrice.text!)")
        
        
        Item_Title_txt.text = selectedProduct?.title
        Item_Category_txt.text = selectedProduct?.itemCategory
        
        if selectedProduct!.quantity == 0 {
            Item_Quantity.text = "Out of stock"
            viewButton.Offer_Now_Btn.backgroundColor = UIColor.lightGray
            viewButton.Buy_Now_Btn.backgroundColor = UIColor.lightGray
        }else{
            Item_Quantity.text = "\(selectedProduct!.quantity) Available"
            viewButton.Offer_Now_Btn.backgroundColor = UIColor.black
            viewButton.Buy_Now_Btn.backgroundColor = UIColor.black
        }
        Item_Description_lbl.text = selectedProduct!.description
        
        var address = ""
        if (selectedProduct?.city != nil) && !(selectedProduct?.city == ""){
            address += selectedProduct!.city
        }
        if (selectedProduct?.state != nil) && !(selectedProduct?.state == ""){
            address += ", " + selectedProduct!.state
        }
        if (selectedProduct?.zipcode != nil) && !(selectedProduct?.zipcode == ""){
            address += ", " + selectedProduct!.zipcode
        }
        
        Item_City_lbl.text = ("\(address)")
        
        Item_condition_lbl.text = selectedProduct!.condition
        print("Longtitude == \(selectedProduct!.longtitude)")
        print("Latitude == \(selectedProduct!.latitude)")
        
        cordinates.latitude = selectedProduct!.latitude
        cordinates.longitude = selectedProduct!.longtitude
        print("item lat ==\(selectedProduct!.latitude ), item long == \(selectedProduct!.longtitude)")
        self.Item_Map_View.delegate = self
        self.Item_Map_View.isUserInteractionEnabled = false
        ItemImages = (self.selectedProduct?.ItemImages)!
               
        Title = (self.selectedProduct?.description)!
        
        cordinates.latitude = selectedProduct!.latitude
               
               cordinates.longitude = selectedProduct!.longtitude
               
               print("item lat ==\(selectedProduct!.latitude ), item long == \(selectedProduct!.longtitude)")
               
               self.Item_Map_View.delegate = self
               
               
               let  circleCenter = CLLocationCoordinate2D(latitude: cordinates.latitude, longitude: cordinates.longitude)
               
               cirlce = GMSCircle(position: circleCenter, radius: 500)
               cirlce.fillColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 250.0/255.0, alpha:1.0)
               cirlce.map = Item_Map_View
        updateTimer(currentTime: nil)
               
               DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                   
                   self.tableView.reloadUsingDispatch()
                   
               }
               
               self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(currentTime: )), userInfo: nil, repeats: true)
        if SessionManager.shared.userId.contains(self.selectedProduct!.uid) {
                   
                   viewButton.removeFromSuperview()
                   
               }
    }
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        showItemData()
        
        StartPrice.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        StartPrice.layer.shadowRadius = 2.0
        StartPrice.layer.shadowOpacity = 1.0
        StartPrice.layer.shadowOffset = CGSize(width: 0, height: 1)
        StartPrice.layer.masksToBounds = false
        
        crossNavigationBtn.layer.cornerRadius = 15
        crossNavigationBtn.layer.masksToBounds = true
        crossNavigationBtn.addTarget(self, action: #selector(actionClose(sender:)), for: .touchUpInside)
        crossNavigationBtn.shadowView()
        
        self.CollectionView.allowsMultipleSelection = false
        self.CollectionView.allowsSelection = true
        Endlisting_Item.RadioImg6.image = UIImage(named: "radioOn")
        Report_Item_View.ReportImg6.image = UIImage(named: "radioOn")
        
        ShowSellerCounteOffer.rejectBtn.addTarget(self, action: #selector(rejectOfferBuyerBtnTapped(sender:)), for: .touchUpInside)
        
        list1 = ["3 Days","5 Days","7 Days","10 Days", "15 Days","21 Days","30 Days"]
        list2 = ["PKR","USD","EUR","INR","BST"]
        
        Relist_Item.Quantitytxt.delegate = self
        
        selectCreatePicker(textField: Relist_Item.Quantitytxt, tag: 1)
        createToolBar(textField: Relist_Item.Quantitytxt)
        EndlistingBtn.addShadowAndRound()
        
        self.MoveToSellerBtn.isEnabled = false
        
        let sharebtn = UITapGestureRecognizer()
        
        sharebtn.addTarget(self, action: #selector(shareaction))
        
        shareimg.addGestureRecognizer(sharebtn)
        
        shareimg.isUserInteractionEnabled = true
        
        
        let watchimgGesture = UITapGestureRecognizer()
        
        watchimgGesture.addTarget(self, action: #selector(WatchingFunc))
        
        
        
        Watchimg.addGestureRecognizer(watchimgGesture)
        
        Watchimg.isUserInteractionEnabled = true
        
        
        self.viewButton.Chat_Now_Btn.addTarget(self, action: #selector(ChatWithSeller), for: .touchUpInside)
        
        
        
        navigationbar.MovetoHome.addTarget(self, action: #selector(MovetoHome), for: .touchUpInside)
        
        navigationbar.HomeBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        
        navigationbar.BackBtn.addShadow()
        navigationbar.ItemTitle.addShadow()
        navigationbar.HomeBtn.addShadow()
        
       
        
        ShowSellerCounteOffer.acceptBtn.addTarget(self, action: #selector(AcceptOfferBtnTapped(sender:)), for: .touchUpInside)
        
        ShowSellerCounteOffer.counterOfferBtn.addTarget(self, action: #selector(counterOfferBtnTapped(sender:)), for: .touchUpInside)
        
        socket?.on(clientEvent: .connect) {data, ack in
            
            print("socket connected")
            
            socket?.emitWithAck("chat_message", "Ahmed").timingOut(after: 0) {data in
                
                socket?.emit("chat_message", "Ahmed" )
                
            }
        }
        
        socket?.on("notifications") {data, ack in
            
            var message = String()
            
            var dictonary:NSDictionary?
            
            let stringnewdata = data.last! as! NSDictionary
            
            let data = stringnewdata["notification"] as! NSDictionary
            
            let datanoti = stringnewdata["data"] as! NSDictionary
            
            message = data["body"] as! String
            
            let title = data["title"] as! String
            
            //            let identifiernew = datanoti["notificationType"] as! String
            
            //            self.itemid = datanoti["item_id"] as! String
            //
            //            item_id = datanoti["item_id"] as! String
            
            let identifier = ""
            
            let newdata = JSON(data)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let content = UNMutableNotificationContent() // Содержимое уведомления
            
            _ = newdata["notification"]
            
            
            
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
            
            print("Socket Ahmed == \(data)")
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        Get_time()
        
       
        
        
        
//        print("User ID == \(SessionManager.shared.userId) , Item User ID =\(self.selectedProduct!.uid)")
        
        
       
        
        
        
        
        
        
        
        ChangeBtnStyle(Button: AcceptOffers)
        
        ChangeBtnStyle(Button: GetNewOrders)
        
        ChangeBtnStyle(Button: RelistItem)
        
        ChangeBtnStyle(Button: AutomaticRelist)
        
        ChangeBtnStyle(Button: TurboCharge)
        
        ChangeBtnStyle(Button: SetStockQuantity)
        
        ChangeBtnStyle(Button: ShowItemBtn)
        ChangeBtnStyle(Button:ViewOrders_ViewOfferBtn)
        ChangeBtnStyle(Button: OrderBtn)
        ChangeBtnStyle(Button: BidsBtn)
        
        navigationbar.BackBtn.addTarget(self, action: #selector(Back_btn), for: .touchUpInside)
        
        self.navigationController?.navigationBar.isHidden = true
        
        let imageView = UIImageView()
        let framYposition = UIDevice.isMedium ? 20 : 50
        navigationbar.frame = CGRect.init(x: 0, y: framYposition, width: Int(UIScreen.main.bounds.width), height: 50)
        
        navigationbar.backgroundColor = UIColor.clear
        viewButton.frame = CGRect.init(x: 0, y: self.view.frame.maxY - 50 , width: UIScreen.main.bounds.width, height: 50)
        
        viewButton.Buy_Now_Btn.isUserInteractionEnabled = true
        
        viewButton.Buy_Now_Btn.addTarget(self, action: #selector(Buy_Now), for: .touchUpInside)
        
        viewButton.Offer_Now_Btn.addTarget(self, action: #selector(Offer_Now), for: .touchUpInside)
        
        viewButton.Bid_Now_Btn.addTarget(self, action: #selector(Bid_Now), for: .touchUpInside)
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
                itemHeight = 350
            }
            else if UIDevice.current.model.contains("iPad") {
                itemHeight =  450
            }
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
        
       
        
    }
    
    
    
    
    
    @IBAction func MovetoUserDetails(_ sender: Any) {
        
        print("Clicked on User Details.")
        
        let storyboard = UIStoryboard.init(name: "UserDetails", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
        
        controller.sellerDetail = self.UserDetail
        
        controller.title = self.UserDetail?.name ?? "Sell4Bid User"
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !SessionManager.shared.userId.contains(self.selectedProduct?.uid ?? "") {
            
            if indexPath.section == 0 {
                
                if UIDevice.current.model.contains("iPhone") {
                    
                    return 350
                    
                }else {
                    
                    return 450
                    
                }
                
            }else if indexPath.section == 1 {
                
                return 60
                
            }else if indexPath.section == 2 {
                
                return 0
                
            }else if indexPath.section == 3 {
                
                return 0
                
            }else if indexPath.section == 4 {
                
                return TimerHeight
                
            }else if indexPath.section == 5 {
                
                if (selectedProduct?.admin_verify.contains("pending")) ?? false{
                    ListedByYou.text = "This Item listing is pending for the approval from Admin."
                    return 50
                }
                else if (selectedProduct?.admin_verify.contains("rejected")) ?? false{
                    ListedByYou.text = "This Item listing is rejected for the approval from Admin."
                    return 50
                }else{
                    ListedByYou.text = "Listed By You"
                    return 0
                }
                
                
            }else if indexPath.section == 6 {
                
                return AuctionandListingHeight
                
            }else if indexPath.section == 7 {
                 return tableView.estimatedRowHeight
            }else if indexPath.section == 8 {
                return 100
            }else if indexPath.section == 9 {
                if selectedProduct?.itemAuctionType ?? "" == "reserve" || selectedProduct?.itemAuctionType ?? "" == "non-reserve" {
                    
                    return 0
                    
                }else {
                    
                    return 50
                    
                }
               
                
            }else if indexPath.section == 10 {
                
                if SessionManager.shared.userId == selectedProduct?.uid ?? "" {
                    
                    return 0
                    
                }else {
                    
                    return tableView.rowHeight
                    
                }
                
            }else if indexPath.section == 11{
                
                return 60
                
            }else if indexPath.section == 12 {
                
                let GMSCameraPos = GMSCameraPosition.init(latitude: cordinates.latitude, longitude: cordinates.longitude, zoom: 14)
                
                self.Item_Map_View.camera = GMSCameraPos
                
                return 300
                
            }else if indexPath.section == 13 {
                
                return 50
                
            }else if indexPath.section == 14 {
                
                return 0
                
            }else {
                
                return 50
                
            }
            
        }
        else if SessionManager.shared.userId.contains(self.selectedProduct?.uid ?? "") && self.selectedProduct?.itemAuctionType ?? "" == "reserve" || self.selectedProduct?.itemAuctionType ?? "" == "non-reserve"{
            
            if indexPath.section == 0 {
                
                if UIDevice.current.model.contains("iPhone") {
                    
                    return 300
                    
                }else {
                    
                    return 450
                    
                }
                
            }else if indexPath.section == 1 {
                
                return 60
                
            }else if indexPath.section == 2 {
                
                return 0
                
            }else if indexPath.section == 3 {
                
                return 60
                
            }else if indexPath.section == 4 {
                
                return 50
                
            }else if indexPath.section == 5 {
                
                if (selectedProduct?.admin_verify.contains("pending"))!{
                    ListedByYou.text = "This Item listing is pending for the approval from Admin."
                    return 50
                }
                else if (selectedProduct?.admin_verify.contains("rejected"))!{
                    ListedByYou.text = "This Item listing is rejected for the approval from Admin."
                    return 50
                }else{
                    ListedByYou.text = "Listed By You"
                    return 50
                }
                
            }
            else if indexPath.section == 6 {
                
                return AuctionandListingHeight
                
            }else if indexPath.section == 7 {
                 return tableView.rowHeight
               
                
            }else if indexPath.section == 8 {
                 return 100
                
                
            }else if indexPath.section == 9 {
                if selectedProduct?.itemAuctionType ?? "" == "reserve" || selectedProduct?.itemAuctionType ?? "" == "non-reserve"{
                    print("ItemAuctionType == 1")
                    return 0
                }else{
                    return 50
                }
               
                
            }else if indexPath.section == 10 {
                
                return 0
                
            }else if indexPath.section == 11 {
                
                return 60
                
            }else if indexPath.section == 12 {
                
                let GMSCameraPos = GMSCameraPosition.init(latitude: cordinates.latitude, longitude: cordinates.longitude, zoom: 14)
                
                self.Item_Map_View.camera = GMSCameraPos
                
                return 300
                
            }else if indexPath.section == 13 {
                
                
                return 50
                
                
            }else if indexPath.section == 14 {
                
                if (selectedProduct?.admin_verify.contains("pending"))! ||  (selectedProduct?.admin_verify.contains("rejected"))!{
                    
                    return 0
                    
                }else{
                
                if indexPath.row == 2 {
                    
                    if selectedProduct?.itemAuctionType ?? "" == "reserve" || selectedProduct?.itemAuctionType ?? "" == "non-reserve"{
                        print("itemAuctionType == 2")
                        return 0
                    }else{
                        return 50
                    }
                    
                }
                
                if selectedProduct!.endTime - currenttime <= -1 {
                    
                    if indexPath.row == 7 {
                        
                        return 0
                        
                    }
                    
                    if indexPath.row == 4 {
                        
                        return 50
                        
                    }
                    
                }else {
                    
                    if indexPath.row == 7 {
                        
                        return 50
                        
                    }
                    
                    if indexPath.row == 4 {
                        
                        return 0
                        
                    }
                    
                }
                }
            }else {
                
                return 50
                
            }
            
        }
        else {
            
            if indexPath.section == 0 {
                
                if UIDevice.current.model.contains("iPhone") {
                    
                    return 300
                    
                }else {
                    
                    return 450
                    
                }
                
            }else if indexPath.section == 1 {
                
                return 60
                
            }else if indexPath.section == 2 {
                
                return 55
                
            }else if indexPath.section == 3 {
                
                return 0
                
            }else if indexPath.section == 4 {
                
                
                
                return 50
                
            }else if indexPath.section == 5 {
                
                
                if (selectedProduct?.admin_verify.contains("pending"))!{
                    ListedByYou.text = "This Item listing is pending for the approval from Admin."
                    return 50
                }
                else if (selectedProduct?.admin_verify.contains("rejected"))!{
                    ListedByYou.text = "This Item listing is rejected for the approval from Admin."
                    return 50
                }else{
                    ListedByYou.text = "Listed By You"
                    return 0
                }
                
            }
            else if indexPath.section == 6 {
                
                return AuctionandListingHeight
                
            }
            else if indexPath.section == 7 {
                
                return 100
                
            }
            else if indexPath.section == 8 {
                if selectedProduct?.itemAuctionType ?? "" == "reserve" || selectedProduct?.itemAuctionType ?? "" == "non-reserve"{
                    print("ItemAuctionType == 1")
                    return 0
                }else{
                    return 50
                }
            }
            else if indexPath.section == 9 {
                
                return 0
                
            }
            else if indexPath.section == 10 {
                
                return tableView.rowHeight
                
            }
            else if indexPath.section == 11 {
                
                return 60
                
            }
            else if indexPath.section == 12 {
                
                let GMSCameraPos = GMSCameraPosition.init(latitude: cordinates.latitude, longitude: cordinates.longitude, zoom: 14)
                
                self.Item_Map_View.camera = GMSCameraPos
                
                return 300
                
            }else if indexPath.section == 13 {
                
                return 50
                
            }else if indexPath.section == 14 {
                
                if (selectedProduct?.admin_verify.contains("pending"))! ||  (selectedProduct?.admin_verify.contains("rejected"))!{
                    
                    return 0
                    
                }else{
                
                if indexPath.row == 2 {
                    
                    if selectedProduct?.itemAuctionType ?? "" == "reserve" || selectedProduct?.itemAuctionType ?? "" == "non-reserve"{
                        print("itemAuctionType == 2")
                        return 0
                    }else{
                        return 50
                    }
                }
                
                if selectedProduct?.endTime ?? 0 - currenttime <= -1 {
                    
                    if indexPath.row == 7 {
                        
                        return 0
                        
                    }
                    
                    if indexPath.row == 4 {
                        
                        return 50
                        
                    }
                    
                }else {
                    
                    if indexPath.row == 7 {
                        
                        return 50
                        
                    }
                    
                    if indexPath.row == 4 {
                        
                        return 0
                        
                    }
                    
                }
                }
            }else {
                
                return 50
                
            }
            
        }
        
        
        
        return 50
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowOrdersandOffers" {
            
        }
        
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
            
        }else {
            
            UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                
                
                
                self.navigationbar.ItemTitle.isHidden = true
                
                self.navigationbar.backgroundColor =  UIColor.clear
                
            }, completion: nil)
            
        }
        
    }
    
}





extension ItemDetailsTableView: UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (pickerView.tag == 1) {
            return list1.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (pickerView.tag == 1){
            return list1[row]
        }
        return list1[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1)
        {
            Relist_Item.Quantitytxt.text = list1[row]
            let days = list1[row].split(separator: " ")
            self.selected_date = Int(days[0])!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label : UILabel
        
        if let view = view as? UILabel{
            label = view
        }
        else{
            label = UILabel()
        }
        label.textColor = .black
        
        label.textAlignment = .center
        
        
        if (pickerView.tag == 1) {
            label.text = list1[row]
        }
        return label
    }
    
    
    
    func selectCreatePicker(textField: UITextField, tag: Int){
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
        print("doneBtn==\(doneBtn)")
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        toolBar.tintColor = UIColor.red
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func handleDone()
    {
        Relist_Item.Quantitytxt.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField.tag == 1 || textField.tag == 2{
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
