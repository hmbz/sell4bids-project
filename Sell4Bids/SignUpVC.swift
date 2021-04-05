//
//  SignUpVC.swift
//  socialLogins
//
//  Created by H.M.Ali on 9/27/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore
import Toast_Swift
import CoreLocation
import AuthenticationServices

class SignUpVC: UIViewController,GIDSignInDelegate,  CLLocationManagerDelegate, ASAuthorizationControllerDelegate{
    
    //MARK:- Properties
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginWitiFbBtn: UIButton!
    @IBOutlet weak var loginWithGoogleBtn: UIButton!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var hidAndShowBtn: UIButton!
    @IBOutlet weak var loginWithApple: ASAuthorizationAppleIDButton!
  var Country = ""
  var City = ""
  var Longitude = ""
  var Latitude = ""
  var state = ""
  var zipcode = ""
  var currentLocation = ""
    
    
    //MARK:- Variable
    var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    var responseStatus =  false
    
    //MARK:- View did load
    override func viewDidLoad() {
        super.viewDidLoad()
      loginWithApple.addTarget(self, action: #selector(handleAppleIdRequest2), for: .touchUpInside)
      let session = SessionManager.shared
      self.Longitude = session.longitude
      self.Latitude = session.latitude
       City = session.City
      state = session.State
      zipcode =  session.ZipCode
      currentLocation = "\(City), \(state) \(zipcode)"
      Country = session.Country
      print(currentLocation)
      
        setupSignUpView()
        topView()
    }
  
  
 @objc func handleAppleIdRequest2() {
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
      let locationManager = CLLocationManager()
      locationManager.requestAlwaysAuthorization()
      locationManager.requestWhenInUseAuthorization()
      if CLLocationManager.locationServicesEnabled() {
          locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
          locationManager.startUpdatingLocation()
      }
      
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    //MARK:- Private functions
    
    private func setupSignUpView() {
      loginWithApple.shadowView()
     
        if Env.isIpad {
            loginWitiFbBtn.layer.cornerRadius = 30
            loginWithGoogleBtn.layer.cornerRadius = 30
           loginWithApple.layer.borderWidth = 1.5
          loginWithApple.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            loginWithGoogleBtn.layer.borderWidth = 1.5
           loginWithApple.layer.cornerRadius = 25
            loginWithGoogleBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else {
            loginWitiFbBtn.layer.cornerRadius = 25
            loginWithGoogleBtn.layer.cornerRadius = 25
            loginWithGoogleBtn.layer.borderWidth = 1.5
           loginWithApple.layer.cornerRadius = 20
          loginWithApple.layer.borderWidth = 1.5
          loginWithApple.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            loginWithGoogleBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        loginWitiFbBtn.shadowView()
        loginWithGoogleBtn.shadowView()
        signUpBtn.shadowView()
    }
    
    private func topView() {
        self.navigationItem.titleView = titleview
      titleview.titleLbl.text = "StrSignUp".localizableString(loc: LanguageChangeCode)
       titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        titleview.backBtn.addTarget(self, action: #selector(homeBtnTapped(sender:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func homeBtnTapped(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
    }
    
    private func SignUpApiCall(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.dimView)
            }
        }
      var Body: [String:Any] = Dictionary<String,Any>()
      Body["email"] = tfEmail.text!
      Body["name"] = tfName.text!
      Body["country"] = "\(self.Country)"
      Body["lng"] = "\(self.Longitude)"
      Body["lat"] = "\(Latitude)"
      Body["password"] = tfPassword.text!
      Body["provider"] = "email"
     
      if self.City != "" {
        Body["city"] = "\(self.City)" as AnyObject
        
      }else{
        Body["city"] = "\(self.state)" as AnyObject
      }
      
      
        Networking.instance.postApiCall(url: SignUpURL, param: Body) { (response, Error, StatusCode) in
            self.responseStatus = true
            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.dimView)
            guard let jsonDic = response.dictionary else {return}
            let status = jsonDic["status"]?.bool
            let message = jsonDic["message"]?.string ?? ""
            if status == true{
                showSwiftMessageWithParams(theme: .success, title: "StrSignUp".localizableString(loc: LanguageChangeCode), body: message, completion: { (Move) in
                    self.navigationController?.popViewController(animated: true)
                })
            }else {
                self.responseStatus = true
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.dimView)
                showSwiftMessageWithParams(theme: .info, title: "StrSignUp".localizableString(loc: LanguageChangeCode), body: message)
            }
        }
    }
    
