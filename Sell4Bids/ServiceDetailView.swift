//

//  ServiceDetailView.swift
//  Sell4Bids
//  Created by Admin on 04/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//



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



class ServiceDetailView: UITableViewController,UICollectionViewDelegate , UICollectionViewDataSource , UITextFieldDelegate, GMSMapViewDelegate , UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var watchListConstraint: NSLayoutConstraint!
    @IBOutlet weak var EndlistingBtn: UIButton!
    @IBOutlet weak var MoveToSellerBtn: UIButton!
    @IBOutlet weak var crossNavigationBtn: UIButton!
    
    var list1 = [String]()
    var selected_date = Int()
    var itemid = String()
    lazy var orderArray = [orderModel]()
    lazy var offerArray = [offerModel]()
    
    
    let RejectOfferView = Bundle.main.loadNibNamed("Reject_Order_View", owner: self, options: nil)?.first as! RejectedOrderView
    var RejectOfferViewAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    var SendCounterOffer = Bundle.main.loadNibNamed("OfferNow_Custom_View", owner: self, options: nil)?.first as! OfferNowCustomView
    var SendCounterOfferAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    let ShowSellerCounteOffer = Bundle.main.loadNibNamed("ShowSellerCounterOffer", owner: self, options: nil)?.first as! SellerCounerOffer
    
    let ShowSellerCounteOffer_View = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
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
                                 "item_id":selectedProduct_Service?.id ?? "",
                                 "order_id":selectedProduct_Service?.OrderArray.last?.orderId ?? ""]
        CallAcceptBuyerOfferApiCall(body: body)
    }
    
    
    @objc func submitReasonTapped(sender: UIButton){
        
        let body:[String: Any] = [ "buyer_name":SessionManager.shared.name,
                                   "buyer_image":SessionManager.shared.image,
                                   "buyer_uid": SessionManager.shared.userId,
                                   "item_id":selectedProduct_Service?.id ?? "",
                                   "order_id":selectedProduct_Service?.OrderArray.last?.orderId ?? "",
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
                "seller_uid": selectedProduct_Service?.OrderArray.last?.sellerId ?? "",
                "buyer_uid": SessionManager.shared.userId ,
                "product_image":"",
                "offer_price": SendCounterOffer.AmountPerItemtxt.text!,
                "item_id": selectedProduct_Service?.OrderArray.last?.orderId ?? ""   ,
                "offer_quantity": SendCounterOffer.Quantitytxt.text!,
                "product_title": selectedProduct_Service?.title ?? "",
                "buyer_name":SessionManager.shared.name,
                "product_category": selectedProduct_Service?.itemCategory ?? "",
                "product_auction_type":selectedProduct_Service?.itemAuctionType ?? "",
                "product_state": selectedProduct?.state ?? "",
                "buyer_image":SessionManager.shared.image ,
                "offer_count": selectedProduct_Service?.OrderArray.last?.OfferCount ?? "",
                "order_id": selectedProduct_Service?.OrderArray.last?.orderId ?? ""
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
    
    
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        
        return UIColor(
            
            red: CGFloat((rgbValue & 0x000000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x000000) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x000000) / 255.0,
            alpha: CGFloat(1.0)
            
        )
        
    }
    
    
    var sellerId : String?
    var itemId : String?
    
    
    func reloadData(){
        
        
        
        self.MainAPi.Item_Details(uid: SessionManager.shared.userId, country: "", seller_uid: self.sellerId ?? "", item_id: self.itemId ?? "") { (status, response, error) in
            if status {
                for message in response!["message"] {
                    let itemCategory = message.1["itemCategory"].stringValue
                    let startPrice = message.1["servicePrice"].intValue
                    let visibility = message.1["visibility"].boolValue
                    let image_0 = message.1["images_small_path"]
                    var image_array = [String]()
                    for image in image_0 {
                        image_array.append(image.1.stringValue)
                    }
                    let chargeTime = message.1["chargeTime"].int64Value
                    let token = message.1["token"].stringValue
                    let description = message.1["description"].stringValue
                    let uid = message.1["uid"].stringValue
                    _ = response!["watching"].boolValue
                    let itemKey = message.1["_id"].stringValue
                    let loc = message.1["loc"]
                    _ = loc["coordinates"]
                    let id = message.1["_id"].stringValue
                    var watch_uid = String()
                    var watch_token = String()
                    var ItemimagesArr = [String]()
                    let itemAuctionType = message.1["itemAuctionType"].stringValue
                    let country_code = message.1["country_code"].stringValue
                    _ = message.1["startTime"].stringValue
                    let timeRemaining = message.1["timeRemaining"].int64Value
                    let title = message.1["title"].stringValue
                    let watching = message.1["watching"]
                    for watch in watching {
                        let watch_uidvalue = watch.1["uid"].stringValue
                        let watch_tokenvalue = watch.1["token"].stringValue
                        watch_uid = watch_uidvalue
                        watch_token = watch_tokenvalue
                    }
                    print(watch_uid)
                    print(watch_token)
                    let zipcode = message.1["zipcode"].stringValue
                    let city = message.1["city"].stringValue
                    let endTime = message.1["endTime"].int64Value
                    let state = message.1["state"].stringValue
                    let autoReList = message.1["autoReList"].boolValue
                    let acceptOffers = message.1["acceptOffers"].boolValue
                    var latitude = Double()
                    var londtitude = Double()
                    let itemimages = message.1["old_images"]
                    
                    let coordinates = loc["coordinates"].array
                    
                    for itemimg in itemimages {
                        
                        ItemimagesArr.append(itemimg.1.stringValue)
                        
                        print("Item Image Url Backhand == \(itemimg.1.stringValue)")
                        
                    }
                    
                    let ordering = message.1["ordering"].boolValue
                    
                    let serviceType = message.1["serviceType"].stringValue
                    
                    let servicePrice = message.1["servicePrice"].stringValue
                    
                    let negotiable = message.1["negotiable"].boolValue
                    
                    let userRole = message.1["userRole"].stringValue
                    
                    let quantity = message.1["quantity"].intValue
                    
                    let image = message.1["images_path"]
                    
                    var imageArray = [String]()
                    
                    for img in image {
                        
                        imageArray.append(img.1.stringValue)
                        
                    }
                    
                    let currency_string = message.1["currency_string"].stringValue
                    
                    let currency_symbol = message.1["currency_symbol"].stringValue
                    let admin_verify = message.1["admin_verify"].stringValue
                    latitude = coordinates![1].doubleValue
                    
                    londtitude = coordinates![0].doubleValue
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
                    
                    
                    let ServiceDetail = sellingModel.init(id: id, latitude: latitude, longtitude: londtitude, chargeTime: chargeTime, images_path: imageArray, images_small_path: image_array, startTime: Int64(startPrice), visibility: visibility, old_small_images: ItemimagesArr, image: imageArray, token: token, country_code: country_code, city: city, title: title, startPrice: startPrice, itemCategory: itemCategory, uid: uid, description: description, endTime: endTime, currency_string: currency_string, currency_symbol: currency_symbol, autoReList: autoReList, acceptOffers: acceptOffers, platform: "iOS", item_id: itemKey, state: state, userRole: userRole, negotiable: negotiable, serviceType: serviceType, servicePrice: servicePrice, timeRemaining: timeRemaining, ordering: ordering , quantity: quantity, zipcode: zipcode , OrderArray: self.orderArray , itemAuctionType: itemAuctionType , admin_verify: admin_verify)
                    
                    self.selectedProduct_Service = ServiceDetail
                    
                    self.selectedProduct_Service!.servicePrice = ServiceDetail.servicePrice
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
    
    
    
    @objc func endlisting_api() {
        
        
        
        MainAPi.End_Listing(reason: EndlistReason, item_id: selectedProduct_Service!.id) { (status, swiftdata, error) in
            
            
            
            if status {
                
                _ = SweetAlert().showAlert("End Listing", subTitle: "Buyers will not be able to send you orders or offers. Are you sure to end listing for this Service? ", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                    
                    if(status == true) {
                        
                        self.selectedProduct_Service!.endTime = -1
                        
                        
                        
                        self.EndlistingBtn.isHidden = true
                        
                        self.EndlistBtnHeight.constant = 0
                        
                        
                        self.RelistItem.isHidden = false
                        
                        self.RelistServiceHeight.constant = 50
                        
                        
                        
                        self.Endlisting_View.dismiss(animated: true, completion: nil)
                        _ = SweetAlert().showAlert("End Listing", subTitle: "Service listing has been ended successfully. You can re-list Service anytime.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                        
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
    
    
    
    
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
        popoverPresentationController.permittedArrowDirections = .down
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    var Downloaded_Item_Images = UIImageView()
    
    var MainAPi = MainSell4BidsApi()
    
    var currenttime = Int64()
    
    
    
    @IBOutlet weak var AuctionandListingendedtxt: UILabel!
    @IBOutlet weak var WatchBtn: UIButton!
    @IBOutlet weak var ShareBtn: UIButton!
    @IBOutlet weak var ListedByYou: UILabel!
    
    
    
    
    @objc func shareaction(){
        
        let textToShare = "Check out this item that i found on The Sell4Bids Marketplace.".localizableString(loc: LanguageChangeCode)
        
        let cat = selectedProduct_Service!.itemCategory
        
        let auction = selectedProduct_Service!.itemAuctionType
        
        let state =  selectedProduct_Service!.state
        
        let prodId = selectedProduct_Service!.id
        
        
        
        
        
        
        
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
            
            MainAPi.UnWatch_Item(uid: SessionManager.shared.userId, itemid: selectedProduct_Service!.id) { (status, data, error) in
                
                print("remove from Watchlist")
                
                
                
                print("status == \(status)")
                
                print("data == \(data)")
                
                print("error == \(error)")
                
                
                
                if status {
                    
                    self.WatchBtn.setTitle("Add to Watch List", for: .normal)
                    
                    self.WatchBtn.setImage(UIImage(named: "ic_watch"), for: .normal)
                    
                    self.Watchimg.image = UIImage(named: "ic_watch")
                    
                    
                    
                    showSwiftMessageWithParams(theme: .info, title: "Remove Watched" , body: "You have succesfully remove Job from watch list")
                    
                    
                    
                }else {
                    
                    showSwiftMessageWithParams(theme: .info, title: "ERROR".localizableString(loc: LanguageChangeCode) , body: "Some Thing is Wrong")
                    
                }
                
                
                
            }
            
        }else {
            
            MainAPi.Watch_Item(uid: SessionManager.shared.userId, itemid: selectedProduct_Service!.id) { (status, data, error) in
                
                print("Add to Watchlist")
                
                
                
                print("status == \(status)")
                
                print("data == \(data)")
                
                print("error == \(error)")
                
                
                
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
            
            MainAPi.UnWatch_Item(uid: SessionManager.shared.userId, itemid: selectedProduct_Service!.id) { (status, data, error) in
                
                print("remove from Watchlist")
                
                
                
                print("status == \(status)")
                
                print("data == \(data)")
                
                print("error == \(error)")
                
                
                
                if status {
                    
                    self.WatchBtn.setTitle("Add to Watch List", for: .normal)
                    
                    self.WatchBtn.setImage(UIImage(named: "ic_watch"), for: .normal)
                    
                    self.Watchimg.image = UIImage(named: "ic_watch")
                    
                    
                    
                    showSwiftMessageWithParams(theme: .info, title: "Remove Watched" , body: "You have succesfully remove Job from watch list")
                    
                    
                    
                }else {
                    
                    showSwiftMessageWithParams(theme: .info, title: "ERROR".localizableString(loc: LanguageChangeCode) , body: "Some Thing is Wrong")
                    
                }
                
                
                
            }
            
        }else {
            
            MainAPi.Watch_Item(uid: SessionManager.shared.userId, itemid: selectedProduct_Service!.id) { (status, data, error) in
                
                print("Add to Watchlist")
                
                
                
                print("status == \(status)")
                
                print("data == \(data)")
                
                print("error == \(error)")
                
                
                
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
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func MoveToUserDetail(_ sender: Any) {
        
        
        
        print("Clicked on User Details.")
        
        
        
        let storyboard = UIStoryboard.init(name: "UserDetails", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
        
        
        
        controller.sellerDetail = self.UserDetail
        
        controller.title = self.UserDetail?.name ?? "Sell4Bid User"
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    
    
    
    
    func Get_time(){
        
        MainAPi.ServerTime { (status, data, error) in
            
            
            
            print("Current time ====== \(data)")
            
            if status {
                
                self.currenttime = data!["time"].int64Value
                
            }
            
        }
        
    }
    
    
    
    
    
    //    var stretchyHeader : GSKStretchyHeaderView!
    
    
    
    var TimerHeight = CGFloat()
    
    var AuctionandListingHeight = CGFloat()
    
    
    
    
    
    @IBOutlet weak var UserImage: UIImageView!
    
    @IBOutlet weak var UserName: UILabel!
    
    @IBOutlet weak var cosmosRating: CosmosView!
    
    @IBOutlet weak var averageRatingUser: smallBold!
    
    @IBOutlet weak var userProfileStackView: UIStackView!
    
    
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    @IBOutlet weak var Watchimg: UIImageView!
    
    @IBOutlet weak var shareimg: UIImageView!
    
    @IBOutlet weak var StartPrice: UILabel!
    
    @IBOutlet weak var CurrencyString_Label: UIImageView!
    
    @IBOutlet weak var Item_Title_txt: UILabel!
    
    @IBOutlet weak var Wanted_OfferingTextLbl: UILabel!
    
    @IBOutlet weak var itemTime: UILabel!
    
    @IBOutlet weak var Item_Category_txt: UILabel!
    
    @IBOutlet weak var Item_Description_lbl: UILabel!
    
    @IBOutlet weak var Item_City_lbl: UILabel!
    
    @IBOutlet weak var Item_State_Lbl: UILabel!
    
    @IBOutlet weak var Item_Map_View: GMSMapView!
    
    @IBOutlet weak var item_Zipcode_Lbl: UILabel!
    
    
    
    @IBOutlet weak var Days: UILabel!
    
    @IBOutlet weak var Minlbl: UILabel!
    
    @IBOutlet weak var secondslbl: UILabel!
    
    @IBOutlet weak var Hourslbl: UILabel!
    
    @IBOutlet weak var Daytxtlbl: UILabel!
    
    @IBOutlet weak var Hourtxtlbl: UILabel!
    
    @IBOutlet weak var Mintxtlbl: UILabel!
    
    @IBOutlet weak var Seclbltxt: UILabel!
    
    
    
    var UserDetail : SellerDetailModel?
    
    
    
    @IBOutlet weak var ServiceType: UILabel!
    
    @IBOutlet weak var GetNewOrders: UIButton!
    
    @IBOutlet weak var AcceptOffers: UIButton!
    
    @IBOutlet weak var ShowItemBtn: UIButton!
    
    @IBOutlet weak var RelistItem: UIButton!
    
    @IBOutlet weak var AutomaticRelist: UIButton!
    
    @IBOutlet weak var TurboCharge: UIButton!
    
    
    
    var Autorelist : Bool?
    
    var visibility : Bool?
    
    var orderingstatus : Bool?
    
    var acceptsOffers : Bool?
    
    
    
    
    
    @IBOutlet weak var OrderBtn: UIButton!
    
    @IBOutlet weak var ViewOrders_ViewOfferBtn: UIButton!
    
    
    
    @IBAction func ViewOrdersBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "ServiceDetail", bundle: nil)
        
        let controller2 = storyboard.instantiateViewController(withIdentifier: "OrderView_Service") as! Services_ViewOrders
        
        controller2.ServiceDetails = selectedProduct_Service
        
        self.navigationController?.pushViewController(controller2, animated: true)
        
    }
    
    @IBAction func ViewOrders_ViewOffers(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "ServiceDetail", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "Offer_View_Identifier") as! Services_ViewOffers
        
        controller.selectedProduct = selectedProduct_Service
        
        //        let maincontroller = storyboard.instantiateViewController(withIdentifier: "ViewOrdersandOffers_Services") as! Services_ViewOrders
        //
        //        maincontroller.selectedProduct = selectedProduct_Service
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    
    
    
    
    @IBAction func AccpetOffers(_ sender: Any) {
        
        
        
        if self.AcceptOffers.titleLabel?.text == "Stop Negotiable" {
            
            self.acceptsOffers = false
            
            _ = SweetAlert().showAlert("Stop Offers", subTitle: "Do you want to stop buyers to send offers?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status==true){
                    
                    self.MainAPi.Offer_Status(country: gpscountry, acceptOffers: self.acceptsOffers!, item_id: self.selectedProduct_Service!.id) { (status, data, error) in
                        
                        print("status == \(status)")
                        
                        print("Data == \(data)")
                        
                        print("error == \(error)")
                        
                        if status {
                            
                            if self.acceptsOffers == true {
                                
                                self.AcceptOffers.setTitle("Stop Negotiable", for: .normal)
                                
                                self.AcceptOffers.setTitleColor(UIColor.black, for: .normal)
                                
                                self.AcceptOffers.backgroundColor = UIColor.white
                                
                                self.reloadData()
                                
                                
                            }else {
                                
                                self.AcceptOffers.setTitle("Set Negotiable", for: .normal)
                                
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
                    
                    //                    _ = SweetAlert().showAlert("Offers", subTitle: "Offers has been disabled successfully. You can enabled it anytime.        ", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    _ = SweetAlert().showAlert("Offers", subTitle: "Offers has been disabled successfully. you can enabled it anytime.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                    
                }
                
            }
            
            
            
        }
            
        else if self.AcceptOffers.titleLabel?.text == "Set Negotiable"
        {
            
            self.acceptsOffers = true
            
            _ = SweetAlert().showAlert("Offers", subTitle: "Do you want buyers to send offers?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status==true){
                    
                    self.MainAPi.Offer_Status(country: gpscountry, acceptOffers: self.acceptsOffers!, item_id: self.selectedProduct_Service!.id) { (status, data, error) in
                        
                        
                        
                        if status {
                            
                            if self.acceptsOffers == false {
                                
                                self.AcceptOffers.setTitle("Set Negotiable", for: .normal)
                                
                                self.AcceptOffers.setTitleColor(UIColor.black, for: .normal)
                                
                                self.AcceptOffers.backgroundColor = UIColor.white
                                
                            }else {
                                
                                self.AcceptOffers.setTitle("Stop Negotiable", for: .normal)
                                
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
                    
                    self.MainAPi.Ordering_Status(country: gpscountry, ordering: self.orderingstatus!, item_id:self.selectedProduct_Service!.id) { (status, data, error) in
                        
                        
                        
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
                    
                    //                     _ = SweetAlert().showAlert("Stop Orders", subTitle: "Orders has been disabled successfully. You can enabled it anytime.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    _ = SweetAlert().showAlert("Stop Orders", subTitle:"Orders has been disabled successfully. you can enabled it anytime.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
                
            }
            
            
            
        }
            
        else if self.GetNewOrders.titleLabel?.text == "Get New Orders" {
            
            orderingstatus = true
            
            _ = SweetAlert().showAlert("Orders", subTitle: "Do you want buyers to send new orders?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status==true){
                    
                    self.MainAPi.Ordering_Status(country: gpscountry, ordering: self.orderingstatus!, item_id:self.selectedProduct_Service!.id) { (status, data, error) in
                        
                        
                        
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
                    
                    _ = SweetAlert().showAlert("Orders", subTitle: "Orders has been enabled successfully. Buyers will be able send orders on this vehicle.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
                
            }
            
            
            
        }}
    
    
    
    
    
    
    
    var ChatMessage = [ChatMessageList]()
    
    
    
    @objc func ChatWithSeller() {
        
        MainAPi.Get_Chat(buyer_uid: SessionManager.shared.userId, item_id: selectedProduct_Service!.id, start: 0, limit: 15) { (status, data, error) in
            
            
            
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
                
                
                
                let msgnewdata = ChatMessageList.init(read: false, delivered_time: 0, created_at: 0, buyer_uid: SessionManager.shared.userId, message: "", itemCategory: self.selectedProduct_Service!.itemCategory, sender_uid: SessionManager.shared.userId, item_id: self.selectedProduct_Service!.id, item_price: Int(self.selectedProduct_Service!.startPrice), sender: SessionManager.shared.name, itemAuctionType: self.selectedProduct_Service!.itemAuctionType, receiver_uid: self.selectedProduct_Service!.uid, images_small_path: self.selectedProduct_Service!.image.last!, delivered: false, seller_uid: self.selectedProduct_Service!.uid, id: self.selectedProduct_Service!.id, images_path: self.selectedProduct_Service!.image.last!, title: self.selectedProduct_Service!.title, receiver: self.UserName.text!, role: "buyer", iserror: false)
                
                
                
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
                
                
                
            }else{
                
                self.MoveToSellerBtn.isEnabled = false
                
            }
            
            
            
        }
        
    }
    
    
    let Relist_Item = Bundle.main.loadNibNamed("DetailsRelistVC", owner: self, options: nil)?.first as! DetailsRelist_ViewC
    
    let Relist_Item_View = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    @objc func Close_Relist_item() {
        
        Relist_Item_View.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBOutlet weak var RelistServiceHeight: NSLayoutConstraint!
    
    @IBOutlet weak var EndlistBtnHeight: NSLayoutConstraint!
    
    
    
    @objc func Relist_Item_Api_Call () {
        
        
        if (Relist_Item.AmountPerItemtxt.text!.isEmpty){
            _ = SweetAlert().showAlert("Invalid Price", subTitle: "Please enter a valid price to continue.", style: AlertStyle.warning,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            return
        }
        if (Relist_Item.Quantitytxt.text!.isEmpty){
            _ = SweetAlert().showAlert("Listing Duration", subTitle: "Please choose listing duration to continue.", style: AlertStyle.warning,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            return
        }
        
        if (!Relist_Item.AmountPerItemtxt.text!.isEmpty){
            
            let price : Int = Int(Relist_Item.AmountPerItemtxt.text!)!
            
            if (!Relist_Item.AmountPerItemtxt.text!.isEmpty) {
                
                
                if price <= 0 {
                    
                    _ = SweetAlert().showAlert("Invalid Price", subTitle: "Please enter valid price more then 0.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    return
                    
                }else{
                    
                    MainAPi.Relist_Item(country: gpscountry, startPrice: price, endTime: selected_date, item_id: selectedProduct_Service!.id, itemCategory: selectedProduct_Service!.itemCategory){ (status, swiftdata, error) in
                        
                        
                        
                        if status {
                            
                            _ = SweetAlert().showAlert("Item Re-listing", subTitle: "Do you to re-list this Item?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                                
                                if(status == true){
                                    
                                    
                                    self.EndlistingBtn.isHidden = false
                                    
                                    self.EndlistBtnHeight.constant = 50
                                    
                                    
                                    
                                    self.Relist_Item_View.dismiss(animated: true, completion: nil)
                                    
                                    
                                    
                                    
                                    
                                    self.RelistItem.isHidden = true
                                    
                                    self.RelistServiceHeight.constant = 0
                                    
                                    self.reloadData()
                                    
                                    self.tableView.reloadData()
                                    
                                    
                                    _ = SweetAlert().showAlert("Item Re-listing", subTitle: "Item has been re-listed successfully.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                                    
                                    
                                }
                            }
                            
                            
                        }else {
                            
                            
                            _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle: swiftdata!["message"].stringValue, style: .success)
                            
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
        
        Relist_Item.Header0_Title.text = "Price"
        
        Relist_Item.Header1_Title.text = "Listing Duration"
        
        Relist_Item.SendOfferBtn.setTitle("Re-List Service", for: .normal)
        
        Relist_Item.Quantitytxt.placeholder = "3 Days"
        
        ChangeBtnStyle(Button: Relist_Item.SendOfferBtn)
        
        Relist_Item_View.view.addSubview(Relist_Item)
        
        
        
        self.present(Relist_Item_View, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //item turbo charged
    
    @IBAction func Turbo_Charge_Item(_ sender: Any) {
        
        
        
        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Service will be shown first to new users. Do you want to turbo charge the Service?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
            
            
            
            if status == true {
                
                self.MainAPi.Item_TurboCharge(country: gpscountry, item_id: self.selectedProduct_Service!.id) { (status, data, error) in
                    
                    
                    
                    if error.contains("The network connection was lost"){
                        
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Service has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    if error.contains("The Internet connection appears to be offline.") {
                        
                        
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Service has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                        
                        
                    }
                    
                    
                    
                    if error.contains("A server with the specified hostname could not be found."){
                        
                        
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Service has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                    }
                    
                    
                    
                    if error.contains("The request timed out.") {
                        
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Service has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                        
                        
                    }
                    
                    
                    
                }
                
                _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Vehicle has been turbo charged successfully.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                
                
                
            }
            
            
            
        }
        
    }
    
    
    
    
    
    
    
    //Show_Item_Hide
    
    @IBAction func Show_Item_Hide_Item(_ sender: Any) {
        
        if ShowItemBtn.titleLabel!.text == "Hide Service" {
            
            visibility = false
            
            
            
            _ = SweetAlert().showAlert("Service Visibility", subTitle: "Item will not be visible to buyers. Do you want to hide the Service?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status == true){
                    
                    self.MainAPi.Hide_Show_Item(country: gpscountry, visibility: self.visibility!, item_id: self.selectedProduct_Service!.id) { (status, data, error) in
                        
                        
                        
                        
                        
                        if status {
                            
                            if self.visibility == true {
                                
                                self.ShowItemBtn.setTitle("Hide Service", for: .normal)
                                
                                self.ShowItemBtn.backgroundColor = UIColor.white
                                
                                self.ShowItemBtn.setTitleColor(UIColor.black, for: .normal)
                                
                                self.reloadData()
                                
                                
                                
                            }else {
                                self.ShowItemBtn.setTitle("Show Service", for: .normal)
                                
                                self.ShowItemBtn.backgroundColor = UIColor.black
                                
                                self.ShowItemBtn.setTitleColor(UIColor.white, for: .normal)
                                
                                self.reloadData()
                                
                            }
                            
                        }
                        
                        
                        
                        
                        
                        if error.contains("The network connection was lost"){
                            
                            
                            
                            _ = SweetAlert().showAlert("Service Visibility", subTitle: "Service visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            _ = SweetAlert().showAlert("Service Visibility", subTitle: "Service has not been disabled due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            
                            
                            _ = SweetAlert().showAlert("Service Visibility", subTitle: "Service has not been disabled due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                        }
                        
                        
                        
                        if error.contains("The request timed out.") {
                            
                            
                            
                            _ = SweetAlert().showAlert("Service Visibility", subTitle: "Service has not been disabled due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                        }
                        
                        
                        
                    }
                    _ = SweetAlert().showAlert("Service Visibility", subTitle: " Service has been disabled successfully. You can un-hide the item anytime.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
                
                
                
            }
            
            
            
            
            
        }
        else if ShowItemBtn.titleLabel!.text == "Show Service" {
            
            visibility = true
            
            
            
            _ = SweetAlert().showAlert("Service Visibility", subTitle: "Service will be visible to new buyers. Do you want to un-hide the Service?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status == true){
                    
                    print("check")
                    
                    self.MainAPi.Hide_Show_Item(country: gpscountry, visibility: self.visibility!, item_id: self.selectedProduct_Service!.id) { (status, data, error) in
                        
                        
                        
                        
                        
                        if status {
                            
                            if self.visibility == false {
                                
                                
                                
                                self.ShowItemBtn.setTitle("Show Service", for: .normal)
                                
                                self.ShowItemBtn.backgroundColor = UIColor.black
                                
                                self.ShowItemBtn.setTitleColor(UIColor.white, for: .normal)
                                
                                self.reloadData()
                                
                            }else {
                                self.ShowItemBtn.setTitle("Hide Service", for: .normal)
                                
                                self.ShowItemBtn.backgroundColor = UIColor.white
                                
                                self.ShowItemBtn.setTitleColor(UIColor.black, for: .normal)
                                
                                self.reloadData()
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        if error.contains("The network connection was lost"){
                            
                            
                            _ = SweetAlert().showAlert("Service Visibility", subTitle: "Service visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            
                            
                            _ = SweetAlert().showAlert("Service Visibility", subTitle: "Service visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                        }
                        
                        
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            
                            
                            _ = SweetAlert().showAlert("Service Visibility", subTitle: "Service visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                        }
                        
                        
                        
                        if error.contains("The request timed out.") {
                            
                            
                            _ = SweetAlert().showAlert("Service Visibility", subTitle: "Service visibility status is not updated due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    _ = SweetAlert().showAlert("Service Visibility", subTitle: "Succesfully updated. Service will be visible to buyers.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                }
                
            }
            
            
            
        }
        
    }
    
    
    
    
    
    //Item Autorelisting
    
    @IBAction func AutoRelisting_Item(_ sender: Any) {
        print("(AutoRelisting_Item)")
        if self.AutomaticRelist.titleLabel?.text == "Stop Automatic Relisting" {
            
            self.Autorelist = false
            
            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Service will not be automatically re-listed for 03 more days after expiration. Do you want to disable automatic re-listing of the Service?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status == true){
                    
                    
                    self.MainAPi.AutoRelist_Item(country: gpscountry, autoReList: self.Autorelist!, item_id: self.selectedProduct_Service!.id) { (status, data, error) in
                        
                        
                        
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
                    
                    _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing has been disabled for this Vehicle.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                    
                    
                    
                }
                
                
                
            }
            
        }
            
        else if self.AutomaticRelist.titleLabel?.text == "Automatic Relist"
        {
            
            Autorelist = true
            
            _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Service will be automatically re-listed for 03 more days after expiration. Do you want automatic re-listing for the Service?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                
                if(status==true){
                    
                    
                    
                    self.MainAPi.AutoRelist_Item(country: gpscountry, autoReList: self.Autorelist!, item_id: self.selectedProduct_Service!.id) { (status, data, error) in
                        
                        
                        
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
                    
                    _ = SweetAlert().showAlert("Automatic Re-listing", subTitle: "Automatic re-listing has been enabled for this Vehicle. Vehicle will be re-listed for 03 days on expiration.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                }
                
            }
            
            
            
        }
        
    }//Func Ended
    
    
    
    @IBAction func ShareProduct(_ sender: Any) {
        
        let textToShare = "Check out this item that i found on The Sell4Bids Marketplace.".localizableString(loc: LanguageChangeCode)
        
        let cat = selectedProduct_Service!.itemCategory
        
        let auction = selectedProduct_Service!.itemAuctionType
        
        let state =  selectedProduct_Service!.state
        
        let prodId = selectedProduct_Service!.id
        
        
        
        
        
        
        
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
          MainAPi.Report_Item(uid: SessionManager.shared.userId , report: ReportItemTxt, item_id: selectedProduct_Service!.itemKey, seller_uid: selectedProduct_Service!.uid) { (status, data, error) in
              
              
              
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
        
        
        
        Button.addShadowAndRoundNew()
        
        
        
    }
    
    
    
    let testVC = UITableViewController(style: .grouped)
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("Item Image == \(itemimg.count)")
        
        if collectionView.tag == 0 {
            
            return selectedProduct_Service?.images_path.count ?? 0
            
        }else {
            
            return selectedProduct_Service?.images_path.count ?? 0
            
        }
        
        
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if collectionView.tag == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCell", for: indexPath) as! ItemImgSliderCell
            
            
            
            let urlStr = selectedProduct_Service?.images_path[indexPath.item] ?? ""
            
            print("url == \(urlStr)")
            
            
            
            cell.ItemImage.sd_setImage(with: URL(string: urlStr), placeholderImage:  UIImage(named: "emptyImage") )
            
            
            
            
            
            return cell
            
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideritemImage", for: indexPath) as! Items_Detail_Sliders_Cell
            
            
            
            
            
            let urlStr = selectedProduct_Service?.images_path[indexPath.item] ?? ""
            
            print("url == \(urlStr)")
            
            
            
            
            
            cell.ItemSliderImages.sd_setImage(with: URL(string: urlStr), placeholderImage:  UIImage(named: "emptyImage") )
            
            
            
            
            
            return cell
            
        }
        
        
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "Service_ImagePopUpView-identifier")  as! Service_ImagePopUpView
        
        
        
        controller.selectedIndex = indexPath
        
        print("controller.selectedIndex : \(controller.selectedIndex)")
        
        controller.view.backgroundColor = UIColor.white
        
        controller.imagesArray = selectedProduct_Service!.images_path
        
        
        
        
        
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        controller.modalTransitionStyle = .coverVertical
        
        self.present(controller, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    
    
    
    var cordinates = CLLocationCoordinate2D()
    
    var selectedProduct_Service : sellingModel?
    
    var ItemImages = [String]()
    
    
    
    var itemimg = [UIImage]()
    
    var Title = String()
    
    
    
    let viewButton  = Bundle.main.loadNibNamed("ItemDetailBottomButtons", owner: self, options: nil)?.first as! ButtonStacksItem
    
    let item_header = Bundle.main.loadNibNamed("Item_Header", owner: self, options: nil)?.first as! Item_Header
    
    let navigationbar = Bundle.main.loadNibNamed("Item_Navigation_barview", owner: self, options: nil)?.first as! Item_Navigation_barview
    
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        viewButton.Bid_Now_Btn.isHidden = true
        
        viewButton.removeFromSuperview()
        
        navigationbar.removeFromSuperview()
        
        self.navigationController?.navigationBar.isHidden = false
        
        
        
    }
    
    
    let Bid_Now_Alert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    let BidNowCustomView = Bundle.main.loadNibNamed("Buy_Now_Custom_View", owner: self, options: nil)?.first as! BuyNowCustomView
    
    
    
    @objc func Bid_Now_Close() {
        
        Bid_Now_Alert.dismiss(animated: true, completion: nil)
        
    }
    
    var quantity : Int?
    
    @objc func Buy_Now_Api() {
        
        _ = SweetAlert().showAlert("Buy Now", subTitle: "Do you want to buy this \(selectedProduct_Service?.title ?? "$") now?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
            
            if status == true {
                
                self.MainAPi.Buy_Now_Item(country: gpscountry, boughtQuantity: 1, buyerName: SessionManager.shared.name, seller_uid: (self.selectedProduct_Service?.uid)!, buyer_uid: SessionManager.shared.userId, itemId: (self.selectedProduct_Service?.id)!, seller_email: SessionManager.shared.email , buyImage: SessionManager.shared.image) { (status, data, error) in
                    
                    print("status == \(status)")
                    
                    print("data == \(data)")
                    
                    print("error == \(error)")
                    
                    if error.contains("The network connection was lost"){
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Vehicle has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                    }
                    
                    if error.contains("The Internet connection appears to be offline.") {
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Vehicle has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                    }
                    
                    if error.contains("A server with the specified hostname could not be found."){
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Vehicle has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                    }
                    
                    if error.contains("The request timed out.") {
                        
                        
                        _ = SweetAlert().showAlert("Turbo Charge", subTitle: "Vehicle has not been turbo charged due to some issues. Try again later.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                    }
                    
                }
                
                _ = SweetAlert().showAlert("Buy Now", subTitle: "Your order has been placed successfully. Please wait for the seller to respond.", style: AlertStyle.success,buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000))
                
            }
            
        }
        
    }
    
    
    @objc func Offer_Now_Api() {
        
        let price = Int(BidNowCustomView.Quantitytxt.text!)
        
        if (BidNowCustomView.Quantitytxt.text!.isEmpty) {
            _ = SweetAlert().showAlert("Price Error", subTitle: "Price can't be empty.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            return
        }
        
        if (!BidNowCustomView.Quantitytxt.text!.isEmpty) {
            
            if (!BidNowCustomView.Quantitytxt.text!.isEmpty) {
                
                
                if price! <= 0 {
                    
                    _ = SweetAlert().showAlert("Invalid Price", subTitle: "Please enter valid Price more then 0.", style: AlertStyle.success,buttonTitle:"Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    return
                    
                }else {
                    
                    MainAPi.Buy_Offer(buyer_uid: SessionManager.shared.userId, offer_price: BidNowCustomView.Quantitytxt.text!, item_id: selectedProduct_Service!.id, offer_quantity: "1", offerType: "offers", buyer_name: SessionManager.shared.name, buyer_image: SessionManager.shared.image , itemCategory: selectedProduct_Service!.itemCategory) { (status, data, error) in
                        
                        if status {
                            
                            showSwiftMessageWithParams(theme: .info, title: "Offer Sent", body: "\(data!["message"].stringValue)", durationSecs: 50, layout: .centeredView, position: .center)
                            
                            self.Bid_Now_Alert.dismiss(animated: true, completion: nil)
                            
                        }
                        
                        print("status = \(status)")
                        
                        print("data = \(data)")
                        
                        print("error == \(error)")
                        
                    }
                }
            }
        }
    }
    
    
    
    @objc func Offer_Now() {
        
        BidNowCustomView.SendOfferBtn.addShadowAndRound()
        
        BidNowCustomView.Quantitytxt.delegate = self
        
        BidNowCustomView.SendOfferBtn.setTitle("Offer Now", for: .normal)
        
        BidNowCustomView.Heading_Title.text =  "Offer Now"
        
        BidNowCustomView.currencyTextField.text = selectedProduct_Service!.currency_string
        BidNowCustomView.Quantitytxt.placeholder = "Enter Price"
        
        BidNowCustomView.CloseBtn.addTarget(self, action: #selector(Bid_Now_Close), for: .touchUpInside)
        
        Bid_Now_Alert.view.frame = BidNowCustomView.frame
        
        Bid_Now_Alert.view.addSubview(BidNowCustomView)
        
        BidNowCustomView.SendOfferBtn.addTarget(self, action: #selector(Offer_Now_Api), for: .touchUpInside)
        
        self.present(Bid_Now_Alert, animated: true, completion: nil)
        
        
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
        self.navigationController?.view.addSubview(viewButton)
        
        self.navigationController?.view.addSubview(navigationbar)
        
       
        
    }
    
    
    
    
    
    
    
    @objc func updateTimer(currentTime: NSNumber?){
        
        var timer = Int64()
        var dif = Int64()
        
        timer = selectedProduct_Service!.endTime
        dif = timer - currenttime
        
        print("Timer == \(timer)")
        print("diference == \(dif)")
        if timer == -1 {
            print("some thing 1")
            TimerHeight = 0
            AuctionandListingHeight = 0
            
            if ((selectedProduct_Service?.OrderArray.isEmpty)!) {
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
            print("Diference In else")
            if dif <= 0 || dif == -1 {
                
                self.Days.isHidden = true
                
                self.Daytxtlbl.isHidden = true
                
                self.Hourtxtlbl.isHidden = true
                
                self.Hourslbl.isHidden = true
                
                self.Mintxtlbl.isHidden = true
                
                self.Minlbl.isHidden = true
                
                self.Seclbltxt.isHidden = true
                
                self.secondslbl.isHidden = true
                
                
                
                if selectedProduct_Service!.itemAuctionType == "reserve" || selectedProduct_Service!.itemAuctionType == "non-reserve" {
                    print("some thing 2")
                    viewButton.Bid_Now_Btn.isEnabled = false
                    
                    viewButton.Bid_Now_Btn.backgroundColor = UIColor.gray
                    
                    TimerHeight = 0
                    
                    AuctionandListingHeight = 50
                    
                }else {
                    print("some thing 3")
                    viewButton.Buy_Now_Btn.isEnabled = false
                    
                    viewButton.Buy_Now_Btn.backgroundColor = UIColor.gray
                    
                    viewButton.Offer_Now_Btn.isEnabled = false
                    
                    viewButton.Offer_Now_Btn.backgroundColor = UIColor.gray
                    
                    TimerHeight = 0
                    
                    AuctionandListingHeight = 50
                    
                }
                
                viewButton.Bid_Now_Btn.isHidden = true
                
                
                TimerHeight = 0
                AuctionandListingHeight = 50
                
                if selectedProduct_Service!.itemAuctionType == "buy-it-now" {
                    
                    AuctionandListingendedtxt.text = "Listing Ended"
                    
                    AuctionandListingendedtxt.textColor = UIColor.red
                    
                }else {
                    
                    AuctionandListingendedtxt.text = "Auction Ended"
                    
                    AuctionandListingendedtxt.textColor = UIColor.red
                    
                }
                
            }else{
                print("Difference is not working")
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
                
                let endTimeInterval:TimeInterval = TimeInterval(selectedProduct_Service!.endTime )
                
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
                            
                            if SessionManager.shared.userId == selectedProduct_Service!.uid {
                                
                                self.EndlistingBtn.isHidden = true
                                
                                self.EndlistBtnHeight.constant = 0
                                
                                self.RelistItem.isHidden = false
                                
                                self.RelistServiceHeight.constant = 50
                                
                                if tableView.tag == 13 {
                                    
                                    tableView.estimatedRowHeight = 0
                                    
                                }
                                
                            }
                            
                            if selectedProduct_Service!.itemAuctionType == "reserve" || selectedProduct_Service!.itemAuctionType == "non-reserve" {
                                print("some thing 4")
                                viewButton.Bid_Now_Btn.isEnabled = false
                                
                                viewButton.Bid_Now_Btn.backgroundColor = UIColor.gray
                                
                                TimerHeight = 0
                                
                                AuctionandListingHeight = 50
                                
                            }else {
                                print("some thing 5")
                                viewButton.Buy_Now_Btn.isEnabled = false
                                
                                viewButton.Buy_Now_Btn.backgroundColor = UIColor.gray
                                
                                TimerHeight = 0
                                
                                AuctionandListingHeight = 50
                                
                            }
                            
                            tableView.reloadUsingDispatch()
                            
                        }else {
                            
                            if SessionManager.shared.userId == selectedProduct_Service!.uid {
                                
                                self.EndlistingBtn.isHidden = false
                                
                                self.EndlistBtnHeight.constant = 50
                                
                                self.RelistItem.isHidden = true
                                
                                self.RelistServiceHeight.constant = 0
                                
                            }
                            
                        }
                        
                        if ((selectedProduct_Service?.OrderArray.isEmpty)!) {
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
    
    
    
    
    @objc func MovetoHome() {
        
        navigationController!.popViewController(animated: true)
        
        
        
    }
    
    
    
    
    
    
    
    
    var timer:Timer?
    
    @objc func actionClose(sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func showDataOnItem() {
        self.CollectionView.reloadData()
        if (selectedProduct_Service?.admin_verify.contains("pending"))!{
                   
                   OrderBtn.isEnabled = false
                   ViewOrders_ViewOfferBtn.isEnabled = false
                   viewButton.isHidden = true
                   shareimg.isUserInteractionEnabled = false
                   Watchimg.isUserInteractionEnabled = false
                   WatchBtn.isEnabled = false
                   ShareBtn.isEnabled = false
                   
               }
               if  (selectedProduct_Service?.admin_verify.contains("rejected"))!{
                   
                   OrderBtn.isEnabled = false
                   ViewOrders_ViewOfferBtn.isEnabled = false
                   viewButton.isHidden = true
                   shareimg.isUserInteractionEnabled = false
                   Watchimg.isUserInteractionEnabled = false
                   WatchBtn.isEnabled = false
                   ShareBtn.isEnabled = false
                   
               }
        
        print("User ID == \(SessionManager.shared.userId) , Item User ID = \(selectedProduct_Service?.uid ?? "0") , CompanyName == \(selectedProduct_Service?.companyName ?? "0") , title == \(selectedProduct_Service?.title ?? "0") , Job Toughness == \(selectedProduct_Service?.condition ?? "0") , ConditionValue == \(selectedProduct_Service?.conditionValue) , EmploymentType == \(selectedProduct_Service?.employmentType ?? "0") , Description == \(selectedProduct_Service?.description ?? "0") , City == \(selectedProduct_Service?.city ?? "0") , PayPeriod == \(selectedProduct_Service?.payPeriod ?? "0")")
        
        
        
        if selectedProduct_Service!.chargeTime != 0 {
            
            //print("time  is not nil")
            
            let startTime:TimeInterval = Double(selectedProduct_Service!.chargeTime)
            
            let miliToDate = Date(timeIntervalSince1970:startTime/1000)
            
            let calender  = NSCalendar.current as NSCalendar
            
            let unitflags = NSCalendar.Unit([.day,.hour,.minute,.second])
            
            let diffDate = calender.components(unitflags, from:miliToDate, to: Date())
            
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
        
        
        
        if TimerHeight == 0 {
            
            AuctionandListingHeight = 50
            
        }else {
            
            TimerHeight = 50
            
        }
        
        
        
        
        
        navigationbar.ItemTitle.text = self.selectedProduct_Service!.title
        if selectedProduct_Service!.watchBool {
                   
                   self.WatchBtn.setTitle("Remove from Watch List", for: .normal)
                   
                   self.WatchBtn.setImage(UIImage(named: "ic_unwatch"), for: .normal)
                   
                   self.Watchimg.image = UIImage(named: "ic_unwatch")
                   
               }else {
                   
                   self.WatchBtn.setTitle("Add to Watch List", for: .normal)
                   
                   self.WatchBtn.setImage(UIImage(named: "ic_watch"), for: .normal)
                   
                   self.Watchimg.image = UIImage(named: "ic_watch")
                   
               }
        
        if SessionManager.shared.userId.contains(selectedProduct_Service!.uid) {
            
            viewButton.isHidden = true
            Watchimg.isHidden = true
            watchListConstraint.constant = 0
            
        }else{
            
            watchListConstraint.constant = 35
            viewButton.isHidden = false
            
        }
        
        
        
        Get_time()
        
        updateTimer(currentTime: nil)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(currentTime: )), userInfo: nil, repeats: true)
        
        
        
        print("User ID == \(SessionManager.shared.userId) , Item User ID =\(self.selectedProduct_Service!.uid)")
        
        GetUserDetails(uid: selectedProduct_Service!.uid)
        
        if ((selectedProduct_Service?.OrderArray.isEmpty)!) {
            viewButton.Buy_Now_Btn.isEnabled = true
            viewButton.Buy_Now_Btn.backgroundColor = UIColor.black
            viewButton.Offer_Now_Btn.isEnabled = true
            viewButton.Offer_Now_Btn.backgroundColor = UIColor.black
            viewButton.Bid_Now_Btn.isHidden = true
        }else{
            viewButton.Buy_Now_Btn.isEnabled = false
            viewButton.Buy_Now_Btn.backgroundColor = UIColor.gray
            viewButton.Offer_Now_Btn.isEnabled = false
            viewButton.Offer_Now_Btn.backgroundColor = UIColor.gray
            viewButton.Bid_Now_Btn.isHidden = true
        }
        
        print(selectedProduct_Service?.OrderArray)
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
        let currencyString = selectedProduct_Service?.currency_string ?? ""
        
        let finalStringToShow = "You recieved counter offer for check Item.\n Seller is ready to sell \(offerQuantity) item(s) at \(currencyString) \(offerPrice)"
        ShowSellerCounteOffer.textLabel.text = finalStringToShow
        visibility = selectedProduct_Service!.visibility
        
        orderingstatus = selectedProduct_Service!.ordering
        
        print("selected product = \(selectedProduct_Service!.itemAuctionType)")
        
        
        
        if selectedProduct_Service!.itemAuctionType.contains("buy-it-now") {
            
            self.viewButton.Offer_Now_Btn.isHidden = false
            
            self.viewButton.Buy_Now_Btn.isHidden = false
            
            self.viewButton.Chat_Now_Btn.isHidden = false
            
            self.viewButton.Bid_Now_Btn.isHidden = true
            
            if selectedProduct_Service!.ordering {
                
                self.viewButton.Buy_Now_Btn.isEnabled = false
                self.viewButton.Buy_Now_Btn.backgroundColor = UIColor.gray
                
            }else {
                
                self.viewButton.Buy_Now_Btn.isEnabled = true
                self.viewButton.Buy_Now_Btn.backgroundColor = UIColor.black
                
            }
            
            if selectedProduct_Service!.acceptOffers {
                
                self.viewButton.Offer_Now_Btn.isHidden = false
                
            }else {
                
                self.viewButton.Offer_Now_Btn.isHidden = true
                
            }
            
        }else {
            
            self.viewButton.Bid_Now_Btn.isHidden = true
            
            self.viewButton.Chat_Now_Btn.isHidden = false
            
            self.viewButton.Buy_Now_Btn.isHidden = true
            
            self.viewButton.Offer_Now_Btn.isHidden = true
            
        }
        
        let country = selectedProduct_Service?.country_code.uppercased()
        print("ItemDetail_country == \(country!)")
        let Detail_Currency_Symbol = CurrencyManager.instance.getCurrencySymbol(Country: country ?? "USA")
        print("Detail_Currency_Symbol == \(Detail_Currency_Symbol)")
        StartPrice.text = "  " + Detail_Currency_Symbol + "" + (selectedProduct_Service?.startPrice.description)!
        print("StartPrice == \(StartPrice.text!)")
        
        Item_Title_txt.text = selectedProduct_Service?.title
        ServiceType.text = selectedProduct_Service?.serviceType
        Item_Category_txt.text = selectedProduct_Service?.serviceType
        Item_Description_lbl.text = selectedProduct_Service!.description
        
        var address = ""
        if (selectedProduct_Service?.city != nil) && !(selectedProduct_Service?.city == ""){
            address += selectedProduct_Service!.city
        }
        if (selectedProduct_Service?.state != nil) && !(selectedProduct_Service?.state == ""){
            address += ", " + selectedProduct_Service!.state
        }
        if (selectedProduct_Service?.zipcode != nil) && !(selectedProduct_Service?.zipcode == ""){
            address += ", " + selectedProduct_Service!.zipcode
        }
        
        Item_City_lbl.text = ("\(address)")
        
        print("Longtitude == \(selectedProduct_Service!.longtitude)")
        
        print("Latitude == \(selectedProduct_Service!.latitude)")
        
        cordinates.latitude = selectedProduct_Service!.latitude
        
        cordinates.longitude = selectedProduct_Service!.longtitude
        
        print("item lat ==\(selectedProduct_Service!.latitude ), item long == \(selectedProduct_Service!.longtitude)")
        ItemImages = (self.selectedProduct_Service?.image)!
        Title = (self.selectedProduct_Service?.description)!
        if SessionManager.shared.userId.contains(self.selectedProduct_Service!.uid) {
                   
                   print("User ID Same")
                   
               }
               
               cordinates.latitude = selectedProduct_Service!.latitude
               
               cordinates.longitude = selectedProduct_Service!.longtitude
               
               print("item lat ==\(selectedProduct_Service!.latitude ), item long == \(selectedProduct_Service!.longtitude)")
               
               self.Item_Map_View.delegate = self
               var cirlce: GMSCircle!
               let  circleCenter = CLLocationCoordinate2D(latitude: cordinates.latitude, longitude: cordinates.longitude)
               
               cirlce = GMSCircle(position: circleCenter, radius: 500)
               cirlce.fillColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 250.0/255.0, alpha:1.0)
               //        cirlce.strokeColor = .blue
               //        cirlce.strokeWidth = 1
               cirlce.map = Item_Map_View
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
        
       
        
        Endlisting_Item.RadioImg6.image = UIImage(named: "radioOn")
        Report_Item_View.ReportImg6.image = UIImage(named: "radioOn")
        
        Relist_Item.AmountPerItemtxt.delegate = self
        
        Endlisting_Item.topHeading.text = "Why you want to end Service listing?"
        Endlisting_Item.Optiontext3.text = "I will re-list it later"
        Endlisting_Item.OptionIext4.text = "I'm not interested to provide services"
        Endlisting_Item.Optiontext5.text = "Not receiving desired order/offers"
        Endlisting_Item.Optiontext6.text = "Other"
        Endlisting_Item.itemOutOfStock.constant = 0
        Endlisting_Item.iWillRestartLatter.constant = 0
        
        list1 = ["3 Days","5 Days","7 Days","10 Days", "15 Days","21 Days","30 Days"]
        
        Relist_Item.Quantitytxt.delegate = self
        
        selectCreatePicker(textField: Relist_Item.Quantitytxt, tag: 1)
        
        createToolBar(textField: Relist_Item.Quantitytxt)
        
        
        
        viewButton.Bid_Now_Btn.isHidden = true
        
        self.MoveToSellerBtn.isEnabled = false
        
        
        
        let sharebtn = UITapGestureRecognizer()
        
        sharebtn.addTarget(self, action: #selector(shareaction))
        
        shareimg.addGestureRecognizer(sharebtn)
        
        shareimg.isUserInteractionEnabled = true
        
        
        
        let userProfile = UITapGestureRecognizer()
        
        userProfile.addTarget(self, action: #selector(MoveToUserDetail))
        
        userProfileStackView.addGestureRecognizer(userProfile)
        
        userProfileStackView.isUserInteractionEnabled = true
        
        
        
        let watchimgGesture = UITapGestureRecognizer()
        
        watchimgGesture.addTarget(self, action: #selector(WatchingFunc))
        
        Watchimg.addGestureRecognizer(watchimgGesture)
        
        Watchimg.isUserInteractionEnabled = true
        
        
        
        
        navigationbar.MovetoHome.addTarget(self, action: #selector(MovetoHome), for: .touchUpInside)
        
        navigationbar.HomeBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        navigationbar.BackBtn.addTarget(self, action: #selector(Back_btn), for: .touchUpInside)
        viewButton.Buy_Now_Btn.addTarget(self, action: #selector(Buy_Now_Api), for: .touchUpInside)
        
        viewButton.Offer_Now_Btn.addTarget(self, action: #selector(Offer_Now), for: .touchUpInside)
        
        navigationbar.backgroundColor = UIColor.clear
        
        
       
        
        
        
        socket?.on("notifications") {data, ack in
            
            print("Socket Item Details == \(data)")
            
            
            
        }
        
        
        viewButton.Chat_Now_Btn.addTarget(self, action: #selector(ChatWithSeller), for: .touchUpInside)
        
        
        
        

        
        
        ShowSellerCounteOffer.acceptBtn.addTarget(self, action: #selector(AcceptOfferBtnTapped(sender:)), for: .touchUpInside)
        ShowSellerCounteOffer.counterOfferBtn.addTarget(self, action: #selector(counterOfferBtnTapped(sender:)), for: .touchUpInside)
        ShowSellerCounteOffer.rejectBtn.addTarget(self, action: #selector(rejectOfferBuyerBtnTapped), for: .touchUpInside)
        
        
        
        if visibility == true {
            
            ShowItemBtn.setTitle("Hide Service", for: .normal)
            ShowItemBtn.backgroundColor = UIColor.white
            ShowItemBtn.setTitleColor(UIColor.black, for: .normal)
            
        }else {
            
            ShowItemBtn.setTitle("Show Service", for: .normal)
            ShowItemBtn.backgroundColor = UIColor.black
            ShowItemBtn.setTitleColor(UIColor.white, for: .normal)
            
        }
        
        ChangeBtnStyle(Button: AcceptOffers)
        ChangeBtnStyle(Button: GetNewOrders)
        ChangeBtnStyle(Button: RelistItem)
        ChangeBtnStyle(Button: AutomaticRelist)
        ChangeBtnStyle(Button: TurboCharge)
        ChangeBtnStyle(Button: ShowItemBtn)
        ChangeBtnStyle(Button:ViewOrders_ViewOfferBtn)
        ChangeBtnStyle(Button: OrderBtn)
        ChangeBtnStyle(Button: EndlistingBtn)
        
        self.navigationController?.navigationBar.isHidden = true
        
        let imageView = UIImageView()
         let framYposition = UIDevice.isMedium ? 20 : 50
        navigationbar.frame = CGRect.init(x: 0, y: framYposition, width: Int(UIScreen.main.bounds.width), height: 50)
        
        viewButton.frame = CGRect.init(x: 0, y: self.view.frame.maxY - 50 , width: UIScreen.main.bounds.width, height: 50)
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
        
        
        self.Item_Map_View.delegate = self
        
        self.Item_Map_View.isUserInteractionEnabled = false
        
        if let layout = CollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            var itemHeight = CGFloat()
            
            let itemWidth = view.bounds.width
            
            if UIDevice.current.model.contains("iPhone") {
                
                itemHeight = 350
                
            }else if UIDevice.current.model.contains("iPad") {
                
                itemHeight = 450
                
            }
            
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
            
        }
        
        navigationbar.HomeBtn.addShadow()
        navigationbar.BackBtn.addShadow()
        navigationbar.MovetoHome.addShadow()
        
        
        
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if SessionManager.shared.userId.contains(selectedProduct_Service?.uid ?? "") {
            
            print("indexPath == 1")
            
            if indexPath.section == 0 {
                
                if UIDevice.current.model.contains("iPhone") {
                    
                    return 350
                    
                }else {
                    
                    return 450
                    
                }
                
            }else if indexPath.section == 1 {
                
                return 60
                
            }else if indexPath.section == 2 {
                
                return 60
                
            }else if indexPath.section == 3 {
                
                return TimerHeight
                
            }else if indexPath.section == 4 {
                
                return AuctionandListingHeight
                
            }else if indexPath.section == 5 {
                
                if (selectedProduct_Service?.admin_verify.contains("pending")) ?? false{
                    ListedByYou.text = "This Service listing is pending for the approval from Admin."
                    return 60
                }
                else if (selectedProduct_Service?.admin_verify.contains("rejected")) ?? false{
                    ListedByYou.text = "This Service listing is rejected for the approval from Admin."
                    return 60
                }else{
                    ListedByYou.text = "Listed By You"
                    return 60
                }
                
            }else if indexPath.section == 6 {
                return tableView.rowHeight
                
                
            }else if indexPath.section == 7 {
                if selectedProduct_Service?.userRole == "Seller" {
                    
                    Wanted_OfferingTextLbl.text = "Offering"
                    
                }else{
                    
                    Wanted_OfferingTextLbl.text = "Wanted"
                    
                }
                
                return 100
               
                
            }else if indexPath.section == 8{
                 return 100
                
                
            }else if indexPath.section == 9 {
                
                return 0
                
            }else if indexPath.section == 10{
                
                let GMSCameraPos = GMSCameraPosition.init(latitude: cordinates.latitude, longitude: cordinates.longitude, zoom: 14)
                
                self.Item_Map_View.camera = GMSCameraPos
                
                return 300
                
            }else if indexPath.section == 11 {
                
                return 50
                
            }else if indexPath.section == 12 {
                
                
                if (selectedProduct_Service?.admin_verify.contains("pending")) ?? false ||  (selectedProduct_Service?.admin_verify.contains("rejected")) ?? false{
                    
                    return 0
                    
                }else{
                
                if selectedProduct_Service!.endTime - currenttime <= -1 {
                    
                    if indexPath.row == 1 {
                        
                        return 60
                        
                    }
                    
                    if indexPath.row == 0 {
                        
                        return 0
                        
                    }
                    
                }else {
                    
                    if indexPath.row == 1 {
                        
                        return 0
                        
                    }
                    
                    if indexPath.row == 0 {
                        
                        return 60
                        
                    }
                    
                }
                
                return 60
                }
            }else if indexPath.section == 13 {
                
                return 0
                
            }
        }
        
        else {
            
            print("indexPath == 2")
            
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
                
                return TimerHeight
                
            }else if indexPath.section == 4 {
                
                return AuctionandListingHeight
                
            }else if indexPath.section == 5 {
                
                if (selectedProduct_Service?.admin_verify.contains("pending")) ?? false{
                    ListedByYou.text = "This Service listing is pending for the approval from Admin."
                    return 60
                }
                else if (selectedProduct_Service?.admin_verify.contains("rejected")) ?? false{
                    ListedByYou.text = "This Service listing is rejected for the approval from Admin."
                    return 60
                }else{
                    ListedByYou.text = "Listed By You"
                    return 0
                }
                
            }else if indexPath.section == 6 {
                 return tableView.rowHeight
               
                
            }else if indexPath.section == 7 {
                if selectedProduct_Service?.userRole == "Seller" {
                    
                    Wanted_OfferingTextLbl.text = "Offering"
                    
                }else{
                    
                    Wanted_OfferingTextLbl.text = "Wanted"
                    
                }
                
                return 100
               
                
            }else if indexPath.section == 8{
                
                return 100
                
            }else if indexPath.section == 9 {
                
                return 0
                
            }else if indexPath.section == 10{
                
                let GMSCameraPos = GMSCameraPosition.init(latitude: cordinates.latitude, longitude: cordinates.longitude, zoom: 14)
                
                self.Item_Map_View.camera = GMSCameraPos
                
                return 300
                
            }else if indexPath.section == 11 {
                
                return 60
                
            }else if indexPath.section == 12 {
                
                return 0
                
            }else if indexPath.section == 13 {
                
                return 60
                
            }
            
        }
        
        return 60
        
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
    
    
    
}







extension ServiceDetailView: UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    
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
