//
//  JobListingStepOneVC.swift
//  Sell4Bids
//
//  Created by admin on 12/5/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class JobListingStepOneVC: UIViewController {

    //MARK:- Outlets and Properties
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var titleBorderLineLbl: UILabel!
    @IBOutlet weak var emplymentTypeTextField: UITextField!
    @IBOutlet weak var emplymentTypeBorderLineLbl: UILabel!
    @IBOutlet weak var medicleSwicth: UISwitch!
    @IBOutlet weak var PTOSwitch: UISwitch!
    @IBOutlet weak var KSwitch: UISwitch!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK:- Variable and Constent
    var employmentType = ["Select Category","Contract Hire","Employee's Choice", "Full-Time","Internship","Temporary"]
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    lazy var medical = ""
    lazy var PTO = ""
    lazy var fzok = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        topMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barTintColor = UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    //MARK:- Actions
    // performing back button functionality
      @objc func backbtnTapped(sender: UIButton){
          print("Back button tapped")
          self.navigationController?.popViewController(animated: true)
      }
      // going back directly towards the home
      @objc func homeBtnTapped(sender: UIButton) {
          print("Home Button Tapped")
      }
    
    @objc func medicalSwitchTapped(sender: UISwitch){
        if sender.isOn == true{
            medical = "Medical"
        }else {
            medical = ""
        }
    }
    
    @objc func ptoSwitchTapped(sender: UISwitch){
        if sender.isOn == true{
            PTO = "PTO"
        }else {
            PTO = ""
        }
    }
    
    @objc func fzokSwitchTapped(sender: UISwitch){
        if sender.isOn == true{
            fzok = "401(K)"
        }else {
            fzok = ""
        }
    }
    
    @objc func nextBtnTapped(sender: UIButton){
        if TitleTextField.text!.isEmpty && TitleTextField.text!.count < 3{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strEmptyTitleTextField".localizableString(loc: LanguageChangeCode))
            TitleTextField.becomeFirstResponder()
        }else if emplymentTypeTextField.text!.isEmpty || emplymentTypeTextField.text! == "Select Category" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please select Emplyment Type")
            emplymentTypeTextField.becomeFirstResponder()
        }else {
            let SB = UIStoryboard(name: "Listing", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "JobListingStepTwoVC") as! JobListingStepTwoVC
            vc.paramDic.updateValue(TitleTextField.text!, forKey: "title")
            vc.paramDic.updateValue(self.medical, forKey: "Medical")
            vc.paramDic.updateValue(self.PTO, forKey: "PTO")
            vc.paramDic.updateValue(self.fzok, forKey: "FZOK")
            vc.paramDic.updateValue(emplymentTypeTextField.text!, forKey: "employmentType")
            UserDefaults.standard.set(vc.paramDic, forKey: "jobTitleDic")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Functions
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Title"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    private func setupViews() {
        self.tabBarController?.tabBar.isHidden = true
        
        let SessionDic = UserDefaults.standard.dictionary(forKey: "jobTitleDic")
        if SessionDic != nil {
            TitleTextField.text = "\(SessionDic?["title"] ?? "")"
            emplymentTypeTextField.text = "\(SessionDic?["employmentType"] ?? "")"
            medical = "\(SessionDic?["Medical"] ?? "")"
            if medical != "" {
              medicleSwicth.isOn = true
            }else {
              medicleSwicth.isOn = false
            }
            
            PTO = "\(SessionDic?["PTO"] ?? "")"
            if PTO != "" {
                PTOSwitch.isOn = true
            }else {
                PTOSwitch.isOn = false
            }
            
            fzok = "\(SessionDic?["FZOK"] ?? "")"
            if fzok != "" {
                KSwitch.isOn = true
            }else {
                KSwitch.isOn = false
            }
        }
        
        nextBtn.shadowView()
        nextBtn.addTarget(self, action: #selector(nextBtnTapped(sender:)), for: .touchUpInside)
        selectCreatePicker(textField: emplymentTypeTextField, tag: 1)
        createToolBar(textField: emplymentTypeTextField)
        medicleSwicth.addTarget(self, action: #selector(medicalSwitchTapped(sender:)), for: .valueChanged)
        PTOSwitch.addTarget(self, action: #selector(ptoSwitchTapped(sender:)), for: .valueChanged)
        KSwitch.addTarget(self, action: #selector(fzokSwitchTapped(sender:)), for: .valueChanged)
    }

}
extension JobListingStepOneVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == TitleTextField {
            titleBorderLineLbl.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }else {
            emplymentTypeBorderLineLbl.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == TitleTextField {
            titleBorderLineLbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else {
            emplymentTypeBorderLineLbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}
extension JobListingStepOneVC: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return employmentType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return employmentType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        emplymentTypeTextField.text! = employmentType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label : UILabel
        if let view = view as? UILabel{
            label = view
        }else{
            label = UILabel()
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.text = employmentType[row]
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
        emplymentTypeTextField.endEditing(true)
    }
}
