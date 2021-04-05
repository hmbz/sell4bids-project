//
//  ViewController.swift
//  fbMessenger
//
//  Created by admin on 9/20/19.
//  Copyright © 2019 Starvation. All rights reserved.
//

import UIKit
import SDWebImage
import XLPagerTabStrip
import SwiftyJSON
import NotificationCenter
import UserNotifications

struct MessageModel {
    var name:String?
    var image : UIImage?
    var message: String?
    var hasRead : Bool?
    var date: String?
    
    init(name:String?, image: UIImage, message: String?, hasRead: Bool?, date: String?) {
        self.name = name
        self.image = image
        self.message = message
        self.hasRead = hasRead
        self.date = date
    }
}

class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Variables
    private let cellId = "cellId"
    lazy var modelArray = [MessageModel]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModel()
        topMenu()
        navigationItem.title = "Recent"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(FriendCell.self, forCellWithReuseIdentifier: cellId)
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Functions
    
    private func setupModel() {
        let mark = MessageModel.init(name: "Mark zuckerberg", image: #imageLiteral(resourceName: "Moto Bike"), message: "Hi, How are you?", hasRead: true, date: "10:00 am")
        let steve = MessageModel.init(name: "Steve Jobs", image: #imageLiteral(resourceName: "Housing@48px"), message: "Are, you available?", hasRead: false, date: "12:00 pm")
        let tim = MessageModel.init(name: "Tim cock", image: #imageLiteral(resourceName: "Profile"), message: "Hi, How are you?", hasRead: true, date: "12:35 pm")
        let bill = MessageModel.init(name: "Bill Gates", image: #imageLiteral(resourceName: "camera_top_andr"), message: "I am in canada", hasRead: false, date: "3:00 pm")
        modelArray = [mark, steve, tim, bill]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FriendCell
        cell.setupModel(instance: modelArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = ChatLogController(collectionViewLayout: layout)
        controller.instance = modelArray[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
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
        //        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
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
//Cell for implementing the Friends view
class FriendCell: BaseCell {
    
    //Properties
    
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? UIColor.gray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 32
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Steve Jobs"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "your friends message and something else....."
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "12:05 pm"
        label.textAlignment = .right
        return label
    }()
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // Functions
    override func setupViews() {
        
        addSubview(profileImageView)
        addSubview(dividerLineView)
        setupContainerview()
        profileImageView.image = UIImage(named: "steve")
        hasReadImageView.image = UIImage(named: "steve")
        // horizental and vertical view for Profile view
        addConstrainstsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstrainstsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        // horizental and vertical view for Divider line
        addConstrainstsWithFormat(format: "H:|-82-[v0]|", views: dividerLineView)
        addConstrainstsWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
    }
    
    private func setupContainerview() {
        let containerView = UIView()
        addSubview(containerView)
        
        // horizental and vertical view for Continer view
        addConstrainstsWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstrainstsWithFormat(format: "V:[v0(50)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        containerView.addConstrainstsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabel,timeLabel)
        containerView.addConstrainstsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel,messageLabel)
        
        containerView.addConstrainstsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        
        containerView.addConstrainstsWithFormat(format: "V:|[v0(24)]", views: timeLabel)
        
        containerView.addConstrainstsWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
    }
    
     func setupModel(instance: MessageModel){
        nameLabel.text = instance.name
        messageLabel.text = instance.message
        profileImageView.image = instance.image
        hasReadImageView.image = instance.image
        let hasRead = instance.hasRead
        if hasRead == true {
            hasReadImageView.isHidden = false
        }else {
            hasReadImageView.isHidden = true
        }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yy-mm-dd" //Your date format
//        print(instance.date!)
        //according to date format your date string
//        guard let date = dateFormatter.date(from: instance.date!) else {
//            print("Error")
//            return
//        }
//        print(date) //Convert String to Date
//        let elapsedTimeSeconds = NSDate().timeIntervalSince(date)
//        let secondsInDays: TimeInterval = 60 * 60 * 24
//        if elapsedTimeSeconds > 7 * secondsInDays {
//            dateFormatter.dateFormat = "mm/dd/yy"
//        }else {
//            dateFormatter.dateFormat = "EEE"
//        }
//        print(date)
        timeLabel.text = instance.date
 
    }
}

extension UIView{
    func addConstrainstsWithFormat(format: String, views: UIView... ) {
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: format, metrics: nil, views: viewsDictionary))
    }
}

//Parent Cell class for dont Writing the unecessary code
class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    }
}

