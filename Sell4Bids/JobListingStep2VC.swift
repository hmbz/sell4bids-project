//
//  JobListingStep2Vc.swift
//  Sell4Bids
//
//  Created by Admin on 07/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class JobListingStep2VC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var jobSelectCategoryView: UIView!
    @IBOutlet weak var jobDescriptionView: UIView!
    @IBOutlet weak var ScrollDownConstraint: NSLayoutConstraint!
    @IBOutlet weak var jobExperienceView: UIView!
    @IBOutlet weak var CompanyNameAndDescriptionView: UIView!
    
        //TakeSelectCategoryCustom
    @IBOutlet weak var jobCategoryLbl: UILabel!
    @IBOutlet weak var jobSelectCategoryTextField: UITextField!
        //TakeSelectJobExperienceCustom
    
    @IBOutlet weak var jobExperienceLbl: UILabel!
    @IBOutlet weak var jobExperienceTextField: UITextField!
        //TakeDescriptionCustom
    @IBOutlet weak var jobDescriptionLbl: UILabel!
    @IBOutlet weak var jobDesTextView: UITextView!
        //TakeCompanyNameAndDescriptionCustom
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyDescriptionTextView: UITextView!
    
        
    var SelectCategory: [String] = ["Select Job Category","Accounting", "Administrative & Office Admin","Advertising & Marketing","Business","Agriculture, Forestry & Fishing","Architecture","Arts & Design","Biotechnology & Pharmaceuticals", "Social Services & Nonprofit","Construction, Mining & Trades","Customer Service & Call Center","Education, Training & Library", "Employment Placement Agencies", "Engineering", "Financial & Banking", "General Labor", "Government", "Hotels & Hospitality", "Human Resources (HR)", "Information Technology (IT)", "Installation, Maintenance & Repair", "Insurance", "Internet & Ecommerce", "Legal & Paralegal", "Manufacturing", "Medical & Healthcare", "Personal Care, Spas & Fitness", "Professional Services", "Real Estate", "Restaurants & Beverage", "Retail & Wholesale", "Sales", "Science", "Sports & Recreation", "Telecommunications", "Television, Film & Entertainment", "Transportation & Warehousing", "Other"]
    var SelectJobExperience: [String] = ["Less then 1 Year","1 Year","2 Years","3 Years","4 Years","5 Years","greater than 5 Years"," 7 Years","10 Years","greater than 10 Years"]
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            addInviteBarButtonToTop()
            addLeftHomeBarButtonToTop()
            addLogoWithLeftBarButton()
            self.title = "Job Listing"
            
            companyDescriptionTextView.delegate = self
            companyDescriptionTextView.text = "Detail of Company (optional)"
            companyDescriptionTextView.textColor = UIColor.lightGray
            
            jobDesTextView.delegate = self
            jobDesTextView.text = "Job Description"
            jobDesTextView.textColor = UIColor.lightGray
            
//            jobSelectCategoryTextField.makeCornersRound()
//            jobSelectCategoryTextField.layer.borderWidth = 1.0
//
//            jobExperienceTextField.makeCornersRound()
//            jobExperienceTextField.layer.borderWidth = 1.0
            jobSelectCategoryTextField.textAlignment = .center
            jobExperienceTextField.textAlignment = .center
            
//            jobDesTextView.makeCornersRound()
//            jobDesTextView.layer.borderWidth = 1.0
            
//            companyNameTextField.layer.borderWidth = 1.0
//            companyNameTextField.makeCornersRound()
            
//            companyDescriptionTextView.layer.borderWidth = 1.0
//            companyDescriptionTextView.makeCornersRound()
            
            
            jobSelectCategoryView.addShadow()
            jobExperienceView.addShadow()
            jobDescriptionView.addShadow()
            CompanyNameAndDescriptionView.addShadow()
            
            

            selectCreatePicker(textField: jobSelectCategoryTextField, tag: 1)
            createToolBar(textField: jobSelectCategoryTextField)
            
            selectCreatePicker(textField: jobExperienceTextField, tag: 2)
            createToolBar(textField: jobExperienceTextField)
            
            jobSelectCategoryTextField.delegate = self
            jobExperienceTextField.delegate = self

        
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tap)
            
            jobSelectCategoryTextField.endEditing(true)
            jobExperienceTextField.endEditing(true)
            jobDesTextView.endEditing(true)
            companyDescriptionTextView.endEditing(true)
            companyNameTextField.endEditing(true)
            
            
            
            jobSelectCategoryView.endEditing(true)
            jobDescriptionView.endEditing(true)
            jobExperienceView.endEditing(true)
            CompanyNameAndDescriptionView.endEditing(true)
            
                
}
    func textViewDidBeginEditing(_ textView: UITextView) {
        if companyDescriptionTextView.textColor == UIColor.lightGray {
            companyDescriptionTextView.text = nil
            companyDescriptionTextView.textColor = UIColor.black
        }
        if jobDesTextView.textColor == UIColor.lightGray {
            jobDesTextView.text = nil
            jobDesTextView.textColor = UIColor.black
        }
    }
    // @ Osama Mansoori 3-june-2019
    func textViewDidEndEditing(_ textView: UITextView) {
        if companyDescriptionTextView.text.isEmpty {
            companyDescriptionTextView.text = "Detail of Company (optional)"
            companyDescriptionTextView.textColor = UIColor.lightGray
        }
        if jobDesTextView.text.isEmpty {
            jobDesTextView.text = "Job Description"
            jobDesTextView.textColor = UIColor.lightGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{


            if jobDesTextView.isFirstResponder == true{
                if touch.view != self.jobDesTextView{
                    jobDesTextView.resignFirstResponder()
                }
            }

        }
    }
    
}


//MARK:- UITextFieldDelegate
extension JobListingStep2VC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
    if textField == jobSelectCategoryTextField{
    
    if textField.isFirstResponder{
    textField.resignFirstResponder()
    return true
    }
        }
          return true
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == jobSelectCategoryTextField{
            return true
        }
        return true
    }
    
    ///for disabling the employment type text field entering text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == jobSelectCategoryTextField {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == companyNameTextField{
            textField.placeholder = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == companyNameTextField{
            if textField.text!.isEmpty{
              textField.placeholder = "Enter your company name"
            }
            
        }
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
        jobSelectCategoryTextField.endEditing(true)
        jobExperienceTextField.endEditing(true)
        jobDesTextView.endEditing(true)
        companyDescriptionTextView.endEditing(true)
        companyNameTextField.endEditing(true)
        
        jobSelectCategoryView.endEditing(true)
        jobDescriptionView.endEditing(true)
        jobExperienceView.endEditing(true)
        CompanyNameAndDescriptionView.endEditing(true)
        
    }
}





//MARK:-  UIPickerViewDelegate, UIPickerViewDataSource
extension JobListingStep2VC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
        return SelectCategory.count
        }else{
            return SelectJobExperience.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            return SelectCategory[row]
        }else{
            return SelectJobExperience[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       if (pickerView.tag == 1)
       {
        jobSelectCategoryTextField.text = SelectCategory[row]
       }else if (pickerView.tag == 2){
        jobExperienceTextField.text = SelectJobExperience[row]
        }
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
        if (pickerView.tag == 1) {
        label.text = SelectCategory[row]
        }else{
            label.text = SelectJobExperience[row]
        }
        return label
    }
    
    
    
    func selectCreatePicker(textField: UITextField, tag: Int){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.tag = tag
        textField.inputView = pickerView
        
    }
    
}

