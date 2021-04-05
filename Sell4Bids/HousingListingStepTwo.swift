//
//  HousingListingStepTwo.swift
//  Sell4Bids
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 admin. All rights reserved.
//  Osama Mansoori

import UIKit

class HousingListingStepTwo: UIViewController , UITextViewDelegate{
    
    //MARK:- Outlets and properties
    @IBOutlet weak var realEstateTextField: UITextField!
    @IBOutlet weak var bedroomsTextField: UITextField!
    @IBOutlet weak var bathroomTextField: UITextField!
    @IBOutlet weak var laundryTextField: UITextField!
    @IBOutlet weak var parkingTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var squareFeetTextField: UITextField!
    @IBOutlet weak var availableDateTextField: UITextField!
    @IBOutlet weak var openHouseDateTextField: UITextField!
    @IBOutlet weak var PetsAccepted: UIButton!
    @IBOutlet weak var Furnished: UIButton!
    @IBOutlet weak var NoSmoking: UIButton!
    @IBOutlet weak var WheelChairAccess: UIButton!
    @IBOutlet weak var realEstateViewHeights: NSLayoutConstraint!
    @IBOutlet weak var bedroomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bathroomViewHeights: NSLayoutConstraint!
    @IBOutlet weak var laundryViewHeights: NSLayoutConstraint!
    @IBOutlet weak var parkingViewHeights: NSLayoutConstraint!
    @IBOutlet weak var squareFeetViewHeights: NSLayoutConstraint!
    @IBOutlet weak var availbleViewHeights: NSLayoutConstraint!
    @IBOutlet weak var openHouseHeights: NSLayoutConstraint!
    @IBOutlet weak var additionalViewHeights: NSLayoutConstraint!
    
    
    //MARK:- Variables:
    lazy var petsAccepted_Variable = String()
    lazy var Furnished_Variable = String()
    lazy var NoSmoking_Variable = String()
    lazy var WheelChairAccess_Variable = String()
    
    lazy var bedroomArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    lazy var bathroomArray = ["0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8+"]
    lazy var laundryArray = ["W/D in unit", "W/D hookups", "Laundry in bldg", "Laundry on site", "No laundry on site"]
    lazy var parkingArray = ["Carport", "Attached garage", "Detached garage", "Off-street parking", "Street parking", "Valet parking", "No parking"]
    
    lazy var realEstateArray = ["Any","Apartment","House","Cottage/cabin","Duplex","Flat","Condo","In-law Suite","Loft","Townhouse","Manufacture","Assisted living","Land"]
    
    lazy var petsSelectionStatus = false
    lazy var furnishedSelectionStatus = false
    lazy var noSmokingSelectionStatus = false
    lazy var wheelChairSelectionStatus = false
    
    //MARK:- View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectCreatePicker(textField: bedroomsTextField, tag: 1)
        createToolBar(textField: bedroomsTextField)
        
        selectCreatePicker(textField: bathroomTextField, tag: 2)
        createToolBar(textField: bathroomTextField)
        
        selectCreatePicker(textField: laundryTextField, tag: 3)
        createToolBar(textField: laundryTextField)
        
        selectCreatePicker(textField: parkingTextField, tag: 4)
        createToolBar(textField: parkingTextField)
        
