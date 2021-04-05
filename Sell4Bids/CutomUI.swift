//
//  CutomUI.swift
//  Sell4Bids
//
//  Created by admin on 12/19/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
extension UIViewController{
    //MARK:- Validation functions forr text fields
    func isValidUserName(username:String) -> Bool {
        let userNameRegEx = "[a-zA-Z\\s]+"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", userNameRegEx)
        return emailTest.evaluate(with: username)
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[a-zA-Z0-9._-]+@[a-z0-9]+\\.+[a-z]+"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    func isValidPassword(password:String) -> Bool {
        let passRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()~])(?=.*\\d)[a-zA-Z\\d\\W]{8,}$"
        let passTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passTest.evaluate(with: password)
    }
    
    // validation Functions
    func validTextFieldData(textField:UITextField){
        DispatchQueue.main.async {
            textField.resignFirstResponder()
            textField.next?.becomeFirstResponder()
        }
    }
    func unValidTextFieldData(textField:UITextField){
        DispatchQueue.main.async {
            textField.becomeFirstResponder()
            print(textField.text!)
        }
    }
}
