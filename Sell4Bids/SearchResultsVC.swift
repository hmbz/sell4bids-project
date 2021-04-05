/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import AVFoundation
import Alamofire
import SDWebImage
import SwiftyJSON
import Firebase
import UIScrollView_InfiniteScroll

typealias Completion = (Bool) -> ()

class SearchResultsVC: UIViewController {
  
  @IBOutlet weak var noResultsView: NoResultsView!
  @IBOutlet weak var fidget: UIImageView!
    let  downloader = SDWebImageDownloader(sessionConfiguration: URLSessionConfiguration.ephemeral)
  @IBOutlet weak var collectionView: UICollectionView!
  var products = [Products]()
     var productObj = ProductModel()
  var searchText : String?
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  @IBOutlet weak var viewDim: UIView!
  var totalitemsToProcess = Int()
  var NumOfProductsProcessed = 0
  var flagShowFidget = false
   // var productObj : ProductModel?
  var dbref = FirebaseDB.shared.dbRef
    var MainApis = MainSell4BidsApi()
var visibleIndexPath: IndexPath? = nil
    lazy var orderArray = [orderModel]()
    lazy var offerArray = [offerModel]()
   
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
  
    addLogoWithLeftBarButton()
    setupViews()
    showFidgetAfter2Seconds()
//    downloadAndShowData()
    getSearchData()
    setupButtonsOfNoResultsView()
//
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
       
    }
  
  func showFidgetAfter2Seconds(){
    
    if #available(iOS 10.0, *) {
      Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] (timer) in
        guard let this = self else { return }
        DispatchQueue.main.async {
          this.fidget.isHidden = !this.flagShowFidget
        }
      }
    } else {
      // Fallback on earlier versions
    }
  }
  
  func setupViews() {
    if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
      layout.flagKeepHeaderHeightForHomeLayout = false
      layout.delegate = self
    }
    view.backgroundColor = UIColor.white
    self.title = self.searchText
    collectionView?.backgroundColor = UIColor.white
    collectionView?.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    view.backgroundColor = UIColor.white
    
    
    
  }
  
  private func setupButtonsOfNoResultsView() {
    noResultsView.btnleft.setTitle("Home", for: .normal)
    noResultsView.btnRight.setTitle("Change", for: .normal)
    noResultsView.btnleft.addTarget(self, action: #selector(btnLeftNoResultsTapped), for: .touchUpInside)
    noResultsView.btnRight.addTarget(self, action: #selector(btnRightNoResultsTapped), for: .touchUpInside)
  }
  
  @objc private func btnLeftNoResultsTapped() {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  @objc private func btnRightNoResultsTapped() {
    self.navigationController?.popViewController(animated: true)
  }

    
    func getSearchData(){
       
      
        let start = products.count
        
        MainApis.filter_Api(lat: SessionManager.shared.latitude,long: SessionManager.shared.longitude,country: gpscountry, itemAuctionType:"", itemCategory: "", condition: "", title: searchText!, city: "", start: "\(start)",limit:"21", min_price: "", max_price: "" , completionHandler: { (status, swifymessage, error) in
            print("Called = Yes")
            //    self.toggleDimBack(false)
            let message = swifymessage!["message"].arrayValue
          
            
            self.reloadColView()
            if status {
               
                
                for items in message {
                
                    let loc = items["loc"]
                    let total_count = items["total_count"].intValue
                    let quantity = items["quantity"].doubleValue
                    let cordinates = loc["coordinates"].arrayValue
                    let type = loc["type"].stringValue
                    let itemid = items["_id"].stringValue
                    let title = items["title"].stringValue
                    let startPrice = items["startPrice"].doubleValue
                    let itemCategory = items["itemCategory"].stringValue
                    let zipcode = items["zipcode"].stringValue
                    let itemAuctionType = items["itemAuctionType"].stringValue
                    let currency_symbol = items["currency_symbol"].stringValue
                    let chargeTime = items["chargeTime"].stringValue
                    let uid = items["uid"].stringValue
                    let image0_small = items["old_small_images"].arrayValue
                    let imageex_small = items["old_small_images"].arrayObject
                    let image1_small = items["old_images"].arrayObject
                    let image2_small = items["old_images"].arrayValue
                    let item_seller = items["item"].stringValue
                    let item_start_time = items["startTime"].int64Value
                    let item_longtitude = loc[0].doubleValue
                    let item_latitude = loc[1].doubleValue
                    let item_condition = items["condition"].stringValue
                    let item_endtime = items["endTime"].int64Value
                    let item_city = items["city"].stringValue
                    let item_state = items["state"].stringValue
                    let images_info = items["images_info"]
                    let currency_string = items["currency_string"].stringValue
                    let isListedEnded = items["listingEnded"].boolValue
                    
                    var image0 = String()
                    
                    
                    if image2_small.count > 0 {
                        image0 = (image2_small[0].stringValue)
                        
                    }
                    
                    print("Category ==\(itemCategory)")
                    
                    
                    let products = Products.init(total_count: total_count, status: status, quantity: quantity, item_id: itemid, old_images: image1_small as! [String], item_title: title, item_category: itemCategory, item_zipcode: zipcode, item_latitude: item_latitude, item_longtitude: item_longtitude, item_seller_id: uid, item_start_time: item_start_time, old_small_images: imageex_small as! [String], item_auction_type: itemAuctionType, item_condition: item_condition, item_endTime: item_endtime, item_city: item_city, item_state: item_state, item_startPrice: startPrice , currency_symbol: currency_symbol , currency_string: currency_string, isListingEnded: isListedEnded)
                    
                    
                    for images_info_value in images_info {
                        
                        products.item_image_height = images_info_value.1["height"].floatValue
                        products.item_image_width = images_info_value.1["width"].floatValue
                        products.item_image_ratio = images_info_value.1["ratio"].floatValue
                        print("Image Info Values == \(images_info_value.1["width"].floatValue)")
                    }
                    
                    
                    self.products.append(products)
                     self.reloadColView()
                    DispatchQueue.main.async {
                        
                        products.item_image.image =   #imageLiteral(resourceName: "emptyImage")
                        
                        
                        
                       
                    }
                    
                    
                    
                    
                    var imageUrlToUse : URL?
                    if products.old_images.count > 0 {
                        let urlStr = products.old_images[0]
//                        let url = URL.init(string: urlStr as! String)
//                        imageUrlToUse = url
//                        let scale = UIScreen.main.scale
//                        //                        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: CGFloat(products.item_image_width) * scale, height: CGFloat(products.item_image_height) * scale ))
//
//                        products.item_image.kf.indicatorType = .activity
//
                        products.item_image.sd_setImage(with: URL(string:urlStr ), placeholderImage: #imageLiteral(resourceName: "emptyImage"))
//                            with: url,
//                            placeholder: UIImage(named: "placeholderImage"),
//                            options: [
//                                //                                .processor(resizingProcessor),
//                                //                                .scaleFactor(UIScreen.main.scale),
//                                .transition(.fade(1)),
//                                .cacheOriginalImage
//                            ])
//                        //
//                        //                        {
//                        //                            result in
//                        //                            switch result {
//                        //                            case .success(let value):
//                        //                                print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                        //                            case .failure(let error):
//                        //                                print("Job failed: \(error.localizedDescription)")
//                        //                            }
//                        //                        }
//                        //
//                        //print("i in outside : \(i)")
//                        //print("image url is \(imageUrl)")
//
//
//
                        
                        
                    }
                }
                
                
            }
            
            if error.contains("The network connection was lost"){
              
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                
               
                self.present(alert, animated: true, completion: nil)
                
                
            }
            
            if error.contains("The Internet connection appears to be offline.") {
              
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
            if error.contains("A server with the specified hostname could not be found."){
               
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                
                
                self.present(alert, animated: true, completion: nil)
            }
            
            if error.contains("The request timed out.") {
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
               
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        })
        
        
        
        
    }

    
    
    

    
  
  
  func toggleHideNoResults(flag: Bool) {
    DispatchQueue.main.async {
      self.noResultsView.isHidden = flag
    }
  }
  
//    fileprivate func downloadAndSaveImages ( completion: @escaping (Bool) -> () ) {
//
//
//    }
  
  func reloadColView() {
    let layout = self.collectionView?.collectionViewLayout as? PinterestLayout
    layout?.delegate = self
    layout?.cache.removeAll()
    self.collectionView?.reloadData()
  
    layout?.invalidateLayout()
  }
  //helpers
  func dimBack(flag: Bool) {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.3, animations: {
        //self.viewDim.alpha = flag ? 0.3 : 0
        
      })
    }
  }

  func showFidget(flag : Bool) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
         self.fidget.isHidden = !flag
    }
    
    
  }
  
}

//MARK:- UICollectionViewDataSource, UICollectionViewDelegate
extension SearchResultsVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return self.products.count
  }
  
    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        let objDateformat: DateFormatter = DateFormatter()
        objDateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strTime: String = objDateformat.string(from: dateToConvert as Date)
        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath as IndexPath) as! AnnotatedPhotoCell
    
    

    let product = products[indexPath.item]
    cell.mainImageView.image = products[indexPath.row].item_image.image
    
    if product.old_images.count > 0 {
        if let _ = URL.init(string: product.old_images[0]) {
            cell.mainImageView.sd_setImage(with: URL(string: product.old_images[0]), placeholderImage: #imageLiteral(resourceName: "placeholder") )
        }else {
            cell.mainImageView.image = #imageLiteral(resourceName: "emptyImage")
        }
    }
    
    
    
    
    
    cell.mainBidNowBtn.addTarget(self, action: #selector(bidNowBuyNowBtnTapped(_:)), for: .touchUpInside)
    cell.mainBidNowBtn.tag = indexPath.row
    
    cell.layer.cornerRadius = 12
    cell.mainBidNowBtn.tag = indexPath.item
    cell.layer.masksToBounds = true
    cell.mainContainerView.addShadow()

    print("will Appear = \(willAppear)")
    
    cell.mainBidNowBtn.addShadowView()
    
    cell.mainImageView.sd_setShowActivityIndicatorView(true)
    cell.titleLabel.text = products[indexPath.row].item_title
    
    
    let now = NSDate()
    let nowTimeStamp : Int64 = Int64(self.getCurrentTimeStampWOMiliseconds(dateToConvert: now))!
    print(nowTimeStamp)
    print("nowTimeStamp == \(nowTimeStamp)")
    let timestamp = Date().currentTimeMillis()
    print("timestamp == \(timestamp)")
    let timeRemaining = (product.item_endTime - timestamp)
    print("TimeRemaining == \(timeRemaining)")
    
    
    DispatchQueue.main.async {
        
        
        let doubleStr = String(format: "%.0f", product.item_startPrice)
        
        if product.item_auction_type == "buy-it-now"{
            
            let doubleStr = String(format: "%.0f", product.item_startPrice)
            
            if (product.item_category != "Jobs"){
                cell.mainBidNowBtn.setTitle("Buy at \(product.currency_string) \(doubleStr)", for: .normal)
            }else{
                cell.mainBidNowBtn.setTitle("Apply Now", for: .normal)
            }
            
            if (product.quantity == 0) && (product.item_category != "Jobs"){
                if (product.item_endTime) != -1 && (product.item_category != "Services"){
                    cell.mainBidNowBtn.setTitle("Sold at \(product.currency_string) \(doubleStr)", for: .normal)
                }else{
                    cell.mainBidNowBtn.setTitle("Buy at \(product.currency_string) \(doubleStr)", for: .normal)
                }
            }else {
                print("No Item Found")
            }
        }else if product.item_auction_type == "reserve" || product.item_auction_type == "non-reserve" {
            cell.mainBidNowBtn.setTitle("Bid at \(product.currency_string) \(doubleStr)", for: .normal)
        }
        
    }
    
    DispatchQueue.main.async {
        //[SERVICES]
        /*Services are always not dependent on Stock*/
        if (product.item_category.lowercased() == "services"){
            
            if (timeRemaining == 0 || timeRemaining < -1){
                
                return cell.mainBidNowBtn.backgroundColor = UIColor.lightGray
                
            }else{
                
                return cell.mainBidNowBtn.backgroundColor = UIColor.red
                
            }
            
        }
        else if product.item_auction_type == "buy-it-now"{
            if product.item_endTime == -1{
                return cell.mainBidNowBtn.backgroundColor = UIColor.red
            }
            if product.quantity == 0 && product.item_category.lowercased() != "jobs"{
                return cell.mainBidNowBtn.backgroundColor = UIColor.lightGray
            }
            if (timeRemaining == 0 || timeRemaining < -1){
                
                return cell.mainBidNowBtn.backgroundColor = UIColor.lightGray
                
            }
        }
        else if product.item_auction_type == "reserve"{
            if (product.item_endTime < -1){
                
                return cell.mainBidNowBtn.backgroundColor = UIColor.lightGray
                
            }
            return cell.mainBidNowBtn.backgroundColor = UIColor.red
        }
            
        else if product.item_auction_type == "non-reserve"{
            if (timeRemaining < -1){
                
                return cell.mainBidNowBtn.backgroundColor = UIColor.lightGray
            }
            return cell.mainBidNowBtn.backgroundColor = UIColor.red
        }
        return cell.mainBidNowBtn.backgroundColor = UIColor.red
    }
    
    return cell
    
  }
  
  @objc func bidNowBuyNowBtnTapped( _ sender : UIButton ) {
    
    let indexPath = IndexPath.init(row: sender.tag, section: 0)
    guard let delegate = collectionView.delegate else { return  }
    delegate.collectionView!(collectionView, didSelectItemAt: indexPath)
    
  }
  
  func returnButtonColor(forProduct: ProductModel) -> UIColor {
    let colorRed = UIColor(red:255/255, green:27/255, blue:34/255, alpha:0.8)
    guard let timeRemaining = forProduct.timeRemaining , let endTime = forProduct.timeRemaining else {
      return colorRed
    }
    if timeRemaining < 0  && endTime != -1 {
      return UIColor(red:184/255, green:184/255, blue:184/255, alpha:1)
    }
    else {
      return  colorRed
    }
  }
    
    
    @objc func BidNowBtn() {
    
    }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    
    
  
    MainApis.Item_Details(uid: SessionManager.shared.userId, country: gpscountry, seller_uid: products[indexPath.row].item_seller_id, item_id: products[indexPath.row].item_id) { (status, swifymessage, error) in
        
        if status {
            Spinner.stop_Spinner(image: self.fidget, view: self.viewDim)
            let jobApplied = swifymessage!["jobApplied"].boolValue
            print("userid.. = \(SessionManager.shared.userId)")
            
            let message = swifymessage!["message"]
            print("message1 = \(message)")
            
            for msg in message {
                //Item Object
                let itemCategory = msg.1["itemCategory"].stringValue
                let itemAuctionType = msg.1["itemAuctionType"].stringValue
                
                
                //Services Object
                if itemCategory.contains("Services") {
                    
                    print("Get_ServiceDetailView_Item == \(itemCategory)")
                    // Service Detail View
                    let startPrice = msg.1["startPrice"].intValue
                    let visibility = msg.1["visibility"].boolValue
                    let image_0 = msg.1["old_images"]
                    var image_array = [String]()
                    for image in image_0 {
                        image_array.append(image.1.stringValue)
                    }
                    let chargeTime = msg.1["chargeTime"].int64Value
                    let token = msg.1["token"].stringValue
                    let description = msg.1["description"].stringValue
                    let uid = msg.1["uid"].stringValue
                    let watchingbool = swifymessage!["watching"].boolValue
                    let itemKey = msg.1["_id"].stringValue
                    let loc = msg.1["loc"]
                    let corrdinate = loc["coordinates"]
                    let id = msg.1["_id"].stringValue
                    
                    var watch_uid = String()
                    var watch_token = String()
                    var ItemimagesArr = [String]()
                    
                    let itemAuctionType = msg.1["itemAuctionType"].stringValue
                    let country_code = msg.1["country_code"].stringValue
                    let startTime = msg.1["startTime"].stringValue
                    let timeRemaining = msg.1["timeRemaining"].int64Value
                    let title = msg.1["title"].stringValue
                    let watching = msg.1["watching"]
                    for watch in watching {
                        let watch_uidvalue = watch.1["uid"].stringValue
                        let watch_tokenvalue = watch.1["token"].stringValue
                        watch_uid = watch_uidvalue
                        watch_token = watch_tokenvalue
                        
                    }
                    let zipcode = msg.1["zipcode"].stringValue
                    let city = msg.1["city"].stringValue
                    let endTime = msg.1["endTime"].int64Value
                    let state = msg.1["state"].stringValue
                    let autoReList = msg.1["autoReList"].boolValue
                    let acceptOffers = msg.1["acceptOffers"].boolValue
                    var latitude = Double()
                    var londtitude = Double()
                    let itemimages = msg.1["old_images"]
                    let coordinates = loc["coordinates"].array
                    for itemimg in itemimages {
                        ItemimagesArr.append(itemimg.1.stringValue)
                        print("Item Image Url Backhand == \(itemimg.1.stringValue)")
                    }
                    let serviceType = msg.1["serviceType"].stringValue
                    let servicePrice = msg.1["servicePrice"].stringValue
                    let negotiable = msg.1["negotiable"].boolValue
                    let userRole = msg.1["userRole"].stringValue
                    let image = msg.1["old_images"]
                    var imageArray = [String]()
                    for img in image {
                        imageArray.append(img.1.stringValue)
                    }
                    let ordering = msg.1["ordering"].boolValue
                    let quantity = msg.1["quantity"].intValue
                    let currency_string = msg.1["currency_string"].stringValue
                    let currency_symbol = msg.1["currency_symbol"].stringValue
                    let admin_verify = msg.1["admin_verify"].stringValue
                    self.orderArray.removeAll()
                    self.offerArray.removeAll()
                    let OrderArray = msg.1["orders"].arrayValue
                    for item in OrderArray {
                        guard let OrderDic = item.dictionary else {return}
                        let orderId = OrderDic["_id"]?.string ?? ""
                        let sellerId = OrderDic["seller_uid"]?.string ?? ""
                        let buyerOfferCount = OrderDic["buyerOfferCount"]?.int ?? -1
                        let offersTypeArray = OrderDic["offers"]?.array ?? []
                        for item in offersTypeArray {
                            guard let Dic = item.dictionary else {return}
                            let message = Dic["message"]?.string ?? ""
                            let role = Dic["role"]?.string ?? ""
                            let price = Dic["price"]?.string ?? ""
                            let quantity = Dic["quantity"]?.string ?? ""
                            let time = OrderDic["time"]?.string ?? ""
                            let object = offerModel.init(message: message, role: role, price: price, quantity: quantity, time: time)
                            self.offerArray.append(object)
                        }
                        print(self.offerArray)
                        let obj = orderModel.init(orderId: orderId, sellerId: sellerId, OfferCount: buyerOfferCount, OfferArray: self.offerArray)
                        self.orderArray.append(obj)
                    }
                    print(self.orderArray)
                    
                    latitude = coordinates![1].doubleValue
                    londtitude = coordinates![0].doubleValue
                    
                    let ServiceDetail = sellingModel.init(id: id, latitude: latitude, longtitude: londtitude, chargeTime: chargeTime, images_path: imageArray, images_small_path: image_array, startTime: Int64(startPrice), visibility: visibility, old_small_images: ItemimagesArr, image: imageArray, token: token, country_code: country_code, city: city, title: title, startPrice: startPrice, itemCategory: itemCategory, uid: uid, description: description, endTime: endTime, currency_string: currency_string, currency_symbol: currency_symbol, autoReList: autoReList, acceptOffers: acceptOffers, platform: "iOS", item_id: itemKey, state: state, userRole: userRole, negotiable: negotiable, serviceType: serviceType, servicePrice: servicePrice, timeRemaining: timeRemaining, ordering: ordering , quantity: quantity, zipcode: zipcode , OrderArray: self.orderArray , itemAuctionType: itemAuctionType , admin_verify: admin_verify)
                    
                    
                    self.tabBarController?.tabBar.isHidden = false
                    
                    let storyBoard_ = UIStoryboard.init(name: storyBoardNames.ServiceDetails , bundle: nil)
                    let controller = storyBoard_.instantiateViewController(withIdentifier: "ServiceDetailView-Identifier") as! ServiceDetailView
                    controller.selectedProduct_Service = ServiceDetail
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    
                    
                }
                    
                else if itemCategory.contains("Jobs") {
                    
                    print("Get_JobsDetailView_Item == \(itemCategory)")
                    let employmentType = msg.1["employmentType"].stringValue
                    let autoReList = msg.1["autoReList"].boolValue
                    let itemAuctionType = msg.1["itemAuctionType"].stringValue
                    let old_images = msg.1["old_images"]
                    let loc = msg.1["loc"]
                    let coordinates = loc["coordinates"].array
                    var old_images_array = [String]()
                    for oldimages in old_images {
                        old_images_array.append(oldimages.1.stringValue)
                    }
                    let payPeriod = msg.1["payPeriod"].stringValue
                    let state = msg.1["state"].stringValue
                    let companyName = msg.1["companyName"].stringValue
                    let startPrice = msg.1["startPrice"].int64Value
                    let image = msg.1["old_images"]
                    var imageArray = [String]()
                    for img in image {
                        imageArray.append(img.1.stringValue)
                    }
                    let acceptOffers = msg.1["acceptOffers"].boolValue
                    let zipcode = msg.1["zipcode"].stringValue
                    let quantity = msg.1["quantity"].int64Value
                    let description = msg.1["description"].stringValue
                    let startTime = msg.1["startTime"].int64Value
                    let jobCategory = msg.1["jobCategory"].stringValue
                    let chargeTime = msg.1["chargeTime"].int64Value
                    let city = msg.1["city"].stringValue
                    let ordering_status = msg.1["ordering"].boolValue
                    let benefits = msg.1["benefits"]
                    var medical = String()
                    var PTO = String()
                    var FZOK = String()
                    for benefit in benefits {
                        
                        if benefit.1 == "Medical" {
                            medical = benefit.1.stringValue
                        }
                        if benefit.1 == "PTO" {
                            PTO = benefit.1.stringValue
                        }
                        if benefit.1 == "FZOk"{
                            FZOK = benefit.1.stringValue
                        }
                    
                        
                        print("Selling_Benefit_0 == \(benefit.0)")
                        print("Selling_Benefit_1 == \(benefit.1)")
                        
                        
                    }
                    var latitude = Double()
                    var londtitude = Double()
                    var watch_uid = String()
                    var watch_token = String()
                    
                    print("coordinate == \(coordinates)")
                    latitude = coordinates![1].doubleValue
                    londtitude = coordinates![0].doubleValue
                    
                    
                    
                    
                    let itemKey = msg.1["itemKey"].stringValue
                    let companyDescription = msg.1["companyDescription"].stringValue
                    let visibility = msg.1["visibility"].boolValue
                    let condition = msg.1["condition"].stringValue
                    let uid = msg.1["uid"].stringValue
                    let country_code = msg.1["country_code"].stringValue
                    let id = msg.1["_id"].stringValue
                    let timeRemaining = msg.1["timeRemaining"].int64Value
                    let conditionValue = msg.1["conditionValue"].intValue
                    let endTime = msg.1["endTime"].int64Value
                    let token = msg.1["token"].stringValue
                    let title = msg.1["title"].stringValue
                    let experience = msg.1["jobExperience"].stringValue
                    let userName = msg.1["name"].stringValue
                    let watching = msg.1["watching"]
                    for watch in watching {
                        let watch_uidvalue = watch.1["uid"].stringValue
                        let watch_tokenvalue = watch.1["token"].stringValue
                        watch_uid = watch_uidvalue
                        watch_token = watch_tokenvalue
                        
                    }
                    let currency_string = msg.1["currency_string"].stringValue
                    let currency_symbol = msg.1["currency_string"].stringValue
                    let admin_verify = msg.1["admin_verify"].stringValue
                    
                    let jobdetails = JobDetails.init(employmentType: employmentType, autoReList: autoReList, itemAuctionType: itemAuctionType, old_images: old_images_array, payPeriod: payPeriod, state: state, companyName: companyName, startPrice: startPrice, image: imageArray, acceptOffers: acceptOffers, zipcode: zipcode, quantity: quantity, description: description, startTime: startTime, jobCategory: jobCategory, chargeTime: chargeTime, city: city, latitude: latitude, longtitude: londtitude, itemKey: itemKey, companyDescription: companyDescription, visibility: visibility, condition: condition, uid: uid, country_code: country_code, id: id, timeRemaining: timeRemaining, conditionValue: conditionValue, endTime: endTime, token: token, itemCategory: itemCategory, title: title , medical: medical , PTO: PTO , FZOK: FZOK, Experience: experience, userName: userName, watchBool: true, watch_uid: watch_uid, watch_token: watch_token , jobApplied: jobApplied , currency_string: currency_string , currency_symbol: currency_symbol , admin_verify: admin_verify)
                    
                    
                    let storyBoard_ = UIStoryboard.init(name: storyBoardNames.JobDetails , bundle: nil)
                    let controller = storyBoard_.instantiateViewController(withIdentifier: "JoBDetailViewIdentifier") as! JoBDetailViewVC
                    controller.selectedProduct_Job = jobdetails
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    
                    
                }
                    
                else if itemCategory.contains("Vehicles") {
                    
                    print("Get_VehiclesDetailView_Item == \(itemCategory)")
                    // Vehicles_Details_View
                    let id = msg.1["_id"].stringValue
                    let loc = msg.1["loc"]
                    let corrdinate = loc["coordinates"]
                    
                    var maxBid = Int64()
                    var askPrice = Int64()
                    var winner = String()
                    var u_id = String()
                    var bid = Int64()
                    var watch_uid = String()
                    var watch_token = String()
                    var ItemimagesArr = [String]()
                    
                    let bids = msg.1["bids"]
                    for values in bids {
                        let maxBidvalue = values.1["maxBid"].int64Value
                        let askPricevalue = values.1["askPrice"].int64Value
                        let winnervalue = values.1["winner"].stringValue
                        maxBid = maxBidvalue
                        askPrice = askPricevalue
                        winner = winnervalue
                    }
                    
                    let bidList = msg.1["bidList"]
                    for bidlst in bidList {
                        let uidvalue = bidlst.1["uid"].stringValue
                        let bidvalue = bidlst.1["bid"].int64Value
                        u_id = uidvalue
                        bid = bidvalue
                    }
                    
                    let chargeTime = msg.1["chargeTime"].int64Value
                    let city = msg.1["city"].stringValue
                    let conditionValue = msg.1["conditionValue"].stringValue
                    let condition = msg.1["condition"].stringValue
                    let country_code = msg.1["country_code"].stringValue
                    let description = msg.1["description"].stringValue
                    let endTime = msg.1["endTime"].int64Value
                    let image = msg.1["old_images"]
                    var imageArray = [String]()
                    for img in image {
                        imageArray.append(img.1.stringValue)
                    }
                    let itemAuctionType = msg.1["itemAuctionType"].stringValue
                    let itemCategory = msg.1["itemCategory"].stringValue
                    let itemKey = msg.1["_id"].stringValue
                    let state = msg.1["itemState"].stringValue
                    let startPrice = msg.1["startPrice"].intValue
                    _ = msg.1["startTime"].stringValue
                    let timeRemaining = msg.1["timeRemaining"].int64Value
                    _ = msg.1["reservePrice"].intValue
                    let title = msg.1["title"].stringValue
                    let token = msg.1["token"].stringValue
                    let uid = msg.1["uid"].stringValue
                    let visibility = msg.1["visibility"].boolValue
                    let zipcode = msg.1["zipcode"].stringValue
                    let autoReList = msg.1["autoReList"].boolValue
                    let acceptOffers = msg.1["acceptOffers"].boolValue
                    let currency_string = msg.1["currency_string"].stringValue
                    let currency_symbol = msg.1["currency_symbol"].stringValue
                    let year = msg.1["year"].stringValue
                    let make = msg.1["make"].stringValue
                    let model = msg.1["model"].stringValue
                    let trim = msg.1["trim"].stringValue
                    let milesDriven = msg.1["miles_driven"].stringValue
                    let fuelType = msg.1["fuel_type"].stringValue
                    let color = msg.1["color"].stringValue
                    
                    
                    let image_0 = msg.1["old_images"]
                    var image_array = [String]()
                    for image in image_0 {
                        image_array.append(image.1.stringValue)
                    }
                    
                    let watchingbool = swifymessage!["watching"].boolValue
                    let watching = msg.1["watching"]
                    for watch in watching {
                        let watch_uidvalue = watch.1["uid"].stringValue
                        let watch_tokenvalue = watch.1["token"].stringValue
                        watch_uid = watch_uidvalue
                        watch_token = watch_tokenvalue
                        
                    }
                    let quantity = msg.1["quantity"].intValue
                    let ordering = msg.1["ordering"].boolValue
                    let admin_verify = msg.1["admin_verify"].stringValue
                    var latitude = Double()
                    var londtitude = Double()
                    let itemimages = msg.1["old_images"]
                    let coordinates = loc["coordinates"].array
                    for itemimg in itemimages {
                        ItemimagesArr.append(itemimg.1.stringValue)
                        print("Item Image Url Backhand == \(itemimg.1.stringValue)")
                    }
                    self.orderArray.removeAll()
                    self.offerArray.removeAll()
                    let OrderArray = msg.1["orders"].arrayValue
                    for item in OrderArray {
                        guard let OrderDic = item.dictionary else {return}
                        let orderId = OrderDic["_id"]?.string ?? ""
                        let sellerId = OrderDic["seller_uid"]?.string ?? ""
                        let buyerOfferCount = OrderDic["buyerOfferCount"]?.int ?? -1
                        let offersTypeArray = OrderDic["offers"]?.array ?? []
                        for item in offersTypeArray {
                            guard let Dic = item.dictionary else {return}
                            let message = Dic["message"]?.string ?? ""
                            let role = Dic["role"]?.string ?? ""
                            let price = Dic["price"]?.string ?? ""
                            let quantity = Dic["quantity"]?.string ?? ""
                            let time = OrderDic["time"]?.string ?? ""
                            let object = offerModel.init(message: message, role: role, price: price, quantity: quantity, time: time)
                            self.offerArray.append(object)
                        }
                        print(self.offerArray)
                        let obj = orderModel.init(orderId: orderId, sellerId: sellerId, OfferCount: buyerOfferCount, OfferArray: self.offerArray)
                        self.orderArray.append(obj)
                    }
                    print(self.orderArray)
                    
                    latitude = coordinates![1].doubleValue
                    londtitude = coordinates![0].doubleValue
                    
                    let VehicleDetail = sellingModel.init(id: id , chargeTime: chargeTime, images_path: imageArray, images_small_path: image_array, startTime: Int64(startPrice), visibility: visibility, ordering: ordering, old_small_images: ItemimagesArr, token: token, country_code: country_code, city: city, title: title, startPrice: startPrice, itemCategory: itemCategory, itemAuctionType: itemAuctionType, uid: uid, condition: condition, conditionValue: conditionValue, description: description, endTime: endTime, currency_string: currency_string, currency_symbol: currency_symbol, autoReList: autoReList, acceptOffers: acceptOffers, platform: "iOS", item_id: id, state: state, timeRemaining: timeRemaining, year: year, make: make, model: model, trim: trim, milesDriven: milesDriven, fuelType: fuelType, color: color, latitude: latitude, longtitude: londtitude, image: imageArray, watchBool: watchingbool, watch_uid: watch_uid, watch_token: watch_token, itemKey: itemKey , quantity: quantity, zipcode: zipcode , OrderArray: self.orderArray , admin_verify: admin_verify)
                    
                    self.tabBarController?.tabBar.isHidden = false
                    
                    let storyBoard_ = UIStoryboard.init(name: storyBoardNames.VehicelDetails , bundle: nil)
                    let controller = storyBoard_.instantiateViewController(withIdentifier: "VehiclesDetailMainView-Identifier") as! VehiclesDetailMainView
                    controller.selectedProduct_Vehicles = VehicleDetail
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    
                }
                    
                else {
                    
                    print("Get_ItemDetailView_Item == \(itemCategory)")
                    let startPrice = msg.1["startPrice"].intValue
                    let visibility = msg.1["visibility"].boolValue
                    let quantity = msg.1["quantity"].intValue
                    let image_0 = msg.1["old_images"]
                    var image_array = [String]()
                    for image in image_0 {
                        image_array.append(image.1.stringValue)
                    }
                    let chargeTime = msg.1["chargeTime"].int64Value
                    let token = msg.1["token"].stringValue
                    let description = msg.1["description"].stringValue
                    let uid = msg.1["uid"].stringValue
                    let watchingbool = swifymessage!["watching"].boolValue
                    let itemKey = msg.1["_id"].stringValue
                    let loc = msg.1["loc"]
                    let corrdinate = loc["coordinates"]
                    
                    var maxBid = Int64()
                    var askPrice = Int64()
                    var winner = String()
                    var u_id = String()
                    var bid = Int64()
                    var watch_uid = String()
                    var watch_token = String()
                    var ItemimagesArr = [String]()
                    
                    
                    let itemAuctionType = msg.1["itemAuctionType"].stringValue
                    let country_code = msg.1["country_code"].stringValue
                    let startTime = msg.1["startTime"].stringValue
                    let bids = msg.1["bids"]
                    for values in bids {
                        let maxBidvalue = values.1["maxBid"].int64Value
                        let askPricevalue = values.1["askPrice"].int64Value
                        let winnervalue = values.1["winner"].stringValue
                        maxBid = maxBidvalue
                        askPrice = askPricevalue
                        winner = winnervalue
                    }
                    let bidList = msg.1["bidList"]
                    for bidlst in bidList {
                        let uidvalue = bidlst.1["uid"].stringValue
                        let bidvalue = bidlst.1["bid"].int64Value
                        u_id = uidvalue
                        bid = bidvalue
                    }
                    let timeRemaining = msg.1["timeRemaining"].int64Value
                    let conditionValue = msg.1["conditionValue"].stringValue
                    let title = msg.1["title"].stringValue
                    let watching = msg.1["watching"]
                    for watch in watching {
                        let watch_uidvalue = watch.1["uid"].stringValue
                        let watch_tokenvalue = watch.1["token"].stringValue
                        watch_uid = watch_uidvalue
                        watch_token = watch_tokenvalue
                        
                    }
                    self.orderArray.removeAll()
                    self.offerArray.removeAll()
                    let OrderArray = msg.1["orders"].arrayValue
                    for item in OrderArray {
                        guard let OrderDic = item.dictionary else {return}
                        let orderId = OrderDic["_id"]?.string ?? ""
                        let sellerId = OrderDic["seller_uid"]?.string ?? ""
                        let buyerOfferCount = OrderDic["buyerOfferCount"]?.int ?? -1
                        let offersTypeArray = OrderDic["offers"]?.array ?? []
                        for item in offersTypeArray {
                            guard let Dic = item.dictionary else {return}
                            let message = Dic["message"]?.string ?? ""
                            let role = Dic["role"]?.string ?? ""
                            let price = Dic["price"]?.string ?? ""
                            let quantity = Dic["quantity"]?.string ?? ""
                            let time = OrderDic["time"]?.string ?? ""
                            let object = offerModel.init(message: message, role: role, price: price, quantity: quantity, time: time)
                            self.offerArray.append(object)
                        }
                        print(self.offerArray)
                        let obj = orderModel.init(orderId: orderId, sellerId: sellerId, OfferCount: buyerOfferCount, OfferArray: self.offerArray)
                        self.orderArray.append(obj)
                    }
                    print(self.orderArray)
                    let acceptOffers = msg.1["acceptOffers"].boolValue
                    let ordering = msg.1["ordering"].boolValue
                    let zipcode = msg.1["zipcode"].stringValue
                    let condition = msg.1["condition"].stringValue
                    let city = msg.1["city"].stringValue
                    let endTime = msg.1["endTime"].int64Value
                    let id = msg.1["_id"].stringValue
                    let state = msg.1["state"].stringValue
                    let autoReList = msg.1["autoReList"].stringValue
                    var latitude = Double()
                    var londtitude = Double()
                    let itemimages = msg.1["old_images"]
                    let coordinates = loc["coordinates"].array
                    for itemimg in itemimages {
                        ItemimagesArr.append(itemimg.1.stringValue)
                        print("Item Image Url Backhand == \(itemimg.1.stringValue)")
                    }
                    
                    latitude = coordinates![1].doubleValue
                    londtitude = coordinates![0].doubleValue
                    let currency_string = msg.1["currency_string"].stringValue
                    let currency_symbol = msg.1["currency_string"].stringValue
                    let admin_verify = msg.1["admin_verify"].stringValue
                    
                    let productdetails = ProductDetails.init(itemkey: itemKey, itemAuctionType : itemAuctionType ,visibility: visibility, startPrice: startPrice, quantity: quantity, chargeTime: chargeTime, Image_0: image_0.stringValue, Image_1: image_0.stringValue, token: token, description: description, uid: uid, itemCategory: itemCategory, country_code: country_code, startTime: Int64(startPrice), maxBid: maxBid, askPrice: askPrice, winner: winner, winner_uid: watch_uid, winner_bid: Int64(startPrice), timeRemaining: timeRemaining, conditionValue: conditionValue, title: title, watch_uid: watch_uid, watch_token: watch_token, zipcode: zipcode, condition: condition, city: city, endTime: endTime, id: id, state: state, autoReList: autoReList, ItemImages: ItemimagesArr, latitude: latitude, longtitude: londtitude, ordering_status: true, company_name: "", benefits: "", payPeriod: "", jobToughness: "", employmentType: "" , acceptOffers: acceptOffers , ordering: ordering , watchingBool: watchingbool, OrderArray: self.orderArray, currency_string: currency_string , currency_symbol: currency_symbol , admin_verify: admin_verify)
                    
                    self.tabBarController?.tabBar.isHidden = false
                    
                    let storyBoard_ = UIStoryboard.init(name: storyBoardNames.ItemDetails , bundle: nil)
                    let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailsVC") as! ItemDetailsTableView
                    controller.selectedProduct = productdetails
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }
                
                
            }
            
        }
        
        if error.contains("The network connection was lost"){
           
            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
            alert.addAction(ok)
            
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        if error.contains("The Internet connection appears to be offline.") {
           
            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
            alert.addAction(ok)
            
          
            self.present(alert, animated: true, completion: nil)
            
        }
        
        if error.contains("A server with the specified hostname could not be found."){
          
            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
            alert.addAction(ok)
            
            
            self.present(alert, animated: true, completion: nil)
        }
        
        if error.contains("The request timed out.") {
           
            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
            alert.addAction(ok)
           
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
  }
}

//MARK: - PINTEREST LAYOUT DELEGATE
extension SearchResultsVC : PinterestLayoutDelegate {
  
  // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat{
        
        let defaultHeight :CGFloat = 250
        var photoheight = CGFloat()
        
        
        let heightInt = Int.random(in: 150...250)
        
        
        var ratio = Float()
        print("index Path = \(index)")
        
        //print("index path .row : \(indexPath.row)")
        //print("got item in images array")
        
        var height : CGFloat = 0
        var numbers = CGFloat()
        var title = String()
        if UIDevice.current.model.contains("iPhone") {
            numbers = 2
        }else {
            numbers = 3
        }
        var width = CGFloat(UIScreen.main.bounds.width) / 3
        print("Photo Height == \(CGFloat(heightInt))")
        
        
        //    for items in productsArray {
        //        print("Product Image ratio == \(items.item_image_height)")
        //
        //        if items.item_image_ratio == 0 {
        //            ratio = 1
        //        }else {
        //            ratio = items.item_image_ratio
        //        }
        //
        //        title = items.item_title
        //    }
        //
        
        print("Count == \(products.count)")
        if products[indexPath.row].item_image_ratio  == 0 {
            ratio = 1
        }else {
            ratio = products[indexPath.row ].item_image_ratio
        }
        
        title = products[indexPath.row].item_title
        
        
        
        
        //    productsArray[indexPath.row].item_image.draw(in: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2 * CGFloat(productsArray[indexPath.row].item_image_ratio)))
        
        height = width  / CGFloat(ratio)
        print("Photo Height Back- == \(height), Photo Widht == \(width) , Photo Ratio\(ratio)")
        
        //    if UIDevice.modelName.contains("iPhone") {
        //         height = CGFloat(productObj.height ?? 250.0) * CGFloat(productObj.height_ratio ?? 0.75)
        //    }else {
        //         height = CGFloat(productObj.height ?? 250.0)  * CGFloat(productObj.height_ratio ?? 0.75)
        //    }
        
        
        //   ProductModel
        
        //print("photo size for index path \(indexPath): \(photo.size)")
        let loading : CGFloat = 80
        let lblNameHeight: CGFloat = 18
        let btnHeight : CGFloat = 50
        let numberOfColumns = 3
        let insets = collectionView.contentInset
        let contentWidth = collectionView.bounds.width - (insets.left + insets.right)
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        let font = UIFont.boldSystemFont(ofSize: 17)
        
        
        
        let estimatedHeight = title.height(withConstrainedWidth: columnWidth, font: font)
        print("estimate height for title : \(title) : \(estimatedHeight)")
        return height + estimatedHeight + btnHeight

        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
//
//        if let visibleIndexPath = self.visibleIndexPath {
//
//            // This conditional makes sure you only animate cells from the bottom and not the top, your choice to remove.
//            if indexPath.row > visibleIndexPath.row {
//
//                cell.contentView.alpha = 0
//
//                cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
//
//                // Simple Animation
//                UIView.animate(withDuration: 0.3) {
//                    cell.contentView.alpha = 1
//                    cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
//
//                }
//            }
//        }
//
    }
}

extension SearchResultsVC : UIScrollViewDelegate {
 
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {
            self.visibleIndexPath = visibleIndexPath
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
        
        if scrollView == collectionView {
            
            let currentOffset = scrollView.contentOffset.y
            let maxOffset = scrollView.contentSize.height - scrollView.frame.height
            
            let height = self.collectionView.contentSize.height
            
            print("contentoffset = \(scrollView.contentOffset.y)")
            print("scrollview height = \(scrollView.frame.height )")
            
            showFidget(flag: true)
        
//            self.collectionView.addInfiniteScroll { (collectionView) -> Void in
//                collectionView.performBatchUpdates({ () -> Void in
//                    // update collection view
//
//
//                }, completion: { (finished) -> Void in
//                    // finish infinite scroll animations
//
//                    self.collectionView.finishInfiniteScroll()
//                });
//            }
           
            
            scrollView.contentSize = CGSize(width: scrollView.frame.size.height, height: height  )
            scrollView.contentInset.bottom += 10
            scrollView.delegate = self
            
            print("Height == \(scrollView.contentSize.height)")
            
            print("maxoffset == \(maxOffset) // == Currentoffset = \(currentOffset)")
            print( "maxoffset- currentoffset = \(maxOffset - currentOffset)")
            
            if   maxOffset - currentOffset < 4000 {
              self.getSearchData()
              
                
            }
        }
        
}
    
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
            if(velocity.y>1) {
                //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
                UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    //self.navigationController?.setToolbarHidden(true, animated: true)
                   // self.SellUStuff.isHidden = false
                   
                    self.tabBarController?.tabBar.isHidden = true
                    print("velocitySearch1 \(velocity.y)")
                    print("Hide")
                }, completion: nil)
    
            } else {
                UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    //self.navigationController?.setToolbarHidden(false, animated: true)
                    self.tabBarController?.tabBar.isHidden = true
                 //   self.SellUStuff.isHidden = true
                    print("Unhide")
                    
                     print("velocitySearch2 \(velocity.y)")
                }, completion: nil)
            }
        }
}

