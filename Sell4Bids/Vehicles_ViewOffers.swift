//
//  Vehicles_ViewOffers.swift
//  Sell4Bids
//
//  Created by Admin on 23/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class Vehicles_ViewOffers: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var navia = UINavigationController()
    var indexrejectbtn = Int()
    var estimateheight = CGFloat()
    var SendCounterOffer = Bundle.main.loadNibNamed("OfferNow_Custom_View", owner: self, options: nil)?.first as! OfferNowCustomView
    var SendCounterOfferAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    var offerhistory = [offers]()
    var navi = UINavigationController().navigationBar
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.OfferArray.count
    }
    
    let RejectOfferView = Bundle.main.loadNibNamed("Reject_Order_View", owner: self, options: nil)?.first as! RejectedOrderView
    
    var RejectOfferViewAlert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    
    @objc func Reject_Offer_Api() {
        
        if RejectOfferView.Reasontxt.text.isEmpty {
            showSwiftMessageWithParams(theme: .error, title: "Empty Field", body: "Please give a reason.")
            
        }else {
            MainApi.Reject_Offer_Api(seller_name: SessionManager.shared.name, seller_image: SessionManager.shared.image, seller_uid: SessionManager.shared.userId, item_id: self.OfferArray[indexrejectbtn].item_id, order_id: self.OfferArray[indexrejectbtn].id , orderRejectReason: RejectOfferView.Reasontxt.text, quantity: "" ) { (status, data, error) in
                
                if status {
                    
                    let message = data!["message"].stringValue
                    _ = SweetAlert().showAlert("Seller Rejected Offer", subTitle: "Successfully Rejected Offer", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                        if status {
                            self.ReloadOfferData()
                            self.RejectOfferViewAlert.dismiss(animated: true, completion: nil)
                            
                        }
                    })
                    
                    
                }
                
                
                
            }
        }
        
    }
    
    
    
    
    @IBAction func ViewOfferHistory(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.init(name: "ItemDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "OfferHistoryView") as! OfferHistoryTableView
        controller.OfferHistory = self.OfferArray[sender.tag]
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    @objc func Close_Reject_btn() {
        
        RejectOfferViewAlert.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func Reject_Offer(_ sender: UIButton) {
        let index = sender.tag
        indexrejectbtn = index
        RejectOfferViewAlert.view.frame = RejectOfferView.frame
        RejectOfferViewAlert.view.addSubview(RejectOfferView)
        RejectOfferView.SubmitBtn.addTarget(self, action: #selector(Reject_Offer_Api), for: .touchUpInside)
        RejectOfferView.Close_Btn.addTarget(self, action: #selector(Close_Reject_btn), for: .touchUpInside)
        
        self.present(RejectOfferViewAlert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    @IBAction func Accept_Offer(_ sender: UIButton) {
        let index = sender.tag
        
        MainApi.Accept_Offer_Api(seller_name: SessionManager.shared.name, seller_image: SessionManager.shared.image, seller_uid: SessionManager.shared.userId, item_id: selectedProduct!.itemKey, order_id: self.OfferArray[index].id) { (status, data, error) in
            
            print("status == \(status)")
            print("data == \(data)")
            print("error == \(error)")
            
            if status {
                let message = data!["message"].stringValue
                _ = SweetAlert().showAlert("Seller Accepted Offer", subTitle: "Successfully Rejected Offer", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                    if status {
                        self.RejectOfferViewAlert.dismiss(animated: true, completion: nil)
                        self.ReloadOfferData()
                    }
                })
                
            }
            
        }
    }
    
    
    @IBAction func MarkedasPaid(_ sender: UIButton) {
        
        MainApi.SellerMarkedPaid_Api(seller_uid: SessionManager.shared.userId, itemId: self.OfferArray[sender.tag].item_id, orderId:self.OfferArray[sender.tag].id , sellerName: self.OfferArray[sender.tag].user!.last!.name, sellerImage: SessionManager.shared.image, seller_marked_paid: true) { (status, data, error) in
            
            if status {
                
                _ = SweetAlert().showAlert("Seller Marked as Paid", subTitle: "Successfully Mared as Paid", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                    if status {
                        self.ReloadOfferData()
                    }
                })
            }else {
                let message = data!["message"].stringValue
                _ = SweetAlert().showAlert("Seller Marked as Paid", subTitle: message, style: .error, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                    if status {
                        self.ReloadOfferData()
                    }
                })
            }
            
        }
        
    }
    
    
    
    @IBAction func ShareLocationBtn(_ sender: UIButton) {
        
        let Index = sender.tag
//        let storyboard = UIStoryboard.init(name: "ItemDetail", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "ShareLocation") as! ShareLocationViewViewController
//        controller.selectedOrder = self.OfferArray[Index].id
//        controller.selectedItemid = self.OfferArray[Index].item_id
//        controller.selectedmethod = "Offers"
//        controller.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.pushViewController(controller, animated: true)
        let vc = UIStoryboard(name: "homeTab", bundle: nil).instantiateViewController(withIdentifier: "FilterLocationVC") as! FilterLocationVC
        vc.OfferStatus = true
      
        vc.itemId = self.OfferArray[Index].item_id
        vc.orderId = self.OfferArray[Index].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var index_Offer_counter = Int()
    
    @objc func SendCounterOfferclose() {
        
        SendCounterOfferAlert.dismiss(animated: true, completion: nil)
    }
    
    @objc func Send_Offer_Counter_Api() {
        
        
        
        MainApi.Send_Counter_Offer_Seller(seller_uid: SessionManager.shared.userId, buyer_uid: self.OfferArray[index_Offer_counter].user!.last!.id, offer_price: SendCounterOffer.AmountPerItemtxt.text!, item_id: self.OfferArray[index_Offer_counter].item_id, offer_quantity: SendCounterOffer.Quantitytxt.text!, order_id: self.OfferArray[index_Offer_counter].id, offer_count: self.OfferArray[index_Offer_counter].sellerOfferCount, seller_name: SessionManager.shared.name, seller_image: SessionManager.shared.image, itemCategory: selectedProduct!.itemCategory) { (status, data, error) in
            
            if status {
                _ = SweetAlert().showAlert("Seller Send Counter Offer", subTitle: "Successfully Send Counter Offer", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                    if status {
                        self.ReloadOfferData()
                        self.SendCounterOfferAlert.dismiss(animated: true, completion: nil)
                    }
                })
            }else {
                let message = data!["message"].stringValue
                _ = SweetAlert().showAlert("Seller Send Counter Offer", subTitle: data!["message"].stringValue, style: .error, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                    if status {
                        self.ReloadOfferData()
                        self.SendCounterOfferAlert.dismiss(animated: true, completion: nil)
                    }
                })
                
                
            }
            
            //        MainApi.Send_Counter_Offer(seller_uid: SessionManager.shared.userId, buyer_uid: self.OfferArray[index_Offer_counter].buyer_uid, product_image: selectedProduct!.Image_0, offer_price: SendCounterOffer.AmountPerItemtxt.text!, item_id: self.OfferArray[index_Offer_counter].item_id, offer_quantity: SendCounterOffer.Quantitytxt.text!, product_title: selectedProduct!.title, buyer_name: self.OfferArray[index_Offer_counter].user!.last!.name, product_category: self.selectedProduct!.itemCategory, product_auction_type: self.selectedProduct!.itemAuctionType, product_state: self.selectedProduct!.state, buyer_image: "ABC.jpg", offer_count: self.OfferArray[index_Offer_counter].sellerOfferCount, order_id: self.OfferArray[index_Offer_counter].id) { (status, data, error) in
            //
            //            if status {
            //                let message = data!["message"].stringValue
            //                showSwiftMessageWithParams(theme: .info, title: "Counter Offer", body: message)
            //            }else {
            //                let message = data!["message"].stringValue
            //                showSwiftMessageWithParams(theme: .info, title: "Counter Offer", body: message)
            //            }
            //
            //
            //        }
        }
    }
    
    @IBAction func SendCounterOffer(_ sender: UIButton) {
        index_Offer_counter = sender.tag
        self.SendCounterOfferAlert.view.frame = self.SendCounterOffer.frame
        self.SendCounterOffer.CloseBtn.addTarget(self, action: #selector(SendCounterOfferclose), for: .touchUpInside)
        self.SendCounterOffer.SendOfferBtn.addTarget(self, action: #selector(Send_Offer_Counter_Api), for: .touchUpInside)
        self.SendCounterOfferAlert.view.addSubview(SendCounterOffer)
        self.present(SendCounterOfferAlert, animated: true, completion: nil)
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewOfferCell
        
        print("Offers = \(self.OfferArray[indexPath.row].offers!.count)")
        
        if self.OfferArray[indexPath.row].status == "Pending" {
            estimateheight = 280
            cell.BuyerAcceptRejectBtnView.isHidden = false
            cell.BuyerandSellerPaidView.isHidden = true
            cell.SellerPaidView.isHidden = true
            cell.RattingDetailView.isHidden = true
            cell.BuyerItemRecivedView.isHidden = true
            cell.RejectStatusView.isHidden = true
            cell.remaingOfferLbl.isHidden = false
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
            let currencySymbol = instance.currencyString
            cell.buyerOfferPriceLbl.text = "\(currencySymbol)\(priceB!)"
            cell.youOfferLbl.text = "Seller offer:"
            let priceS = instance.lastOfferSeller
            cell.yourOfferPriceLbl.text = "\(currencySymbol)\(priceS!)"
            let price = self.OfferArray[indexPath.row].price
            cell.priceLbl.text = "\(currencySymbol)\(price)"
            cell.itemQuantity.text = " Pending "
            cell.itemQuantity.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            
        }
        else if self.OfferArray[indexPath.row].status == "Accepted" {
            estimateheight = 300
            cell.buyerOfferStackView.isHidden = false
            cell.priceStackView.isHidden = true
            cell.yourOfferStack.isHidden = true
            
            cell.buyerNameLbl.text = "Sold At:"
            
            let boughtPrice = OfferArray[indexPath.row].boughtPrice
            let currencySymbol = OfferArray[indexPath.row].currencyString
            cell.buyerOfferPriceLbl.text = currencySymbol + boughtPrice
            
            
            cell.BuyerAcceptRejectBtnView.isHidden = true
            cell.BuyerandSellerPaidView.isHidden = true
            cell.BuyerItemRecivedView.isHidden = true
            cell.RattingDetailView.isHidden = false
            cell.RejectStatusView.isHidden = true
            cell.BuyerAcceptRejectCounterView.isHidden = false
            cell.BuyerandSellerPaidView.isHidden = true
            cell.acceptRejectStack.isHidden = true
            cell.remaingOfferLbl.isHidden = true
            
            cell.MarkasPaidbtn.isHidden = false
            cell.ShareLocationbtn.tag = indexPath.row
            cell.MarkasPaidbtn.tag = indexPath.row
            cell.SendCounterOffer.tag = indexPath.row
            if OfferArray[indexPath.row].seller_marked_paid == true {
                estimateheight = 320
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
            cell.priceLbl.text = "\(self.OfferArray[indexPath.row].boughtPrice)"
            
            cell.itemQuantity.text = " Accepted "
            cell.itemQuantity.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            
            let averageratings = Double(round(1000*self.OfferArray[indexPath.row].user!.last!.averagerating)/1000)
            
            cell.RattingLabel.text = "Average Ratting : \(averageratings)"
            if self.OfferArray[indexPath.row].seller_Rating == -1 {
                cell.Ratting.didFinishTouchingCosmos = { rating in
                    
                    self.MainApi.BuyerRatting_Offer(sellerName: self.OfferArray[indexPath.row].user!.last!.name, sellerImage: "Abc.jpg", seller_uid: self.OfferArray[indexPath.row].buyer_uid, item_id: self.OfferArray[indexPath.row].item_id, order_id: self.OfferArray[indexPath.row].id, rating: rating, completionHandler: { (status, data, error) in
                        
                        if status {
                            _ = SweetAlert().showAlert("Buyer Rated", subTitle: "Successfully Buyer Rated", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                                if status {
                                    self.ReloadOfferData()
                                }
                            })
                        }
                    })
                }
                
            }else {
                cell.Ratting.rating = self.OfferArray[indexPath.row].seller_Rating
                cell.Ratting.isUserInteractionEnabled = false
            }
            
            
        }else  if self.OfferArray[indexPath.row].status == "Rejected" {
            estimateheight = 150
            cell.sellerNameLbl.text = self.OfferArray[indexPath.row].user!.last!.name
            cell.BuyerAcceptRejectBtnView.isHidden = true
            cell.RattingDetailView.isHidden = true
            cell.BuyerAcceptRejectCounterView.isHidden = true
            cell.BuyerandSellerPaidView.isHidden = true
            cell.BuyerItemRecivedView.isHidden = true
            cell.acceptRejectStack.isHidden = true
            cell.remaingOfferLbl.isHidden = true
            cell.RejectedStatuslbl.text = self.OfferArray[indexPath.row].orderRejectReason
            
            cell.AcceptRejectOfferHistorybtn.isHidden = true
            cell.RejectOrder.tag = indexPath.row
            
            cell.RejectStatusView.isHidden = false
            cell.AcceptRejectOfferHistorybtn.isHidden = false
            
            
//            cell.priceLbl.text = "\(self.OfferArray[indexPath.row].lastOfferBuyer) X \(self.OfferArray[indexPath.row].boughtQuantity)"
//
//            cell.itemQuantity.text = "Rejected"
//            cell.itemQuantity.textColor = UIColor.red
            let Historyinstance = offerhistory
            let currencySymbol = self.OfferArray[indexPath.row].currencyString
            
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
                  
                    cell.buyerOfferPriceLbl.text = currencySymbol + price
                }else if role == "seller" {
                    cell.buyerOfferStackView.isHidden = true
                    cell.priceStackView.isHidden = true
                    cell.yourOfferStack.isHidden = false
                    cell.youOfferLbl.text = "Buyer's Offer:"
                    let price = instance.price
                   
                    cell.yourOfferPriceLbl.text = currencySymbol + price
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
        cell.itemQuantity.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimateheight
    }
    
    
    var MainApi = MainSell4BidsApi()
    var selectedProduct : sellingModel?
    var OfferArray = [OfferModel]()
    
    @IBOutlet weak var tableview: UITableView!
    
    func ReloadOfferData() {
        print(selectedProduct)
        
        MainApi.Get_Offers(seller_uid: SessionManager.shared.userId, item_id: selectedProduct!.id, type: "offers", sellerImage: SessionManager.shared.image) { (status, data, error) in
            if status {
                self.OfferArray.removeAll()
                self.offerhistory.removeAll()
                let offerdata = data!["message"]
                let message = data!["data"].stringValue
                if message.contains("No Orders available on this item") {
                    
                     _ = SweetAlert().showAlert("Offers", subTitle: message, style: .error)
                    
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
                        let currencysString = offerdata.1["currency_string"].stringValue
                        let seller_Rating = offerdata.1["seller_Rating"].doubleValue
                        let buyer_Rating = offerdata.1["buyer_Rating"].doubleValue
                         let isLocationShared = offerdata.1["isLocationShared"].boolValue
                         let quantity = offerdata.1["quantity"].intValue
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
                        
                        
                        let maindataoffer = OfferModel.init(id: id, user: userdata, item_id: item_id, type: type, status: status, sellerOfferCount: selletOfferCount, seller_uid: seller_uid, seller_marked_paid: seller_marked_paid, buyerOfferCount: buyerOfferCount, price: price, offers: offersdataoffers, buyer_uid: buyer_uid , boughtPrice: boughtPrice , boughtQuantity: boughtQuantity , orderRejectReason : orderRejectReason ,lastOfferBuyer: lastOfferBuyer, seller_Rating: seller_Rating , buyer_Rating: buyer_Rating, isLocationShared: isLocationShared, address: address,lastQuantityBuyer:lastQuantityBuyer,lastOfferSeller: lastOfferSeller,lastQuantitySeller:lastQuantitySeller, currency_string: currencysString, quantity: quantity)
                        
                        
                        
                        self.OfferArray.append(maindataoffer)
                        
                        self.tableview.reloadData()
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                }
            }
            print("status == \(status)")
            print("data == \(data)")
            print("error == \(error)")
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Offers"
//        addLogoWithLeftBarButton()
//        addInviteBarButtonToTop()
        topMenu()
     NotificationCenter.default.addObserver(self, selector: #selector(self.method12(notification:)), name: Notification.Name("updatelocation"), object: nil)


//        ReloadOfferData()
        tableview.delegate = self
        tableview.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      NotificationCenter.default.addObserver(self, selector: #selector(self.method12(notification:)), name: Notification.Name("updatelocation"), object: nil)
        ReloadOfferData()
    }
    @objc func method12(notification: Notification) {
      print("here is my function call")
      self.OfferArray.removeAll()
      self.ReloadOfferData()
      self.tableview.reloadData()
  }

    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Offers"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        
        self.navigationItem.hidesBackButton = true
    }
    
    //MARK:-  Actions
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
}
extension Vehicles_ViewOffers:updateLocatation{
  func upatelocation() {
    self.OfferArray.removeAll()
    self.ReloadOfferData()
    self.tableview.reloadData()
  }
  
  
}
