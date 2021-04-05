//
//  ChatLogVC.swift
//  Sell4Bids
//
//  Created by admin on 5/1/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UIScrollView_InfiniteScroll
import Reachability
import Alamofire
import SwiftyJSON


struct ChatMessage {
    let text: String
    let isIncoming: Bool
    let date: Date
    var timeStamp : String?
    var receiver : String?
    var sender : String?
    var itemimg : String?
    var itemtitle : String?
    var receiverLastMessage = ""
    
}

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date =  dateFormatter.date(from: customString) ?? Date()
        return date
    }
    
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date =  dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
        return date
    }
}

class ChatLogVC: UIViewController , UITableViewDelegate , UITableViewDataSource , UIGestureRecognizerDelegate {
    
    //Properties
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textMessageHight: NSLayoutConstraint!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var fidgetSpinner: UIImageView!
    @IBOutlet weak var suggestionHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewMessage: UITextView!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var tabview: UITableView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var suggestionBtn1: UIButton!
    @IBOutlet weak var suggestionBtn2: UIButton!
    @IBOutlet weak var suggestionBtn3: UIButton!
    @IBOutlet weak var suggestionBtn4: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var suggestionConstrainHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomTextViewToSafe: NSLayoutConstraint!
    
    
    //MARK:-  Variables
    var userSuggestionArry = [" Hi, is it still available? "," I'm interested "," Is the price negotiable? "," What condition is it in? "]
    var senderSuggestionArray = [" Yes, It's for sale "," What's your offer? "," Sorry, it has been sold! "," Yes, it's negotiable "]
    var typingStatus : Bool = true
    var ownTypingStatus = Bool()
    var MainAPi = MainSell4BidsApi()
    var sellerDetail : SellerDetailModel?
    var indexrow = Int()
    var movetochat = Bool()
    var datetimesender = String()
    var datetimereciver = String()
    var ChatMesssage  = [ChatMessageList]()
    fileprivate let cellId1 = "id123"
    var typingTimmer = Timer()
    var typingTimerTrue = Timer()
    var messagesFromServer = [ChatMessage]()
    weak var delegate : ChatLogVCDelegate?
    var currentTimeStamp: Int64 = 0
    var messages = [MessageOld]()
    var previousData = [String:Any]()
    let placeHolderText = "Text Message"
    var IsTypingSocketValue = Bool()
    var titleview = Bundle.main.loadNibNamed("ChatNavigation", owner: self, options: nil)?.first as! ChatNavi
    var timertyping = Timer()
    var serialQueue = DispatchQueue.init(label: "typing")
    lazy var responseStatus = false
    lazy var notificationStatus =  false
    lazy var detailStatus = false
    lazy var presentView = false
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        setUpItemDetail()
        getUserdetails()
        let image = titleview.itemImage
        image?.layer.cornerRadius = (image?.frame.height)!/2
        
        suggestionBtn1.sizeToFit()
        suggestionBtn1.sizeThatFits(CGSize.zero)
        suggestionBtn1.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        suggestionBtn1.shadowView()
        
        suggestionBtn2.sizeToFit()
        suggestionBtn2.sizeThatFits(CGSize.zero)
        suggestionBtn2.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        suggestionBtn2.shadowView()
        
        suggestionBtn3.sizeToFit()
        suggestionBtn3.sizeThatFits(CGSize.zero)
        suggestionBtn3.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        suggestionBtn3.shadowView()
        
        suggestionBtn4.sizeToFit()
        suggestionBtn4.sizeThatFits(CGSize.zero)
        suggestionBtn4.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        suggestionBtn4.shadowView()
        
