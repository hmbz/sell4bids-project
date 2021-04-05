//
//  MainSell4BidsApi.swift
//  Sell4Bids
//
//  Created by admin on 08/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


public class MainSell4BidsApi {
    
    // http://192.168.100.27:8000/items/filter
    
    var IP2 = "http://192.168.29.183:3000"
    var IP = "https://apis.sell4bids.com"
//    let IP = "http://192.168.29.115:3000"
    var Port = "8000"
    var home = "/items/home"
    var filters = "/items/filter"
    var sellingItem = "/users/getSellingItemsStatus"
    var itemdetails = "/items/itemDetails"
    var watchList = "/users/getWatchingItems"
    var FollowingList = "/users/getFollowing"
    var FollowerList = "/users/getFollowers"
    var BlockList = "/users/getBlockedUsers"
    var unblockUser = "/users/unblockUser"
    var buyingItemm = "/items/getBuyingItems"
    var boughtList = "/items/getBoughtItems"
    var itemBuyNow = "/items/buyItem"
    var AutorelistItem = "/items/AutoReListing"
    var Hide_Show_Item = "/items/hideItem"
    var Set_Item_Quantity = "/items/setQuantity"
    var Item_TurboCharge = "/items/turboCharge"
    var Ordering_Status = "/items/orderingStatus"
    var Offering_Status = "/items/setAcceptingOffers"
    var Relist_Item = "/items/reListing"
    var GetUserDetails = "/users/userDetails"
    var GetOrders = "/items/getOrders"
    var RattingBuyyer = "/items/buyerRating"
    var Accept_Orders = "/items/acceptOrder"
    var Reject_Orders = "/items/rejectOrder"
    var SellerMarkedPaid = "/items/sellerMakedPaid"
    var ShareLocation = "/items/sellerShareLocation"
    var ItemListing = "/items/addItem"
    var HousingListing = "/items/addItem"
    var Joblisting = "/items/addItem"
    var ServiceListing = "/items/addItem"
    var VehiclesListing = "/items/addVehicle"
    var signUp = "/authentication/signup"
    var login = "/authentication/login"
    var forgotSendEmail = "/authentication/sendPasscode/"
    var sendPasscode = "/authentication/checkPasscode"
    var resetForgotPassword = "/authentication/changePassword"
    var loginWithFB_GoogleBtn =  "/authentication/socialMediaLogin"
    var setusertoken = "/users/setUserToken"
    var Bid_Now = "/items/bidItem"
    var currenttime = "/items/serverTime/"
    var BuyOffer = "/items/buyerOffer"
    var AcceptOffer = "/items/acceptOfferSeller"
    var RejectOffer = "/items/rejectOfferSeller"
    var sellerRating = "/items/sellerRating"
    var buyerRating = "/items/buyerRating"
    var send_counter_offer_buyer = "/items/buyerCounterOffer"
    var send_counter_offer_seller = "/items/sellerOffer"
    var sellerDetails = "/users/sellerDetails"
    var FollowUser = "/users/followUser"
    var UnFollowerUser = "/users/unfollowUser"
    var BlockUser = "/users//blockUser"
    var WinsList = "/items/wins"
    var BidItems = "/items/userBiddingHistory"
    var BidHistoryItem = "/items/itemBiddingHistory"
    var UserImageUpload = "/users/uploadUserImage"
    var EditUserDetails = "/users/updateUserDetails"
    var ChatListApi = "/chat/getLastChats"
    var GetChat = "/chat/getChat"
    var GetNotifications = "/notifications/getNotifications"
    var Watch_Item = "/users/watchItem"
    var UnWatch_Item = "/users/unwatchItem"
    var UserDetailsActivity = "/users/userCount"
    var readNoti = "/notifications/readNotification"
    var reportItem = "/items/reportItem"
    var endlisting = "/items/endingList"
    