    func SocialLogInApi(user: [String:Any]){
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            if self.responseStatus == false {
//                self.fidgetImageView.toggleRotateAndDisplayGif()
//                Spinner.load_Spinner(image: self.fidgetImageView, view: self.dimView)
//            }
//        }
        Networking.instance.postApiCall(url: socialMediaLoginUrl, param: user) { (response, Error, StatusCode) in
            print(response)
//          self.fidgetImageView.hideview()
            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.dimView)
//          fidget.stopfiget(fidgetView: self.fidgetImageView)
          fidget.stopfiget(fidgetView: self.fidgetImageView)
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
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.dimView)
                self.responseStatus = true
                showSwiftMessageWithParams(theme: .info, title: appName, body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
            }
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
    
    func getFBData(){
        
//        fidgetImageView.show()
      DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          if self.responseStatus == false {
              self.fidgetImageView.loadGif(name: gifName)
              Spinner.load_Spinner(image: self.fidgetImageView, view: self.dimView)
          }
      }
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
    

    
    //MARK:- IBActions and user interaction
    
    @IBAction func hideAndShowPass(_ sender: Any) {
                if tfPassword.isSecureTextEntry == true {
                    tfPassword.isSecureTextEntry = false
                    hidAndShowBtn.setImage(UIImage(named: "eye (1)"), for: .normal)
                } else {
                    tfPassword.isSecureTextEntry = true
                    hidAndShowBtn.setImage(UIImage(named: "hide (1)"), for: .normal)
                }
    }
    
    @IBAction func loginWithFbBtnAction(_ sender: Any) {
        if InternetAvailability.isConnectedToNetwork() {
            let loginManager = LoginManager()
             loginManager.logOut()
            loginManager.logIn(permissions: [.publicProfile, .email], viewController: self, completion: { (loginResult) in
                switch loginResult {
                case .failed(let error):
                    showSwiftMessageWithParams(theme: .error, title: "StrFacebookLoginFailed".localizableString(loc: LanguageChangeCode), body: "\(error.localizedDescription)")
                case .cancelled:
                    self.view.makeToast("StrCancelRegeuest".localizableString(loc: LanguageChangeCode), position: .center)
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("grantedPermissions == \(grantedPermissions)")
                    print("declinedPermissions == \(declinedPermissions)")
                    print(accessToken)
                    self.getFBData()
                }
            })
            
        }
        else{
          showSwiftMessageWithParams(theme: .warning, title: "StrNetworkError".localizableString(loc: LanguageChangeCode) , body: "StrCheckNetworkAvailibility".localizableString(loc: LanguageChangeCode))
            
        }

        
    }
    
    @IBAction func loginWithGoogleBtnAction(_ sender: Any) {
        if InternetAvailability.isConnectedToNetwork() == true{
            GIDSignIn.sharedInstance().signIn()
        }
        else{
            fidgetImageView.isHidden = true
            fidgetImageView.image = nil
          showSwiftMessageWithParams(theme: .warning, title: "StrNetworkError".localizableString(loc: LanguageChangeCode) , body: "StrCheckNetworkAvailibility".localizableString(loc: LanguageChangeCode))
        }
    }
    
    @IBAction func signUpWithEmail(_ sender: Any) {
        
        if InternetAvailability.isConnectedToNetwork() == true{
            if self.tfName.text == "" || !isValidUserName(username: tfName.text!) {
              self.view.makeToast("strUsernameLengthValidation".localizableString(loc: LanguageChangeCode), position: .center)
            }
            else if self.tfEmail.text == "" || !isValidEmail(email: tfEmail.text!) {
              self.view.makeToast("strInvalidEmailValidation".localizableString(loc: LanguageChangeCode),position: .center)
            }
            else if self.tfPassword.text == "" ||  tfPassword.text!.count <= 7 {
              self.view.makeToast("strInvalidPassValidation".localizableString(loc: LanguageChangeCode),position: .center)
            }
            else {
                self.SignUpApiCall()
            }
        }
        else{
          showSwiftMessageWithParams(theme: .warning, title: "StrNetworkError".localizableString(loc: LanguageChangeCode) , body: "StrCheckNetworkAvailibility".localizableString(loc: LanguageChangeCode))
        }
    }
    

    @IBAction func fromSignUpToLoginBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension SignUpVC : UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        
         if textField == self.tfName{
            if (textField.text?.isEmpty)!{
                print("Username is empty")
              self.view.makeToast("strEmptyNameValidation".localizableString(loc: LanguageChangeCode),position: .center)
                textField.becomeFirstResponder()
            }
            else{
                if (tfName.text?.count)! < 3 || (tfName.text?.count)! > 64 {
                    self.view.makeToast("strUsernameLengthValidation".localizableString(loc: LanguageChangeCode),position: .center)
                    unValidTextFieldData(textField: tfName)
                }
                else if isValidUserName(username: tfName.text!){
                  print("Valid UserName")
                }
                else{
                    unValidTextFieldData(textField:tfName)
                   self.view.makeToast("strUsernameLengthValidation".localizableString(loc: LanguageChangeCode),position: .center)
                }
            }
        }
        else if textField == self.tfEmail{
            if (textField.text?.isEmpty)!{
              self.view.makeToast("strEmptyEmailValidation".localizableString(loc: LanguageChangeCode),position: .center)
                textField.becomeFirstResponder()
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
        }
        else if textField == self.tfPassword{
            if (textField.text?.isEmpty)!{
              self.view.makeToast("strEmptyPassValidation".localizableString(loc: LanguageChangeCode),position: .center)
                textField.becomeFirstResponder()
            }else {
                if isValidPassword(password: tfPassword.text!) {
                    print("Valid Password")
                }
                else {
                    unValidTextFieldData(textField: tfPassword)
                    self.view.makeToast("strInvalidPassValidation".localizableString(loc: LanguageChangeCode),position: .center)
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfName {
            if string.count == 0 {
                return true
            }
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            return prospectiveText.containsOnlyCharactersIn(matchCharacters: allowedCharcterforNameString) &&
                prospectiveText.count <= 64
        }
        else if textField == tfEmail {
            if string.count == 0 {
                return true
            }
            let currentText = textField.text ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            return prospectiveText.containsOnlyCharactersIn(matchCharacters: allowedCharacterForEmailString) &&
                prospectiveText.count <= 40
        }
        else if textField == tfPassword {
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else{
            return true
        }
    }
}