        tabview.contentInset = .init(top: 25, left: 0, bottom: 0, right: 0)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        timertyping = Timer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: false)
        
        self.tabview.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        
        
        socket?.on("message_delivered", callback: { (data, emiterror) in
            
            let newdata = data.last! as! NSDictionary
            
            print("Message Delivered ==\(newdata)")
            
            let delivered_time = newdata["delivered_time"] as! Int64
            let item_id = newdata["item_id"] as! String
            let receiver_uid = newdata["receiver_uid"] as! String
            
            
            print("delivered_time_msg == \(delivered_time)")
            
            for (index , msg) in self.ChatMesssage.enumerated() {
                
                if msg.item_id == item_id && msg.receiver_uid == receiver_uid && msg.delivered_time == delivered_time {
                    
                    self.ChatMesssage[index].delivered = true
                    self.tabview.reloadUsingDispatch()
                }
                print("delivered_time_usr == \(msg.delivered_time)")
            }
            
        })
        
        
        socket?.on("read", callback: { (data, emiterror) in
            
            let newdata = data.last! as! NSDictionary
            
            print("Message ==\(newdata)")
            
            let delivered_time = newdata["delivered_time"] as! Int64
            let item_id = newdata["item_id"] as! String
            let receiver_uid = newdata["receiver_uid"] as! String
            //            let sender_uid = newdata["sender_uid"] as! String
            
            print("delivered_time_msg == \(delivered_time)")
            
            for (index , msg) in self.ChatMesssage.enumerated() {
                
                if msg.item_id == item_id && msg.receiver_uid == receiver_uid && msg.delivered_time == delivered_time {
                    
                    self.ChatMesssage[index].read = true
                    self.tabview.reloadUsingDispatch()
                }
                print("delivered_time_usr == \(msg.delivered_time)")
                
            }
            
        })
        
        socket?.on("my_messages", callback: { (data, emit) in
            let newdata = data.last! as! NSDictionary
            print("data == \(newdata)")
            let messagedata = newdata["data"] as! NSDictionary
            let buyer_uid = messagedata["buyer_uid"] as! String
            let created_at = messagedata["created_at"] as! Int64
            let delivered = messagedata["delivered"] as! Bool
            let delivered_time = messagedata["delivered_time"] as! Int64
            let itemAuctionType = messagedata["itemAuctionType"] as! String
            let itemCategory = messagedata["itemCategory"] as! String
            let item_id = messagedata["item_id"] as! String
            var item_price_val : Int?
            
            item_price_val =  messagedata["item_price"] as? Int
            
            let item_title = messagedata["item_title"] as! String
            let message = messagedata["message"] as! String
            let read = messagedata["read"] as! Bool
            let receiver = messagedata["receiver"] as! String
            let receiver_uid = messagedata["receiver_uid"] as! String
            let role = messagedata["role"] as! String
            let seller_uid = messagedata["seller_uid"] as! String
            let sender = messagedata["sender"] as! String
            let sender_uid = messagedata["sender_uid"] as! String
            let item_image = messagedata["item_image"] as! String
            
            let newmessage = ChatMessageList.init(read: read, delivered_time: delivered_time, created_at: created_at, buyer_uid: buyer_uid, message: message, itemCategory: itemCategory, sender_uid: sender_uid, item_id: item_id, item_price: item_price_val!, sender: sender, itemAuctionType: itemAuctionType, receiver_uid: receiver_uid, images_small_path: "", delivered: delivered, seller_uid: seller_uid, id: "", images_path: item_image, title: item_title, receiver: receiver,role: role, iserror: false)
            
            self.ChatMesssage.insert(newmessage, at: 0)
            
            self.tabview.reloadUsingDispatch()
            
        })
        
        
        
        socket?.on("new_chat", callback: { (data, emit) in
            let newdata = data.last! as! NSDictionary
            print("data == \(newdata)")
            
            let messagedata = newdata["data"] as! NSDictionary
            let item_id_msg = messagedata["item_id"] as! String
            let buyer_uid = messagedata["buyer_uid"] as! String
            let created_at = messagedata["created_at"] as! Int64
            let delivered = messagedata["delivered"] as! Bool
            let delivered_time = messagedata["delivered_time"] as! Int64
            let itemAuctionType = messagedata["itemAuctionType"] as! String
            let itemCategory = messagedata["itemCategory"] as! String
            var item_price_val = Int()
            if messagedata["item_price"] == nil {
                
            }else {
                
                item_price_val = messagedata["item_price"] as? Int ?? -1
            }
            
            let item_title = messagedata["item_title"] as! String
            let message = messagedata["message"] as! String
            let read = messagedata["read"] as! Bool
            let receiver = messagedata["receiver"] as! String
            let receiver_uid = messagedata["receiver_uid"] as! String
            let role = messagedata["role"] as! String
            let seller_uid = messagedata["seller_uid"] as! String
            let sender = messagedata["sender"] as! String
            let sender_uid = messagedata["sender_uid"] as! String
            let item_image = messagedata["item_image"] as! String
            
            let newmessage = ChatMessageList.init(read: read, delivered_time: delivered_time, created_at: created_at, buyer_uid: buyer_uid, message: message, itemCategory: itemCategory, sender_uid: sender_uid, item_id: item_id_msg, item_price: item_price_val, sender: sender, itemAuctionType: itemAuctionType, receiver_uid: receiver_uid, images_small_path: "", delivered: delivered, seller_uid: seller_uid, id: "", images_path: item_image, title: item_title, receiver: receiver,role: role, iserror: false)
            
            
            
            
            self.tabview.reloadUsingDispatch()
            if self.ChatMesssage.last!.item_id == newmessage.item_id && self.ChatMesssage.last!.buyer_uid == buyer_uid  {
                
                
                if self.movetochat {
                    self.ChatMesssage.insert(newmessage, at: 0)
                    socket?.emit("read", ["item_id" : item_id_msg , "receiver_uid" : receiver_uid , "delivered_time" : delivered_time , "sender_uid" : sender_uid] )
                }
            }
        })
        getCurrentServerTime { [weak self] (success, currentTime) in
            guard let this = self else { return }
            this.currentTimeStamp = Int64(currentTime)
        }
        
        tabview.delegate = self
        tabview.dataSource = self
        viewMessage.layer.cornerRadius = 18
        viewMessage.layer.borderColor = UIColor.gray.cgColor
        viewMessage.layer.borderWidth = 0.6
        
        
        viewMessage.backgroundColor = UIColor.white
        btnSendMessage.addShadowAndRoundChat()
        textViewMessage.layer.borderColor = UIColor.black.cgColor
        
        
        tabview.register(ChatMessageCell.self, forCellReuseIdentifier: cellId1)
        tabview.separatorStyle = .none
        if Env.isIpad {
            suggestionBtn1.layer.cornerRadius = 20
            suggestionBtn2.layer.cornerRadius = 20
            suggestionBtn3.layer.cornerRadius = 20
            suggestionBtn4.layer.cornerRadius = 20
        }else if Env.isIphoneSmall {
            suggestionBtn1.layer.cornerRadius = 15
            suggestionBtn2.layer.cornerRadius = 15
            suggestionBtn3.layer.cornerRadius = 15
            suggestionBtn4.layer.cornerRadius = 15
        }else {
            suggestionBtn1.layer.cornerRadius = 15
            suggestionBtn2.layer.cornerRadius = 15
            suggestionBtn3.layer.cornerRadius = 15
            suggestionBtn4.layer.cornerRadius = 15
        }
        
        suggestionBtn1.isHidden = true
        suggestionBtn2.isHidden = true
        suggestionBtn3.isHidden = true
        suggestionBtn4.isHidden = true
        suggestionConstrainHeight.constant = 0
        suggestionHeight.constant = 0
        
        socket?.on("typing", callback: { (data, error) in
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
                //                let reciver_uid = value["reciver_uid"].stringValue
                //                let sender_uid = value["sender_uid"].stringValue
                let buyer_uid = value["buyer_uid"].stringValue
                let item_id = value["item_id"].stringValue
                
                if self.ChatMesssage.last!.buyer_uid == buyer_uid  && self.ChatMesssage.last!.item_id == item_id {
                    print("IsTyping == \(isTyping)")
                    self.IsTypingSocketValue = isTyping
                    if self.IsTypingSocketValue {
                        if   buyer_uid == self.ChatMesssage.last!.buyer_uid &&  item_id == self.ChatMesssage.last!.item_id{
                            self.titleview.itemPrice.text = "Typing..."
                        }
                        
                    }else {
                        if   buyer_uid == self.ChatMesssage.last!.buyer_uid && item_id == self.ChatMesssage.last!.item_id  {
                            self.itemPriceLbl.text = String(describing: "$\(self.ChatMesssage.last!.item_price)")
                            self.titleview.itemPrice.text = ""
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    
    override func viewLayoutMarginsDidChange() {
        if detailStatus == false {
            titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
            print("titleview width = \(titleview.frame.width)")
        }
    }
    
    
    //MARK:- PRivate functions
    private func setUpItemDetail() {
        self.itemImage.sd_setImage(with: URL(string: self.ChatMesssage.last?.images_path ?? "" ),placeholderImage: UIImage(named: "app_icon_64" ))
        self.itemNameLbl.text = self.ChatMesssage.last!.title
        self.itemPriceLbl.text = String(describing: "$\(self.ChatMesssage.last!.item_price)")
        let tapGesture: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(MovetoItemChat))
        self.itemImage.isUserInteractionEnabled = true
        self.itemImage.addGestureRecognizer(tapGesture)
        
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(MovetoItemChat))
        self.itemNameLbl.isUserInteractionEnabled = true
        self.itemNameLbl.addGestureRecognizer(tap)
        
        let tap2: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(MovetoItemChat))
        self.itemPriceLbl.isUserInteractionEnabled = true
        self.itemPriceLbl.addGestureRecognizer(tap2)
    }
    
    private func getUserdetails() {
        print(self.ChatMesssage)
        MainAPi.Seller_Detail_Api(buyer_uid: SessionManager.shared.userId, seller_uid: self.ChatMesssage.last?.receiver_uid ?? "") { (status, data, error) in
            if status {
                Spinner.stop_Spinner(image: self.fidgetSpinner, view: self.dimView)
                let message = data!["message"]
                let blocked = data!["blocked"].boolValue
                let following = data!["following"].boolValue
                let productCount = data!["productCount"].stringValue
                let followerCount = data!["followerCount"].stringValue
                let followingCount = data!["followingCount"].stringValue
                let id = message["_id"].stringValue
                let image = message["image"].stringValue
                let totalrating = message["totalratings"].doubleValue
                let averagerating = message["averagerating"].doubleValue
                let name = message["name"].stringValue
                let sellerdata = SellerDetailModel.init(blocked: blocked, following: following, id: id, image: image, totalrating: totalrating, averagerating: averagerating, name: name , productCount: productCount , followerCount: followerCount , followingCount: followingCount)
                self.sellerDetail = sellerdata
                
                self.titleview.itemImage.sd_setImage(with: URL(string: self.sellerDetail?.image ?? "" ),placeholderImage: UIImage(named: "emptyImage" ))
                
                self.titleview.itemTitle.text = self.sellerDetail?.name
                self.titleview.itemPrice.text = ""
//                if self.presentView == true {
//                    self.navigationViewHeight.constant = 50
//                    self.titleview.frame =  CGRect(x:0, y: 0, width: (self.navigationView.frame.width), height: 40)
//                    self.navigationView.addSubview(self.titleview)
//                }else {
//                    self.navigationViewHeight.constant = 0
//                    self.navigationItem.titleView = self.titleview
//                }
                self.navigationItem.titleView =  self.titleview
                self.titleview.itemImage.addShadowAndRoundChat()
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.moveToUserDetail(tap:)))
                self.titleview.itemImage.isUserInteractionEnabled = true
                self.titleview.itemImage.addGestureRecognizer(tapGestureRecognizer)
                
                let TAP = UITapGestureRecognizer(target: self, action: #selector(self.moveToUserDetail(tap:)))
                self.titleview.itemTitle.isUserInteractionEnabled = true
                self.titleview.itemTitle.addGestureRecognizer(TAP)
                
                self.titleview.inviteBtn.addTarget(self, action: #selector(self.inviteBarBtnTapped(_:)), for: .touchUpInside )
            }
        }
    }
    
    
    @objc func moveToUserDetail(tap: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "UserDetails", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
        
        controller.sellerDetail = self.sellerDetail
        
        controller.title = self.sellerDetail?.name ?? "Sell4Bid User"
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK:- Actions
    
    @IBAction func ItemDetails(_ sender: Any) {
        let storyBoard_ = UIStoryboard.init(name: storyBoardNames.prodDetails , bundle: nil)
        let controller = storyBoard_.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
        print(controller)
        //controller.productDetail = selectedProduct
        //        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @objc func upadteStop() {
        print("typing stop")
        self.ownTypingStatus = false
        var sender_uid = String()
        var receiver_uid = String()
        if ChatMesssage.last!.buyer_uid == SessionManager.shared.userId {
            sender_uid = ChatMesssage.last!.buyer_uid
            receiver_uid = ChatMesssage.last!.seller_uid
        }else {
            sender_uid = ChatMesssage.last!.seller_uid
            receiver_uid = ChatMesssage.last!.buyer_uid
        }
        socket?.emit("typing", ["receiver_uid" : receiver_uid , "sender_uid" : sender_uid , "buyer_uid" : self.ChatMesssage.last!.buyer_uid , "item_id" : self.ChatMesssage.last!.item_id , "isTyping" : self.ownTypingStatus])
    }
    
    @objc func update() {
        // Something cool
        print("typing...")
        self.ownTypingStatus = true
        var sender_uid = String()
        var receiver_uid = String()
        if ChatMesssage.last!.buyer_uid == SessionManager.shared.userId {
            
            sender_uid = ChatMesssage.last!.buyer_uid
            receiver_uid = ChatMesssage.last!.seller_uid
        }else {
            
            sender_uid = ChatMesssage.last!.seller_uid
            receiver_uid = ChatMesssage.last!.buyer_uid
        }
        socket?.emit("typing", ["receiver_uid" : receiver_uid , "sender_uid" : sender_uid , "buyer_uid" : self.ChatMesssage.last!.buyer_uid , "item_id" : self.ChatMesssage.last!.item_id , "isTyping" : self.ownTypingStatus])
        typingStatus = true
    }
    
    
    @objc func MovetoItemChat() {
        print("called MovetoItem")
        let instance = ChatMesssage.last
        let Category = instance?.itemCategory
        if Category?.lowercased() == "jobs" {
             let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
             let controller = storyBoard_.instantiateViewController(withIdentifier: "JobsDetailVC") as! JobsDetailVC
            controller.ImageArray = instance?.images_path as? [String] ?? [""]
             controller.itemName = instance?.title
             controller.itemId = instance?.item_id
             controller.sellerId = instance?.seller_uid
             controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
         }
         else if Category?.lowercased() == "services" {
             let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
             let controller = storyBoard_.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
            controller.ImageArray = instance?.images_path as? [String] ?? [""]
             controller.itemName = instance?.title
             controller.itemId = instance?.item_id
             controller.sellerId = instance?.seller_uid
             controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
         }
         else if Category?.lowercased() == "vehicles" {
             let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
             let controller = storyBoard_.instantiateViewController(withIdentifier: "VehicleDetailVC") as! VehicleDetailVC
            controller.ImageArray = instance?.images_path as? [String] ?? [""]
             controller.itemName = instance?.title
             controller.itemId = instance?.item_id
             controller.sellerId = instance?.seller_uid
             controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
         }
         else if Category?.lowercased() == "housing" {
             
             let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
             let controller = storyBoard_.instantiateViewController(withIdentifier: "HousingDetailVC") as! HousingDetailVC
             controller.ImageArray = instance?.images_path as? [String] ?? [""]
            controller.itemName = instance?.title
             controller.itemId = instance?.item_id
             controller.sellerId = instance?.seller_uid
             controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
         }
        
         else {
             let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
             let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
            controller.itemName = instance?.title
             controller.itemId = instance?.item_id
             controller.sellerId = instance?.seller_uid
             controller.ImageArray = instance?.images_path as? [String] ?? [""]
             controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
         }
//        if Category?.lowercased() == "jobs" {
//            let storyBoard_ = UIStoryboard.init(name: "JobDetail" , bundle: nil)
//            let controller = storyBoard_.instantiateViewController(withIdentifier: "JoBDetailViewIdentifier") as! JoBDetailViewVC
//            controller.itemId = instance?.item_id
//            controller.sellerId = instance?.seller_uid
//            let transition:CATransition = CATransition()
//            transition.duration = 0.5
//            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//            transition.type = kCATransitionPush
//            transition.subtype = kCATransitionFade
//            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//        else if Category?.lowercased() == "services" {
//            let storyBoard_ = UIStoryboard.init(name: "ServiceDetail" , bundle: nil)
//            let controller = storyBoard_.instantiateViewController(withIdentifier: "ServiceDetailView-Identifier") as! ServiceDetailView
//            controller.itemId = instance?.item_id
//            controller.sellerId = instance?.seller_uid
//            let transition:CATransition = CATransition()
//            transition.duration = 0.5
//            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//            transition.type = kCATransitionPush
//            transition.subtype = kCATransitionFade
//            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//        else if Category?.lowercased() == "vehicles" {
//            let storyBoard_ = UIStoryboard.init(name: "VehiclesDetail" , bundle: nil)
//            let controller = storyBoard_.instantiateViewController(withIdentifier: "VehiclesDetailMainView-Identifier") as! VehiclesDetailMainView
//            controller.itemId = instance?.item_id
//            controller.sellerId = instance?.seller_uid
//            let transition:CATransition = CATransition()
//            transition.duration = 0.5
//            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//            transition.type = kCATransitionPush
//            transition.subtype = kCATransitionFade
//            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//        else if Category?.lowercased() == "housing" {
//            let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
//            let controller = storyBoard_.instantiateViewController(withIdentifier: "HousingDetailVC") as! HousingDetailVC
//            controller.ImageArray = [(instance?.images_path ?? "")]
//            controller.itemName = instance?.title
//            controller.itemId = instance?.item_id
//            controller.sellerId = instance?.seller_uid
//            controller.modalPresentationStyle = .fullScreen
//            self.present(controller, animated: true, completion: nil)
//        }
//
//        else {
//            let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
//            let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
//            controller.itemId = instance?.item_id
//            controller.sellerId = instance?.seller_uid
//            controller.ImageArray = [(instance?.images_path ?? "")]
//            controller.modalPresentationStyle = .fullScreen
//            self.present(controller, animated: true, completion: nil)
//        }
    }
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //   --
        print("numberOfSections = \(messagesFromServer.count)")
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ChatMesssage.count
    }
    
    
    
    
    
    @objc func refreshmessage() {
        var error = Bool()
        if  NetworkReachabilityManager()!.isReachable {
            error = false
        }else {
            error = true
            
        }
        let data = SendMessage.init(message: ChatMesssage[indexrow].message, buyer_uid: ChatMesssage[indexrow].buyer_uid, item_id: ChatMesssage[indexrow].item_id, receiver_uid: ChatMesssage[indexrow].receiver_uid, sender: ChatMesssage[indexrow].sender, receiver: ChatMesssage[indexrow].receiver, seller_uid: ChatMesssage[indexrow].seller_uid, role: ChatMesssage[indexrow].role, sender_uid: ChatMesssage[indexrow].sender_uid, itemCategory: ChatMesssage[indexrow].itemCategory, itemAuctionType: ChatMesssage[indexrow].itemAuctionType, item_title: ChatMesssage[indexrow].title, item_image: ChatMesssage[indexrow].images_path, item_price: ChatMesssage[indexrow].item_price, delivered_time: currentTimeStamp,iserror: error )
        
        print("Network error == \(data.iserror)")
        if data.iserror {
            print("This IsError is Called true")
            
        }else {
            print("This IsError is Called false")
            socket?.emit("new_message", ["message" : data.message ,"buyer_uid" : data.buyer_uid , "item_id" : data.item_id ,"receiver_uid": data.receiver_uid , "sender" : data.sender ,"sender_uid" : data.sender_uid, "receiver" : data.receiver , "seller_uid" : data.seller_uid , "role" : data.role , "itemCategory" : data.itemCategory , "item_price" : data.item_price , "itemAuctionType" : data.itemAuctionType , "item_title": data.item_title , "delivered_time": data.delivered_time , "item_image" : data.item_image])
            ChatMesssage.remove(at: indexrow)
            print("Message = \(["message" : data.message ,"buyer_uid" : data.buyer_uid , "item_id" : data.item_id ,"receiver_uid": data.receiver_uid , "sender" : data.sender ,"sender_uid" : data.sender_uid, "receiver" : data.receiver , "seller_uid" : data.seller_uid , "role" : data.role , "itemCategory" : data.itemCategory , "item_price" : data.item_price , "itemAuctionType" : data.itemAuctionType , "item_title": data.item_title , "delivered_time": data.delivered_time ])")
            self.tabview.reloadData()
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabview.dequeueReusableCell(withIdentifier: cellId1, for: indexPath) as! ChatMessageCell
        //        let chatMessage = chatMessages[indexPath.row]
        print("message22 = \(ChatMesssage[indexPath.row].message)")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let message = ChatMesssage[indexPath.item]
        let cellSpacing : CGFloat = 15
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        let messageText = message.message
        
        if message.sender_uid == SessionManager.shared.userId  {
            
            func handleTimeSender() {
                
                let time = Int64(ChatMesssage[indexPath.row].created_at)
                let f = Date(milliseconds: Int(time))
                let currentTime = self.currentTimeStamp
                _ = Int64(currentTime) - time
                
                let timeText = "\(f.toString(dateFormat: "HH:mm a"))"
                let todaytext = "\(f.toString(dateFormat: "E, d MMM yyyy "))"
                
                self.datetimereciver = todaytext
                
                //                    cell.namelabel.text = todaytext
                cell.namelabel.isHidden = true
                
                cell.timeLabel.text = timeText
                
                print("timetext = \(timeText)")
                
            }
            
            handleTimeSender()
            
            if ChatMesssage[indexPath.row].message == "" {
                cell.bubbleBackgroundView.isHidden = true
            }else {
                
                cell.bubbleBackgroundView.isHidden = false
                cell.messageLabel.text = ChatMesssage[indexPath.row].message
                cell.isIncoming = false
                print("message iserror == \(message.iserror)")
                if message.iserror {
                    cell.refreshbutton.isHidden = false
                    cell.refreshbutton.setImage(UIImage(named: "Refresh"), for: .normal)
                    self.indexrow = indexPath.row
                    cell.refreshbutton.addTarget(self, action: #selector(refreshmessage), for: .touchUpInside)
                    cell.imagetick.isHidden = false
                    cell.imagetick.image = UIImage(named: "Wait for Network")
                }else if message.read {
                    cell.refreshbutton.isHidden = true
                    cell.imagetick.isHidden = false
                    cell.imagetick.image = UIImage(named: "Double Tick Green")
                }else if message.delivered == false {
                    cell.imagetick.isHidden = false
                    cell.refreshbutton.isHidden = true
                    cell.imagetick.image = UIImage(named: "Signle-Tick")
                    
                }else if message.delivered {
                    cell.imagetick.isHidden = false
                    cell.refreshbutton.isHidden = true
                    cell.imagetick.image = UIImage(named: "Double Tick")
                    
                }else if message.delivered == false{
                    cell.imagetick.isHidden = false
                    cell.refreshbutton.isHidden = true
                    cell.imagetick.image = UIImage(named: "Signle-Tick")
                }
            }
        }else {
            func handleTimeSender() {
                
                let time = Int64(ChatMesssage[indexPath.row].created_at)
                let f = Date(milliseconds: Int(time))
                let currentTime = self.currentTimeStamp
                _ = Int64(currentTime) - time
                
                let timeText = "\(f.toString(dateFormat: "hh:mm a"))"
                let todaytext = "\(f.toString(dateFormat: "E, d MMM yyyy "))"
                
                print("time == \(todaytext)")
                
                self.datetimesender = todaytext
                //                     cell.namelabel.text = todaytext
                cell.namelabel.isHidden = true
                //   cell.timeLabel.text = timeText
                cell.timeLabel.text =  timeText
                print("timetext = \(timeText)")
                
            }
            handleTimeSender()
            
            if message.iserror {
                cell.refreshbutton.isHidden = true
            }else if message.read {
                cell.refreshbutton.isHidden = true
                cell.imagetick.isHidden = true
                
            }else if message.delivered == false {
                cell.refreshbutton.isHidden = true
                cell.imagetick.isHidden = true
                
            }else if message.delivered {
                cell.refreshbutton.isHidden = true
                cell.imagetick.isHidden = true
                
            }else if message.delivered == false{
                cell.refreshbutton.isHidden = true
                cell.imagetick.isHidden = true
            }
            
            print("timecheck = \(String(describing: handleTimeSender))")
            
            
            cell.messageLabel.text = ChatMesssage[indexPath.row].message
            cell.isIncoming = true
            
            
        }
        let Suggestionmessage = ChatMesssage[ChatMesssage.count-1].message
        print("suggestionmeg  = \(String(describing: Suggestionmessage))")
        self.suggestionOptions(lastMessage: ChatMesssage[ChatMesssage.count-1].sender_uid)
        cell.Autoset()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Chatlist ==\(ChatMesssage[indexPath.row].iserror)")
    }
    
    private func tableView(tableView: UITableView, willDisplay cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        print("willDisplay")
    }
    
    
    func suggestionOptions(lastMessage:String){
        print("last Message = \(lastMessage)")
        let user = SessionManager.shared.userId
        suggestionBtn1.isHidden = false
        suggestionBtn2.isHidden = false
        suggestionBtn3.isHidden = false
        suggestionBtn4.isHidden = false
        if lastMessage == user {
            suggestionConstrainHeight.constant = Env.isIpad ? 50 : 40
            suggestionHeight.constant = Env.isIpad ? 40 : 30
            print(suggestionConstrainHeight.constant)
            suggestionBtn1.setTitle(userSuggestionArry[0], for: .normal)
            suggestionBtn2.setTitle(userSuggestionArry[1], for: .normal)
            suggestionBtn3.setTitle(userSuggestionArry[2], for: .normal)
            suggestionBtn4.setTitle(userSuggestionArry[3], for: .normal)
        }else {
            suggestionConstrainHeight.constant = Env.isIpad ? 50 : 40
            suggestionHeight.constant = Env.isIpad ? 40 : 30
            print(suggestionConstrainHeight.constant)
            suggestionBtn1.setTitle(senderSuggestionArray[0], for: .normal)
            suggestionBtn2.setTitle(senderSuggestionArray[1], for: .normal)
            suggestionBtn3.setTitle(senderSuggestionArray[2], for: .normal)
            suggestionBtn4.setTitle(senderSuggestionArray[3], for: .normal)
        }
    }
    
    
    @objc func buttonTapped( _ button : UIButton){
        print("actionss")
        print(button.tag)
    }
    
    
    
    class DateHeaderLabel: UILabel {
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .black
            textColor = .white
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false // enables auto layout
            font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 20, height: height)
        }
        
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tabview.scrollToRow(at: indexPath, at: .bottom, animated: false)
            
        }
    }
    @IBAction func SuggestionButtonSelectAction(_ sender: UIButton) {
        
        var btnmessage = ""
        if sender.tag == 1 {
            btnmessage = (suggestionBtn1.titleLabel?.text)!
            print("its 1 \(btnmessage)")
            textViewMessage.text = btnmessage
        }
        else if sender.tag == 2 {
            btnmessage = (suggestionBtn2.titleLabel?.text)!
            print("its 2 \(btnmessage)")
            textViewMessage.text = btnmessage
        }
        else if sender.tag == 3 {
            btnmessage = (suggestionBtn3.titleLabel?.text)!
            textViewMessage.text = btnmessage
            print("its 3 \(btnmessage)")
        }
        else if sender.tag == 4 {
            btnmessage = (suggestionBtn4.titleLabel?.text)!
            textViewMessage.text = btnmessage
            print("its 4 \(btnmessage)")
        }else {
            print("its 5 \(btnmessage)")
        }
        
        sendMessage()
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        movetochat = false
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let adjustedConstant = keyboardFrame.size.height
        debugPrint(adjustedConstant)
        bottomTextViewToSafe.constant = keyboardFrame.size.height
        self.view.layoutIfNeeded()
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        bottomTextViewToSafe.constant =  5
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.viewMessage.layoutIfNeeded()
            self.view.layoutIfNeeded()
        })
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 1000
        let size = CGSize(width: self.view.frame.width , height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    
    //MARK:- IBActions and user interaction
    
    
    @IBAction func btnSendMessageTapped(_ sender: UIButton) {
        print("Send Button Tapped")
        sendMessage()
    }
}



