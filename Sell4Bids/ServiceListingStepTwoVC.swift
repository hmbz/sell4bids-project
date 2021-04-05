//
//  ServiceListingStepTwoVC.swift
//  Sell4Bids
//
//  Created by admin on 12/7/19.
//  Copyright © 2019 admin. All rights reserved.
//
import UIKit

class ServiceListingStepTwoVC: UIViewController {
    
    //MARK:- Properties and Outlets
    @IBOutlet weak var selectCategoryTextField: UITextField!
    @IBOutlet weak var selectTextFieldBorderLine: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionBorderLine: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK:- Variable
    lazy var itemsCategory: [String] = ["Select Category","Automotive & Transportation","Cleaning","Dog walking","Computer & Internet","Counseling","Creative","Education & Training","Electronics Repair & Installation","Events & Catering","Financial","Garden & Outdoors","Health & Beauty","Home Improvement & Repair","Legal","Maids & Domestic Help","Marketing & Advertising","Moving & Storage","Online Skills","Pet Services","Publishing & Printing","Repair & Restoration","Transportation","Travel & Tourism","Writing & Translation","Other Services"]
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    var imageArray = [UIImage]()
    lazy var paramDic = [String:Any]()
    
    //MARK;- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        topMenu()
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    //MARK:- Actions
    
    @objc func backbtnTapped(sender: UIButton){
           print("Back button tapped")
           self.navigationController?.popViewController(animated: true)
       }
       // going back directly towards the home
       @objc func homeBtnTapped(sender: UIButton) {
           print("Home Button Tapped")
       }
    
    @objc func nextBtnTapped(sender: UIButton){
        if selectCategoryTextField.text!.isEmpty || selectCategoryTextField.text! == "Select Category" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select category")
        }
        else if descriptionTextView.text!.isEmpty || descriptionTextView.text == "Description of your item"{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please enter description of the item")
        }
        else if descriptionTextView.text!.count < 20 {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please enter description of the item at least 20 words")
        }else {
            let SB = UIStoryboard(name: "Listing", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "ItemListingLocationVC") as! ItemListingLocationVC
            vc.controllerName = "service"
            //Session Update
            vc.imageArray = self.imageArray
            // Updating Values
            vc.paramDic.updateValue("Services", forKey: "itemCategory")
            vc.paramDic.updateValue(selectCategoryTextField.text!, forKey: "serviceType")
            vc.paramDic.updateValue(descriptionTextView.text!, forKey: "description")
            vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
            vc.paramDic.updateValue(self.paramDic["userRole"] ?? "", forKey: "userRole")
            UserDefaults.standard.set(vc.paramDic, forKey: "serviceDescriptionDic")
            print(vc.paramDic)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Private Functions
    private func setupViews() {
        print("Parameters",self.paramDic)
        print("ImagesArray",self.imageArray)
        
        let SessionDic: [String: Any]? = UserDefaults.standard.dictionary(forKey: "serviceDescriptionDic")
        if SessionDic?["itemCategory"] != nil {
            selectCategoryTextField.text = "\(SessionDic?["itemCategory"] ?? "")"
            descriptionTextView.text = "\(SessionDic?["description"] ?? "")"
            
            let Description = "\(SessionDic?["description"] ?? "")"
            if Description != "" {
                descriptionTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }else {
                descriptionTextView.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                descriptionTextView.text = "Description of your item"
            }
            
        }
        selectCreatePicker(textField: selectCategoryTextField, tag: 1)
        createToolBar(textField: selectCategoryTextField)
        descriptionTextView.delegate = self
        nextBtn.addTarget(self, action: #selector(nextBtnTapped(sender:)), for: .touchUpInside)
    }
    
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Description Item"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
}
//TODO:- Picker View Functions
extension ServiceListingStepTwoVC: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsCategory.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemsCategory[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCategoryTextField.text! = itemsCategory[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label : UILabel
        if let view = view as? UILabel{
            label = view
        }else{
            label = UILabel()
            label.textColor = UIColor.black
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            label.text = itemsCategory[row]
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
        selectCategoryTextField.endEditing(true)
    }
}
//TODO:- Text field Delegate
extension ServiceListingStepTwoVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectTextFieldBorderLine.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectTextFieldBorderLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
extension ServiceListingStepTwoVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text!.isEmpty || textView.text == "Description of your item"{
            textView.text = ""
            textView.textColor = UIColor.black
            descriptionBorderLine.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text!.isEmpty{
            textView.text = "Description of your item"
            textView.textColor = UIColor.lightGray
        }
        descriptionBorderLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
}
