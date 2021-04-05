//
//  CategoryVC.swift
//  Sell4Bids
//
//  Created by admin on 9/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {
    
    //MARK:- Properties and outlets
    @IBOutlet var productColView: UICollectionView!
    @IBOutlet var shadowView: UIView!
    @IBOutlet var fidgetSpinner: UIImageView!
    
    //MARK:- Variables
    lazy var catName = ""
    lazy var responseStatus = false
    lazy var MainApis = MainSell4BidsApi()
    lazy var currentCountry = ""
    lazy var currentLongitude = ""
    lazy var currentLatitude = ""
    lazy var searchText = ""
    lazy var orderArray = [orderModel]()
    lazy var offerArray = [offerModel]()
    lazy var MyCollectionViewCellId: String = "productCollectionViewCell"
    lazy var ApiDic:[String:Any] = [:]
    let transition = TransitionAnimator()
    var selectedCell = UICollectionViewCell()
    
    //Model Arrays.
    lazy var imageInfoArray = [ImageInfoModel]()
    lazy var productArray = [productModelNew]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        productColView.delegate = self
        productColView.dataSource = self
        self.tabBarController?.tabBar.isHidden = true
        topMenu()
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        self.productColView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        let body:[String:Any] = ["start": "\(0)", "lng": self.currentLongitude, "country": self.currentCountry, "lat": self.currentLatitude, "limit": "25","itemCategory": self.catName,"title": searchText]
        self.ApiDic = body
        self.getProductData(param: self.ApiDic)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // hiding the cell when the View disappesrs for transition purpose
    }
    
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = catName + searchText
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        let tapImg = UITapGestureRecognizer(target: self, action: #selector(homeBtnTapped(sender:)))
        titleview.homeImg.addGestureRecognizer(tapImg)
        titleview.homeImg.isUserInteractionEnabled = true
        self.navigationItem.hidesBackButton = true
    }
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.productArray.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let mainSB = getStoryBoardByName(storyBoardNames.main)
        let initialViewController = mainSB.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    //MARK:- Functions
    private func  getProductData(param: [String:Any]){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetSpinner.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetSpinner, view: self.shadowView)
            }
        }
        Networking.instance.postApiCall(url: getFilterUrl, param: param) { (response, error, statusCode) in
            print(response)
            let responseStatus = response["status"].bool ?? false
            if responseStatus {
               guard let jsonDic = response.dictionary else {return}
               let status = jsonDic["status"]?.bool ?? false
               let totalCount = jsonDic["totalCount"]?.int ?? -1
               let messageArray = jsonDic["message"]?.array ?? ["N/A"]
               let msg = jsonDic["message"]?.string ?? ""
               if msg != "" {
                   print(msg)
               }
               //Main Array
               for item in messageArray {
                   //Main Dictionary
                   guard let MessageDic = item.dictionary else {return}
                   let adminRejected = MessageDic["admin_verify"]?.string ?? ""
                   let locDic = MessageDic["loc"]?.dictionary
                   let coordinates = locDic?["coordinates"]?.array ?? []
                   let type = locDic?["type"]?.string ?? ""
                   
                   let ImagePath = MessageDic["images_path"]?.arrayObject ?? []
                   let ImagePathSmall = MessageDic["images_small_path"]?.arrayObject ?? []
                   
                   //Array for Getting Image Info
                   self.imageInfoArray.removeAll()
                   let imagesInfoArray = MessageDic["images_info"]?.array ?? []
                   if imagesInfoArray.count > 0 {
                       for itemImages in imagesInfoArray {
                           let ImageInfoDic = itemImages.dictionary
                           let height = ImageInfoDic?["height"]?.float ?? -1
                           let ratio = ImageInfoDic?["ratio"]?.float ?? -1
                           let width = ImageInfoDic?["width"]?.float ?? -1
                           let obj = ImageInfoModel.init(height: height, ratio: ratio, width: width)
                           self.imageInfoArray.append(obj)
                       }
                   }
                   let startTime = MessageDic["startTime"]?.int64 ?? -1
                   let visibility = MessageDic["visibility"]?.bool ?? false
                   let oldSmallImages = MessageDic["old_small_images"]?.arrayObject ?? []
                   let oldImages = MessageDic["old_images"]?.arrayObject ?? []
                   let itemId = MessageDic["_id"]?.string ?? ""
                   let chargeTime = MessageDic["chargeTime"]?.int64 ?? -1
                   let city = MessageDic["city"]?.string ?? ""
                   let title = MessageDic["title"]?.string ?? ""
                   let startPrice = MessageDic["startPrice"]?.float ?? 0.0
                   let itemCategory = MessageDic["itemCategory"]?.string ?? ""
                   let zipcode = MessageDic["zipcode"]?.int ?? -1
                   let itemAuctionType = MessageDic["itemAuctionType"]?.string ?? ""
                   let uid = MessageDic["uid"]?.string ?? ""
                   let condition = MessageDic["condition"]?.string ?? ""
                   let endTime = MessageDic["endTime"]?.int64 ?? -1
                   let quantity = MessageDic["quantity"]?.int ?? -1
                   let state = MessageDic["state"]?.string ?? ""
                   let currencyString = MessageDic["currency_string"]?.string ?? ""
                   let currencySymbol = MessageDic["currency_symbol"]?.string ?? ""
                   
                   let object = productModelNew.init(status: status, totalCount: totalCount, coordinates: coordinates, type: type, ImagePath: ImagePath, ImagePathSmall: ImagePathSmall, imageInfoArray: self.imageInfoArray, startTime: startTime, visibility: visibility, oldSmallImages: oldSmallImages, oldImages: oldImages, itemId: itemId, chargeTime: chargeTime, city: city, title: title, startPrice: startPrice, itemCategory: itemCategory, zipcode: zipcode, itemAuctionType: itemAuctionType, uid: uid, condition: condition, endTime: endTime, quantity: quantity, state: state, currencyString: currencyString, currencySymbol: currencySymbol, adminRejected: adminRejected)
                   self.productArray.append(object)
                self.reloadCollectionView()
                self.responseStatus = true
                self.productColView.isHidden = false
                Spinner.stop_Spinner(image: self.fidgetSpinner, view: self.shadowView)
               }
            }
            else{
                if error?.contains("The request timed out.") ?? false{
                   self.responseStatus = true
                    Spinner.stop_Spinner(image: self.fidgetSpinner, view: self.shadowView)
                    showSwiftMessageWithParams(theme: .info, title: "\(statusCode)", body: error ?? "")
                }else {
                    self.responseStatus = true
                    self.productColView.isHidden = false
                    Spinner.stop_Spinner(image: self.fidgetSpinner, view: self.shadowView)
                  showSwiftMessageWithParams(theme: .info, title: appName, body: "StrServerError".localizableString(loc: LanguageChangeCode))
                }
            }
        }
    }
    
    private func reloadCollectionView() {
        print("Reloading Collection view")
        if let layout = productColView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.flagKeepHeaderHeightForHomeLayout = false
        }
        let layout = self.productColView.collectionViewLayout as! PinterestLayout
        layout.prepare()
        layout.cache.removeAll()
        DispatchQueue.main.async {
            self.productColView.reloadData()
        }
 
    }
}
//MARK:- Collection View Stub Functions
extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = productColView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! productCollectionViewCell
            let instance = self.productArray
            guard indexPath.row < instance.count else {return cell}
            cell.setupDataIntheCollectionView(product: instance[indexPath.row])
            cell.getButtonText(product: instance[indexPath.item])
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let instance = self.productArray
        guard indexPath.row < instance.count else {return}
        let Category = instance[indexPath.row].itemCategory
          selectedCell = productColView.cellForItem(at: indexPath) as! productCollectionViewCell
        if Category?.lowercased() == "jobs" {
            let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
            let controller = storyBoard_.instantiateViewController(withIdentifier: "JobsDetailVC") as! JobsDetailVC
            controller.ImageArray = instance[indexPath.row].ImagePath as! [String]
            controller.itemName = instance[indexPath.row].title
            controller.itemId = instance[indexPath.row].itemId
            controller.sellerId = instance[indexPath.row].uid
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        else if Category?.lowercased() == "services" {
            let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
            let controller = storyBoard_.instantiateViewController(withIdentifier: "ServiceDetailVC") as! ServiceDetailVC
            controller.ImageArray = instance[indexPath.row].ImagePath as! [String]
            controller.itemName = instance[indexPath.row].title
            controller.itemId = instance[indexPath.row].itemId
            controller.sellerId = instance[indexPath.row].uid
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        else if Category?.lowercased() == "vehicles" {
            let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
            let controller = storyBoard_.instantiateViewController(withIdentifier: "VehicleDetailVC") as! VehicleDetailVC
            controller.ImageArray = instance[indexPath.row].ImagePath as! [String]
            controller.itemName = instance[indexPath.row].title
            controller.itemId = instance[indexPath.row].itemId
            controller.sellerId = instance[indexPath.row].uid
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        else if Category?.lowercased() == "housing" {
            
            let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
            let controller = storyBoard_.instantiateViewController(withIdentifier: "HousingDetailVC") as! HousingDetailVC
            controller.ImageArray = instance[indexPath.row].ImagePath as! [String]
            controller.itemName = instance[indexPath.row].title
            controller.itemId = instance[indexPath.row].itemId
            controller.sellerId = instance[indexPath.row].uid
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        else {
            let storyBoard_ = UIStoryboard.init(name: sell4bidsStoryBoard.instance.descrioption , bundle: nil)
            let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
            controller.itemName = instance[indexPath.row].title
            controller.itemId = instance[indexPath.row].itemId
            controller.sellerId = instance[indexPath.row].uid
            controller.ImageArray = instance[indexPath.row].ImagePath as! [String]
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.productColView.infiniteScrollTriggerOffset = 10
        scrollView.infiniteScrollTriggerOffset = 500
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height  // Change 10.0
        //Change 10.0 to adjust the distance from bottom
        if scrollView == productColView {
            if maximumOffset - currentOffset <= 3000 {
                let start = self.productArray.count
                self.ApiDic["start"] = "\(start)"
                print(self.ApiDic)
                self.getProductData(param: self.ApiDic)
            }
        }
    }
}
//MARK:- PinterstLayout Delegate
extension CategoryVC: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        var ratio = Float()
        var height : CGFloat = 0
        var title = String()
        let width = CGFloat(UIScreen.main.bounds.width) / 3
        let productsArray = self.productArray
        if productsArray[indexPath.row].imageInfoArray?.count ?? 0 > 0 {
            ratio = productsArray[indexPath.row ].imageInfoArray![0].ratio!
        }else {
            ratio = 1
        }
        title = productsArray[indexPath.row].title!
        height = width  / CGFloat(ratio)
        let btnHeight : CGFloat = 50
        let numberOfColumns = 3
        let insets = collectionView.contentInset
        let contentWidth = collectionView.bounds.width - (insets.left + insets.right)
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        let font = UIFont.boldSystemFont(ofSize: 17)
        let estimatedHeight = title.height(withConstrainedWidth: columnWidth, font: font)
        return height + estimatedHeight + btnHeight
    }
}
extension CategoryVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let originFrame = selectedCell.superview?.convert(selectedCell.frame, to: nil) else {
            return transition
        }
        transition.originFrame = originFrame
        transition.presenting = true
//        selectedCell.isHidden = true
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
