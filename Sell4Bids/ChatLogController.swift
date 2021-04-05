//
//  ChatLogController.swift
//  fbMessenger
//
//  Created by admin on 9/20/19.
//  Copyright © 2019 Starvation. All rights reserved.
//

import UIKit
import UserNotifications

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Properies
    
    let messageInputContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField : UITextField = {
       let textfield = UITextField()
        textfield.placeholder = "Enter message ..."
        return textfield
    }()
    let sendButton: UIButton = {
       let button = UIButton()
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    
    //MARK:- Variables
    var instance : MessageModel?
    lazy var messageLogArray = [MessageLogModel]()
    private let cellId = "cellId"
    var bottomConstraint: NSLayoutConstraint?
    lazy var titleview = Bundle.main.loadNibNamed("EdTopBarView", owner: self, options: nil)?.first as! EdTopBarView
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.01835327221, green: 0.01723449095, blue: 0.1892845812, alpha: 1)
        self.collectionView?.backgroundColor = #colorLiteral(red: 0.01835327221, green: 0.01723449095, blue: 0.1892845812, alpha: 1)
        topMenu()
        setupChatModel()
        self.collectionView?.scrollToBottom()
        setupInputComponents()
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = instance?.name
        
        collectionView?.register(chatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageInputContainerView)
        //Vertical and horizental constraints for Input Container View
        view.addConstrainstsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstrainstsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    //MARK:- Action
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func infoBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = keyboardFrame.height
                print(keyboardHeight)
                let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
                bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
                UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }) { (completion) in
                    // code
                    if isKeyboardShowing {
                        self.collectionView?.scrollToBottom()
                    }
                    
                }
            }
        }
    }
    
    @objc func sendButtonTapped() {
        print("Send Button Tapped")
        if inputTextField.text!.isEmpty {
            print("Please enter Some text")
        }else {
            let message = MessageLogModel.init(id: 190, message: inputTextField.text!, seenStatus: false, senderId: 123)
            messageLogArray.append(message)
            self.collectionView?.reloadData()
            self.collectionView?.scrollToBottom()
            self.inputTextField.text = ""
        }
        
    }
    
    //MARK:- Functions
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.infoBtn.addTarget(self, action: #selector(infoBtnTapped(sender:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.20239, green: 0.31236, blue: 0.53646, alpha: 1)
    }
    
    private func setupInputComponents() {
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        //Vertical and horizental constraints for Input Container View
        messageInputContainerView.addConstrainstsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        messageInputContainerView.addConstrainstsWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstrainstsWithFormat(format: "V:|[v0]|", views: sendButton)
        
        messageInputContainerView.addConstrainstsWithFormat(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstrainstsWithFormat(format: "V:|[v0(1)]", views: topBorderView)
    }
    
    private func setupChatModel() {
      let msg1 = MessageLogModel.init(id: 1, message: "Hi how are you buddy", seenStatus: true, senderId: 123)
        let msg2 = MessageLogModel.init(id: 2, message: "Miss bergenza is looking a long long for you very very bad buddy :( i wnt t make the payment of your laptop is this free for me or not usman is also loooking for iphone 7 do you want to cell?", seenStatus: true, senderId: 124)
        let msg3 = MessageLogModel.init(id: 3, message: "Miss bergenza is looking a long long for you very very bad buddy :( i wnt t make the payment of your laptop is this free for me or not usman is also loooking for iphone 7 do you want to cell?", seenStatus: true, senderId: 123)
        let msg4 = MessageLogModel.init(id: 4, message: "Miss bergenza is looking a long long for you very very bad buddy :( i wnt t make the payment of your laptop is this free for me or not usman is also loooking for iphone 7 do you want to cell?", seenStatus: true, senderId: 124)
        let msg5 = MessageLogModel.init(id: 5, message: "Miss bergenza is looking a long long for you very very bad buddy :( i wnt t make the payment of your laptop is this free for me or not usman is also loooking for iphone 7 do you want to cell?", seenStatus: true, senderId: 123)
        let msg6 = MessageLogModel.init(id: 6, message: "Miss bergenza is looking a long long for you very very bad buddy :( i wnt t make the payment of your laptop is this free for me or not usman is also loooking for iphone 7 do you want to cell?", seenStatus: true, senderId: 124)
        let msg7 = MessageLogModel.init(id: 7, message: "Miss bergenza is looking a long long for you very very bad buddy :( i wnt t make the payment of your laptop is this free for me or not usman is also loooking for iphone 7 do you want to cell?", seenStatus: true, senderId: 123)
        let msg8 = MessageLogModel.init(id: 8, message: "Miss bergenza is looking a long long for you very very bad buddy :( i wnt t make the payment of your laptop is this free for me or not usman is also loooking for iphone 7 do you want to cell?", seenStatus: true, senderId: 124)
        let msg9 = MessageLogModel.init(id: 9, message: "Miss bergenza is looking a long long for you very very bad buddy :( i wnt t make the payment of your laptop is this free for me or not usman is also loooking for iphone 7 do you want to cell?", seenStatus: true, senderId: 123)
         let msg10 = MessageLogModel.init(id: 10, message: "Miss bergenza is looking a long long for you very very bad buddy :( i wnt t make the payment of your laptop is this free for me or not usman is also loooking for iphone 7 do you want to cell?", seenStatus: true, senderId: 124)
        let msg11 = MessageLogModel.init(id: 10, message: "Okay", seenStatus: true, senderId: 123)
        let msg12 = MessageLogModel.init(id: 10, message: "Did you call mom?", seenStatus: true, senderId: 124)
        messageLogArray = [msg1,msg2,msg3,msg4,msg5,msg6,msg7,msg8,msg9,msg10,msg11,msg12]
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageLogArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! chatLogMessageCell
        cell.messageTextView.text = messageLogArray[indexPath.item].message
        if let messageText = messageLogArray[indexPath.item].message {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText ).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            let userId = 123
            if messageLogArray[indexPath.item].senderId == userId {
                // Outgoing messages
                cell.profileImageView.isHidden = true
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
                cell.messageTextView.textColor = UIColor.white
                cell.textBubbleView.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 1, alpha: 1)
            }else {
                // incoming messages
                cell.profileImageView.isHidden = false
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 6)
                cell.messageTextView.textColor = UIColor.black
                cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
            }
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let messageText = messageLogArray[indexPath.row].message ?? ""
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 20 + 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 50, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
}

extension UICollectionView {
    func scrollToBottom() {
        let rows = self.numberOfItems(inSection: 0)
        if rows > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: rows - 1, section: 0)
                self.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
            }
        }
    }
}


