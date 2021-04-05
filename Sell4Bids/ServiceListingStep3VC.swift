////
////  ServiceListingStep3VC.swift
////  Sell4Bids
////
////  Created by Admin on 28/02/2019.
////  Copyright © 2019 admin. All rights reserved.
////


import UIKit

class ServiceListingStep3VC: UIViewController {
    
    
    @IBOutlet weak var ServiceMainView: UIView!
    @IBOutlet weak var ServiceOfferMainView: UIView!
    
    
    // Step3VC Atributes
    var defaults = UserDefaults.standard
    var accceptOfferFlag = false
    var listIndefinitelyFlag = false
    var acceptOffers = "no"
    var DaysIn = [String]()
    var payPeriodArray = [String]()
    var selectedDuration: String?
    var selecteditem : ProductModel?
    var currencyChar : Character = "$"
    var currency_String = String()
    var currency_Symbol = String()
    var check = true
    var selected_date = Int()
    var Select_payPeriod = String()
    var AcceptOffer = Bool()
    var ListIdentefily = Bool()
    let defaultCurrencyPicker = UIPickerView()
    
    
    @IBOutlet var borderLbl: UILabel!
    //TakeSalaryCustom
    @IBOutlet weak var JobSalaryTitleLbl: UILabel!
    @IBOutlet weak var JobSalaryTextField: UITextField!
    @IBOutlet weak var DollarLabel: UILabel!
    @IBOutlet weak var DollarView: UIView!
    @IBOutlet weak var currencyBtn: UIButton!
    @IBOutlet weak var currencyPickerBtn: UIButton!
    
    var TakeDurationAndOffersCustom = Bundle.main.loadNibNamed("JobListingDurationAndOffersVC", owner: self, options: nil)?.first as! TakeDurationAndOffersCustomCell
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        borderLbl.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        borderLbl.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JobSalaryTextField.keyboardType = UIKeyboardType.decimalPad
        
        TakeDurationAndOffersCustom.acceptOfferLbl.text = "Negotiable"
        JobSalaryTitleLbl.text = "Price:"
        JobSalaryTextField.placeholder = "Price"
        ServiceMainView.addShadow()
        
        ServiceOfferMainView.frame = TakeDurationAndOffersCustom.frame
        ServiceOfferMainView.addShadow()
        ServiceOfferMainView.addSubview(TakeDurationAndOffersCustom)
        
        DollarLabel.text = currency_String
        DollarLabel.text = currency_Symbol
        
        DaysIn = ["3 Days","5 Days","7 Days","10 Days", "15 Days","21 Days","30 Days"]
        payPeriodArray = ["Daily", "BiWeekly", "Weekly", "Monthly","Project based"]
        
        TakeDurationAndOffersCustom.listingDurationTextField.delegate = self
        TakeDurationAndOffersCustom.payPeriodTextField.delegate = self
        JobSalaryTextField.delegate = self
        
        selectCreatePicker(textField: TakeDurationAndOffersCustom.listingDurationTextField, tag: 3)
        createToolBar(textField: TakeDurationAndOffersCustom.listingDurationTextField)
        
        
        selectCreatePicker(textField: TakeDurationAndOffersCustom.payPeriodTextField, tag: 4)
        createToolBar(textField: TakeDurationAndOffersCustom.payPeriodTextField)
        
        
        TakeDurationAndOffersCustom.listIndefinitelySwitch.addTarget(self, action: #selector(listindefinitelySwitchAction), for: .touchUpInside)
        TakeDurationAndOffersCustom.acceptOfferSwitch.addTarget(self, action: #selector(AcceptOfferSwitchAction), for: .touchUpInside)
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        JobSalaryTextField.endEditing(true)
        TakeDurationAndOffersCustom.listIndefinitelySwitch.endEditing(true)
        TakeDurationAndOffersCustom.acceptOfferSwitch.endEditing(true)
        
        TakeDurationAndOffersCustom.listIndefinitelyStackView.endEditing(true)
        TakeDurationAndOffersCustom.listDurationStackView.endEditing(true)
        TakeDurationAndOffersCustom.acceptsOfferStackView.endEditing(true)
        TakeDurationAndOffersCustom.payPeriodStackView.endEditing(true)
        
        
        TakeDurationAndOffersCustom.listIndefinitelyImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showListIndefinitely))
        tapGestureRecognizer.numberOfTapsRequired = 1
        TakeDurationAndOffersCustom.listIndefinitelyImage.addGestureRecognizer(tapGestureRecognizer)
        
