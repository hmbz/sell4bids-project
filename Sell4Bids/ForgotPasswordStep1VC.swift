//
//  ForgotPasswordStep1VC.swift
//  Sell4Bids
//
//  Created by admin on 2/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ForgotPasswordStep1VC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    var MainApis = MainSell4BidsApi()
    @IBOutlet weak var fidgetImageView: UIImageView!
    
    @IBOutlet weak var Disableview: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    
    lazy var responseStatus =  false
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        emailTxt.becomeFirstResponder()
        Disableview.isHidden = true
        sendBtn.shadowView()
        self.hideKeyboardWhenTappedAround()
        topView() 
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if !(emailTxt.text?.isEmpty)!{
            sendRequest()
            emailTxt.endEditing(true)
        }else{
            self.view.makeToast("Please enter your email address", position: .top)
        }
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
    
    func sendRequest(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.responseStatus == false {
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.Disableview)
            }
        }
        MainApis.ForgotSendEmail_Api(email: emailTxt.text!, completionHandler: { (status, swifymessage, error) in
            
            
            let message = swifymessage!["message"].stringValue
            self.responseStatus = true
            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.Disableview)
            
            if status {
                self.Disableview.isHidden = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "forgotPasswordStep2VC") as! forgotPasswordStep2VC
                vc.emailAddress = self.emailTxt.text!
                self.navigationController?.pushViewController(vc, animated: true)
                _ = SweetAlert().showAlert("Forget Password", subTitle: " Please check your email for verification to reset your password " , style: AlertStyle.success,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
            }else{
                self.Disableview.isHidden = true
//                if message.contains("Email doesn't exist"){
//                    _ = SweetAlert().showAlert("Forget Password", subTitle: "\(self.emailTxt.text!), This email address doesn't exist" , style: AlertStyle.error,buttonTitle:
//                        "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
//                    //self.alert(message: "\(self.emailTxt.text!), This email address doesn't exist", title: "Error")
//                }
//                else{
                  //  self.alert(message: message, title: "Error")
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle: message , style: AlertStyle.error,buttonTitle:
                        "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
//                }
            }
        })
    }
    
}
