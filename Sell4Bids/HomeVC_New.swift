  
  //
  //  ViewController.swift
  //  Sell4Bids
  //
  //  Created by admin on 8/25/17.
  //  Copyright © 2017 admin. All rights reserved.
  //
  
  import UIKit
  import Firebase
  import FirebaseDatabase
  import FirebaseStorage
  import SDWebImage
  import ViewAnimator
  import AVFoundation
  import Alamofire
  import SwiftyJSON
  import NotificationCenter
  import CoreLocation
  import AVFoundation
  import UserNotifications
  
  
  
  var isfilterclicked : Bool = false
  var stateName  = ""
  var endkey : String?
  var endAt : String?
  var zipCode = ""
  var city = ""
  var gpscountry = ""
  var lat = String()
  var long = String()
  var SellingProduct : sellingModel?
  var selectedProduct : ProductDetails?
  var willAppear: Bool = false
  var alertActionBarSellNow = UIAlertController()
  var sell_items = UIAlertAction()
  var custom_Sell_Now_ActionBar = UIView()
  var logindetail : LoginModel?
  let AP_APP_RATING_SHOWN = "com.brainplow.app_rating_shown"
  
  
  

  //variable is use for pagination on 11/22/2018
  var fetchingMethod = "zipcode"
  func getlocation () {
    let home = HomeVC_New()
    home.getCurrenState { (Complete,city, state, zip , latitude , longitude) in
        if Complete {
            print("check1 \(Complete), \(city!), \(state!), \(zip!) ,\(latitude!) ,\(longitude!)")
        }else {
            
        }
    }
  }
  
  class HomeVC_New:  UIViewController, UITabBarControllerDelegate,CLLocationManagerDelegate,UIPopoverPresentationControllerDelegate,UISearchBarDelegate,UNUserNotificationCenterDelegate , UITabBarDelegate {
    
    
    
    var arrayTableSections = [tableSection]()
    
    struct tableSection {
        let name : String
        var items : [tableItem]
    }
    struct tableItem {
        var name : String
        let image : UIImage
    }
    
    
//    func loadArrayTableSectionsWithData() {
//        let itemHome : tableItem = tableItem.init(name: "Home".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "Home")!)
//        let itemSell : tableItem = tableItem.init(name: "Sell Now".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "Sell now")!)
//        let itemCat : tableItem = tableItem.init(name: "Browse Categories".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "categories_top")!)
//        //      let itemFilters : tableItem = tableItem.init(name: "Search Products", image: #imageLiteral(resourceName: "filterColor"))
//        let itemMy : tableItem = tableItem.init(name: "My Sell4Bids".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "My Sell4Bids")!)
//        let itemJobs : tableItem = tableItem.init(name: "Jobs".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "Jobs")!)
//        let itemChat : tableItem = tableItem.init(name: "My Chat".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "chat")!)
//        let itemWatchList : tableItem = tableItem.init(name: "My Watch List".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "My view list")!)
//        let itemProfile : tableItem = tableItem.init(name: "My Profile".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "My Profile")!)
//        let itemNotification : tableItem = tableItem.init(name: "Notifications".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "Notification")!)
//        
//        let itemsOfFirstSection :[tableItem] = [itemHome, itemSell, itemCat, itemMy, itemJobs, itemChat, itemWatchList, itemProfile, itemNotification]
//        let sectionHome = tableSection.init(name: "Sell4Bids", items: itemsOfFirstSection)
//        arrayTableSections.append(sectionHome)
//        
//        let itemWhatIs : tableItem = tableItem(name: "What is Sell4Bids?".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "My Sell4Bids")!)
//        let itemHowWorks : tableItem = tableItem(name: "How it Works?".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "How it works")!)
//        let itemEstablishContact : tableItem = tableItem(name: "Establish Contact".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "Establish contact")!)
//        
//        let itemsOfAboutSell4Bids : [tableItem] = [itemWhatIs, itemHowWorks, itemEstablishContact]
//        let sectionAbout = tableSection.init(name: "About Sell4Bids".localizableString(loc: LanguageChangeCode), items: itemsOfAboutSell4Bids)
//        arrayTableSections.append(sectionAbout)
//        
//        let itemTerms = tableItem(name: "Terms and conditions".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "terms and condition")!  )
//        let itemPolicy = tableItem(name: "Privacy Policy".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "privacy policy")!)
//        let itemsOfLegal = [itemTerms, itemPolicy ]
//        
//        let sectionLegal = tableSection.init(name: "Legal".localizableString(loc: LanguageChangeCode), items: itemsOfLegal)
//        arrayTableSections.append(sectionLegal)
//        
//        let itemRateUs = tableItem(name: "Rate Us".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "Rate us")!)
//        //let itemFeedback = tableItem(name: "Give Feedback", image: #imageLiteral(resourceName: "drawer_feedback"))
//        let itemShare = tableItem(name: "Share this App".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "Share")!)
//        let itemLogOut = tableItem(name: "Logout".localizableString(loc: LanguageChangeCode), image:  UIImage(named: "log out")!)
//        let itemsOfSettingsAndFeedBack = [itemRateUs, itemShare, itemLogOut ]
//        
//        let sectionSettings = tableSection.init(name: "FeedBack".localizableString(loc: LanguageChangeCode), items: itemsOfSettingsAndFeedBack)
//        
//        arrayTableSections.append(sectionSettings)
//        
//    }
    
    
    
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if tabBarController.selectedIndex == 2{
            tabBarController.selectedIndex = 0
            alertActionBarSellNow = UIAlertController(title:"", message: "Select Sell Now Option", preferredStyle: .actionSheet)
            
            
            
            //item Sell Now Gesture
            let Items_Gesture = UITapGestureRecognizer(target: self, action: #selector(Item_Select_Sell_Now))
            
            //Job Sell Now Gesture
            let Job_Gesture = UITapGestureRecognizer(target: self, action: #selector(Job_Select_Sell_Now))
            
            
            //Vehicles Sell Now Gesture
            let Vehicles_Gesture = UITapGestureRecognizer(target: self, action: #selector(Vehicles_Select_Sell_Now))
            
            //Services Sell Now Gesture
            let Services_Gesture = UITapGestureRecognizer(target: self, action: #selector(Services_Select_Sell_Now))
            
            //Services Sell Now Gesture
            let Housing_Gesture = UITapGestureRecognizer(target: self, action: #selector(Housing_Select_Sell_Now))
            
            //Changes by OsamaMansoori(12-04-2019)
            //item Sell Now Details
            
            customview.OthersItemsLbl.isUserInteractionEnabled = true
            customview.OthersItemsLbl.addGestureRecognizer(Items_Gesture)
            
            //Job Sell Now Details
            
            customview.JobsLbl.isUserInteractionEnabled = true
            customview.JobsLbl.addGestureRecognizer(Job_Gesture)
            
            //Vehicles Sell Now Details
            
            customview.VehiclesLbl.isUserInteractionEnabled = true
            customview.VehiclesLbl.addGestureRecognizer(Vehicles_Gesture)
            
            
            //Services Sell Now Details
            
            customview.isUserInteractionEnabled = true
            
            customview.ServiceLbl.isUserInteractionEnabled = true
            customview.ServiceLbl.addGestureRecognizer(Services_Gesture)
            
            //Housing Sell Now Details
            
            customview.HousingLbl.isUserInteractionEnabled = true
            customview.HousingLbl.addGestureRecognizer(Housing_Gesture)
            
            customview.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: 200)
            
            
            alertActionBarSellNow.view.addSubview(customview)
            
            
            
            alertActionBarSellNow.view.frame = CGRect(x: 0, y: 0,width :  UIScreen.main.bounds.width, height: 100)
            alertActionBarSellNow.popoverPresentationController?.sourceView = self.view
            alertActionBarSellNow.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.minX, y: self.view.bounds.maxY, width: UIScreen.main.bounds.width, height: 0)
            
            self.present(alertActionBarSellNow, animated: true) {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
                alertActionBarSellNow.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            }
            
        }
    }
    
    
    
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var HeaderHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var DimView: UIView!

    var notificationCenter  = UNUserNotificationCenter.current()
    
    let customview = Bundle.main.loadNibNamed("CustomSellNowActionBar", owner: self, options: nil)?.first as! CustomSellNowActionBar
    
    
    var searchtext = String()
    var searchBoolen = Bool()
    var searchProductArray = [Products]()
    func getSearchData(search : String){
        
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    //MARK: - Properties
    var visibleIndexPath =  IndexPath()
    var searchSuggestion = [Suggestionlist]()
    var ApiCalled : Bool = false
    @IBOutlet weak var SellUStuff: UIButton!
    var MainApis = MainSell4BidsApi()
    var selected : ProductDetails?
    
    lazy var drawerArray = [[drawerModel]]()
    lazy var drawerSection = ["", "Sell4Bids Special", "About Sell4Bids", "Legal", "Others"]
    lazy var responseStatus = false
    
    @objc func ProfileimageTapped(){
        let myProfileSB = getStoryBoardByName(storyBoardNames.myProfileSB)
        
        if let controller = myProfileSB.instantiateViewController(withIdentifier: "UserProfileDetailVc") as? UserProfileDetail {
            let tbc = revealViewController().frontViewController as? UITabBarController
            let nav = UINavigationController.init(rootViewController: controller)
            tbc?.present(nav, animated: true, completion: nil)
            self.revealViewController().setFrontViewPosition(.left, animated: true)
        }
    }
    
    private func setupViewsForPizzaMenu() {
        profileImg.sd_setImage(with:URL(string: SessionManager.shared.image) , placeholderImage: #imageLiteral(resourceName: "Profile-image-for-sell4bids-App"), options: [.refreshCached], completed: nil)
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(ProfileimageTapped))
        profileImg!.isUserInteractionEnabled = true
        profileImg!.addGestureRecognizer(tapOnImage)
        userNameLbl.text = SessionManager.shared.name
        if SessionManager.shared.email == "" {
            userEmailLbl.text = "www.sell4bids.com"
        }else {
            userEmailLbl.text = SessionManager.shared.email
        }
        
    }
    
    
    
    private func setupDrawer() {
        
        // For Section 0
        let home = drawerModel.init(name: "Home", image: UIImage(named: "Home"))
        let sellNow = drawerModel.init(name: "Sell Now", image: UIImage(named: "Sell now"))
        let category = drawerModel.init(name: "Browse Categories", image: UIImage(named: "categories_top"))
        let filter = drawerModel.init(name: "Search Filters", image: UIImage(named: "Filter"))
        let MySell4bids = drawerModel.init(name: "My Sell4Bids", image: UIImage(named: "My Sell4Bids"))
        let jobs = drawerModel.init(name: "Jobs", image: UIImage(named: "Jobs@32px"))
        let chat = drawerModel.init(name: "My Chat", image: UIImage(named: "chat"))
        let profile = drawerModel.init(name: "My Profile ", image: UIImage(named: "My Profile"))
        let recommendation = drawerModel.init(name: "Recommendations", image: UIImage(named: "Recomendation"))
        let notifications = drawerModel.init(name: "Notifications", image: UIImage(named: "Notification"))
        
        //For Section 1
        
        let Selling = drawerModel.init(name: "Selling", image: UIImage(named: "Sell now"))
        let MyWatchlist = drawerModel.init(name: "My Watch List", image: UIImage(named: "ic_unwatch"))
        let Buying = drawerModel.init(name: "Buying", image: UIImage(named: "Bought & bids"))
        let Bought = drawerModel.init(name: "bought", image: UIImage(named: "Bought & wins"))
        let Bids = drawerModel.init(name: "Bids", image: UIImage(named: "Bid or Buy"))
        let Wins = drawerModel.init(name: "Wins", image: UIImage(named: "win"))
        let Followers = drawerModel.init(name: "Followers", image: UIImage(named: "Followers"))
        let Followings = drawerModel.init(name: "Followings", image: UIImage(named: "Following"))
        let BlockList = drawerModel.init(name: "Block List", image: UIImage(named: "Block list"))
        
        // for section 2
        let What = drawerModel.init(name: "What is Sell4Bids?", image: UIImage(named: "My Sell4Bids"))
        let How = drawerModel.init(name: "How It Works?", image: UIImage(named: "How it works"))
        let Contact = drawerModel.init(name: "Establish Contact", image: UIImage(named: "Establish contact"))
        
        
        // for section 3
        let Term = drawerModel.init(name: "Term of Use", image: UIImage(named: "terms and condition"))
        let Privacy = drawerModel.init(name: "Privacy Policy", image: UIImage(named: "privacy policy"))
        let FAQ = drawerModel.init(name: "FAQs", image: UIImage(named: "FAQ"))
        
        //for section 4
        let rate = drawerModel.init(name: "Rate Us", image: UIImage(named: "Rate us"))
        let share = drawerModel.init(name: "Share", image: UIImage(named: "Share"))
        let logout = drawerModel.init(name: "Logout", image: UIImage(named: "log out"))
        let empty = drawerModel.init(name: "", image: UIImage(named: ""))
        
        drawerArray = [[home,sellNow,category,filter,MySell4bids,jobs,chat,profile,recommendation,notifications],[Selling,MyWatchlist,Buying,Bought,Bids,Wins,Followers,Followings,BlockList],[What,How,Contact],[Term, Privacy,FAQ],[rate,share,logout,empty]]
        
    }
    
    
    
    
    @objc func Item_Select_Sell_Now() {
        dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard.init(name: "ItemsSell", bundle: nil)
        let ItemListing = storyboard.instantiateViewController(withIdentifier: "MainItemListing")
        self.navigationController?.pushViewController(ItemListing, animated: true)
        
    }
    
    @objc func Job_Select_Sell_Now() {
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard.init(name: "JobListing", bundle: nil)
        let JobListing = storyboard.instantiateViewController(withIdentifier: "JobListingMain")
        self.navigationController?.pushViewController(JobListing, animated: true)
    }
    
    @objc func Vehicles_Select_Sell_Now() {
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard.init(name: "VehiclesSell", bundle: nil)
        let ItemListing = storyboard.instantiateViewController(withIdentifier: "MainVehicleListing")
        self.navigationController?.pushViewController(ItemListing, animated: true)
    }
    
    @objc func Services_Select_Sell_Now() {
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard.init(name: "ServiceListingVC", bundle: nil)
        let ServiceListing = storyboard.instantiateViewController(withIdentifier: "ServiceListingStepMainIdentifier")
        self.navigationController?.pushViewController(ServiceListing, animated: true)
    }
    
    @objc func Housing_Select_Sell_Now() {
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard.init(name: "HousingListing", bundle: nil)
        let HousingListing = storyboard.instantiateViewController(withIdentifier: "Hosing_Listing_Main")
        self.navigationController?.pushViewController(HousingListing, animated: true)
    }
    
    @objc func ClosebtnSellNow() {
        alertActionBarSellNow.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func movetoSell(_ sender: Any) {
        alertActionBarSellNow = UIAlertController(title: "", message: "Select Sell Now Option", preferredStyle: .actionSheet)
        
        
        
        //item Sell Now Gesture
        let Items_Gesture = UITapGestureRecognizer(target: self, action: #selector(Item_Select_Sell_Now))
        
        //Job Sell Now Gesture
        let Job_Gesture = UITapGestureRecognizer(target: self, action: #selector(Job_Select_Sell_Now))
        
        
        //Vehicles Sell Now Gesture
        let Vehicles_Gesture = UITapGestureRecognizer(target: self, action: #selector(Vehicles_Select_Sell_Now))
        
        //Services Sell Now Gesture
        let Services_Gesture = UITapGestureRecognizer(target: self, action: #selector(Services_Select_Sell_Now))
        
        //Housing Sell Now Gesture
        let Housing_Gesture = UITapGestureRecognizer(target: self, action: #selector(Housing_Select_Sell_Now))
        
        //Changes by OsamaMansoori(12-04-2019)
        //item Sell Now Details
        
        customview.OthersItemsLbl.isUserInteractionEnabled = true
        customview.OthersItemsLbl.addGestureRecognizer(Items_Gesture)
        
        //Job Sell Now Details
        
        customview.JobsLbl.isUserInteractionEnabled = true
        customview.JobsLbl.addGestureRecognizer(Job_Gesture)
        
        //Vehicles Sell Now Details
        
        customview.VehiclesLbl.isUserInteractionEnabled = true
        customview.VehiclesLbl.addGestureRecognizer(Vehicles_Gesture)
        
        
        //Services Sell Now Details
        
        customview.isUserInteractionEnabled = true
        
        customview.ServiceLbl.isUserInteractionEnabled = true
        customview.ServiceLbl.addGestureRecognizer(Services_Gesture)
        
        //Housing Sell Now Details
        
        customview.HousingLbl.isUserInteractionEnabled = true
        customview.HousingLbl.addGestureRecognizer(Housing_Gesture)
        
        customview.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: 200)
        
        alertActionBarSellNow.view.addSubview(customview)
        
        alertActionBarSellNow.view.frame = CGRect(x: 0, y: 0,width :  UIScreen.main.bounds.width, height: 100)
        alertActionBarSellNow.popoverPresentationController?.sourceView = self.view
        alertActionBarSellNow.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.minX, y: self.view.bounds.maxY, width: UIScreen.main.bounds.width, height: 0)
        
        self.present(alertActionBarSellNow, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alertActionBarSellNow.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
        
        
        //        tabBarController?.selectedIndex = 2
        //        tabBarController?.tabBar.isHidden = false
        //        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //        self.SellUStuff.isHidden = true
        
        
    }
    
    @IBAction func invitebtnshow(_ sender: Any) {
        let items =  ["shareString".localizableString(loc: LanguageChangeCode), urlAppStore] as [ Any ]
        let activityVC = UIActivityViewController(activityItems: items , applicationActivities: [])
        //activityVC.popoverPresentationController?.sourceView = sender
        if let popoverController = activityVC.popoverPresentationController{
            popoverController.barButtonItem = sender as? UIBarButtonItem
            popoverController.permittedArrowDirections = .down
        }
        
        self.present(activityVC, animated:true , completion: nil)
    }
    
    
    
    
    
    //function for loading item from zipcode , city and state 11/23/2018
    @IBOutlet weak var itemLoadingView: UIView!
    @IBOutlet weak var itemFidgetSpinner: UIImageView!
    @IBOutlet weak var itemLoadingDescrib: UILabel!
    var downloadeditems = false
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    @IBOutlet weak var emptyProductMessage: UILabel!
    @IBOutlet weak var fidgetImageView: UIImageView!
    
    @IBOutlet weak var colVProducts: UICollectionView!
    
    @IBOutlet weak var imgViewNetworkError: UIImageView!
    @IBOutlet weak var viewNoResults: UIView!
    
    @IBOutlet weak var btnTryAgainNoResults: UIButton!
    //MARK: - Variables
    var imagesUrlArray = [UIImage]()
    var databaseHandle:DatabaseHandle?
    var dbRef: DatabaseReference!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var mainNavigationController: UINavigationController?
    var productsArray = [Products]()
    var FilteredDataFromFilterVcArray:[Products]!
    var blockedUserIdArray = [String]()
    var flagIsFilterApplied = Bool()
    var productObj = ProductModel()
    let  downloader = SDWebImageDownloader(sessionConfiguration: URLSessionConfiguration.ephemeral)
    var CityName = ""
    var cityAndStateName:String?
    var setSearchResults : Set<ProductModel>!
    var isOpen = 0
    var endAtChargeTimes = [CategoryAndAuctionType:CLongLong]()
    var endAtChargeTime : CLongLong = -999
    private var jobsDataSource = [ProductModel]()
    private let downloadSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
    //MARK:- View Life Cycle
    var categoryToFilter = "All"
    var buyingOptionToFilter = "Any"
    var stateToFilter = "New York, NY"
    var currency = String()
    var priceMinFilter : Int?
    var priceMaxFilter: Int?
    var totalcount = Int()
    // @ AK 11-feb (parameters for filter)
    
    var countryF = String()
    var itemAuctionTypeF = String()
    var itemCategoryF = String()
    var conditionF = String()
    var cityF = String()
    var priceMinF = String()
    var priceMaxF = String()
    var filterLong = String()
    var filterLat = String()
    
    let searchbar = Bundle.main.loadNibNamed("SearchCustomView", owner: self, options: nil)?.first as! SearchCustomView
    
    @IBOutlet weak var drawerLeading: NSLayoutConstraint!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var drawerTableView: UITableView!
    
    
    @IBOutlet weak var searchBarTop: UISearchBar!
    var prevHeight :CGFloat = 0
    
    let searchbarview = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    
    @objc func Close_SearchBarView() {
        searchbarview.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func searchbtnaction() {
        let searchVCStoryBoard = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchVCStoryBoard.instantiateViewController(withIdentifier: "SearchVC")
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func filterbtnaction() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "FiltersVc") as? FiltersVc else {return}
        controller.selfWasPushed = true
        controller.cityAndStateName = city + " " + stateName
        stateToFilter = controller.stateToFilter
        controller.delegate = self
        
        if flagIsFilterApplied {
            controller.categoryToFilter = self.categoryToFilter
            controller.buyingOptionToFilter = self.buyingOptionToFilter
        }
        controller.stateToFilter = stateName
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func invitebtnaction(_ sender : AnyObject) {
        let items =  ["shareString".localizableString(loc: LanguageChangeCode), urlAppStore] as [ Any ]
        let activityVC = UIActivityViewController(activityItems: items , applicationActivities: [])
        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        if let popoverController = activityVC.popoverPresentationController{
            popoverController.barButtonItem = sender as? UIBarButtonItem
            popoverController.permittedArrowDirections = .up
        }
        self.present(activityVC, animated:true , completion: nil)
    }
    
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        self.colVProducts.alwaysBounceVertical = true
        refreshControl.tintColor = #colorLiteral(red: 0.8566855788, green: 0.1049235985, blue: 0.136507839, alpha: 1)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString.init(string: "Pull to refresh")
        return refreshControl
    }()
    
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    
    lazy var mikeImgForSpeechRec = UIImageView(frame: CGRect(x: 0, y: 0, width: 0,height: 0))
    
    var titleview = Bundle.main.loadNibNamed("NavigationBarMainView", owner: self, options: nil)?.first as! NavigationBarMainView
    
    
    //    override func viewLayoutMarginsDidChange() {
    //        navigationItem.titleView?.frame = CGRect(x: 2, y: 0, width: UIScreen.main.bounds.width, height: 40)
    //
    //
    //    }
    fileprivate func getAndDisplayNotificationCount() {
//
//                NetworkService.getNotificationCount{ [weak self ] (complete, unReadCount) in
//                    guard let this = self, let unRead = unReadCount else { return }
//
//                    let dict = ["unRead" : unRead]
//
//                    UIApplication.shared.applicationIconBadgeNumber = unReadCount!
//
//
//                    //update notifications count in main user node
//        //            updateNotCount(updatedCount: unRead, completion: { (success) in
//
//        //            })
//                    //update notifications tab badge number
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"updateTabBadgeNumber"), object: nil, userInfo: dict)
//
//
//                }
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
    let token :String = Messaging.messaging().fcmToken ?? ""
    
    
    func SetToken() {
        
        SessionManager.shared.fcmToken = token
        print("User id = \(SessionManager.shared.userId)")
        
        MainApis.Set_User_Token(uid: SessionManager.shared.userId, token: token ) { (status, data, error) in
            
            print("status == \(status)")
            print("data == \(String(describing: data))")
            print("error == \(error)")
            
            
            
        }
        
        
        
    }
    // OsamaMansoori (24-04-2019)
    
    @objc func HousingImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
        _ = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard.init(name: "HousingListing", bundle: nil)
        let HousingListing = storyboard.instantiateViewController(withIdentifier: "Hosing_Listing_Main")
        self.navigationController?.pushViewController(HousingListing, animated: true)
    }
    
    @objc func ServiceImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
        _ = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard.init(name: "ServiceListingVC", bundle: nil)
        let ServiceListing = storyboard.instantiateViewController(withIdentifier: "ServiceListingStepMainIdentifier")
        self.navigationController?.pushViewController(ServiceListing, animated: true)
    }
    
    
    @objc func VehiclesImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
        _ = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard.init(name: "VehiclesSell", bundle: nil)
        let ItemListing = storyboard.instantiateViewController(withIdentifier: "MainVehicleListing")
        self.navigationController?.pushViewController(ItemListing, animated: true)
    }
    
    
    @objc func jobImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
        _ = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard.init(name: "JobListing", bundle: nil)
        let JobListing = storyboard.instantiateViewController(withIdentifier: "JobListingMain")
        self.navigationController?.pushViewController(JobListing, animated: true)
    }
    
    
    @objc func othersItemsImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
        _ = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard.init(name: "ItemsSell", bundle: nil)
        let ItemListing = storyboard.instantiateViewController(withIdentifier: "MainItemListing")
        self.navigationController?.pushViewController(ItemListing, animated: true)
    }
    
    let SideMenuBar = Bundle.main.loadNibNamed("SideMenuBar", owner: self, options: nil)?.first as! SideMenuBar
    
    
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func Close_SideMenuBar() {
        SideMenuBar.removeFromSuperview()
        
    }
    
    lazy var orderArray = [orderModel]()
    lazy var offerArray = [offerModel]()
    
//    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
//        let objDateformat: DateFormatter = DateFormatter()
//        objDateformat.dateFormat = "yyyy-MM-dd"
//        let strTime: String = objDateformat.string(from: dateToConvert as Date)
//        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
//        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
//        let strTimeStamp: String = "\(milliseconds)"
//        return strTimeStamp
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let now = NSDate()
//        let nowTimeStamp = self.getCurrentTimeStampWOMiliseconds(dateToConvert: now)
//        print(nowTimeStamp)
        
        
//        yourCollectionView.prefetchDataSource = self
    
        swipe()
        setupViewsForPizzaMenu()
        setupDrawer()
        let imgViewUser = SideMenuBar.UserImage
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(ProfileimageTapped))
        imgViewUser!.isUserInteractionEnabled = true
        imgViewUser!.addGestureRecognizer(tapOnImage)
        SideMenuBar.frame = self.view.frame
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            print("called Home refresh")
            self.colVProducts.reloadUsingDispatch()
        }
        notificationCenter.delegate = self
        socket?.on("notifications") {data, ack in
            var message = String()
//            var itemid = String()
//            var dictonary:NSDictionary?
            let stringnewdata = data.last! as! NSDictionary
            let data = stringnewdata["notification"] as! NSDictionary
            _ = stringnewdata["data"] as! NSDictionary
            message = data["body"] as! String
            let title = data["title"] as! String
            let identifiernew = ""
//            itemid = datanoti["item_id"] as! String
//            item_id = datanoti["item_id"] as! String
//            print(itemid)
            let identifier = identifiernew
            let newdata = JSON(data)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let content = UNMutableNotificationContent()
            let noti = newdata["notification"]
            print(noti)
            content.title = title
            content.body = message
            content.sound = UNNotificationSound.default()
            content.badge = 1
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            self.notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
            print("Socket Ahmed == \(data)")
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
                let count = value["count"].intValue
                print(count)
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
                print(role)
                let seller_uid = value["seller_uid"].stringValue
                let sender = value["sender"].stringValue
                let sender_uid = value["sender_uid"].stringValue
                let created_at = value["created_at"].int64Value
                let receiver_uid = value["receiver_uid"].stringValue
                let delivered_time = value["delivered_time"].int64Value
                
                let chatdata = ChatListModel.init(buyer_uid_id: buyer_uid, item_id_buyer_uid: sender_uid, item_price: item_price, created_at: created_at, receiver_uid: receiver_uid, item_title: item_title, receiver: receiver, itemCategory: itemCategory, buyer_uid: buyer_uid, id: "", seller_uid: seller_uid, item_id: item_id, item_image: item_image, message: message, itemAuctionType: itemAuctionType, sender: sender, read: read, sender_uid: sender_uid, delivered_time: delivered_time)
                print("Chat data socket  == \(chatdata.buyer_uid) , Chat item socket ==\(chatdata.item_id)")
                self.notificationCenter.delegate = self
                let identifier = "\(delivered_time)"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let content = UNMutableNotificationContent()
                let fileUrl = URL(string: chatdata.item_image)
                if chatdata.item_image.isEmpty  {
                    let image  = UIImage(named: "emptyImage1")
                    let imageData: Data = UIImageJPEGRepresentation(image!, 1)!
                    guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "img.jpeg", data: imageData as NSData, options: nil) else { return  }
                    content.attachments = [attachment]
                    content.title = item_title
                    content.body = message
                    content.sound = UNNotificationSound.default()
                    content.badge = 1
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    self.notificationCenter.add(request) { (error) in
                        if let error = error {
                            print("Error \(error.localizedDescription)")
                        }
                    }
                    
                }else {
                    let imageData = NSData(contentsOf: fileUrl!)
                    guard let attachment = UNNotificationAttachment.create(imageFileIdentifier: "img.jpeg", data: imageData!, options: nil) else { return  }
                    
                    content.attachments = [attachment]
                    content.title = item_title
                    content.body = message
                    content.sound = UNNotificationSound.default()
                    content.badge = 1
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    self.notificationCenter.add(request) { (error) in
                        if let error = error {
                            print("Error \(error.localizedDescription)")
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        })
        socket?.connect()
        
        let othersItemTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(othersItemsImageTapped(tapGestureRecognizer:)))
        customview.Items_Image.isUserInteractionEnabled = true
        customview.Items_Image.addGestureRecognizer(othersItemTapGestureRecognizer)
        
        let jobImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(jobImageTapped(tapGestureRecognizer:)))
        customview.Job_Image.isUserInteractionEnabled = true
        customview.Job_Image.addGestureRecognizer(jobImageTapGestureRecognizer)
        
        let ServiceTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VehiclesImageTapped(tapGestureRecognizer:)))
        customview.Vehciles_Image.isUserInteractionEnabled = true
        customview.Vehciles_Image.addGestureRecognizer(ServiceTapGestureRecognizer)
        
        let VehiclesTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ServiceImageTapped(tapGestureRecognizer:)))
        customview.Services_Image.isUserInteractionEnabled = true
        customview.Services_Image.addGestureRecognizer(VehiclesTapGestureRecognizer)
        
        let HousingTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HousingImageTapped(tapGestureRecognizer:)))
        customview.Housing_Image.isUserInteractionEnabled = true
        customview.Housing_Image.addGestureRecognizer(HousingTapGestureRecognizer)
        
        self.SetToken()
        
        
        searchbar.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        
        let headerNib = UINib(nibName: "HeaderView", bundle: nil)
        
        colVProducts.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        // @ak
        getlocation()
        
        // Change By Osama Mansoori
        ForLanguageChange()
        
        
        
        if !InternetAvailability.isConnectedToNetwork() {
            itemFidgetSpinner.isHidden = true
        }
        else {
            fidget.toggleRotateAndDisplayView(fidgetView: fidgetImageView, downloadcompleted: downloadCompleted)
            fidget.toggleRotateAndDisplayItems(fidgetView: itemFidgetSpinner, downloadcompleted: downloadeditems)
            getCurrenState{ (complete,state,ci,zip,longitude,latitude)  in
                stateName = state!
                city = ci!
                zipCode = zip ??  " "
                self.fetchDisplayData()
                self.titleview.citystateZIpcode.text = "\(city), \(stateName) \(zipCode)"
                self.cityAndStateName = city + ",\(stateName)"
            }
        }
        
        StoreReviewHelper.checkAndAskForReview()
        getAndDisplayNotificationCount()
        
        
        fidget.toggleRotateAndDisplayView(fidgetView: fidgetImageView , downloadcompleted: downloadCompleted)
        tabBarController?.delegate = self
        
        
        print("titleview width = \(titleview.frame.width)")
        
        
        self.navigationItem.titleView = titleview
        titleview.searchBarButton.addTarget(self, action: #selector(searchbtnaction), for: .touchUpInside)
        titleview.filterbtn.addTarget(self, action: #selector(filterbtnaction), for: .touchUpInside)
        titleview.inviteBtn.addTarget(self, action:  #selector(self.inviteBarBtnTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchbtnaction))
        titleview.citystateZIpcode.isUserInteractionEnabled = true
        titleview.citystateZIpcode.addGestureRecognizer(tap)
        
        toggleDimBack(false)
        addDoneLeftBarBtn()
        
        
        setupViews()
        
        
        if productsArray.count > 1 {
            print("Applied......")
            
            print("productArray .....\(productsArray.count)")
        }
        
        getUserIDAndStoreFCMInUsersNode()
        
        dbRef = FirebaseDB.shared.dbRef
        
        downloadAndShowData()
        self.colVProducts.delegate = self
        self.colVProducts.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayUnReadNotifInTabBadge(_:)), name: NSNotification.Name("updateTabBadgeNumber"), object: nil)
    }
    
    // Change by Osama Mansoori 31-jan
    func ForLanguageChange(){
        SellUStuff.setTitle("SellorAuctionOffNowHVC".localizableString(loc: LanguageChangeCode), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MainApis.Notification_Count(User_Id: SessionManager.shared.userId) { (status, data, error) in
            print("status ==\(status)")
            print("data == \(String(describing: data))")
            print("error ==\(error)")
            if status {
                let message = data!["message"].intValue
                if message > 0 {
                    let Count : String = String(message)
                    self.tabBarController!.tabBar.items![4].badgeValue = Count
                }
            }
        }
        
        
        //      self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 50, height: 40)
        isfilterclicked = false
        
        
        
    }

    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        print("WillAppear ")
        //getAndDisplayNotificationCount()
        willAppear = animated
        print("viewwillDisappear\(flagIsFilterApplied)")
        //  self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 20, height: 33)
        
        if isOpen == 1 {
            self.revealViewController().revealToggle(animated: true)
            
        }
        if self.downloadCompleted {
            self.fidgetImageView.isHidden = true
        }
        toggleDimBack(false)
        
        
        DispatchQueue.main.async {
            
            self.view.endEditing(true)
            if self.downloadCompleted {
                self.reloadColView()
                self.fidgetImageView.isHidden = true
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with:event)
        let touch = touches.first
        if touch?.view == DimView {
            drawerLeading.constant = -280
            DimView.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.delegate = self
        
//        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)

        self.fidgetImageView.isHidden = true
        
//        if isMenuOpen {
//            openMenu()
//            isMenuOpen = false
//        }
        
        
        print("Filter Flag == \(FilterFlag)")
        
        
        if FilterFlag {
            if productsArray.count == 0 {
                getFilterData()
            }
            
            
        }
        
        
        
        print("statenamehome will appear = \(stateToFilter)")
        self.titleview.citystateZIpcode.text = "\(city), \(stateName) \(zipCode)"
        
        
        
        if isfilterclicked {
            
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "FiltersVc") as? FiltersVc else {return}
            controller.selfWasPushed = true
            controller.cityAndStateName = cityAndStateName ?? "New York, NY"
            controller.delegate = self
            
            
            controller.stateToFilter = stateName
            
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        
        fidget.toggleRotateAndDisplayView(fidgetView: fidgetImageView , downloadcompleted: downloadCompleted)
        self.SellUStuff.isHidden = true
        toggleDimBack(false)
        DispatchQueue.main.async {
            
            self.view.endEditing(true)
            if self.downloadCompleted {
                self.fidgetImageView.isHidden = true
            }
        }
    }
    
    func getFilterData(){
        
        print("here1 = \(FilterFlag)")
        // FilterFlag = false
        let start = productsArray.count
        
        
        print("Filter parameter = Country = \(countryF) , ItemAuctionTypeF = \(itemAuctionTypeF) , itemcategoryF = \(itemCategoryF) , ConditionF = \(conditionF) , city = \(cityF) , minprice = \(priceMinF) , Maxprice = \(priceMaxF), Latitude = \(filterLat) , Longitude = \(filterLong)")
        self.DimView.isHidden = false
        self.DimView.backgroundColor = .clear
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.isHidden = false
                self.fidgetImageView.loadGif(name: "red")
            }
        }
        MainApis.filter_Api(lat: filterLat,long:filterLong,country:countryF, itemAuctionType:itemAuctionTypeF, itemCategory: itemCategoryF, condition: conditionF, title: "", city: cityF, start: "\(start)",limit:"50", min_price: priceMinF, max_price: priceMaxF , completionHandler: { (status, swifymessage, error) in
            print("Called = Yes")
            self.toggleDimBack(false)
            let status = swifymessage!["status"].boolValue
            let message = swifymessage!["message"].arrayValue
            let totalcount = swifymessage!["totalCount"].intValue
            
            if totalcount == 0 && self.productsArray.count == 0  {
                self.emptyProductMessage.isHidden = false
            }else {
                self.emptyProductMessage.isHidden = true
            }
            // self.productsArray.removeAll()
            //self.reloadColView()
            if status  {
                self.responseStatus = true
                
                self.itemFidgetSpinner.isHidden = true
                self.itemLoadingDescrib.isHidden = true
                
                self.downloadCompleted = true
                self.toggleDimBack(false)
                self.fidgetImageView.isHidden = true
                fidget.stopfiget(fidgetView: (self.fidgetImageView)!)
                
                for items in message {
                    
                    let loc = items["loc"]
                    let total_count = items["total_count"].intValue
                    let quantity = items["quantity"].doubleValue
                    _ = loc["coordinates"].arrayValue
                    _ = loc["type"].stringValue
                    let itemid = items["_id"].stringValue
                    let title = items["title"].stringValue
                    let startPrice = items["startPrice"].doubleValue
                    let itemCategory = items["itemCategory"].stringValue
                    let zipcode = items["zipcode"].stringValue
                    let itemAuctionType = items["itemAuctionType"].stringValue
                    let currency_symbol = items["currency_symbol"].stringValue
                    _ = items["chargeTime"].stringValue
                    let uid = items["uid"].stringValue
                    _ = items["old_small_images"].arrayValue
                    let imageex_small = items["old_small_images"].arrayObject
                    let image1_small = items["old_images"].arrayObject
                    let image2_small = items["old_images"].arrayValue
                    _ = items["item"].stringValue
                    let item_start_time = items["startTime"].int64Value
                    let item_longtitude = loc[0].doubleValue
                    let item_latitude = loc[1].doubleValue
                    let item_condition = items["condition"].stringValue
                    let item_endtime = items["endTime"].int64Value
                    let item_city = items["city"].stringValue
                    let item_state = items["state"].stringValue
                    let currency_string = items["currency_string"].stringValue
                    let isListedEnded = items["listingEnded"].boolValue
                    var image0 = String()
                    
                    if image2_small.count > 0 {
                        image0 = (image2_small[0].stringValue)
                    }
                    print(image0)
                    print("Category ==\(itemCategory)")
                    
                    let products = Products.init(total_count: total_count, status: status, quantity: quantity, item_id: itemid, old_images: image1_small as! [String], item_title: title, item_category: itemCategory, item_zipcode: zipcode, item_latitude: item_latitude, item_longtitude: item_longtitude, item_seller_id: uid, item_start_time: item_start_time, old_small_images: imageex_small as! [String], item_auction_type: itemAuctionType, item_condition: item_condition, item_endTime: item_endtime, item_city: item_city, item_state: item_state, item_startPrice: startPrice , currency_symbol: currency_symbol , currency_string: currency_string, isListingEnded: isListedEnded)
                    
                    self.productsArray.append(products)
                    products.item_image.image =  #imageLiteral(resourceName: "emptyImage")
                    self.colVProducts.reloadUsingDispatch()
                    var imageUrlToUse : URL?
                    if products.old_images.count > 0 {
                        let urlStr = products.old_images[0]
                        let url = URL.init(string: urlStr)
                        imageUrlToUse = url
                    }

                    self.downloader.shouldDecompressImages = true
                    print("Image downloaded = \(String(describing: imageUrlToUse))")
                    self.downloader.downloadImage(with: imageUrlToUse, options: SDWebImageDownloaderOptions.lowPriority, progress: nil) {[weak self] (image_, data, error, success) in
                        guard self != nil else { return }
                        if success {
                            products.item_image.image = image_ ?? #imageLiteral(resourceName: "emptyImage")
                        }
                    }
                }
            }
        })
    }
    
    var downloadCompleted = false
    
    //MARK:- Private functions
    func getUserIDAndStoreFCMInUsersNode() {
        
        getLoggedInUserID { (id, status) in
            if status{
                writeTime(id: id)
                //get fcm token from firebase and store in users node in fcmToken Attribute
                
                //going to store fcm token from firebase in users node to receive push notifications
                InstanceID.instanceID().instanceID(handler: { (result, error) in
                    if let result = result {
                       print(result)
                    }
                })
                
                
            }
        }
    }
    
    
    
    
    
    func reloadColView() {
        print("reloadColView Called")
        let layout = self.colVProducts.collectionViewLayout as! PinterestLayout
        self.colVProducts.reloadData()

        setupViews()
        layout.cache.removeAll()
        layout.prepare()
        
    }
    fileprivate func addDoneLeftBarBtn() {
        
        
        //addLogoWithLeftBarButton()
        
        //        self.navigationItem.leftBarButtonItems = [btnMenuButton]
    }
    
    @objc func pizzaMenuTapped(sender: UIButton) {
        if drawerLeading.constant == 0 {
            drawerLeading.constant = -280
            DimView.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }else {
            drawerLeading.constant = 0
            DimView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
//    @objc func openMenu() {
//
//        tabBarController?.tabBar.isHidden = true
////        loadArrayTableSectionsWithData()
//        SideMenuBar.BackArrow.addTarget(self, action: #selector(Close_SideMenuBar), for: .touchUpInside)
//        SideMenuBar.UserName.text = SessionManager.shared.name
//        SideMenuBar.UserImage.layer.cornerRadius =   SideMenuBar.UserImage.layer.bounds.height / 2
//        SideMenuBar.TableView.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
////        SideMenuBar.TableView.delegate = self
////        SideMenuBar.TableView.dataSource = self
//        SideMenuBar.UserImage.sd_setImage(with:URL(string: SessionManager.shared.image) , placeholderImage: #imageLiteral(resourceName: "Profile-image-for-sell4bids-App"), options: [.refreshCached], completed: nil)
//        self.navigationController?.view.addSubview(SideMenuBar)
//
//    }
    
    private func setupViews() {
        
        if #available(iOS 10.0, *) {
            self.colVProducts.refreshControl = refreshControl
        }
        
        btnTryAgainNoResults.addShadowAndRound()
        setCustomBackImage()
        addGestureToMike()
        self.emptyProductMessage.text = "Sorry, No items found. Try searching with different filters".localizableString(loc: LanguageChangeCode)
        imgViewNetworkError.loadGif(name: "networkError")
        
        
        self.automaticallyAdjustsScrollViewInsets = true
        //FireBase connection
        //CollectionView
        if let layout = colVProducts.collectionViewLayout as? PinterestLayout {
            
            layout.delegate = self
        }
        colVProducts.backgroundColor = .clear
        colVProducts.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //Registering the header view identifier
        
        //
        //Side Menu Properties
        if (self.revealViewController()?.delegate = self) != nil {
            self.revealViewController().delegate = self
            
            
//            titleview.menuBtn.addTarget( self, action: #selector(openMenu), for: .touchUpInside)
            titleview.menuBtn.addTarget(self, action: #selector(pizzaMenuTapped(sender:)), for: .touchUpInside)
            
            //  titleview.menuBtn.target = revealViewController()
            //    titleview.menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
        }
        self.tabBarController?.delegate = self
        mikeImgForSpeechRec.image = UIImage(named: "mike")
        
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "emptyImage")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40) //CGRectMake(0, 0, 30, 30)
        
        
        
        
        
        
        //navigationItem.titleView = searchBarTop
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        print(imageView)
        
        // navigationItem.titleView = imageView
        
        
    }
    
    private func swipe() {
        let Rightswipe = UISwipeGestureRecognizer(target: self, action: #selector(self.RepondtoGesture))
        Rightswipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(Rightswipe)
        
        let Leftswipe = UISwipeGestureRecognizer(target: self, action: #selector(self.RepondtoGesture))
        Leftswipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(Leftswipe)
    }
    @objc func RepondtoGesture(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.left:
            swipeLeft()
        case UISwipeGestureRecognizer.Direction.right:
            swipeRight()
        default:
            break
        }
        
    }
    
    private func swipeRight() {
        drawerLeading.constant = 0
        DimView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func swipeLeft() {
        drawerLeading.constant = -300
        DimView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }

    
    
    
    
    
    
    func downloadAndShowData() {
        
        if checkInternetAndShowNoResults() {
            toggleShowViewNoResults(flag: false)
            
            
            if !self.flagIsFilterApplied {
                
                //        getCurrenState{ (complete,country,a,b)  in
                //            print("country = \(country!)")
                //          self.cityAndStateName = city + ",\(stateName)"
                //          self.getUserBlockedList{(complete) in
                //            self.fetchAndDisplayData(flagFirstTime: true)
                //           print("Zipcode = \(zipCode)")
                //
                //          }
                //        }
                
            }else {
                
                //        let cityAndStateArr = self.cityAndStateName?.components(separatedBy: ",")
                //
                //        guard let cityAndStateArr_ = cityAndStateArr else {
                //          return
                //        }
                //        guard cityAndStateArr_.count > 1 else {
                //          return
                //        }
                //        let state =  cityAndStateArr_[1]
                //        stateName = state.trimmingCharacters(in: .whitespaces)
                //
                //        self.CityName = cityAndStateArr_[0]
                //        self.cityAndStateName = city + ",\(stateName)"
                
                
                //        DB_Names.state = stateName
                
                
            }
            
        }
        
        
        
    }
    
    private func addGestureToMike() {
        // let tap = UITapGestureRecognizer(target: self, action: #selector(mikeTapped))
        titleview.micBtn.addTarget(self, action:  #selector(mikeTapped), for: .touchUpInside)
        //mikeImgForSpeechRec.addGestureRecognizer(tap)
    }
    
    //  private func storeFCMTokenInUsersNode(fcmToken: String) {
    //    //print("going to store fcm token from firebase in users node to receive push notifications")
    //    dbRef.child("users").child(SessionManager.shared.userId).child("token").setValue(fcmToken)
    //  }
    
    @objc private func displayUnReadNotifInTabBadge(_ notification: Notification) {
        if let userInfo = notification.userInfo as? [String:Int] {
            if let unRead = userInfo["unRead"]  {
                if unRead > 0 {
                    DispatchQueue.main.async {
                        self.tabBarController?.tabBar.items![4].badgeValue = "\(unRead)"
                    }
                    
                }else {
                    DispatchQueue.main.async {
                        self.tabBarController?.tabBar.items![4].badgeValue = nil
                    }
                    
                    
                }
            }
        }
    }
    
    func getCurrenState(completion : @escaping (Bool,String?,String?,String?,String?,String?) -> ()) {
        //1. Try to get users physical location
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        print("latitud")
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            if locationManager.location != nil{
                let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
                let loc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
                let geo = CLGeocoder()
                geo.reverseGeocodeLocation(loc, completionHandler: { [weak self] (placemarks, error) -> Void in
                    print("placmarks == \(String(describing: placemarks?.first?.country!))")
                    guard self != nil else {
                        completion(false,nil,nil,nil,nil,nil)
                        return
                        
                    }
                    
                    if let placeMark = placemarks?.first {
                        if let country = placeMark.addressDictionary!["Country"] as? String {
                            
                            
                            //new requirements India country added
                            
                            let state = placeMark.addressDictionary!["State"] as? String
                            let citygps = placeMark.addressDictionary!["City"] as? String
                            let zipcode = placeMark.postalCode
                            let latitude = "\(String(describing: placeMark.location?.coordinate.latitude))"
                            let longitude = "\(String(describing: placeMark.location?.coordinate.longitude))"
                            print("latitude = \(latitude) longitude = \(longitude)")
                            city = citygps!
                            stateName = state!
                            zipCode = zipcode ?? "75210"
                            gpscountry = country
                            lat = String(placeMark.location!.coordinate.latitude)
                            long = String(placeMark.location!.coordinate.longitude)
                            
                            //                if country == "United States" {
                            //                    gpscountry = "USA"
                            //                }else if country == "India" {
                            //                    gpscountry = "IN"
                            //                }
                            
                            if zipcode != zipCode {
                                zipCode = zipcode ?? "75210"
                                fetchingMethod = "zipcode"
                                
                            }
                            
                            print("get gps citygps = \(citygps) , state = \(state) , zipcode = \(zipCode)")
                            
                            
                            
                            self!.titleview.citystateZIpcode.text = "\(citygps!), \(state!) \(zipcode)"
                            completion(true,state,citygps,zipcode,latitude,longitude)
                            
                            
                            print("Country ==\(country)")
                            realGpsCountry = country
                            gpscountry = "USA"
                            //                this.getCityAndStateFromUsersNode(completion: { (c, state , zipcode, country)  in
                            //                    guard let ci = c, let state = state , let zip = zipcode  else {
                            //                    //could not get city and state from users node, so falling back to new york
                            //                    stateName = "NY"
                            //                    this.CityName = "NewYork"
                            //                    city =  "NewYork"
                            //                    zipCode = "10001"
                            //
                            //
                            //
                            //                        this.cityAndStateName = city + ", " + stateName
                            //
                            //                    completion(false,"NewYork","NY","10001","40.785091","74.0060")
                            //                    return
                            //                  }
                            //                  //got city and state name from users node
                            //
                            ////                  stateName = state
                            ////                  this.CityName = ci
                            ////                 // city = ci
                            ////                    zipCode = zip
                            ////                  //  if zip.isEmpty {
                            ////                    //    zipCode = "10001"
                            ////                 //   }
                            ////                  print("Zipcode == \(zip)")
                            ////                  this.cityAndStateName = city + stateName
                            //                     print("get from user node citygps = \(ci) , state = \(state) , zipcode = \(zip), country = \(gpscountry)")
                            //                  completion(true,state,ci,zip,"","")
                            //
                            //                })
                            //
                            
                            
                            
                            
                        }
                    }
                })
            } else{
                //print("location is disabled")
                //get location from user's node
                
                stateName = "NY"
                self.CityName = "NewYork"
                zipCode = "10001"
                gpscountry = "USA"
                completion(true,"NewYork","NY", "10001", "40.785091", "74.0060")
            }
        } else{
            //location is disable, revert to new York
            //print("location is disabled")
            stateName = "NY"
            self.CityName = "NewYork"
            zipCode = "10001"
            gpscountry = "USA"
            completion(true,"NewYork","NY","10001", "40.785091", "74.0060")
        }
    }
    
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        print("called Notification Clicked")
//
//        if response.notification.request.identifier == "bidding" {
//            print("Biding Notification")
//
//
//
//            MainApis.Item_Details(uid: SessionManager.shared.userId, country: gpscountry, seller_uid: "ctermid", item_id: item_id) { (status, response, error) in
//
//                if status {
//
//
//
//                    for message in response!["message"] {
//
//                        let itemCategory = message.1["itemCategory"].stringValue
//
//
//
//
//
//                        if  itemCategory == "Jobs" {
//                            let jobApplied = response!["jobApplied"].boolValue
//                            //Job Details Data
//                            let employmentType = message.1["employmentType"].stringValue
//                            let autoReList = message.1["autoReList"].boolValue
//                            let itemAuctionType = message.1["itemAuctionType"].stringValue
//                            let old_images = message.1["old_images"]
//                            let loc = message.1["loc"]
//                            let coordinates = loc["coordinates"].array
//                            var old_images_array = [String]()
//                            for oldimages in old_images {
//                                old_images_array.append(oldimages.1.stringValue)
//                            }
//                            let payPeriod = message.1["payPeriod"].stringValue
//                            let state = message.1["state"].stringValue
//                            let companyName = message.1["companyName"].stringValue
//                            let startPrice = message.1["startPrice"].int64Value
//                            let image = message.1["images_path"]
//                            var imageArray = [String]()
//                            for img in image {
//                                imageArray.append(img.1.stringValue)
//                            }
//                            let acceptOffers = message.1["acceptOffers"].boolValue
//                            let zipcode = message.1["zipcode"].stringValue
//                            let quantity = message.1["quantity"].int64Value
//                            let description = message.1["description"].stringValue
//                            let startTime = message.1["startTime"].int64Value
//                            let jobCategory = message.1["jobCategory"].stringValue
//                            let chargeTime = message.1["chargeTime"].int64Value
//                            let city = message.1["city"].stringValue
//                            let ordering_status = message.1["ordering"].boolValue
//                            let benefits = message.1["benefits"]
//                            var medical = String()
//                            var PTO = String()
//                            var FZOK = String()
//                            for benefit in benefits {
//                                let medical = benefit.1["Medical"].stringValue
//                                let PTO = benefit.1["PTO"].stringValue
//                                let FZOK = benefit.1["FZOK"].stringValue
//
//                            }
//                            var latitude = Double()
//                            var londtitude = Double()
//
//                            print("coordinate == \(coordinates)")
//                            latitude = coordinates![1].doubleValue
//                            londtitude = coordinates![0].doubleValue
//
//
//
//
//                            let itemKey = message.1["itemKey"].stringValue
//                            let companyDescription = message.1["companyDescription"].stringValue
//                            let visibility = message.1["visibility"].boolValue
//                            let condition = message.1["condition"].stringValue
//                            let uid = message.1["uid"].stringValue
//                            let country_code = message.1["country_code"].stringValue
//                            let id = message.1["_id"].stringValue
//                            let timeRemaining = message.1["timeRemaining"].int64Value
//                            let conditionValue = message.1["conditionValue"].intValue
//                            let endTime = message.1["endTime"].int64Value
//                            let token = message.1["token"].stringValue
//                            let title = message.1["title"].stringValue
//                            let experience = message.1["jobExperiance"].stringValue
//                            let userName = message.1["name"].stringValue
//                            let watchBool = message.1["watchBool"].boolValue
//                            let watch_uid = message.1["watch_uid"].stringValue
//                            let watch_token = message.1["watch_token"].stringValue
//                            let currency_string = message.1["currency_string"].stringValue
//                            let currency_symbol = message.1["currency_string"].stringValue
//                            let admin_verify = message.1["admin_verify"].stringValue
//
//                            let jobdetails = JobDetails.init(employmentType: employmentType, autoReList: autoReList, itemAuctionType: itemAuctionType, old_images: old_images_array, payPeriod: payPeriod, state: state, companyName: companyName, startPrice: startPrice, image: imageArray, acceptOffers: acceptOffers, zipcode: zipcode, quantity: quantity, description: description, startTime: startTime, jobCategory: jobCategory, chargeTime: chargeTime, city: city, latitude: latitude, longtitude: londtitude, itemKey: itemKey, companyDescription: companyDescription, visibility: visibility, condition: condition, uid: uid, country_code: country_code, id: id, timeRemaining: timeRemaining, conditionValue: conditionValue, endTime: endTime, token: token, itemCategory: itemCategory, title: title , medical: medical , PTO: PTO , FZOK: FZOK, Experience: experience, userName: userName, watchBool: watchBool , watch_uid: watch_uid , watch_token: watch_token , jobApplied: jobApplied , currency_string: currency_string, currency_symbol: currency_symbol , admin_verify: admin_verify)
//
//                            print("Job Details = \(jobdetails.title)")
//
//
//                            let storyBoard_ = UIStoryboard.init(name: storyBoardNames.JobDetails , bundle: nil)
//                            let controller = storyBoard_.instantiateViewController(withIdentifier: "JoBDetailViewIdentifier") as! JoBDetailViewVC
//                            controller.selectedProduct_Job = jobdetails
//                            // controller.  = selectedProductKey
//
//
//
//                        }else {
//                            //Item Details Job
//                            let startPrice = message.1["startPrice"].intValue
//                            let visibility = message.1["visibility"].boolValue
//                            let quantity = message.1["quantity"].intValue
//                            let image_0 = message.1["old_images"]
//                            var image_array = [String]()
//                            for image in image_0 {
//                                image_array.append(image.1.stringValue)
//                            }
//                            let chargeTime = message.1["chargeTime"].int64Value
//                            let token = message.1["token"].stringValue
//                            let description = message.1["description"].stringValue
//                            let uid = message.1["uid"].stringValue
//                            let watchingbool = response!["watching"].boolValue
//                            let itemKey = message.1["_id"].stringValue
//                            let loc = message.1["loc"]
//                            let corrdinate = loc["coordinates"]
//
//                            var maxBid = Int64()
//                            var askPrice = Int64()
//                            var winner = String()
//                            var u_id = String()
//                            var bid = Int64()
//                            var watch_uid = String()
//                            var watch_token = String()
//                            var ItemimagesArr = [String]()
//
//
//                            let itemAuctionType = message.1["itemAuctionType"].stringValue
//                            let country_code = message.1["country_code"].stringValue
//                            let startTime = message.1["startTime"].stringValue
//                            let bids = message.1["bids"]
//                            for values in bids {
//                                let maxBidvalue = values.1["maxBid"].int64Value
//                                let askPricevalue = values.1["askPrice"].int64Value
//                                let winnervalue = values.1["winner"].stringValue
//                                maxBid = maxBidvalue
//                                askPrice = askPricevalue
//                                winner = winnervalue
//                            }
//                            let bidList = message.1["bidList"]
//                            for bidlst in bidList {
//                                let uidvalue = bidlst.1["uid"].stringValue
//                                let bidvalue = bidlst.1["bid"].int64Value
//                                u_id = uidvalue
//                                bid = bidvalue
//                            }
//                            let timeRemaining = message.1["timeRemaining"].int64Value
//                            let conditionValue = message.1["conditionValue"].stringValue
//                            let title = message.1["title"].stringValue
//                            let watching = message.1["watching"]
//                            for watch in watching {
//                                let watch_uidvalue = watch.1["uid"].stringValue
//                                let watch_tokenvalue = watch.1["token"].stringValue
//                                watch_uid = watch_uidvalue
//                                watch_token = watch_tokenvalue
//
//                            }
//                            self.orderArray.removeAll()
//                            self.offerArray.removeAll()
//                            let OrderArray = message.1["orders"].arrayValue
//                            for item in OrderArray {
//                                guard let OrderDic = item.dictionary else {return}
//                                let orderId = OrderDic["_id"]?.string ?? ""
//                                let sellerId = OrderDic["seller_uid"]?.string ?? ""
//                                let buyerOfferCount = OrderDic["buyerOfferCount"]?.int ?? -1
//                                let offersTypeArray = OrderDic["offers"]?.array ?? []
//                                for item in offersTypeArray {
//                                    guard let Dic = item.dictionary else {return}
//                                    let message = Dic["message"]?.string ?? ""
//                                    let role = Dic["role"]?.string ?? ""
//                                    let price = Dic["price"]?.string ?? ""
//                                    let quantity = Dic["quantity"]?.string ?? ""
//                                    let time = OrderDic["time"]?.string ?? ""
//                                    let object = offerModel.init(message: message, role: role, price: price, quantity: quantity, time: time)
//                                    self.offerArray.append(object)
//                                }
//                                print(self.offerArray)
//                                let obj = orderModel.init(orderId: orderId, sellerId: sellerId, OfferCount: buyerOfferCount, OfferArray: self.offerArray)
//                                self.orderArray.append(obj)
//                            }
//                            print(self.orderArray)
//
//                            let acceptOffers = message.1["acceptOffers"].boolValue
//                            let ordering = message.1["ordering"].boolValue
//                            let zipcode = message.1["zipcode"].stringValue
//                            let condition = message.1["condition"].stringValue
//                            let city = message.1["city"].stringValue
//                            let endTime = message.1["endTime"].int64Value
//                            let id = message.1["_id"].stringValue
//                            let state = message.1["state"].stringValue
//                            let autoReList = message.1["autoReList"].stringValue
//                            var latitude = Double()
//                            var londtitude = Double()
//                            let itemimages = message.1["old_images"]
//                            let coordinates = loc["coordinates"].array
//                            for itemimg in itemimages {
//                                ItemimagesArr.append(itemimg.1.stringValue)
//                                print("Item Image Url Backhand == \(itemimg.1.stringValue)")
//                            }
//
//                            latitude = coordinates![1].doubleValue
//                            londtitude = coordinates![0].doubleValue
//                            let currency_string = message.1["currency_string"].stringValue
//                            let currency_symbol = message.1["currency_string"].stringValue
//                            let admin_verify = message.1["admin_verify"].stringValue
//
//                            let productdetails = ProductDetails.init(itemkey: itemKey, itemAuctionType : itemAuctionType ,visibility: visibility, startPrice: startPrice, quantity: quantity, chargeTime: chargeTime, Image_0: image_0.stringValue, Image_1: image_0.stringValue, token: token, description: description, uid: uid, itemCategory: itemCategory, country_code: country_code, startTime: Int64(startPrice), maxBid: maxBid, askPrice: askPrice, winner: winner, winner_uid: watch_uid, winner_bid: Int64(startPrice), timeRemaining: timeRemaining, conditionValue: conditionValue, title: title, watch_uid: watch_uid, watch_token: watch_token, zipcode: zipcode, condition: condition, city: city, endTime: endTime, id: id, state: state, autoReList: autoReList, ItemImages: ItemimagesArr, latitude: latitude, longtitude: londtitude, ordering_status: true, company_name: "", benefits: "", payPeriod: "", jobToughness: "", employmentType: "" , acceptOffers: acceptOffers , ordering: ordering , watchingBool: watchingbool, OrderArray: self.orderArray , currency_string: currency_string, currency_symbol: currency_symbol , admin_verify: admin_verify)
//
//                            selectedProduct = productdetails
//
//
//
//                            let storyBoard_ = UIStoryboard.init(name: storyBoardNames.ItemDetails , bundle: nil)
//                            let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailsVC") as! ItemDetailsTableView
//                            controller.loadnavi()
//                            controller.selectedProduct = selectedProduct
//
//
//                            self.navigationController!.pushViewController(controller, animated: true)
//
//                            // controller.  = selectedProductKey
//
//
//                        }
//
//
//
//
//
//
//
//
//                    }
//
//                }
//
//                if error.contains("The network connection was lost"){
//
//                    let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
//                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
//                    alert.addAction(ok)
//
//
//
//                }
//
//                if error.contains("The Internet connection appears to be offline.") {
//
//                    let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
//                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
//                    alert.addAction(ok)
//
//
//
//                }
//
//                if error.contains("A server with the specified hostname could not be found."){
//
//                    let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
//                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
//                    alert.addAction(ok)
//
//                }
//
//                if error.contains("The request timed out.") {
//
//                    let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
//                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
//                    alert.addAction(ok)
//
//
//                }
//
//            }
//
//
//        }else if response.notification.request.identifier == "offers" {
//            print("Offers Notification")
//            UITabBarController().tabBarController?.selectedIndex = 4
//        }
//
//        if response.notification.request.identifier == "orders" {
//            print("Orders Notification")
//            UITabBarController().tabBarController?.selectedIndex = 4
//        }
//
//        completionHandler()
//
//    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
        
        
        //UIApplication.shared.applicationIconBadgeNumber += 1
    }
    
  }
  
  // MARK:- Table View Life cycle
  extension HomeVC_New: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return drawerSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return drawerSection[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawerArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = drawerTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let image =  drawerArray[indexPath.section][indexPath.row].image
        cell.imageView!.image = image?.maskWithColor(color: UIColor.white)
        cell.textLabel?.text = drawerArray[indexPath.section][indexPath.row].name
        cell.detailTextLabel?.text = "Ehtisham"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.text = drawerSection[section]
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        
        view.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                print("Home")
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 1 {
                print("Sell Now")
                //Sell Now
                self.drawerLeading.constant = -280
                alertActionBarSellNow = UIAlertController(title:"", message: "Select Sell Now Option", preferredStyle: .actionSheet)
                
                //item Sell Now Gesture
                let Items_Gesture = UITapGestureRecognizer(target: self, action: #selector(Item_Select_Sell_Now))
                
                //Job Sell Now Gesture
                let Job_Gesture = UITapGestureRecognizer(target: self, action: #selector(Job_Select_Sell_Now))
                
                //Vehicles Sell Now Gesture
                let Vehicles_Gesture = UITapGestureRecognizer(target: self, action: #selector(Vehicles_Select_Sell_Now))
                
                //Services Sell Now Gesture
                let Services_Gesture = UITapGestureRecognizer(target: self, action: #selector(Services_Select_Sell_Now))
                
                //Services Sell Now Gesture
                let Housing_Gesture = UITapGestureRecognizer(target: self, action: #selector(Housing_Select_Sell_Now))
                
                //Changes by OsamaMansoori(12-04-2019)
                //item Sell Now Details
                
                customview.OthersItemsLbl.isUserInteractionEnabled = true
                customview.OthersItemsLbl.addGestureRecognizer(Items_Gesture)
                
                //Job Sell Now Details
                
                customview.JobsLbl.isUserInteractionEnabled = true
                customview.JobsLbl.addGestureRecognizer(Job_Gesture)
                
                //Housing Sell Now Details
                
                customview.HousingLbl.isUserInteractionEnabled = true
                customview.HousingLbl.addGestureRecognizer(Housing_Gesture)
                
                //Vehicles Sell Now Details
                
                customview.VehiclesLbl.isUserInteractionEnabled = true
                customview.VehiclesLbl.addGestureRecognizer(Vehicles_Gesture)
                
                
                //Services Sell Now Details
                
                customview.isUserInteractionEnabled = true
                
                customview.ServiceLbl.isUserInteractionEnabled = true
                customview.ServiceLbl.addGestureRecognizer(Services_Gesture)
                
                customview.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: 200)
                
                alertActionBarSellNow.view.addSubview(customview)
                
                alertActionBarSellNow.view.frame = CGRect(x: 0, y: 0,width :  UIScreen.main.bounds.width, height: 100)
                alertActionBarSellNow.popoverPresentationController?.sourceView = self.view
                alertActionBarSellNow.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.minX, y: self.view.bounds.maxY, width: UIScreen.main.bounds.width, height: 0)
                
                self.present(alertActionBarSellNow, animated: true) {
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
                    alertActionBarSellNow.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
                }
            }
            else if indexPath.row == 2 {
                print("Categories")
                self.tabBarController?.selectedIndex = 3
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 3 {
                print("Search Filters")
                let vc = storyboard?.instantiateViewController(withIdentifier: "FiltersVc") as! FiltersVc
                vc.selfWasPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 4 {
                print("My Sell$bids")
                self.tabBarController?.selectedIndex = 1
                self.drawerLeading.constant = -280
            }
//            else if indexPath.row == 5 {
//                print("Jobs")
//                let SBName = storyBoardNames.tabs.categoriesTab
//                let catDetailsSB = getStoryBoardByName(SBName)
//                let controller = catDetailsSB.instantiateViewController(withIdentifier: "CategoryDetailVC") as! CategoryDetailVC
//                controller.categoryName = "Jobs"
//                controller.sidemenu = true
//                let tbc = revealViewController().frontViewController as? UITabBarController
//                let nav = UINavigationController.init(rootViewController: controller)
//                tbc?.present(nav, animated: true, completion: nil)
//                self.revealViewController().setFrontViewPosition(.leftSide, animated: true)
//                self.drawerLeading.constant = -280
//            }
            else if indexPath.row == 6 {
                print("My Chat")
                let chatSB = getStoryBoardByName(storyBoardNames.chat)
                let chatListVC = chatSB.instantiateViewController(withIdentifier: "MyChatList") as! MyChatListVC
                chatListVC.flagUsedInMySell4Bids = false
                
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: chatListVC)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                tbc?.present(nav, animated: true, completion: nil)
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 7 {
                print("My Profile")
                let myProfileSB = getStoryBoardByName(storyBoardNames.myProfileSB)
                if let controller = myProfileSB.instantiateViewController(withIdentifier: "UserProfileDetailVc") as? UserProfileDetail {
                    //                    controller.userData = self.userData
                    let tbc = revealViewController().frontViewController as? UITabBarController
                    let nav = UINavigationController.init(rootViewController: controller)
                    tbc?.present(nav, animated: true, completion: nil)
                    self.revealViewController().setFrontViewPosition(.left, animated: true)
                    self.drawerLeading.constant = -280
                }
            }
            else if indexPath.row == 8 {
                print("Recommendations")
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 9 {
                print("Notifications")
                self.tabBarController?.selectedIndex = 4
                self.drawerLeading.constant = -280
            }
            
        }
            
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                print("Selling")
                let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                let chatListVC = chatSB.instantiateViewController(withIdentifier: "MySellVc") as! SellingVC
                
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: chatListVC)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                tbc?.present(nav, animated: true, completion: nil)
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 1 {
                print("My Watchlist")
//                self.tabBarController?.selectedIndex = 1
                let chatSB = UIStoryboard(name: "myWatchList", bundle: nil)
                let chatListVC = chatSB.instantiateViewController(withIdentifier: "ActiveWatchListVc") as! ActiveWatchListVc
                
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: chatListVC)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                tbc?.present(nav, animated: true, completion: nil)
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 2 {
                print("Buying")
                let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                let chatListVC = chatSB.instantiateViewController(withIdentifier: "BidsVc") as! BuyingAndBidsVC
                
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: chatListVC)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                tbc?.present(nav, animated: true, completion: nil)
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 3 {
                print("Bought")
                let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                let chatListVC = chatSB.instantiateViewController(withIdentifier: "BoughtAndWinsVc") as! BoughtAndWinsVc
                
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: chatListVC)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                tbc?.present(nav, animated: true, completion: nil)
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 4 {
                print("Bids")
                let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                let chatListVC = chatSB.instantiateViewController(withIdentifier: "BidsItemsVC") as! BidsVC
                
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: chatListVC)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                tbc?.present(nav, animated: true, completion: nil)
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 5 {
                print("Wins")
                let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                let chatListVC = chatSB.instantiateViewController(withIdentifier: "WinsVc") as! WinsVc
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: chatListVC)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                tbc?.present(nav, animated: true, completion: nil)
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 6 {
                print("Followers")
                let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                let chatListVC = chatSB.instantiateViewController(withIdentifier: "FollowersVc") as! FollowersVc
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: chatListVC)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                tbc?.present(nav, animated: true, completion: nil)
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 7 {
                print("Followings")
                let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                let chatListVC = chatSB.instantiateViewController(withIdentifier: "FollowingVc") as! FollowingVc
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: chatListVC)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                tbc?.present(nav, animated: true, completion: nil)
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 8 {
                print("Block List")
                let chatSB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                let chatListVC = chatSB.instantiateViewController(withIdentifier: "BlockUserVc") as! BlockUserVc
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: chatListVC)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                tbc?.present(nav, animated: true, completion: nil)
                self.drawerLeading.constant = -280
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                print("What is Sell4bids")
                let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
                
                let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "whatIsSell4Bids")
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: controller)
                tbc?.present(nav, animated: true, completion: nil)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                self.drawerLeading.constant = -280
            }
                
            else if indexPath.row == 1 {
                print("How It Works")
                let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
                let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "howItWorksTableVC")
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: controller)
                tbc?.present(nav, animated: true, completion: nil)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                self.drawerLeading.constant = -280
            }
                
            else if indexPath.row == 2 {
                print("Establish Contact")
                let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
                let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "establishContact")
                let tbc = revealViewController().frontViewController as? UITabBarController
                let nav = UINavigationController.init(rootViewController: controller)
                tbc?.present(nav, animated: true, completion: nil)
                self.revealViewController().setFrontViewPosition(.left, animated: true)
                self.drawerLeading.constant = -280
            }
        }
            
        else if indexPath.section == 3 {
            if indexPath.row == 0 {
                print("Term of Use")
//                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "termsServiceVC") as? termsServiceVC {
//                    let tbc = revealViewController().frontViewController as? UITabBarController
//                    let nav = UINavigationController.init(rootViewController: controller)
//                    tbc?.present(nav, animated: true, completion: nil)
//                    self.drawerLeading.constant = -280
//                }
            }
                
            else if indexPath.row == 1 {
                print("Privacy Policy")
//                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "termsServiceVC") as? termsServiceVC {
//                    let tbc = revealViewController().frontViewController as? UITabBarController
//                    controller.flagShowTerms_or_PrivacyPolicy = 1
//                    let nav = UINavigationController.init(rootViewController: controller)
//                    tbc?.present(nav, animated: true, completion: nil)
//                    self.revealViewController().setFrontViewPosition(.left, animated: true)
//                    self.drawerLeading.constant = -280
//                }
            }
            else if indexPath.row == 2 {
                print("FAQs")
                self.drawerLeading.constant = -280
            }
        }
            
        else if indexPath.section == 4 {
            if indexPath.row == 0 {
                print("Rate Us")
              
                guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1304176306") else {
                    return
                }
                guard #available(iOS 10, *) else {
                    return
                }
                UIApplication.shared.open(url, options: [:])
                self.drawerLeading.constant = -280
              
            }
            else if indexPath.row == 1 {
                print("Share")
                let messageStr = "Did you install the Official Sell4Bids App? You wil find Stuff, Services, Jobs, Offers, Counter-Offers, Auctions & Bidding and a whole lot more.\n\n"
                
                let itunesLink = URL.init(string: "https://itunes.apple.com/us/app/sell4bids/id1304176306?mt=8")!
                
                let activityItems = [ messageStr, itunesLink] as [Any]
                let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                self.present(activityViewController, animated: true, completion: nil)
                self.drawerLeading.constant = -280
            }
            else if indexPath.row == 2 {
                print("Logout")
                
                _ = SweetAlert().showAlert("Signing Out", subTitle: "Do you want to sign out?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (action) -> Void in
//                    if(action == true) {
//                        
//                        SessionManager.logOut()
//                        let loginSignupSB = getStoryBoardByName(storyBoardNames.loginSignupSB)
//                        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//                        
//                        let homeViewController = loginSignupSB.instantiateViewController(withIdentifier: "WelcomeVc") as! WelcomeVc
//                        let nav = UINavigationController(rootViewController: homeViewController)
//                        appdelegate.window!.rootViewController = nav
//                        appdelegate.window?.makeKeyAndVisible()
//                        homeViewController.reloadInputViews()
//                        //showSwiftMessageWithParams(theme: .success, title: "Logout", body: "You have been successfully logout")
//                        _ = SweetAlert().showAlert("Signed Out", subTitle: "   You have been signed out successfully.   " , style: AlertStyle.success,buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
//                    }
                    
                }
            }
        }
    }
  }
  
  
  
  
