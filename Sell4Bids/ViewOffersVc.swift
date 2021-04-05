//
//  ViewOffersVc.swift
//  Sell4Bids
//
//  Created by admin on 11/1/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import Cosmos
import GooglePlaces
import SwiftMessages

class ViewOffersVc: UIViewController , UIGestureRecognizerDelegate {
    
    
    //MARK:- Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var fidgetImageView: UIImageView!
    
    
    //MARK:-  Variables
    var MainApi = MainSell4BidsApi()
    var navi = UINavigationController().navigationBar
    var Heightcell = CGFloat()
    // Alert View For rejection of the Order
    let Reject_Order_AlertView = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    let RejectedOrderView = Bundle.main.loadNibNamed("Reject_Order_View", owner: self, options: nil)?.first as! RejectedOrderView
    // custom view for Top bar
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    // For Item rehection
    var Rejecteditemid = String()
    var RejectedOrderid = String()
    var RejectedReason = String()
    var RejectedOrderQuantity = Int()
    
    var ordersArray = [OrderViewModel]()
    var buyerArray = [UserModel]()
    var orderdata : OrderViewModel?
    var productDetail:ProductDetails!
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Orders"
        topMenu()
        ReloadOrderData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK:- Private functions
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Orders"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    
    private func ReloadOrderData() {
        ordersArray.removeAll()
        MainApi.Get_Orders(seller_uid: SessionManager.shared.userId, item_id: self.productDetail!.id, type: "orders", sellerImage: SessionManager.shared.image , start: "0" , limit: "25") { (status, data, error) in
            let message = data!["message"]
            let msg = data!["data"].stringValue
            if status {
                if msg.contains("No Orders available on this item") {
                    _ = SweetAlert().showAlert("Orders", subTitle: msg, style: .error)
                }else {
                    
                    for msg in message {
                        let status = msg.1["status"].stringValue
                        let orderid = msg.1["_id"].stringValue
                        let boughtprice = msg.1["boughtPrice"].intValue
                        let boughtQuantity = msg.1["boughtQuantity"].intValue
                        let buyer_item_recieved = msg.1["buyer_item_recieved"].boolValue
                        let seller_marked_paid = msg.1["seller_marked_paid"].boolValue
                        let isLocationShared = msg.1["isLocationShared"].boolValue
                        let seller_rating = msg.1["seller_Rating"].doubleValue
                        var address = String()
                        let user = msg.1["users"]
                        let type = msg.1["type"].stringValue
                        var totalrating = Double()
                        var usrid = String()
                        var averagerating = Double()
                        let orderRejectReason = msg.1["orderRejectReason"].stringValue
                        for usr in user {
                            let averageratingvalue = usr.1["averagerating"].doubleValue
                            averagerating = averageratingvalue
                        }
                        var username = msg.1["buyerName"].stringValue
                        var avgratting = Double()
                        var uid = String()
                        var image = String()
                        var item_id = msg.1["item_id"].stringValue
                        if isLocationShared {
                            address = msg.1["address"].stringValue
                        }else {
                            address = "Location not shared yet."
                        }
                        for usr in user {
                            totalrating = usr.1["totalratings"].doubleValue
                            usrid = usr.1["_id"].stringValue
                            //                    username = usr.1["buyerName"].stringValue
                            avgratting = usr.1["averagerating"].doubleValue
                            uid = usr.1["uid"].stringValue
                            image = usr.1["image"].stringValue
                            
                        }
                        
                        print("name ===== \(username)")
                        let orders = OrderViewModel.init(item_id: item_id, order_status: status, image: image, user_id: usrid, user_averagerating: avgratting, name: username, order_id: orderid , type: type, buyer_item_recieved: buyer_item_recieved, price: boughtprice, seller_marked_paid: seller_marked_paid, quantity: boughtQuantity , isLocationShared: isLocationShared , address: address , seller_rating: seller_rating , averagerating: averagerating, orderRejectReason: orderRejectReason)
                        
                        
                        
                        self.ordersArray.append(orders)
                        self.tableView.reloadData()
                        
                        
                    }
                    
                }
            }
            
        }
        
        
    }
    
