//
//  ItemListingPostVC.swift
//  Sell4Bids
//
//  Created by admin on 12/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ItemListingPostVC: UIViewController {
    
    //MARK:- Outlets and properties
    // Buy Now
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var buyNowView: UIView!
    @IBOutlet weak var BuyNowCurrencySymbolBtn: UIButton!
    @IBOutlet weak var buyNowCurrencySymbolDropDownBtn: UIButton!
    @IBOutlet weak var buyNowPriceTextField: UITextField!
    @IBOutlet weak var buyNowQuantityTextField: UITextField!
    @IBOutlet weak var listIndefinitelySwitch: UISwitch!
    @IBOutlet weak var buyNowStartingDurationTextField: UITextField!
    @IBOutlet weak var buyNowAcceptOfferSwitch: UISwitch!
    @IBOutlet weak var buyNowAutomaticRelistingSwitch: UISwitch!
    // Auction
    @IBOutlet weak var auctionView: UIView!
    @IBOutlet weak var auctionCurrencySymbolBtn: UIButton!
    @IBOutlet weak var auctionStartingPriceTextField: UITextField!
    @IBOutlet weak var auctionReserveSwitch: UISwitch!
    @IBOutlet weak var auctionListingDurationTextField: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var listDurationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var listDurationViewBottomLineLbl: UILabel!
    @IBOutlet weak var automaticRelistingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var automaticRelistingViewBorderLineLbl: UILabel!
    @IBOutlet weak var automaticRelistingView: UIView!
    @IBOutlet weak var reserveAuctionPriceTextField: UITextField!
    @IBOutlet weak var reserveAuctionView: UIStackView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var fidgetSpinner: UIImageView!
    
    //MARK:- Variable
    var imageArray = [UIImage]()
    lazy var paramDic = [String:Any]()
    lazy var buyNowStatus = false
    lazy var auctionStatus = false
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    let DoneAlertView = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    let DoneView = Bundle.main.loadNibNamed("Item_Listing_Done_Custom_View", owner: self, options: nil)?.first as! ItemListingDoneCustom
    lazy var list = ["Select","3","5","7","15","21","30"]
    lazy var listingDuration = ""
    lazy var auctionDuration = ""
    lazy var country = ""
    let defaultCurrencyPicker = UIPickerView()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//      CurrencyManager.currencyArray.insert("Select Currency", at: 0)
