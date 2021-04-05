//
//  profileViewController.swift
//  Sell4Bids
//
//  Created by admin on 9/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Cosmos

class profileViewController: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var userListingColView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var resetImageBtn: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userRatingControl: CosmosView!
    @IBOutlet weak var userRatingLbl: UILabel!
    
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var buyingActivitiesSwitch: UISwitch!
    @IBOutlet weak var sellingActivitiesSwitch: UISwitch!
    @IBOutlet weak var chatMessageSwitch: UISwitch!
    @IBOutlet weak var edBotSwitch: UISwitch!
    @IBOutlet weak var edBotLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userAddressLbl: UILabel!
    @IBOutlet weak var userActivitesTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var googleBtnView: UIView!
    @IBOutlet var selectImageView: UIView!
    @IBOutlet weak var takePhotoView: UIView!
    @IBOutlet weak var selectPhotoView: UIView!
    @IBOutlet var takePhotoBtn: UIButton!
    @IBOutlet var selectPhotoBtn: UIButton!
    @IBOutlet var shadowView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    
    //MARK:- Variable
    var ProfileDataArray = [UserDetailModel]()
    var sell4bidsInfoArray = [String]()
    var imagePickerController = UIImagePickerController()
    var MainApi = MainSell4BidsApi()
    var array : [String] = []
    var dummyCount = 10
    var temp:CGPoint!
    var selectedPage = 0
    var scrollingTimer : Timer?
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Views
        setupProfileViews()
        topMenu()
        //Networking
        showProfileData()
        sell4BidsInfo()
        getSellingItem()
        
        userListingColView.delegate = self
        userListingColView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.addSubview(selectImageView)
        selectImageView.center = self.view.center
        selectImageView.isHidden = true
    }
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Profile"
        titleview.backBtn.setImage(nil, for: .normal)
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.backBtn.setTitle("Done", for: .normal)
        titleview.backBtnWidth.constant = 60
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        
        self.navigationItem.hidesBackButton = true
    }
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
    }
    
    //MARK:-  Private Functions
    func UpdateProfile(user: [String:Any] ,Url: String){
        loginService.instance.postApiCall(URL: Url, param: user) { (success) in
            if success{
                let status = loginService.instance.status
                if status == 200 || status == 201 || status == 202{
                    print("Success = 200")
                }
                else{
                    print("Error")
                }
            }
            else{
                let status = loginService.instance.status
                print(status)
            }
        }
        
    }
    
    
    func uploadImage(profileImage:UIImage){
        MainApi.UserImageUpload_Api(country_code: "USA", uid: SessionManager.shared.userId, image: profileImage) { (status, data, error) in
            print("Data =",data as Any)
            var Message = ""
            if status {
                guard let Dict = data?.dictionary else {return}
                Message = Dict["message"]?.string ?? ""
                let ImageUrl = Dict["imageUrl"]?.string ?? ""
                SessionManager.shared.image = ImageUrl
                print(Message)
            }
        }
    }
    private func setupProfileViews() {
        
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.masksToBounds = false
        profileImageView.makeRound()
        profileImageView.clipsToBounds = true
        
        resetImageBtn.layer.borderColor = UIColor.black.cgColor
        resetImageBtn.layer.borderWidth = 2
        resetImageBtn.makeRound()
        
        self.tabBarController?.tabBar.isHidden = true
        
        takePhotoView.shadowView()
        selectImageView.shadowView()
        selectImageView.layer.cornerRadius = 10
        selectImageView.layer.borderWidth = 1.0
        selectImageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        selectPhotoView.shadowView()
        
        //Delegate
        imagePickerController.delegate = self
        userActivitesTableView.delegate = self
        userActivitesTableView.dataSource = self
        
        
        // perform Actions
        resetImageBtn.addTarget(self, action: #selector(resetImageBtnTapped(sender:)), for: .touchUpInside)
        takePhotoBtn.addTarget(self, action: #selector(takePhotoBtnTapped(sender:)), for: .touchUpInside)
        selectPhotoBtn.addTarget(self, action: #selector(selectImageBtnTapped(sender:)), for: .touchUpInside)
        edBotSwitch.addTarget(self, action: #selector(edbotSwitchTapped(sender:)), for: .valueChanged)
        buyingActivitiesSwitch.addTarget(self, action: #selector(BuyingActivitesSwitchTapped(sender:)), for: .valueChanged)
        sellingActivitiesSwitch.addTarget(self, action: #selector(SellingActivitesSwitchTapped(sender:)), for: .valueChanged)
        chatMessageSwitch.addTarget(self, action: #selector(ChatMessageSwitchTapped(sender:)), for: .valueChanged)
        
        //Ed Bot Functionality
        let edBot = UserDefaults.standard.bool(forKey: SessionManager.shared.edBot)
        
        if edBot == true {
            edBotSwitch.isOn = true
            edBotLbl.text = "Enable"
        }else {
            edBotSwitch.isOn = false
            edBotLbl.text = "Disable"
        }
        
        //Profile Image Tapped
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(ProfileimageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapOnImage)
        
    }
    
    private func setupTableViewModel() {
        let watching = "Watching 0"
        let followers = "Followers 0 "
        let followings = "Followings 0 "
        let totalListing = "Total Listings 0 "
        let buying = "Buying 0 "
        let bids = "Bids 0 "
        let bought = "Bought 0 "
        let win = "Wins 0 "
        let unreadMessages = "Unread Message 0 "
        let unreadNotification = "Unread Notifcations 0 "
        sell4bidsInfoArray = [watching, followers,followings,totalListing,buying,bids,bought,win,unreadMessages,unreadNotification]
        self.tableViewHeight.constant = 400
        self.userActivitesTableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with:event)
        let touch = touches.first
        if touch?.view == shadowView {
            shadowView.isHidden = true
            selectImageView.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func sell4BidsInfo() {
        MainApi.UserActivityDetails(uid: SessionManager.shared.userId) { (status, data, error) in
            print("Status =", status)
            print("Data =", data as Any)
            print("Error =",error)
            if status {
                let datanewunreadNotification = data!["unreadNotification"].int ?? 0
                let winscount = data!["winsCount"].int ?? 0
                let totalItemCount = data!["totalItemCount"].int ?? 0
                let message = data!["message"].int ?? 0
                let watchingCount = data!["watchingCount"].int ?? 0
                let boughtCount = data!["boughtCount"].int ?? 0
                let bidsCount = data!["bidsCount"].int ?? 0
                let buyingCount = data!["buyingCount"].int ?? 0
                let followingCount = data!["followingCount"].int ?? 0
                let followerCount = data!["followerCount"].int ?? 0
                
                let UserActivitydata = UserActivity.init(unreadNotifications: datanewunreadNotification, winsCount: winscount, totalItemCount: totalItemCount, message: message, watchingCount: watchingCount, boughtCount: boughtCount, bidsCount: bidsCount, buyingCount: buyingCount, followingCount: followingCount, followerCount: followerCount)
                
                let watching = "Watching \(UserActivitydata.watchingCount)"
                let followers = "Followers \(UserActivitydata.followerCount)"
                let followings = "Followings \(UserActivitydata.followingCount)"
                let totalListing = "Total Listings \(UserActivitydata.totalItemCount)"
                let buying = "Buying \(UserActivitydata.buyingCount)"
                let bids = "Bids \(UserActivitydata.bidsCount)"
                let bought = "Bought \(UserActivitydata.boughtCount)"
                let win = "Wins \(UserActivitydata.winsCount)"
                let unreadMessages = "Unread Message \(UserActivitydata.message)"
                let unreadNotification = "Unread Notifcations \(UserActivitydata.unreadNotifications)"
                self.sell4bidsInfoArray = [watching, followers,followings,totalListing,buying,bids,bought,win,unreadMessages,unreadNotification]
                self.tableViewHeight.constant = 400
                self.userActivitesTableView.reloadData()
                
            }else {
                self.setupTableViewModel()
            }
        }
    }
    
    private func showProfileData() {
        MainApi.Get_User_Detail(uid: SessionManager.shared.userId) { (status, data, error) in
            
            if status {
                let message = data!["message"]
                let zipCode = message["zipCode"].stringValue
                let id = message["_id"].stringValue
                let latitude = message["latitude"].doubleValue
                let longitude = message["longitude"].doubleValue
                let unreadCount = message["unreadCount"].intValue
                let state = message["state"].stringValue
                let uid = message["uid"].stringValue
                let totalratings = message["totalratings"].doubleValue
                let name = message["name"].stringValue
                let country = message["country"].stringValue
                let fcmToken = message["fcmToken"].stringValue
                let averagerating = message["averagerating"].doubleValue
                let unreadNotifications = message["unreadNotifcations"].intValue
                let startTime = message["startTime"].int64Value
                let newNotifications = message["newNotifications"].intValue
                let token = message["token"].stringValue
                let city = message["city"].stringValue
                let followersCount = message["followersCount"].intValue
                let configs = message["configs"]
                let buyingActivities = configs["buyingActivities"].boolValue
                let chatActivities = configs["charActivities"].boolValue
                let sellingActivities = configs["sellingActivities"].boolValue
                let email = message["email"].stringValue
                let image = message["image"].stringValue
                
                let data = UserDetailModel.init(email: email, unreadNotifications: unreadNotifications, fcmToken: fcmToken, averagerating: averagerating, unreadCount: unreadCount, country: country, buyingActivities: buyingActivities, sellingActivities: sellingActivities, chatActivities: chatActivities, uid: uid, followersCount: followersCount, latitude: latitude, longitude: longitude, zipCode: zipCode, name: name, newNotifications: newNotifications, city: city, state: state, startTime: startTime, followingCount: followersCount, totalratings: totalratings, id: id, token: token, image: image)
                print(data.country)
                self.ProfileDataArray.append(data)
                
                self.userNameLbl.text = data.name
                self.titleview.titleLbl.text = data.name
                print("Image",data.image)
                self.profileImageView.sd_setImage(with: URL(string: data.image), placeholderImage: #imageLiteral(resourceName: "Profile-image-for-sell4bids-App-1"))
                self.userRatingLbl.text = "(Ratings: \(data.totalratings))"
                
                self.userRatingControl.rating = data.averagerating
                self.userEmailLbl.text = data.email
                let address = "\(data.city), \(data.state) \(data.zipCode) \(data.country)"
                self.userAddressLbl.text = address
                self.buyingActivitiesSwitch.isOn = data.buyingActivities
                self.sellingActivitiesSwitch.isOn = data.sellingActivities
                self.chatMessageSwitch.isOn = data.chatActivities
            }
            
        }
    }
    
    private func getSellingItem(){
        MainApi.Selling_Api(user_ID: SessionManager.shared.userId, country: "USA", start: "\(0)", limit: "100" ,type : "owner", completionHandler: { (status, swifymessage, error) in
            let totalcount = swifymessage!["totalCount"].intValue
            if status {
                print("userid.. = \(SessionManager.shared.userId)")
                let message = swifymessage!["message"].stringValue
                print("message1 = \(message)")
                if totalcount > 0 {
                    let message = swifymessage!["message"]
                    for msg in message {
                        let itemCategory = msg.1["itemCategory"].stringValue
                        if itemCategory.contains("Services") {
                            let image_0 = msg.1["old_small_images"]
                            for image in image_0 {
                                self.array.append(image.1.stringValue)
                            }
                        }else if itemCategory.contains("Jobs") {
                            let images_small_path = msg.1["old_small_images"]
                            for Images in  images_small_path{
                                self.array.append(Images.1.stringValue)
                            }
                        }else if itemCategory.contains("Vehicles") {
                            let image = msg.1["old_small_images"]
                            for img in image {
                                self.array.append(img.1.stringValue)
                            }
                        } else {
                            let images_small_path = msg.1["old_small_images"]
                            for Images in  images_small_path{
                                self.array.append(Images.1.stringValue)
                            }
                        }
                        print("Image Array =",self.array)
                        self.userListingColView.reloadData()
                        let pages = self.array.count
                        self.pageControl.numberOfPages = pages
                        self.startTimer()
                    }
                }else {
                    print("Total Count =", totalcount)
                }
            }else {
                print("Status =", status)
            }
        })
    }
    
    
    //MARK:- Actions
    @objc func resetImageBtnTapped(sender: UIButton) {
        print("Reset Image Tapped")
        self.shadowView.isHidden = false
        self.selectImageView.isHidden = false
    }
    
    @objc func takePhotoBtnTapped(sender: UIButton){
        print("Take Photo Button Tapped")
        self.shadowView.isHidden = true
        self.selectImageView.isHidden = true
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .camera
        // Make sure ViewController is notified when the user picks an image.
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func selectImageBtnTapped(sender: UIButton) {
        print("Select Image Button Tapped")
        self.shadowView.isHidden = true
        self.selectImageView.isHidden = true
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func edbotSwitchTapped(sender: UISwitch){
       
        
        if sender.isOn == true {
           let alert = UIAlertController(title: "EdBot", message: "Do you want to enable edBot?", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok".localizableString(loc: LanguageChangeCode), style: .default, handler: { action in
            self.edBotSwitch.isOn = true
                       UserDefaults.standard.set(true, forKey: SessionManager.shared.edBot)
                       print("Ed Bot Status =",UserDefaults.standard.bool(forKey: SessionManager.shared.edBot))
            self.edBotLbl.text = "Enable"
           }))
           self.present(alert, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: "EdBot", message: "Do you want to disable edBot?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localizableString(loc: LanguageChangeCode), style: .default, handler: { action in
                self.edBotSwitch.isOn = false
             UserDefaults.standard.set(false, forKey: SessionManager.shared.edBot)
             print("Ed Bot Status =",UserDefaults.standard.bool(forKey: SessionManager.shared.edBot))
                self.edBotLbl.text = "Disable"
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @objc func SellingActivitesSwitchTapped(sender: UISwitch) {
        let Status = buyingActivitiesSwitch.isOn
        let url = "\(MainApi.IP)/users/setSellingActivities"
        let body:[String: Any] = ["sellingActivities":Status]
        self.UpdateProfile(user: body, Url: url)
    }
    
    @objc func BuyingActivitesSwitchTapped(sender: UISwitch) {
        let Status = buyingActivitiesSwitch.isOn
        let url = "\(MainApi.IP)/users/setBuyingActivities"
        let body:[String: Any] = ["buyingActivities":Status]
        self.UpdateProfile(user: body, Url: url)
    }
    @objc func ChatMessageSwitchTapped(sender: UISwitch) {
        let Status = buyingActivitiesSwitch.isOn
        let url = "\(MainApi.IP)/users/setChatActivities"
        let body:[String: Any] = ["chatMessages":Status]
        self.UpdateProfile(user: body, Url: url)
    }
    
    @objc func ProfileimageTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageView") as! ImageView
        vc.image = ProfileDataArray[0].image
        vc.userName = ProfileDataArray[0].name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK:- Table View Stubs
extension profileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sell4bidsInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userActivitesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sell4bidsInfoArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}
//TODO: UIImagePickerControllerDelegate
extension profileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        profileImageView.image = selectedImage
        self.uploadImage(profileImage: selectedImage)
        dismiss(animated: true, completion: nil)
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension profileViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count * dummyCount
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userListingColView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! profileCollectionViewCell
        let imageIndex = indexPath.item % self.array.count
        var image = String()
        image = self.array[imageIndex]
        cell.userImage.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "Profile-image-for-sell4bids-App-1"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return userListingColView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == self.userListingColView) {
            if temp == nil{
                return
            }
            else {
                self.centerIfNeeded(animationTypeAuto: false, offSetBegin: temp!)
                self.startTimer()
            }
        }
    }
    
    
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        DispatchQueue.main.async() {
            self.stopTimer()
            self.userListingColView.reloadData()
            self.userListingColView.setContentOffset( CGPoint.zero, animated: true)
            self.startTimer()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView == self.userListingColView) {
            stopTimer()
        }
    }
    
    
    
    // start animating the slider
    
    func startTimer() {
        if self.array.count > 1 && scrollingTimer == nil {
            let timeInterval = 3.0
            scrollingTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.rotate), userInfo: nil, repeats: true)
            scrollingTimer!.fireDate = Date().addingTimeInterval(timeInterval)
        }
    }
    
    
    
    func stopTimer() {
        scrollingTimer?.invalidate()
        scrollingTimer = nil
    }
    
    
    
    @objc func rotate() {
        let offset = CGPoint(x:self.userListingColView.contentOffset.x + cellWidth, y: self.userListingColView.contentOffset.y)
        var animated = true
        if (offset.equalTo(CGPoint.zero) || offset.equalTo(CGPoint(x: totalContentWidth, y: offset.y))){
            animated = false
        }
        self.userListingColView.setContentOffset(offset, animated: animated)
    }
    
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if (scrollView == self.userListingColView) {
            self.centerIfNeeded(animationTypeAuto: true, offSetBegin: CGPoint.zero)
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == self.userListingColView){
            if(scrollView.panGestureRecognizer.state == .began){
                stopTimer()
            }
            else if( scrollView.panGestureRecognizer.state == .possible){
                startTimer()
            }
        }
    }
    
    
    func centerIfNeeded(animationTypeAuto:Bool, offSetBegin:CGPoint) {
        let currentOffset = self.userListingColView.contentOffset
        let contentWidth = self.totalContentWidth
        let width = contentWidth / CGFloat(dummyCount)
        if currentOffset.x < 0{
            self.userListingColView.contentOffset = CGPoint(x: width - currentOffset.x, y: currentOffset.y)
        } else if (currentOffset.x + cellWidth) >= contentWidth {
            let  point = CGPoint.zero
            var tempCGPoint = point
            tempCGPoint.x = tempCGPoint.x + cellWidth
            print("center if need set offset to \( tempCGPoint)")
            self.userListingColView.contentOffset = point
        }
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if (scrollView == self.userListingColView)
        {
            self.temp = scrollView.contentOffset
            self.stopTimer()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(collectionView == self.userListingColView){
            var page:Int =  Int(collectionView.contentOffset.x / collectionView.frame.size.width)
            page = page % self.array.count
            pageControl.currentPage = Int (page)
        }
    }
    
    func updatePageControl(){
        var updatedPage = selectedPage + 1
        let totalItems = self.array.count
        updatedPage = updatedPage % totalItems
        print("updatedPage: \(updatedPage)")
        selectedPage  = updatedPage
        self.pageControl.currentPage = updatedPage    }
    
    var totalContentWidth: CGFloat {
        return CGFloat(self.array.count * dummyCount) * cellWidth
    }
    
    var cellWidth: CGFloat {
        return self.userListingColView.frame.width
    }
}