    //MARK:- Action
    
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        
    }
    
    @IBAction func ShareLocationBtn(_ sender: UIButton) {
        let Index = sender.tag
        let vc = UIStoryboard(name: "homeTab", bundle: nil).instantiateViewController(withIdentifier: "FilterLocationVC") as! FilterLocationVC
        vc.OfferStatus = true
        vc.itemId = ordersArray[Index].item_id
        vc.orderId = ordersArray[Index].order_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func Accept_Offer_Btn(_ sender: UIButton) {
        let AcceptOfferAlertBox = UIAlertController.init(title: "Order Confirmation", message: "Do you want to confrim this order?", preferredStyle: .alert)
        let confrim = UIAlertAction.init(title: "Confrim", style: .default) { (confrim) in
            let Index : Int = sender.tag
            self.MainApi.Accept_Order_Api(seller_uid: SessionManager.shared.userId, itemId: self.ordersArray[Index].item_id, orderId: self.ordersArray[Index].order_id, sellerName: SessionManager.shared.name, sellerImage: "") { (status, data, error) in
                if status {
                    _ = SweetAlert().showAlert("Seller Accepted Order", subTitle: "Successfully Accepted Order", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                        if status {
                            
                            self.ReloadOrderData()
                        }
                    })
                }
            }
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: .default) { (cancel) in
            self.dismiss(animated: true, completion: nil)
        }
        AcceptOfferAlertBox.addAction(confrim)
        AcceptOfferAlertBox.addAction(cancel)
        self.present(AcceptOfferAlertBox, animated: true, completion: nil)
    }
    
    @objc func Close_Btn_Rejected() {
        Reject_Order_AlertView.dismiss(animated: true, completion: nil)
    }
    
    @objc func Rejected_Order_Api() {
        MainApi.Reject_Order_Api(seller_uid: SessionManager.shared.userId, itemId: Rejecteditemid, orderId: RejectedOrderid, sellerName: SessionManager.shared.name, sellerImage: "",orderRejectReason: RejectedOrderView.Reasontxt.text , quantity : RejectedOrderQuantity) { (status, data, error) in
            if status {
                _ = SweetAlert().showAlert("Seller Rejected Order", subTitle: "Successfully Rejected Order", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                    if status {
                        self.Reject_Order_AlertView.dismiss(animated: true, completion: nil)
                        self.ReloadOrderData()
                    }
                })
            }
        }
    }
    
    
    @IBAction func Reject_Order_btn(_ sender: UIButton) {
        Reject_Order_AlertView.view.frame = RejectedOrderView.frame
        Reject_Order_AlertView.view.addSubview(RejectedOrderView)
        RejectedOrderView.Close_Btn.addTarget(self, action: #selector(Close_Btn_Rejected), for: .touchUpInside)
        RejectedOrderView.SubmitBtn.addTarget(self, action: #selector(Rejected_Order_Api), for: .touchUpInside)
        present(Reject_Order_AlertView, animated: true, completion: nil)
        let Index : Int = sender.tag
        Rejecteditemid = ordersArray[Index].item_id
        RejectedOrderid = ordersArray[Index].order_id
        RejectedReason = RejectedOrderView.Reasontxt.text
        RejectedOrderQuantity = ordersArray[Index].quantity
    }
    
    @IBAction func SellerMarkPaidBtn(_ sender: UIButton) {
        let Index : Int = sender.tag
        let MarkedPaidAlertbox = UIAlertController.init(title: "Marked as Paid", message: "Do you confrim to recieved payments", preferredStyle: .alert)
        let confirm = UIAlertAction.init(title: "Confirm", style: .default) { (confirm) in
            self.MainApi.SellerMarkedPaid_Api(seller_uid: SessionManager.shared.userId, itemId: self.ordersArray[Index].item_id, orderId: self.ordersArray[Index].order_id, sellerName: SessionManager.shared.name, sellerImage: SessionManager.shared.image, seller_marked_paid: true, completionHandler: { (status, data, error) in
                if status {
                    _ = SweetAlert().showAlert("Seller Marked as Paid", subTitle: "Successfully Marked as Paid", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                        if status {
                            self.ReloadOrderData()
                        }
                    })
                }
            })
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (cancel) in
            self.dismiss(animated: true, completion: nil)
        }
        MarkedPaidAlertbox.addAction(confirm)
        MarkedPaidAlertbox.addAction(cancel)
        self.present(MarkedPaidAlertbox, animated: true, completion: nil)
    }
}

extension ViewOffersVc: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderViewCell
        
        let widhttxt = ordersArray[indexPath.row].address.widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 2))
        
        print("widhttxt == \(widhttxt)")
        cell.ShareLocation.tag = indexPath.row
        if ordersArray[indexPath.row].order_status == "Completed" {
            
            
            self.Heightcell = 250 + widhttxt
            cell.BuyerName.text = ordersArray[indexPath.row].name
            cell.ItemQuantity_Price.text = "$\(ordersArray[indexPath.row].price) X \(ordersArray[indexPath.row].quantity)"
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
            cell.priceLbl.text = "$ \(ordersArray[indexPath.row].price) X \(ordersArray[indexPath.row].quantity)"
            
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
            cell.priceLbl.text = "$ \(ordersArray[indexPath.row].price) X \(ordersArray[indexPath.row].quantity)"
            cell.ItemQuantity_Price.text = "  Accepted  "
            cell.ItemQuantity_Price.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            
            if ordersArray[indexPath.row].isLocationShared == true {
                cell.locationtxt.text = ordersArray[indexPath.row].address
            }
            
            
            cell.MarkPaid.tag = indexPath.row
            let averageratings = Double(round(1000*self.ordersArray[indexPath.row].averagerating)/1000)
            cell.RattingLabel.text = "Average Rating : \(averageratings)"
            
            if self.ordersArray[indexPath.row].seller_rating == -1 {
                cell.RattingView.didFinishTouchingCosmos = { rating in
                    
                    self.MainApi.Ratting_Buyyer(buyer_uid: self.ordersArray[indexPath.row].user_id, itemId: self.ordersArray[indexPath.row].item_id, orderId: self.ordersArray[indexPath.row].order_id, buyerName: self.ordersArray[indexPath.row].name, buyerImage: self.ordersArray[indexPath.row].image, ratting: rating, completionHandler: { (status, data, error) in
                        
                        if status {
                            _ = SweetAlert().showAlert("Buyer Rated", subTitle: "Successfully Rated", style: .success, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), action: { (status) in
                                if status {
                                    self.ReloadOrderData()
                                }
                            })
                            
                        }
                        print("Status == \(status)")
                        print("data == \(data)")
                        print("error == \(error)")
                        
                        
                        
                    })
                    print("Ratting ==\(rating)")
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
            
            cell.priceLbl.text = "$ \(ordersArray[indexPath.row].price) X \(ordersArray[indexPath.row].quantity)"
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
}