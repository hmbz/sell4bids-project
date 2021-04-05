//
//
//  ViewController.swift
//  socialLogins
//
//  Created by Admin on 9/26/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import FBSDKLoginKit
import FirebaseDatabase
import IQKeyboardManagerSwift
import AuthenticationServices
class WelcomeVc: UIViewController ,GIDSignInDelegate, UICollectionViewDelegateFlowLayout, ASAuthorizationControllerDelegate{
    
    //MARK:- Properties
    @IBOutlet weak var loginWithGoogleBtn: UIButton!
    @IBOutlet weak var loginWithFbBtn: FBLoginButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: ButtonSignIn!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var ShadowView: UIView!
    @IBOutlet weak var loginWithAppleBtn:ASAuthorizationAppleIDButton!
  @IBOutlet weak var appleimg: UIImageView!
    
    
    //MARK:- Variables
    var scrollTimer : Timer?
    var MainApis = MainSell4BidsApi()
    var array : [UIImage] = [#imageLiteral(resourceName: "onBoard1"),#imageLiteral(resourceName: "onBoard2"),#imageLiteral(resourceName: "onBoard3"),#imageLiteral(resourceName: "onBoard4"),#imageLiteral(resourceName: "onBoard5")]
    var dummyCount = 9
    var temp:CGPoint!
    var selectedPage = 0
    lazy var responseStatus = false
    
    //MARK:- View Life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
      loginWithAppleBtn.addTarget(self, action: #selector(handleAppleIdRequest1), for: .touchUpInside)
        setUpViews()
        startTimer()
       if let token = AccessToken.current,
           !token.isExpired {
           // User is logged in, do work such as go to next view controller.
       }else{
        loginWithFbBtn.permissions = ["public_profile", "email"]
        loginWithFbBtn.delegate = self
        
      }
        fidgetImageView.loadGif(name: gifNames[0])
        collectionView.delegate = self
        collectionView.dataSource = self
        loginWithFbBtn.shadowView()
        loginWithGoogleBtn.shadowView()
        signUpBtn.shadowView()
        loginBtn.shadowView()
        pageControl.numberOfPages = array.count
    }
  
  @objc func handleAppleIdRequest1() {
   let appleIDProvider = ASAuthorizationAppleIDProvider()
   let request = appleIDProvider.createRequest()
   request.requestedScopes = [.fullName, .email]
   let authorizationController = ASAuthorizationController(authorizationRequests: [request])
   authorizationController.delegate = self
   authorizationController.performRequests()
   }

     func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
     if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
  //   let userIdentifier = appleIDCredential.user
  //   let fullName = appleIDCredential.fullName
  //   let email = appleIDCredential.email
  //
  //      let appDelegate = UIApplication.shared.delegate! as! AppDelegate
      var loginEmail: String = "admin@brainplow.com"
      if appleIDCredential.email != nil{
        loginEmail = appleIDCredential.email!
      }else{
        let alert = UIAlertController(title: "Email Required!!!", message:"AllowEmail".localizableString(loc: LanguageChangeCode), preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok".localizableString(loc: LanguageChangeCode), style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        return
      }
     
    
          let LoginName = appleIDCredential.fullName!
          let token = appleIDCredential.user
          let parameter:[String:Any] = [
              "email": loginEmail,
              "name" :"\( LoginName.givenName!) \( String(describing: LoginName.familyName!))",
              "token" : token ,
              "country": "USA",
              "city":"New York",
              "lng":"-73.935242",
              "lat":"40.730610",
              "provider" : "facebook"
          ]
          self.SocialLogInApi(user: parameter)
      
  //                            let mainSB = getStoryBoardByName(storyBoardNames.main)
  //                            let initialViewController = mainSB.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
  //                            appDelegate.window?.rootViewController = initialViewController
  //                            appDelegate.window?.makeKeyAndVisible()
  //                            showSwiftMessageWithParams(theme: .success, title: appName, body: StrSuccessLogin)
  //
           

    
     }
       
       
       
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
               GIDSignIn.sharedInstance()?.presentingViewController = self
               GIDSignIn.sharedInstance().delegate = self
    }
    
