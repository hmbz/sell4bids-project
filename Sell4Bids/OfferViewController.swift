//
//  OfferViewController.swift
//  Sell4Bids
//
//  Created by admin on 11/9/19.
//  Copyright © 2019 admin. All rights reserved.
//


import UIKit

class OfferViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    //MARK:- Properties
    @IBOutlet weak var tableview: UITableView!
  
    var ChatList = [ChatListModel]()
    //MARK:- Variables
    var indexrejectbtn = Int()
    var estimateheight = CGFloat()
  var MainAPi = MainSell4BidsApi()
  var ChatMessage = [ChatMessageList]()
//    var SendCounterOffer = Bundle.main.loadNibNamed("OfferNow_Custom_View", owner: self, options: nil)?.first as! OfferNowCustomView
//    var SendCounterOfferAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    lazy var multipleTextFieldView = Bundle.main.loadNibNamed("MultipleTextFieldView", owner: self, options: nil)?.first as! MultipleTextFieldView
    lazy var multipleTextFieldViewAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    lazy var singleTextFieldView = Bundle.main.loadNibNamed("singleTextFieldView", owner: self, options: nil)?.first as! singleTextFieldView
    lazy var singleTextFieldViewAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    
    var navi = UINavigationController().navigationBar
//    let RejectOfferView = Bundle.main.loadNibNamed("Reject_Order_View", owner: self, options: nil)?.first as! RejectedOrderView
//    var RejectOfferViewAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    var offerhistory = [offers]()
    var counterOfferIndex = Int()
    var MainApi = MainSell4BidsApi()
    var itemId: String?
    var itemCategory: String?
    var OfferArray = [OfferModel]()
    lazy var QuantityStatus = false
    
    //MARK:- View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Offers"
      NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("update"), object: nil)


        topMenu()
