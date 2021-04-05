//
//  MyChatList.swift
//  Sell4Bids
//
//  Created by H.M.Ali on 11/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics
import SDWebImage
import XLPagerTabStrip
import SwiftyJSON
import NotificationCenter
import UserNotifications


class MyChatListVC: UIViewController, IndicatorInfoProvider , UNUserNotificationCenterDelegate {
    
    
    //MARK:- Properties and Outlets
    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var ChatError: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fidgetImageView: UIImageView!
    
    //MARK:-  Variables
    var itemprice = String()
    var IsTypingSocketValue = Bool()
    var chatItem : ChatItem?
    var ChatMessage = [ChatMessageList]()
    var selectedproduct : ProductModel?
    var MainAPi = MainSell4BidsApi()
    var ChatList = [ChatListModel]()
    var nav:UINavigationController?
    var usersIamChattingWith = [UserData]()
    var flagUsedInMySell4Bids = true
    var myID = ""
    var myName = ""
    var ownerId = ""
    var ownerName = ""
    var itemimg = ""
    var sellerDetail : SellerDetailModel?
    var notificationCenter  = UNUserNotificationCenter.current()
    var flagViewDidLoadCalled = false
    var refreshControl = UIRefreshControl()
    var fidgetbool = Bool()
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:-  view Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
        notificationCenter.delegate = self
        socket?.on("my_read", callback: { (data, emiterror) in
            let newdata = data.last! as! NSDictionary
            print("Message ==\(newdata)")
            let delivered_time = newdata["delivered_time"] as! Int64
            let item_id = newdata["item_id"] as! String
            let receiver_uid = newdata["receiver_uid"] as! String
            _ = newdata["sender_uid"] as! String
            print("delivered_time_msg == \(delivered_time)")
            for (index , msg) in self.ChatList.enumerated() {
                if msg.item_id == item_id && msg.receiver_uid == receiver_uid && msg.delivered_time == delivered_time {
                    
                    self.ChatList[index].read = true
                    self.tableView.reloadUsingDispatch()
                }
                print("delivered_time_usr == \(msg.delivered_time)")
            }
            
        })
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        setupViews()
        flagViewDidLoadCalled = true
        navigationController?.navigationBar.barTintColor = UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        writeTime(id: SessionManager.shared.userId)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        downloadAndShowChatList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        flagViewDidLoadCalled = false
        //        downloadAndShowChatList()
    }
    
    //MARK:-  Actions
    
    @objc func refresh(sender:AnyObject) {
        ChatList.removeAll()
        downloadAndShowChatList()
        refreshControl.endRefreshing()
    }
    
    //MARK:- Private Function
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "My Chat".localizableString(loc: LanguageChangeCode))
    }
    
    fileprivate func setupViews() {
        if fidgetbool {
            ChatError.isHidden = true
            fidgetImageView.toggleRotateAndDisplayGif()
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func downloadAndShowChatList() {
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
                    self.tableView.reloadData()
                }
            }else {
                
                self.ChatError.isHidden = false
            }
        }
    }
    
    //TODO:- Top bar Setting
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "My Chat"
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
//        dismiss(animated: true, completion: nil)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
}


