//
//  NotificationsViewController.swift
//  Sell4Bids
//
//  Created by admin on 10/11/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwiftyJSON


class NotificationsVc: UIViewController,SWRevealViewControllerDelegate {
    
    //MARK: - Properties
    @IBOutlet weak var searchBarTop: UISearchBar!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    @IBOutlet weak var errorimg: UIImageView!
    
    //MARK:- Variables
    var ChatMessage = [ChatMessageList]()
    var newnotificationArray = [NewNotification_Model]()
    lazy var responseStatus = false
    var titleview = Bundle.main.loadNibNamed("NavigationBarMainView", owner: self, options: nil)?.first as! NavigationBarMainView
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = colorRedPrimay
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    //MARK:- View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newnotificationArray.removeAll()
        getnotif(start: 0)
        getNotificationThroughSocket()
        setupViews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      self.newnotificationArray.removeAll()
      getnotif(start: 0)
        let city = SessionManager.shared.City
        let state = SessionManager.shared.State
        let zipCode = SessionManager.shared.ZipCode
        titleview.citystateZIpcode.text = "\(city), \(state) \(zipCode)"
        tabBarController?.tabBar.isHidden = false
    }
 
    
    
    //MARK:-  Action
    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
        // here you can get notification
        self.newnotificationArray.removeAll()
        getnotif(start: 0)
        refreshControl.endRefreshing()
    }
    
    
    @objc func backBtnTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc func searchbtnaction() {
        let searchVCStoryBoard = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchVCStoryBoard.instantiateViewController(withIdentifier: "SearchVC")
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func filterbtnaction() {
        tabBarController?.selectedIndex = 0
    }
    
    //MARK:-  Functions
    
    private func setupViews(){
        self.navigationItem.titleView = titleview
        titleview.pizzaBtnWidth.constant = 0
        let country = UserDefaults.standard.string(forKey: SessionManager.shared.Country)
        titleview.citystateZIpcode.text = "\(country ?? "")"
        titleview.searchBarButton.addTarget(self, action: #selector(searchbtnaction), for: .touchUpInside)
        titleview.filterbtn.addTarget(self, action: #selector(filterbtnaction), for: .touchUpInside)
        titleview.inviteBtn.addTarget(self, action:  #selector(self.inviteBarBtnTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchbtnaction))
        titleview.citystateZIpcode.isUserInteractionEnabled = true
        titleview.citystateZIpcode.addGestureRecognizer(tap)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backBtnTapped(tapGestureRecognizer:)))
        titleview.homeImg.isUserInteractionEnabled = true
        titleview.homeImg.addGestureRecognizer(tapGestureRecognizer)
        
        if (self.revealViewController()?.delegate = self) != nil {
            self.revealViewController().delegate = self
        }
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        table.tableFooterView = UIView.init(frame: .zero)
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
        }
    }
    
    private func getNotificationThroughSocket() {
        socket?.on("notifications") {data, ack in
            print(data)
            let stringnewdata = data.last! as! NSDictionary
            let data = stringnewdata["data"] as! NSDictionary
            let notificatoinType = data["notificationType"] as! String
            if notificatoinType == "bidding" {
                print(data)
                let id = data["_id"] as! String
                let acutionType = data["auctionType"] as! String
                let cateogry = data["category"] as! String
                let created_at = data["created_at"] as! Int64
                let delivered = data["delivered"] as! Bool
                let item_id = data["item_id"] as! String
                //                let key = data["key"] as! String
                let message = data["message"] as! String
                //                let notificatoinType = data["notificationType"] as! String
                let receiver_uid = data["receiver_uid"] as! String
                let seller_uid = data["buyer_uid"] as! String
                let title = data["title"] as! String
                let item_price = data["item_price"] as! Int
               let senderName = data["senderName"] as! String
                
              let notidata = NewNotification_Model.init(category: cateogry, item_id: item_id, id: id, delivered: delivered, message: message, created_at: created_at, receiver_uid: receiver_uid, auctionType: acutionType, read: false, title: title, image_small_path: [""],image_path: [""], notificationType: notificatoinType, seller_uid: seller_uid, price: item_price, buyerId: "", SenderName: senderName )
                self.newnotificationArray.insert(notidata, at: 0)
                self.table.reloadUsingDispatch()
            }
            else if notificatoinType == "offers" {
                let id = data["key"] as! String
                let acutionType = data["auctionType"] as! String
                let cateogry = data["category"] as! String
                let created_at = data["created_at"] as! Int64
                //                let delivered = data["delivered"] as! Bool
                let item_id = data["item_id"] as! String
                _ = data["key"] as! String
                let message = data["message"] as! String
                let notificatoinType = data["notificationType"] as! String
                let receiver_uid = data["receiver_uid"] as! String
                let seller_uid = data["buyer_uid"] as? String
                let title = data["title"] as! String
              let senderName = data["senderName"] as! String
                //                let item_price = data["item_price"] as! Int
                
              let notidata = NewNotification_Model.init(category: cateogry, item_id: item_id, id: id, delivered: false, message: message, created_at: created_at, receiver_uid: receiver_uid, auctionType: acutionType, read: false, title: title, image_small_path: [""],image_path: [""], notificationType: notificatoinType, seller_uid: seller_uid ?? "", price: 0, buyerId: "", SenderName: senderName )
                self.newnotificationArray.insert(notidata, at: 0)
                self.table.reloadUsingDispatch()
            }
            else if notificatoinType == "orders" {
                let id = data["_id"] as! String
                let acutionType = data["auctionType"] as! String
                let cateogry = data["category"] as! String
                let created_at = data["created_at"] as! Int64
                let delivered = data["delivered"] as! Bool
                let item_id = data["item_id"] as! String
                _ = data["key"] as! String
                let message = data["message"] as! String
                let notificatoinType = data["notificationType"] as! String
                let receiver_uid = data["receiver_uid"] as! String
                let seller_uid = data["buyer_uid"] as! String
                let title = data["title"] as! String
                let item_price = data["item_price"] as! Int
                let senderName = data["senderName"] as! String
              let notidata = NewNotification_Model.init(category: cateogry, item_id: item_id, id: id, delivered: delivered, message: message, created_at: created_at, receiver_uid: receiver_uid, auctionType: acutionType, read: false, title: title, image_small_path: [""],image_path: [""], notificationType: notificatoinType, seller_uid: seller_uid, price: item_price, buyerId: "", SenderName: senderName)
                
                self.newnotificationArray.insert(notidata, at: 0)
                self.table.reloadUsingDispatch()
            }
        }
    }
    
    
    fileprivate func addDoneLeftBarBtn() {
        addLogoWithLeftBarButton()
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItems = [btnMenuButton, barButton]
    }
    
    func getnotif(start: Int) {
        
        let parameter:[String:Any] = ["uid": SessionManager.shared.userId, "start": start, "limit" :30]
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.toggleRotateAndDisplayGif()
                self.errorimg.isHidden = true
                self.emptyMessage.isHidden = true
                self.table.isHidden = false
                self.fidgetImageView.isHidden = false
            }
        }
        Networking.instance.postApiCall(url: getNotificationUrl, param: parameter) { (response, Error, StatusCode) in
            self.responseStatus = true
          
            
            print(response)
            guard let jsonDic = response.dictionary else {return}
            let jsonStatus = jsonDic["status"]?.bool ?? false
            if jsonStatus == true {
                self.tabBarController!.tabBar.items![4].badgeValue = nil
                let msgArray = jsonDic["message"]?.array ?? []
                for item in msgArray {
                    guard let msgDic = item.dictionary else {return}
                    let id = msgDic["_id"]?.string ?? ""
                    let itemPrice = msgDic["item_price"]?.int ?? 0
                    let title = msgDic["title"]?.string ?? ""
                    let auctionType = msgDic["auctionType"]?.string ?? ""
                    let category = msgDic["category"]?.string ?? ""
                    let delivered = msgDic["delivered"]?.bool ?? false
                    let imagePathSmall = msgDic["images_small_path"]?.arrayObject ?? []
                    let itemId = msgDic["item_id"]?.string ?? ""
                    let message = msgDic["message"]?.string ?? ""
                    let imagesPath = msgDic["images_path"]?.arrayObject ?? []
                    let notificationType = msgDic["notificationType"]?.string ?? ""
                    let sellerUid = msgDic["seller_uid"]?.string ?? ""
                    let senderName = msgDic["senderName"]?.string ?? "Sell4bids Team"
                    let buyerUid = msgDic["buyer_uid"]?.string ?? ""
                    //                    let currencyString = msgDic["currency_string"]?.string ?? ""
                    let createdAt = msgDic["created_at"]?.int64 ?? 0
                    let receiverUid = msgDic["receiver_uid"]?.string ?? ""
                    let read = msgDic["read"]?.bool ??  false
                  let data = NewNotification_Model.init(category: category, item_id: itemId, id: id, delivered: delivered, message: message, created_at: createdAt, receiver_uid: receiverUid, auctionType: auctionType, read: read, title: title, image_small_path: imagePathSmall as! [String], image_path: imagesPath as! [String], notificationType: notificationType, seller_uid: sellerUid, price: itemPrice, buyerId: buyerUid, SenderName: senderName)
                  
                    self.newnotificationArray.append(data)
                    
                }
                self.fidgetImageView.stopAnimatingGif()
                self.table.reloadData()
            }else {
                showSwiftMessageWithParams(theme: .info, title: "StrUpdateQuantity".localizableString(loc: LanguageChangeCode), body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                if self.newnotificationArray.count == 0 {
                    self.emptyMessage.text = "Notification not found"
                    self.errorimg.isHidden = false
                    self.emptyMessage.isHidden = false
                    self.table.isHidden = true
                    self.fidgetImageView.isHidden = true
                }else {
                    self.errorimg.isHidden = true
                    self.emptyMessage.isHidden = true
                    self.fidgetImageView.isHidden = true
                    self.table.isHidden = false
                    
                }
            }
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension NotificationsVc : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newnotificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lblTitle = cell.viewWithTag(1) as! UILabel
        let lblProductName =  cell.viewWithTag(2) as! UILabel
        let senderLabel =  cell.viewWithTag(3) as! UILabel
        let postedTimeLabel =  cell.viewWithTag(4) as! UILabel
        let imageView = cell.viewWithTag(10) as! UIImageView
        if newnotificationArray.isEmpty { return UITableViewCell() }
        if indexPath.row < newnotificationArray.count {
            let notification = newnotificationArray[indexPath.row]
            print(indexPath.row)
            lblTitle.text = notification.message
            let notificationproduct = newnotificationArray[indexPath.row]
            if notification.item_id == "-LDosERS2GbllyNYgM0V" {
                print("here you go")
            }
            let product = notificationproduct
          
            lblProductName.text = product.title
            
            if product.image_small_path?.count ?? 0 > 0 {
                let image = product.image_small_path?[0]  as? String
                let encodedImage = image?.replacingOccurrences(of: " ", with: "%20")
                imageView.sd_setImageWithURLWithFade(url: URL(string: encodedImage ?? ""), placeholderImage: #imageLiteral(resourceName: "emptyImage"))
            }else {
                if product.image_path?.count ?? 0 > 0 {
                    print("Showing bigger image")
                    let image = product.image_path?[0]  as? String
                    let encodedImage = image?.replacingOccurrences(of: " ", with: "%20")
                    imageView.sd_setImageWithURLWithFade(url: URL(string: encodedImage ?? ""), placeholderImage: #imageLiteral(resourceName: "emptyImage"))
                }else {
                    print("no image found")
                }
            }
          senderLabel.text = product.SenderName
            imageView.layer.cornerRadius = 5
            imageView.layer.masksToBounds = false
            imageView.clipsToBounds = true
            lblTitle.text = notification.message
            
            if notification.created_at != nil {
                //print("time  is not nil")
                let startTime:TimeInterval = Double(notification.created_at!)
                let miliToDate = Date(timeIntervalSince1970:startTime/1000)
                let calender  = NSCalendar.current as NSCalendar
                let unitflags = NSCalendar.Unit([.day,.hour,.minute,.second])
                let diffDate = calender.components(unitflags, from:miliToDate, to: Date())
                if let days = diffDate.day, let hours = diffDate.hour, let minutes = diffDate.minute, let seconds = diffDate.second {
                    if days > 1 {
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
            }
            else {
                postedTimeLabel.text = "NA"
                print("time is nil")
            }
            if notification.read == true {
                cell.contentView.backgroundColor = UIColor.white
            }
            else {
                cell.contentView.backgroundColor =  UIColor(red: 255/255, green: 229/255, blue: 229/255, alpha: 1)
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.table.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let start = self.newnotificationArray.count
        if indexPath.row == start - 1 {  //number of item count
            self.getnotif(start: start)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      self.newnotificationArray.removeAll()
             getnotif(start: 0)
        let instance = newnotificationArray
        guard indexPath.row < instance.count else {return}
        let url = "\(readNotificationUrl)\(instance[indexPath.row].id ?? "")"
        Networking.instance.getApiCall(url: url) { (response, Error, StatusCode) in
            guard let jsonDic = response.dictionary else {return}
            let jsonStatus = jsonDic["status"]?.bool ?? false
            if jsonStatus == true {
                print("Notification Read")
            }else {
                print("Error Reading Notification")
            }
        }
        let notification = newnotificationArray[indexPath.row]
        let notificationType = notification.notificationType
        if notificationType == "Chat" {
            print("chat Button")
            let parameter:[String:Any] = [
                "buyer_uid" : notification.buyerId ?? "",
                "item_id" : notification.item_id ?? "",
                "start" : 0,
                "limit" : 15
            ]
            Networking.instance.postApiCall(url: getChatUrl, param: parameter) { (response, Error, StatusCode) in
                print(response)
                guard let jsonDic = response.dictionary else {return}
                let jsonStatus = jsonDic["status"]?.bool ?? false
                if jsonStatus == true {
                    let msgArray = jsonDic["message"]?.array ?? []
                  self.ChatMessage.removeAll()
                    for item in msgArray{
                        guard let msgDic = item.dictionary else {return}
                        // Id's Used in the chat
                        let id = msgDic["_id"]?.string ?? ""
                        let receiverUid = msgDic["receiver_uid"]?.string ?? ""
                        let senderUid = msgDic["sender_uid"]?.string ?? ""
                        let sellerUid = msgDic["seller_uid"]?.string ?? ""
                        let buyerUid = msgDic["buyer_uid"]?.string ?? ""
                        let itemId = msgDic["item_id"]?.string ?? ""

                        // Time For creation the chat
                        let createdAt = msgDic["created_at"]?.int64 ?? 0
                        let deliverTime = msgDic["delivered_time"]?.int64 ?? 0

                        // Item Data on which chat is going to begin
                        let title = msgDic["title"]?.string ?? ""
                        let price = msgDic["item_price"]?.int ?? 0
                        let imagePathSmall = msgDic["images_small_path"]?.string ?? ""
                        let imagesPath = msgDic["images_path"]?.string ?? ""
                        //                    let currencyString = msgDic["currency_string"]?.string ?? ""
                        let itemCategory = msgDic["itemCategory"]?.string ?? ""

                        // Details of person who send Message
                        let senderName = msgDic["senderName"]?.string ?? "Sell4bids Team"
                        //                    let senderImage = msgDic["image"]?.string ?? ""
                        // Details of person who recieve message
                        let receiverName = msgDic["receiver"]?.string ?? ""

                        // Chat Specific Data
                        let deliver = msgDic["delivered"]?.bool ?? false
                        let read = msgDic["read"]?.bool ?? false
                        let ItemAuctionType = msgDic["itemAuctionType"]?.string ?? ""
                        let message = msgDic["message"]?.string ?? ""
                        //                    let isTyping = msgDic["isTyping"]?.bool ?? false

                        // If somebody does not read the msg make them to read
                        if receiverUid == SessionManager.shared.userId && read == false {
                            socket?.emit("read", [
                                "item_id" : itemId,
                                "receiver_uid" : receiverUid,
                                "delivered_time" : deliverTime,
                                "sender_uid" : senderUid
                            ])
                        }

                        let ChatObject = ChatMessageList.init(read: read, delivered_time: deliverTime, created_at: createdAt, buyer_uid: buyerUid, message: message, itemCategory: itemCategory, sender_uid: senderUid, item_id: itemId, item_price: price, sender: senderName, itemAuctionType: ItemAuctionType, receiver_uid: receiverUid, images_small_path: imagePathSmall, delivered: deliver, seller_uid: sellerUid, id: id, images_path: imagesPath, title: title, receiver: receiverName, role: "", iserror: false)
                        self.ChatMessage.append(ChatObject)
                    }
                    // take the view towards chat Module
                    let storyboard = UIStoryboard.init(name: "chat", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogVC
                    controller.ChatMesssage = self.ChatMessage
                    controller.movetochat = true
                    self.navigationController?.pushViewController(controller, animated: true)

                }
                else {
                    let message = jsonDic["message"]?.string ?? ""
                    let MsgString = "\(message) Do you want to start new Chat?"
                    SweetAlert().showAlert("StrChat".localizableString(loc: LanguageChangeCode), subTitle: MsgString, style: AlertStyle.warning, buttonTitle: "StrYes".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black, otherButtonTitle: "StrNo".localizableString(loc: LanguageChangeCode), otherButtonColor: UIColor.black) { (ifYes) -> Void in
                        if(ifYes == true){
                            self.ChatMessage.removeAll()
                            let newchat = ChatMessageList.init(read: false, delivered_time: 0, created_at: 0, buyer_uid: SessionManager.shared.userId, message: "", itemCategory: notification.category ?? "", sender_uid: SessionManager.shared.userId, item_id: notification.item_id ?? "", item_price: notification.price ?? 0, sender: SessionManager.shared.name, itemAuctionType: notification.auctionType ?? "", receiver_uid: notification.receiver_uid ?? "", images_small_path: "", delivered: false, seller_uid: notification.seller_uid ?? "", id: notification.item_id ?? "", images_path: "", title: notification.title ?? "", receiver: "", role: "", iserror: false)
                            self.ChatMessage.append(newchat)

                            let storyboard = UIStoryboard.init(name: "chat", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogVC
                            controller.ChatMesssage = self.ChatMessage
                            controller.movetochat = true
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                }
            }
        }
        else if notificationType == "ItemListing" || notificationType == "bidding" {
            
            let instance = newnotificationArray
            guard indexPath.row < instance.count else {return}
            if instance[indexPath.row].message?.contains("rejected") ?? false{
                print("Rejected")
            }else {
                let Category = instance[indexPath.row].category
                if Category?.lowercased() == "jobs" {
                    let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
                    let controller = storyBoard_.instantiateViewController(withIdentifier: "JobsDetailVC") as! JobsDetailVC
                    controller.ImageArray = instance[indexPath.row].image_path as! [String]
                    controller.itemName = instance[indexPath.row].title
                    controller.itemId = instance[indexPath.row].item_id
                    controller.sellerId = instance[indexPath.row].seller_uid
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }
                else if Category?.lowercased() == "services" {
                    let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
                    let controller = storyBoard_.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
                    controller.ImageArray = instance[indexPath.row].image_path as! [String]
                    controller.itemName = instance[indexPath.row].title
                    controller.itemId = instance[indexPath.row].item_id
                    controller.sellerId = instance[indexPath.row].seller_uid
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }
                else if Category?.lowercased() == "vehicles" {
                    let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
                    let controller = storyBoard_.instantiateViewController(withIdentifier: "VehicleDetailVC") as! VehicleDetailVC
                    controller.ImageArray = instance[indexPath.row].image_path as! [String]
                    controller.itemName = instance[indexPath.row].title
                    controller.itemId = instance[indexPath.row].item_id
                    controller.sellerId = instance[indexPath.row].seller_uid
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }
                else if Category?.lowercased() == "housing" {
                    let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
                    let controller = storyBoard_.instantiateViewController(withIdentifier: "HousingDetailVC") as! HousingDetailVC
                    controller.ImageArray = instance[indexPath.row].image_path as! [String]
                    controller.itemName = instance[indexPath.row].title
                    controller.itemId = instance[indexPath.row].item_id
                    controller.sellerId = instance[indexPath.row].seller_uid
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }
                else {
                    let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
                    let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
                    controller.itemName = instance[indexPath.row].title
                    controller.itemId = instance[indexPath.row].item_id
                    controller.sellerId = instance[indexPath.row].seller_uid
                    controller.ImageArray = instance[indexPath.row].image_path as! [String]
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        else if notificationType == "offers" {
            if notification.seller_uid == SessionManager.shared.userId{
                let story = UIStoryboard(name: "Description", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "OfferViewController") as! OfferViewController
                vc.itemId = notification.item_id ?? ""
                vc.itemCategory = notification.category ?? ""
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated: true, completion: nil)
            }else {
                print("User cannot open Offers")
            }
        }
        else if notificationType == "Orders"{
            if notification.seller_uid == SessionManager.shared.userId{
                let story = UIStoryboard(name: "Description", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
                vc.itemId = notification.item_id ?? ""
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated: true, completion: nil)
            }else {
                print("User cannot open Offers")
            }
        }
        
    }
}