//  extension HomeVC_New : UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 0
//        }
//        return UIDevice.isPad ? 50 : 40
//    }
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard section != 0 else { return }
//        guard let header = view as? UITableViewHeaderFooterView else { return }
//        header.textLabel?.textColor = UIColor.white
//
//
//        header.textLabel?.font = AdaptiveLayout.HeadingBold
//        header.textLabel?.frame = header.frame
//        header.textLabel?.textAlignment = .left
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return arrayTableSections[section].name
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return arrayTableSections.count
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrayTableSections[section].items.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
//
//        let image = arrayTableSections[indexPath.section].items[indexPath.row].image
//
//        let text = arrayTableSections[indexPath.section].items[indexPath.row].name
//
//        cell.menuLabel.tag = indexPath.row
//
//        // @AK 30-jan
//        cell.menuLabel.rightAlign(LanguageCode : LanguageChangeCode)
//        //      if indexPath.section == 0 && indexPath.row == 8 {
//        //        text = "Notifications"
//        //        let count = SideMenuVc.numOfUnReadNotifications
//        //
//        //        if count > 0 {
//        //          text = "Notifications - \(SideMenuVc.numOfUnReadNotifications)"
//        //        }
//        //
//        //        print("text = \(text)")
//        //        if SideMenuVc.numOfUnReadNotifications != 0  {
//        //          cell.menuLabel.textColor = #colorLiteral(red: 0.8566855788, green: 0.1049235985, blue: 0.136507839, alpha: 1)
//        //        }
//        //        else { cell.menuLabel.textColor = UIColor.black }
//        //
//        //      }
//
//
//
//        print("Section = \(indexPath.section)   Row = \(indexPath.row)")
//
//        //cell.menuLabel.font = AdaptiveLayout.normalBold
//        cell.imgIcon.image = image
//        cell.menuLabel.text = text
//        //        textlabelmsg = cell.menuLabel
//        // @ AK 30-jan
//
//
//        if (cell.menuLabel.text?.contains("My Chat -  unread"))! {
//            cell.menuLabel.textColor = UIColor.red
//        }else if (cell.menuLabel.text?.contains("Notifications -"))!{
//            cell.menuLabel.textColor = UIColor.red
//        }else{
//            cell.menuLabel.textColor = UIColor.white
//        }
//        //
//        //cell.menuLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        cell.selectionStyle = UITableViewCellSelectionStyle.none
//
//        return cell
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if indexPath.section == 0 {
//
//            if indexPath.row == 0
//            {
//                //Home
//                SideMenuBar.removeFromSuperview()
//
//
//            }
//            else if indexPath.row == 1 {
//                //Sell Now
//                SideMenuBar.removeFromSuperview()
//
//
//                alertActionBarSellNow = UIAlertController(title:"", message: "Select Sell Now Option", preferredStyle: .actionSheet)
//
//
//
//                //item Sell Now Gesture
//                let Items_Gesture = UITapGestureRecognizer(target: self, action: #selector(Item_Select_Sell_Now))
//
//                //Job Sell Now Gesture
//                let Job_Gesture = UITapGestureRecognizer(target: self, action: #selector(Job_Select_Sell_Now))
//
//
//                //Vehicles Sell Now Gesture
//                let Vehicles_Gesture = UITapGestureRecognizer(target: self, action: #selector(Vehicles_Select_Sell_Now))
//
//                //Services Sell Now Gesture
//                let Services_Gesture = UITapGestureRecognizer(target: self, action: #selector(Services_Select_Sell_Now))
//
//                //Changes by OsamaMansoori(12-04-2019)
//                //item Sell Now Details
//
//                customview.OthersItemsLbl.isUserInteractionEnabled = true
//                customview.OthersItemsLbl.addGestureRecognizer(Items_Gesture)
//
//                //Job Sell Now Details
//
//                customview.JobsLbl.isUserInteractionEnabled = true
//                customview.JobsLbl.addGestureRecognizer(Job_Gesture)
//
//                //Vehicles Sell Now Details
//
//                customview.VehiclesLbl.isUserInteractionEnabled = true
//                customview.VehiclesLbl.addGestureRecognizer(Vehicles_Gesture)
//
//
//                //Services Sell Now Details
//
//                customview.isUserInteractionEnabled = true
//
//                customview.ServiceLbl.isUserInteractionEnabled = true
//                customview.ServiceLbl.addGestureRecognizer(Services_Gesture)
//
//
//
//                customview.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: 200)
//
//
//                alertActionBarSellNow.view.addSubview(customview)
//
//
//
//                alertActionBarSellNow.view.frame = CGRect(x: 0, y: 0,width :  UIScreen.main.bounds.width, height: 100)
//                alertActionBarSellNow.popoverPresentationController?.sourceView = self.view
//                alertActionBarSellNow.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.minX, y: self.view.bounds.maxY, width: UIScreen.main.bounds.width, height: 0)
//
//                self.present(alertActionBarSellNow, animated: true) {
//                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
//                    alertActionBarSellNow.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
//                }
//
//
//
//            }
//            else if indexPath.row == 2 {
//                //Browse Categories
//                let tbc = revealViewController().frontViewController as? UITabBarController
//                // var nc = tbc?.selectedViewController as? UINavigationController
//                tbc?.selectedIndex = 3
//                self.revealViewController().setFrontViewPosition(.left, animated: true)
//            }
//                //        else if indexPath.row == 3 {
//                //          //Search Products
//                //          let storyBoard = getStoryBoardByName(storyBoardNames.tabs.homeTab)
//                //
//                //          if let controller = storyBoard.instantiateViewController(withIdentifier: "FiltersVc") as? FiltersVc {
//                //            controller.selfWasPushed = true
//                //            let tbc = revealViewController().frontViewController as? UITabBarController
//                //            let nav = UINavigationController.init(rootViewController: controller)
//                //            tbc?.present(nav, animated: true, completion: nil)
//                //            self.revealViewController().setFrontViewPosition(.left, animated: true)
//                //
//                //          }
//                //
//                //        }
//            else if indexPath.row == 3 {
//                //MySel4Bids
//                let tbc = revealViewController().frontViewController as? UITabBarController
//                //var nc = tbc?.selectedViewController as? UINavigationController
//                tbc?.selectedIndex = 1
//                self.revealViewController().setFrontViewPosition(.left, animated: true)
//
//            }
//            else if indexPath.row == 4 {
//                //Jobs
//                let SBName = storyBoardNames.tabs.categoriesTab
//                let catDetailsSB = getStoryBoardByName(SBName)
//
//                let controller = catDetailsSB.instantiateViewController(withIdentifier: "CategoryDetailVC") as! CategoryDetailVC
//
//                controller.categoryName = "Jobs"
//                controller.sidemenu = true
//
//
//
//                let tbc = revealViewController().frontViewController as? UITabBarController
//                let nav = UINavigationController.init(rootViewController: controller)
//                tbc?.present(nav, animated: true, completion: nil)
//
//
//
//                self.revealViewController().setFrontViewPosition(.leftSide, animated: true)
//
//            }
//
//
//            else if indexPath.row == 5{
//                //                self.unreadmsg1 = 0
//                //My Chat
//                //          if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MyChatList") as? MyChatListVC {
//                //
//                //          let tbc = revealViewController().frontViewController as? UITabBarController
//                //          let nav = UINavigationController.init(rootViewController: controller)
//                //          self.revealViewController().setFrontViewPosition(.left, animated: true)
//                //          tbc?.present(nav, animated: true, completion: nil)
//                //
//
//                //           let ref =  dbRef.child("users").child(useridmsg).child("unreadCount")
//                //            ref.setValue("0")
//
//
//                let chatSB = getStoryBoardByName(storyBoardNames.chat)
//                let chatListVC = chatSB.instantiateViewController(withIdentifier: "MyChatList") as! MyChatListVC
//                chatListVC.flagUsedInMySell4Bids = false
//
//                let tbc = revealViewController().frontViewController as? UITabBarController
//                let nav = UINavigationController.init(rootViewController: chatListVC)
//                self.revealViewController().setFrontViewPosition(.left, animated: true)
//                tbc?.present(nav, animated: true, completion: nil)
//
//            }
//
//            else if indexPath.row == 6 {
//                //My Watch list
//                let tbc = revealViewController().frontViewController as? UITabBarController
//                tbc?.selectedIndex = 1
//                self.revealViewController().setFrontViewPosition(.left, animated: true)
//
//            }
//            else if indexPath.row == 7 {
//                //My Profile
//                let myProfileSB = getStoryBoardByName(storyBoardNames.myProfileSB)
//
//                if let controller = myProfileSB.instantiateViewController(withIdentifier: "UserProfileDetailVc") as? UserProfileDetail {
//                    //                    controller.userData = self.userData
//                    let tbc = revealViewController().frontViewController as? UITabBarController
//                    let nav = UINavigationController.init(rootViewController: controller)
//                    tbc?.present(nav, animated: true, completion: nil)
//                    self.revealViewController().setFrontViewPosition(.left, animated: true)
//
//                }
//            }
//            else if indexPath.row == 8{
//
//
//
//                //notifications
//                let tbc = revealViewController().frontViewController as? UITabBarController
//                //var nc = tbc?.selectedViewController as? UINavigationController
//                tbc?.selectedIndex = 4
//
//                self.revealViewController().setFrontViewPosition(.left, animated: true)
//            }
//        }
//        else if indexPath.section == 1 {
//            //About sell4Bids
//            if indexPath.row == 0 {
//                //What is Sell4Bids
//
//                let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
//
//                let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "whatIsSell4Bids")
//                let tbc = revealViewController().frontViewController as? UITabBarController
//                let nav = UINavigationController.init(rootViewController: controller)
//                tbc?.present(nav, animated: true, completion: nil)
//                self.revealViewController().setFrontViewPosition(.left, animated: true)
//
//
//            }
//
//            else if indexPath.row == 1 {
//
//
//                let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
//                let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "howItWorksTableVC")
//                let tbc = revealViewController().frontViewController as? UITabBarController
//                let nav = UINavigationController.init(rootViewController: controller)
//                tbc?.present(nav, animated: true, completion: nil)
//                self.revealViewController().setFrontViewPosition(.left, animated: true)
//
//            }
//            else if indexPath.row == 2 {
//
//                //Establish Contact
//                let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
//                let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "establishContact")
//                let tbc = revealViewController().frontViewController as? UITabBarController
//                let nav = UINavigationController.init(rootViewController: controller)
//                tbc?.present(nav, animated: true, completion: nil)
//                self.revealViewController().setFrontViewPosition(.left, animated: true)
//
//            }
//
//        }//end if indexPath.section == 1
//        else if indexPath.section == 2 {
//            //Legal
//            if indexPath.row == 0 {
//                //Terms and conditions
//                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "termsServiceVC") as? termsServiceVC {
//                    let tbc = revealViewController().frontViewController as? UITabBarController
//                    let nav = UINavigationController.init(rootViewController: controller)
//                    tbc?.present(nav, animated: true, completion: nil)
//
//                }
//            }
//            if indexPath.row == 1 {
//                //Privacy Policy
//
//                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "termsServiceVC") as? termsServiceVC {
//                    let tbc = revealViewController().frontViewController as? UITabBarController
//                    controller.flagShowTerms_or_PrivacyPolicy = 1
//                    let nav = UINavigationController.init(rootViewController: controller)
//                    tbc?.present(nav, animated: true, completion: nil)
//                    self.revealViewController().setFrontViewPosition(.left, animated: true)
//
//                }
//
//
//            }
//        }//end if indexPath.section == 2
//        else if indexPath.section == 3 {
//            //Settings & Feedback
//            if indexPath.row == 0 {
//                //Rate Us
//
//                guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1304176306") else {
//                    return
//                }
//                guard #available(iOS 10, *) else {
//                    return
//                }
//                UIApplication.shared.open(url, options: [:])
//            }
//            else if indexPath.row == 1 {
//                //Share this App
//                let messageStr = "Did you install the Official Sell4Bids App? You wil find Stuff, Services, Jobs, Offers, Counter-Offers, Auctions & Bidding and a whole lot more.\n\n"
//
//                let itunesLink = URL.init(string: "https://itunes.apple.com/us/app/sell4bids/id1304176306?mt=8")!
//
//                let activityItems = [ messageStr, itunesLink] as [Any]
//                let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
//                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//
//                self.present(activityViewController, animated: true, completion: nil)
//            }
//
//                // @Changes By Saad Ahmed(14-06-2019)
//            else if indexPath.row == 2 { //Log Out
//                //log out function
//                func logOut() {
//                    SessionManager.logOut()
//                    if Auth.auth().currentUser == nil
//                    {
//                        let loginSignUpSB = getStoryBoardByName(storyBoardNames.loginSignupSB)
//                        let controller = loginSignUpSB.instantiateViewController(withIdentifier: "WelcomeVc")
//                        self.navigationController?.popToRootViewController(animated: true)
//                        // self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
//
//                        UIApplication.shared.keyWindow?.rootViewController?.dismiss(
//                            animated: false, completion: nil)
//                        let thread_count: mach_msg_type_number_t = 0
//                        let size = MemoryLayout<thread_t>.size * Int(thread_count)
//
//
//
//
//
//
//                        let nav = UINavigationController(rootViewController: controller)
//
//                        // self.navigationController?.popToRootViewController(animated: true)
//                        // @SaadAhmed (12-6-2019)
//                        self.present(nav, animated: true, completion: {
//                            _ = SweetAlert().showAlert("Signed Out", subTitle: "You have been signed out successfully." , style: AlertStyle.success,buttonTitle:
//                                "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
//                            // showSwiftMessageWithParams(theme: .success, title: "Signed Out", body: "You have been Successfully signed out from Sell4bids.", durationSecs: 10, layout: .cardView, position: .center)
//
//                        })
//
//
//                    }else {
//                        // self.alert(message: "Sorry, Could not sign you out")
//                        _ = SweetAlert().showAlert("Signed Out", subTitle: "Sorry, Could not signed out" , style: AlertStyle.error,buttonTitle:
//                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
//
//                    }
//                }
//                _ = SweetAlert().showAlert("Signing Out", subTitle: "Do you want to sign out?", style: AlertStyle.warning, buttonTitle:"Yes", buttonColor:UIColor.colorFromRGB(0x000000), otherButtonTitle:  "No", otherButtonColor: UIColor.colorFromRGB(0x000000)) { (action) -> Void in
//
//                    if(action == true) {
//                        logOut()
//                    }
//
//                }
//            }
//            else if indexPath.row == 3 {
//                //Log Out
//
//            }
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        var height : CGFloat = 0
//        if UIDevice.isSmall { height = 40 }
//        if UIDevice.isMedium { height = 45 }
//        if UIDevice.isPad { height = 50  }
//        else if UIDevice.isX {height = 48 }
//
//
//        return height
//    }
//  }
  
  
  
  //var imageCache = [String:UIImage]()
  
  // MARK: - Image Scaling.
  extension UIImage {
    
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    /// Switch MIN to MAX for aspect fill instead of fit.
    ///
    /// - parameter newSize: newSize the size of the bounds the image must fit within.
    ///
    /// - returns: a new scaled image.
    func scaleImageToSize(newSize: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth = newSize.width/size.width
        let aspectheight = newSize.height/size.height
        let aspectheight3 = aspectheight
        let aspectRatio = max(aspectWidth, aspectheight3)
        
        scaledImageRect.size.width = size.width * aspectRatio;
        scaledImageRect.size.height = size.height * aspectRatio;
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
  }
  
  extension UIView {
    func fade_In() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fade_Out() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
  }
  
  
  extension UNNotificationAttachment {
    
    /// Save the image to disk
    static func create(imageFileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL?.appendingPathComponent(imageFileIdentifier)
            try data.write(to: fileURL!, options: [])
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL!, options: options)
            return imageAttachment
        } catch let error {
            print("error \(error)")
        }
        return nil
    }
    func setAppRatingShown(){
       defaults.set(true, forKey: AP_APP_RATING_SHOWN)
       
     }
    
  }
