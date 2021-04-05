//
//  HomeVCExtension_Actions.swift
//  Sell4Bids
//
//  Created by MAC on 17/07/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
extension HomeVC_New {
  
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
       mikeTapped()
    }
  @objc func resetLabelTapped(_ sender: UITapGestureRecognizer) {
    //searchController.isActive = false
    categoryToFilter = "All"
    buyingOptionToFilter = "Any"
    cityAndStateName = "New York, NY"
    stateName = "NY"
    flagIsFilterApplied = false
    fetchDisplayData()
    emptyProductMessage.isHidden = true
    productsArray.removeAll()
    //print(productsArray.count)
    //self.colVProducts.reloadData()
   
    
  }
  @objc func cityLabelactionTapped(_ sender: UITapGestureRecognizer) {
    guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "FiltersVc") as? FiltersVc else {return}
    controller.selfWasPushed = true
    controller.cityAndStateName = cityAndStateName ?? "New York, NY"
    controller.delegate = self
    
    if flagIsFilterApplied {
        controller.categoryToFilter = self.categoryToFilter
        controller.buyingOptionToFilter = self.buyingOptionToFilter
        
    }
    controller.stateToFilter = stateName
    self.navigationController?.pushViewController(controller, animated: true)
    }
  
  @objc func bidNowBtnTapped(_ sender:UIButton){
    let indexPathRow = sender.tag
    
    fidget.toggleRotateAndDisplayItems(fidgetView: self.fidgetImageView, downloadcompleted: true)
    DimView.isHidden = false
    
    MainApis.Item_Details(uid: SessionManager.shared.userId, country: gpscountry, seller_uid: productsArray[sender.tag].item_seller_id, item_id: productsArray[sender.tag].item_id) { (status, response, error) in
        
        if status {
            
            fidget.stopfiget(fidgetView: self.fidgetImageView)
            self.DimView.isHidden = true
            for message in response!["message"] {
                
                let itemCategory = message.1["itemCategory"].stringValue
                
                
                
                
                
                if  itemCategory == "Jobs" {
                    //Job Details Data
                    let jobApplied = response!["jobApplied"].boolValue
                    let employmentType = message.1["employmentType"].stringValue
                    let autoReList = message.1["autoReList"].boolValue
                    let itemAuctionType = message.1["itemAuctionType"].stringValue
                    let old_images = message.1["old_images"]
                    let loc = message.1["loc"]
                    let coordinates = loc["coordinates"].array
                    var old_images_array = [String]()
                    for oldimages in old_images {
                        old_images_array.append(oldimages.1.stringValue)
                    }
                    let payPeriod = message.1["payPeriod"].stringValue
                    let state = message.1["state"].stringValue
                    let companyName = message.1["companyName"].stringValue
                    let startPrice = message.1["startPrice"].int64Value
                    let image = message.1["images_path"]
                    var imageArray = [String]()
                    for img in image {
                        imageArray.append(img.1.stringValue)
                    }
                    let acceptOffers = message.1["acceptOffers"].boolValue
                    let zipcode = message.1["zipcode"].stringValue
                    let quantity = message.1["quantity"].int64Value
                    let description = message.1["description"].stringValue
                    let startTime = message.1["startTime"].int64Value
                    let jobCategory = message.1["jobCategory"].stringValue
                    let chargeTime = message.1["chargeTime"].int64Value
                    let city = message.1["city"].stringValue
                    let ordering_status = message.1["ordering"].boolValue
                    let benefits = message.1["benefits"]
                    var medical = String()
                    var PTO = String()
                    var FZOK = String()
                    for benefit in benefits {
                        let medical = benefit.1["Medical"].stringValue
                        let PTO = benefit.1["PTO"].stringValue
                        let FZOK = benefit.1["FZOK"].stringValue
                        
                    }
                    var latitude = Double()
                    var londtitude = Double()
                    var watch_uid = String()
                    var watch_token = String()
                    
                    print("coordinate == \(coordinates)")
                    latitude = coordinates![1].doubleValue
                    londtitude = coordinates![0].doubleValue
                    
                    
                    
                    
                    let itemKey = message.1["itemKey"].stringValue
                    let companyDescription = message.1["companyDescription"].stringValue
                    let visibility = message.1["visibility"].boolValue
                    let condition = message.1["condition"].stringValue
                    let uid = message.1["uid"].stringValue
                    let country_code = message.1["country_code"].stringValue
                    let id = message.1["id"].stringValue
                    let timeRemaining = message.1["timeRemaining"].int64Value
                    let conditionValue = message.1["conditionValue"].intValue
                    let endTime = message.1["endTime"].int64Value
                    let token = message.1["token"].stringValue
                    let title = message.1["title"].stringValue
                    let experience = message.1["experience"].stringValue
                    let userName = message.1["name"].stringValue
                    let watching = message.1["watching"]
                    for watch in watching {
                        let watch_uidvalue = watch.1["uid"].stringValue
                        let watch_tokenvalue = watch.1["token"].stringValue
                        watch_uid = watch_uidvalue
                        watch_token = watch_tokenvalue
                        
                    }
                    let currency_string = message.1["currency_string"].stringValue
                    let currency_symbol = message.1["currency_string"].stringValue
                    let admin_verify = message.1["admin_verify"].stringValue
                    
                    let jobdetails = JobDetails.init(employmentType: employmentType, autoReList: autoReList, itemAuctionType: itemAuctionType, old_images: old_images_array, payPeriod: payPeriod, state: state, companyName: companyName, startPrice: startPrice, image: imageArray, acceptOffers: acceptOffers, zipcode: zipcode, quantity: quantity, description: description, startTime: startTime, jobCategory: jobCategory, chargeTime: chargeTime, city: city, latitude: latitude, longtitude: londtitude, itemKey: itemKey, companyDescription: companyDescription, visibility: visibility, condition: condition, uid: uid, country_code: country_code, id: id, timeRemaining: timeRemaining, conditionValue: conditionValue, endTime: endTime, token: token, itemCategory: itemCategory, title: title , medical: medical , PTO: PTO , FZOK: FZOK, Experience: experience, userName: userName, watchBool: true, watch_uid: watch_uid, watch_token: watch_token , jobApplied: jobApplied , currency_string: currency_string , currency_symbol: currency_symbol , admin_verify: admin_verify)
                    
                    print("Job Details = \(jobdetails.title)")
                    
                    self.tabBarController?.tabBar.isHidden = false
                    
                    let storyBoard_ = UIStoryboard.init(name: storyBoardNames.JobDetails , bundle: nil)
                    let controller = storyBoard_.instantiateViewController(withIdentifier: "JoBDetailViewIdentifier") as! JoBDetailViewVC
                    controller.selectedProduct_Job = jobdetails
                    // controller.  = selectedProductKey
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    
                    
                }else {
                    //Item Details Job
                    let startPrice = message.1["startPrice"].intValue
                    let visibility = message.1["visibility"].boolValue
                    let quantity = message.1["quantity"].intValue
                    let image_0 = message.1["old_images"]
                    var image_array = [String]()
                    for image in image_0 {
                        image_array.append(image.1.stringValue)
                    }
                    let chargeTime = message.1["chargeTime"].int64Value
                    let token = message.1["token"].stringValue
                    let description = message.1["description"].stringValue
                    let uid = message.1["uid"].stringValue
                    
                    let itemKey = message.1["itemKey"].stringValue
                    let loc = message.1["loc"]
                    let corrdinate = loc["coordinates"]
                    
                    var maxBid = Int64()
                    var askPrice = Int64()
                    var winner = String()
                    var u_id = String()
                    var bid = Int64()
                    var watch_uid = String()
                    var watch_token = String()
                    var ItemimagesArr = [String]()
                    
                    
                    let itemAuctionType = message.1["itemAuctionType"].stringValue
                    let country_code = message.1["country_code"].stringValue
                    let startTime = message.1["startTime"].stringValue
                    let bids = message.1["bids"]
                    for values in bids {
                        let maxBidvalue = values.1["maxBid"].int64Value
                        let askPricevalue = values.1["askPrice"].int64Value
                        let winnervalue = values.1["winner"].stringValue
                        maxBid = maxBidvalue
                        askPrice = askPricevalue
                        winner = winnervalue
                    }
                    let bidList = message.1["bidList"]
                    for bidlst in bidList {
                        let uidvalue = bidlst.1["uid"].stringValue
                        let bidvalue = bidlst.1["bid"].int64Value
                        u_id = uidvalue
                        bid = bidvalue
                    }
                    let timeRemaining = message.1["timeRemaining"].int64Value
                    let conditionValue = message.1["conditionValue"].stringValue
                    let title = message.1["title"].stringValue
                    let watching = message.1["watching"]
                    for watch in watching {
                        let watch_uidvalue = watch.1["uid"].stringValue
                        let watch_tokenvalue = watch.1["token"].stringValue
                        watch_uid = watch_uidvalue
                        watch_token = watch_tokenvalue
                        
                    }
                    self.orderArray.removeAll()
                    self.offerArray.removeAll()
                    let OrderArray = message.1["orders"].arrayValue
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
                    
                    let zipcode = message.1["zipcode"].stringValue
                    let condition = message.1["condition"].stringValue
                    let city = message.1["city"].stringValue
                    let endTime = message.1["endTime"].int64Value
                    let id = message.1["_id"].stringValue
                    let state = message.1["state"].stringValue
                    let autoReList = message.1["autoReList"].stringValue
                    var latitude = Double()
                    var londtitude = Double()
                    let itemimages = message.1["old_images"]
                    for itemimg in itemimages {
                        ItemimagesArr.append(itemimg.1.stringValue)
                        print("Item Image Url Backhand == \(itemimg.1.stringValue)")
                    }
                    let ordering = message.1["ordering"].boolValue
                    let acceptOffers = message.1["acceptOffers"].boolValue
                    let watchingbool = response!["watching"].boolValue
                    let currency_string = message.1["currency_string"].stringValue
                    let currency_symbol = message.1["currency_string"].stringValue
                    let admin_verify = message.1["admin_verify"].stringValue
                    
                    let productdetails = ProductDetails.init(itemkey: itemKey, itemAuctionType : itemAuctionType,visibility: visibility, startPrice: startPrice, quantity: quantity, chargeTime: chargeTime, Image_0: image_0.stringValue, Image_1: image_0.stringValue, token: token, description: description, uid: uid, itemCategory: itemCategory, country_code: country_code, startTime: Int64(startPrice), maxBid: maxBid, askPrice: askPrice, winner: winner, winner_uid: watch_uid, winner_bid: Int64(startPrice), timeRemaining: timeRemaining, conditionValue: conditionValue, title: title, watch_uid: watch_uid, watch_token: watch_token, zipcode: zipcode, condition: condition, city: city, endTime: endTime, id: id, state: state, autoReList: autoReList, ItemImages: ItemimagesArr, latitude: latitude, longtitude: londtitude, ordering_status: true, company_name: "", benefits: "", payPeriod: "", jobToughness: "", employmentType: "", acceptOffers: acceptOffers, ordering: ordering, watchingBool: watchingbool, OrderArray: self.orderArray , currency_string: currency_string , currency_symbol: currency_symbol , admin_verify: admin_verify)
                    
                    selectedProduct = productdetails
                    
                    print("Ask-Price == \(self.productsArray[sender.tag].item_image_ratio)")
                    
                    
                    self.tabBarController?.tabBar.isHidden = false
                    
                    let storyBoard_ = UIStoryboard.init(name: storyBoardNames.ItemDetails , bundle: nil)
                    let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailsVC") as! ItemDetailsTableView
                    controller.selectedProduct = selectedProduct
                    // controller.  = selectedProductKey
                    self.navigationController?.pushViewController(controller, animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    
                }
                
                
                
                
                
                
                
                
            }
            
        }
        
        if error.contains("The network connection was lost"){
            self.DimView.isHidden = true
            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
            alert.addAction(ok)
            
            fidget.stopfiget(fidgetView: self.fidgetImageView)
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
        if error.contains("The Internet connection appears to be offline.") {
            self.DimView.isHidden = true
            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
            alert.addAction(ok)
            
            fidget.stopfiget(fidgetView: self.fidgetImageView)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        if error.contains("A server with the specified hostname could not be found."){
            self.DimView.isHidden = true
            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
            alert.addAction(ok)
            fidget.stopfiget(fidgetView: self.fidgetImageView)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        if error.contains("The request timed out.") {
            self.DimView.isHidden = true
            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
            alert.addAction(ok)
            fidget.stopfiget(fidgetView: self.fidgetImageView)
            
            self.present(alert, animated: true, completion: nil)
            
        }
  }
    
    }
  
  
  //MARK: - IBActions and user interaction
  
  @IBAction func btnTryAgainNoResultsTapped(_ sender: UIButton) {
    downloadAndShowData()
  }
  
  @IBAction func btnFilterRightTapped(_ sender: Any) {
    
    guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "FiltersVc") as? FiltersVc else {return}
    controller.selfWasPushed = true
    controller.cityAndStateName = cityAndStateName ?? "New York, NY"
    controller.delegate = self
    
    if flagIsFilterApplied {
      controller.categoryToFilter = self.categoryToFilter
      controller.buyingOptionToFilter = self.buyingOptionToFilter
      
    }
    controller.stateToFilter = stateName
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func mikeTapped() {
    let searchSB = getStoryBoardByName(storyBoardNames.searchVC)
    let searchVC = searchSB.instantiateViewController(withIdentifier: "SearchVC") as! SearchVc
    searchVC.flagShowSpeechRecBox = true
    self.navigationController?.pushViewController(searchVC, animated: true)
  }
  @objc func handleRefresh(_ refreshControl: UIRefreshControl){
   
    DispatchQueue.main.async {

   
         fetchingMethod = "zipcode"
        endkey = nil
       
       
        count = 0
        if FilterFlag{
            
        }else{
            if !self.flagIsFilterApplied {
                self.fetchDisplayData()
            }
        }
        
       
        self.emptyProductMessage.isHidden = true
     
      self.fidgetImageView.isHidden = false
      self.refreshControl.beginRefreshing()
      self.refreshControl.endRefreshing()
    }
    
    
   
//
//    getCurrenState{ (complete,state,city,zip)  in
//
//
//
//        self.getUserBlockedList{(complete) in
//
//        DispatchQueue.main.async {
//            print("refresh\(state!)")
//            print("product count == \(self.productsArray.count)")
//                self.colVProducts.reloadData()
//                refreshControl.endRefreshing()
//          self.dimView.isHidden = true
//          self.fidgetImageView.isHidden = true
//        }
//      }
//    }
  }
}
