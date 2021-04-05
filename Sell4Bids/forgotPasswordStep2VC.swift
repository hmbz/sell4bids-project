//
//  forgotPasswordStep2VC.swift
//  Sell4Bids
//
//  Created by admin on 2/28/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import SVPinView

class forgotPasswordStep2VC: UIViewController  {

    
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var InfoLbl: UILabel!
    
    var MainApis = MainSell4BidsApi()
    var emailAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       topView()
       configurePinView()
        
        var nextStyle = pinView.style.rawValue + 1
        if nextStyle == 3 {nextStyle = 0}
        pinView.layer.cornerRadius = 10
        
        let newstr = emailAddress
        var token = newstr.components(separatedBy: "@")
        let newQuery = String(repeating: "*", count: token[0].characters.count)  //check array length before using index
        let email1 = newQuery + "@" +  token[1]
      
        InfoLbl.text = "\("We have send a verification code to \(email1). To verify that this is your email address, enter it below.")"
       self.hideKeyboardWhenTappedAround()
        
    }
    
    func sendcode(){
        
         let Verifycode =  pinView.getPin()
        MainApis.SendPasscode_Api(email: emailAddress, passcode: Verifycode, completionHandler: { (status, swifymessage, error) in
            
            let message = swifymessage!["message"].stringValue
            
            if status {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "forgotPasswordStep3VC") as! forgotPasswordStep3VC
                vc.emailAddress = self.emailAddress
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                if message.contains("Email doesn't exist"){
                    
                }else{
                    self.alert(message: message, title: "ERROR".localizableString(loc: LanguageChangeCode))
                }
            }
        })
    }
    
    func configurePinView() {
        
        pinView.pinLength = 6
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 8
        pinView.textColor = UIColor.black
        pinView.borderLineColor = UIColor.white
        pinView.activeBorderLineColor = UIColor.white
        pinView.borderLineThickness = 1
        pinView.shouldSecureText = false
        pinView.allowsWhitespaces = false
        pinView.style = .none
        pinView.fieldBackgroundColor = UIColor.white.withAlphaComponent(0.3)
        pinView.fieldBackgroundColor = UIColor.white.withAlphaComponent(0.5)
        pinView.fieldCornerRadius = 10
        pinView.activeFieldCornerRadius = 10
        pinView.placeholder = "------"
        pinView.becomeFirstResponderAtIndex = 0
        pinView.font = UIFont.systemFont(ofSize: 30)
        pinView.keyboardType = .numberPad
        
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
    }

    func didFinishEnteringPin(pin:String) {
        let pin1 = pinView.getPin()
        print("sended \(pin1)")
        sendcode()
        pinView.endEditing(true)
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
    
   

}
