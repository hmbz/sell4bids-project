//
//  VehicleContainerThreeVC.swift
//  Sell4Bids
//
//  Created by Admin on 22/06/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class VehicleContainerThreeVC: UIViewController {
    
    // Price and Quantity
    @IBOutlet weak var pricetext: UITextField!
    @IBOutlet weak var currencyTestFiled: textFieldWithNoCopyPasteSelect!
    
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
    
    
    // variables
    var defaults = UserDefaults.standard
    var accceptOfferFlag = false
    var listIndefinitelyFlag = false
    var acceptOffers = "no"
    var list1 = [String]()
    var selectedDuration: String?
    var selecteditem : ProductModel?
    var currencyChar : Character = "$"
    var currency_String = String()
    var currency_Symbol = String()
    var check = true
    var selected_date = Int()
    var listIdentifily = Bool()
    var accecptOffer = Bool()
    var auto_Relisting = Bool()
    var list_Iden = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listIndefinitelySwitch.endEditing(true)
        acceptOfferSwitch.endEditing(true)
        listDurationTextField.endEditing(true)
        autoRelistingSwitch.endEditing(true)
        pricetext.endEditing(true)
        listIndefinitelyStackView2.endEditing(true)
        listDurationsStackView.endEditing(true)
        acceptsOfferStackView2.endEditing(true)
        autoRelisting.endEditing(true)
        listIndefinitelyLbl.endEditing(true)
        listDurationLbl.endEditing(true)
        acceptOfferLbl.endEditing(true)
        automaticRelisting.endEditing(true)
        
        
        
        pricetext.keyboardType = UIKeyboardType.decimalPad
        
        
        list1 = ["3 Days","5 Days","7 Days","10 Days", "15 Days","21 Days","30 Days"]
        TextFieldStyle()
        listDurationTextField.delegate = self
        pricetext.delegate = self
        
        
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
        
        
        pricetext.layer.borderColor = UIColor.black.cgColor
        pricetext.layer.borderWidth = 2.0
        pricetext.makeCornersRound()
        
        // Step1VC Working.
        //        pricetext.layer.borderColor = UIColor.black.cgColor
        //        Qantitytxt.layer.borderColor = UIColor.black.cgColor
        //        pricetext.makeCornersRound()
        //        pricetext.layer.borderWidth = 2.0
        //        Qantitytxt.makeCornersRound()
        //        Qantitytxt.layer.borderWidth = 2.0
    }
    
}



// Extension : ItemListingStepThreeContainerVC for PickerView And for TextField
extension  VehicleContainerThreeVC : UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 2) {
            return list1.count
        }
        return list1.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 2){
            return list1[row]
        }
        return list1[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let days = list1[row].split(separator: " ")
        self.selected_date = Int(days[0])!
        
        if (pickerView.tag == 2)
        {
            listDurationTextField.text = list1[row]
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
        if (pickerView.tag == 2) {
            label.text = list1[row]
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
        if textField == currencyTestFiled {
            textField.resignFirstResponder()
        }
        else if textField == pricetext {
            textField.resignFirstResponder()
            Qantitytxt.becomeFirstResponder()
        }
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        
        
        
        //        if textField.tag == 1 {
        //            print("called Editing")
        //            var price = textField.text
        //            let i = price!.characters.index(of: currencyChar)
        //            if i != nil {
        //
        //                price!.remove(at: i!)
        //            }else {
        //                print("called Editing nil")
        //            }
        //            textField.text = price!
        //        }
        //
        
        
        
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        
        
        
        //        if textField.tag == 1  {
        //
        //            let temp = textField.text
        //            if gpscountry == "USA" {
        //                if temp?.contains(currency_Symbol)==false  {
        //                    textField.text = currency_Symbol + temp!
        //                    check = true
        //                }
        //            }else if  gpscountry == "IN" {
        //                if temp?.contains(currency_Symbol)==false  {
        //                    textField.text = currency_Symbol + temp!
        //                    self.check = true
        //                }
        //            }
        //        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
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

