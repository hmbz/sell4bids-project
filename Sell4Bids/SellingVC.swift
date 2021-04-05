//
// MySellVc.swift
//  Sell4Bids
//
//  Created by admin on 10/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip
import SwiftyJSON
import Alamofire

class SellingVC: UIViewController , IndicatorInfoProvider   {
    
    //MARK: - Properties
    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var imgVNoProduct: UIImageView!
    @IBOutlet weak var emptyProductMessage: UILabel!
    
    //MARK:- Variable.
    var MainApis = MainSell4BidsApi()
    var countryCode = String()
    var numberOfColumns : CGFloat = {
        if UIDevice.current.userInterfaceIdiom == .pad { return 3 }
        else { return 2}
    }()
    var mySellArray : [ProductModel] = []
    var MySelling = [sellingModel]()
    private let leftAndRightPaddings: CGFloat = 6.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 30.0
    var nav:UINavigationController?
    lazy var responseStatus = false
    lazy var orderArray = [orderModel]()
    lazy var offerArray = [offerModel]()
    lazy var MyCollectionViewCellId: String = "productCollectionViewCell"
    lazy var imageInfoArray = [ImageInfoModel]()
    lazy var productArray = [productModelNew]()
    lazy var bottomBar =  false
    
    // For implementing the Transition
    // Will implement in future...for transition
    let transition = TransitionAnimator()
    var selectedCell = UICollectionViewCell()
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeCollectionView()
        topMenu()
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        self.collView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
//        getSellingData()
        if bottomBar == true {
            self.tabBarController?.tabBar.isHidden = true
        }
        navigationController?.navigationBar.barTintColor = UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        self.productArray.removeAll()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSellingData()
      
    }
    
   
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Selling"
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
    
    
    
    
    
    //MARK:-  Private Functions
    
    private func  getSellingData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
            }
        }
        let url = "\(MainApis.IP)\(MainApis.sellingItem)"
        let start = productArray.count
        let userId = SessionManager.shared.userId
        let body:[String:Any] = ["uid": userId , "country" : "USA", "start" : start , "limit" : "30"  , "type" : "owner"]
        print(body)
        Networking.instance.postApiCall(url: url, param: body,completionHandler: { (response, Error, StatusCode) in
            if Error == nil{
                self.responseStatus = true
                do{
                    if let jsonDic = response.dictionary{
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
                        }
                      
                    }
                    print(self.productArray)
                  if self.productArray.count <= 0{
                   self.hideCollectionView(hideYesNo: true)
                  }else{
                     self.hideCollectionView(hideYesNo: false)
                    self.collView.reloadData()
                                     self.fidgetImageView.isHidden = true
                                     self.DimView.isHidden = true
                    
                  }
                 
                    
              }
            }else{
                 print("Error")
            }
           
        })
    }
    
    
    //MARK:- Add Cancel button on left side in Navigationbar.
    private func setupLeftBarBtns() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
    }
    
    
    //Mark:- Hide collection view depands on boolean value.
    func hideCollectionView(hideYesNo : Bool) {
        
        emptyProductMessage.text = "Items you list for sale, appear here".localizableString(loc: LanguageChangeCode)
        if hideYesNo == false {
            collView.isHidden = false
            imgVNoProduct.isHidden = true
            fidgetImageView.isHidden = false
            fidgetImageView.image = nil
            emptyProductMessage.isHidden = true
        }
        else  {
            fidgetImageView.isHidden = true
            fidgetImageView.image = nil
            collView.isHidden = true
            imgVNoProduct.isHidden = false
            emptyProductMessage.isHidden = false
        }
    }
    
    //Mark:- customize Padding, widht and height.
    func customizeCollectionView(){
        //custom collectionView Cell size
        
        let bounds = UIScreen.main.bounds
        
        var width = (bounds.size.width / numberOfColumns ) - (leftAndRightPaddings * 2)
        let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
        //layout.itemSize = CGSize(width, width + heightAdjustment)
        if UIDevice.current.userInterfaceIdiom == .phone {
            width = width - 1
        }
        layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
    }
    
    // Change by Osama Mansoori
    
    //Mark:- Set title on Top Slide bar
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo.init(title: "SellingTab".localizableString(loc: LanguageChangeCode))
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SellingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Mark: - define number of section in  collectionview.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Mark:- define numnber of items in collectionview.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  productArray.count
    }
    
    //Mark:- define cell for collectionview and define it properties.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! productCollectionViewCell
        
        guard indexPath.row < productArray.count else {return cell}
        cell.setupDataIntheCollectionView(product: productArray[indexPath.row])
        if productArray[indexPath.row].adminRejected?.lowercased() == "rejected" {
            cell.rejectedLbl.isHidden = false
            cell.rejectedLbl.text = "Declined"
        }
        else if productArray[indexPath.row].adminRejected?.lowercased() == "pending"{
            cell.rejectedLbl.isHidden = false
            cell.rejectedLbl.text = "Pending"
        }
        else {
            cell.rejectedLbl.isHidden = true
        }
        cell.getButtonText(product: productArray[indexPath.item])
        return cell
        
    }
    //Mark:- When user select any item in collection view this function called.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let instance = productArray
         guard indexPath.row < instance.count else {return}
         let Category = instance[indexPath.row].itemCategory
         selectedCell = collView.cellForItem(at: indexPath) as! productCollectionViewCell
         if Category?.lowercased() == "jobs" {
              let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
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
              let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
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
              let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
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
              
              let storyBoard_ = UIStoryboard.init(name: "Description" , bundle: nil)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let start = productArray.count
        if indexPath.row == start - 1 {  //numberofitem count
            self.getSellingData()
        }
    }
    
}
// Implemented in future........ for transition

extension SellingVC: UIViewControllerTransitioningDelegate {

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



