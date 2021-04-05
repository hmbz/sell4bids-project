//
//  BlockUserVc.swift
//  Sell4Bids
//
//  Created by admin on 10/16/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import Cosmos
import XLPagerTabStrip

class BlockUserVc: UIViewController, IndicatorInfoProvider {
  //Mark: - Properties
  
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var emptyMessage: UILabel!
  @IBOutlet weak var fidgetImageView: UIImageView!
  @IBOutlet weak var cosmosViewRating: CosmosView!
  @IBOutlet weak var totalRatingLabel: UILabel!
  
    var MainApis = MainSell4BidsApi()
    @IBOutlet weak var errorimg: UIImageView!
    
  
  
  //Mark: - variables
  var nav:UINavigationController?
  var blockedUserArray = [UserModel]()
    var blockedUserArr = [BlockListModel]()
//  var dbRef: DatabaseReference!
  var imageUrl = ""
    lazy  var responseStatus = false
  
//  let currentUserId = Auth.auth().currentUser?.uid
  let dbR = FirebaseDB.shared.dbRef
    lazy var bottomBar =  false
    
  override func viewDidLoad() {
    super.viewDidLoad()
    topMenu()
     //   blockedUsersData()
    
    fidgetImageView.toggleRotateAndDisplayGif()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    if bottomBar == true {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // tableView.separatorColor = UIColor(white: 0.95 , alpha:1)
    
    // Do any additional setup after loading the view.
  //  dbRef = Database.database().reference()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
     self.fidgetImageView.isHidden = true
    
    getBlockListItem()
   // blockedUserArray.removeAll()
   
 //   blockedUsersData()
//    fidgetImageView.toggleRotateAndDisplayGif()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    
    // tableView.separatorColor = UIColor(white: 0.95 , alpha:1)
    
    // Do any additional setup after loading the view.
  //  dbRef = Database.database().reference()

  }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        print("Disappear")
//        getBlockListItem()
        blockedUserArray.removeAll()
    }
    
    
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Block List"
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
    
    
    
