//
//  ItemListingStepThreeContainerVC.swift
//  Sell4Bids
//
//  Created by admin on 07/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


var IslistingItem = Bool()

class ItemListingStepThreeContainerVC: UIViewController {
    
    // Price and Quantity
    @IBOutlet weak var pricetext: UITextField!
    @IBOutlet weak var Qantitytxt: UITextField!
    
    var isItemListing = Bool()
    
    @IBOutlet weak var PriceView: UIStackView!
    @IBOutlet weak var QuantityView: UIStackView!
    // UILabel of ListingDurations.
    @IBOutlet weak var listIndefinitelyLbl: UILabel!
    @IBOutlet weak var listDurationLbl: UILabel!
    @IBOutlet weak var acceptOfferLbl: UILabel!
    @IBOutlet weak var automaticRelisting: UILabel!
    
    // StackView Connetions
    @IBOutlet weak var listIndefinitelyStackView2: UIStackView!
    @IBOutlet weak var listDurationsStackView: UIStackView!
    @IBOutlet weak var acceptsOfferStackView2: UIStackView!
    @IBOutlet weak var autoRelisting: UIStackView!
    
    // UI Switches & PickerView.
    @IBOutlet weak var listIndefinitelySwitch: UISwitch!
    @IBOutlet weak var acceptOfferSwitch: UISwitch!
    @IBOutlet weak var listDurationTextField: UITextField!
    @IBOutlet weak var autoRelistingSwitch: UISwitch!
    @IBOutlet weak var LIstDurationHeight: NSLayoutConstraint!
    
    @IBOutlet weak var listIndefinitelyImage: UIImageView!
    @IBOutlet weak var listingDurationImage: UIImageView!
    @IBOutlet weak var acceptOffersImage: UIImageView!
    @IBOutlet weak var autoRelistingImage: UIImageView!
    
    @IBOutlet weak var QuantityStackView: NSLayoutConstraint!
    @IBOutlet weak var PriceTextFieldConstant: NSLayoutConstraint!
    @IBOutlet weak var DollarLabel: UILabel!
    @IBOutlet weak var DollarView: UIView!
    @IBOutlet weak var currencyBtn: UIButton!
    @IBOutlet weak var currencyPickerBtn: UIButton!
    
    func Hide_Quantity() {
        self.QuantityView.isHidden = true
        
    }
    
    func Show_Quantity() {
        self.QuantityView.isHidden = false
        
    }
    
    // variables
    var list1 = [String]()
    var selectedDuration: String?
    var currency_String = String()
    var currency_Symbol = String()
    var selected_date = Int()
    var listIdentifily = Bool()
    var accecptOffer = Bool()
    var auto_Relisting = Bool()
    var list_Iden = Bool()
    let defaultCurrencyPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrencyManager.setupCurrencyArray()
        
        listIndefinitelySwitch.endEditing(true)
        acceptOfferSwitch.endEditing(true)
        listDurationTextField.endEditing(true)
        autoRelistingSwitch.endEditing(true)
        pricetext.endEditing(true)
        Qantitytxt.endEditing(true)
        Qantitytxt.textAlignment = .center
        pricetext.textAlignment = .center
        listIndefinitelyStackView2.endEditing(true)
        listDurationsStackView.endEditing(true)
        acceptsOfferStackView2.endEditing(true)
        autoRelisting.endEditing(true)
        listIndefinitelyLbl.endEditing(true)
        listDurationLbl.endEditing(true)
        acceptOfferLbl.endEditing(true)
        automaticRelisting.endEditing(true)
//        Qantitytxt.layer.borderColor = UIColor.black.cgColor
        
//        Qantitytxt.layer.borderWidth = 2
//        Qantitytxt.layer.cornerRadius = 8
        
        
        
        print("isitemlisting == \(isItemListing)")
        //        if  IslistingItem {
        //            Show_Quantity()
        //        }else {
        //            Hide_Quantity()
        //        }
        
        
        pricetext.keyboardType = UIKeyboardType.decimalPad
        Qantitytxt.keyboardType = UIKeyboardType.decimalPad
        