//extension HomeVC_New : UIScrollViewDelegate {
//
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//
//        if scrollView == colVProducts {
//
//            let currentOffset = scrollView.contentOffset.y
//            let maxOffset = scrollView.contentSize.height - scrollView.frame.height
//
//            let height = self.colVProducts.contentSize.height
//
//            print("contentoffset = \(scrollView.contentOffset.y)")
//            print("scrollview height = \(scrollView.frame.height )")
//
//            self.fidgetImageView.isHidden = true
//            fidget.stopfiget(fidgetView: fidgetImageView)
//
//            itemLoadingDescrib.isHidden = true
//
//            scrollView.contentSize = CGSize(width: scrollView.frame.size.height, height: height  )
//            scrollView.contentInset.bottom += 200
//            scrollView.delegate = self
//
//            print("Height == \(scrollView.contentSize.height)")
//
//            print("maxoffset == \(maxOffset) // == Currentoffset = \(currentOffset)")
//            print( "maxoffset- currentoffset = \(maxOffset - currentOffset)")
//
//
//            if  maxOffset - currentOffset <= 9533.0  {
//
//                if  FilterFlag {
//                    getFilterData()
//                }else {
//                    // self.fetchDisplayData()
//                }
//
//
//
//
//            }
//        }
//
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        if(velocity.y>0) {
//            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
//            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//                //self.navigationController?.setToolbarHidden(true, animated: true)
//                self.SellUStuff.isHidden = false
//                self.tabBarController?.tabBar.isHidden = true
//
//
//
//
//                print("Hide")
//            }, completion: nil)
//
//        } else {
//            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//                //self.navigationController?.setToolbarHidden(false, animated: true)
//                self.tabBarController?.tabBar.isHidden = false
//                self.SellUStuff.isHidden = true
//                print("Unhide")
//            }, completion: nil)
//        }
//    }
//
//
//
//}