        selectCreatePicker(textField: realEstateTextField, tag: 5)
               createToolBar(textField: realEstateTextField)
        
        
        realEstateTextField.textAlignment = .center
        bedroomsTextField.textAlignment = .center
        bathroomTextField.textAlignment = .center
        laundryTextField.textAlignment = .center
        parkingTextField.textAlignment = .center
        squareFeetTextField.textAlignment = .center
        availableDateTextField.textAlignment = .center
        openHouseDateTextField.textAlignment = .center
        
        
        PetsAccepted.addTarget(self, action: #selector(petsAccepted(sender:)), for: .touchUpInside)
        Furnished.addTarget(self, action: #selector(Furnished(sender:)), for: .touchUpInside)
        NoSmoking.addTarget(self, action: #selector(noSmoking(sender:)), for: .touchUpInside)
        WheelChairAccess.addTarget(self, action: #selector(wheelChairAccess(sender:)), for: .touchUpInside)
        
        descriptionTextView.delegate = self
        descriptionTextView.makeCornersRound()
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.text = "Housing Description"
        descriptionTextView.textColor = UIColor.lightGray
        
        PetsAccepted.makeBlackBorder()
        Furnished.makeBlackBorder()
        NoSmoking.makeBlackBorder()
        WheelChairAccess.makeBlackBorder()
        
    }
    
    
    //MARK:- Actions
    @objc func petsAccepted (sender:UIButton){
        if petsSelectionStatus == false {
            petsSelectionStatus = true
            PetsAccepted.backgroundColor = UIColor.black
            PetsAccepted.setTitleColor(.white, for: .normal)
            petsAccepted_Variable = "Pets Accepted"
            print("Pets Accepted is selected == \(petsAccepted_Variable)")
        }else if petsSelectionStatus == true{
            petsSelectionStatus = false
            PetsAccepted.backgroundColor = UIColor.white
            PetsAccepted.setTitleColor(.black, for: .normal)
            petsAccepted_Variable = ""
            print("Pets Accepted is Unselected == \(petsAccepted_Variable)")
        }
    }
    
    @objc func Furnished (sender:UIButton){
        if furnishedSelectionStatus == false {
            furnishedSelectionStatus = true
            Furnished.backgroundColor = UIColor.black
            Furnished.setTitleColor(.white, for: .normal)
            Furnished_Variable = "Furnished"
            print("Furnished is selected == \(Furnished_Variable)")
        }else if furnishedSelectionStatus == true{
            furnishedSelectionStatus = false
            Furnished.backgroundColor = UIColor.white
            Furnished.setTitleColor(.black, for: .normal)
            Furnished_Variable = ""
            print("Furnished is Unselected == \(Furnished_Variable)")
        }
    }
    
    @objc func noSmoking (sender:UIButton){
        if noSmokingSelectionStatus == false {
            noSmokingSelectionStatus = true
            NoSmoking.backgroundColor = UIColor.black
            NoSmoking.setTitleColor(.white, for: .normal)
            NoSmoking_Variable = "No Smoking"
            print("No Smoking is selected == \(NoSmoking_Variable)")
        }else if noSmokingSelectionStatus == true{
            noSmokingSelectionStatus = false
            NoSmoking.backgroundColor = UIColor.white
            NoSmoking.setTitleColor(.black, for: .normal)
            NoSmoking_Variable = ""
            print("No Smoking is Unselected == \(NoSmoking_Variable)")
        }
    }
    
    @objc func wheelChairAccess (sender:UIButton){
        if wheelChairSelectionStatus == false {
            wheelChairSelectionStatus = true
            WheelChairAccess.backgroundColor = UIColor.black
            WheelChairAccess.setTitleColor(.white, for: .normal)
            WheelChairAccess_Variable = "Wheel Chair Access"
            print("Wheel Chair Access is selected == \(WheelChairAccess_Variable)")
        }else if wheelChairSelectionStatus == true {
            wheelChairSelectionStatus = false
            WheelChairAccess.backgroundColor = UIColor.white
            WheelChairAccess.setTitleColor(.black, for: .normal)
            WheelChairAccess_Variable = ""
            print("Wheel Chair Access is Unselected == \(WheelChairAccess_Variable)")
        }
    }
    
    
    //MARK:- Private Function
    private func TextFieldStyle(){
        
        bedroomsTextField.makeCornersRound()
        bedroomsTextField.layer.borderColor = UIColor.black.cgColor
        bedroomsTextField.layer.borderWidth = 1.0
        
        bathroomTextField.makeCornersRound()
        bathroomTextField.layer.borderColor = UIColor.black.cgColor
        bathroomTextField.layer.borderWidth = 1.0
        
        laundryTextField.makeCornersRound()
        laundryTextField.layer.borderColor = UIColor.black.cgColor
        laundryTextField.layer.borderWidth = 1.0
        
        parkingTextField.makeRedAndRound()
        parkingTextField.layer.borderColor = UIColor.black.cgColor
        parkingTextField.layer.borderWidth = 1.0
    }
}

//MARK:- Text Delgate, Action and Function
extension HousingListingStepTwo : UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
             if descriptionTextView.textColor == UIColor.lightGray {
                 descriptionTextView.text = nil
                 descriptionTextView.textColor = UIColor.black
             }
         }
         
         func textViewDidEndEditing(_ textView: UITextView) {
             if descriptionTextView.text.isEmpty {
                 descriptionTextView.text = "Housing Description"
                 descriptionTextView.textColor = UIColor.lightGray
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
    
    @objc func handleDone(){
        bedroomsTextField.endEditing(true)
        bathroomTextField.endEditing(true)
        laundryTextField.endEditing(true)
        parkingTextField.endEditing(true)
        realEstateTextField.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text!.isEmpty{
            if textField == realEstateTextField{
                textField.placeholder = "Real Estate Type"
            }else if textField == bedroomsTextField {
                textField.placeholder = "How many bedrooms"
            }else if textField == bathroomTextField {
                textField.placeholder = "How many bathrooms"
            }else if textField == laundryTextField {
                textField.placeholder = "Select Laundry"
            }else if textField == parkingTextField {
                textField.placeholder = "Select Parking"
            }else if textField == squareFeetTextField {
                textField.placeholder = "Select square feet"
            }else if textField == availableDateTextField {
                textField.placeholder = "Select Availability"
            }else if textField == openHouseDateTextField {
                textField.placeholder = "Select open house date"
            }else {
                print(textField)
            }
        }else {
            textField.placeholder = nil
        }
    }
    
}

//MARK:-  Picker View Delgate and Data Source
extension HousingListingStepTwo: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return bedroomArray.count
        }else if (pickerView.tag == 2){
            return bathroomArray.count
        }else if (pickerView.tag == 3){
            return laundryArray.count
        }else if (pickerView.tag == 4){
            return parkingArray.count
        }else if (pickerView.tag == 5){
            return realEstateArray.count
        }else{
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            return bedroomArray[row]
        }else if (pickerView.tag == 2){
            return bathroomArray[row]
        }else if (pickerView.tag == 3){
            return laundryArray[row]
        }else if (pickerView.tag == 4) {
            return parkingArray[row]
        }else if (pickerView.tag == 5){
            return realEstateArray[row]
        }else {
           return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            bedroomsTextField.text = bedroomArray[row]
        }
        else if (pickerView.tag == 2){
            bathroomTextField.text = bathroomArray[row]
        }
        else if (pickerView.tag == 3){
            laundryTextField.text = laundryArray[row]
        }
        else if (pickerView.tag == 4){
            parkingTextField.text = parkingArray[row]
        }else if pickerView.tag == 5 {
            realEstateTextField.text = realEstateArray[row]
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
        
        if (pickerView.tag == 1) {
            label.text = bedroomArray[row]
        }else if (pickerView.tag == 2){
            label.text = bathroomArray[row]
        }else if (pickerView.tag == 3){
            label.text = laundryArray[row]
        }else if (pickerView.tag == 4){
            label.text = parkingArray[row]
        }else if (pickerView.tag == 5){
            label.text = realEstateArray[row]
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


