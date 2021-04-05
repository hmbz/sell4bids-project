//
//  JobListingStepTwoVC.swift
//  Sell4Bids
//
//  Created by admin on 12/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class JobListingStepTwoVC: UIViewController {
    
    //MARK:- Outlets and Properties
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryBorderLine: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionBorderLine: UILabel!
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var experienceBorderLine: UILabel!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyNameBorderLine: UILabel!
    @IBOutlet weak var companyDescriptionTextView: UITextView!
    @IBOutlet weak var companyDescriptionBorderLine: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK:- Variable and Constent
    lazy var paramDic = [String:Any]()
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    var itemsCategory: [String] = ["Select Category","Accounting", "Administrative & Office Admin","Advertising & Marketing","Business","Agriculture, Forestry & Fishing","Architecture","Arts & Design","Biotechnology & Pharmaceuticals", "Social Services & Nonprofit","Construction, Mining & Trades","Customer Service & Call Center","Education, Training & Library", "Employment Placement Agencies", "Engineering", "Financial & Banking", "General Labor", "Government", "Hotels & Hospitality", "Human Resources (HR)", "Information Technology (IT)", "Installation, Maintenance & Repair", "Insurance", "Internet & Ecommerce", "Legal & Paralegal", "Manufacturing", "Medical & Healthcare", "Personal Care, Spas & Fitness", "Professional Services", "Real Estate", "Restaurants & Beverage", "Retail & Wholesale", "Sales", "Science", "Sports & Recreation", "Telecommunications", "Television, Film & Entertainment", "Transportation & Warehousing", "Other"]
    var jobCategory: [String] = ["Select Category","Less then 1 Year","1 Year","2 Years","3 Years","4 Years","5 Years","greater than 5 Years"," 7 Years","10 Years","greater than 10 Years"]
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
        setupViews()
        
    }
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    //MARK:- Actions
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
    }
    
    @objc func nextBtnTapped(sender: UIButton) {
        if categoryTextField.text!.isEmpty ||  categoryTextField.text! == "Select Category"{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select Category")
            categoryTextField.becomeFirstResponder()
        }
        else if descriptionTextView.text!.isEmpty || descriptionTextView.text == "Enter job description here" || descriptionTextView.text!.count < 20{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please enter description of the job at-leat 20 words")
            descriptionTextView.becomeFirstResponder()
        }
        else if experienceTextField.text!.isEmpty || experienceTextField.text! == "Select Category"{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select job category")
            experienceTextField.becomeFirstResponder()
        }
        else if companyNameTextField.text!.isEmpty{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please enter Comapny Name")
            companyNameTextField.becomeFirstResponder()
        }else {
            let SB = UIStoryboard(name: "Listing", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "ItemListingLocationVC") as! ItemListingLocationVC
            vc.controllerName = "job"
            vc.paramDic.updateValue(categoryTextField.text!, forKey: "jobCategory")
            vc.paramDic.updateValue(descriptionTextView.text!, forKey: "description")
            vc.paramDic.updateValue(experienceTextField.text!, forKey: "jobExperience")
            vc.paramDic.updateValue(companyNameTextField.text!, forKey: "companyName")
            vc.paramDic.updateValue(companyDescriptionTextView.text!, forKey: "companyDescription")
            
            vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
            vc.paramDic.updateValue(self.paramDic["Medical"] ?? "", forKey: "Medical")
            vc.paramDic.updateValue(self.paramDic["PTO"] ?? "", forKey: "PTO")
            vc.paramDic.updateValue(self.paramDic["FZOK"] ?? "", forKey: "FZOK")
            vc.paramDic.updateValue(self.paramDic["employmentType"] ?? "", forKey: "employmentType")
            
            UserDefaults.standard.set(vc.paramDic, forKey: "jobDescriptionDic")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //MARK:- Functions
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Company Information"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    
    private func setupViews() {
        selectCreatePicker(textField: categoryTextField, tag: 1)
        selectCreatePicker(textField: experienceTextField, tag: 2)
        createToolBar(textField: categoryTextField)
        createToolBar(textField: experienceTextField)
        nextBtn.shadowView()
        nextBtn.addTarget(self, action: #selector(nextBtnTapped(sender:)), for: .touchUpInside)
        
        let sessionDic = UserDefaults.standard.dictionary(forKey: "jobDescriptionDic")
        if sessionDic != nil {
            categoryTextField.text = "\(sessionDic?["jobCategory"] ?? "")"
            descriptionTextView.text = "\(sessionDic?["description"] ?? "")"
            descriptionTextView.textColor = .black
            experienceTextField.text = "\(sessionDic?["jobExperience"] ?? "")"
            companyNameTextField.text = "\(sessionDic?["companyName"] ?? "")"
            companyDescriptionTextView.text = "\(sessionDic?["companyDescription"] ?? "")"
            if companyDescriptionTextView.text != "(Optional)"{
                companyDescriptionTextView.textColor = .black
            }
        }
        
    }
}
//MARK:- Text Field Delegate
extension JobListingStepTwoVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == categoryTextField{
            categoryBorderLine.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        else if textField == experienceTextField {
            experienceBorderLine.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        else {
            companyNameBorderLine.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == categoryTextField{
            categoryBorderLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else if textField == experienceTextField {
            experienceBorderLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else {
            companyNameBorderLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}
//MARK:- Text View Delegate
extension JobListingStepTwoVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            if textView.text!.isEmpty || textView.text == "Enter job description here"{
              textView.text = ""
            }
            textView.textColor = .black
            descriptionBorderLine.backgroundColor = .red
        }else {
            if textView.text!.isEmpty || textView.text == "(Optional)"{
                textView.text = ""
            }
            textView.textColor = .black
            companyDescriptionBorderLine.backgroundColor = .red
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            if textView.text!.isEmpty{
                textView.text = "Enter job description here"
                textView.textColor = .lightGray
            }
            descriptionBorderLine.backgroundColor = .black
        }else {
            if textView.text!.isEmpty{
                textView.text = "(Optional)"
                textView.textColor = .lightGray
            }
            companyDescriptionBorderLine.backgroundColor = .black
        }
    }
}
//TODO:- Picker View Functions
extension JobListingStepTwoVC: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return itemsCategory.count
        }else {
            return jobCategory.count
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
          return itemsCategory[row]
        }else {
          return jobCategory[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
           categoryTextField.text! = itemsCategory[row]
        }else {
            experienceTextField.text! = jobCategory[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label : UILabel
        if let view = view as? UILabel{
            label = view
        }else{
            label = UILabel()
            label.textColor = UIColor.black
            label.textAlignment = .center
            if pickerView.tag == 1 {
                label.text = itemsCategory[row]
            }else {
                label.text = jobCategory[row]
            }
            
        }
        return label
    }
    
    func selectCreatePicker(textField: UITextField , tag : Int){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.tag = tag
        textField.inputView = pickerView
    }
    
    func createToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.tintColor = UIColor.red
        textField.inputAccessoryView = toolBar
    }
    
    @objc func handleDone(){
        self.view.endEditing(true)
    }
}