        list1 = ["3 Days","5 Days","7 Days","10 Days", "15 Days","21 Days","30 Days"]
        TextFieldStyle()
        listDurationTextField.delegate = self
        pricetext.delegate = self
        Qantitytxt.delegate = self
        
        selectCreatePicker(textField: listDurationTextField, tag: 2)
        createToolBar(textField: listDurationTextField)
        
        listIndefinitelySwitch.addTarget(self, action: #selector(listindefinitelySwitchAction), for: .touchUpInside)
        acceptOfferSwitch.addTarget(self, action: #selector(AcceptOfferSwitchAction), for: .touchUpInside)
        autoRelistingSwitch.addTarget(self, action: #selector(AutomaticRelistingSwitchAction), for: .touchUpInside)
        
        
        if listIndefinitelySwitch.isSelected == true{
            
            listDurationsStackView.isHidden = false
            
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        listIndefinitelyImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showListIndefinitely))
        tapGestureRecognizer.numberOfTapsRequired = 1
        listIndefinitelyImage.addGestureRecognizer(tapGestureRecognizer)
        
        listingDurationImage.isUserInteractionEnabled = true
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(showListingDuration))
        tapGestureRecognizer.numberOfTapsRequired = 1
        listingDurationImage.addGestureRecognizer(tapGestureRecognizer1)
        
        acceptOffersImage.isUserInteractionEnabled = true
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(showAcceptOffers))
        tapGestureRecognizer.numberOfTapsRequired = 1
        acceptOffersImage.addGestureRecognizer(tapGestureRecognizer2)
        