    func getBlockListItem(){
        
//        self.blockedUserArr.removeAll()
        let start = blockedUserArr.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.isHidden = false
//                self.dim.isHidden = false
            }
        }
        MainApis.BlockList_Api(user_ID: SessionManager.shared.userId, country: "USA", start: "\(start)", limit: "10", completionHandler: { (status, swifymessage, error) in
            
            self.fidgetImageView.isHidden = true
            self.responseStatus = true
            if status {
            let totalCount = swifymessage!["totalCount"].int!
            let message = swifymessage!["message"]
            print("message1 = \(message)")
            if totalCount > 0 {
                self.hideCollectionView(hideYesNo: false)
                
                for item in 0...totalCount-1{
                    
                    
                    let data = message[item]
                    
                    let userID = data["_id"].stringValue
                    let name = data["name"].stringValue
                    var image = ""
                    var averageRating = ""
                    var totalRatings = ""
                    
                    if data["image"].exists(){
                        image = data["image"].stringValue
                    }else{
                    }
                    
                    if data["averagerating"].exists(){
                        averageRating = data["averagerating"].stringValue
                    }else{
                    }
                    
                    if data["totalratings"].exists(){
                        totalRatings = data["totalratings"].stringValue
                    }else{
                    }
                    
                    
                    //                var old_small_images = [String]()
                    //                let old_small_imagesCount = data["old_small_images"].count
                    //                for i in 0...old_small_imagesCount-1{
                    //                    let img = data["old_small_images"][i].string
                    //                    old_small_images.append(img!)
                    //                }
                    
                    //                var old_images = [String]()
                    //                let old_imagesCount = data["old_images"].count
                    //                for i in 0...old_imagesCount-1{
                    //                    var img = data["old_small_images"][i].string
                    //                    old_images.append(img!)
                    //                }
                    //                print("oldImages \(old_images)")
                    
                    
                    let BlockItems = BlockListModel.init(name: name, userid: userID, totalrating: totalRatings, averagerating: averageRating, image: image)
                    
                    
                    self.blockedUserArr.append(BlockItems)
                    
                }
                self.tableView.reloadData()
            }else{
                if self.blockedUserArr.count > 0 {
                    self.hideCollectionView(hideYesNo: false)
                }else {
                   self.hideCollectionView(hideYesNo: true)
                }
                self.tableView.reloadData()
           
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
    
    emptyMessage.text = "People, you block, appear here"
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
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
//  func blockedUsersData(){
//    let userID = Auth.auth().currentUser?.uid
//
//
//    dbR.child("users").child(userID!).child("blockedPersons").observeSingleEvent(of: .value) { (snapshot) in
//
//      // Get user value
//      if let dict = snapshot.value as? NSDictionary {
//
//
//
//        if let blockedUsers = dict as? NSDictionary {
//          self.hideCollectionView(hideYesNo: false)
//           self.blockedUserArray.removeAll()
//
//            for value in blockedUsers{
//                if blockedUsers.count > 0{
//            //Block User Id
//            let userId = value.key
//            print("Blocked Data Key = \(value.key)")
//                    self.dbRef.child("users").child(userId as! String).observeSingleEvent(of: .value, with: { (snapshot) in
//              if let dictObj = snapshot.value as? NSDictionary {
//                let userName = dictObj.value(forKey: "name")
//                if let userImage = dictObj.value(forKey: "image")
//                {
//                  self.imageUrl = userImage as! String
//                }
//                var checkRating = "0"
//                if let rating = dictObj.value(forKey: "averagerating") {
//                  checkRating = rating as! String
//
//                }
//
//                var checktotalRating = "0"
//                if let totalrating = dictObj.value(forKey: "totalratings") {
//                  checktotalRating = totalrating as! String
//
//                }
//
//                let ratingInt = (checkRating as NSString).floatValue
//                let totalratingInt = (checktotalRating as NSString).floatValue
//
//
//                let blockedUser:UserModel = UserModel(name: userName as? String ?? "Sell4BidsUser", image: self.imageUrl ?? " ", userId: userId as? String ?? " ", averageRating: ratingInt ?? 0, totalRating: totalratingInt ?? 0 , email: "", zipCode: nil, state: "", watching: 0, follower: 0, following: 0, totalListing: 0, buying: 0, bought: 0, unReadMessage: 0, unReadNotify: 0)
//
//
//                self.blockedUserArray.append(blockedUser)
//               print("Blocked User = \(self.blockedUserArray.count)")
//
//              }
//
//              DispatchQueue.main.async {
//
//                self.fidgetImageView.isHidden = true
//                self.fidgetImageView.image = nil
//                self.hideCollectionView(hideYesNo: false)
//                self.tableView.reloadData()
//              }
//
//            }) { (error) in
//              print(error.localizedDescription)
//
//            }
//          }
//
//
//
//        }
//        }else {
//          self.blockedUserArray.removeAll()
//            self.tableView.reloadData()
//
//          self.hideCollectionView(hideYesNo: true)
//        }
//
//      }
//
//    }
//
//    if self.blockedUserArray.count <= 0 {
//        self.hideCollectionView(hideYesNo: true)
//        self.fidgetImageView.isHidden = true
//        self.errorimg.isHidden = false
//        self.emptyMessage.isHidden = false
//    }
//  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "Block ListTab".localizableString(loc: LanguageChangeCode))
  }
}
//Mark: - UITableViewDataSource,UITableViewDelegate

extension BlockUserVc: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return blockedUserArr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard blockedUserArr.count > 0 else {
      print("blockedUserArray count is 0")
      return UITableViewCell()
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
    let followingInfo = blockedUserArr[indexPath.row]
    cell.blockUserNameLabel.text = followingInfo.Name
    cell.blockUserImageView.sd_setImage(with: URL(string: followingInfo.image ?? "" ), placeholderImage: UIImage(named:"emptyImage"))
    if followingInfo.averagerating != "" {
        if  followingInfo.averagerating != "" {
            cell.blockCosmosView.rating = Double(followingInfo.averagerating)!
        
      }
        if  followingInfo.totalratings != "" {
        cell.blockRating.text = "( Total ratings- \(followingInfo.totalratings)  )"
      }
      
    }
    else {
      cell.blockCosmosView.rating = 0
      cell.blockRating.text = "Not rated yet"
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    cell.blockCosmosView.settings.updateOnTouch = false
    cell.updateUIForBlockedUser()
    return cell
  }
    
    // @ OsamaMansoori 14-06-2019
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let blockedPerson = blockedUserArr[indexPath.row]
    
//    let alertController = UIAlertController(title: "Unblock Person", message: "Do you want to unblock this person ? ", preferredStyle: .alert)
    
    _ = SweetAlert().showAlert("Blocked Seller", subTitle: "Do you want to unblock this Seller? ", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle: "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (status) -> Void in
    
    // Create OK button
//    let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
        if status == true {
            let unblockUserID = self.blockedUserArr[indexPath.row].userID
            print("useridbb.. \(unblockUserID) ")
            self.MainApis.Unblock_Api(user_ID: SessionManager.shared.userId , blockUserID: unblockUserID , completionHandler: { (status, swifymessage, error) in
                
                let status = swifymessage!["status"].bool
                print("status.. = \(String(describing: status))")
                
                if status == true{
                  self.blockedUserArr.remove(at: indexPath.row)
                    self.getBlockListItem()
                  self.tableView.reloadData()
                }else{
                    
                }
                
            })
        }
        else{
            print("Selected Button is No")
//            self.present(self, animated: true, completion:nil)
        }
        
    
            
//      self.dbRef.child("users").child(self.currentUserId!).child("blockedPersons").child(blockedPerson.userId!).removeValue()
//      self.dbRef.child("users").child(blockedPerson.userId!).child("blockedBy").child(self.currentUserId!).removeValue()
//        self.blockedUserArr.removeAll()
//        self.blockedUsersData()
//        if self.blockedUserArr.count <= 0 {
//            self.errorimg.isHidden = false
//            self.emptyMessage.isHidden = false
//             self.hideCollectionView(hideYesNo: true)
//            self.fidgetImageView.isHidden = true
//
//        }
       
        
      // Code in this block will trigger when OK button tapped.
      print("Ok button tapped");
      //self.blockedUsersData()
    }
//    alertController.addAction(OKAction)
//
//
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
//      print("Cancel button tapped")
//    }
//    alertController.addAction(cancelAction)
//
//    // Present Dialog message
//    self.present(alertController, animated: true, completion:nil)
    
    
  }
    //  change by Osama Mansoori
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if (UIDevice.current.userInterfaceIdiom == .phone){
         return 130
    }else {
        return 155
    }
  }
  
  
  
}


