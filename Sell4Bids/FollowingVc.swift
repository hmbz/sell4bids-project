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
import Cosmos
import XLPagerTabStrip

class FollowingVc: UIViewController, IndicatorInfoProvider {
  
  //Mark: - Properties
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var emptyMessage: UILabel!
  @IBOutlet weak var fidgetImageView: UIImageView!
  
    @IBOutlet weak var DimView: UIView!
    //Mark: - variables
  var MainApis = MainSell4BidsApi()
  var nav:UINavigationController?
  var followingArray = [UserModel]()
  var followingArr = [FollowingModel]()
    var sellerDetail : SellerDetailModel?
    lazy var responseStatus = false
    lazy var bottomBar =  false
    
 // var dbRef: DatabaseReference!
 // var imageUrl = ""
    @IBOutlet weak var errorimg: UIImageView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    topMenu()
   
    if bottomBar == true {
        self.tabBarController?.tabBar.isHidden = true
    }
    fidgetImageView.toggleRotateAndDisplayGif()
  //  dbRef = Database.database().reference()

  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
     getFollowingListItem()
  //  getFollowingListItem()
   // getFollowinglist()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white

  }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        print("Disappear")
//        getFollowingListItem()
         self.followingArr.removeAll()
    }
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Followings"
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
  
    func getFollowingListItem(){
//        followingArr.removeAll()
        
        let start = followingArr.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.isHidden = false
                self.DimView.isHidden = false
            }
        }
        MainApis.Following_Api(user_ID: SessionManager.shared.userId, country: "USA", start: "\(start)", limit: "10", completionHandler: { (status, swifymessage, error) in
            
            self.fidgetImageView.isHidden = true
            self.responseStatus = true
            if status {
//            self.followingArr.removeAll()
            let totalCount = swifymessage!["totalCount"].int!
            let message = swifymessage!["message"]
            print("message1 = \(message)")
            if totalCount > 0 {
            self.hideCollectionView(hideYesNo: false)
                
            for item in 0...totalCount-1{
                
                
                let data = message[item]
            
                let userID = data["_id"].stringValue
                let name = data["name"].stringValue
                let image = data["image"].stringValue
                var averageRating = ""
                var totalRatings = ""
                
                if data["averagerating"].exists(){
                    averageRating = data["averagerating"].stringValue
                }else{
                }
                
                if data["totalratings"].exists(){
                    totalRatings = data["totalratings"].stringValue
                }else{
                }
                let followingItems = FollowingModel.init(name: name, userid: userID, totalrating: totalRatings, averagerating: averageRating, image: image)
          
             self.followingArr.append(followingItems)
            }
                self.tableView.reloadData()

            }else{
                if self.followingArr.count > 0 {
                    
                self.hideCollectionView(hideYesNo: false)
                    
                }else {
                    
                 self.hideCollectionView(hideYesNo: true)
                    
                }
                
                }
          
            }else{
                
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
            
        })
        
    }
    
  func hideCollectionView(hideYesNo : Bool) {
    
    emptyMessage.text = "People, you follow, appear here"
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
    
//  func getFollowinglist(){
//    self.fidgetImageView.isHidden = false
//    guard let userID = Auth.auth().currentUser?.uid else {
//      print("ERROR: while getting user ID")
//      return
//    }
//    dbRef.child("users").child(userID).child("followings").observeSingleEvent(of: .value) { (followerSnapshot) in
//      self.followingArray.removeAll()
//      if followerSnapshot.childrenCount > 0 {
//        guard let followingList = followerSnapshot.value as? NSDictionary else {
//          print("ERROR: while getting followers list")
//          self.hideCollectionView(hideYesNo: true)
//          return
//        }
//        for follower in followingList {
//          guard let userId = follower.key as? String else {return}
//          self.dbRef.child("users").child(userId).observeSingleEvent(of: .value, with: { (userSnapshot) in
//            guard let userDict = userSnapshot.value as? [String:AnyObject] else {return}
//            let userList =  UserModel(userId: userId, userDict: userDict)
//            self.followingArray.append(userList)
//            self.fidgetImageView.isHidden = true
//            self.fidgetImageView.image = nil
//
//            DispatchQueue.main.async {
//              self.hideCollectionView(hideYesNo: false)
//              self.tableView.reloadData()
//
//            }
//          })
//        }
//      }else{
//        self.hideCollectionView(hideYesNo: true)
//      }
//    }
//  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "FollowingTab".localizableString(loc: LanguageChangeCode))
  }
  
}
//Mark: - UITableViewDataSource,UITableViewDelegate

extension FollowingVc: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return followingArr.count
   // return followingArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard followingArr.count > 0 else {
      print("following arry count is 0 ")
      return UITableViewCell()
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
    let followingInfo = followingArr[indexPath.row]
    cell.followingUserNameLabel.text = followingInfo.Name
   
      cell.FollwingUserImageView.sd_setImage(with: URL(string: followingInfo.image), placeholderImage: UIImage(named:"emptyImage"))
   
    if followingInfo.averagerating != "" {
        
        cell.followingCosmosView.rating = Double(followingInfo.averagerating)!
        
      }
        else {
          cell.followingCosmosView.rating = 0
          cell.followingRating.text = "Not rated yet"
        }
    
    if followingInfo.totalratings != ""{
    cell.followingRating.text = "( Total ratings- \(followingInfo.totalratings)  )"
    }else{
         cell.followingRating.text = "( Not rated yet )"
    }

    cell.selectionStyle = UITableViewCellSelectionStyle.none
    cell.followingCosmosView.settings.updateOnTouch = false
    cell.updateUIForFollowing()
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//     Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
    self.DimView.isHidden = false
    self.DimView.alpha = 1
    self.DimView.backgroundColor = .clear
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        if self.responseStatus == false {
            self.fidgetImageView.toggleRotateAndDisplayGif()
            self.fidgetImageView.isHidden = false
        }
    }
    
    MainApis.Seller_Detail_Api(buyer_uid: SessionManager.shared.userId, seller_uid: self.followingArr[indexPath.row].userID) { (status, data, error) in
        
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
            let storyboard = UIStoryboard.init(name: "UserDetails", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
          
            controller.sellerDetail = self.sellerDetail
            
            controller.title = self.sellerDetail!.name
            
            self.navigationController?.pushViewController(controller, animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
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
                getFollowingListItem()
            }
        }
    }
  
}

