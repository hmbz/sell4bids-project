//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

import AVFoundation

extension HomeVC_New : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    
    
  
    
    
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.colVProducts {
      if flagIsFilterApplied {
       
        return productsArray.count
      }
      else
      {
        //print("Get numberOfItemsInSection", section, productsArray.count)
        print("Product items in collectionview \(productsArray.count)")
        return productsArray.count
        //return number of rows in section
      }
    }
    else {
      //print("Get numberOfItemsInSection", section, categoriesImagesArray.count)
         print("Product items in collectionview \(categoriesImagesArray.count)")
      return categoriesImagesArray.count
        
      
    }
  }
    
//    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
//        let objDateformat: DateFormatter = DateFormatter()
//        objDateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let strTime: String = objDateformat.string(from: dateToConvert as Date)
//        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
//        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
//        let strTimeStamp: String = "\(milliseconds)"
//        return strTimeStamp
//    }
  
    
    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView == colVProducts {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath as IndexPath) as! AnnotatedPhotoCell
        
        cell.layer.cornerRadius = 12
        cell.mainBidNowBtn.tag = indexPath.item
        cell.layer.masksToBounds = true
        cell.mainContainerView.addShadowView()
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.6
        print("will Appear = \(willAppear)")
        cell.mainBidNowBtn.addShadowAndRound()
        
        if  !flagIsFilterApplied{
            //filter not applied
            guard indexPath.row < productsArray.count else { return cell }
            let product = productsArray[indexPath.row]
            if product.old_images.count > 0 {
                let image = product.old_images[0].replacingOccurrences(of: " ", with: "%20")
                cell.mainImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "emptyImage"))
            }else {
                print("No Image Found")
            }
            
            if product.item_category.contains("Services") {
                cell.ServiceTagtxt.isHidden = false
                cell.ServiceView.isHidden = false
                cell.ServiceTagtxt.text = "Services"
                let blueColor = UIColor.init(red: 12/255, green: 53/255, blue: 90/255, alpha: 1)
                _ = UIColor.init(red: 39/255, green: 71/255, blue: 96/225, alpha: 1)
                
                cell.ServiceView.setGradientBackground(colorOne: blueColor, colorTwo: UIColor.white)
                
            }else {
                cell.ServiceTagtxt.isHidden = true
                cell.ServiceView.isHidden = true
            }
            _ = Int.random(in: 150...250)
            
            if productsArray[indexPath.row].item_image_ratio == 0 {
                cell.mainImageView.contentMode = .scaleAspectFit
            }else {
                cell.mainImageView.contentMode = .scaleAspectFill
            }
            cell.mainImageView.image = productsArray[indexPath.row].item_image.image
            cell.mainBidNowBtn.addTarget(self, action: #selector(HomeVC_New.bidNowBtnTapped), for: .touchUpInside)
            cell.mainImageView.sd_setShowActivityIndicatorView(true)
            
            if (indexPath.row == productsArray.count - 20)
            {
                
                cell.mainImageView.alpha = 0
                UIView.animate(withDuration: 0.9) {
                    cell.mainImageView.alpha = 1
                }
            }else {
                print("Nothing to found")
            }
            
            cell.titleLabel.text = product.item_title

            
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

            
        }
        else if flagIsFilterApplied && indexPath.item < productsArray.count {
            
            
            let product = productsArray[indexPath.item]
            cell.mainImageView.image = productsArray[indexPath.row].item_image.image
            cell.mainBidNowBtn.addTarget(self, action: #selector(HomeVC_New.bidNowBtnTapped), for: .touchUpInside)
            cell.mainBidNowBtn.tag = indexPath.item
            
            cell.mainImageView.sd_setShowActivityIndicatorView(true)
            cell.titleLabel.text = productsArray[indexPath.row].item_title
            
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
                        
                        return cell.mainBidNowBtn.backgroundColor = UIColor.gray
                        
                    }else{
                        
                        return cell.mainBidNowBtn.backgroundColor = UIColor.red
                        
                    }
                    
                }
                else if product.item_auction_type == "buy-it-now"{
                    if product.item_endTime == -1{
                        return cell.mainBidNowBtn.backgroundColor = UIColor.red
                    }
                    if product.quantity == 0 && product.item_category.lowercased() != "jobs"{
                        return cell.mainBidNowBtn.backgroundColor = UIColor.gray
                    }
                    if (timeRemaining == 0 || timeRemaining < -1){
                        
                        return cell.mainBidNowBtn.backgroundColor = UIColor.gray
                        
                    }
                }
                else if product.item_auction_type == "reserve"{
                    if (product.item_endTime < -1){
                        
                        return cell.mainBidNowBtn.backgroundColor = UIColor.gray
                        
                    }
                    return cell.mainBidNowBtn.backgroundColor = UIColor.red
                }
                    
                else if product.item_auction_type == "non-reserve"{
                    if (timeRemaining < -1){
                        
                        return cell.mainBidNowBtn.backgroundColor = UIColor.gray
                    }
                    return cell.mainBidNowBtn.backgroundColor = UIColor.red
                }
                return cell.mainBidNowBtn.backgroundColor = UIColor.red
            }

        }
        else {
            print("Nothing")
        }
        
        return cell
    }
    else {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCell
      print("indexPath ====\(indexPath.item)")
      cell.categoriesNameLabel.text = categoriesArray[indexPath.item]
      cell.imageView.image = categoriesImagesArray[indexPath.item]
      cell.imageView.contentMode = .scaleAspectFit
      cell.imageView.clipsToBounds = true
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == self.colVProducts {
    
        self.DimView.isHidden = false
        self.DimView.alpha = 1
        self.DimView.backgroundColor = .clear
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.isHidden = false
                self.fidgetImageView.loadGif(name: "red")
            }
        }
       
        MainApis.Item_Details(uid: SessionManager.shared.userId, country: gpscountry, seller_uid: productsArray[indexPath.row].item_seller_id, item_id: productsArray[indexPath.row].item_id) { (status, response, error) in
            
            if status {
                self.responseStatus = true
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                 let jobApplied = response!["jobApplied"].boolValue
                 let sellerIsBlocked = response!["sellerIsBlocked"].boolValue
                
                for message in response!["message"] {
                    
                   let itemCategory = message.1["itemCategory"].stringValue

                    if  itemCategory == "Jobs" {
                        
                        print("itemCategory_JobsDetails == \(itemCategory)")
                        //Job Details Data
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
                        _ = message.1["ordering"].boolValue
                        let benefits = message.1["benefits"]
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
                        
                        print("coordinate == \(String(describing: coordinates))")
                        latitude = coordinates![1].doubleValue
                        londtitude = coordinates![0].doubleValue
                        let itemKey = message.1["itemKey"].stringValue
                        let companyDescription = message.1["companyDescription"].stringValue
                        let visibility = message.1["visibility"].boolValue
                        let condition = message.1["condition"].stringValue
                        let uid = message.1["uid"].stringValue
                        let country_code = message.1["country_code"].stringValue
                        let id = message.1["_id"].stringValue
                        let timeRemaining = message.1["timeRemaining"].int64Value
                        let conditionValue = message.1["conditionValue"].intValue
                        let endTime = message.1["endTime"].int64Value
                        let token = message.1["token"].stringValue
                        let title = message.1["title"].stringValue
                        let experience = message.1["jobExperience"].stringValue
                        let userName = message.1["name"].stringValue
                        let watching = message.1["watching"]
                        for watch in watching {
                            let watch_uidvalue = watch.1["uid"].stringValue
                            let watch_tokenvalue = watch.1["token"].stringValue
                            watch_uid = watch_uidvalue
                            watch_token = watch_tokenvalue
                        }
                        print(watch_uid)
                        print(watch_token)
                        let currency_string = message.1["currency_string"].stringValue
                        let currency_symbol = message.1["currency_string"].stringValue
                        let admin_verify = message.1["admin_verify"].stringValue
                        
                        let jobdetails = JobDetails.init(employmentType: employmentType, autoReList: autoReList, itemAuctionType: itemAuctionType, old_images: old_images_array, payPeriod: payPeriod, state: state, companyName: companyName, startPrice: startPrice, image: imageArray, acceptOffers: acceptOffers, zipcode: zipcode, quantity: quantity, description: description, startTime: startTime, jobCategory: jobCategory, chargeTime: chargeTime, city: city, latitude: latitude, longtitude: londtitude, itemKey: itemKey, companyDescription: companyDescription, visibility: visibility, condition: condition, uid: uid, country_code: country_code, id: id, timeRemaining: timeRemaining, conditionValue: conditionValue, endTime: endTime, token: token, itemCategory: itemCategory, title: title , medical: medical , PTO: PTO , FZOK: FZOK, Experience: experience, userName: userName, watchBool: true, watch_uid: watch_uid, watch_token: watch_token , jobApplied: jobApplied , currency_string: currency_string , currency_symbol: currency_symbol , admin_verify: admin_verify)
                        
                        print("Job Details = \(jobdetails.title)")
                        
                        self.tabBarController?.tabBar.isHidden = false
                        
                        let storyBoard_ = UIStoryboard.init(name: storyBoardNames.JobDetails , bundle: nil)
                        let controller = storyBoard_.instantiateViewController(withIdentifier: "JoBDetailViewIdentifier") as! JoBDetailViewVC
                        controller.selectedProduct_Job = jobdetails
                        
                        self.navigationController?.pushViewController(controller, animated: true)
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                        
                        
                    }
                    
                    
                    else if itemCategory == "Vehicles" {
                        
                        print("itemCategory_VehiclesDetails == \(itemCategory)")
                        // Vehicles_Details_View
                        print(message)
                        let id = message.1["_id"].stringValue
                        let loc = message.1["loc"]
                        _ = loc["coordinates"]
                        
                        var maxBid = Int64()
                        var askPrice = Int64()
                        var winner = String()
                        var u_id = String()
                        var bid = Int64()
                        var watch_uid = String()
                        var watch_token = String()
                        var ItemimagesArr = [String]()
                        
                        let bids = message.1["bids"]
                        for values in bids {
                            let maxBidvalue = values.1["maxBid"].int64Value
                            let askPricevalue = values.1["askPrice"].int64Value
                            let winnervalue = values.1["winner"].stringValue
                            maxBid = maxBidvalue
                            askPrice = askPricevalue
                            winner = winnervalue
                        }
                        print(maxBid)
                        print(askPrice)
                        print(winner)
                        let bidList = message.1["bidList"]
                        for bidlst in bidList {
                            let uidvalue = bidlst.1["uid"].stringValue
                            let bidvalue = bidlst.1["bid"].int64Value
                            u_id = uidvalue
                            bid = bidvalue
                        }
                        print(u_id)
                        print(bid)
                        let chargeTime = message.1["chargeTime"].int64Value
                        let city = message.1["city"].stringValue
                        let conditionValue = message.1["conditionValue"].stringValue
                        let condition = message.1["condition"].stringValue
                        let country_code = message.1["country_code"].stringValue
                        let description = message.1["description"].stringValue
                        let endTime = message.1["endTime"].int64Value
                        let image = message.1["images_path"]
                        var imageArray = [String]()
                        for img in image {
                            imageArray.append(img.1.stringValue)
                        }
                        let itemAuctionType = message.1["itemAuctionType"].stringValue
                        let itemCategory = message.1["itemCategory"].stringValue
                        let item_id = message.1["_id"].stringValue
                        let state = message.1["itemState"].stringValue
                        let startPrice = message.1["startPrice"].intValue
                        _ = message.1["startTime"].stringValue
                        let timeRemaining = message.1["timeRemaining"].int64Value
                        _ = message.1["reservePrice"].intValue
                        let title = message.1["title"].stringValue
                        let token = message.1["token"].stringValue
                        let uid = message.1["uid"].stringValue
                        let visibility = message.1["visibility"].boolValue
                        let zipcode = message.1["zipcode"].stringValue
                        let autoReList = message.1["autoReList"].boolValue
                        let acceptOffers = message.1["acceptOffers"].boolValue
                        let currency_string = message.1["currency_string"].stringValue
                        let currency_symbol = message.1["currency_symbol"].stringValue
                        let year = message.1["year"].stringValue
                        let make = message.1["make"].stringValue
                        let model = message.1["model"].stringValue
                        let trim = message.1["trim"].stringValue
                        let milesDriven = message.1["miles_driven"].stringValue
                        let fuelType = message.1["fuel_type"].stringValue
                        let color = message.1["color"].stringValue
                        
                        
                        let image_0 = message.1["images_small_path"]
                        var image_array = [String]()
                        for image in image_0 {
                            image_array.append(image.1.stringValue)
                        }
                        
                        let watchingbool = response!["watching"].boolValue
                        let watching = message.1["watching"]
                        for watch in watching {
                            let watch_uidvalue = watch.1["uid"].stringValue
                            let watch_tokenvalue = watch.1["token"].stringValue
                            watch_uid = watch_uidvalue
                            watch_token = watch_tokenvalue
                            
                        }
                        
                        let ordering = message.1["ordering"].boolValue
                        var latitude = Double()
                        var londtitude = Double()
                        let itemimages = message.1["images_info"]
                        let coordinates = loc["coordinates"].array
                        let quantity = message.1["quantity"].intValue
                        let admin_verify = message.1["admin_verify"].stringValue
                        for itemimg in itemimages {
                            ItemimagesArr.append(itemimg.1.stringValue)
                            print("Item Image Url Backhand == \(itemimg.1.stringValue)")
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
                        
                        latitude = coordinates![1].doubleValue
                        londtitude = coordinates![0].doubleValue
                        
                       let VehicleDetail = sellingModel.init(id: id , chargeTime: chargeTime, images_path: imageArray, images_small_path: image_array, startTime: Int64(startPrice), visibility: visibility, ordering: ordering, old_small_images: ItemimagesArr, token: token, country_code: country_code, city: city, title: title, startPrice: startPrice, itemCategory: itemCategory, itemAuctionType: itemAuctionType, uid: uid, condition: condition, conditionValue: conditionValue, description: description, endTime: endTime, currency_string: currency_string, currency_symbol: currency_symbol, autoReList: autoReList, acceptOffers: acceptOffers, platform: "iOS", item_id: id, state: state, timeRemaining: timeRemaining, year: year, make: make, model: model, trim: trim, milesDriven: milesDriven, fuelType: fuelType, color: color, latitude: latitude, longtitude: londtitude, image: imageArray, watchBool: watchingbool, watch_uid: watch_uid, watch_token: watch_token, itemKey: item_id , quantity: quantity , zipcode: zipcode , OrderArray: self.orderArray , admin_verify: admin_verify)
                        
                        print("VehicleDetails = \(VehicleDetail.title)")
                        print("itemkey_VehicleDetails == \(VehicleDetail.itemKey)")

                        if VehicleDetail.itemKey == "" {

                        }else {
                            self.tabBarController?.tabBar.isHidden = false

                            let storyBoard_ = UIStoryboard.init(name: storyBoardNames.VehicelDetails , bundle: nil)
                            let controller = storyBoard_.instantiateViewController(withIdentifier: "VehiclesDetailMainView-Identifier") as! VehiclesDetailMainView
                            controller.selectedProduct_Vehicles = VehicleDetail
                            
                            self.navigationController?.pushViewController(controller, animated: true)
                            self.navigationController?.setNavigationBarHidden(false, animated: true)
                        }
                        
                    }else if itemCategory == "Services" {
                        
                        print("itemCategory_ServicesDetails == \(itemCategory)")
                        // Service Detail View
                        let startPrice = message.1["startPrice"].intValue
                        let visibility = message.1["visibility"].boolValue
                        let image_0 = message.1["images_small_path"]
                        var image_array = [String]()
                        for image in image_0 {
                            image_array.append(image.1.stringValue)
                        }
                        let chargeTime = message.1["chargeTime"].int64Value
                        let token = message.1["token"].stringValue
                        let description = message.1["description"].stringValue
                        let uid = message.1["uid"].stringValue
                        _ = response!["watching"].boolValue
                        let itemKey = message.1["_id"].stringValue
                        let loc = message.1["loc"]
                        _ = loc["coordinates"]
                        let id = message.1["_id"].stringValue
                      
                        var watch_uid = String()
                        var watch_token = String()
                        var ItemimagesArr = [String]()
                        
                        let itemAuctionType = message.1["itemAuctionType"].stringValue
                        let country_code = message.1["country_code"].stringValue
                        _ = message.1["startTime"].stringValue
                        let timeRemaining = message.1["timeRemaining"].int64Value
                        let title = message.1["title"].stringValue
                        let watching = message.1["watching"]
                        for watch in watching {
                            let watch_uidvalue = watch.1["uid"].stringValue
                            let watch_tokenvalue = watch.1["token"].stringValue
                            watch_uid = watch_uidvalue
                            watch_token = watch_tokenvalue
                        }
                        print(watch_uid)
                        print(watch_token)
                        let zipcode = message.1["zipcode"].stringValue
                        let city = message.1["city"].stringValue
                        let endTime = message.1["endTime"].int64Value
                        let state = message.1["state"].stringValue
                        let autoReList = message.1["autoReList"].boolValue
                        let acceptOffers = message.1["acceptOffers"].boolValue
                        var latitude = Double()
                        var londtitude = Double()
                        let itemimages = message.1["old_images"]
                        let coordinates = loc["coordinates"].array
                        for itemimg in itemimages {
                            ItemimagesArr.append(itemimg.1.stringValue)
                            print("Item Image Url Backhand == \(itemimg.1.stringValue)")
                        }
                        let ordering = message.1["ordering"].boolValue
                        let serviceType = message.1["serviceType"].stringValue
                        let servicePrice = message.1["startPrice"].stringValue
                        let negotiable = message.1["negotiable"].boolValue
                        let userRole = message.1["userRole"].stringValue
                        let quantity = message.1["quantity"].intValue
                        let image = message.1["images_path"]
                        var imageArray = [String]()
                        for img in image {
                            imageArray.append(img.1.stringValue)
                        }
                        let currency_string = message.1["currency_string"].stringValue
                        let currency_symbol = message.1["currency_symbol"].stringValue
                        let admin_verify = message.1["admin_verify"].stringValue
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
                        latitude = coordinates![1].doubleValue
                        londtitude = coordinates![0].doubleValue
                        
                        let ServiceDetail = sellingModel.init(id: id, latitude: latitude, longtitude: londtitude, chargeTime: chargeTime, images_path: imageArray, images_small_path: image_array, startTime: Int64(startPrice), visibility: visibility, old_small_images: ItemimagesArr, image: imageArray, token: token, country_code: country_code, city: city, title: title, startPrice: startPrice, itemCategory: itemCategory, uid: uid, description: description, endTime: endTime, currency_string: currency_string, currency_symbol: currency_symbol, autoReList: autoReList, acceptOffers: acceptOffers, platform: "iOS", item_id: itemKey, state: state, userRole: userRole, negotiable: negotiable, serviceType: serviceType, servicePrice: servicePrice, timeRemaining: timeRemaining, ordering: ordering , quantity: quantity, zipcode: zipcode , OrderArray: self.orderArray , itemAuctionType: itemAuctionType , admin_verify: admin_verify)

                        if ServiceDetail.item_id == "" {
                            
                        }else {
                            self.tabBarController?.tabBar.isHidden = false
                            
                            let storyBoard_ = UIStoryboard.init(name: storyBoardNames.ServiceDetails , bundle: nil)
                            let controller = storyBoard_.instantiateViewController(withIdentifier: "ServiceDetailView-Identifier") as! ServiceDetailView
                            controller.selectedProduct_Service = ServiceDetail
                            
                            self.navigationController?.pushViewController(controller, animated: true)
                            self.navigationController?.setNavigationBarHidden(false, animated: true)
                        }
   
                    }else {
                        
                        print("itemCategory_ItemDetails == \(itemCategory)")
                        //Item Details View
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
                        let watchingbool = response!["watching"].boolValue
                        let itemKey = message.1["_id"].stringValue
                        let loc = message.1["loc"]
                        _ = loc["coordinates"]
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
                        _ = message.1["startTime"].stringValue
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
                        print(u_id)
                        print(bid)
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
                        let acceptOffers = message.1["acceptOffers"].boolValue
                        let ordering = message.1["ordering"].boolValue
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
                        let coordinates = loc["coordinates"].array
                        for itemimg in itemimages {
                            ItemimagesArr.append(itemimg.1.stringValue)
                            print("Item Image Url Backhand == \(itemimg.1.stringValue)")
                        }
                        
                        latitude = coordinates![1].doubleValue
                        londtitude = coordinates![0].doubleValue
                        let currency_string = message.1["currency_string"].stringValue
                        let currency_symbol = message.1["currency_string"].stringValue
                        let admin_verify = message.1["admin_verify"].stringValue
                    
                        let productdetails = ProductDetails.init(itemkey: itemKey, itemAuctionType : itemAuctionType ,visibility: visibility, startPrice: startPrice, quantity: quantity, chargeTime: chargeTime, Image_0: image_0.stringValue, Image_1: image_0.stringValue, token: token, description: description, uid: uid, itemCategory: itemCategory, country_code: country_code, startTime: Int64(startPrice), maxBid: maxBid, askPrice: askPrice, winner: winner, winner_uid: watch_uid, winner_bid: Int64(startPrice), timeRemaining: timeRemaining, conditionValue: conditionValue, title: title, watch_uid: watch_uid, watch_token: watch_token, zipcode: zipcode, condition: condition, city: city, endTime: endTime, id: id, state: state, autoReList: autoReList, ItemImages: ItemimagesArr, latitude: latitude, longtitude: londtitude, ordering_status: true, company_name: "", benefits: "", payPeriod: "", jobToughness: "", employmentType: "" , acceptOffers: acceptOffers , ordering: ordering , watchingBool: watchingbool, OrderArray: self.orderArray , currency_string: currency_string, currency_symbol: currency_symbol , admin_verify: admin_verify)
                        selectedProduct = productdetails
                        print("Ask-Price == \(self.productsArray[indexPath.row].item_image_ratio)")
                         print("itemkey ## \(selectedProduct!.itemKey)")
                        if selectedProduct!.itemKey == "" {
                            
                        }else {
                            
                            
                            if sellerIsBlocked == false {
                            self.tabBarController?.tabBar.isHidden = false
                            
                            let storyBoard_ = UIStoryboard.init(name: storyBoardNames.ItemDetails , bundle: nil)
                            let controller = storyBoard_.instantiateViewController(withIdentifier: "ItemDetailsVC") as! ItemDetailsTableView
                            controller.selectedProduct = selectedProduct
                          self.navigationController?.pushViewController(controller, animated: true)
                            self.navigationController?.setNavigationBarHidden(false, animated: true)
                            }else {
                                _ = SweetAlert().showAlert("Blocked Seller", subTitle: "you have blocked this seller.", style: .warning, buttonTitle: "unblock", buttonColor: UIColor.black, otherButtonTitle: "Cancel", action: { (unblocked) in
                                    if unblocked {
                                        print("unblocked!")
                                        self.MainApis.Unblock_Api(user_ID: SessionManager.shared.userId, blockUserID: uid, completionHandler: { (status, data, error) in
                                            
                                            if status {
                                                let message = data!["message"].stringValue
                                                
                                                _ = SweetAlert().showAlert("Successfully", subTitle: message, style: .success)
                                            }else {
                                                let message = data!["message"].stringValue
                                                
                                                _ = SweetAlert().showAlert("unSuccessfully", subTitle: message, style: .error)
                                            }
                                        })
                                    }else {
                                        print("cancel!")
                                    }
                                })
                            }
                        }
                    }
                }
            }
            
            if error.contains("The network connection was lost"){
               Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                
             
                self.present(alert, animated: true, completion: nil)
                
                
            }
            
            if error.contains("The Internet connection appears to be offline.") {
                  Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                
               
                self.present(alert, animated: true, completion: nil)
                
            }
            
            if error.contains("A server with the specified hostname could not be found."){
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                  Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                self.present(alert, animated: true, completion: nil)
            }
            
            if error.contains("The request timed out.") {
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                  Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                self.present(alert, animated: true, completion: nil)
            
            }
            
        }
    }
