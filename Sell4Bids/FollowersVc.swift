//
//  FollowersVc.swift
//  Sell4Bids
//
//  Created by admin on 10/16/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import XLPagerTabStrip

class FollowersVc: UIViewController , IndicatorInfoProvider {
  
  //MARK: - Properties
  
    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var emptyMessage: UILabel!
  @IBOutlet weak var fidgetImageView: UIImageView!
    var sellerDetail : SellerDetailModel?
  
  //MARK: - variables
  var nav:UINavigationController?
  var followerArray = [UserModel]()
  var followerProductsArray = [ProductModel]()
    var followerArr = [FollowersModel]()
 // var dbRef: DatabaseReference!
    var MainApis = MainSell4BidsApi()
    lazy var responseStatus = false
    lazy var bottomBar = false
    
  
    @IBOutlet weak var errorimg: UIImageView!
    var imageUrl = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    topMenu()
    if bottomBar == true {
        self.tabBarController?.tabBar.isHidden = true
    }
//    getFollowersListItem()
//    self.followerArr.removeAll()
//    fidgetImageView.toggleRotateAndDisplayGif()
 
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
    getFollowersListItem()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
//    navigationController?.isToolbarHidden = false
  //  getFollowerlist()
  }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        print("Disappear")
         followerArr.removeAll()
//        getFollowersListItem()
    }
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Followers"
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
    
    
    
    func getFollowersListItem(){
        
        let start = followerArr.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.isHidden = false
                self.DimView.isHidden = false
            }
        }
//        self.fidgetImageView.toggleRotateAndDisplayGif()
//        Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
        MainApis.Follower_Api(user_ID: SessionManager.shared.userId, country: "USA", start: "\(start)", limit: "10", completionHandler: { (status, swifymessage, error) in
            
            self.fidgetImageView.isHidden = true
            
            if status {
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
              self.responseStatus = true
                
                
//            self.followerArr.removeAll()
                _ = swifymessage!["totalCount"].int!
//                if totalCount == 0 {
//                    self.errorimg.isHidden = false
//                    self.emptyMessage.isHidden = false
//
//                }else {
//                    self.errorimg.isHidden = true
//                    self.emptyMessage.isHidden = true
//
//                }
            let message = swifymessage!["message"]
            print("message1 = \(message)")
          
                for msg in message {
                    let uid = msg.1["uid"].stringValue
                    let name = msg.1["name"].stringValue
                    let averagerating = msg.1["averagerating"].doubleValue
                    let image = msg.1["image"].stringValue
                    let totalrating = msg.1["totalrating"].doubleValue
                    let id = msg.1["_id"].stringValue
                    
                    let userdata = FollowersModel.init(uid: uid, name: name, averagerating: averagerating, image: image, totalratings: totalrating, id: id)
                    self.followerArr.append(userdata)
                    self.tableView.reloadData()
                    
                    
                }
              
              if self.followerArr.count > 0 {
                 self.errorimg.isHidden = true
                  self.emptyMessage.isHidden = true
              }else {
                  self.errorimg.isHidden = false
                  self.emptyMessage.isHidden = false
                  self.emptyMessage.text = "No Follower"
              }

            
            if error.contains("The network connection was lost"){
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                self.present(alert, animated: true, completion: nil)
                
                
            }
            
            
            if error.contains("The Internet connection appears to be offline.") {
               
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            if error.contains("A server with the specified hostname could not be found."){
               
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                
                self.present(alert, animated: true, completion: nil)
            }
            
            if error.contains("The request timed out.") {
               
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
    })
    }
    
    
  func hideCollectionView(hideYesNo : Bool) {
    
    emptyMessage.text = "People, who follow you, appear here".localizableString(loc: LanguageChangeCode)
    if hideYesNo == false {
      tableView.isHidden = false
      fidgetImageView.isHidden = true
        fidgetImageView.image = nil
      emptyMessage.isHidden = true
      errorimg.isHidden = true
        
    }
    else  {
      fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        
      tableView.isHidden = true
      emptyMessage.isHidden = false
         errorimg.isHidden = false
    }
  }
//  func getFollowerlist(){
//    dbRef = Database.database().reference()
//    guard let userID = Auth.auth().currentUser?.uid else {
//      print("ERROR: while getting user ID")
//      return
//    }
//    dbRef.child("users").child(userID).child("followers").observeSingleEvent(of: .value) { (followerSnapshot) in
//      self.followerArray.removeAll()
//      if followerSnapshot.childrenCount > 0 {
//        guard let followersList = followerSnapshot.value as? NSDictionary else {
//          print("ERROR: while getting followers list")
//          self.hideCollectionView(hideYesNo: true)
//          return
//        }
//        for follower in followersList {
//          guard let userId = follower.key as? String else {return}
//          self.dbRef.child("users").child(userId).observeSingleEvent(of: .value, with: { (userSnapshot) in
//            guard let userDict = userSnapshot.value as? [String:AnyObject] else {return}
//            let userList =  UserModel(userId: userId, userDict: userDict)
//            self.followerArray.append(userList)
//            self.fidgetImageView.isHidden = true
//            self.fidgetImageView.image = nil
//            DispatchQueue.main.async {
//              self.hideCollectionView(hideYesNo: false)
//              self.tableView.reloadData()
//            }
//          })
//        }
//      }else {
//        self.hideCollectionView(hideYesNo: true)
//      }
//    }
//  }//end func
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "FollowersTab".localizableString(loc: LanguageChangeCode))
  }
}
//Mark: - UITableViewDataSource,UITableViewDelegate

