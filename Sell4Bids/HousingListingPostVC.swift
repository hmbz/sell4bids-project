//
//  HousingListingPostVC.swift
//  Sell4Bids
//
//  Created by admin on 12/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class HousingListingPostVC: UIViewController {
    //MARK:- Properties and outlets
    
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var currencySymbolBtn: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var listIndefinitSwitch: UISwitch!
    @IBOutlet weak var listingDurationView: UIStackView!
    @IBOutlet weak var listingDurationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var listingDurationBorderHeight: NSLayoutConstraint!
    @IBOutlet weak var listingDurationBorderLine: UILabel!
    @IBOutlet weak var acceptOffersSwitch: UISwitch!
    @IBOutlet weak var automaticRelistSwitch: UISwitch!
    @IBOutlet weak var automaticRelistingView: UIStackView!
    @IBOutlet weak var automaticRelistViewHeight: NSLayoutConstraint!
    @IBOutlet weak var automaticRelistBorderLine: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var fidgetSpinner: UIImageView!
  @IBOutlet weak var rentmonthly: UILabel!
    
    //MARK:- Variables
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    lazy var country = ""
    var imageArray = [UIImage]()
    lazy var paramDic = [String:Any]()
    let durationArray = ["Select","3","5","7","10", "15","21","30"]
    lazy var listingDurationValue = ""
    let DoneAlertView = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
       let DoneView = Bundle.main.loadNibNamed("Item_Listing_Done_Custom_View", owner: self, options: nil)?.first as! ItemListingDoneCustom
     let defaultCurrencyPicker = UIPickerView()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
        setupViews()
      if paramDic["housingCategory"] as? String == "Apartment for sale"{
        rentmonthly.text = "Price"
      }
    }
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    //MARK:- Actions
    @objc func currencyBtbTapped(sender: UIButton){
        createCurrencyPicker()
    }
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
    }
    
    @objc func listIndefinitelyTapped(sender: UISwitch){
        if sender.isOn == true {
            listingDurationView.isHidden = true
            listingDurationBorderLine.isHidden = true
            listingDurationViewHeight.constant = 0
            listingDurationBorderHeight.constant = 0
            automaticRelistViewHeight.constant = 0
            automaticRelistBorderLine.isHidden = true
            automaticRelistingView.isHidden = true
            durationTextField.text = ""
            listingDurationValue = ""
            automaticRelistSwitch.isOn = false
        }else {
            listingDurationView.isHidden = false
            listingDurationBorderLine.isHidden = false
            listingDurationViewHeight.constant = 35
            listingDurationBorderHeight.constant = 1
            automaticRelistViewHeight.constant = 35
            automaticRelistBorderLine.isHidden = false
            automaticRelistingView.isHidden = false
            
        }
    }
    
    @objc func postBtnTapped(sender: UIButton){
      if priceTextField.text!.isEmpty || priceTextField.text! == "0"{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please Enter Price")
            priceTextField.becomeFirstResponder()
        }
        else if listIndefinitSwitch.isOn == false && listingDurationValue == "" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select listing duration")
            durationTextField.becomeFirstResponder()
        }else if listIndefinitSwitch.isOn == false && listingDurationValue == "Select" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select listing duration")
            durationTextField.becomeFirstResponder()
        }else {
            print("Post")
            
            self.paramDic.updateValue(true, forKey: "visibility")
            self.paramDic.updateValue("IOS", forKey: "platform")
            self.paramDic.updateValue("buy-it-now", forKey: "itemAuctionType")
            self.paramDic.updateValue(priceTextField.text!, forKey: "startPrice")
            self.paramDic.updateValue(acceptOffersSwitch.isOn, forKey: "acceptOffers")
            self.paramDic.updateValue("1", forKey: "quantity")
            if listIndefinitSwitch.isOn == true{
                self.paramDic.updateValue("-1", forKey: "endTime")
            }else {
                self.paramDic.updateValue(listingDurationValue, forKey: "endTime")
            }
            self.paramDic.updateValue(automaticRelistSwitch.isOn, forKey: "autoRelist")
            print(self.paramDic)
            self.postItem(body: self.paramDic)
        }
    }
    
    @objc func doneBtnTapped(sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @objc func duedone(){
        self.view.endEditing(true)
    }
    
    //MARK:- Private Function
    private func createCurrencyPicker() {
        defaultCurrencyPicker.delegate = self
        defaultCurrencyPicker.dataSource = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(duedone))
        doneButton.tintColor =  _ColorLiteralType(red: 0.8024634268, green: 0.07063802083, blue: 0.1448886847, alpha: 1)
        toolbar.setItems([spaceButton1, spaceButton2,doneButton], animated: false)
        let tempInput = UITextField( frame:CGRect.zero )
        tempInput.inputView = self.defaultCurrencyPicker
        tempInput.inputAccessoryView = toolbar   // Your picker
        self.view.addSubview( tempInput )
        tempInput.becomeFirstResponder()
    }
    private func setupViews() {
        let currencySymbol = CurrencyManager.instance.getCurrencySymbol(Country: self.country.uppercased())
        let currencyString = CurrencyManager.instance.getCurrencyTwoDigitCode(Country: self.country.uppercased())
        self.paramDic.updateValue(currencySymbol, forKey: "currency_symbol")
        self.paramDic.updateValue(currencyString, forKey: "currency_string")
        priceTextField.delegate = self
        priceTextField.tag = 1
        postBtn.shadowView()
        if self.country != "" {
            let currencySymbol = CurrencyManager.instance.getCurrencySymbolForListing(Country: self.country.uppercased())
            currencySymbolBtn.setTitle(currencySymbol, for: .normal)
            priceTextField.placeholder = currencySymbol
        }
        listIndefinitSwitch.addTarget(self, action: #selector(listIndefinitelyTapped(sender:)), for: .valueChanged)
        selectCreatePicker(textField: durationTextField, tag: 1)
        createToolBar(textField: durationTextField)
        postBtn.addTarget(self, action: #selector(postBtnTapped(sender:)), for: .touchUpInside)
         currencySymbolBtn.addTarget(self, action: #selector(currencyBtbTapped(sender:)), for: .touchUpInside)
    }
    
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Pricing"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    
    private func postItem(body:[String:Any]){
       let symbol = paramDic["currency_symbol"] as? String
       if symbol == "NOT SELECTED"{
    return  showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select a country!")
      }
        self.shadowView.isHidden = false
        self.fidgetSpinner.isHidden = false
        self.fidgetSpinner.loadGif(name: "red")
        Networking.instance.listingApiCall(url: addItemUrl, param: body, ImagesArray: self.imageArray) { (response, Error, StatusCode) in
            self.shadowView.isHidden = true
            self.fidgetSpinner.isHidden = true
            self.fidgetSpinner.stopAnimatingGif()
            if StatusCode == 413 {
              showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strFileSizeTooLarge".localizableString(loc: LanguageChangeCode))
            }
            else if StatusCode == 502 {
              showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strServerDown".localizableString(loc: LanguageChangeCode))
            }else {
                guard let jsonDic = response.dictionary else {return}
                let jsonStatus = jsonDic["status"]?.bool ?? false
                if jsonStatus == true {
                    UserDefaults.standard.set(nil, forKey: "housingTitleDic")
                    UserDefaults.standard.set(nil, forKey: "housingImagesArray")
//                  serDefaults.standard.dictionary(forKey: "housingDescriptionDic")
                  UserDefaults.standard.removeObject(forKey: "housingDescriptionDic")
                    self.DoneView.DoneBtn.makeCornersRound()
                    self.DoneView.DoneBtn.addTarget(self, action: #selector(self.doneBtnTapped(sender:)), for: .touchUpInside)
                    self.DoneAlertView.view.frame = self.DoneView.frame
                    self.DoneAlertView.view.addSubview(self.DoneView)
                    self.present(self.DoneAlertView, animated: true, completion: nil)
                }else {
                    showSwiftMessageWithParams(theme: .info, title: "Listing", body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
                }
            }
        }
    }
}
//TODO:- Picker View Functions
extension HousingListingPostVC: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == defaultCurrencyPicker {
            return CurrencyManager.currencyArray.count
        }else {
            return durationArray.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == defaultCurrencyPicker {
            var symbol = String()
            let Array = CurrencyManager.currencyArray
            if Array[row].symbol != nil {
                symbol = "\(Array[row].country ?? "")" + " " + "(\(Array[row].symbol ?? ""))"
            }else if Array[row].twoDigitCode != nil {
                symbol = "\(Array[row].country ?? "")" + " " + "(\(Array[row].threeDigitCode ?? ""))"
            }else{
                symbol = "\(Array[row].country ?? "")" + " " + "(\(Array[row].twoDigitCode ?? ""))"
            }
            print("Current Symbol = \(symbol)")
            return symbol
        }else{
            return durationArray[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == defaultCurrencyPicker {
            var symbol = String()
            let TwoDigitCode = CurrencyManager.currencyArray[row].twoDigitCode
            let currencySymbol = CurrencyManager.currencyArray[row].symbol
            let Array = CurrencyManager.currencyArray
            if Array[row].symbol != nil {
                symbol = Array[row].symbol ?? ""
            }else if Array[row].twoDigitCode != nil {
                symbol = Array[row].twoDigitCode ?? ""
            }else{
                symbol = Array[row].threeDigitCode ?? ""
            }
            print("Current Symbol = \(symbol)")
            self.currencySymbolBtn.setTitle(symbol, for: .normal)
            self.priceTextField.placeholder = symbol
            self.paramDic.updateValue(currencySymbol ?? "", forKey: "currency_symbol")
            self.paramDic.updateValue(TwoDigitCode ?? "", forKey: "currency_string")
        }
        else {
            durationTextField.text! = durationArray[row] + " Days"
            listingDurationValue = durationArray[row]
        }
        
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
            if (pickerView == defaultCurrencyPicker) {
                var symbol = String()
                let Array = CurrencyManager.currencyArray
                if Array[row].symbol != nil {
                    symbol = "\(Array[row].country ?? "")" + " " + "(\(Array[row].symbol ?? ""))"
                }else if Array[row].twoDigitCode != nil {
                    symbol = "\(Array[row].country ?? "")" + " " + "(\(Array[row].threeDigitCode ?? ""))"
                }else{
                    symbol = "\(Array[row].country ?? "")" + " " + "(\(Array[row].twoDigitCode ?? ""))"
                }
                label.text = symbol
            }else {
               label.text = durationArray[row] + " Days"
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
extension HousingListingPostVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1{
            
            if (textField.text?.count)! > 5 {
                let maxLength = 6
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            return replacementText.isValidDecimal(maximumFractionDigits: 2)
        }
        return true
        
    }
}
