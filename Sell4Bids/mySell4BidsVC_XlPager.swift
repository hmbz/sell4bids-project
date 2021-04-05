//  ButtonBarExampleViewController.swift
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2017 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import XLPagerTabStrip

class mySell4BidsVC_XlPager: ButtonBarPagerTabStripViewController , UITabBarControllerDelegate , SWRevealViewControllerDelegate {
    
  
    var titleview = Bundle.main.loadNibNamed("NavigationBarMainView", owner: self, options: nil)?.first as! NavigationBarMainView
    
    let SideMenuBar = Bundle.main.loadNibNamed("SideMenuBar", owner: self, options: nil)?.first as! SideMenuBar
    
    struct tableSection {
        let name : String
        var items : [tableItem]
    }
    struct tableItem {
        var name : String
        let image : UIImage
    }
    
    var arrayTableSections = [tableSection]()
  
//    override func viewLayoutMarginsDidChange() {
//        navigationItem.titleView?.frame = CGRect(x: 2, y: 0, width: UIScreen.main.bounds.width, height: 40)
//    }
  
   
    @objc func searchbtnaction() {
        let searchVCStoryBoard = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchVCStoryBoard.instantiateViewController(withIdentifier: "SearchVC")
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }

    @objc func filterbtnaction() {
        isfilterclicked = true
        
        tabBarController?.selectedIndex = 0
        
        
    }

    
    
    
    
    
    @IBAction func InviteBtn(_ sender: Any) {
        let items =  ["shareString".localizableString(loc: LanguageChangeCode), urlAppStore] as [ Any ]
        let activityVC = UIActivityViewController(activityItems: items , applicationActivities: [])
        //activityVC.popoverPresentationController?.sourceView = sender
        if let popoverController = activityVC.popoverPresentationController{
            popoverController.barButtonItem = sender as! UIBarButtonItem
            popoverController.permittedArrowDirections = .up
        }
        self.present(activityVC, animated:true , completion: nil)
        
        
    }
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    
    
    
    
    fileprivate func addDoneLeftBarBtn() {
        
        
        addLogoWithLeftBarButton()
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItems = [btnMenuButton, barButton ]
    }
    
    
    
    
     @IBOutlet weak var searchBarTop: UISearchBar!
    @objc func mikeTapped() {
        print("ahmed---090")
        let searchSB = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchSB.instantiateViewController(withIdentifier: "SearchVC") as! SearchVc
        searchVC.flagShowSpeechRecBox = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func addGestureToMike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(mikeTapped))
        mikeImgForSpeechRec.addGestureRecognizer(tap)
    }
    
  var isReload = false
  var controllers : [UIViewController] = [UIViewController]()
    lazy var mikeImgForSpeechRec = UIImageView(frame: CGRect(x: 0, y: 0, width: 0,height: 0))
    
    
    @IBAction func filterbtn(_ sender: Any) {
       
    
        
        isfilterclicked = true
        
        tabBarController?.selectedIndex = 0
        
        
        
    }
    func loadArrayTableSectionsWithData() {
        let itemHome : tableItem = tableItem.init(name: "Home".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "Home"))
        let itemSell : tableItem = tableItem.init(name: "Sell Now".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "Sell now"))
        let itemCat : tableItem = tableItem.init(name: "Browse Categories".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "categories_top"))
        //      let itemFilters : tableItem = tableItem.init(name: "Search Products", image: #imageLiteral(resourceName: "filterColor"))
        let itemMy : tableItem = tableItem.init(name: "My Sell4Bids".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "My Sell4Bids"))
        let itemJobs : tableItem = tableItem.init(name: "Jobs".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "Jobs"))
        let itemChat : tableItem = tableItem.init(name: "My Chat".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "chat"))
        let itemWatchList : tableItem = tableItem.init(name: "My Watch List".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "My view list"))
        let itemProfile : tableItem = tableItem.init(name: "My Profile".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "My Profile"))
        let itemNotification : tableItem = tableItem.init(name: "Notifications".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "Notification"))
        
        let itemsOfFirstSection :[tableItem] = [itemHome, itemSell, itemCat, itemMy, itemJobs, itemChat, itemWatchList, itemProfile, itemNotification]
        let sectionHome = tableSection.init(name: "Sell4Bids", items: itemsOfFirstSection)
        arrayTableSections.append(sectionHome)
        
        let itemWhatIs : tableItem = tableItem(name: "What is Sell4Bids?".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "My Sell4Bids"))
      let a = "How it Works?".localizableString(loc: LanguageChangeCode)
      let itemHowWorks : tableItem = tableItem(name: a, image: #imageLiteral(resourceName: "How it works"))
        let itemEstablishContact : tableItem = tableItem(name: "Establish Contact".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "Establish contact"))
        
        let itemsOfAboutSell4Bids : [tableItem] = [itemWhatIs, itemHowWorks, itemEstablishContact]
        let sectionAbout = tableSection.init(name: "About Sell4Bids".localizableString(loc: LanguageChangeCode), items: itemsOfAboutSell4Bids)
        arrayTableSections.append(sectionAbout)
        
        let itemTerms = tableItem(name: "Terms and conditions".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "terms and condition")  )
        let itemPolicy = tableItem(name: "Privacy Policy".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "privacy policy"))
        let itemsOfLegal = [itemTerms, itemPolicy ]
        
        let sectionLegal = tableSection.init(name: "Legal".localizableString(loc: LanguageChangeCode), items: itemsOfLegal)
        arrayTableSections.append(sectionLegal)
        
        let itemRateUs = tableItem(name: "Rate Us".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "Rate us"))
        //let itemFeedback = tableItem(name: "Give Feedback", image: #imageLiteral(resourceName: "drawer_feedback"))
        let itemShare = tableItem(name: "Share this App".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "Share"))
        let itemLogOut = tableItem(name: "Logout".localizableString(loc: LanguageChangeCode), image: #imageLiteral(resourceName: "log out"))
        let itemsOfSettingsAndFeedBack = [itemRateUs, itemShare, itemLogOut ]
        
        let sectionSettings = tableSection.init(name: "FeedBack".localizableString(loc: LanguageChangeCode), items: itemsOfSettingsAndFeedBack)
        
        arrayTableSections.append(sectionSettings)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let city = SessionManager.shared.City
        let state = SessionManager.shared.State
        let zipCode = SessionManager.shared.ZipCode
        
        titleview.citystateZIpcode.text = "\(city), \(state) \(zipCode)"
        
        isfilterclicked = false
        print("Disappear")
       
    }
    
    
  
    
