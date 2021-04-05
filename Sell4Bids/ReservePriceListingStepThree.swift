//
//  ReservePriceListingStepThree.swift
//  Sell4Bids
//
//  Created by Admin on 07/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ReservePriceListingStepThree: UIViewController {
    
    // stackview Connections:
    @IBOutlet weak var DollarViewReserve: UIView!
    @IBOutlet weak var DollarView: UIView!
    @IBOutlet weak var startingpriceStackView: UIStackView!
    @IBOutlet weak var addReservePriceStackView: UIStackView!
    @IBOutlet weak var reservePriceStackView: UIStackView!
    @IBOutlet weak var startingPriceTextField: UITextField!
    @IBOutlet weak var addReservePriceSwitch: UISwitch!
    @IBOutlet weak var reservePriceTextField: UITextField!
    @IBOutlet weak var listDurationTextField: UITextField!
    @IBOutlet weak var autoRelistingSwitch: UISwitch!
    @IBOutlet weak var reservePriceLbl: UILabel!
    
    @IBOutlet weak var listingDurationImage: UIImageView!
    @IBOutlet weak var autoRelistingImage: UIImageView!
    @IBOutlet weak var currenctBtn: UIButton!
    @IBOutlet weak var currencyDownBtn: UIButton!
    @IBOutlet weak var DollarLabelStartingPrice: UILabel!
    @IBOutlet weak var DollarLabelReservePrice: UILabel!
    
    var selected_date = Int()
    var list1 = [String]()
    var selectedDuration: String?
    var selecteditem : ProductModel?
    var currencyChar : String = "$"
    var currency_String = String()
    var currency_Symbol = String()
    var check = true
    var Auction_auto_relistingbool = Bool()
    let defaultCurrencyPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DollarView.makeCornersRound()
        startingPriceTextField.keyboardType = UIKeyboardType.decimalPad
        reservePriceTextField.keyboardType = UIKeyboardType.decimalPad
        
        startingpriceStackView.endEditing(true)
        addReservePriceStackView.endEditing(true)
        reservePriceStackView.endEditing(true)
        startingPriceTextField.endEditing(true)
        addReservePriceSwitch.endEditing(true)
        reservePriceTextField.endEditing(true)
        listDurationTextField.endEditing(true)
        autoRelistingSwitch.endEditing(true)
        reservePriceLbl.endEditing(true)
        
        list1 = ["3 Days","5 Days","7 Days","10 Days", "15 Days","21 Days","30 Days"]
        
        TextFieldStyle()
        listDurationTextField.delegate = self
        
        startingPriceTextField.delegate = self
        reservePriceTextField.delegate = self
        
        reservePriceLbl.isHidden = true
        reservePriceTextField.isHidden = true
        DollarViewReserve.isHidden = true
        
        print("currency_Symbol == \(currency_Symbol)")
        print("currency_String == \(currency_String)")
        DollarLabelStartingPrice.text = (currency_String + " " + currency_Symbol)
        DollarLabelReservePrice.text = (currency_String + " " + currency_Symbol)
        currenctBtn.setTitle("\(currency_String + " " + currency_Symbol)", for: .normal)
        
        autoRelistingSwitch.addTarget(self, action: #selector(AutomaticRelistingSwitchAction), for: .touchUpInside)
        addReservePriceSwitch.addTarget(self, action: #selector(AddReservePriceAction), for: .touchUpInside)
        addReservePriceSwitch.addTarget(self, action: #selector(ShowReservePriceingAction), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        selectCreatePicker(textField: listDurationTextField, tag: 3)
        createToolBar(textField: listDurationTextField)
        
        
        listingDurationImage.isUserInteractionEnabled = true
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(showListingDuration))
        tapGestureRecognizer1.numberOfTapsRequired = 1
        listingDurationImage.addGestureRecognizer(tapGestureRecognizer1)
        
        autoRelistingImage.isUserInteractionEnabled = true
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(showAutoRelistInfoPopup))
        tapGestureRecognizer3.numberOfTapsRequired = 1
        autoRelistingImage.addGestureRecognizer(tapGestureRecognizer3)
        
        currenctBtn.addTarget(self, action: #selector(currencyBtbTapped(sender:)), for: .touchUpInside)
        currencyDownBtn.addTarget(self, action: #selector(currencyBtbTapped(sender:)), for: .touchUpInside)
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
    
    
    @objc func showListingDuration() {
        let title = "Listing Duration"
        let messageText = "Number of days until you will receive offers on listed item. You can relist item when this time is ended."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    @objc func showAutoRelistInfoPopup() {
        let title = "Automatic Relisting"
        let messageText = "Your item will be automatically relisted after 1 hour when sale is ended."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    @objc func AutomaticRelistingSwitchAction(){
        
        autoRelistingSwitch.isSelected = !autoRelistingSwitch.isSelected
        
        if autoRelistingSwitch.isSelected == true{
            autoRelistingSwitch.layer.borderColor = UIColor.clear.cgColor
            print("autoRelisting Selected")
            Auction_auto_relistingbool = true
        }else if autoRelistingSwitch.isSelected == false{
            autoRelistingSwitch.layer.borderColor = UIColor.clear.cgColor
            print("autoRelisting Un-Selected")
            Auction_auto_relistingbool = false
        }
        else {
            DispatchQueue.main.async {
                self.autoRelistingSwitch.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
    }
    
    
    @IBAction func SwitchAddReservePrice(_ sender: Any) {
        
        if addReservePriceSwitch.isOn == true{
            addReservePriceSwitch.layer.borderColor = UIColor.clear.cgColor
            print("addReservePrice Selected")
            
        }else {
            DispatchQueue.main.async {
                self.addReservePriceSwitch.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
        
    }
    
    
    @objc func AddReservePriceAction(){
        
        addReservePriceSwitch.isSelected = !addReservePriceSwitch.isSelected
        
        if addReservePriceSwitch.isSelected == true{
            addReservePriceSwitch.layer.borderColor = UIColor.clear.cgColor
            print("addReservePrice Selected")
            
        }else {
            DispatchQueue.main.async {
                self.addReservePriceSwitch.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
    }
    
    @objc func ShowReservePriceingAction(){
        if addReservePriceSwitch.isOn == false{
            reservePriceTextField.isHidden = true
            reservePriceLbl.isHidden = true
            DollarViewReserve.isHidden = true
        }
        else if addReservePriceSwitch.isOn == true{
            reservePriceTextField.isHidden = false
            reservePriceLbl.isHidden = false
            DollarViewReserve.isHidden = false
        }
    }
    
    func TextFieldStyle(){
        self.DollarView.layer.borderColor = UIColor.black.cgColor
        self.DollarView.layer.borderWidth = 2.0
        DollarViewReserve.layer.borderColor = UIColor.black.cgColor
        DollarViewReserve.layer.borderWidth = 2.0
        DollarViewReserve.makeCornersRound()
    }
    
}


extension  ReservePriceListingStepThree : UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 3) {
            return list1.count
        }else if pickerView == defaultCurrencyPicker {
            return CurrencyManager.currencyArray.count
        }else{
          return list1.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 3){
            return list1[row]
        }else if pickerView == defaultCurrencyPicker {
            return CurrencyManager.currencyArray[row].country
        }else{
            return list1[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if (pickerView.tag == 3)
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
            self.currenctBtn.setTitle(symbol, for: .normal)
            self.DollarLabelStartingPrice.text = symbol
            self.DollarLabelReservePrice.text = symbol
            self.currency_Symbol = symbol
//            self.currenctBtn.setTitle(currencyArray[row], for: .normal)
//            self.DollarLabelStartingPrice.text = currencyArray[row]
//            self.DollarLabelReservePrice.text = currencyArray[row]
            
//            if self.DollarLabelStartingPrice.text == "PKR"{
//                self.currency_Symbol = "Rs"
//            }
//            if self.DollarLabelStartingPrice.text == "USD"{
//                self.currency_Symbol = "$"
//            }
//            if self.DollarLabelStartingPrice.text == "EUR"{
//                self.currency_Symbol = "€"
//            }
//            if self.DollarLabelStartingPrice.text == "INR"{
//                self.currency_Symbol = "₹"
//            }
//            if self.DollarLabelStartingPrice.text == "BST"{
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
        
        //        label.font = AdaptiveLayout.normalBold
        if (pickerView.tag == 3) {
            label.text = list1[row]
        }else if pickerView == defaultCurrencyPicker {
            label.text =  CurrencyManager.currencyArray[row].country
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
        
        toolBar.tintColor = UIColor.red
        
        textField.inputAccessoryView = toolBar
        
    }
    @objc func handleDone()
    {
        listDurationTextField.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField.tag == 1 || textField.tag == 2{
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
