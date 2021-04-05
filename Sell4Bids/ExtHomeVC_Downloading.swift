//
//  ExtHomeVC_Downloading.swift
//  Sell4Bids
//
//  Created by MAC on 17/07/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Firebase
import SDWebImage
import Alamofire
import SwiftyJSON
import ViewAnimator
import Kingfisher



extension HomeVC_New {
    
    
    func fetchDisplayData() {
                 print("Data Fetching.........")
        
        
       
        let start = self.productsArray.count
        
        self.DimView.isHidden = false
        self.DimView.backgroundColor = .clear
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.isHidden = false
                self.fidgetImageView.loadGif(name: "red")
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
           
            let latitude : String = String(lat)
            let longtidue : String = String(long)

            self.MainApis.Home_Api(lat:  latitude , lng: longtidue , country: gpscountry, start: "\(start)", limit: "25", completionHandler: { (status, swifymessage, error) in
                print("Called = Yes Home")
                self.toggleDimBack(false)
                print(swifymessage)
                let message = swifymessage!["message"].arrayValue
               
                if status {
                    
                    self.responseStatus = true
                    self.fidgetImageView.isHidden = true
                    self.DimView.isHidden = true
                    for (index , items) in message.enumerated() {
                        self.totalcount += 1
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
                        var imagesmall = [String]()
                        let image0_small = items["old_images"]
                        for img in image0_small {
                            imagesmall.append(img.1.stringValue)
                        }
                        
                        let imageex_small = items["old_images"].arrayObject
                        var imagearray = [String]()
                        let image1_small = items["old_images"]
                        for imgs in image1_small {
                            imagearray.append(imgs.1.stringValue)
                        }
                        let image2_small = items["images_path"].arrayValue
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
                        
                        if itemid == "5c8cc7896ffe92181315d034" {
                            
                        }else {
                            
                        
                            let products = Products.init(total_count: total_count, status: status, quantity: quantity, item_id: itemid, old_images: imagearray, item_title: title, item_category: itemCategory, item_zipcode: zipcode, item_latitude: item_latitude, item_longtitude: item_longtitude, item_seller_id: uid, item_start_time: item_start_time, old_small_images: imagesmall, item_auction_type: itemAuctionType, item_condition: item_condition, item_endTime: item_endtime, item_city: item_city, item_state: item_state, item_startPrice: startPrice , currency_symbol: currency_symbol , currency_string: currency_string, isListingEnded: isListedEnded)
                        
                        DispatchQueue.main.async {
                            
                           
                          
                        
                        self.productsArray.append(products)
                            
                            if products.old_images.count > 0 {
                                products.item_image.sd_setImage(with: URL(string: products.old_images[0]), placeholderImage: #imageLiteral(resourceName: "emptyImage"))
                                
                               
                                if self.productsArray.count <= 25 {
                                    self.colVProducts.reloadData()
                                }else {
                                    self.colVProducts.reloadData()
                                    
                                }
                            }
                            
                            for images_info_value in images_info {
                                
                                products.item_image_height = images_info_value.1["height"].floatValue
                                products.item_image_width = images_info_value.1["width"].floatValue
                                products.item_image_ratio = images_info_value.1["ratio"].floatValue
                                print("Image Info Values == \(images_info_value.1["width"].floatValue)")
                            }
                            
                          
                            }
                            
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
                    fidget.stopfiget(fidgetView: self.fidgetImageView)
                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                    alert.addAction(ok)
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
            })
          
        }
        
    }
    
    
  ///downloads 1 image of the product for each product in products array for height calculation in heightForPhoto
  public func downloadAndSaveImages ( completion: @escaping (Bool) -> () ) {
    var i = 0
    let dispatchGroup = DispatchGroup.init()


    for product in productsArray {

      guard let photoIndex = self.productsArray.index(where: { (aProduct:Products) -> Bool in
        return aProduct.item_id == product.item_id

      }) else {
        print("no product found in downloadAndSaveImages function  ")
        print("product : \(product)")
        i += 1
        continue

      }
     
      var imageUrlToUse : URL?
        if product.old_small_images.count > 0 {
            let urlStr = product.old_images[0]
            let url = URL.init(string: urlStr as! String)
            imageUrlToUse = url
        }
    
      

      
      //print("i in outside : \(i)")
      //print("image url is \(imageUrl)")

      dispatchGroup.enter()

        downloader.shouldDecompressImages = false
        print("Image downloaded = \(imageUrlToUse)")
        downloader.downloadImage(with: imageUrlToUse, options: SDWebImageDownloaderOptions.highPriority, progress: nil) {[weak self] (image_, data, error, success) in
        guard let strongSelf = self else { return }

        i += 1

        if let image = image_ {

          
          let cellSpacing :CGFloat = 8
          let colvNumOfColumns :CGFloat = 3
          let width = (strongSelf.view.frame.width / colvNumOfColumns) - cellSpacing * colvNumOfColumns
          //print("before scaling, image size \(image.size)")
            let scaledImage : UIImage? =  imageWithImage(sourceImage: image, scaledToWidth: width)
          //print("after scaling, image size \(scaledImage.size)")
      
          guard photoIndex < strongSelf.productsArray.count else { return }
          
          strongSelf.productsArray[photoIndex].item_image.image = scaledImage ?? #imageLiteral(resourceName: "emptyImage")
            
           

        }else {

          //print("could not download image with url : \(imageUrlToUse)")
          //print("product title : \(product.title as Any)")

          
          guard photoIndex < strongSelf.productsArray.count else { return }
          strongSelf.productsArray[photoIndex].item_image.image = #imageLiteral(resourceName: "emptyImage")

        }
        dispatchGroup.leave()
        //print("i = \(i)")



      }

    }


    dispatchGroup.notify(queue: .main) {

      print("i = \(i)")
      print("strongSelf.productsArray.count \(self.productsArray.count)")


      completion(true)


    }

  }
}

extension HomeVC_New {
  func getUserBlockedList(completion : @escaping (Bool) -> ()) {
    guard let userId = Auth.auth().currentUser?.uid  else {return}
    dbRef.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
      self.blockedUserIdArray.removeAll()
      if let dictObj = snapshot.value as? NSDictionary {
        if   let blockedPerson = dictObj.value(forKeyPath: "blockedPersons") as? NSDictionary {
          for value in blockedPerson {
            let blockedPerson = value.key as! String
            self.blockedUserIdArray.append(blockedPerson)
          }
          
          // print(blockedPerson.)
        }
      }
      completion(true)
    }
    
    
  }
}

extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}


extension UIImageView {
    
    
    func downloadImageFromUrl(_ url: String, defaultImage: UIImage? = UIImage(named: "empty")) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) -> Void in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    return
            }
        }).resume()
    }

    public func imageFromServerURL(urlString: String) {
        self.image = nil
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}