        TakeDurationAndOffersCustom.listingDurationImage.isUserInteractionEnabled = true
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(showListingDuration))
        tapGestureRecognizer.numberOfTapsRequired = 1
        TakeDurationAndOffersCustom.listingDurationImage.addGestureRecognizer(tapGestureRecognizer1)
        
        TakeDurationAndOffersCustom.acceptOffersImage.isUserInteractionEnabled = true
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(showAcceptOffers))
        tapGestureRecognizer.numberOfTapsRequired = 1
        TakeDurationAndOffersCustom.acceptOffersImage.addGestureRecognizer(tapGestureRecognizer2)
        
        TakeDurationAndOffersCustom.autoRelistingImage.isUserInteractionEnabled = true
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(showAutoRelistInfoPopup))
        tapGestureRecognizer.numberOfTapsRequired = 1
        TakeDurationAndOffersCustom.autoRelistingImage.addGestureRecognizer(tapGestureRecognizer3)
        
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
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        JobSalaryTextField.endEditing(true)
        TakeDurationAndOffersCustom.listIndefinitelySwitch.endEditing(true)
        TakeDurationAndOffersCustom.acceptOfferSwitch.endEditing(true)
        TakeDurationAndOffersCustom.listingDurationTextField.endEditing(true)
        TakeDurationAndOffersCustom.payPeriodTextField.endEditing(true)
        TakeDurationAndOffersCustom.listIndefinitelyStackView.endEditing(true)
        TakeDurationAndOffersCustom.listDurationStackView.endEditing(true)
        TakeDurationAndOffersCustom.acceptsOfferStackView.endEditing(true)
        TakeDurationAndOffersCustom.payPeriodStackView.endEditing(true)
        
    }
    
    @objc func listindefinitelySwitchAction(){
        
        TakeDurationAndOffersCustom.listIndefinitelySwitch.isSelected = !TakeDurationAndOffersCustom.listIndefinitelySwitch.isSelected
        
        if TakeDurationAndOffersCustom.listIndefinitelySwitch.isSelected == true{
            TakeDurationAndOffersCustom.listDurationHeight.constant = 0
            TakeDurationAndOffersCustom.listIndefinitelySwitch.layer.borderColor = UIColor.clear.cgColor
            print("ListIndefinitely Selected")
            ListIdentefily = true
            
        }else if TakeDurationAndOffersCustom.listIndefinitelySwitch.isSelected == false{
            TakeDurationAndOffersCustom.listDurationHeight.constant = 75
            TakeDurationAndOffersCustom.listIndefinitelySwitch.layer.borderColor = UIColor.clear.cgColor
            print("ListIndefinitely Un-Selected")
            ListIdentefily = false
        }
        else {
            DispatchQueue.main.async {
                self.TakeDurationAndOffersCustom.listIndefinitelySwitch.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
    }
    
    @objc func AcceptOfferSwitchAction(){
        
        TakeDurationAndOffersCustom.acceptOfferSwitch.isSelected = !TakeDurationAndOffersCustom.acceptOfferSwitch.isSelected
        
        if TakeDurationAndOffersCustom.acceptOfferSwitch.isSelected == true{
            TakeDurationAndOffersCustom.acceptOfferSwitch.layer.borderColor = UIColor.clear.cgColor
            print("AcceptOffer Selected")
            AcceptOffer = true
            
        }else if TakeDurationAndOffersCustom.acceptOfferSwitch.isSelected == false{
            TakeDurationAndOffersCustom.acceptOfferSwitch.layer.borderColor = UIColor.clear.cgColor
            print("AcceptOffer Un-Selected")
            AcceptOffer = false
        }
        else {
            DispatchQueue.main.async {
                self.TakeDurationAndOffersCustom.acceptOfferSwitch.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
    }
    
}


extension  ServiceListingStep3VC : UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == defaultCurrencyPicker {
            return CurrencyManager.currencyArray.count
        }else if (pickerView.tag == 3) {
            return DaysIn.count
        }else{
            return payPeriodArray.count
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
        }else if (pickerView.tag == 3) {
            return DaysIn[row]
        }else{
            return payPeriodArray[row]
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == defaultCurrencyPicker {
            
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
            self.DollarLabel.text = symbol
            self.currency_Symbol = symbol
            
        }else if (pickerView.tag == 3) {
            TakeDurationAndOffersCustom.listingDurationTextField.text = DaysIn[row]
            let days = DaysIn[row].split(separator: " ")
            self.selected_date = Int(days[0])!
        }else{
            TakeDurationAndOffersCustom.payPeriodTextField.text =  payPeriodArray[row]
            self.Select_payPeriod = payPeriodArray[row]
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
            print("Current Symbol = \(symbol)")
            self.currency_String = symbol
        }else if (pickerView.tag == 3) {
            label.text = DaysIn[row]
            let days = DaysIn[row].split(separator: " ")
            self.selected_date = Int(days[0])!
        }else{
            label.text = payPeriodArray[row]
            self.Select_payPeriod = payPeriodArray[row]
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
        print("doneBtn==\(doneBtn)")
        toolBar.setItems([doneBtn], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        toolBar.tintColor = UIColor.red
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func handleDone()
    {
        
        currencyBtn.endEditing(true)
        JobSalaryTextField.endEditing(true)
        TakeDurationAndOffersCustom.listingDurationTextField.endEditing(true)
        TakeDurationAndOffersCustom.payPeriodTextField.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == currencyBtn {
            textField.resignFirstResponder()
        }
        else if textField == JobSalaryTextField {
            textField.resignFirstResponder()
            JobSalaryTextField.becomeFirstResponder()
        }
        return true
    }
    
    
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

