//
//  loginVC.swift
//  socialLogins
//
//  Created by H.M.Ali on 9/27/17.
//  Copyright © 2017 Admin. All rights reserved.
//


import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin
import GoogleSignIn
import SkyFloatingLabelTextField
import AuthenticationServices
class LoginVC: UIViewController,ASAuthorizationControllerDelegate{
    
    //MARK:- Properties and Outlets
    @IBOutlet weak var viewDim: UIView!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPass: SkyFloatingLabelTextField!
    @IBOutlet weak var loginWithFbBtn: UIButton!
    @IBOutlet weak var loginWithGoogleBtn: DesignableButton!
    @IBOutlet weak var hideShowBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginWithApple: ASAuthorizationAppleIDButton!
    
    //MARK:- Variable
    var uid = String()
    var token = String()
    var MainApis = MainSell4BidsApi()
    var loginCred : LoginModel?
    lazy var responseStatus =  false
    lazy var DetailPageStatus = false
    
    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tfEmail.text = ""
        tfPass.text = ""
      if let token = AccessToken.current,
          !token.isExpired {
          // User is logged in, do work such as go to next view controller.
      }
        hideShowBtn.addTarget(self, action: #selector(showpass), for: .touchUpInside)
       loginWithApple.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        
    }
  @objc func handleAppleIdRequest() {
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
      let alert = UIAlertController(title: "Email Required!!!", message: "AllowEmail".localizableString(loc: LanguageChangeCode), preferredStyle: UIAlertControllerStyle.alert)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    //MARK:- Private Function
    private func setupViews() {
        loginWithFbBtn.shadowView()
        loginWithApple.shadowView()
        loginWithGoogleBtn.shadowView()
        loginBtn.shadowView()
        topView()
        hideKeyboardWhenTappedAround()
        if Env.isIpad {
            loginWithFbBtn.layer.cornerRadius = 30
            loginWithGoogleBtn.layer.cornerRadius = 30
          loginWithApple.layer.cornerRadius = 30
          loginWithApple.layer.borderWidth = 1.5
            loginWithGoogleBtn.layer.borderWidth = 1.5
            loginWithGoogleBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else {
            loginWithFbBtn.layer.cornerRadius = 25
            loginWithGoogleBtn.layer.cornerRadius = 25
            loginWithApple.layer.cornerRadius = 25
            loginWithApple.layer.borderWidth = 1.5
            loginWithGoogleBtn.layer.borderWidth = 1.5
            loginWithGoogleBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
    }
    
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        if DetailPageStatus == true {
            dismiss(animated: true, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
            tabBarController?.selectedIndex = 0
        }
    }
    
    
    var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    private func topView() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "StrLogIn".localizableString(loc: LanguageChangeCode)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        titleview.backBtn.addTarget(self, action: #selector(homeBtnTapped(sender:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    
    func SocialLogInApi(user: [String:Any]){
        Networking.instance.postApiCall(url: socialMediaLoginUrl, param: user) { (response, Error, StatusCode) in
            self.responseStatus = true
            if StatusCode == 502 {
                SweetAlert().showAlert(appName, subTitle: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode), style: .error, buttonTitle: "Ok".localizableString(loc: LanguageChangeCode), buttonColor: UIColor.black)
            }else {
              fidget.stopfiget(fidgetView: self.fidgetImageView)
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
    
    func LoginRequest(){
        self.viewDim.isHidden = false
        self.viewDim.alpha = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.loadGif(name: gifName)
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.viewDim)
            }
        }
        let user = ["email": tfEmail.text! , "password" : tfPass.text! , "platform" : "iOS"]
        Networking.instance.postApiCall(url: loginUrl, param: user) { (response, Error, StatusCode) in
            print(response)
            self.responseStatus = true
            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.viewDim)
            
            if StatusCode == 502 {
                showSwiftMessageWithParams(theme: .info, title: appName, body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
            }else {
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
                    let msg = jsonDic["message"]?.string ?? ""
                    showSwiftMessageWithParams(theme: .info, title: appName, body: msg)
                }
            }
        }
    }
    
    func getFBData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.loadGif(name: gifName)
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.viewDim)
            }
        }
        guard let accessToken = AccessToken.current else {
            showSwiftMessageWithParams(theme: .error, title: "StrFacebookLoginFailed".localizableString(loc: LanguageChangeCode), body: "StrCheckNetworkAvailibility".localizableString(loc: LanguageChangeCode))
                
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
    
    
    
    //MARK:- Actions
    @IBAction func SignUpbtn(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showpass() {
        if tfPass.isSecureTextEntry == true {
            tfPass.isSecureTextEntry = false
            hideShowBtn.setImage(UIImage(named: "eye (1)"), for: .normal)
        } else {
            tfPass.isSecureTextEntry = true
            hideShowBtn.setImage(UIImage(named: "hide (1)"), for: .normal)
        }
        
    }
    
    @IBAction func loginWithFbBtnAction(_ sender: Any) {
        if InternetAvailability.isConnectedToNetwork() {
            let loginManager = LoginManager()
          loginManager.logOut()
            
            loginManager.logIn(permissions: [.userAboutMe, .email], viewController: self, completion: { (loginResult) in
                
                switch loginResult {
                case .failed(let error):
                    print(error)
                    showSwiftMessageWithParams(theme: .error, title: "StrFacebookLoginFailed".localizableString(loc: LanguageChangeCode), body: "\(error.localizedDescription)")
                case .cancelled:
                    self.view.makeToast("StrCancelRegeuest".localizableString(loc: LanguageChangeCode), position: .center)
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print(grantedPermissions)
                    print(declinedPermissions)
                    print(accessToken)
                    self.getFBData()
                }
            })
            
        }
        else{
            showSwiftMessageWithParams(theme: .warning, title: "StrNetworkError".localizableString(loc: LanguageChangeCode), body: "StrCheckNetworkAvailibility".localizableString(loc: LanguageChangeCode))
        }
        
    }
    
    @IBAction func loginWithGoogleBtnAction(_ sender: Any) {
        if InternetAvailability.isConnectedToNetwork() == true{
            GIDSignIn.sharedInstance().signIn()
        }
        else{
            fidgetImageView.isHidden = true
            fidget.stopfiget(fidgetView: self.fidgetImageView)
            fidgetImageView.image = nil
            showSwiftMessageWithParams(theme: .warning, title: "StrNetworkError".localizableString(loc: LanguageChangeCode), body: "StrCheckNetworkAvailibility".localizableString(loc: LanguageChangeCode))
        }
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        if InternetAvailability.isConnectedToNetwork()==true{
            self.signInWithEmail()
        }
        else{
            showSwiftMessageWithParams(theme: .warning, title: "StrNetworkError".localizableString(loc: LanguageChangeCode), body: "StrCheckNetworkAvailibility".localizableString(loc: LanguageChangeCode))
            return
        }
        
    }
    @IBAction func forgetPasswordBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordStep1VC") as! ForgotPasswordStep1VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func signInWithEmail(){
        if tfEmail.text!.isEmpty || !isValidEmail(email: tfEmail.text!) {
            self.tfEmail.becomeFirstResponder()
            if !isValidEmail(email: tfEmail.text!) {
                self.view.makeToast("strInvalidEmailValidation".localizableString(loc: LanguageChangeCode) ,position:.top)
            }else {
                self.view.makeToast("strEmptyEmailValidation".localizableString(loc: LanguageChangeCode),position:.top)
            }
        }else if tfPass.text!.isEmpty {
            self.view.makeToast("strEmptyPassValidation".localizableString(loc: LanguageChangeCode),position:.top)
        }else {
            self.view.endEditing(true)
            LoginRequest()
        }
    }
}

extension LoginVC : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print(error ?? "google error")
            return
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if self.responseStatus == false {
                    self.fidgetImageView.toggleRotateAndDisplayGif()
                    Spinner.load_Spinner(image: self.fidgetImageView, view: self.viewDim)
                }
            }
            let nidToken = user.authentication.accessToken // Safe to send to the server
            if nidToken != nil {
                let fullName = user.profile.name
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
    }
}
extension LoginVC : UITextFieldDelegate{
    // functions for Regular Expression
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.tfEmail{
            if (textField.text?.isEmpty)!{
                print("email empty ")
//                textField.becomeFirstResponder()
            }
            else{
                if isValidEmail(email: tfEmail.text!){
                    print("Valid Email")
                }
                else{
                    unValidTextFieldData(textField:tfEmail)
                    self.view.makeToast("strInvalidEmailValidation".localizableString(loc: LanguageChangeCode),position: .center)
                }
            }
        }else if textField == tfPass {
            if tfPass.text!.isEmpty{
//                tfPass.becomeFirstResponder()
                self.view.makeToast("strEmptyPassValidation".localizableString(loc: LanguageChangeCode),position: .center)
            }
        }else {
            textField.endEditing(true)
        }
    }
}
// Put this piece of code anywhere you like