//    else {
//         self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.tabBarController?.tabBar.isHidden = false
//      let selectedCat = categoriesArray[indexPath.item]
//         self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.tabBarController?.tabBar.isHidden = false
//        let storyBoard = UIStoryboard.init(name: storyBoardNames.tabs.categoriesTab , bundle: nil)
//        let controller = storyBoard.instantiateViewController(withIdentifier: "CategoryDetailVC") as! CategoryDetailVC
//        controller.categoryName = selectedCat
//        navigationController?.pushViewController(controller, animated: true)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.tabBarController?.tabBar.isHidden = true
//    }
  }
    
    
    
   
    private func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        
        let height: CGFloat = 100
        
        
        
        let size = CGSize(width: self.view.frame.width , height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    var headerheight = CGFloat()
    
    if collectionView == colVProducts{
      let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
//
      return CGSize(width: itemSize, height: itemSize)
    }
    else {
//
      let size: CGSize = categoriesArray[indexPath.row].size(withAttributes: nil)
        if UIDevice.modelName.contains("iPhone") {
             headerheight = CGFloat(100)
        }else {
             headerheight = CGFloat(140)
        }
      //45.5
      let heightForLabel = headerheight * 0.29
      let cellHeight = headerheight - heightForLabel + 10
      return CGSize(width: size.width + 60.5, height: cellHeight  )
//
    }

//
    let padding: CGFloat = 60
    var height = CGFloat()
    //estimate each cell's height
    
    //        var mx = messages
    //        mx.sort(){$0.message!.count > ($1.message?.count)!}
    
    var width = CGFloat((categoriesArray[indexPath.item].widthOfString(usingFont: UIFont.systemFont(ofSize: 17))))
    var widthipad = CGFloat((categoriesArray[indexPath.item].widthOfString(usingFont: UIFont.systemFont(ofSize: 22))))
    
    let heighth = categoriesArray[indexPath.item].height(constraintedWidth: width, font: UIFont.boldSystemFont(ofSize: 25))
    
        height = estimateFrameForText(text: categoriesArray[indexPath.item]).height + padding
    print("width === \(width)")
    print("widthipad == \(widthipad)")
    if width < 90 {
        width += 50
    }
    if widthipad < 115 {
        widthipad += 50
    }
    
    print("heibjkfjght == \(heighth)")
    print("Textheight == \(height)")
    
    
    if UIDevice.modelName.contains("iPhone") {
         return CGSize(width: width , height: 130)
    }else {
         return CGSize(width: widthipad , height: 120)
    }
   
  }
  