        autoRelistingImage.isUserInteractionEnabled = true
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(showAutoRelistInfoPopup))
        tapGestureRecognizer.numberOfTapsRequired = 1
        autoRelistingImage.addGestureRecognizer(tapGestureRecognizer3)
        currencyBtn.addTarget(self, action: #selector(currencyBtbTapped(sender:)), for: .touchUpInside)
        currencyPickerBtn.addTarget(self, action: #selector(currencyBtbTapped(sender:)), for: .touchUpInside)
    }
    
    var currencyArray = ["PKR","USD","EUR","INR","BST"]
    
    @objc func currencyBtbTapped(sender: UIButton){
        createCurrencyPicker()
    }
    
    func createCurrencyPicker() {
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
    
    @objc func duedone() {
        self.view.endEditing(true)
    }
    
    
    
    @objc func showListIndefinitely() {
        let title = "List Indefinitely"
        let messageText = "Item will be listed for an infinite time. You can end the listing anytime you want from the listing details."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    @objc func showListingDuration() {
        let title = "Listing Duration"
        let messageText = "Number of days until you will receive offers on listed item. You can relist item when this time is ended."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    @objc func showAcceptOffers() {
        let title = "Accept Offers"
        let messageText = "Buyer will be able to send you offers on different prices instead of fixed price."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    @objc func showAutoRelistInfoPopup() {
        let title = "Automatic Relisting"
        let messageText = "Your item will be automatically relisted after 1 hour when sale is ended."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    
    @objc func listindefinitelySwitchAction(){
        
        listIndefinitelySwitch.isSelected = !listIndefinitelySwitch.isSelected
        
        if listIndefinitelySwitch.isSelected == true{
            listIndefinitelySwitch.layer.borderColor = UIColor.clear.cgColor
            LIstDurationHeight.constant = 0
            selected_date = -1
            
            print("ListIndefinitely Selected")
            list_Iden = true
        }else if listIndefinitelySwitch.isSelected == false{
            listIndefinitelySwitch.layer.borderColor = UIColor.clear.cgColor
            print("ListIndefinitely Un-Selected")
            list_Iden = false
            LIstDurationHeight.constant = 60
        }
        else {
            DispatchQueue.main.async {
                self.listIndefinitelySwitch.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
    }
    
    @objc func AcceptOfferSwitchAction(){
        
        acceptOfferSwitch.isSelected = !acceptOfferSwitch.isSelected
        
        if acceptOfferSwitch.isSelected == true{
            acceptOfferSwitch.layer.borderColor = UIColor.clear.cgColor
            print("AcceptOffer Selected")
            accecptOffer = true
        }else if acceptOfferSwitch.isSelected == false{
            acceptOfferSwitch.layer.borderColor = UIColor.clear.cgColor
            print("AcceptOffer Selected")
            accecptOffer = false
        }
        else {
            DispatchQueue.main.async {
                self.acceptOfferSwitch.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
    }
    @objc func AutomaticRelistingSwitchAction(){
        
        autoRelistingSwitch.isSelected = !autoRelistingSwitch.isSelected
        
        if autoRelistingSwitch.isSelected == true{
            autoRelistingSwitch.layer.borderColor = UIColor.clear.cgColor
            print("autoRelisting Selected")
            auto_Relisting = true
        }else if autoRelistingSwitch.isSelected == false{
            autoRelistingSwitch.layer.borderColor = UIColor.clear.cgColor
            print("autoRelisting Selected")
            auto_Relisting = false
        }
        else {
            DispatchQueue.main.async {
                self.autoRelistingSwitch.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
    }
    func TextFieldStyle(){
        
        
//        DollarView.layer.borderColor = UIColor.black.cgColor
//        DollarView.layer.borderWidth = 2.0
//        DollarView.makeCornersRound()
        
    }
    
    
    
    
    
}



// Extension : ItemListingStepThreeContainerVC for PickerView And for TextField
extension  ItemListingStepThreeContainerVC : UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 2) {
            return list1.count
        }else if pickerView == defaultCurrencyPicker {
            return CurrencyManager.currencyArray.count
        }else {
          return list1.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 2){
            return list1[row]
        }else if pickerView == defaultCurrencyPicker {
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
          return list1[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if (pickerView.tag == 2)
        {
            let days = list1[row].split(separator: " ")
            self.selected_date = Int(days[0])!
            listDurationTextField.text = list1[row]
        }else if pickerView == defaultCurrencyPicker {
            
            var symbol = String()
            let Array = CurrencyManager.currencyArray
            if Array[row].symbol != nil {
                symbol = Array[row].symbol ?? ""
            }else if Array[row].twoDigitCode != nil {
                symbol = Array[row].twoDigitCode ?? ""
            }else{
                symbol = Array[row].threeDigitCode ?? ""
            }
            print("Current Symbol = \(symbol)")
            self.currencyBtn.setTitle(symbol, for: .normal)
//            self.DollarLabel.text = symbol
            if pricetext.text!.isEmpty == true {
              self.pricetext.placeholder = symbol
            }
            self.currency_Symbol = symbol
//
//            if self.DollarLabel.text == "PKR"{
//                self.currency_Symbol = "Rs"
//            }
//            if self.DollarLabel.text == "USD"{
//                self.currency_Symbol = "$"
//            }
//            if self.DollarLabel.text == "EUR"{
//                self.currency_Symbol = "€"
//            }
//            if self.DollarLabel.text == "INR"{
//                self.currency_Symbol = "₹"
//            }
//            if self.DollarLabel.text == "BST"{
//                self.currency_Symbol = "£"
//            }
            
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
        if (pickerView.tag == 2) {
            label.text = list1[row]
        }else if pickerView == defaultCurrencyPicker {
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
            
            label.text =  symbol
        }
        return label
    }
    
    
    
    func selectCreatePicker(textField: UITextField, tag: Int){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.tag = tag
        textField.inputView = pickerView
        
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
        listDurationTextField.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == pricetext {
            textField.resignFirstResponder()
        }
        else if textField == Qantitytxt {
            textField.resignFirstResponder()
            Qantitytxt.becomeFirstResponder()
        }
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == pricetext || textField == Qantitytxt{
        textField.placeholder = ""
      }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == pricetext{
            textField.placeholder = ""
        }else if textField == Qantitytxt  {
            if textField.text!.isEmpty{
                textField.placeholder = "Quantity"
            }else {
                
            }
        }else {
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField.tag == 1 || textField.tag == 2{
            
            if textField.text!.count < 0  {
                self.DollarLabel.textColor = UIColor.gray
            }else {
                self.DollarLabel.textColor = UIColor.black
            }
            
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
