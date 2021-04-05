//
//  ItemListingStepTwoVC.swift
//  Sell4Bids
//
//  Created by admin on 12/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import TGPControls


class ItemListingStepTwoVC: UIViewController {
    
    //MARK:- Properties and Outlets
    @IBOutlet weak var selectCategoryTextField: UITextField!
    @IBOutlet weak var selectTextFieldBorderLine: UILabel!
    @IBOutlet weak var conditionBar: TGPDiscreteSlider!
    @IBOutlet weak var conditionLbl: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionBorderLine: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK:- Variable
    lazy var sliderData = ["Any","For Parts","Used",
    "Reconditioned","Open box / Like new","New"]
    lazy var itemsCategory: [String] = ["Select Category","Accessories","Antiques", "Arts and Crafts", "Baby and Kids", "Bags",
                                    "Boats and Marines","Books","Business Equipment","Campers and RVs","Cars and Accessories",
                                    "CDs and DVDs","Clothing","Collectible Toys","Computers and Accessories","Costumes",
                                    "Coupons", "Electronics","Exercise","Fashion", "Free and Donations",
                                    "Furniture","Gadgets","Games","Halloween","Hobbies",
                                    "Home Decor","Home and Garden","Household Appliances", "Jewelry", "Kids Toys",
                                    "Makeup and Beauty","Motorcycles and Accessories","Musical Equipment","Outdoor and Camping","Pet & Animals","Pet Accessories",
                                    "Tickets","Tools","Phone and Tablets","Shoes","Sports Equipment",
                                    "Video Games","Wallets","Watches","Wedding","Others"]
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    lazy var conditionString = ""
    var imageArray = [UIImage]()
    lazy var paramDic = [String:Any]()
    
    //MARK;- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        topMenu()
        // Do any additional setup after loading the view.
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    //MARK:- Actions
    @objc func handleValueChange(_ sender: TGPDiscreteSlider){
        //set slider value in constant variable named value.
        let value = Int(sender.value)
        self.conditionLbl.text = sliderData[value]
        self.conditionString = sliderData[value]
    }
    
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
        else if conditionString == "" || conditionString == "Select Category"{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please specify the Condition of the item")
        }
        else if descriptionTextView.text!.isEmpty || descriptionTextView.text == "Description of your item"{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please enter description of the item")
        }
        else if descriptionTextView.text!.count < 20 {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please enter description of the item at least 20 words")
        }else {
            let SB = UIStoryboard(name: "Listing", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "ItemListingLocationVC") as! ItemListingLocationVC
            vc.controllerName = "item"
            //Session Update
            vc.imageArray = self.imageArray
            // Updating Values
            vc.paramDic.updateValue(selectCategoryTextField.text!, forKey: "itemCategory")
            vc.paramDic.updateValue(conditionString, forKey: "condition")
            vc.paramDic.updateValue(descriptionTextView.text!, forKey: "description")
            vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
            UserDefaults.standard.set(vc.paramDic, forKey: "itemDescriptionDic")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Private Functions
    private func setupViews() {
        print("Parameters",self.paramDic)
        print("ImagesArray",self.imageArray)
        
        let SessionDic: [String: Any]? = UserDefaults.standard.dictionary(forKey: "itemDescriptionDic")
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
            
            let conditionValue = "\(SessionDic?["condition"] ?? "")"
            conditionLbl.text = "\(SessionDic?["condition"] ?? "")"
            conditionString = conditionValue
           
            switch conditionValue {
              
            case "Any":
                conditionBar.value = 0
                conditionLbl.text = "Any"
            case "For Parts":
                conditionBar.value = 1
                conditionLbl.text = "For Parts"
            case "Used":
                conditionBar.value = 2
                conditionLbl.text = "Used"
            case "Reconditioned":
                conditionBar.value = 3
                conditionLbl.text = "Reconditioned"
            case "Open box / Like new":
                conditionBar.value = 4
                conditionLbl.text = "Open box / Like new"
            case "New":
                conditionBar.value = 5
                conditionLbl.text = "New"
            default:
                print("no match")
            }
            
        }
        
        conditionBar.applyBlackCorner()
        conditionBar.addTarget(self, action: #selector(handleValueChange(_:)), for: .valueChanged)
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
extension ItemListingStepTwoVC: UIPickerViewDataSource, UIPickerViewDelegate{
    
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
extension ItemListingStepTwoVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectTextFieldBorderLine.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectTextFieldBorderLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
extension ItemListingStepTwoVC: UITextViewDelegate {
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

