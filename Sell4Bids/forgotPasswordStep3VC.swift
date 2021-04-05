//
//  forgotPasswordStep3VC.swift
//  Sell4Bids
//
//  Created by admin on 2/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class forgotPasswordStep3VC: UIViewController, UITextFieldDelegate {
    
    var emailAddress = ""
    var MainApis = MainSell4BidsApi()
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var reEnterPassword: UITextField!
    @IBOutlet weak var hideUnhideBtnPass: UIButton!
    @IBOutlet weak var hideUnhideBtnRePass: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView()
        submitBtn.addShadowAndRound()
        hideUnhideBtnPass.addTarget(self, action: #selector(showForPass), for: .touchUpInside)
        hideUnhideBtnRePass.addTarget(self, action: #selector(showForRePass), for: .touchUpInside)
    }
    
    
    @IBAction func SubmitAction(_ sender: Any) {
        
        
        if (password.text?.isEmpty)! || (reEnterPassword.text?.isEmpty)!{
            //self.alert(message: "Please fill required fields", title: "ERROR".localizableString(loc: LanguageChangeCode))
            _ = SweetAlert().showAlert("Forget Password", subTitle: "Please fill required fields" , style: AlertStyle.error,buttonTitle:
                "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            
        }else if password.text! != reEnterPassword.text!{
            print("pass verify")
            //self.alert(message: "Please enter a valid email address to continue", title: "User Authentication")
            _ = SweetAlert().showAlert("Forget Password", subTitle: "  Your password and confirmation password do not match." , style: AlertStyle.error,buttonTitle:
                "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
        }else{
            passwordChangeRequest()
            password.endEditing(true)
            reEnterPassword.endEditing(true)
        }
    }
    
    //    else if !(Sell4Bids.isEmailValid(text: password.text!)){
    //
    //    self.alert(message: "Password must contain at least 1 Capital Alphabet, 1 Number and 1 Special Character", title: "User Authentication")
    //    self.password.shake()
    
    
    @objc func showForPass() {
        if password.isSecureTextEntry == true {
            password.isSecureTextEntry = false
            hideUnhideBtnPass.setImage(UIImage(named: "eye (1)"), for: .normal)
        } else {
            password.isSecureTextEntry = true
            hideUnhideBtnPass.setImage(UIImage(named: "hide (1)"), for: .normal)
        }
        
    }
    
    @objc func showForRePass() {
        if reEnterPassword.isSecureTextEntry == true {
            reEnterPassword.isSecureTextEntry = false
            hideUnhideBtnRePass.setImage(UIImage(named: "eye (1)"), for: .normal)
        } else {
            reEnterPassword.isSecureTextEntry = true
            hideUnhideBtnRePass.setImage(UIImage(named: "hide (1)"), for: .normal)
        }
        
    }
    
    
    func passwordChangeRequest(){
        
        MainApis.ResetForgotPassword_Api(email: emailAddress, password: reEnterPassword.text!, completionHandler: { (status, swifymessage, error) in
            
            let message = swifymessage!["message"].stringValue
            
            if status {
                
                _ = SweetAlert().showAlert("", subTitle: "Sell4bids Password Reset", style: AlertStyle.warning, buttonTitle:"Thanks", buttonColor:UIColor.colorFromRGB(0x000000)) { (status) -> Void in
                    
                    if(status==true){
                        
                        let appdelegate = UIApplication.shared.delegate as! AppDelegate
                        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVc") as! WelcomeVc
                        let nav = UINavigationController(rootViewController: homeViewController)
                        appdelegate.window!.rootViewController = nav
                        appdelegate.window?.makeKeyAndVisible()
                        homeViewController.reloadInputViews()
                    }
                }
                
                
                
                //     self.alert(message: "Your password has been changed", title: "")
                //                let alertController = UIAlertController(title: "", message: "Your password has been changed", preferredStyle: .alert)
                //
                //                let okAction = UIAlertAction(title: "Ok".localizableString(loc: LanguageChangeCode), style: UIAlertActionStyle.default) {
                //                    UIAlertAction in
                //                    self.dismiss(animated: true, completion: nil)
                //                }
                //
                //                alertController.addAction(okAction)
                //
                //                self.present(alertController, animated: true, completion: nil)
            }else{
                //self.alert(message: message, title: "ERROR".localizableString(loc: LanguageChangeCode))
                self.alert(message: message, title: "ERROR".localizableString(loc: LanguageChangeCode))
                _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle: message , style: AlertStyle.error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                
            }
        })
    }
    
    var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    private func topView() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Forgot Password"
       titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        titleview.backBtn.addTarget(self, action: #selector(homeBtnTapped(sender:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        //                dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.password{
            if (textField.text?.isEmpty)!{
                print("password empty ")
                textField.becomeFirstResponder()
            }else {
                if isValidPassword(password: password.text!) {
                    print("Valid Password")
                }
                else {
                    unValidTextFieldData(textField: password)
                    self.view.makeToast("strInvalidPassValidation".localizableString(loc: LanguageChangeCode),position: .center)
                }
            }
        }else if textField == self.reEnterPassword{
            if (textField.text?.isEmpty)!{
                print("password empty ")
                textField.becomeFirstResponder()
            }else {
                if isValidPassword(password: reEnterPassword.text!) {
                    print("Valid Password")
                }
                else {
                    unValidTextFieldData(textField: reEnterPassword)
                    self.view.makeToast("strInvalidPassValidation".localizableString(loc: LanguageChangeCode),position: .center)
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == password {
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if textField == reEnterPassword {
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