extension ChatLogVC : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.tag == 2 {
            typingTimerTrue.invalidate()
            if typingStatus == true {
                typingStatus = false
                typingTimmer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(update), userInfo: nil, repeats: false)
            }
            typingTimerTrue = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(upadteStop), userInfo: nil, repeats: false)
        }
        
        if textViewMessage.numberOfLines() == 1 {
            textMessageHight.constant = 45
        }else if textViewMessage.numberOfLines() == 2 {
            textMessageHight.constant = 60
        }else if textViewMessage.numberOfLines() == 3 {
            textMessageHight.constant = 75
        }
        
        if text == "\n" {
            if (textView.text == "")  {
                self.alert(message: "Message must not be empty")
            }else if (textView.text == " "){
                self.alert(message: "Message must not be empty")
            }
            else {
                sendMessage()
            }
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
        textView.text = ""
        textView.textColor = UIColor.black
        textView.tintColor = .black
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        if textView.tag == 2 {
            print("typing ended")
        }
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.font = UIFont.systemFont(ofSize: 18)
            
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldEndEditing")
        return true
    }
}
//MARK:- Sending message
extension ChatLogVC {
    func sendMessage() {
        
        let messagetext = textViewMessage.text.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        
        if messagetext.isEmpty || textViewMessage.text == "Text Message" || textViewMessage.text == nil {
            showToast(message: "Message must not be empty")
        }
        else{
            var sender = String()
            var receiver = String()
            var error: Bool = false
            if  NetworkReachabilityManager()!.isReachable {
                error = false
            }else {
                error = true
            }
            let data = SendMessage.init(message: self.textViewMessage.text, buyer_uid: ChatMesssage.last!.buyer_uid, item_id: ChatMesssage.last!.item_id, receiver_uid: ChatMesssage.last!.receiver_uid, sender: ChatMesssage.last!.sender, receiver: ChatMesssage.last!.receiver, seller_uid: ChatMesssage.last!.seller_uid, role: ChatMesssage.last!.role, sender_uid: ChatMesssage.last!.sender_uid, itemCategory: ChatMesssage.last!.itemCategory, itemAuctionType: ChatMesssage.last!.itemAuctionType, item_title: ChatMesssage.last!.title, item_image: ChatMesssage.last!.images_path, item_price: ChatMesssage.last!.item_price, delivered_time: currentTimeStamp,iserror: error )
            if data.sender_uid == SessionManager.shared.userId {
                sender = data.sender
                receiver = data.receiver
            }else {
                sender = data.receiver
                receiver = data.sender
            }
            if data.buyer_uid == SessionManager.shared.userId {
                data.role = "buyer"
                data.sender_uid = data.buyer_uid
                data.receiver_uid = data.seller_uid
            }else {
                data.role = "seller"
                data.sender_uid = data.seller_uid
                data.receiver_uid = data.buyer_uid
            }
            if data.iserror {
                print("This IsError is Called true")
                let newMessage = ChatMessageList.init(read: false, delivered_time: data.delivered_time, created_at: 000000, buyer_uid: data.buyer_uid, message: self.textViewMessage.text, itemCategory: data.itemCategory, sender_uid: data.sender_uid, item_id: data.item_id, item_price: data.item_price, sender: data.sender, itemAuctionType: data.itemAuctionType, receiver_uid: data.receiver_uid, images_small_path: data.item_image, delivered: false, seller_uid: data.seller_uid, id: data.item_id, images_path: data.item_image, title: data.item_title, receiver: data.receiver, role: data.role, iserror: data.iserror)
                self.ChatMesssage.insert(newMessage, at: 0)
                self.tabview.reloadUsingDispatch()
            }else {
                print("This IsError is Called false")
                socket?.emit("new_message", ["message" : data.message ,"buyer_uid" : data.buyer_uid , "item_id" : data.item_id ,"receiver_uid": data.receiver_uid , "sender" : sender ,"sender_uid" : data.sender_uid, "receiver" : receiver , "seller_uid" : data.seller_uid , "role" : data.role , "itemCategory" : data.itemCategory , "item_price" : data.item_price , "itemAuctionType" : data.itemAuctionType , "item_title": data.item_title , "delivered_time": data.delivered_time , "item_image" : data.item_image])
//
                self.textViewMessage.text = ""
                
                print("Message = \(["message" : data.message ,"buyer_uid" : data.buyer_uid , "item_id" : data.item_id ,"receiver_uid": data.receiver_uid , "sender" : data.sender ,"sender_uid" : data.sender_uid, "receiver" : data.receiver , "seller_uid" : data.seller_uid , "role" : data.role , "itemCategory" : data.itemCategory , "item_price" : data.item_price , "itemAuctionType" : data.itemAuctionType , "item_title": data.item_title , "delivered_time": data.delivered_time, "item_image :" : data.item_image ])")
              
              ////new

              //        Spinner.load_Spinner(image: fidgetImageView, view: self.DimView)
//              self.ChatMesssage.removeAll()
//              self.ChatMesssage.insert(newmessage, at: 0)
//              socket?.emit("read", ["item_id" : data.item_id , "receiver_uid" : data.receiver_uid , "delivered_time" : data.delivered_time , "sender_uid" : data.sender_uid] )
//                      MainAPi.Get_Chat(buyer_uid: data.buyer_uid, item_id: data.item_id, start: 0, limit: 15) { (status, data, error) in
//                          if status {
//              //                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
//                              let message = data!["message"]
//                              for msg in message {
//                                  let read = msg.1["read"].boolValue
//                                  let delivered_time = msg.1["delivered_time"].int64Value
//                                  let created_at = msg.1["created_at"].int64Value
//                                  let buyer_uid = msg.1["buyer_uid"].stringValue
//                                  let message = msg.1["message"].stringValue
//                                  let itemCategory = msg.1["itemCategory"].stringValue
//                                  let sender_uid = msg.1["sender_uid"].stringValue
//                                  let item_id = msg.1["item_id"].stringValue
//                                  let item_price = msg.1["item_price"].intValue
//                                  let sender = msg.1["sender"].stringValue
//                                  let itemAuctionType = msg.1["itemAuctionType"].stringValue
//                                  let receiver_uid = msg.1["receiver_uid"].stringValue
//                                  let images_small_path = msg.1["images_small_path"].stringValue
//                                  let delivered = msg.1["delivered"].boolValue
//                                  let seller_uid = msg.1["seller_uid"].stringValue
//                                  let id = msg.1["_id"].stringValue
//                                  let images_path = msg.1["images_path"].stringValue
//                                  let title = msg.1["title"].stringValue
//                                  let receiver = msg.1["receiver"].stringValue
//                                  let role = msg.1["role"].stringValue
//
//                                  if receiver_uid == SessionManager.shared.userId && read == false {
//                                      socket?.emit("read", ["item_id" : item_id , "receiver_uid" : receiver_uid , "delivered_time" : delivered_time , "sender_uid" : sender_uid] )
//                                  }
//                                  let msgdata = ChatMessageList.init(read: read, delivered_time: delivered_time, created_at: created_at, buyer_uid: buyer_uid, message: message, itemCategory: itemCategory, sender_uid: sender_uid, item_id: item_id, item_price: item_price, sender: sender, itemAuctionType: itemAuctionType, receiver_uid: receiver_uid, images_small_path: images_small_path, delivered: delivered, seller_uid: seller_uid, id: id, images_path: images_path, title: title, receiver: receiver, role: role, iserror: false)
//
//                                self.ChatMesssage.append(msgdata)
//                                 self.tabview.reloadUsingDispatch()
//                              }
//
//
//                          }
//
//
//              }
              
              ////end
               
            }
        }
    }
    
}