//      CurrencyManager.currencyArray.insert(currencyModel.init(country: "Select Countery", threeDigitCode: "NOT SELECTED", twoDigitCode: "NOT SELECTED", symbol: "NOT SELECTED"), at: 0)
      
        setupViews()
        topMenu()
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    //MARK:- Actions
    @objc func currencyBtbTapped(sender: UIButton){
        createCurrencyPicker()
    }
    
    @objc func segmentControllTapped(segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex {
        case 0:
            self.buyNowStatus = true
            self.auctionStatus = false
            self.buyNowView.isHidden = false
            self.auctionView.isHidden = true
            
            reserveAuctionView.isHidden = true
            reserveAuctionPriceTextField.text = ""
            auctionStartingPriceTextField.text = ""
            auctionListingDurationTextField.text = ""
            auctionReserveSwitch.isOn = false
            
        case 1:
            self.buyNowStatus = false
            self.auctionStatus = true
            self.buyNowView.isHidden = true
            self.auctionView.isHidden = false
            
            // Removing Buy Now Attributes
            buyNowPriceTextField.text = ""
            buyNowQuantityTextField.text = ""
            listIndefinitelySwitch.isOn = false
            listDurationViewHeight.constant = 35
            listDurationViewBottomLineLbl.isHidden = false
            automaticRelistingViewHeight.constant = 35
            automaticRelistingViewBorderLineLbl.isHidden = false
            buyNowAutomaticRelistingSwitch.isOn = false
            automaticRelistingView.isHidden = false
            buyNowStartingDurationTextField.text = ""
            buyNowAcceptOfferSwitch.isOn = false
            
        default:
            break
        }
    }
    
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
    }
    
    @objc func doneBtnTapped(sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @objc func listIndefinitelyBtnTapped(sender: UISwitch) {
        if sender.isOn {
            listDurationViewHeight.constant = 0
            listDurationViewBottomLineLbl.isHidden = true
            automaticRelistingViewHeight.constant = 0
            automaticRelistingViewBorderLineLbl.isHidden = true
            automaticRelistingView.isHidden = true
            listingDuration = ""
            buyNowStartingDurationTextField.placeholder = "3 Days"
        }else {
            listDurationViewHeight.constant = 35
            listDurationViewBottomLineLbl.isHidden = false
            automaticRelistingViewHeight.constant = 35
            automaticRelistingViewBorderLineLbl.isHidden = false
            buyNowAutomaticRelistingSwitch.isOn = false
            automaticRelistingView.isHidden = false
            buyNowStartingDurationTextField.text = ""
        }
    }
    @objc func reservedAuctionSwitchTapped(sender: UISwitch) {
        if sender.isOn {
            reserveAuctionView.isHidden = false
        }else {
            reserveAuctionView.isHidden = true
            reserveAuctionPriceTextField.text = ""
        }
    }
    
    @objc func postBtnTapped(sender: UIButton){
        self.paramDic.updateValue(true, forKey: "visibility")
        self.paramDic.updateValue("IOS", forKey: "platform")
        if segmentControl.selectedSegmentIndex == 0 {
            print("Buy Now")
            buyNowApiCall()
        }else {
            print("Auction")
            AuctionApiCall()
        }
    }
    @objc func duedone() {
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
    private func buyNowApiCall() {
      
      let symbol = paramDic["currency_symbol"] as? String
        if buyNowPriceTextField.text!.isEmpty ||  buyNowPriceTextField.text! == "0" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please enter item price")
            buyNowPriceTextField.becomeFirstResponder()
        }else if symbol == "NOT SELECTED"{
        showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select a country!")
        }
        else if buyNowQuantityTextField.text!.isEmpty || buyNowQuantityTextField.text! == "0"{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please enter item quantity")
            buyNowQuantityTextField.becomeFirstResponder()
        }else if listIndefinitelySwitch.isOn == false && listingDuration == "Select" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select listing Duration")
            buyNowStartingDurationTextField.becomeFirstResponder()
        }else if listIndefinitelySwitch.isOn == false && listingDuration == "" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select listing Duration")
            buyNowStartingDurationTextField.becomeFirstResponder()
        }else {
            self.paramDic.updateValue(buyNowPriceTextField.text!, forKey: "startPrice")
            self.paramDic.updateValue(buyNowQuantityTextField.text!, forKey: "quantity")
            if listIndefinitelySwitch.isOn == true {
              self.paramDic.updateValue("-1", forKey: "endTime")
            }else{
              self.paramDic.updateValue(listingDuration, forKey: "endTime")
            }
            self.paramDic.updateValue("buy-it-now", forKey: "itemAuctionType")
            self.paramDic.updateValue(buyNowAutomaticRelistingSwitch.isOn, forKey: "autoRelist")
            self.paramDic.updateValue(buyNowAcceptOfferSwitch.isOn, forKey: "acceptOffers")
            print("Buy Now Post Params = ",self.paramDic)
            self.postItem(body: self.paramDic)
        }
    }
    
    private func AuctionApiCall() {
       let symbol = paramDic["currency_symbol"] as? String
       var number1 = "0"
      if reserveAuctionPriceTextField.text! != ""{
        number1 = reserveAuctionPriceTextField.text!
      }else{
        
      }
      let number2 = auctionStartingPriceTextField.text!
    
              guard let value_one = Int(number1), let value_two = Int(number2) else {
                  print("Some value is nil")
                  return
              }
      if auctionStartingPriceTextField.text!.isEmpty || auctionStartingPriceTextField.text  == "0"{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please enter item price")
            auctionStartingPriceTextField.becomeFirstResponder()
        }else if auctionReserveSwitch.isOn == true && reserveAuctionPriceTextField.text!.isEmpty{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please enter Reserve Auction Price")
            reserveAuctionPriceTextField.becomeFirstResponder()
        }else if symbol == "NOT SELECTED"{
        showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select a country!")
        }
        else if auctionReserveSwitch.isOn == true && value_one != 0 &&  value_one < value_two    {
         
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Reserve auction price should be greater than starting price")
            reserveAuctionPriceTextField.becomeFirstResponder()
          
        }
      else if auctionDuration == "" ||  auctionDuration == "Select"  {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select Auction Duration")
            auctionListingDurationTextField.becomeFirstResponder()
        }else {
            self.paramDic.updateValue(auctionStartingPriceTextField.text!, forKey: "startPrice")
            self.paramDic.updateValue("1", forKey: "quantity")
            self.paramDic.updateValue(auctionDuration, forKey: "endTime")
            if auctionReserveSwitch.isOn == true {
               self.paramDic.updateValue("reserve", forKey: "itemAuctionType")
               self.paramDic.updateValue(reserveAuctionPriceTextField.text!, forKey: "reservePrice")
            }else {
               self.paramDic.updateValue("non-reserve", forKey: "itemAuctionType")
               self.paramDic.updateValue(auctionStartingPriceTextField.text!, forKey: "base_price")
            }
            print("Auction Post Params = ",self.paramDic)
            self.postItem(body: self.paramDic)
        }
    }
    
    
    private func setupViews() {
        let currencySymbol = CurrencyManager.instance.getCurrencySymbol(Country: self.country.uppercased())
        let currencyString = CurrencyManager.instance.getCurrencyTwoDigitCode(Country: self.country.uppercased())
        self.paramDic.updateValue(currencySymbol, forKey: "currency_symbol")
        self.paramDic.updateValue(currencyString, forKey: "currency_string")
        print("Final Parameters",self.paramDic)
        print("Final ImagesArray",self.imageArray)
        self.buyNowStatus = true
        self.auctionStatus = false
        
        buyNowPriceTextField.delegate = self
        buyNowPriceTextField.tag = 1
        buyNowQuantityTextField.delegate = self
        buyNowQuantityTextField.tag = 2
        auctionStartingPriceTextField.delegate = self
        auctionStartingPriceTextField.tag = 1
        reserveAuctionPriceTextField.delegate = self
        reserveAuctionPriceTextField.tag = 1
        
        
        segmentControl.addTarget(self, action: #selector(segmentControllTapped(segControl:)), for: .valueChanged)
        
        let font = UIFont.boldSystemFont(ofSize: 20)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        listIndefinitelySwitch.addTarget(self, action: #selector(listIndefinitelyBtnTapped(sender:)), for: .allTouchEvents)
        auctionReserveSwitch.addTarget(self, action: #selector(reservedAuctionSwitchTapped(sender:)), for: .allTouchEvents)
        
        selectCreatePicker(textField: buyNowStartingDurationTextField, tag: 1)
        createToolBar(textField: buyNowStartingDurationTextField)
        selectCreatePicker(textField: auctionListingDurationTextField, tag: 2)
        createToolBar(textField: auctionListingDurationTextField)
        
        if self.country != "" {
            let currencySymbol = CurrencyManager.instance.getCurrencySymbolForListing(Country: self.country.uppercased())
            auctionCurrencySymbolBtn.setTitle(currencySymbol, for: .normal)
            BuyNowCurrencySymbolBtn.setTitle(currencySymbol, for: .normal)
            buyNowPriceTextField.placeholder = currencySymbol
            auctionStartingPriceTextField.placeholder = currencySymbol
            reserveAuctionPriceTextField.placeholder = currencySymbol
        }
        
        postBtn.addTarget(self, action: #selector(postBtnTapped(sender:)), for: .touchUpInside)
        BuyNowCurrencySymbolBtn.addTarget(self, action: #selector(currencyBtbTapped(sender:)), for: .touchUpInside)
        auctionCurrencySymbolBtn.addTarget(self, action: #selector(currencyBtbTapped(sender:)), for: .touchUpInside)
        
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
                showSwiftMessageWithParams(theme: .info, title: "Listing", body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
            }else {
                guard let jsonDic = response.dictionary else {return}
                let jsonStatus = jsonDic["status"]?.bool ?? false
                if jsonStatus == true {
                    UserDefaults.standard.set(nil, forKey: "itemTitleDic")
                    UserDefaults.standard.set(nil, forKey: "itemDescriptionDic")
                    UserDefaults.standard.set(nil, forKey: "itemImagesArray")
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
extension ItemListingPostVC: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == defaultCurrencyPicker {
            return CurrencyManager.currencyArray.count
        }else {
           return list.count
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
        }else {
            return list[row] + " Days"
          
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
            self.BuyNowCurrencySymbolBtn.setTitle(symbol, for: .normal)
            self.auctionCurrencySymbolBtn.setTitle(symbol, for: .normal)
            self.buyNowPriceTextField.placeholder = symbol
            self.paramDic.updateValue(currencySymbol ?? "", forKey: "currency_symbol")
            self.paramDic.updateValue(TwoDigitCode ?? "", forKey: "currency_string")
        }
        else if pickerView.tag == 1 {
            buyNowStartingDurationTextField.text! = list[row] + " Days"
            listingDuration = list[row]
        }else {
            auctionListingDurationTextField.text! = list[row] + " Days"
            auctionDuration = list[row]
        }
    }
  override func viewWillAppear(_ animated: Bool) {
    
    auctionListingDurationTextField.text! = list[0] + " Days"
    buyNowStartingDurationTextField.text! = list[0] + " Days"
  }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label : UILabel
        if let view = view as? UILabel{
            label = view
        }else{
            label = UILabel()
            label.textColor = UIColor.black
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
               label.text = list[row] + " Days"
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

extension ItemListingPostVC: UITextFieldDelegate{
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
        }else if textField.tag == 2 {
            if (textField.text?.count)! > 2 {
                let maxLength = 3
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