    var GetZipCodeLatLong = "https://www.zipcodeapi.com/rest/tTJZRHMN8OQHrmHvRpWkUx6Q7mkcaFVUMNecIIc2zv5YH8CuSdaOQlS9uM9D9JD9/info.json"
    var notification_Count = "/notifications/getNotificationCount"
    
    
    var applyForJob = "/jobs/applyForJob"
    var getJobs = "/jobs/getJobs"
    var getYear = "/vehicles/getYears"
    var getMake = "/vehicles/getMake"
    var getModel = "/vehicles/getModel"
    var getTrim = "/vehicles/getTrim"
    var getFuelType = "/vehicles/getFuelType"
    var getAllCVs = "/jobs/getJobs"
    var JobRejected = "/jobs/rejectCandidate"
    var JobShortlistedCandidate = "/jobs/shortListCandidate"
    var uid = String()
    var fileData = NSData()
    var fileName = String()
    var filtercalled = Bool()
    var status = 0
    var message = ""
    
    
    func Home_Api(lat : String , lng : String ,country : String, start : String , limit : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["lat": lat , "lng" : lng , "country" : country, "start" : start , "limit" : limit ]
         let url = "\(IP)\(filters)"
        print("Filter Url = ",url)
        print("Parameter == \(parameter)")
        
       
        
        Alamofire.request( url, method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    func filter_Api(lat : String , long : String , country : String , itemAuctionType : String , itemCategory : String , condition : String , title : String ,city : String , start : String , limit : String , min_price : String , max_price : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["lat" : lat , "lng" : long ,"country": country , "itemAuctionType" : itemAuctionType , "itemCategory" : itemCategory , "condition" : condition , "title" : title , "city" : city , "start" : start , "limit" : limit , "minPrice": min_price , "maxPrice": max_price ]
        
        print("Search_Data == \(parameter)")
        
        Alamofire.request("\(IP)\(filters)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
               
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response = Filter \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response filter --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Selling_Api(user_ID : String ,country : String, start : String , limit : String ,type : String,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid": user_ID , "country" : country, "start" : start , "limit" : limit  , "type" : type]
        
        Alamofire.request("\(IP)\(sellingItem)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode  Seller = \(statusCode!)")
                print("Response Seller = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Seller --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    func Item_Details(uid : String , country : String , seller_uid : String , item_id : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid": uid , "country" : country  , "item_id" : item_id ,"seller_uid" : seller_uid ,"platform" : "iOS"]
        print("\(IP)\(itemdetails)")
        print("parameters == \(parameter)")
        Alamofire.request("\(IP)\(itemdetails)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode Items = \(statusCode!)")
                print("Response Items = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func WatchList_Api(user_ID : String ,country : String, start : String , limit : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid": user_ID , "country" : country, "start" : start , "limit" : limit ]
        
        Alamofire.request("\(IP)\(watchList)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Following_Api(user_ID : String ,country : String, start : String , limit : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid": user_ID , "country" : country, "start" : start , "limit" : limit ]
        
        Alamofire.request("\(IP)\(FollowingList)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Follower_Api(user_ID : String ,country : String, start : String , limit : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid": user_ID , "country" : country, "start" : start , "limit" : limit ]
        
        Alamofire.request("\(IP)\(FollowerList)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Follower = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func BlockList_Api(user_ID : String ,country : String, start : String , limit : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid": user_ID , "country" : country, "start" : start , "limit" : limit ]
        
        Alamofire.request("\(IP)\(BlockList)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Unblock_Api(user_ID : String ,blockUserID : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        
        
        Alamofire.request("\(IP)\(unblockUser)/\(user_ID)/\(blockUserID)" , method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func BuyingList_Api(user_ID : String ,country : String, start : String , limit : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid": user_ID , "country" : country, "start" : start , "limit" : limit ]
        
        Alamofire.request("\(IP)\(buyingItemm)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func BoughtList_Api(user_ID : String ,country : String, start : String , limit : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid": user_ID , "country" : country, "start" : start , "limit" : limit ]
        
        Alamofire.request("\(IP)\(boughtList)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                print(swiftyJsonVar)
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func WinsList_Api(user_ID : String ,country : String, start : String , limit : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid": user_ID , "country" : country, "start" : start , "limit" : limit ]
        
        Alamofire.request("\(IP)\(WinsList)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    
    
    
    func Buy_Now_Item(country : String ,boughtQuantity : Int, buyerName : String , seller_uid : String ,buyer_uid : String ,itemId : String ,seller_email : String ,buyImage : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["country": country , "bought_quantity" : boughtQuantity, "buyer_name" : buyerName , "seller_uid" : seller_uid , "buyer_uid" : buyer_uid , "item_id" : itemId , "buyer_email" : seller_email ,"buyer_image" : buyImage] as [String : Any]
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(itemBuyNow)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    func SignUp_Api(name : String ,email : String, password : String , country : String , city : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["name": name , "email" : email, "password" : password , "country" : country , "city" : city, "platform" : "iOS", "provider": "email" ]
        
        Alamofire.request("\(IP)\(signUp)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func AutoRelist_Item(country : String ,autoReList : Bool, item_id : String,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["country": country , "autoReList" : autoReList, "item_id" : item_id  ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(AutorelistItem)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Hide_Show_Item(country : String ,visibility : Bool, item_id : String,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["country": country , "visibility" : visibility, "item_id" : item_id  ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(Hide_Show_Item)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Login_Api(email : String ,password : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["email": email , "password" : password , "platform" : "iOS"]
        
        print("login parameter == \(parameter)")
        Alamofire.request("\(IP)\(login)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            print(response)
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    func Set_item_Quantity(country : String ,quantity : Int, item_id : String,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["country": country , "quantity" : quantity, "item_id" : item_id  ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(Set_Item_Quantity)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func ForgotSendEmail_Api(email : String  ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        //  let parameter = ["email": email ]
        
        Alamofire.request("\(IP)\(forgotSendEmail)\(email)" , method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    func Item_TurboCharge(country : String , item_id : String,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["country": country , "item_id" : item_id  ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(Item_TurboCharge)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func SendPasscode_Api(email : String ,passcode : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["email": email , "passcode" : passcode ]
        
        Alamofire.request("\(IP)\(sendPasscode)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    func Ordering_Status(country : String ,ordering : Bool , item_id : String,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["country": country ,"ordering" : ordering, "item_id" : item_id  ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(Ordering_Status)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    func ResetForgotPassword_Api(email : String ,password : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["email": email , "password" : password ]
        
        Alamofire.request("\(IP)\(resetForgotPassword)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Offer_Status(country : String , acceptOffers : Bool , item_id : String,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["country": country ,"acceptOffers" : acceptOffers, "item_id" : item_id  ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(Offering_Status)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    func ItemListing_Api(lat : Double , lng : Double , user_Token : String , user_Name : String , user_Image : String , user_ID : String , country : String , city : String , title : String , itemCategory : String , condition : String , description : String , currency_string : String , currency_symbol : String , quantity : String , payPeriod : String , autoReList : String , acceptOffers : String , zipCode : String , UI_Image : [UIImage] , endTime : String , startPrice : String , itemAuctionType : String , visibility : Bool , reservePrice : String, SelectOption : String , base_price : String ,State: String, completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        var Parameters = [String : Any]()
        
        let Buyingparameters = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city , "title" : title , "itemCategory" : itemCategory , "condition" : condition , "description" : description , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "quantity" : quantity , "autoReList" : autoReList , "acceptOffers" : acceptOffers , "zipCode" : zipCode , "endTime" : endTime , "itemAuctionType" : itemAuctionType , "visibility" : visibility, "startPrice" : startPrice ,"state":State, "platform" : "iOS"] as [String : Any]
        
        let Auction_Reserve = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city ,"state":State, "title" : title , "itemCategory" : itemCategory , "condition" : condition , "description" : description , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "autoReList" : autoReList , "zipCode" : zipCode , "endTime" : endTime , "startPrice" : startPrice , "itemAuctionType" : itemAuctionType , "visibility" : visibility , "reservePrice" : reservePrice , "platform" : "iOS" , "base_price" : base_price] as [String : Any]
        
        let Auction_nonReserve = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city ,"state":State, "title" : title , "itemCategory" : itemCategory , "condition" : condition , "description" : description , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "autoReList" : autoReList , "zipCode" : zipCode , "endTime" : endTime , "startPrice" : startPrice , "itemAuctionType" : itemAuctionType , "visibility" : visibility , "platform" : "iOS" , "base_price" : base_price] as [String : Any]
        
        print("select Option MainApi == \(SelectOption)")
        
        if SelectOption.contains("Buying") {
            Parameters = Buyingparameters
        }
        if SelectOption.contains("Auction-NonReserve") {
            Parameters = Auction_nonReserve
        }
        if SelectOption.contains("Auction-Reserve") {
            Parameters = Auction_Reserve
        }
        
        print("parameters == \(Parameters)")
        let imgData: NSData = NSData(data: UIImageJPEGRepresentation((UI_Image.last!), 1)!)
        // var imgData: NSData = UIImagePNGRepresentation(image)
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        let imageSize: Int = imgData.count
        print( "Quality = \(Double(imageSize) / 1000.0)")
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var imagesData : [Data] = []
            for _image in UI_Image{
                if let data: Data = UIImageJPEGRepresentation(_image as UIImage, 0.9) {
                    imagesData.append(data)
                }
            }
            
            
            for i in 0..<imagesData.count{
                multipartFormData.append(imagesData[i], withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in Parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key )
            }
            
            
            
        }, to:"\(IP)\(ItemListing)",
            method: .post
            )
            
        {
            (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("progess == \(progress.fractionCompleted)")
                    //Print progress
                })
                
                upload.responseJSON { response in
                    //print response.result
                    print(response.request)
                    print(response.result)
                    print(response.response)
                    let data = JSON(response.result.value)
                    let status = data["status"].boolValue
                    let statusCode = response.response?.statusCode
                    completionHandler(status, data , "Response Get")
                }
                
            case .failure(let encodingError):
            //print encodingError.description
            completionHandler(false, JSON(encodingError) , encodingError.localizedDescription)
                break
            }
        }
    }
    
    
    func HousingListing_Api(lat : Double , lng : Double , user_Token : String , user_Name : String , user_Image : String , user_ID : String , country : String , city : String , title : String , itemCategory : String , condition : String , description : String , housingType : String , bedrooms : Int , bathrooms : Int , laundry : String , parking : String , address : String , squareFeet : Int , availableOn : String ,  openHouseDate : String , petsAccepted : Bool , noSmoking : Bool , wheelChairAccess : Bool , monthlyRent : Int , roomType : String , bathType : String,  currency_string : String , currency_symbol : String , quantity : String , payPeriod : String , autoReList : String , acceptOffers : String , zipCode : String , UI_Image : [UIImage] , endTime : String , startPrice : String , itemAuctionType : String , visibility : Bool , reservePrice : String, SelectOption : String , base_price : String , completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        var Parameters = [String : Any]()
        
        let Buyingparameters = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city , "title" : title , "itemCategory" : itemCategory , "condition" : condition , "description" : description , "housingType" : housingType , "bedrooms" : bedrooms , "bathrooms" : bathrooms , "laundry" : laundry , "parking" : parking , "address" : address , "squareFeet" : squareFeet , "availableOn" : availableOn ,  "openHouseDate" : openHouseDate , "petsAccepted" : petsAccepted , "noSmoking" : noSmoking , "wheelChairAccess" : wheelChairAccess , "monthlyRent" : monthlyRent , "roomType" : roomType , "bathType" : bathType , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "quantity" : quantity , "autoReList" : autoReList , "acceptOffers" : acceptOffers , "zipCode" : zipCode , "endTime" : endTime , "itemAuctionType" : itemAuctionType , "visibility" : visibility, "startPrice" : startPrice , "platform" : "iOS"] as [String : Any]
        let Auction_Reserve = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city , "title" : title , "itemCategory" : itemCategory , "condition" : condition , "description" : description , "housingType" : housingType , "bedrooms" : bedrooms , "bathrooms" : bathrooms , "laundry" : laundry , "parking" : parking , "address" : address , "squareFeet" : squareFeet , "availableOn" : availableOn ,  "openHouseDate" : openHouseDate , "petsAccepted" : petsAccepted , "noSmoking" : noSmoking , "wheelChairAccess" : wheelChairAccess , "monthlyRent" : monthlyRent , "roomType" : roomType , "bathType" : bathType , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "autoReList" : autoReList , "zipCode" : zipCode , "endTime" : endTime , "startPrice" : startPrice , "itemAuctionType" : itemAuctionType , "visibility" : visibility , "reservePrice" : reservePrice , "platform" : "iOS" , "base_price" : base_price] as [String : Any]
        
        let Auction_nonReserve = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city , "title" : title , "itemCategory" : itemCategory , "condition" : condition , "description" : description , "housingType" : housingType , "bedrooms" : bedrooms , "bathrooms" : bathrooms , "laundry" : laundry , "parking" : parking , "address" : address , "squareFeet" : squareFeet , "availableOn" : availableOn ,  "openHouseDate" : openHouseDate , "petsAccepted" : petsAccepted , "noSmoking" : noSmoking , "wheelChairAccess" : wheelChairAccess , "monthlyRent" : monthlyRent , "roomType" : roomType , "bathType" : bathType , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "autoReList" : autoReList , "zipCode" : zipCode , "endTime" : endTime , "startPrice" : startPrice , "itemAuctionType" : itemAuctionType , "visibility" : visibility , "platform" : "iOS" , "base_price" : base_price] as [String : Any]
        
        print("select Option MainApi == \(SelectOption)")
        
        if SelectOption.contains("Buying") {
            Parameters = Buyingparameters
        }
        if SelectOption.contains("Auction-NonReserve") {
            Parameters = Auction_nonReserve
        }
        if SelectOption.contains("Auction-Reserve") {
            Parameters = Auction_Reserve
        }
        
        print("parameters == \(Parameters)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var imagesData : [Data] = []
            for _image in UI_Image{
                if let data: Data = UIImageJPEGRepresentation(_image as UIImage, 0.9) {
                    imagesData.append(data)
                }
            }
            
            
            for i in 0..<imagesData.count{
                multipartFormData.append(imagesData[i], withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in Parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key )
            }
            
            
            
        }, to:"\(IP)\(HousingListing)",
            method: .post
            )
            
        {
            
            (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("progess == \(progress.fractionCompleted)")
                    //Print progress
                })
                
                upload.responseJSON { response in
                    //print response.result
                    print(response.result.value)
                    let data = JSON(response.result.value)
                    let status = data["status"].boolValue
                    
                    completionHandler(status, data , "Response Get")
                }
                
            case .failure(let encodingError): break
            //print encodingError.description
            
            completionHandler(false, JSON(encodingError) , encodingError.localizedDescription)
            }
        }
    }
    
    
    func JobListing_Api(lat : Double , lng : Double , user_Token : String , user_Name : String , user_Image : String , user_ID : String , country : String , city : String , title : String , employmentType : String , Medical : String,PTO : String ,K401 : String , jobCategory : String , jobExperiance :String , description : String , currency_string : String , currency_symbol : String , startPrice : String, endTime : String , payPeriod : String , acceptOffers : String , zipCode : String , visibility : Bool , UI_Image : [UIImage] , itemAuctionType : String , itemCategory : String , companyName : String , companyDescription : String,State: String, completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        
        
        let parameters = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city ,"state":State, "title" : title , "employmentType" : employmentType , "Medical" : Medical , "PTO" : PTO , "FZOk" : K401 , "jobCategory" : jobCategory , "jobExperience" : jobExperiance, "description" : description , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "startPrice" : startPrice, "endTime" : endTime , "payPeriod" : payPeriod , "acceptOffers" : acceptOffers , "zipCode" : zipCode ,  "visibility" : visibility , "itemAuctionType" : itemAuctionType , "itemCategory" : itemCategory , "platform" : "iOS" , "companyName" : companyName , "companyDescription" : companyDescription] as [String : Any]
        
        print("parameters == \(parameters)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            if  UI_Image != nil {
                var imagesData : [Data] = []
                for _image in UI_Image{
                    if let data: Data = UIImageJPEGRepresentation(_image as UIImage, 0.9) {
                        imagesData.append(data)
                    }
                }
               
                for i in 0..<imagesData.count{
                    multipartFormData.append(imagesData[i], withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key )
                }
            }else {
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key )
                }
            }
            
            
            
        }, to:"\(IP)\(Joblisting)",
            method: .post
            )
            
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("progess == \(progress.fractionCompleted)")
                    //Print progress
                })
                
                upload.responseJSON { response in
                    //print response.result
                    
                    let data = JSON(response.result.value)
                    let status = data["status"].boolValue
                    
                    completionHandler(status, data , "Response Get")
                }
                
            case .failure(let encodingError): break
            //print encodingError.description
            
            completionHandler(false, JSON(encodingError) , encodingError.localizedDescription)
            }
        }
    }
    
    
    func Relist_Item(country : String , startPrice : Int , endTime : Int ,item_id : String , itemCategory : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["country": country ,"startPrice" : startPrice, "endTime" : endTime , "item_id" : item_id , "itemCategory" : itemCategory] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(Relist_Item)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Get_User_Detail(uid : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid" : uid ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(GetUserDetails)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Get_Orders(seller_uid : String ,item_id : String , type : String , sellerImage : String , start : String , limit : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["seller_uid" : seller_uid , "item_id" : item_id , "type" : type , "start" :  start , "limit" : limit] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.GetOrders)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value!)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    func Ratting_Buyyer(buyer_uid : String ,itemId : String , orderId : String , buyerName : String , buyerImage : String , ratting : Double ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["seller_uid" : buyer_uid , "item_id" : itemId , "order_id" : orderId, "buyer_name" : buyerName , "buyer_image" : buyerImage , "rating" : ratting  ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.RattingBuyyer)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Accept_Order_Api(seller_uid : String ,itemId : String , orderId : String , sellerName : String , sellerImage : String,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["seller_uid" : seller_uid , "item_id" : itemId , "order_id" : orderId, "sellerName" : sellerName , "sellerImage" : sellerImage] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.Accept_Orders)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Reject_Order_Api(seller_uid : String ,itemId : String , orderId : String , sellerName : String , sellerImage : String ,orderRejectReason : String  , quantity : Int ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["seller_uid" : seller_uid , "item_id" : itemId , "order_id" : orderId, "sellerName" : sellerName , "sellerImage" : sellerImage ,"orderRejectReason" : orderRejectReason , "quantity" : quantity ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.Reject_Orders)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func SellerMarkedPaid_Api(seller_uid : String ,itemId : String , orderId : String , sellerName : String , sellerImage : String ,seller_marked_paid : Bool ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["seller_uid" : seller_uid , "itemId" : itemId , "order_id" : orderId, "sellerName" : sellerName , "sellerImage" : sellerImage ,"seller_marked_paid" : seller_marked_paid ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.SellerMarkedPaid)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    func Share_Location_Api(address : String ,itemId : String , orderId : String , lat : Double , lng : Double ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["address" : address , "item_id" : itemId , "order_id" : orderId, "lat" : lat , "lng" : lng ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.ShareLocation)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func ServiceListing_Api(lat : Double , lng : Double , user_Token : String , user_Name : String , user_Image : String , user_ID : String , country : String , city : String , title : String , serviceType : String , description : String , currency_string : String , currency_symbol : String , servicePrice : String, negotiable : String , zipCode : String , visibility : Bool , UI_Image : [UIImage] , itemAuctionType : String , itemCategory : String , endTime : String , payPeriod : String , userRole : String , selectButton : String,State:String, completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        var Parameters = [String : Any]()
        
        let Seller_parameters = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city , "title" : title , "serviceType" : serviceType , "description" : description , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "startPrice" : servicePrice , "negotiable" : negotiable , "zipCode" : zipCode ,  "visibility" : visibility , "itemAuctionType" : itemAuctionType , "itemCategory" : itemCategory , "endTime" : endTime , "userRole" : userRole , "platform" : "iOS" , "payPeriod" : payPeriod] as [String : Any]
        
        let Buyer_parameters = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city , "title" : title , "serviceType" : serviceType , "description" : description , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "startPrice" : servicePrice , "acceptOffers" : negotiable , "zipCode" : zipCode ,  "visibility" : visibility , "itemAuctionType" : itemAuctionType , "itemCategory" : itemCategory , "endTime" : endTime , "userRole" : userRole , "platform" : "iOS" , "payPeriod" : payPeriod] as [String : Any]
        
        print("Selectbutton_MainApi_Class ==== \(selectButton)")
        
        if selectButton.contains("Offer"){
            Parameters = Seller_parameters
            print("parameters == \(Seller_parameters)")
            print("Serives Listing is Hitting_Offer")
        }else if selectButton.contains("Want") {
            Parameters = Buyer_parameters
            print("parameters == \(Buyer_parameters)")
            print("Serives Listing is Hitting_Want")
        }
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var imagesData : [Data] = []
            for _image in UI_Image{
                if let data: Data = UIImageJPEGRepresentation(_image as UIImage, 0.9) {
                    imagesData.append(data)
                }
            }
            
            for i in 0..<imagesData.count{
                multipartFormData.append(imagesData[i], withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in Parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key )
            }
        }, to:"\(IP)\(ServiceListing)",
            method: .post
            )
            
            
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("progess == \(progress.fractionCompleted)")
                    //Print progress
                })
                
                upload.responseJSON { response in
                    //print response.result
                    
                    let data = JSON(response.result.value)
                    let status = data["status"].boolValue
                    
                    completionHandler(status, data , "Response Get")
                }
                
            case .failure(let encodingError): break
            //print encodingError.description
            
            completionHandler(false, JSON(encodingError) , encodingError.localizedDescription)
            }
        }
        
    }
    
    func LoginWithFB_Api(name : String ,email : String , token : String , lat : String , lng : String , city : String , country : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["email": email , "name" : name , "token" : token , "lat" : lat , "lng" : lng , "city" : city , "country" : country , "provider" : "facebook" , "platform" : "iOS"]
        
        print("parameters == \(parameter)")
        
        Alamofire.request("\(IP)\(loginWithFB_GoogleBtn)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    func LoginWithGoogle_Api(name : String ,email : String , token : String , lat : String , lng : String , city : String , country : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["email": email , "name" : name , "token" : token , "lat" : lat , "lng" : lng , "city" : city , "country" : country , "provider" : "google" , "platform" : "iOS"]
        
        print("parameters == \(parameter)")
        
        Alamofire.request("\(IP)\(loginWithFB_GoogleBtn)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    func Bid_Now_Api(bidAmount : String ,item_id : String , buyerUid : String , buyerName : String , buyerToken : String , buyerEmail : String  ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["item_id" : item_id,"bidAmount": bidAmount , "buyerUid" : buyerUid , "buyerName" : buyerName , "buyerToken" : buyerToken , "buyerEmail" : buyerEmail ]
        
        print("parameters == \(parameter)")
        
        Alamofire.request("\(IP)\(Bid_Now)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    func Set_User_Token(uid : String ,token : String   ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid": uid , "token" : token ]
        
        print("parameters token == \(parameter)")
        
        Alamofire.request("\(IP)\(setusertoken)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    func ServerTime(completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        
        Alamofire.request("\(IP)\(currenttime)" , method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    func ApplyForJob_Api(item_id:String, seller_uid:String, professionalSummary:String, expereince:String, expectedSalary:String, currentSalary:String, contactNo:String, jobSeekerEmail:String, jobSeekerName:String, jobSeekerImage:String, document : String ,jobSeekerUid : String , country_code : String , jobCategory : String, completionHandler: @escaping (Bool, JSON?,String) -> ()){
        
        let parameters = ["item_id":item_id, "seller_uid":seller_uid, "professionalSummary":professionalSummary, "experience":expereince, "expectedSalary":expectedSalary, "currentSalary":currentSalary, "contactNo":contactNo, "email":jobSeekerEmail, "jobSeekerName":jobSeekerName, "jobSeekerImage":jobSeekerImage, "document" : document , "jobSeekerUid" : jobSeekerUid , "country_code" : country_code , "jobCategory" : jobCategory ]
        
        print("ApplyForJob Parameters  == \(parameters)")
        
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(self.fileData as Data, withName: "document", fileName: self.fileName, mimeType: "text/plain")
            
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: "\(IP)\(applyForJob)", method: .post
            )
            
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("progess == \(progress.fractionCompleted)")
                    //Print progress
                })
                
                upload.responseJSON { response in
                    //print response.result
                    
                    let data = JSON(response.result.value)
                    let status = data["status"].boolValue
                    
                    completionHandler(status, data , "Response Get")
                }
                
            case .failure(let encodingError): break
            //print encodingError.description
            
            completionHandler(false, JSON(encodingError) , encodingError.localizedDescription)
            }
        }
    }
    
    
    func VehicleListing_Api(lat : Double , lng : Double , user_Token : String , user_Name : String , user_Image : String , user_ID : String , country : String , city : String , title : String , itemCategory : String , condition : String , description : String , currency_string : String , currency_symbol : String , quantity : String , payPeriod : String , autoReList : String , acceptOffers : String , zipCode : String , UI_Image : [UIImage] , endTime : String , startPrice : String , itemAuctionType : String , visibility : Bool , reservePrice : String, SelectOption : String , year : String , make : String , model : String , trim : String , millage : String , fuel_type : String , color : String , base_price : String ,State: String, completionHandler: @escaping (Bool, JSON?,String) -> ()){
        
        var Parameters = [String : Any]()
        
        let Buyingparameters = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city ,"state":State, "title" : title , "itemCategory" : itemCategory , "condition" : condition , "description" : description , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "quantity" : quantity , "autoReList" : autoReList , "acceptOffers" : acceptOffers , "zipCode" : zipCode , "endTime" : endTime , "itemAuctionType" : itemAuctionType , "visibility" : visibility, "startPrice" : startPrice , "platform" : "iOS" , "year" : year , "make" : make , "model" : model , "trim" : trim , "miles_driven" : millage , "fuel_type" : fuel_type , "color" : color , "base_price" : base_price] as [String : Any]
        
        let Auction_Reserve = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city ,"state":State, "title" : title , "itemCategory" : itemCategory , "condition" : condition , "description" : description , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "autoReList" : autoReList , "zipCode" : zipCode , "endTime" : endTime , "startPrice" : startPrice , "itemAuctionType" : itemAuctionType , "visibility" : visibility , "reservePrice" : reservePrice , "platform" : "iOS" , "year" : year , "make" : make , "model" : model , "trim" : trim , "miles_driven" : millage , "fuel_type" : fuel_type , "color" : color , "base_price" : base_price] as [String : Any]
        
        let Auction_nonReserve = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city ,"state":State, "title" : title , "itemCategory" : itemCategory , "condition" : condition , "description" : description , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "autoReList" : autoReList , "zipCode" : zipCode , "endTime" : endTime , "startPrice" : startPrice , "itemAuctionType" : itemAuctionType , "visibility" : visibility , "platform" : "iOS" , "year" : year , "make" : make , "model" : model , "trim" : trim , "miles_driven" : millage , "fuel_type" : fuel_type , "color" : color , "base_price" : base_price] as [String : Any]
        print("select Option MainApi == \(SelectOption)")
        print("VEhicelsImage == \(UI_Image)")
        
        if SelectOption.contains("Buying") {
            Parameters = Buyingparameters
        }
        if SelectOption.contains("Auction-NonReserve") {
            Parameters = Auction_nonReserve
        }
        if SelectOption.contains("Auction-Reserve") {
            Parameters = Auction_Reserve
            print("Auction_Reserve ===== \(Auction_Reserve)")
        }
        
        print("parameters == \(Parameters)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var imagesData : [Data] = []
            for _image in UI_Image{
                if let data: Data = UIImageJPEGRepresentation(_image as UIImage, 0.9) {
                    imagesData.append(data)
                }
            }
            
            
            for i in 0..<imagesData.count{
                multipartFormData.append(imagesData[i], withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in Parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key )
            }
            
            
            
        }, to: "\(IP)\(VehiclesListing)",
            method: .post
            )
            
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("progess == \(progress.fractionCompleted)")
                    //Print progress
                })
                
                upload.responseJSON { response in
                    //print response.result
                    
                    let data = JSON(response.result.value)
                    let status = data["status"].boolValue
                    
                    completionHandler(status, data , "Response Get")
                }
                
            case .failure(let encodingError): break
            //print encodingError.description
            
            completionHandler(false, JSON(encodingError) , encodingError.localizedDescription)
            }
        }
    }
    
    func Get_years_Api(country: String , completionHandler: @escaping (Bool, JSON?,String) -> ()){
        
        let parameters = [ "country": country ] as [String : Any]
        
        Alamofire.request("\(IP)\(getYear)" , method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
            
            
        }
    }
    
    
    func Get_FuelType_Api(completionHandler: @escaping (Bool, JSON?,String) -> ()){
        
        Alamofire.request("\(IP)\(getFuelType)" , method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func Buy_Offer(buyer_uid : String ,offer_price : String , item_id : String ,offer_quantity : String , offerType : String , buyer_name : String , buyer_image : String , itemCategory : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["buyer_uid": buyer_uid , "offer_price" : offer_price  , "item_id" : item_id , "offerType" : offerType  , "buyer_name" : buyer_name ,"buyer_image" : buyer_image , "offer_quantity" : offer_quantity , "itemCategory" : itemCategory]
        
        print("parameters token == \(parameter)")
        
        Alamofire.request("\(IP)\(BuyOffer)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    
    func Get_Offers(seller_uid : String ,item_id : String , type : String , sellerImage : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["seller_uid" : seller_uid , "item_id" : item_id , "type" : type ,"limit":"50", "start" : 0 ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.GetOrders)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response.response?.statusCode)
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func Accept_Offer_Api(seller_name : String ,seller_image : String , seller_uid : String , item_id : String, order_id : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["seller_name" : seller_name , "seller_image" : seller_image , "seller_uid" : seller_uid , "order_id" : order_id  , "item_id" : item_id ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.AcceptOffer)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func Reject_Offer_Api(seller_name : String ,seller_image : String , seller_uid : String , item_id : String, order_id : String , orderRejectReason : String,  quantity:String,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["seller_name" : seller_name , "seller_image" : seller_image , "seller_uid" : seller_uid , "order_id" : order_id , "orderRejectReason" : orderRejectReason , "item_id" : item_id, "quantity": quantity] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.RejectOffer)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    
    
    
    func SellerRatting_Offer(buyerName : String ,buyerImage : String , item_id : String , rating : Double, buyer_uid : String , order_id : String  ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["buyerName" : buyerName , "buyerImage" : buyerImage , "buyer_uid" : buyer_uid , "order_id" : order_id , "rating" : rating , "item_id" : item_id ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.sellerRating)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    

    
    func BuyerRatting_Offer(sellerName : String ,sellerImage : String , seller_uid : String , item_id : String, order_id : String , rating : Double  ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["sellerName" : sellerName , "sellerImage" : seller_uid , "seller_uid" : seller_uid , "order_id" : order_id , "item_id" : item_id , "rating" : rating  ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.buyerRating)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    func Send_Counter_Offer_buyer(seller_uid : String ,buyer_uid : String , product_image : String , offer_price : String, item_id : String , offer_quantity : String , product_title : String , buyer_name : String , product_category : String , product_auction_type : String , product_state : String , buyer_image : String , offer_count : Int, order_id : String , itemCategory : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["seller_uid" : seller_uid , "buyer_uid" : buyer_uid , "product_image" : product_image , "offer_price" : offer_price , "item_id" : item_id , "offer_quantity" : offer_quantity , "product_title" : product_title , "buyer_name" : buyer_name , "product_category" : product_category , "product_auction_type" : product_auction_type , "product_state" : product_state ,  "buyer_image" : buyer_image, "offer_count" : offer_count , "order_id" : order_id , "itemCategory" : itemCategory ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.send_counter_offer_buyer)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
  
    
    func Send_Counter_Offer_Seller(seller_uid : String ,buyer_uid : String , offer_price : String , item_id : String, offer_quantity : String , order_id : String , offer_count : Int , seller_name : String , seller_image : String , itemCategory : String , completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["seller_uid" : seller_uid , "buyer_uid" : buyer_uid  , "offer_price" : offer_price , "item_id" : item_id , "offer_quantity" : offer_quantity , "offer_count" : offer_count , "order_id" : order_id  , "seller_image" : seller_image , "itemCategory" : itemCategory] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.send_counter_offer_seller)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
 
    
    func Seller_Detail_Api(buyer_uid : String ,seller_uid : String , completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["seller_uid" : seller_uid , "buyer_uid" : buyer_uid  ] as [String : Any]
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(self.IP)\(self.sellerDetails)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
               
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                print(response)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
   
    
    func Follow_User(follower_Id : String ,following_id : String , completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["follower_Id" : follower_Id , "uid" : following_id  ] as [String : Any]
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        print("Para == \(parameter)")
        let url = "\(self.IP)\(self.FollowUser)"+"/"+"\(following_id)"+"/"+"\(follower_Id)"
        print("Url unFollowing === \(url)")
        Alamofire.request( url, method: .get, encoding: URLEncoding.queryString).responseJSON { (response) in
            switch response.result {
            
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
        
    }
    
    
    
    
    func UnFollow_User(follower_Id : String ,following_id : String , completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["follower_Id" : follower_Id , "uid" : following_id  ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        let url = "\(self.IP)\(self.UnFollowerUser)"+"/"+"\(following_id)"+"/"+"\(follower_Id)"
        print("Url unFollowing === \(url)")
        Alamofire.request( url, method: .get, encoding: URLEncoding.queryString).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    func block_Api(user_ID : String ,blockUserID : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        
        
        Alamofire.request("\(IP)\(BlockUser)/\(user_ID)/\(blockUserID)" , method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    func BidItems_Api(user_ID : String ,country : String, start : String , limit : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid": user_ID , "country" : country, "start" : start , "limit" : limit ]
        
        Alamofire.request("\(IP)\(BidItems)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response BidsItems = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response BidsItems --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    func BidHistoryItems_Api(item_id : String , start : String , limit : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["item_id" : item_id , "start" : start , "limit" : limit]
        
        Alamofire.request("\(IP)\(BidHistoryItem)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response BidsItems = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response BidsItems --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    func UserImageUpload_Api(country_code : String , uid : String, image : UIImage ,  completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        
        
        let parameters = ["country_code" : country_code , "uid" : uid ] as [String : Any]
        
        print("parameters == \(parameters)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            
            if let data: Data = UIImageJPEGRepresentation(image as UIImage, 0.9) {
                
                
                
                multipartFormData.append(data, withName: "profileImage", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key )
            }
     
        }, to: "\(IP)\(UserImageUpload)",
            method: .post
            )
            
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("progess == \(progress.fractionCompleted)")
                    //Print progress
                })
                
                upload.responseJSON { response in
                    //print response.result
                    
                    let data = JSON(response.result.value)
                    let status = data["status"].boolValue
                    print("Status =", status)
                    completionHandler(status, data , "Response Get")
                }
                
            case .failure(let encodingError): break
            //print encodingError.description
            print(encodingError.localizedDescription)
            
            completionHandler(false, JSON(encodingError) , encodingError.localizedDescription)
            }
        }
    }
    
    
    
    func EditUser_Details(uid : String , city : String ,lat : String ,lng : String ,country : String ,state : String ,zipcode : String ,name : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["state" : state ,"zipcode" : zipcode ,"name" : name  , "uid" : uid]
        
        
        print("Parameter = \(parameter)")
        Alamofire.request("\(IP)\(EditUserDetails)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response BidsItems = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response BidsItems --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    func Get_Chat_List(uid : String , start : Int, limit :Int ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid" : uid , "start" : start, "limit" : limit] as [String : Any]
        
        print("URL === Chat == \(IP)\(ChatListApi)")
        print("Parameter = \(parameter)")
        Alamofire.request("\(IP)\(ChatListApi)" , method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Chat Request = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response BidsItems --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    func Get_Chat(buyer_uid: String, item_id : String , start : Int, limit :Int ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["buyer_uid" : buyer_uid , "item_id" : item_id , "start" : start, "limit" : limit] as [String : Any]
        
        print("URL === Chat == \(IP)\(ChatListApi)")
        print("Parameter = \(parameter)")
        Alamofire.request("\(IP)\(GetChat)" , method: .post, parameters: parameter, encoding: JSONEncoding.prettyPrinted).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Chat Request = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response BidsItems --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    func Get_Make_Api(year: String , country : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()){
        
        let parameters = ["year" : year , "country" : country]
        
        print("parameters == \(parameters)")
        
        Alamofire.request("\(IP)\(getMake)" , method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
            
        }
    }
    
    
    func Get_Model_Api(year: String , make : String , country : String , completionHandler: @escaping (Bool, JSON?,String) -> ()){
        
        let parameters = [ "year" : year , "make" : make , "country" : country ]
        
        print("parameters == \(parameters)")
        
        Alamofire.request("\(IP)\(getModel)" , method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
            
        }
    }
    
    func Get_Trim_Api(year: String , make : String , model : String , country : String , completionHandler: @escaping (Bool, JSON?,String) -> ()){
        
        let parameters = [ "year" : year , "make" : make , "model" : model , "country" : country]
        
        Alamofire.request("\(IP)\(getTrim)" , method: .post , parameters: parameters , encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
            
        }
    }
    
    
    func View_Applications(item_id : String , seller_uid : String , start : Int , limit : Int ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["item_id": item_id , "seller_uid" : seller_uid , "start" : start , "limit" : limit  ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(getAllCVs)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Job_Rejected_Api(job_id : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["job_id": job_id] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(JobRejected)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    func Job_CV_Shortlist_Api(job_id : String ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["job_id": job_id] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(JobShortlistedCandidate)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    func Get_Notification(uid: String, start: Int, limit :Int ,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid": uid, "start": start, "limit" :limit] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(self.GetNotifications)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            print(response.value)
            switch response.result {
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    func Watch_Item(uid : String ,itemid : String , completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let url = "\(self.IP)\(self.Watch_Item)"+"/"+"\(uid)"+"/"+"\(itemid)"
        print("Url unFollowing === \(url)")
        Alamofire.request( url, method: .get, encoding: URLEncoding.queryString).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = (statusCode!)")
                print("Response Home = (swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
        
    }
    
    
    func UnWatch_Item(uid : String ,itemid : String , completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let url = "\(self.IP)\(self.UnWatch_Item)"+"/"+"\(uid)"+"/"+"\(itemid)"
        print("Url unFollowing === \(url)")
        Alamofire.request( url, method: .get, encoding: URLEncoding.queryString).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = (statusCode!)")
                print("Response Home = (swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
        
    }
    
    
    
    
    func ReadNoti(noti_id : String,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        //        let parameter = ["id": noti_id] as [String : Any]
        
        
        //        print("Parameter == \(parameter)")
        
        let url = "\(self.IP)\(self.readNoti)"+"/"+"\(noti_id)"
        print("Url Read Noti === \(url)")
        
        Alamofire.request(url , method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    
    func Report_Item(uid : String, report : String, item_id : String, seller_uid : String,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["uid" : uid, "report" : report, "item_id" : item_id, "seller_uid" : seller_uid] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(self.reportItem)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    
    
    func End_Listing(reason : String, item_id : String,completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["reason" : reason, "item_id" : item_id] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        Alamofire.request("\(IP)\(self.endlisting)" , method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
    }
    
   

  
    func UserActivityDetails(uid : String  , completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let url = "\(self.IP)\(self.UserDetailsActivity)"+"/"+"\(uid)"
        print("Url unFollowing === \(url)")
        Alamofire.request( url, method: .get, encoding: URLEncoding.queryString).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
        
    }
    
    
    
    
    
    
    
    func GetZipCodeLatLong(Zipcode : String ,Units : String , completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let url = "\(self.GetZipCodeLatLong)"+"/"+"\(Zipcode)"+"/"+"\(Units)"
        print("Url unFollowing === \(url)")
        Alamofire.request( url, method: .get, encoding: URLEncoding.queryString).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = (statusCode!)")
                print("Response Home = (swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
        
    }
    
    
    func Notification_Count(User_Id : String , completionHandler: @escaping (Bool, JSON?,String) -> ()) {
        
        let parameter = ["User_ID" : User_Id  ] as [String : Any]
        
        
        print("Parameter == \(parameter)")
        
        print("Para == \(parameter)")
        print("Para == \(parameter)")
        let url = "\(self.IP)\(self.notification_Count)"+"/"+"\(User_Id)"
        print("Url Notification === \(url)")
        Alamofire.request( url, method: .get, encoding: URLEncoding.queryString).responseJSON { (response) in
            switch response.result {
                
                
                
            case .success(_):
                let swiftyJsonVar = JSON(response.result.value)
                
                let status = swiftyJsonVar["status"].boolValue
                let statusCode = response.response?.statusCode
                print("Statuscode = \(statusCode!)")
                print("Response Home = \(swiftyJsonVar)")
                completionHandler(status, JSON(swiftyJsonVar),"Response Get")
            case .failure(let error):
                print("Response Home --\(error.localizedDescription)")
                
                
                completionHandler(false, JSON(error),error.localizedDescription)
            }
        }
        
    }
    
    // Call Post Api Call
    func postApiCall(URL:String,param:[String:Any] ,completion: @escaping (Bool) -> ()) {
        let url = URL
        print(url)
        print(param)
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            print(response)
            self.message = ""
            if response.result.error == nil{
                self.status = (response.response?.statusCode)!
                print(response)
                guard let data = response.data else {return}
                do{
                    if let jsonDic = try JSON(data: data).dictionary{
                        let message = jsonDic["message"]?.string ?? ""
                        self.message = message
                    print(jsonDic)
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
    
    // Social Login Api call
    func SocialLoginApiCall(URL:String,param:[String:Any] ,completion: @escaping (Bool) -> ()) {
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
                        let message = jsonDic["message"]?.string ?? ""
                        self.message = message
                        guard let userDic = jsonDic["user"]?.dictionary else {return}
                        let email = userDic["email"]?.string ?? ""
                        let Token = userDic["token"]?.string ?? ""
                        let userId = userDic["_id"]?.string ?? ""
                        let latitude =  userDic["latitude"]?.double ?? 00
                        let longitude = userDic["longitude"]?.double ?? 00
                        let image = userDic["image"]?.string ?? ""
                        let name = userDic["name"]?.string ?? ""
                        let uid = userDic["uid"]?.string ?? ""
                        self.uid = uid
                        SessionManager.shared.name = name
                        SessionManager.shared.userId = userId
                        SessionManager.shared.fcmToken = Token
                        SessionManager.shared.email = email
                        SessionManager.shared.image = image
                        SessionManager.shared.latitude = "\(latitude)"
                        SessionManager.shared.longitude = "\(longitude)"
                        
                        let params:[String:Any] = ["Name":name,
                                      "UserId":userId,
                                      "Token":Token,
                                      "Email":email,
                                      "Image":image,
                                      "Latitude":latitude,
                                      "Lobgitude":longitude,
                                      "UID":uid]
                        print(params)
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