//
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//
//        if section == 0 {
//            return CGSize(width: UIScreen.main.bounds.width, height: 117)
//        }else {
//             return CGSize(width: UIScreen.main.bounds.width, height: 117)
//        }
//
//    }
    
    
    
    
    
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
      headerView.collView.delegate = self
      headerView.collView.dataSource = self
      headerView.buttonView.addShadowView()
      headerView.collView.register(UINib(nibName: "CategoriesCell", bundle: nil), forCellWithReuseIdentifier: "cell")
      headerView.cityNameAndStateNameLabel.text = cityAndStateName
      let resetTapAction = UITapGestureRecognizer(target: self, action: #selector(self.resetLabelTapped(_:)))
      headerView.resetLabel.isUserInteractionEnabled = true
      headerView.resetLabel.addGestureRecognizer(resetTapAction)
      // city label tapped
      let cityTapAction = UITapGestureRecognizer(target: self, action: #selector(self.cityLabelactionTapped(_:)))
      headerView.cityNameAndStateNameLabel.isUserInteractionEnabled = true
      headerView.cityNameAndStateNameLabel.addGestureRecognizer(cityTapAction)
    if UIDevice.modelName.contains("iPhone") {
          headerView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 120)
    }else {
          headerView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 130)
    }
      return headerView
  }
}

