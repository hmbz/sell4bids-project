//
//  OrderViewController.swift
//  Sell4Bids
//
//  Created by admin on 11/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Firebase
import Cosmos
import GooglePlaces
import SwiftMessages

class OrderViewController: UIViewController , UIGestureRecognizerDelegate {
    
    
    //MARK:- Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var fidgetImageView: UIImageView!
    
    
    //MARK:-  Variables
    var MainApi = MainSell4BidsApi()
    var navi = UINavigationController().navigationBar
    var Heightcell = CGFloat()
  var MainAPi = MainSell4BidsApi()
   var ChatMessage = [ChatMessageList]()
  var ChatList = [ChatListModel]()
    // Alert View For rejection of the Order
    let rejectCounterOfferView = Bundle.main.loadNibNamed("rejectCustomView", owner: self, options: nil)?.first as! rejectCustomView
    var rejectCounterOfferAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    // custom view for Top bar
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    // For Item rehection
    var Rejecteditemid = String()
    var RejectedOrderid = String()
    var RejectedReason = String()
    var RejectedOrderQuantity = Int()
    var RejectedOrderImage = String()
    
    var ordersArray = [OrderViewModel]()
    var buyerArray = [UserModel]()
    var orderdata : OrderViewModel?
    var itemId: String?
    