extension MyChatListVC : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    static var colorIndexForInitialsBackground = 0
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ChatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myChatCell", for: indexPath) as! MyChatCell
        
        let instance = ChatList
        guard indexPath.row < instance.count  else {
            return cell
        }
        
        let user = instance[indexPath.row]
        //cell.roundNameLabel.text = "\(ch!)".capitalized
        print("created at == \(user.created_at)")
        if user.created_at != -1 {
            //print("time  is not nil")
            let startTime:TimeInterval = Double(user.created_at)
            let miliToDate = Date(timeIntervalSince1970:startTime/1000)
            let calender  = NSCalendar.current as NSCalendar
            let unitflags = NSCalendar.Unit([.day,.hour,.minute,.second])
            let diffDate = calender.components(unitflags, from:miliToDate, to: Date())
            if let days = diffDate.day, let hours = diffDate.hour, let minutes = diffDate.minute, let seconds = diffDate.second {
                if days > 1 {
                    cell.Timeshow.text = "\(days) days ago"
                }
                else if  hours < 24 && hours > 1{
                    
                    cell.Timeshow.text = "\(hours) hrs ago"
                }
                else if minutes < 60 && minutes > 1 {
                    cell.Timeshow.text = "\(minutes) min ago"
                }
                else if seconds < 60 && seconds > 1{
                    
                    cell.Timeshow.text = "Just Now"
                }
            }
        }else {
            cell.Timeshow.text = "NA"
            print("time is nil")
        }
        cell.nameLabel.text = user.item_title
        cell.onlineTextLabel.text = user.message
        if user.sender == SessionManager.shared.name {
            cell.lastMessage.text = user.receiver
        }else {
            cell.lastMessage.text = user.sender
        }
        //        cell.lastMessage.text = user.sender
        print("UserID = \(user.sender_uid), Session user ==\(SessionManager.shared.userId)")
        if user.read == true || user.sender_uid == SessionManager.shared.userId{
            cell.unreadCountLabel.isHidden = true
        }else {
            cell.unreadCountLabel.isHidden = false
        }
        
        socket?.on("typing", callback: { (data, error) in
            
            let string = String(describing: data)
            print("String == \(string)")
            var diction : NSDictionary?
            if let dict = data[0] as? [String: Any] {
                diction = dict as NSDictionary
                print("It's a dict")
            } else {
                print("It's not")
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: diction!, options: .prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                let value = JSON(jsonData)
                let isTyping = value["isTyping"].boolValue
                _ = value["reciver_uid"].stringValue
                _ = value["sender_uid"].stringValue
                let buyer_uid = value["buyer_uid"].stringValue
                let item_id = value["item_id"].stringValue
                
                print("Buyer_id Socket == \(buyer_uid) , Item_id ==\(item_id)")
                
                for (index , msg) in self.ChatList.enumerated() {
                    print("Buyer_id List== \(msg.buyer_uid) , Item_id ==\(msg.item_id)")
                    if msg.buyer_uid == buyer_uid && msg.item_id == item_id {
                        
                        print("Buyer_id List== \(msg.buyer_uid) , Item_id ==\(msg.item_id)")
                        if indexPath.row == index {
                            print("IsTyping == \(isTyping)")
                            self.IsTypingSocketValue = isTyping
                            if self.IsTypingSocketValue {
                                
                                cell.onlineTextLabel.text = "Type...."
                                
                                
                            }else {
                                
                                cell.onlineTextLabel.text = user.message
                                
                                
                            }
                        }
                        
                        
                    }
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
        })
        socket = manager.defaultSocket
        socket?.connect()
        socket?.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            socket?.emitWithAck("chat_message", "Ahmed").timingOut(after: 0) {data in
                socket?.emit("chat_message", "Ahmed" )
            }
        }
        
        socket?.on("new_chat", callback: { (data, error) in
            let string = String(describing: data)
            print("String == \(string)")
            var diction : NSDictionary?
            if let dict = data[0] as? [String: Any] {
                diction = dict as NSDictionary
                print("It's a dict")
            } else {
                print("It's not")
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: diction!, options: .prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                
                let valuenew = JSON(jsonData)
                let value = valuenew["data"]
                let buyer_uid = value["buyer_uid"].stringValue
                _ = value["count"].intValue
                let itemAuctionType = value["itemAuctionType"].stringValue
                let itemCategory = value["itemCategory"].stringValue
                let item_id = value["item_id"].stringValue
                let item_image = value["item_image"].stringValue
                let item_price = value["item_price"].stringValue
                let item_title = value["item_title"].stringValue
                let message = value["message"].stringValue
                let read = value["read"].boolValue
                let receiver = value["receiver"].stringValue
                let role = value["role"].stringValue
                let seller_uid = value["seller_uid"].stringValue
                let sender = value["sender"].stringValue
                let sender_uid = value["sender_uid"].stringValue
                let created_at = value["created_at"].int64Value
                let receiver_uid = value["receiver_uid"].stringValue
                let delivered_time = value["delivered_time"].int64Value
                let chatdata = ChatListModel.init(buyer_uid_id: buyer_uid, item_id_buyer_uid: sender_uid, item_price: item_price, created_at: created_at, receiver_uid: receiver_uid, item_title: item_title, receiver: receiver, itemCategory: itemCategory, buyer_uid: buyer_uid, id: "", seller_uid: seller_uid, item_id: item_id, item_image: item_image, message: message, itemAuctionType: itemAuctionType, sender: sender, read: read, sender_uid: sender_uid, delivered_time: delivered_time)
                
                print("Chat data socket  == \(chatdata.buyer_uid) , Chat item socket ==\(chatdata.item_id)")
                for  (index , chat) in self.ChatList.enumerated() {
                    
                    if chat.buyer_uid == chatdata.buyer_uid && chat.item_id == chatdata.item_id {
                        print("Chat data list condition == \(chat.buyer_uid) , Chat item list ==\(chat.item_id)")
                        self.ChatList.remove(at: index)
                        self.ChatList.insert(chatdata, at: 0)
                        self.tableView.reloadUsingDispatch()
                    }
                }
                
                self.notificationCenter.delegate = self
                let identifier = "New_Chat"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let content = UNMutableNotificationContent()
                content.title = role
                content.body = message
                content.sound = UNNotificationSound.default()
                content.badge = 1
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                self.notificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Error \(error.localizedDescription)")
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        })
        
        
        cell.selectionStyle  = UITableViewCellSelectionStyle.none
        let url = URL.init(string: user.item_image)
        cell.userImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "emptyImage1"))
        cell.userImageView.show()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ChatMessage.removeAll()
        let instance = ChatList
        guard indexPath.row < instance.count else {return}
        
//        Spinner.load_Spinner(image: fidgetImageView, view: self.DimView)
        MainAPi.Get_Chat(buyer_uid: instance[indexPath.row].buyer_uid, item_id: instance[indexPath.row].item_id, start: 0, limit: 15) { (status, data, error) in
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
            
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler(.alert)
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            print("called Notification Clicked")
            if response.notification.request.identifier == "New_Chat" {
            }
            completionHandler()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension MyChatListVC : ChatLogVCDelegate {
    func willMove() {
        usersIamChattingWith.removeAll()
        tableView.reloadUsingDispatch()
        downloadAndShowChatList()
    }
}