//MARK:- Toggles
extension HomeVC_New {
   func toggleShowViewNoResults(flag : Bool) {
    DispatchQueue.main.async {
      self.viewNoResults.alpha = flag ? 1 : 0
    }
  }
   func toggleDimBack(_ flag : Bool) {
    DispatchQueue.main.async {
     // self.dimView.alpha = flag ? 0.3 : 0
    }
  }
}



extension HomeVC_New: PinterestLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat{
        var ratio = Float()
        var height : CGFloat = 0
        var title = String()
        let width = CGFloat(UIScreen.main.bounds.width) / 3
        print("Count == \(productsArray.count)")
        if productsArray[indexPath.row].item_image_ratio  == 0 {
            ratio = 1
        }else {
            ratio = productsArray[indexPath.row ].item_image_ratio
        }
        title = productsArray[indexPath.row].item_title
        height = width  / CGFloat(ratio)
        print("Photo Height Back- == \(height), Photo Widht == \(width) , Photo Ratio\(ratio)")
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
//Tariq bahi Disable this Funcationality.
//MARK:- UIScrollViewDelegate
extension HomeVC_New : UIScrollViewDelegate {
    
    
    
    
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
   
    if scrollView == colVProducts {
         self.colVProducts.infiniteScrollTriggerOffset = 10
        scrollView.infiniteScrollTriggerOffset = 500
      let currentOffset = scrollView.contentOffset.y
      let maxOffset = scrollView.contentSize.height - scrollView.frame.height
        let height = self.colVProducts.contentSize.height
        
        print("contentoffset = \(scrollView.contentOffset.y)")
        print("scrollview height = \(scrollView.frame.height )")
       
        self.fidgetImageView.isHidden = true
        fidget.stopfiget(fidgetView: fidgetImageView)
    
        itemLoadingDescrib.isHidden = true
        
//        scrollView.contentSize = CGSize(width: scrollView.frame.size.height, height: height  )
     
        scrollView.delegate = self
        
        print("Height == \(scrollView.contentSize.height)")

        print("maxoffset == \(maxOffset) // == Currentoffset = \(currentOffset)")
        print( "maxoffset- currentoffset = \(maxOffset - currentOffset)")
            if maxOffset - currentOffset < 3000 {
                if FilterFlag {
                    self.getFilterData()
                    self.searchBoolen = false
                    
                }else if self.searchBoolen == true{
                    self.getSearchData(search: self.searchtext)
                    
                }else {
                    self.fetchDisplayData()
                }
            }

        

  



        }

        
        
    
    

  }
    
    
   
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView == colVProducts {
            
            if(velocity.y>0) {
                //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
                UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.SellUStuff.isHidden = false
                    self.tabBarController?.tabBar.isHidden = true
                    let currentOffset = scrollView.contentOffset.y
                    let maxOffset = scrollView.contentSize.height - scrollView.frame.height
                    print("MAX OFF = \(scrollView.contentSize.height)")
                    print("Hide")
                }, completion: nil)
                
            } else {
                UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.tabBarController?.tabBar.isHidden = false
                    self.SellUStuff.isHidden = true
                    print("Unhide")
                }, completion: nil)
            }
        }
        print("Data Fetching...  \(velocity.y)")
        
        if velocity.y > 2.5   {
            //self.fetchDisplayData()
        }
    }
    
   

}