extension FollowersVc: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return followerArr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard followerArr.count > 0 else {
      print("following arry count is 0 ")
      return UITableViewCell()
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
    let follwersInfo = followerArr[indexPath.row]
    cell.userName.text = follwersInfo.name
          cell.userImage.sd_setImage(with: URL(string: follwersInfo.image), placeholderImage: UIImage(named:"emptyImage"))
    
    
    if follwersInfo.averagerating != 0 {
        if  follwersInfo.averagerating != 0 {
        
           cell.cosmosViewRating.rating = follwersInfo.averagerating
        
      }
        if  follwersInfo.totalratings != 0 {
            cell.ratingLabel.text = "( Total ratings- \(follwersInfo.totalratings)  )"
      }
    }
    else {
      cell.cosmosViewRating.rating = 0
      cell.ratingLabel.text = "Not rated yet"
    }
    //
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    cell.cosmosViewRating.settings.updateOnTouch = false
    cell.updateUIForFollower()
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.DimView.isHidden = false
    self.DimView.alpha = 1
    self.DimView.backgroundColor = .clear
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        if self.responseStatus == false {
            self.fidgetImageView.toggleRotateAndDisplayGif()
            self.fidgetImageView.isHidden = false
        }
    }
    
    MainApis.Seller_Detail_Api(buyer_uid: SessionManager.shared.userId, seller_uid: self.followerArr[indexPath.row].id) { (status, data, error) in
        
        if status {
            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
            self.responseStatus = true
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
                
               
//                if (self.currentUserId == sellerdata.id) {
//
//                    let cancel = UIBarButtonItem.init(image:UIImage(named: "stepBack") , style:.plain, target: self, action: #selector(self.backBtnTap))
//                    self.navigationItem.leftBarButtonItem = cancel
//                    self.navigationItem.title = sellerdata.name
//                }
                
            
            
            let storyboard = UIStoryboard.init(name: "UserDetails", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
            controller.UserDetails = self.followerArr[indexPath.row]
            controller.sellerDetail = self.sellerDetail
            controller.title = self.sellerDetail!.name
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        
    }
    
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 130
  }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
        if scrollView == tableView {
            let currentOffset = tableView.contentOffset.y
            let maxOffset = tableView.contentSize.height - scrollView.frame.height
            print("contentoffset = \(scrollView.contentOffset.y)")
            print("scrollview height = \(scrollView.frame.height )")
            self.fidgetImageView.isHidden = true
            fidget.stopfiget(fidgetView: fidgetImageView)
            scrollView.delegate = self
            print("Height == \(scrollView.contentSize.height)")
            print("maxoffset == \(maxOffset) // == Currentoffset = \(currentOffset)")
            print( "maxoffset- currentoffset = \(maxOffset - currentOffset)")
            
            if maxOffset - currentOffset < 50 {
                getFollowersListItem()
            }
        }
    }
    
    
}