    //MARK:- Action
    @IBAction func TermsandConditionbtn(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.urlString = termOfUseUrl
        vc.screenName = "Term of use"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func PrivacyandPolicybtn(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.urlString = privacyPolicyUrl
        vc.screenName = "Privacy Policy"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signupBtnTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginWithFbbtnAction(_ sender: Any) {
//        if InternetAvailability.isConnectedToNetwork() {
//
//            let loginManager = LoginManager()
//          loginManager.loginBehavior = .browser
//          loginManager.logOut()
//
//            loginManager.logIn(permissions: [.email,.publicProfile], viewController: self, completion: { (loginResult) in
//                switch loginResult {
//                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
//                    print("grantedPermissions == \(grantedPermissions)")
//                    print("declinedPermissions == \(declinedPermissions)")
//                    print(accessToken)
//                    self.getFBData()
//                case .cancelled:
//                  self.view.makeToast("StrCancelRegeuest".localizableString(loc: LanguageChangeCode), position: .center)
//                case .failed(let error):
//                    print(error)
//                    showSwiftMessageWithParams(theme: .error, title: "StrFacebookLoginFailed".localizableString(loc: LanguageChangeCode), body: "\(error.localizedDescription)")
//                }
//            })
//        }
//        else{
//          showSwiftMessageWithParams(theme: .error, title: appName, body: "StrCheckNetworkAvailibility".localizableString(loc: LanguageChangeCode))
//        }
    }
    
    //MARK:- Private functions
    
    private func setUpViews(){
        loginWithGoogleBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        loginWithGoogleBtn.layer.borderWidth = 1.5
      appleimg.layer.cornerRadius = 15
        if Env.isIpad {
            loginWithFbBtn.layer.cornerRadius = 25
            loginWithGoogleBtn.layer.cornerRadius = 25
            loginBtn.layer.cornerRadius = 25
            signUpBtn.layer.cornerRadius = 25
         loginWithAppleBtn.layer.cornerRadius = 25
          
        }else {
            loginWithFbBtn.layer.cornerRadius = 20
            loginWithGoogleBtn.layer.cornerRadius = 20
            loginBtn.layer.cornerRadius = 20
            signUpBtn.layer.cornerRadius = 20
            loginWithAppleBtn.layer.cornerRadius = 20
        }
    }
    
    func getFBData(){
        fidgetImageView.show()
        guard let accessToken = AccessToken.current else {
          showSwiftMessageWithParams(theme: .error, title: "StrFacebookLoginFailed".localizableString(loc: LanguageChangeCode), body: "StrInternalError".localizableString(loc: LanguageChangeCode))
            return
        }
        
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"])) { httpResponse, result, error   in
            if error != nil {
                NSLog(error.debugDescription)
                print(error.debugDescription)
                return
            }
            // Handle vars
            if let result = result as? [String:String],
                let loginEmail: String = result["email"],
                let LoginName:String = result["name"] {
                let token = accessToken.tokenString
                let parameter:[String:Any] = [
                    "email": loginEmail,
                    "name" : LoginName,
                    "token" : token ,
                    "country": "USA",
                    "city":"New York",
                    "lng":"-73.935242",
                    "lat":"40.730610",
                    "provider" : "facebook"
                ]
                self.SocialLogInApi(user: parameter)

            }

        }
        connection.start()
    }
    
    @IBAction func loginWithgoogleBtnAction(_ sender: Any){
        if InternetAvailability.isConnectedToNetwork() == true{
            GIDSignIn.sharedInstance().signIn()
        }
        else{
            fidgetImageView.isHidden = true
            fidgetImageView.image = nil
          showSwiftMessageWithParams(theme: .warning, title: "StrNetworkError".localizableString(loc: LanguageChangeCode), body: "StrCheckNetworkAvailibility".localizableString(loc: LanguageChangeCode))
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print(error ?? "google error")
            return
        }
        else {
            let parameters = ["param" : user] as [String : Any]
            print(parameters)
            _ = user.userID // For client-side use only!
            let nidToken = user.authentication.accessToken // Safe to send to the server
            let fullName = user.profile.name;
            _ = user.profile.givenName;
            let imageURl = user.profile.imageURL(withDimension: 256);
            let pathString = imageURl!.path // String
            print(pathString)
            _ = "https://lh5.googleusercontent.com\(pathString)"
            let email = user.profile.email
            if nidToken != nil {
                DispatchQueue.main.async {
                    let user :[String:Any] = [
                        "email": email! ,
                        "name" : fullName! ,
                        "token" : nidToken! ,
                        "country": "USA",
                        "city":"New York",
                        "lng":"-73.935242",
                        "lat":"40.730610",
                        "provider" : "google"
                    ]
                    self.SocialLogInApi(user: user)
                }
            }
        }
    }
    
    // facebook login get token api function
    func SocialLogInApi(user: [String:Any]){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.ShadowView)
            }
        }
        Networking.instance.postApiCall(url: socialMediaLoginUrl, param: user) { (response, Error, StatusCode) in
            print(response)
            self.responseStatus = true
            guard let jsonDic = response.dictionary else {return}
            let status = jsonDic["status"]?.bool ?? false
            if status == true {
                guard let userDic = jsonDic["user"]?.dictionary else {return}
                let email = userDic["email"]?.string ?? ""
                let Token = userDic["token"]?.string ?? ""
                let userId = userDic["_id"]?.string ?? ""
                let latitude =  userDic["latitude"]?.double ?? 00
                let longitude = userDic["longitude"]?.double ?? 00
                let image = userDic["image"]?.string ?? ""
                let name = userDic["name"]?.string ?? ""
                
                let zipCode = userDic["zipCode"]?.int ?? 0
                let state = userDic["state"]?.string ?? ""
                let city = userDic["city"]?.string ?? ""
                let country = userDic["country"]?.string ?? ""
                
                SessionManager.shared.Country = country
                SessionManager.shared.City = city
                SessionManager.shared.State = state
                SessionManager.shared.ZipCode = "\(zipCode)"
                
                SessionManager.shared.name = name
                SessionManager.shared.userId = userId
                SessionManager.shared.fcmToken = Token
                SessionManager.shared.email = email
                SessionManager.shared.image = image
                SessionManager.shared.latitude = "\(latitude)"
                SessionManager.shared.longitude = "\(longitude)"
                
                SessionManager.shared.isUserLoggedIn = true
                SessionManager.shared.loggedInThrough = loggedInThrough.facebook.hashValue
                UserDefaults.standard.set(false, forKey: SessionManager.shared.edBot)
                let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                let mainSB = getStoryBoardByName(storyBoardNames.main)
                let initialViewController = mainSB.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
              showSwiftMessageWithParams(theme: .success, title: appName, body: "StrSuccessLogin".localizableString(loc: LanguageChangeCode))
            }else {
                showSwiftMessageWithParams(theme: .info, title: appName, body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
            }
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension WelcomeVc : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return array.count * dummyCount
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellSlider = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let imageIndex = indexPath.item % array.count
        let image = array[imageIndex]
        cellSlider.myImage.tag = indexPath.row
        cellSlider.myImage.image = image
        return cellSlider
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(collectionView == self.collectionView){
            var page:Int =  Int(collectionView.contentOffset.x / collectionView.frame.size.width)
            page = page % array.count
            print("page = \(page)")
            pageControl.currentPage = Int (page)
        }
    }
}