extension HomeVC_New: SWRevealViewControllerDelegate {
  
  func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
    if position == FrontViewPosition.left {
      isOpen = 0
    }else {
      isOpen = 1
    }
  }
}

extension HomeVC_New : filtersVCDelegate {
    func getFilterData(param: [String : Any]) {
        print(param)
    }
    
   
    
    
    func btnDoneFiltersTapped1(_ country: String, _ itemAuctionType: String, _ itemCategory: String, _ condition: String, _ city: String, _ priceMin: Int, _ priceMax: Int,Latitude: Double, Longitude: Double) {
         print("filterss = \(country) \(itemAuctionType) \(itemCategory) \(condition) \(city)")
         countryF = country
         itemAuctionTypeF = itemAuctionType
         itemCategoryF = itemCategory
         conditionF = condition
         cityF = city
         priceMinF = String(priceMin)
         priceMaxF = String(priceMax)
         self.filterLat = String(Latitude)
        self.filterLong = String(Longitude)
    }
    
    
  func btnDoneFiltersTapped(_ category: String, _ auction: String, _ cityAndState: String, _ condition: String, _ priceMin: Int, _ priceMax: Int) {
    self.categoryToFilter = category
    self.buyingOptionToFilter = auction
 //  self.cityAndStateName = "\(city), \(stateName)"
     self.cityAndStateName = city
    print("city = \(city)")
    let parts = self.cityAndStateName!.components(separatedBy: ",")
   // stateName = parts[1].replacingOccurrences(of: " ", with: "")
   // self.conditionToFilter = condition
    self.priceMinFilter = priceMin
    self.priceMaxFilter = priceMax
    self.flagIsFilterApplied = true
    print("categoryToFilter \(categoryToFilter) , buyingOptionToFilter \(buyingOptionToFilter)")
    productsArray.removeAll()
    colVProducts.reloadData()
    
    if FilterFlag != true{
        print("here2 = \(FilterFlag)")
       fetchDisplayData()
    }
    //self.stateToFilter = state
  }
  
  
}