//        ReloadOfferData()
        tableview.delegate = self
        tableview.dataSource = self
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
      ReloadOfferData()
  }

    override func viewLayoutMarginsDidChange() {
        // Setting Up Size of the Top Title View
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        ReloadOfferData()
    }
    
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        titleview.titleLbl.text = StrOffers
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.titleView = titleview
    }
    
    //MARK:-  Actions
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.dismiss(animated: true, completion: nil)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        
    }
    
    
    //MARK:- Action
    
     func Reject_Offer_Api() {
            let body:[String:Any] = [
                "seller_name" : SessionManager.shared.name,
                "seller_image" : SessionManager.shared.image,
                "seller_uid" : SessionManager.shared.userId,
                "order_id" : self.OfferArray[indexrejectbtn].id,
                "orderRejectReason" : "",
                "item_id" : self.OfferArray[indexrejectbtn].item_id,
                "quantity": self.OfferArray[indexrejectbtn].boughtQuantity
            ]
            Networking.instance.postApiCall(url: rejectSellerOfferUrl, param: body) { (response, Error, StatusCode) in
                guard let jsonDic = response.dictionary else {return}
                let status = jsonDic["status"]?.bool ?? false
                let message = jsonDic["message"]?.string ?? ""
                if status == true {
                    showSwiftMessageWithParams(theme: .success, title: "strSellerRejectOffer".localizableString(loc: LanguageChangeCode), body: message)
                    self.ReloadOfferData()
                }
                else{
                    showSwiftMessageWithParams(theme: .error, title: "strOrderConfirmation".localizableString(loc: LanguageChangeCode), body: message)
                }
            }
    }
    
    @IBAction func ViewOfferHistory(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.init(name: "ItemDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "OfferHistoryView") as! OfferHistoryTableView
        controller.OfferHistory = self.OfferArray[sender.tag]
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
//    @objc func Close_Reject_btn() {
//
//        RejectOfferViewAlert.dismiss(animated: true, completion: nil)
//
//    }
    
    
    
    @IBAction func Reject_Offer(_ sender: UIButton) {
        let index = sender.tag
        indexrejectbtn = index
        
        SweetAlert().showAlert("StrCounterOffer".localizableString(loc: LanguageChangeCode), subTitle: "strQRejectCounterOffer".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrYes".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
            if(ifYes == true){
                self.Reject_Offer_Api()
            }
        }
//        RejectOfferViewAlert.view.frame = RejectOfferView.frame
//        RejectOfferViewAlert.view.addSubview(RejectOfferView)
//        RejectOfferView.SubmitBtn.addTarget(self, action: #selector(Reject_Offer_Api), for: .touchUpInside)
//        RejectOfferView.Close_Btn.addTarget(self, action: #selector(Close_Reject_btn), for: .touchUpInside)
//
//        self.present(RejectOfferViewAlert, animated: true, completion: nil)
    }
    
    @IBAction func Accept_Offer(_ sender: UIButton) {
        SweetAlert().showAlert("strSellerAcceptOffer".localizableString(loc: LanguageChangeCode), subTitle: "strQConfirmOrder".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrYes".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
            if(ifYes == true){
                let body:[String:Any] = [
                    "seller_name" : SessionManager.shared.name,
                    "seller_image" : SessionManager.shared.image,
                    "seller_uid" : SessionManager.shared.userId,
                    "order_id" : self.OfferArray[sender.tag].id,
                    "item_id" : self.itemId ?? "",
                    "quantity": self.OfferArray[sender.tag].boughtQuantity
                ]
                Networking.instance.postApiCall(url: acceptSellerOfferUrl, param: body) { (response, Error, StatusCode) in
                    print(response)
                    guard let jsonDic = response.dictionary else {return}
                    let status = jsonDic["status"]?.bool ?? false
                    let message = jsonDic["message"]?.string ?? ""
                    if status == true {
                        showSwiftMessageWithParams(theme: .success, title: "strSellerAcceptOffer".localizableString(loc: LanguageChangeCode), body: message)
                        self.ReloadOfferData()
                    }
                    else{
                        showSwiftMessageWithParams(theme: .error, title: "strOrderConfirmation".localizableString(loc: LanguageChangeCode), body: message)
                    }
                }
            }
        }
    }
    
    
    @IBAction func MarkedasPaid(_ sender: UIButton) {
        SweetAlert().showAlert("strMarkedAsPaid".localizableString(loc: LanguageChangeCode), subTitle: "strQRejectOrder".localizableString(loc: LanguageChangeCode), style: AlertStyle.warning, buttonTitle: "StrYes".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
            if(ifYes == true){
                let body:[String:Any] = [
                    "seller_uid" : SessionManager.shared.userId,
                    "itemId" : self.OfferArray[sender.tag].item_id,
                    "order_id" : self.OfferArray[sender.tag].id,
                    "sellerName" : SessionManager.shared.name,
                    "sellerImage" : SessionManager.shared.image,
                    "seller_marked_paid" : true
                ]
                Networking.instance.postApiCall(url: sellerMarkedPaidUrl, param: body) { (response, Error, StatusCode) in
                    guard let jsonDic = response.dictionary else {return}
                    let status = jsonDic["status"]?.bool ?? false
                    let message = jsonDic["message"]?.string ?? ""
                    if status == true {
                        showSwiftMessageWithParams(theme: .success, title: "strMarkedAsPaid".localizableString(loc: LanguageChangeCode), body: message)
                        self.ReloadOfferData()
                    }
                    else{
                        showSwiftMessageWithParams(theme: .error, title: "strMarkedAsPaid".localizableString(loc: LanguageChangeCode), body: message)
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func ShareLocationBtn(_ sender: UIButton) {
        let Index = sender.tag
        let vc = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        vc.itemId = OfferArray[Index].item_id
        vc.orderId = OfferArray[Index].id
//        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @objc func SendCounterOfferclose() {
        multipleTextFieldViewAlert.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeSingleCounterOffer(sender:UIButton){
        singleTextFieldViewAlert.dismiss(animated: true, completion: nil)
    }
    
    @objc func Send_Offer_Counter_Api() {
        let itemQuantity = Int(self.OfferArray[counterOfferIndex].quantity)
        let textFieldQuantity = Int(multipleTextFieldView.quantityTextField.text ?? "0") ?? 0
        if multipleTextFieldView.priceTextField.text!.isEmpty {
            self.view.makeToast("strCounterOfferEmptyPrice".localizableString(loc: LanguageChangeCode), position:.top)
        }
        else if multipleTextFieldView.quantityTextField.text!.isEmpty {
            self.view.makeToast("strCounterOfferEmptyQuantity".localizableString(loc: LanguageChangeCode), position:.top)
        }
        else if textFieldQuantity > itemQuantity{
            self.view.makeToast("strCounterOfferQuantityCheck".localizableString(loc: LanguageChangeCode), position:.top)
        }else {
            let quantity = multipleTextFieldView.quantityTextField.text ?? "1"
            let amount = multipleTextFieldView.priceTextField.text ?? ""
            MainApi.Send_Counter_Offer_Seller(seller_uid: SessionManager.shared.userId, buyer_uid: self.OfferArray[counterOfferIndex].user!.last!.id, offer_price: amount, item_id: self.OfferArray[counterOfferIndex].item_id, offer_quantity: quantity, order_id: self.OfferArray[counterOfferIndex].id, offer_count: self.OfferArray[counterOfferIndex].sellerOfferCount, seller_name: SessionManager.shared.name, seller_image: SessionManager.shared.image, itemCategory: self.itemCategory ?? "") { (status, data, error) in
                
                if status {
                    _ = SweetAlert().showAlert("StrCounterOffer".localizableString(loc: LanguageChangeCode), subTitle: "strCounterOfferSuccessfullySend".localizableString(loc: LanguageChangeCode), style: .success, buttonTitle: "StrOk".localizableString(loc: LanguageChangeCode), action: { (status) in
                        if status {
                            self.ReloadOfferData()
                            self.multipleTextFieldViewAlert.dismiss(animated: true, completion: nil)
                        }
                    })
                }else {
                    _ = data!["message"].stringValue
                    _ = SweetAlert().showAlert("StrCounterOffer".localizableString(loc: LanguageChangeCode), subTitle: data!["message"].stringValue, style: .error, buttonTitle: "StrOk".localizableString(loc: LanguageChangeCode), action: { (status) in
                        if status {
                            self.ReloadOfferData()
                        }
                    })
                    
                }
            }
        }
    }
    
    @objc func singleCounterOfferApiCall(sender: UIButton) {
        if singleTextFieldView.firstTextField.text!.isEmpty {
            self.view.makeToast("strCounterOfferEmptyPrice".localizableString(loc: LanguageChangeCode), position:.top)
        }else {
            let amount = singleTextFieldView.firstTextField.text ?? ""
            MainApi.Send_Counter_Offer_Seller(seller_uid: SessionManager.shared.userId, buyer_uid: self.OfferArray[counterOfferIndex].user!.last!.id, offer_price: amount, item_id: self.OfferArray[counterOfferIndex].item_id, offer_quantity: "1", order_id: self.OfferArray[counterOfferIndex].id, offer_count: self.OfferArray[counterOfferIndex].sellerOfferCount, seller_name: SessionManager.shared.name, seller_image: SessionManager.shared.image, itemCategory: self.itemCategory ?? "") { (status, data, error) in
                
                if status {
                    _ = SweetAlert().showAlert("StrCounterOffer".localizableString(loc: LanguageChangeCode), subTitle: "strCounterOfferSuccessfullySend".localizableString(loc: LanguageChangeCode), style: .success, buttonTitle: "StrOk".localizableString(loc: LanguageChangeCode), action: { (status) in
                        if status {
                            self.ReloadOfferData()
                            self.singleTextFieldViewAlert.dismiss(animated: true, completion: nil)
                        }
                    })
                }else {
                    _ = data!["message"].stringValue
                    _ = SweetAlert().showAlert("StrCounterOffer".localizableString(loc: LanguageChangeCode), subTitle: data!["message"].stringValue, style: .error, buttonTitle: "StrOk".localizableString(loc: LanguageChangeCode), action: { (status) in
                        if status {
                            self.ReloadOfferData()
                        }
                    })
                    
                    
                }
            }
        }
    }
    
    @IBAction func SendCounterOffer(_ sender: UIButton) {
        counterOfferIndex = sender.tag
        if QuantityStatus == true {
            self.multipleTextFieldViewAlert.view.frame = self.multipleTextFieldView.frame
            self.multipleTextFieldView.crossBtn.addTarget(self, action: #selector(SendCounterOfferclose), for: .touchUpInside)
            self.multipleTextFieldView.sendBtn.addTarget(self, action: #selector(Send_Offer_Counter_Api), for: .touchUpInside)
            self.multipleTextFieldView.priceTextField.keyboardType = .numberPad
            self.multipleTextFieldView.priceTextField.delegate = self
            
            self.multipleTextFieldView.quantityTextField.keyboardType = .numberPad
            self.multipleTextFieldView.quantityTextField.delegate = self
            self.multipleTextFieldViewAlert.view.addSubview(multipleTextFieldView)
            self.present(multipleTextFieldViewAlert, animated: true, completion: nil)
        }else {
            self.singleTextFieldViewAlert.view.frame = self.singleTextFieldView.frame
            self.singleTextFieldView.titleLbl.text = "StrCounterOffer".localizableString(loc: LanguageChangeCode)
            self.singleTextFieldView.firstTextField.keyboardType = .numberPad
            self.singleTextFieldView.firstTextField.delegate = self
            self.singleTextFieldView.textFieldTitleLbl.text = "Offer Price"
            self.singleTextFieldView.firstTextField.placeholder = "Price"
            self.singleTextFieldView.crossBtn.addTarget(self, action: #selector(closeSingleCounterOffer), for: .touchUpInside)
            self.singleTextFieldView.sendBtn.addTarget(self, action: #selector(singleCounterOfferApiCall(sender:)), for: .touchUpInside)
            self.singleTextFieldViewAlert.view.addSubview(singleTextFieldView)
            self.present(singleTextFieldViewAlert, animated: true, completion: nil)
        }
    }
    
    //MARK:- Private Functions
    private func ReloadOfferData() {
        offerhistory.removeAll()
        OfferArray.removeAll()
        MainApi.Get_Offers(seller_uid: SessionManager.shared.userId, item_id: self.itemId ?? "", type: "offers", sellerImage: SessionManager.shared.image) { (status, data, error) in
            print(data!)
            if status {
                _ = data!["message"]
                let message = data!["data"].stringValue
                if message.contains("No Orders available on this item") {
                  SweetAlert().showAlert("StrOffers".localizableString(loc: LanguageChangeCode), subTitle: "No Offers are Available on this item", style: .warning, buttonTitle: "StrOk".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black)
                    
                }else {
                    
                    for offerdata in data!["message"] {
                        var userdata = [users]()
                        var offersdataoffers = [offers]()
                        let item_id = offerdata.1["item_id"].stringValue
                        let type = offerdata.1["type"].stringValue
                        let status = offerdata.1["status"].stringValue
                        let selletOfferCount = offerdata.1["sellerOfferCount"].intValue
                        let seller_uid = offerdata.1["seller_uid"].stringValue
                        let seller_marked_paid = offerdata.1["seller_marked_paid"].boolValue
                        let buyerOfferCount = offerdata.1["buyerOfferCount"].intValue
                        let price = offerdata.1["price"].stringValue
                        let id = offerdata.1["_id"].stringValue
                        let buyer_uid = offerdata.1["buyer_uid"].stringValue
                        let userdataoffer = offerdata.1["users"]
                        let boughtPrice = offerdata.1["boughtPrice"].stringValue
                        let boughtQuantity = offerdata.1["boughtQuantity"].stringValue
                        let orderRejectReason = offerdata.1["orderRejectReason"].stringValue
                        let lastOfferBuyer = offerdata.1["lastOfferBuyer"].intValue
                        let lastQuantityBuyer = offerdata.1["lastQuantityBuyer"].intValue
                        let lastOfferSeller = offerdata.1["lastOfferSeller"].intValue
                        let lastQuantitySeller = offerdata.1["lastQuantitySeller"].intValue
                        let currencysString = offerdata.1["currency_symbol"].stringValue
                        let quantity = offerdata.1["quantity"].intValue
                        
                        let seller_Rating = offerdata.1["seller_Rating"].doubleValue
                        let buyer_Rating = offerdata.1["buyer_Rating"].doubleValue
                        let isLocationShared = offerdata.1["isLocationShared"].boolValue
                        let address = offerdata.1["address"].stringValue
                        
                        
                        for dataoffers in offerdata.1["offers"] {
                            let quantity = dataoffers.1["quantity"].stringValue
                            let price = dataoffers.1["price"].stringValue
                            let role = dataoffers.1["role"].stringValue
                            let time = dataoffers.1["time"].int64Value
                            let message = dataoffers.1["message"].stringValue
                            
                            let dataoffersdata = offers.init(quantity: quantity, price: price, message: message, role: role, time: time)
                            
                            offersdataoffers.append(dataoffersdata)
                            self.offerhistory.append(dataoffersdata)
                        }
                        for useroffer in userdataoffer {
                            print("User uid == \(useroffer.1["uid"].stringValue)")
                            print("User uid == \(useroffer.1["_id"].stringValue)")
                            print("User uid == \(useroffer.1["name"].stringValue)")
                            
                            
                            let uid = useroffer.1["uid"].stringValue
                            let id = useroffer.1["_id"].stringValue
                            let name = useroffer.1["name"].stringValue
                            let averagerating = useroffer.1["averagerating"].doubleValue
                            let datauser = users.init(uid: uid, id: id, name: name ,averagerating : averagerating )
                            userdata.append(datauser)
                            
                        }
                        
                        let maindataoffer = OfferModel.init(id: id, user: userdata, item_id: item_id, type: type, status: status, sellerOfferCount: selletOfferCount, seller_uid: seller_uid, seller_marked_paid: seller_marked_paid, buyerOfferCount: buyerOfferCount, price: price, offers: offersdataoffers, buyer_uid: buyer_uid , boughtPrice: boughtPrice , boughtQuantity: boughtQuantity , orderRejectReason : orderRejectReason ,lastOfferBuyer: lastOfferBuyer, seller_Rating: seller_Rating , buyer_Rating: buyer_Rating,isLocationShared: isLocationShared , address: address,lastQuantityBuyer:lastQuantityBuyer,lastOfferSeller: lastOfferSeller,lastQuantitySeller:lastQuantitySeller, currency_string: currencysString, quantity: quantity)
                        self.OfferArray.append(maindataoffer)
                        self.tableview.reloadData()
                    }
                }
            }
            print("status == \(status)")
            print("data == \(data!)")
            print("error == \(error)")
            print(self.OfferArray)
        }
    }
    
    
    
    //MARK:- Table View Life cycle
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.OfferArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewOfferCell
      cell.Chat.tag = indexPath.row
      cell.Chat.addTarget(self, action: #selector(chatBtnTapped(_:)), for: .touchUpInside)
        guard indexPath.row < self.OfferArray.count else {return cell}
        if self.OfferArray[indexPath.row].status == "Pending" {
            estimateheight = 330
            cell.BuyerAcceptRejectBtnView.isHidden = false
            cell.BuyerandSellerPaidView.isHidden = true
            cell.SellerPaidView.isHidden = true
            cell.RattingDetailView.isHidden = true
            cell.BuyerItemRecivedView.isHidden = true
            cell.RejectStatusView.isHidden = true
            cell.BuyerAcceptRejectCounterView.isHidden = true
            cell.AcceptRejectOfferHistorybtn.isHidden = false
            cell.AcceptRejectOfferHistorybtn.tag = indexPath.row
            cell.AcceptOrder.tag = indexPath.row
            cell.RejectOrder.tag = indexPath.row
            cell.SendCounterOffer.tag = indexPath.row
            
            if self.OfferArray[indexPath.row].sellerOfferCount >= 5 {
                cell.SendCounterOffer.isEnabled = false
                cell.SendCounterOffer.setTitleColor(UIColor.black, for: .normal)
                cell.SendCounterOffer.backgroundColor = UIColor.white
            }
            
            cell.OfferDetailView.isHidden = false
            if self.OfferArray[indexPath.row].user!.count > 0 {
                cell.sellerNameLbl.text = self.OfferArray[indexPath.row].user!.last!.name
            }
            cell.priceStackView.isHidden = false
            cell.buyerOfferStackView.isHidden = false
            cell.yourOfferStack.isHidden = false
            let instance = self.OfferArray[indexPath.row]
            cell.buyerNameLbl.text = "Buyer's offer:"
            let priceB = instance.lastOfferBuyer
            let quantityB = instance.lastQuantityBuyer
            let currencySymbol = instance.currencyString
            if QuantityStatus == true {
               cell.buyerOfferPriceLbl.text = "\(currencySymbol)\(priceB!) X \(quantityB!)"
            }else {
               cell.buyerOfferPriceLbl.text = "\(currencySymbol)\(priceB!)"
            }
            
            cell.youOfferLbl.text = "Seller offer:"
            let priceS = instance.lastOfferSeller
            let quantityS = instance.lastQuantitySeller
            
            if QuantityStatus == true {
               cell.yourOfferPriceLbl.text = "\(currencySymbol)\(priceS!) X \(quantityS!)"
            }else {
                cell.yourOfferPriceLbl.text = "\(currencySymbol)\(priceS!)"
            }
            let price = self.OfferArray[indexPath.row].price
            cell.priceLbl.text = "\(currencySymbol)\(price)"
            cell.itemQuantity.text = " Pending "
            cell.itemQuantity.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
        else if self.OfferArray[indexPath.row].status == "Accepted" {
            estimateheight = 300
            cell.buyerOfferStackView.isHidden = false
            cell.priceStackView.isHidden = true
            cell.yourOfferStack.isHidden = true
            
            cell.buyerNameLbl.text = "Sold At:"
            
            let boughtPrice = OfferArray[indexPath.row].boughtPrice
            let boughtQuantity = OfferArray[indexPath.row].boughtQuantity
            let currencySymbol = OfferArray[indexPath.row].currencyString
            
            if QuantityStatus == true {
               cell.buyerOfferPriceLbl.text = currencySymbol + boughtPrice + " X " + boughtQuantity
            }else {
                cell.buyerOfferPriceLbl.text = currencySymbol + boughtPrice
            }
            
            
            cell.BuyerAcceptRejectBtnView.isHidden = true
            cell.BuyerandSellerPaidView.isHidden = true
            cell.BuyerItemRecivedView.isHidden = true
            cell.RattingDetailView.isHidden = false
            cell.RejectStatusView.isHidden = true
            cell.BuyerAcceptRejectCounterView.isHidden = false
            cell.BuyerandSellerPaidView.isHidden = true
//            cell.acceptRejectStack.isHidden = true
            
            cell.MarkasPaidbtn.isHidden = false
            cell.ShareLocationbtn.tag = indexPath.row
            cell.MarkasPaidbtn.tag = indexPath.row
            cell.SendCounterOffer.tag = indexPath.row
            if OfferArray[indexPath.row].seller_marked_paid == true {
                estimateheight = 350
                cell.BuyerandSellerPaidView.isHidden = false
                cell.MarkasPaidbtn.isHidden = true
                cell.SellerPaidView.isHidden = false
                cell.SellerPaidLbl.text = "Mark Paid By Seller"
                cell.SellerPaidTic.isHidden = false
                cell.SellerPaidLbl.isHidden = false
            }else {
                cell.BuyerandSellerPaidView.isHidden = true
                
                cell.BuyerItemTic.isHidden = true
                cell.BuyerItemLbl.isHidden = true
                cell.MarkasPaidbtn.isHidden = false
                cell.SellerPaidView.isHidden = true
                
                cell.SellerPaidTic.isHidden = true
                cell.SellerPaidLbl.isHidden = true
            }
            
            if OfferArray[indexPath.row].isLocationShared == true {
             cell.shareLocationLbl.text = OfferArray[indexPath.row].address
             cell.ShareLocationbtn.setTitle("Update Location", for: .normal)
            }else {
                cell.shareLocationLbl.text = "Location not shared yet"
                cell.ShareLocationbtn.setTitle("Share Location", for: .normal)
            }
            
            cell.sellerNameLbl.text = self.OfferArray[indexPath.row].user!.last!.name
            cell.itemQuantity.text = " Accepted "
            cell.itemQuantity.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            
            cell.priceLbl.text = "\(currencySymbol)\(self.OfferArray[indexPath.row].price)"
            
            let averageratings = Double(round(1000*self.OfferArray[indexPath.row].user!.last!.averagerating)/1000)
            
            cell.RattingLabel.text = "Average Ratting : \(averageratings)"
            if self.OfferArray[indexPath.row].seller_Rating != -1 {
                cell.Ratting.didFinishTouchingCosmos = { rating in
                    cell.RattingLabel.text = "You Ratted : \(rating)"
                    let body:[String:Any] = [
                        "seller_uid" : SessionManager.shared.userId,
                        "item_id" : self.OfferArray[indexPath.row].item_id,
                        "order_id" : self.OfferArray[indexPath.row].id,
                        "buyer_name" : SessionManager.shared.name,
                        "buyer_image" : SessionManager.shared.image,
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
                    
//                    self.MainApi.BuyerRatting_Offer(sellerName: self.OfferArray[indexPath.row].user!.last!.name, sellerImage: "Abc.jpg", seller_uid: self.OfferArray[indexPath.row].buyer_uid, item_id: self.OfferArray[indexPath.row].item_id, order_id: self.OfferArray[indexPath.row].id, rating: rating, completionHandler: { (status, data, error) in
//
//                        if status {
//                            _ = SweetAlert().showAlert("Buyer Rated", subTitle: "Successfully Buyer Rated", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
//                                if status {
//                                    self.ReloadOfferData()
//                                }
//                            })
//                        }
//                    })
                }
                
            }else {
                cell.Ratting.rating = self.OfferArray[indexPath.row].seller_Rating
                cell.Ratting.isUserInteractionEnabled = false
            }
            
            
            if OfferArray[indexPath.row].isLocationShared == true {
                
                
            }
            
            
        }else  if self.OfferArray[indexPath.row].status == "Rejected" {
            estimateheight = 160
            cell.sellerNameLbl.text = self.OfferArray[indexPath.row].user!.last!.name
            cell.BuyerAcceptRejectBtnView.isHidden = true
            cell.RattingDetailView.isHidden = true
            cell.BuyerAcceptRejectCounterView.isHidden = true
            cell.BuyerandSellerPaidView.isHidden = true
            cell.BuyerItemRecivedView.isHidden = true
            
           
            cell.RattingDetailView.isHidden = true
            cell.BuyerAcceptRejectBtnView.isHidden = true
            cell.RejectedStatuslbl.text = self.OfferArray[indexPath.row].orderRejectReason
            let currencySymbol = self.OfferArray[indexPath.row].currencyString
            cell.AcceptRejectOfferHistorybtn.isHidden = false
            cell.RejectOrder.tag = indexPath.row

            cell.RejectStatusView.isHidden = false
            let Historyinstance = offerhistory
            
            let historyCount = offerhistory.count
            
            if historyCount > 0 {
                let index = historyCount - 1
                let instance = Historyinstance[index]
                let role = instance.role
                if role == "buyer" {
                    cell.buyerOfferStackView.isHidden = false
                    cell.priceStackView.isHidden = true
                    cell.yourOfferStack.isHidden = true
                    cell.buyerNameLbl.text = "Buyer's Offer:"
                    let price = instance.price
                    let quantity = instance.quantity
                    
                    if QuantityStatus == true {
                        cell.buyerOfferPriceLbl.text = currencySymbol + price + " X " + quantity
                    }else {
                        cell.buyerOfferPriceLbl.text = currencySymbol + price
                    }
                    
                    
                }else if role == "seller" {
                    cell.buyerOfferStackView.isHidden = true
                    cell.priceStackView.isHidden = true
                    cell.yourOfferStack.isHidden = false
                    cell.youOfferLbl.text = "Buyer's Offer:"
                    let price = instance.price
                    let quantity = instance.quantity
                    
                    if QuantityStatus == true {
                        cell.yourOfferPriceLbl.text = currencySymbol + price + " X " + quantity
                    }else {
                        cell.yourOfferPriceLbl.text = currencySymbol + price
                    }
                    
                    
                }else {
                    cell.buyerOfferStackView.isHidden = true
                    cell.priceStackView.isHidden = true
                    cell.yourOfferStack.isHidden = true
                    print("Nothing")
                }
            }
            
            
            cell.priceLbl.text = "\(currencySymbol)\(self.OfferArray[indexPath.row].price))"
            cell.itemQuantity.text = " Rejected "
            cell.itemQuantity.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
            
            
        }else {
            estimateheight = 0
        }
        cell.itemQuantity.layer.cornerRadius = 15
        cell.itemQuantity.layer.masksToBounds = true
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimateheight
    }
  override func viewWillAppear(_ animated: Bool) {
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
extension OfferViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  textField == singleTextFieldView.firstTextField || textField == multipleTextFieldView.priceTextField || textField == multipleTextFieldView.quantityTextField{
            let allowedCharacters = "1234567890"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }
        return true
    }
}