extension ChatLogVC {
    override func willMove(toParentViewController parent: UIViewController?) {
        //print("Got it ")
        if parent == nil, let delegate = delegate {
            delegate.willMove()
        }
        
    }
}

protocol ChatLogVCDelegate: class {
    func willMove()
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
    
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
}


extension ChatLogVC : UIScrollViewDelegate {
    
    
    @objc func hidetextbox() {
        
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        scrollView.contentInset = UIEdgeInsets.init(top: 25, left: 0, bottom: 25, right: 0)
        
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                //self.navigationController?.setToolbarHidden(false, animated: true)
                self.MainAPi.Get_Chat(buyer_uid: self.ChatMesssage[0].buyer_uid, item_id: self.ChatMesssage[0].item_id, start: self.ChatMesssage.count, limit: 15) { (status, data, error) in
                    
                    if status {
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
                            
                            let msgdata = ChatMessageList.init(read: read, delivered_time: delivered_time, created_at: created_at, buyer_uid: buyer_uid, message: message, itemCategory: itemCategory, sender_uid: sender_uid, item_id: item_id, item_price: item_price, sender: sender, itemAuctionType: itemAuctionType, receiver_uid: receiver_uid, images_small_path: images_small_path, delivered: delivered, seller_uid: seller_uid, id: id, images_path: images_path, title: title, receiver: receiver, role: role, iserror: false)
                            
                            if self.ChatMesssage.last!.buyer_uid == msgdata.buyer_uid {
                                self.ChatMesssage.append(msgdata)
                            }
                            
                            
                        }
                        self.tabview.reloadData()
                        
                        
                    }
                    
                }
                
                
                
                print("Unhide")
            }, completion: nil)
        }
        
        print("Data Fetching...  \(velocity.y)")
        
        if velocity.y > 2.5   {
            //self.fetchDisplayData()
            
        }
    }
    
    
    
}
extension UITextView{
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
}