extension WelcomeVc: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        stopTimer()
        
    }
    
    func startTimer() {
        if array.count > 1 && scrollTimer == nil {
            let timeInterval = 6.0
            scrollTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.rotate), userInfo: nil, repeats: true)
            scrollTimer!.fireDate = Date().addingTimeInterval(timeInterval)
        }
    }
    
    func stopTimer() {
        scrollTimer?.invalidate()
        scrollTimer = nil
    }
    
    @objc func rotate() {
        let offset = CGPoint(x:self.collectionView.contentOffset.x + cellWidth, y: self.collectionView.contentOffset.y)
        var animated = true
        if (offset.equalTo(CGPoint.zero) || offset.equalTo(CGPoint(x: totalContentWidth, y: offset.y))){
            animated = false
        }
        self.collectionView.setContentOffset(offset, animated: animated)
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.centerIfNeeded(animationTypeAuto: true, offSetBegin: CGPoint.zero)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == collectionView){
            if(scrollView.panGestureRecognizer.state == .began){
                stopTimer()
            }else if( scrollView.panGestureRecognizer.state == .possible){
            }
        }
    }
    
    
    func updatePageControl(){
        var updatedPage = selectedPage + 1
        let totalItems = array.count
        updatedPage = updatedPage % totalItems
        selectedPage  = updatedPage
        self.pageControl.currentPage = updatedPage
    }
    
    
    func centerIfNeeded(animationTypeAuto:Bool, offSetBegin:CGPoint) {
        let currentOffset = self.collectionView.contentOffset
        let contentWidth = self.totalContentWidth
        let width = contentWidth / CGFloat(dummyCount)
        if currentOffset.x < 0{
            //left scrolling
            self.collectionView.contentOffset = CGPoint(x: width - currentOffset.x, y: currentOffset.y)
        } else if (currentOffset.x + cellWidth) >= contentWidth {
            //right scrolling
            let  point = CGPoint.zero
            var tempCGPoint = point
            tempCGPoint.x = tempCGPoint.x + cellWidth
            print("center if need set offset to \( tempCGPoint)")
            self.collectionView.contentOffset = point
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("\(scrollView.contentOffset)")
        self.temp = scrollView.contentOffset
        self.stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.centerIfNeeded(animationTypeAuto: false, offSetBegin: temp)
        self.startTimer()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        DispatchQueue.main.async() {
            self.stopTimer()
            self.collectionView.reloadData()
            self.collectionView.setContentOffset( CGPoint.zero, animated: true)
            self.startTimer()
        }
    }
    
    var totalContentWidth: CGFloat {
        return CGFloat(array.count * dummyCount) * cellWidth
    }
    
    var cellWidth: CGFloat {
        return self.collectionView.frame.width
    }
//  @IBAction func loginwithapple(_ sender: UIButton){
//    
//  }
}
extension WelcomeVc: LoginButtonDelegate{
  func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    var token1 = result?.token?.tokenString
      
          let connection = GraphRequestConnection()
    
          connection.add(GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])) { httpResponse, result, error   in
              if error != nil {
                  NSLog(error.debugDescription)
                  print(error.debugDescription)
                  return
              }
             var loginEmail1 = ""
            var LoginNames = ""
              // Handle vars
            if let result = result as? [String:String]{
             
              if  let loginEmail: String = result["email"]{
                loginEmail1 = loginEmail
              }else{
               return  showSwiftMessageWithParams(theme: .error, title: appName, body: "StrSuccessLogin12".localizableString(loc: LanguageChangeCode))
              }
              if  let LoginName:String = result["name"]{
                LoginNames = LoginName
              }
            }
            
                  let parameter:[String:Any] = [
                      "email": loginEmail1,
                      "name" : LoginNames,
                      "token" : token1! ,
                      "country": "USA",
                      "city":"New York",
                      "lng":"-73.935242",
                      "lat":"40.730610",
                      "provider" : "facebook"
                  ]
                  self.SocialLogInApi(user: parameter)

          }
          connection.start()

  }
  
  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    print("logout")
  }
  
  
}
