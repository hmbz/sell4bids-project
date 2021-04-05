//
//  ServiceListingStep2VC.swift
//  Sell4Bids
//
//  Created by Admin on 20/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ServiceListingStep2VC: UIViewController, UITextViewDelegate {

    // Outlets of Step2:View StoryBoard:
    @IBOutlet weak var ServiceTypeView: UIView!
    @IBOutlet weak var ServiceDescriptionView: UIView!
    
    // Connects atteched of step2View:
    //TakeServiceTypeCustomVariable
    @IBOutlet weak var ServiceTypeLbl: UILabel!
    @IBOutlet weak var ServiceTypeTextField: UITextField!
    
    
    
     //TakeDescriptionCustomVariable
    @IBOutlet weak var ServiceDescriptionLbl: UILabel!
    @IBOutlet weak var ServiceDescriptionTextView: UITextView!
//    @IBOutlet var descritionTextHeight: NSLayoutConstraint!
    @IBOutlet var descriptionBorderLbl: UILabel!
    
    
    
    // ServiceType name list:
    var ServiceType = ["Select Service Type","Automotive & Transportation","Cleaning","Dog walking","Computer & Internet","Counseling","Creative","Education & Training","Electronics Repair & Installation","Events & Catering","Financial","Garden & Outdoors","Health & Beauty","Home Improvement & Repair","Legal","Maids & Domestic Help","Marketing & Advertising","Moving & Storage","Online Skills","Pet Services","Publishing & Printing","Repair & Restoration","Transportation","Travel & Tourism","Writing & Translation","Other Services"]
    
    
//    func adjustTextViewHeight() {
//        let fixedWidth = ServiceDescriptionTextView.frame.size.width
//        let newSize = ServiceDescriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: self.descritionTextHeight.constant ))
//        self.descritionTextHeight.constant = newSize.height
//        self.view.layoutIfNeeded()
//    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        adjustTextViewHeight()
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ServiceDescriptionTextView.delegate = self
        ServiceDescriptionTextView.text = "Service Description"
        ServiceDescriptionTextView.textColor = UIColor.lightGray

        
//        ServiceDescriptionTextView.makeCornersRound()
//        ServiceDescriptionTextView.layer.borderWidth = 1.0
//        ServiceTypeTextField.makeCornersRound()
//        ServiceTypeTextField.layer.borderWidth = 1.0
        ServiceTypeTextField.textAlignment = .center
        ServiceTypeView.addShadow()
        
        
        
        ServiceDescriptionView.addShadow()
        
        
        createPicker(textField: ServiceTypeTextField)
        createToolBar(textField: ServiceTypeTextField)
        
        ServiceTypeTextField.delegate = self
        ServiceTypeTextField.endEditing(true)
        ServiceDescriptionTextView.endEditing(true)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if ServiceDescriptionTextView.textColor == UIColor.lightGray {
            ServiceDescriptionTextView.text = nil
            ServiceDescriptionTextView.textColor = UIColor.black
        }
        descriptionBorderLbl.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1)
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if ServiceDescriptionTextView.text.isEmpty {
            ServiceDescriptionTextView.text = "Service Description"
            ServiceDescriptionTextView.textColor = UIColor.lightGray
        }
        descriptionBorderLbl.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
    }
    
    
    
    
}



//MARK:- UITextFieldDelegate
extension ServiceListingStep2VC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == ServiceTypeTextField {
            if textField.isFirstResponder{
                ServiceTypeTextField.becomeFirstResponder()
            }
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == ServiceTypeTextField{
            return true
        }
        return true
    }
    
    ///for disabling the employment type text field entering text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == ServiceTypeTextField {
            return false
        }
        return true
    }
    func createToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone)
        )
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //toolBar.barTintColor = UIColor.red
        toolBar.tintColor = UIColor.red
        
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func handleDone()
    {
        ServiceTypeTextField.endEditing(true)
        
    }
    
}



//MARK:-  UIPickerViewDelegate, UIPickerViewDataSource
extension ServiceListingStep2VC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ServiceType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ServiceType[row]
        //return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ServiceTypeTextField.text = ServiceType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label : UILabel
        
        if let view = view as? UILabel{
            label = view
        }
        else{
            label = UILabel()
        }
        label.textColor = .black
        
        label.textAlignment = .center
        
//        label.font = AdaptiveLayout.normalBold
        
        label.text = ServiceType[row]
        
        return label
    }
    
    func createPicker(textField: UITextField){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        textField.inputView = pickerView
        
    }
  
}
