//
//  HousingListing_Two.swift
//  Sell4Bids
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 admin. All rights reserved.
//  Osama Mansoori

import UIKit

class HousingListingStepTwo: UIViewController , UITextViewDelegate{
    
    //MARK:- Outlets and properties
    @IBOutlet weak var noOfBedRooms: textFieldWithNoCopyPasteSelect!
    @IBOutlet weak var noOfBathrooms: textFieldWithNoCopyPasteSelect!
    @IBOutlet weak var laundry: textFieldWithNoCopyPasteSelect!
    @IBOutlet weak var parking: textFieldWithNoCopyPasteSelect!
    @IBOutlet weak var selectCondition: textFieldWithNoCopyPasteSelect!
    @IBOutlet weak var Descriptiontext: UITextView!
    @IBOutlet weak var SelectSquareFeet: textFieldWithNoCopyPasteSelect!
    @IBOutlet weak var AvailibleOn: textFieldWithNoCopyPasteSelect!
    @IBOutlet weak var OpenHouseDate: textFieldWithNoCopyPasteSelect!
    @IBOutlet weak var PetsAccepted: UIButton!
    @IBOutlet weak var Furnished: UIButton!
    @IBOutlet weak var NoSmoking: UIButton!
    @IBOutlet weak var WheelChairAccess: UIButton!
    
    
    //MARK:- Variables:
    var petsAccepted_Variable = String()
    var Furnished_Variable = String()
    var NoSmoking_Variable = String()
    var WheelChairAccess_Variable = String()
    
    var Bedrooms_Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    var Bathrooms_Array = ["0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8+"]
    var Laundry_Array = ["W/D in unit", "W/D hookups", "Laundry in bldg", "Laundry on site", "No laundry on site"]
    var Parking_Array = ["Carport", "Attached garage", "Detached garage", "Off-street parking", "Street parking", "Valet parking", "No parking"]
    var Condition_Array = ["Other (see description)", "For parts", "Used", "Reconditioned", "Open box / like new", "New"]
    
    //MARK:- View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectCreatePicker(textField: noOfBedRooms, tag: 1)
        createToolBar(textField: noOfBedRooms)
        
        selectCreatePicker(textField: noOfBathrooms, tag: 2)
        createToolBar(textField: noOfBathrooms)
        
        selectCreatePicker(textField: laundry, tag: 3)
        createToolBar(textField: laundry)
        
        selectCreatePicker(textField: parking, tag: 4)
        createToolBar(textField: parking)
        
        selectCreatePicker(textField: selectCondition, tag: 5)
        createToolBar(textField: selectCondition)
        