//    @objc func openMenu() {
//       
//        isMenuOpen = true
//        tabBarController?.selectedIndex = 0
//        
// 
//    }
    
    
 
  override func viewDidLoad() {
    super.viewDidLoad()
   
    loadArrayTableSectionsWithData()
    
     buttonBarView.move(fromIndex: 0, toIndex: 0, progressPercentage: 1, pagerScroll: .no)

    
//    DispatchQueue.main.async {
//        self.moveToViewController(at: 5, animated: false)
//    }
    
    self.buttonBarView.addShadowView()
    self.navigationItem.titleView = titleview
    titleview.pizzaBtnWidth.constant = 0
    let country = UserDefaults.standard.string(forKey: SessionManager.shared.Country)
    titleview.citystateZIpcode.text = "\(country ?? "")"
    titleview.searchBarButton.addTarget(self, action: #selector(searchbtnaction), for: .touchUpInside)
    titleview.filterbtn.addTarget(self, action: #selector(filterbtnaction), for: .touchUpInside)
    titleview.inviteBtn.addTarget(self, action:  #selector(self.inviteBarBtnTapped), for: .touchUpInside)
    titleview.micBtn.addTarget(self, action:  #selector(mikeTapped), for: .touchUpInside)
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backBtnTapped(tapGestureRecognizer:)))
    titleview.homeImg.isUserInteractionEnabled = true
    titleview.homeImg.addGestureRecognizer(tapGestureRecognizer)
    
    
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(searchbtnaction))
    titleview.citystateZIpcode.isUserInteractionEnabled = true
    titleview.citystateZIpcode.addGestureRecognizer(tap)
    
    
 // addDoneLeftBarBtn()
   // addInviteBarButtonToTop()
    mikeImgForSpeechRec.image = UIImage(named: "mike")
    
    searchBarTop.delegate = self
    searchBarTop.setImage(mikeImgForSpeechRec.image, for: .bookmark, state: .normal)
    
//      addGestureToMike()
    
   
    
    searchBarTop.showsBookmarkButton = true
    
    
//    navigationItem.titleView = searchBarTop
    
    if (self.revealViewController()?.delegate = self) != nil {
        self.revealViewController().delegate = self
    }
    
//    btnMenuButton.target = revealViewController()
//    btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))

    
//    titleview.menuBtn.addTarget(self, action: #selector(openMenu), for: .touchUpInside); self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    
    setupMySell4BidsTopBar()
    setupViews()
   
    

  }
    
    @objc func backBtnTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.tabBarController?.selectedIndex = 0
    }
 
    
  private func setupViews() {
    //addDoneLeftBarBtn()
    //addInviteBarButtonToTop()
    
    clearBackButtonText()
    self.title = "MySell4Bids"
  }
  
 
  @objc func barBtnInNavTapped() {
    self.tabBarController?.selectedIndex = 0
  }
  func setupMySell4BidsTopBar () {
    
    changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
        
        oldCell?.label.textColor = UIColor.black
        newCell?.label.textColor = UIColor.red
        
        if animated {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
        }
        else {
            newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
   settings.style.buttonBarItemBackgroundColor =  UIColor.white
    settings.style.buttonBarItemTitleColor = UIColor.black
    let size :CGFloat = Env.isIpad ? 20 : 20
    settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: size)
    buttonBarView.selectedBar.backgroundColor = UIColor.red
   
   // buttonBarView.backgroundColor =  UIColor(red:1.00, green:0.90, blue:0.90, alpha:1.0)
  }
  // MARK: - PagerTabStripDataSource
  
   
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    
    let chatSB = getStoryBoardByName(storyBoardNames.chat)
    //My Chat
    let controllerChat = chatSB.instantiateViewController(withIdentifier: "MyChatList") as! MyChatListVC
    controllerChat.view.layer.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
    controllerChat.nav = self.navigationController
    controllerChat.flagUsedInMySell4Bids = true
    controllerChat.title = "My Chat"
    self.controllers.append(controllerChat)
  
    
    
    //My Watch List
    let watchListSB = getStoryBoardByName(storyBoardNames.myWatchListSB)
    let watchListVC = watchListSB.instantiateViewController(withIdentifier: "ActiveWatchListVc") as! ActiveWatchListVc
    watchListVC.nav = self.navigationController
    watchListVC.title = "Watch List"
    self.controllers.append(watchListVC)
    
    
    //Selling
    let controllerSelling = self.storyboard?.instantiateViewController(withIdentifier: "MySellVc") as! SellingVC
    controllerSelling.nav = self.navigationController
    controllerSelling.title = "Selling"
    self.controllers.append(controllerSelling)
    
    
  
    
    
    //Buying and Bids
    let controllerBids = self.storyboard?.instantiateViewController(withIdentifier: "BidsVc") as! BuyingAndBidsVC
    controllerBids.nav = self.navigationController
    controllerBids.title = "Buying"
    self.controllers.append(controllerBids)

    let controllerBidsItems = self.storyboard?.instantiateViewController(withIdentifier: "BidsItemsVC") as! BidsVC
    controllerBids.nav = self.navigationController
    controllerBids.title = "Bids"
    self.controllers.append(controllerBidsItems)

    
    //Bought and Wins
    let controllerBoughts = self.storyboard?.instantiateViewController(withIdentifier:"BoughtAndWinsVc") as! BoughtAndWinsVc
    controllerBoughts.nav = self.navigationController
    controllerBoughts.title = "Bought"
    self.controllers.append(controllerBoughts)
    
    //Winas
    let controllerWins = self.storyboard?.instantiateViewController(withIdentifier:"WinsVc") as! WinsVc
    controllerBoughts.nav = self.navigationController
    controllerBoughts.title = "Wins"
    self.controllers.append(controllerWins)

    //Followers
    let controllerFollowers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVc") as! FollowersVc
    controllerFollowers.nav = self.navigationController
    controllerFollowers.title = "Followers"
    self.controllers.append(controllerFollowers)

    //Following
    let controllerFollowing = self.storyboard?.instantiateViewController(withIdentifier: "FollowingVc") as! FollowingVc
    controllerFollowing.nav = self.navigationController
    controllerFollowing.title = "Following"
    self.controllers.append(controllerFollowing)

    //Block list
    let controllerBlockedUsers = self.storyboard?.instantiateViewController(withIdentifier: "BlockUserVc") as! BlockUserVc
    controllerBlockedUsers.nav = self.navigationController
    controllerBlockedUsers.title = "Block List"
    self.controllers.append(controllerBlockedUsers)
    
    
    
  
    //My profile.
//    let mainSB = getStoryBoardByName(storyBoardNames.main)
//    let myProfileVC = mainSB.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
//    myProfileVC.nav = self.navigationController
//    myProfileVC.title = "My Profile"
//    self.controllers.append(myProfileVC)
    
    
    return self.controllers
  }
  
    
 

  override func reloadPagerTabStripView() {
    isReload = true
   
    if arc4random() % 2 == 0 {
      pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
    } else {
      pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
    }
    super.reloadPagerTabStripView()
    
  }
   
    
    
}

extension mySell4BidsVC_XlPager: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVCStoryBoard = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchVCStoryBoard.instantiateViewController(withIdentifier: "SearchVC")
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.pushViewController(searchVC, animated: true)
        
        return false
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        mikeTapped()
    }
}