    lazy var quantityStatus = false
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Orders"
        topMenu()
      NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("update"), object: nil)

        tableView.delegate = self
        tableView.dataSource = self
    }
  @objc func methodOfReceivedNotification(notification: Notification) {
       ReloadOrderData()
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ReloadOrderData()
      downloadAndShowChatList(id: "")
      
    }

      @objc func chatBtnTapped(_ sender: UIButton){
       
        
        print("Chat Button Tapped")
        
        let instance = ChatList
        
        //        Spinner.load_Spinner(image: fidgetImageView, view: self.DimView)
        MainAPi.Get_Chat(buyer_uid: instance[sender.tag].buyer_uid, item_id: instance[sender.tag].item_id, start: 0, limit: 15) { (status, data, error) in
                    if status {
        //                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        let message = data!["message"]
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
        
        
        
        
        
        
        //    MainAPi.Geid: <#String#>t_Chat_List(uid: "", start: 0, limit: 15) { (status, Data, error) in
    //
    //
    //    }


       
        
      }
      
      

      
      
    }
    override func viewLayoutMarginsDidChange() {
        // Setting Up Size of the Top Title View
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
    }
    
    //MARK:- Private functions
    private func topMenu() {
        titleview.titleLbl.text = StrOrders
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.titleView = titleview
    }
    
    private func ReloadOrderData() {
        self.ordersArray.removeAll()
        let body:[String:Any] = [
            "seller_uid" : SessionManager.shared.userId,
            "item_id" : self.itemId ?? "",
            "type" : "orders",
            "start" :  0,
            "limit" : 25
        ]
        Networking.instance.postApiCall(url: getOrderUrl, param: body) { (response, Error, StatusCode) in
          print(response)
          
            guard let jsonDic = response.dictionary else {return}
          
            let status = jsonDic["status"]?.bool ?? false
            if status == true {
                let messageArray = jsonDic["message"]?.array ?? []
                for item in messageArray {
                    guard let msgDic = item.dictionary else {return}
                    let type = msgDic["type"]?.string ?? ""
                    let sellerMarkedPaid = msgDic["seller_marked_paid"]?.bool ?? false
//                    let sellerUid = msgDic["seller_uid"]?.string ?? ""
//                    let currencySymbol = msgDic["currency_symbol"]?.string ?? ""
                    let status = msgDic["status"]?.string ?? ""
                    let boughtQuantity = msgDic["boughtQuantity"]?.int ?? 0
                    let itemId = msgDic["item_id"]?.string ?? ""
                    let address = msgDic["address"]?.string ?? "Location not shared yet"
                    let orderRejectReason = msgDic["orderRejectReason"]?.string ?? ""
                    let userArray = msgDic["users"]?.array ?? []
                    var userImage = ""
                    var uid = ""
                    var userAverageRating = 0.0
                    var userName = ""
                    for item in userArray {
                        let userDic = item.dictionary
                        uid = userDic?["uid"]?.string ?? ""
                        userAverageRating = userDic?["averagerating"]?.double ?? 0.0
                        userImage = userDic?["image"]?.string ?? ""
                        userName = userDic?["name"]?.string ?? ""
                    }
//                    let buyerRating = msgDic["buyer_Rating"]?.int ?? 0
                    let isLocationShared = msgDic["isLocationShared"]?.bool ?? false
//                    let buyerUid = msgDic["buyer_uid"]?.string ?? ""
//                    let sellerName = msgDic["sellerName"]?.string ?? ""
//                    let itemCategory = msgDic["itemCategory"]?.string ?? ""
//                    let buyerName = msgDic["buyerName"]?.string ?? ""
                    let boughtPrice = msgDic["boughtPrice"]?.int ?? 0
//                    let currencyString = msgDic["currency_string"]?.string ?? ""
                    let sellerRating = msgDic["seller_Rating"]?.double ?? 0.0
                    let orderId = msgDic["_id"]?.string ?? ""
                    let orders = OrderViewModel.init(item_id: itemId, order_status: status, image: userImage, user_id: uid, user_averagerating: userAverageRating, name: userName, order_id: orderId, type: type, buyer_item_recieved: false, price: boughtPrice, seller_marked_paid: sellerMarkedPaid, quantity: boughtQuantity, isLocationShared: isLocationShared, address: address, seller_rating: sellerRating, averagerating: sellerRating, orderRejectReason: orderRejectReason)
                    self.ordersArray.append(orders)
                }
              if self.ordersArray.count > 0{
                self.tableView.reloadData()
              }else{
                SweetAlert().showAlert("StrOrders".localizableString(loc: LanguageChangeCode), subTitle: "No Orders are Available on this item", style: .warning, buttonTitle: "StrOk".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black)
              }
                
            }
            else{
              showSwiftMessageWithParams(theme: .error, title: appName, body: "StrServerError".localizableString(loc: LanguageChangeCode))
            }
            
        }
    }
    
    //MARK:- Action
    
    // Back button tapped
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        
    }
    
    //TODO:- These Cells Button Actions are Made with wrong Method Change them into Objective C Button Actions Style (EK)
    @IBAction func ShareLocationBtn(_ sender: UIButton) {
        let Index = sender.tag
        let vc = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        vc.itemId = ordersArray[Index].item_id
        vc.orderId = ordersArray[Index].order_id
//        vc.modalPresentationStyle = .fullScreen
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    
    @IBAction func Accept_Offer_Btn(_ sender: UIButton) {
        SweetAlert().showAlert("strOrderConfirmation".localizableString(loc: LanguageChangeCode), subTitle: "strQConfirmOrder".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrYes".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
            if(ifYes == true){
                let parameter:[String:Any] = [
                    "seller_uid" : SessionManager.shared.userId,
                    "item_id" : self.ordersArray[sender.tag].item_id,
                    "order_id" : self.ordersArray[sender.tag].order_id,
                    "sellerName" : SessionManager.shared.name,
                    "sellerImage" : self.ordersArray[sender.tag].image,
                    "quantity": self.ordersArray[sender.tag].quantity
                ]
                Networking.instance.postApiCall(url: acceptOrderUrl, param: parameter) { (response, Error, StatusCode) in
                    guard let jsonDic = response.dictionary else {return}
                    let status = jsonDic["status"]?.bool ?? false
                    let message = jsonDic["message"]?.string ?? ""
                    if status == true {
                        showSwiftMessageWithParams(theme: .success, title: "strOrderConfirmation".localizableString(loc: LanguageChangeCode), body: message)
                        self.ReloadOrderData()
                    }
                    else{
                        showSwiftMessageWithParams(theme: .error, title: "strOrderConfirmation".localizableString(loc: LanguageChangeCode), body: message)
                    }
                }
            }
        }
    }
    
    
    @objc func submitReasonTappedonCounterOffer(sender: UIButton) {
        if rejectCounterOfferView.selectedBtnTitle == "" {
            self.view.makeToast("Please select reason for rejection", position:.top)
        }else {
            let param:[String:Any] = [
                "seller_uid" : SessionManager.shared.userId,
                "item_id" : self.Rejecteditemid,
                "order_id" : self.RejectedOrderid,
                "sellerName" : SessionManager.shared.name,
                "sellerImage" : self.RejectedOrderImage,
                "orderRejectReason" : rejectCounterOfferView.selectedBtnTitle,
                "quantity" : self.RejectedOrderQuantity
            ]
            Networking.instance.postApiCall(url: rejectOrderUrl, param: param) { (response, Error, StatusCode) in
                print(response)
                guard let jsonDic = response.dictionary else {return}
                let status = jsonDic["status"]?.bool ?? false
                let message = jsonDic["message"]?.string ?? ""
                if status == true {
                    showSwiftMessageWithParams(theme: .success, title: "strOrderRejection".localizableString(loc: LanguageChangeCode), body: message)
                    self.rejectCounterOfferAlert.dismiss(animated: true, completion: nil)
                    self.ReloadOrderData()
                }
                else{
                    showSwiftMessageWithParams(theme: .error, title: "strOrderRejection".localizableString(loc: LanguageChangeCode), body: message)
                }
            }
        }
    }
    
    
    @IBAction func Reject_Order_btn(_ sender: UIButton) {
        
        let Index : Int = sender.tag
        Rejecteditemid = ordersArray[Index].item_id
        RejectedOrderid = ordersArray[Index].order_id
        RejectedReason = rejectCounterOfferView.selectedBtnTitle
        RejectedOrderQuantity = ordersArray[Index].quantity
        RejectedOrderImage = ordersArray[Index].image
        
        rejectCounterOfferAlert.view.frame = rejectCounterOfferView.frame
        rejectCounterOfferAlert.view.addSubview(rejectCounterOfferView)
        rejectCounterOfferView.continueBtn.addTarget(self, action: #selector(submitReasonTappedonCounterOffer), for: .touchUpInside)
        rejectCounterOfferView.cancelBtn.addTarget(self, action: #selector(closeRejectReason), for: .touchUpInside)
        self.present(rejectCounterOfferAlert, animated: true, completion: nil)
    }
    
    @objc func closeRejectReason(){
        rejectCounterOfferAlert.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SellerMarkPaidBtn(_ sender: UIButton) {
        SweetAlert().showAlert("strMarkedAsPaid".localizableString(loc: LanguageChangeCode), subTitle: "strQRejectOrder".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrYes".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
            if(ifYes == true){
                let body:[String:Any] = [
                    "seller_uid" : SessionManager.shared.userId,
                    "itemId" : self.ordersArray[sender.tag].item_id,
                    "order_id" : self.ordersArray[sender.tag].order_id,
                    "sellerName" : SessionManager.shared.name,
                    "sellerImage" : self.ordersArray[sender.tag].image,
                    "seller_marked_paid" : true
                ]
                Networking.instance.postApiCall(url: sellerMarkedPaidUrl, param: body) { (response, Error, StatusCode) in
                    guard let jsonDic = response.dictionary else {return}
                    let status = jsonDic["status"]?.bool ?? false
                    let message = jsonDic["message"]?.string ?? ""
                    if status == true {
                        showSwiftMessageWithParams(theme: .success, title: "strMarkedAsPaid".localizableString(loc: LanguageChangeCode), body: message)
                        self.ReloadOrderData()
                    }
                    else{
                        showSwiftMessageWithParams(theme: .error, title: "strMarkedAsPaid".localizableString(loc: LanguageChangeCode), body: message)
                    }
                }
            }
        }
    }
}

extension OrderViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderViewCell
      cell.chatBtn.tag = indexPath.row
      cell.chatBtn.addTarget(self, action: #selector(chatBtnTapped(_:)), for: UIControlEvents.touchUpInside)
        let widhttxt = ordersArray[indexPath.row].address.widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 2))
        
        print("widhttxt == \(widhttxt)")
        cell.RejectOrder.tag = indexPath.row
        cell.ShareLocation.tag = indexPath.row
        if ordersArray[indexPath.row].order_status == "Completed" {
            
            
            self.Heightcell = 250 + widhttxt
            cell.BuyerName.text = ordersArray[indexPath.row].name
            
            if quantityStatus == true {
                cell.ItemQuantity_Price.text = "$\(ordersArray[indexPath.row].price) X \(ordersArray[indexPath.row].quantity)"
            }else {
                 cell.ItemQuantity_Price.text = "$\(ordersArray[indexPath.row].price)"
            }
            
           
            cell.AcceptOrRejectBtnsView.isHidden = true
            cell.MarkPaid.isHidden = true
            cell.BuyerItemRecivedTic.isHidden = true
            cell.BuyerItemReviedTxt.isHidden = true
            cell.locationtxt.text = ordersArray[indexPath.row].address
            
            cell.RejectedView.isHidden = true
            
            
            
            
            
            
        }else if ordersArray[indexPath.row].order_status == "Pending" {
            cell.BuyerName.text = ordersArray[indexPath.row].name
            
            cell.ItemQuantity_Price.text = " Pending "
            cell.priceLbl.textColor = UIColor.red
            cell.ItemQuantity_Price.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            
            if quantityStatus == true {
                cell.priceLbl.text = "$ \(ordersArray[indexPath.row].price) X \(ordersArray[indexPath.row].quantity)"
            }else {
                 cell.priceLbl.text = "$ \(ordersArray[indexPath.row].price)"
            }
            
            
            
            
            cell.locationtxt.text = ordersArray[indexPath.row].address
            cell.BuyerAcceptAndRejectBtns.isHidden = false
            cell.RattingDetailView.isHidden = true
            cell.BuyerPaidStatusView.isHidden = true
            cell.BuyerAcceptAndRejectBtns.isHidden = true
            cell.AcceptOrRejectBtnsView.isHidden = false
            cell.RejectedView.isHidden = true
            cell.AcceptOrder.tag = indexPath.row
            cell.RejectOrder.tag = indexPath.row
            
            self.Heightcell = 100 + widhttxt
        }else if ordersArray[indexPath.row].order_status == "Accepted" {
            self.Heightcell = 250 + widhttxt
            cell.BuyerAcceptAndRejectBtns.isHidden = false
            cell.BuyerPaidStatusView.isHidden = true
            cell.BuyerItemRecivedView.isHidden = true
            cell.SellerPaidRecived.isHidden = true
            
            
            cell.MarkPaid.isHidden = false
            cell.RejectedView.isHidden = true
            cell.AcceptOrRejectBtnsView.isHidden = true
            
            cell.BuyerPaidStatusView.isHidden = false
            cell.RattingDetailView.isHidden = false
            
            //             cell.locationtxt.text = ordersArray[indexPath.row].address
            cell.BuyerName.text = ordersArray[indexPath.row].name
            
            cell.actualPriceLbl.text = "Sold At:"
            cell.priceLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
            if quantityStatus == true {
                cell.priceLbl.text = "$ \(ordersArray[indexPath.row].price) X \(ordersArray[indexPath.row].quantity)"
            }else {
                 cell.priceLbl.text = "$ \(ordersArray[indexPath.row].price)"
            }
            
            
            
            cell.ItemQuantity_Price.text = "  Accepted  "
            cell.ItemQuantity_Price.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            
            if ordersArray[indexPath.row].isLocationShared == true {
                cell.locationtxt.text = ordersArray[indexPath.row].address
            }
            
            
            cell.MarkPaid.tag = indexPath.row
            let averageratings = Double(round(1000*self.ordersArray[indexPath.row].averagerating)/1000)
            cell.RattingLabel.text = "Average Rating : \(averageratings)"
            
            if self.ordersArray[indexPath.row].seller_rating != -2 {
                cell.RattingView.didFinishTouchingCosmos = { rating in
                    cell.RattingLabel.text = "You Ratted : \(rating)"
                    let body:[String:Any] = [
                        "seller_uid" : self.ordersArray[indexPath.row].user_id,
                        "item_id" : self.ordersArray[indexPath.row].item_id,
                        "order_id" : self.ordersArray[indexPath.row].order_id,
                        "buyer_name" : self.ordersArray[indexPath.row].name,
                        "buyer_image" : self.ordersArray[indexPath.row].image,
                        "rating" : rating
                    ]
                    Networking.instance.postApiCall(url: buyerRatingUrl, param: body) { (response, Error, StatusCode) in
                        guard let jsonDic = response.dictionary else {return}
                        let status = jsonDic["status"]?.bool ?? false
                        let message = jsonDic["message"]?.string ?? ""
                        if status == true {
                            showSwiftMessageWithParams(theme: .success, title: "strBuyerRated".localizableString(loc: LanguageChangeCode), body: message)
                        }
                        else{
                            showSwiftMessageWithParams(theme: .error, title: "strBuyerRated".localizableString(loc: LanguageChangeCode), body: message)
                        }
                    }
//                    self.MainApi.Ratting_Buyyer(buyer_uid: self.ordersArray[indexPath.row].user_id, itemId: self.ordersArray[indexPath.row].item_id, orderId: self.ordersArray[indexPath.row].order_id, buyerName: self.ordersArray[indexPath.row].name, buyerImage: self.ordersArray[indexPath.row].image, ratting: rating, completionHandler: { (status, data, error) in
//
//                        if status {
//                            _ = SweetAlert().showAlert("Buyer Rated", subTitle: "Successfully Rated", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
//                                if status {
//                                    self.ReloadOrderData()
//                                }
//                            })
//
//                        }
//                    })
                }
            }else {
                cell.RattingView.rating = self.ordersArray[indexPath.row].seller_rating
                cell.RattingView.isUserInteractionEnabled = false
            }
            
            if ordersArray[indexPath.row].seller_marked_paid == true {
                
                cell.SellerPaidRecived.isHidden = false
                cell.SellerTicImg.isHidden = false
                cell.MarkPaid.isHidden = true
                cell.SellerPaidtxt.isHidden = false
                cell.SellerPaidtxt.text = "You Marked this as paid."
            }else {
                
                
            }
            
            if ordersArray[indexPath.row].buyer_item_recieved == true {
                print("Buyer Status == \(ordersArray[indexPath.row].buyer_item_recieved)")
                cell.BuyerItemRecivedView.isHidden = false
                cell.BuyerItemReviedTxt.text = "Buyer Marked this Item as  Recieved."
                cell.BuyerItemRecivedTic.isHidden = false
                cell.BuyerItemReviedTxt.isHidden = false
                
            }else {
                
                
            }
            
            
            
            cell.locationtxt.text = ordersArray[indexPath.row].address
            
        }else if ordersArray[indexPath.row].order_status == "Rejected" {
            self.Heightcell = 60 + widhttxt
            
            cell.RejectedView.isHidden = false
            cell.BuyerPaidStatusView.isHidden = true
            cell.AcceptOrRejectBtnsView.isHidden = true
            cell.RattingDetailView.isHidden = true
            cell.BuyerAcceptAndRejectBtns.isHidden = true
            
            //            cell.RejectedStatustxt.text = self.ordersArray[indexPath.row].orderRejectReason
            cell.RejectedStatustxt.isHidden = true
            
            if quantityStatus == true {
                cell.priceLbl.text = "$ \(ordersArray[indexPath.row].price) X \(ordersArray[indexPath.row].quantity)"
            }else {
                cell.priceLbl.text = "$ \(ordersArray[indexPath.row].price)"
            }
            
            cell.priceLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.ItemQuantity_Price.text = " Rejected "
            cell.ItemQuantity_Price.backgroundColor = colorRed
            
            
            cell.BuyerName.text = ordersArray[indexPath.row].name
            
        }
        
        
        cell.ItemQuantity_Price.layer.cornerRadius = 15
        cell.ItemQuantity_Price.layer.masksToBounds = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.Heightcell
    }
  
  
  func downloadAndShowChatList(id:String) {
       ChatList.removeAll()
       MainAPi.Get_Chat_List(uid: SessionManager.shared.userId, start: ChatList.count, limit: 15) { (status, data, error) in
           let message = data!["message"]
           print(message)
           if status {
               for msg in message {
                   let buyerdetail = msg.1["_id"]
                   let buyer_uid_buyer_id = buyerdetail["buyer_uid"].stringValue
                   let item_id = buyerdetail["item_id"].stringValue
                   let lastChat = msg.1["lastChat"]
                   let item_price = lastChat["item_price"].stringValue
                   let created_at = lastChat["created_at"].int64Value
                   let receiver_uid = lastChat["receiver_uid"].stringValue
                   let item_title = lastChat["item_title"].stringValue
                   let receiver = lastChat["receiver"].stringValue
                   let itemCategory = lastChat["itemCategory"].stringValue
                   let buyer_uid = lastChat["buyer_uid"].stringValue
                   let id = lastChat["_id"].stringValue
                   let seller_uid = lastChat["seller_uid"].stringValue
                   let item_id_uid = lastChat["item_id"].stringValue
                   let message = lastChat["message"].stringValue
                   let itemAuctionType = lastChat["itemAuctionType"].stringValue
                   let sender = lastChat["sender"].stringValue
                   let item_image = lastChat["item_image"].stringValue
                   let read = lastChat["read"].boolValue
                   let sender_uid = lastChat["sender_uid"].stringValue
                   let delivered_time = lastChat["delivered_time"].int64Value
                   
                   let Chatdata = ChatListModel.init(buyer_uid_id: buyer_uid_buyer_id, item_id_buyer_uid: item_id, item_price: item_price, created_at: created_at, receiver_uid: receiver_uid, item_title: item_title, receiver: receiver, itemCategory: itemCategory, buyer_uid: buyer_uid, id: id, seller_uid: seller_uid, item_id: item_id_uid, item_image: item_image, message: message, itemAuctionType: itemAuctionType, sender: sender , read: read, sender_uid: sender_uid,delivered_time: delivered_time )
                   self.ChatList.append(Chatdata)
                   print("ChatData == \(Chatdata.sender)")
                   
               }
           }else {
               
                         }
       }
  }
}