        PetsAccepted.addTarget(self, action: #selector(petsAccepted(sender:)), for: .allTouchEvents)
        Furnished.addTarget(self, action: #selector(Furnished(sender:)), for: .allTouchEvents)
        NoSmoking.addTarget(self, action: #selector(noSmoking(sender:)), for: .allTouchEvents)
        WheelChairAccess.addTarget(self, action: #selector(wheelChairAccess(sender:)), for: .allTouchEvents)
        
        Descriptiontext.delegate = self
        Descriptiontext.makeCornersRound()
        Descriptiontext.layer.borderColor = UIColor.black.cgColor
        Descriptiontext.layer.borderWidth = 1.0
        Descriptiontext.text = "Housing Description"
        Descriptiontext.textColor = UIColor.lightGray
        
        PetsAccepted.makeBlackBorder()
        Furnished.makeBlackBorder()
        NoSmoking.makeBlackBorder()
        WheelChairAccess.makeBlackBorder()
        
    }
    
    
    //MARK:- Actions
    @objc func petsAccepted (sender:UIButton){
        if sender.isTouchInside == true {
            PetsAccepted.backgroundColor = UIColor.black
            PetsAccepted.setTitleColor(.white, for: .normal)
            petsAccepted_Variable = "Pets Accepted"
            print("Pets Accepted is selected == \(petsAccepted_Variable)")
        }else if sender.isTouchInside == false{
            PetsAccepted.backgroundColor = UIColor.white
            PetsAccepted.setTitleColor(.black, for: .normal)
            petsAccepted_Variable = ""
            print("Pets Accepted is Unselected == \(petsAccepted_Variable)")
        }
    }
    
    @objc func Furnished (sender:UIButton){
        if sender.isTouchInside == true {
            Furnished.backgroundColor = UIColor.black
            Furnished.setTitleColor(.white, for: .normal)
            Furnished_Variable = "Furnished"
            print("Furnished is selected == \(Furnished_Variable)")
        }else if sender.isTouchInside == false{
            Furnished.backgroundColor = UIColor.white
            Furnished.setTitleColor(.black, for: .normal)
            Furnished_Variable = ""
            print("Furnished is Unselected == \(Furnished_Variable)")
        }
    }
    
    @objc func noSmoking (sender:UIButton){
        if sender.isTouchInside == true {
            NoSmoking.backgroundColor = UIColor.black
            NoSmoking.setTitleColor(.white, for: .normal)
            NoSmoking_Variable = "No Smoking"
            print("No Smoking is selected == \(NoSmoking_Variable)")
        }else if sender.isTouchInside == false{
            NoSmoking.backgroundColor = UIColor.white
            NoSmoking.setTitleColor(.black, for: .normal)
            NoSmoking_Variable = ""
            print("No Smoking is Unselected == \(NoSmoking_Variable)")
        }
    }
    
    @objc func wheelChairAccess (sender:UIButton){
        if sender.isTouchInside == true {
            WheelChairAccess.backgroundColor = UIColor.black
            WheelChairAccess.setTitleColor(.white, for: .normal)
            WheelChairAccess_Variable = "Wheel Chair Access"
            print("Wheel Chair Access is selected == \(WheelChairAccess_Variable)")
        }else if sender.isTouchInside == true && (sender.backgroundColor != nil) {
            WheelChairAccess.backgroundColor = UIColor.white
            WheelChairAccess.setTitleColor(.black, for: .normal)
            WheelChairAccess_Variable = ""
            print("Wheel Chair Access is Unselected == \(WheelChairAccess_Variable)")
        }
    }
    
    //MARK:- Private Function
    private func TextFieldStyle(){
        
        noOfBedRooms.makeCornersRound()
        noOfBedRooms.layer.borderColor = UIColor.black.cgColor
        noOfBedRooms.layer.borderWidth = 1.0
        
        noOfBathrooms.makeCornersRound()
        noOfBathrooms.layer.borderColor = UIColor.black.cgColor
        noOfBathrooms.layer.borderWidth = 1.0
        
        laundry.makeCornersRound()
        laundry.layer.borderColor = UIColor.black.cgColor
        laundry.layer.borderWidth = 1.0
        
        parking.makeRedAndRound()
        parking.layer.borderColor = UIColor.black.cgColor
        parking.layer.borderWidth = 1.0
        
        selectCondition.makeCornersRound()
        selectCondition.layer.borderColor = UIColor.black.cgColor
        selectCondition.layer.borderWidth = 1.0
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
           if Descriptiontext.textColor == UIColor.lightGray {
               Descriptiontext.text = nil
               Descriptiontext.textColor = UIColor.black
           }
       }
       
       func textViewDidEndEditing(_ textView: UITextView) {
           if Descriptiontext.text.isEmpty {
               Descriptiontext.text = "Housing Description"
               Descriptiontext.textColor = UIColor.lightGray
           }
       }
    
}

//MARK:- UITextFieldDelegate
extension HousingListingStepTwo : UITextFieldDelegate {
    
    
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
        
        noOfBedRooms.endEditing(true)
        noOfBathrooms.endEditing(true)
        laundry.endEditing(true)
        parking.endEditing(true)
        selectCondition.endEditing(true)
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text!.isEmpty{
            if textField == noOfBedRooms {
                textField.placeholder = "How many bedrooms"
            }else if textField == noOfBathrooms {
                textField.placeholder = "How many bathrooms"
            }else if textField == laundry {
                textField.placeholder = "Select Laundry"
            }else if textField == parking {
                textField.placeholder = "Select Parking"
            }else if textField == selectCondition {
                textField.placeholder = "Select Condition"
            }
            else if textField == SelectSquareFeet {
                textField.placeholder = "Select square feet"
            }else if textField == AvailibleOn {
                textField.placeholder = "Select Availability"
            }else if textField == OpenHouseDate {
                textField.placeholder = "Select open house date"
            }else {
                print(textField)
            }
        }else {
            textField.placeholder = nil
        }
    }
    
}

//MARK:-  UIPickerViewDelegate, UIPickerViewDataSource
extension HousingListingStepTwo: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return Bedrooms_Array.count
        }else if (pickerView.tag == 2){
            return Bathrooms_Array.count
        }else if (pickerView.tag == 3){
            return Laundry_Array.count
        }else if (pickerView.tag == 4){
            return Parking_Array.count
        }else if (pickerView.tag == 5){
            return Condition_Array.count
        }else{
            return Bedrooms_Array.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            return Bedrooms_Array[row]
        }else if (pickerView.tag == 2){
            return Bathrooms_Array[row]
        }else if (pickerView.tag == 3){
            return Laundry_Array[row]
        }else if (pickerView.tag == 4) {
            return Parking_Array[row]
        }else if (pickerView.tag == 5){
            return Condition_Array[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            noOfBedRooms.text = Bedrooms_Array[row]
        }
        else if (pickerView.tag == 2){
            noOfBathrooms.text = Bathrooms_Array[row]
        }
        else if (pickerView.tag == 3){
            laundry.text = Laundry_Array[row]
        }
        else if (pickerView.tag == 4){
            parking.text = Parking_Array[row]
        }
        else if (pickerView.tag == 5){
            selectCondition.text = Condition_Array[row]
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
            label.text = Bedrooms_Array[row]
        }else if (pickerView.tag == 2){
            label.text = Bathrooms_Array[row]
        }else if (pickerView.tag == 3){
            label.text = Laundry_Array[row]
        }else if (pickerView.tag == 4){
            label.text = Parking_Array[row]
        }else if (pickerView.tag == 5){
            label.text = Condition_Array[row]
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


