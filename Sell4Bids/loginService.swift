//
//  loginService.swift
//  Sell4Bids
//
//  Created by admin on 8/27/19.
//  Copyright © 2019 admin. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON
class loginService{
    
    //MARK:- Variables
    static let instance = loginService()
    lazy var status = 0
    lazy var message = ""
    lazy var uid = ""
    lazy var apiStatus = false
    
    
    
//    MARK:- Private Functions
    
    //TODO:- Social Logins
    func SocialLoginApiCall(URL:String,param:[String:Any] ,completion: @escaping (Bool) -> ()) {
        let url = URL
        print(url)
        print(param)
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            print(response)
            self.message = ""
            self.status = 0
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
    
    
    //TODO:-  SignUp Api call
    
    func SignUpApiCall(URL:String,param:[String:Any] ,completion: @escaping (Bool) -> ()) {
        let url = URL
        print(url)
        print(param)
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")// response serialization result
            print(response)
            self.message = ""
            self.status = 0
            if response.result.error == nil{
                self.status = (response.response?.statusCode)!
                print(response)
                guard let data = response.data else {return}
                do{
                    if let jsonDic = try JSON(data: data).dictionary{
                       self.message = jsonDic["message"]?.string ?? ""
                       let uid = jsonDic["uid"]?.string ?? ""
                       UserDefaults.standard.set(uid, forKey: SessionManager.shared.userId)
                       self.apiStatus = jsonDic["status"]?.bool ??  false
                        
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
    
    //TODO:- Post Api call
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
    
    
    
}
