//
//  JobListingStep2(1)Vc.swift
//  Sell4Bids
//
//  Created by Admin on 07/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//  @ OM 08-Feb-2019

import UIKit
import AVFoundation


class JobListingStep1VC: UIViewController {
    
    var employmentType = ["Select Employment Type","Contract Hire","Employee's Choice", "Full-Time","Internship","Temporary"]
    
    @IBOutlet weak var TakeTitleView: UIView!
    @IBOutlet weak var jobEmploymentView: UIView!
    @IBOutlet weak var jobBenefitsView: UIView!
    var Medical = Bool()
    var PTO = Bool()
    var k401 = Bool()

    
    
    //TakeTitleCustom
    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var jobTitleTextField: UITextField!
    //TakeEmploymentCustom
    @IBOutlet weak var JobEmploymentLbl: UILabel!
    @IBOutlet weak var JobSelectEmploymentTextField: textFieldWithNoCopyPasteSelect!
    //TakeBenefitsCustom
    @IBOutlet weak var jobBenefitsTitleLbl: UILabel!
    @IBOutlet weak var jobMedicalTitleLbl: UILabel!
    @IBOutlet weak var jobFourZeroOneLbl: UILabel!
    @IBOutlet weak var jobPTOlbl: UILabel!
    @IBOutlet weak var medicalSwitch: UISwitch!
    @IBOutlet weak var PTOSwitch: UISwitch!
    @IBOutlet weak var fourZeroOneSwitch: UISwitch!
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        TakeTitleView.addShadow()
        jobEmploymentView.addShadow()
        jobBenefitsView.addShadow()
        JobSelectEmploymentTextField.textAlignment = .center
//        jobTitleTextField.makeCornersRound()
//        jobTitleTextField.layer.borderWidth = 1.0
//        JobSelectEmploymentTextField.makeCornersRound()
//        JobSelectEmploymentTextField.layer.borderWidth = 1.0
        
        medicalSwitch.addTarget(self, action: #selector(MedicalBtnAction), for: .touchUpInside)
        PTOSwitch.addTarget(self, action: #selector(PTOBtnAction), for: .touchUpInside)
        fourZeroOneSwitch.addTarget(self, action: #selector(FourZeroOne), for: .touchUpInside)
    
        createPicker(textField: JobSelectEmploymentTextField)
        createToolBar(textField: JobSelectEmploymentTextField)
        
        jobTitleTextField.delegate = self
        JobSelectEmploymentTextField.delegate = self
        
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        jobTitleTextField.endEditing(true)
        fourZeroOneSwitch.endEditing(true)
        medicalSwitch.endEditing(true)
        PTOSwitch.endEditing(true)
        JobSelectEmploymentTextField.endEditing(true)

    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func MedicalBtnAction(){
        
        medicalSwitch.isSelected = !medicalSwitch.isSelected
        
        if medicalSwitch.isSelected == true{
            medicalSwitch.layer.borderColor = UIColor.clear.cgColor
            print("Medical Selected")
            Medical = true
            
        }else if medicalSwitch.isSelected == false{
            medicalSwitch.layer.borderColor = UIColor.clear.cgColor
            print("Medical Un-Selected")
            Medical = false
        }
        else {
            DispatchQueue.main.async {
                self.medicalSwitch.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
        }
    
    @objc func PTOBtnAction(){
        
            PTOSwitch.isSelected = !PTOSwitch.isSelected
        
            if PTOSwitch.isSelected == true{
                PTOSwitch.layer.borderColor = UIColor.clear.cgColor
                print("PTO Selected")
                PTO = true
            }
            else if PTOSwitch.isSelected == false{
            PTOSwitch.layer.borderColor = UIColor.clear.cgColor
            print("PTO Un_Selected")
                PTO = false
                
            }
                
            else {
                DispatchQueue.main.async {
                    self.PTOSwitch.layer.borderColor = UIColor.darkGray.cgColor
                }
            }
        }
    
    
    @objc func FourZeroOne(){
        
        fourZeroOneSwitch.isSelected = !fourZeroOneSwitch.isSelected
        
        if fourZeroOneSwitch.isSelected == true{
            fourZeroOneSwitch.layer.borderColor = UIColor.clear.cgColor
            print("401(k) Selected")
            k401 = true
            
        }else if fourZeroOneSwitch.isSelected == false{
            fourZeroOneSwitch.layer.borderColor = UIColor.clear.cgColor
            print("401(k) Un-Selected")
            k401 = false
            
        }       else {
            DispatchQueue.main.async {
                self.fourZeroOneSwitch.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
      }
    }




//MARK:- UITextFieldDelegate
extension JobListingStep1VC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
       
        if textField == jobTitleTextField{
            if textField.isFirstResponder{
               
                func TitletextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                    //For mobile numer validation
                    if textField == jobTitleTextField {
                        print("titleValidations== \(textField)")
                        let allowedCharacters = CharacterSet(charactersIn:".*[^A-Za-z\\s].*")//Here change this characters based on your requirement
                        let characterSet = CharacterSet(charactersIn: string)
                        
                        return allowedCharacters.isSuperset(of: characterSet)
                        
                    }
                    return true
                }
            JobSelectEmploymentTextField.becomeFirstResponder()
                
            }
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == JobSelectEmploymentTextField{
            return true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == jobTitleTextField {
            if textField.text!.isEmpty{
                textField.placeholder = "e.g: Data Entry Operator"
            }
            
        }else {
            // Write something Else
        }
    }

    
    ///for disabling the employment type text field entering text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == JobSelectEmploymentTextField {
            return false
        }
        return true
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
        jobTitleTextField.endEditing(true)
        fourZeroOneSwitch.endEditing(true)
        medicalSwitch.endEditing(true)
        PTOSwitch.endEditing(true)
        JobSelectEmploymentTextField.endEditing(true)
        
    }
}





//MARK:-  UIPickerViewDelegate, UIPickerViewDataSource
extension JobListingStep1VC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return employmentType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return employmentType[row]
        //return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        JobSelectEmploymentTextField.text = employmentType[row]
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
        
        label.text = employmentType[row]
        
        return label
    }
    
    
    
    func createPicker(textField: UITextField){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        textField.inputView = pickerView
        
}
   
}




   
    
    
    
    

    



