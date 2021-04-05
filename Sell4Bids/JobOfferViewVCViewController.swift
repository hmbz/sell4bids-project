//
//  JobOfferViewVCViewController.swift
//  Sell4Bids
//
//  Created by Admin on 14/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class JobOfferViewVCViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource, UIGestureRecognizerDelegate {
    
    
    
    var Heightcell = CGFloat()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersArray.count
    }
    
    
    @IBAction func ShareLocationBtn(_ sender: UIButton) {
        
        let Index = sender.tag
        let storyboard = UIStoryboard.init(name: "ItemDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ShareLocation") as! ShareLocationViewViewController
        controller.selectedOrder = ordersArray[Index].order_id
        controller.selectedItemid = ordersArray[Index].item_id
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    
    
    
    
    @IBAction func Accept_Offer_Btn(_ sender: UIButton) {
        
        let AcceptOfferAlertBox = UIAlertController.init(title: "Order Confirmation", message: "Do you want to confirm this order?", preferredStyle: .alert)
        
        let confrim = UIAlertAction.init(title: "Confrim", style: .default) { (confrim) in
            let Index : Int = sender.tag
            self.MainApi.Accept_Order_Api(seller_uid: SessionManager.shared.userId, itemId: self.ordersArray[Index].item_id, orderId: self.ordersArray[Index].order_id, sellerName: SessionManager.shared.name, sellerImage: "") { (status, data, error) in
                
                print("Status == \(status)")
                print("data == \(data)")
                print("error == \(error)")
            }
        }
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .default) { (cancel) in
            
            self.dismiss(animated: true, completion: nil)
        }
        AcceptOfferAlertBox.addAction(confrim)
        AcceptOfferAlertBox.addAction(cancel)
        
        
        self.present(AcceptOfferAlertBox, animated: true, completion: nil)
        
        
        
    }
    
    let Reject_Order_AlertView = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    let RejectedOrderView = Bundle.main.loadNibNamed("Reject_Order_View", owner: self, options: nil)?.first as! RejectedOrderView
    
    @objc func Close_Btn_Rejected() {
        Reject_Order_AlertView.dismiss(animated: true, completion: nil)
        
    }
    
    var Rejecteditemid = String()
    var RejectedOrderid = String()
    var RejectedReason = String()
    
    @objc func Rejected_Order_Api() {
        
        MainApi.Reject_Order_Api(seller_uid: SessionManager.shared.userId, itemId: Rejecteditemid, orderId: RejectedOrderid, sellerName: SessionManager.shared.name, sellerImage: "",orderRejectReason: RejectedReason) { (status, data, error) in
            print("status == \(status)")
            print("data == \(data)")
            print("error == \(error)")
            
            if status {
                self.Reject_Order_AlertView.dismiss(animated: true, completion: nil)
                
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
        
        
        
        
    }
    
    
    @IBAction func SellerMarkPaidBtn(_ sender: UIButton) {
        let Index : Int = sender.tag
        let MarkedPaidAlertbox = UIAlertController.init(title: "Marked as Paid", message: "Do you confrim to recieved payments", preferredStyle: .alert)
        
        let confirm = UIAlertAction.init(title: "Confirm", style: .default) { (confirm) in
            
            self.MainApi.SellerMarkedPaid_Api(seller_uid: SessionManager.shared.userId, itemId: self.ordersArray[Index].item_id, orderId: self.ordersArray[Index].order_id, sellerName: SessionManager.shared.name, sellerImage: "", seller_marked_paid: true, completionHandler: { (status, data, error) in
                
                print("status == \(status)")
                print("data == \(data)")
                print("error == \(error)")
                
            })
            
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (cancel) in
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
        MarkedPaidAlertbox.addAction(confirm)
        MarkedPaidAlertbox.addAction(cancel)
        
        
        
        self.present(MarkedPaidAlertbox, animated: true, completion: nil)
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderViewCell
        
        let widhttxt = ordersArray[indexPath.row].address.widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 2))
        
        print("widhttxt == \(widhttxt)")
        cell.ShareLocation.tag = indexPath.row
        if ordersArray[indexPath.row].order_status == "Completed" {
            
            
            self.Heightcell = 250 + widhttxt
            cell.BuyerName.text = ordersArray[indexPath.row].name
            cell.ItemQuantity_Price.text = "$ \(ordersArray[indexPath.row].price) X \(ordersArray[indexPath.row].quantity)"
            cell.AcceptOrRejectBtnsView.isHidden = true
            cell.MarkPaid.isHidden = true
            cell.BuyerItemRecivedTic.isHidden = true
            cell.BuyerItemReviedTxt.isHidden = true
            cell.locationtxt.text = ordersArray[indexPath.row].address
            
            cell.RejectedView.isHidden = true
            
            if ordersArray[indexPath.row].seller_marked_paid == true {
                cell.SellerPaidtxt.text = "You Marked this as paid."
            }else {
                
            }
            
            if ordersArray[indexPath.row].buyer_item_recieved == true {
                
                cell.BuyerAcceptAndRejectBtns.isHidden = true
                cell.RejectedView.isHidden = true
                cell.BuyerItemReviedTxt.text = "Buyer Marked this Item as  Recieved."
                cell.BuyerItemRecivedTic.isHidden = false
                cell.BuyerItemReviedTxt.isHidden = false
                
            }else {
                
            }
            
            
            cell.RattingView.didFinishTouchingCosmos = { rating in
                
                self.MainApi.Ratting_Buyyer(buyer_uid: self.ordersArray[indexPath.row].user_id, itemId: self.ordersArray[indexPath.row].item_id, orderId: self.ordersArray[indexPath.row].order_id, buyerName: self.ordersArray[indexPath.row].name, buyerImage: self.ordersArray[indexPath.row].image, ratting: rating, completionHandler: { (status, data, error) in
                    
                    if status {
                        showSwiftMessageWithParams(theme: .info, title: "", body: data!["message"].stringValue, durationSecs: 5, layout: .cardView, position: .center)
                        
                    }
                    print("Status == \(status)")
                    print("data == \(data)")
                    print("error == \(error)")
                    
                    
                    
                })
                print("Ratting ==\(rating)")
            }
            
        }else if ordersArray[indexPath.row].order_status == "Pending" {
            cell.BuyerName.text = ordersArray[indexPath.row].name
            cell.ItemQuantity_Price.text = "$ \(ordersArray[indexPath.row].price) X \(ordersArray[indexPath.row].quantity)"
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
            self.Heightcell = 140 + widhttxt
            cell.BuyerAcceptAndRejectBtns.isHidden = false
            cell.RejectedView.isHidden = true
            cell.AcceptOrRejectBtnsView.isHidden = true
            cell.BuyerPaidStatusView.isHidden = true
            cell.RattingDetailView.isHidden = true
            cell.locationtxt.text = ordersArray[indexPath.row].address
            cell.BuyerName.text = ordersArray[indexPath.row].name
            cell.ItemQuantity_Price.text = "$ \(ordersArray[indexPath.row].price) X \(ordersArray[indexPath.row].quantity)"
            
            cell.MarkPaid.tag = indexPath.row
            
            
        }else if ordersArray[indexPath.row].order_status == "Rejected" {
            self.Heightcell = 80 + widhttxt
            cell.RejectedView.isHidden = false
            cell.BuyerPaidStatusView.isHidden = true
            cell.AcceptOrRejectBtnsView.isHidden = true
            cell.RattingDetailView.isHidden = true
            cell.BuyerAcceptAndRejectBtns.isHidden = true
            cell.ItemQuantity_Price.text = "$ \(ordersArray[indexPath.row].price) X \(ordersArray[indexPath.row].quantity)"
            cell.BuyerName.text = ordersArray[indexPath.row].name
            
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.Heightcell
    }
    
    //MARk: -Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var fidgetImageView: UIImageView!
    var MainApi = MainSell4BidsApi()
    
    ///location is approximate or seller has shared
    
    //MARK:-  Vairables
    var dbRef:DatabaseReference!
    var ordersArray = [OrderViewModel]()
    var buyerArray = [UserModel]()
    var orderdata : OrderViewModel?
    public var productDetail:ProductDetails!
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ordersArray.removeAll()
        MainApi.Get_Orders(seller_uid: SessionManager.shared.userId, item_id: selectedProduct!.id, type: "orders", sellerImage: "") { (status, data, error) in
            
            //        print("status == \(status)")
            //        print("status == \(data)")
            //        print("error == \(error)")
            let message = data!["message"]
            
            if status {
                
                for msg in message {
                    let status = msg.1["status"].stringValue
                    let orderid = msg.1["_id"].stringValue
                    let boughtprice = msg.1["price"].intValue
                    let boughtQuantity = msg.1["quantity"].intValue
                    let buyer_item_recieved = msg.1["buyer_item_recieved"].boolValue
                    let seller_marked_paid = msg.1["seller_marked_paid"].boolValue
                    let isLocationShared = msg.1["isLocationShared"].boolValue
                    var address = String()
                    let user = msg.1["users"]
                    let type = msg.1["type"].stringValue
                    var totalrating = Double()
                    var usrid = String()
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
                    let orders = OrderViewModel.init(item_id: item_id, order_status: status, image: image, user_id: usrid, user_averagerating: avgratting, name: username, order_id: orderid , type: type, buyer_item_recieved: buyer_item_recieved, price: boughtprice, seller_marked_paid: seller_marked_paid, quantity: boughtQuantity , isLocationShared: isLocationShared , address: address)
                    
                    
                    self.ordersArray.append(orders)
                    self.tableView.reloadData()
                    
                    
                }
                
            }
        }
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
    //MARK:- Private functions
    private func setupViews() {
        
    }
    
    
    
    //MARK:- IBActions and user interaction
    
    
    
    
    
}