extension HomeVC_New {
  func checkFilteredData() {
    if FilteredDataFromFilterVcArray != nil && FilteredDataFromFilterVcArray.count >= 0{
      if FilteredDataFromFilterVcArray.count == 0 {
        self.flagIsFilterApplied = true
        //self.colVProducts.isHidden = true
        // emptyProductMessage.text = "No result Found, Try different Filter"
        hideCollectionView(hideYesNo: true)
        
      }else {
        self.flagIsFilterApplied = true
      }
      
    }else {
     self.flagIsFilterApplied = false
    }
    
  }
  
  func checkInternetAndShowNoResults() -> Bool{
    //check internet is available
    if !InternetAvailability.isConnectedToNetwork() {
      
      toggleShowViewNoResults(flag: true)
      fidgetImageView.isHidden = true
        fidget.stopfiget(fidgetView: fidgetImageView)
      return false
    }
    return true
  }
  func hideCollectionView(hideYesNo : Bool) {
    
    emptyProductMessage.text = "No products found, try searching with different filters"
    if hideYesNo == false {
      // colVProducts.isHidden = false
      fidgetImageView.isHidden = false
      emptyProductMessage.isHidden = true
    }
    else  {
      fidgetImageView.isHidden = true
        fidget.stopfiget(fidgetView: fidgetImageView)
      //colVProducts.isHidden = true
      // imgeView.isHidden = false
      emptyProductMessage.isHidden = false
    }
  }
  
  func setCustomBackImage() {
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
  }
}

//MARK:- UISearchBarDelegate
//extension HomeVC_New: UISearchBarDelegate{
//  
//  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//    let searchVCStoryBoard = getStoryBoardByName(storyBoardNames.searchVC)
//    let searchVC = searchVCStoryBoard.instantiateViewController(withIdentifier: "SearchVC")
//    self.navigationController?.view.backgroundColor = UIColor.clear
//    self.navigationController?.pushViewController(searchVC, animated: true)
//    
//    return false
//  }
//}

public extension UIImage {
    /**
     Calculates the best height of the image for available width.
     */
    public func height(forWidth width: CGFloat) -> CGFloat {
        let boundingRect = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: CGFloat(MAXFLOAT)
        )
        let rect = AVMakeRect(
            aspectRatio: size,
            insideRect: boundingRect
        )
        return rect.size.height
    }
}

extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}



extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

