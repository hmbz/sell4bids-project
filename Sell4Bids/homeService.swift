
//  homeService.swift
//  Sell4Bids
//
//  Created by admin on 8/5/19.
//  Copyright © 2019 admin. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON

class homeService{
    
    //MARK:-  Variable
    static let instance = homeService()
    lazy var status = 0
    lazy var message = ""
    lazy var imageInfoArray = [ImageInfoModel]()
    lazy var productArray = [productModelNew]()
    lazy var CatProductArray = [productModelNew]()
    lazy var CatImageInfoArray = [ImageInfoModel]()
    
    //MARK:-  Functions
    //TODO:- Filter Api for getting data to display on Home
    func CallFilterApi(URL:String,param:[String:Any] ,completion: @escaping (Bool,String) -> ()) {
        let url = URL
        print(url)
        print(param)
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            print(response)
            if response.result.error == nil{
                self.status = (response.response?.statusCode)!
                print(response)
                guard let data = response.data else {return}
                do{
                    if let jsonDic = try JSON(data: data).dictionary{
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
                }
                catch let jsonErr{
                    
                    print(jsonErr.localizedDescription)
                }
                completion (true, "\(response.error?.localizedDescription ?? "No Error")")
            }else{
                completion (false, "\(response.error?.localizedDescription ?? "ERROR".localizableString(loc: LanguageChangeCode))")
            }
        }
    }
    
    // calling Filter Api for Category
    func CategoryFilterApi(URL:String,param:[String:Any] ,completion: @escaping (Bool) -> ()) {
        let url = URL
        print(url)
        print(param)
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            print(response)
            if response.result.error == nil{
                self.status = (response.response?.statusCode)!
                print(response)
                guard let data = response.data else {return}
                do{
                    if let jsonDic = try JSON(data: data).dictionary{
                        let status = jsonDic["status"]?.bool ?? false
                        let totalCount = jsonDic["totalCount"]?.int ?? -1
                        let messageArray = jsonDic["message"]?.array ?? ["N/A"]
                        let msg = jsonDic["message"]?.string ?? ""
                        if msg != "" {
                            print(msg)
                            self.status = 502
                            completion(true)
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
                            self.CatImageInfoArray.removeAll()
                            let imagesInfoArray = MessageDic["images_info"]?.array ?? []
                            if imagesInfoArray.count > 0 {
                                for itemImages in imagesInfoArray {
                                    let ImageInfoDic = itemImages.dictionary
                                    let height = ImageInfoDic?["height"]?.float ?? -1
                                    let ratio = ImageInfoDic?["ratio"]?.float ?? -1
                                    let width = ImageInfoDic?["width"]?.float ?? -1
                                    let obj = ImageInfoModel.init(height: height, ratio: ratio, width: width)
                                    self.CatImageInfoArray.append(obj)
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
                            
                            let object = productModelNew.init(status: status, totalCount: totalCount, coordinates: coordinates, type: type, ImagePath: ImagePath, ImagePathSmall: ImagePathSmall, imageInfoArray: self.CatImageInfoArray, startTime: startTime, visibility: visibility, oldSmallImages: oldSmallImages, oldImages: oldImages, itemId: itemId, chargeTime: chargeTime, city: city, title: title, startPrice: startPrice, itemCategory: itemCategory, zipcode: zipcode, itemAuctionType: itemAuctionType, uid: uid, condition: condition, endTime: endTime, quantity: quantity, state: state, currencyString: currencyString, currencySymbol: currencySymbol, adminRejected: adminRejected)
                            self.CatProductArray.append(object)
                        }
                    }
                }
                catch let jsonErr{
                    
                    print(jsonErr.localizedDescription)
                }
                completion (true)
            }else{
                completion (false)
            }
        }
    }
    
}
