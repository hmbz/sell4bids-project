//
//  VehicleDetailsVC.swift
//  Sell4Bids
//
//  Created by admin on 12/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
protocol AddDetailsDelegate {
    func didRecievData(year: String,Make: String,Model:String,Trim:String,FuelType:String,Color:String,Miles: String)
}

class AddVehicleDetailsVC: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var trimTextField: UITextField!
    @IBOutlet weak var fuelTypeTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var milesDrivenTextField: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    
    //MARK:- Variables
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    lazy var country = ""
     var selectionDelegate: AddDetailsDelegate?
    lazy var editStatus = false
    
    //Arrays
    var YearsArray = [String]()
    var MakersArray = [String]()
    var ModelArray = [String]()
    var TrimArray = [String]()
    var FuelTypeArray = [String]()
    var ColorArray = ["Select Color","Black","Blue","Brown","Gold","Gray","Green","Orange","Purple","Red","Silver","Tan","White","Yellow","Other"]
    
    var getModelValue = String()
    var getMakeValue = String()
    var getYearValue = String()
    var getTrimValue = String()
    var getkmdDrivevalue = String()
    var getfuelTypevalue = String()
    var getColorvalue = String()
    var getMilesValue = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
        setupViews()
    
      self.ModelArray.insert("Select Model", at: 0)
       self.YearsArray.insert("Select year", at: 0)
      self.MakersArray.insert("Select Category", at: 0)
       self.TrimArray.insert("Select Type", at: 0)
       self.FuelTypeArray.insert("Select Fuel Type", at: 0)
    }
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    //MARK:- Actions
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
    }
    
    
    
    //MARK:- Private Function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Add Details"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    
    private func setupViews() {
        continueBtn.shadowView()
        getyearData(country: self.country)
        getFuelData()
        self.selectCreatePicker(textField: self.colorTextField, tag: 6)
        self.createToolBar(textField: self.colorTextField)
        if editStatus == true {
           getMakeData(year: getYearValue)
           getModelData(year: getYearValue, make: getMakeValue)
           getTrimData(year: getYearValue, make: getMakeValue, model: getModelValue)
            self.yearTextField.text = getYearValue
            self.makeTextField.text = getMakeValue
            self.modelTextField.text = getModelValue
            self.trimTextField.text = getTrimValue
            self.fuelTypeTextField.text = getfuelTypevalue
            self.colorTextField.text = getColorvalue
            self.milesDrivenTextField.text = getMilesValue
        }
        
        self.colorTextField.isUserInteractionEnabled = true
        continueBtn.addTarget(self, action: #selector(continueBtnTapped(sender:)), for: .touchUpInside)
        showDownImageOnTextField(TextField: yearTextField)
        showDownImageOnTextField(TextField: makeTextField)
        showDownImageOnTextField(TextField: modelTextField)
        showDownImageOnTextField(TextField: trimTextField)
        showDownImageOnTextField(TextField: fuelTypeTextField)
        showDownImageOnTextField(TextField: colorTextField)
        milesDrivenTextField.delegate = self
    }
    
    private func getyearData(country: String) {
         let body = [ "country": country ]
        Networking.instance.postApiCall(url: getVehicleYearUrl, param: body) { (response, Error, StatusCode) in
            guard let jsonDic = response.dictionary else {return}
            let jsonStatus = jsonDic["status"]?.bool ?? false
            if jsonStatus == true {
                let msgArray = jsonDic["message"]?.array ?? []
                for item in msgArray {
                    let data = "\(item)"
                    self.YearsArray.append(data)
                  
                    self.selectCreatePicker(textField: self.yearTextField, tag: 1)
                    self.createToolBar(textField: self.yearTextField)
                    self.yearTextField.isUserInteractionEnabled = true
                }
             
            }else {
                showSwiftMessageWithParams(theme: .info, title: "Vehicle Details", body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
            }
        }
    }
    
    func getMakeData(year: String) {
        let body = ["year" : year , "country" : self.country]
        Networking.instance.postApiCall(url: getVehicleMakeUrl, param: body) { (response, Error, StatusCode) in
            guard let jsonDic = response.dictionary else {return}
            let jsonStatus = jsonDic["status"]?.bool ?? false
            if jsonStatus == true {
                let msgArray = jsonDic["message"]?.array ?? []
                for item in msgArray {
                    let data = "\(item)"
                    self.MakersArray.append(data)
                    self.selectCreatePicker(textField: self.makeTextField, tag: 2)
                    self.createToolBar(textField: self.makeTextField)
                    self.makeTextField.isUserInteractionEnabled = true
                }
              
            }else {
                showSwiftMessageWithParams(theme: .info, title: "Vehicle Details", body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
            }
        }
    }
    func getModelData(year: String,make:String) {
        let body = ["year" : year , "make" : make , "country" : self.country]
        
        Networking.instance.postApiCall(url: getVehicleModelUrl, param: body) { (response, Error, StatusCode) in
            guard let jsonDic = response.dictionary else {return}
            let jsonStatus = jsonDic["status"]?.bool ?? false
            if jsonStatus == true {
                let msgArray = jsonDic["message"]?.array ?? []
                for item in msgArray {
                    let data = "\(item)"
                    self.ModelArray.append(data)
                    self.selectCreatePicker(textField: self.modelTextField, tag: 3)
                    self.createToolBar(textField: self.modelTextField)
                    self.modelTextField.isUserInteractionEnabled = true
                }
              
            }else {
                showSwiftMessageWithParams(theme: .info, title: "Vehicle Details", body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
            }
        }
    }
    
    func getTrimData(year: String,make:String,model:String) {
        let body = [ "year" : year , "make" : make , "model" : model , "country" : self.country]
        Networking.instance.postApiCall(url: getVehicleTrimUrl, param: body) { (response, Error, StatusCode) in
            guard let jsonDic = response.dictionary else {return}
            let jsonStatus = jsonDic["status"]?.bool ?? false
            if jsonStatus == true {
                let msgArray = jsonDic["message"]?.array ?? []
                for item in msgArray {
                    let data = "\(item)"
                    self.TrimArray.append(data)
                    self.selectCreatePicker(textField: self.trimTextField, tag: 4)
                    self.createToolBar(textField: self.trimTextField)
                    self.trimTextField.isUserInteractionEnabled = true
                }
             
            }else {
                showSwiftMessageWithParams(theme: .info, title: "Vehicle Details", body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
            }
        }
    }
    
    func getFuelData() {
        Networking.instance.getApiCall(url: getVehicleFuelTypeUrl) { (response, Error, StatusCode) in
            print(response)
            guard let jsonDic = response.dictionary else {return}
            let jsonStatus = jsonDic["status"]?.bool ?? false
            if jsonStatus == true {
                let msgArray = jsonDic["message"]?.array ?? []
                for item in msgArray {
                    guard let dataDic = item.dictionary else {return}
                    let title = dataDic["title"]?.string ?? ""
                    self.FuelTypeArray.append(title)
                    self.selectCreatePicker(textField: self.fuelTypeTextField, tag: 5)
                    self.createToolBar(textField: self.fuelTypeTextField)
                    self.fuelTypeTextField.isUserInteractionEnabled = true
                }
             
            }else {
                showSwiftMessageWithParams(theme: .info, title: "Vehicle Details", body: "StrTechnicalIssue".localizableString(loc: LanguageChangeCode))
            }
        }
    }
    
    @objc func continueBtnTapped(sender: UIButton) {
        if yearTextField.text!.isEmpty || yearTextField.text! == "Select year" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please Select manufacture Year")
        }else if makeTextField.text!.isEmpty || makeTextField.text! == "Select Category" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please Select Make")
        }else if modelTextField.text!.isEmpty || modelTextField.text! == "Select Model" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please Select Model")
        }else if trimTextField.text!.isEmpty ||  trimTextField.text! == "Select Type" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please Select Trim")
        }else if fuelTypeTextField.text!.isEmpty || fuelTypeTextField.text! == "Select Fuel Type" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please Select Fuel Type.")
        }else if colorTextField.text!.isEmpty || colorTextField.text! == "SelectColor" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please Select Color.")
        }else if milesDrivenTextField.text!.isEmpty{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "Please Enter Miles Driven")
        }else {
            selectionDelegate?.didRecievData(year: getYearValue, Make: getMakeValue, Model: getModelValue, Trim: getTrimValue, FuelType: getfuelTypevalue, Color: getColorvalue, Miles: milesDrivenTextField.text!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
//MARK:-  UIPickerViewDelegate, UIPickerViewDataSource
extension AddVehicleDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return YearsArray.count
        }else if (pickerView.tag == 2){
            return MakersArray.count
        }else if (pickerView.tag == 3){
            return ModelArray.count
        }else if (pickerView.tag == 4){
            return TrimArray.count
        }else if (pickerView.tag == 5){
            return FuelTypeArray.count
        }else{
            return ColorArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            return YearsArray[row]
        }else if (pickerView.tag == 2){
            return MakersArray[row]
        }else if (pickerView.tag == 3){
            return ModelArray[row]
        }else if (pickerView.tag == 4) {
            return TrimArray[row]
        }else if (pickerView.tag == 5){
            return FuelTypeArray[row]
        }else{
            return ColorArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            yearTextField.text = YearsArray[row]
            getYearValue = YearsArray[row]
            getMakeData(year: getYearValue)
          UserDefaults.standard.set(yearTextField.text, forKey: "year")
        }
        else if pickerView.tag == 2 {
            makeTextField.text = MakersArray[row]
            getMakeValue = MakersArray[row]
            getModelData(year: getYearValue, make: getMakeValue)
           UserDefaults.standard.set(makeTextField.text, forKey: "maker")
        }
        else if pickerView.tag == 3 {
            modelTextField.text = ModelArray[row]
            getModelValue = ModelArray[row]
            getTrimData(year: getYearValue, make: getMakeValue, model: getModelValue)
           UserDefaults.standard.set(modelTextField.text , forKey: "model")
        }
        else if pickerView.tag == 4 {
            trimTextField.text = TrimArray[row]
            getTrimValue = TrimArray[row]
          UserDefaults.standard.set(trimTextField.text , forKey: "trim")
        }
        else if pickerView.tag == 5 {
            fuelTypeTextField.text = FuelTypeArray[row]
            getfuelTypevalue = FuelTypeArray[row]
          UserDefaults.standard.set(fuelTypeTextField.text , forKey: "fuel")
        }
        else if pickerView.tag == 6 {
            colorTextField.text = ColorArray[row]
            getColorvalue = ColorArray[row]
          UserDefaults.standard.set(colorTextField.text , forKey: "color")
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
            label.text = YearsArray[row]
        }else if (pickerView.tag == 2){
            label.text = MakersArray[row]
        }else if (pickerView.tag == 3){
            label.text = ModelArray[row]
        }else if (pickerView.tag == 4){
            label.text = TrimArray[row]
        }else if (pickerView.tag == 5){
            label.text = FuelTypeArray[row]
        }else{
            label.text = ColorArray[row]
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
     
     @objc func handleDone(){
        self.view.endEditing(true)
     }
    
}

extension AddVehicleDetailsVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      if textField == milesDrivenTextField {
                  let allowedCharacters = "1234567890"
                  let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                  let typedCharacterSet = CharacterSet(charactersIn: string)
                  let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
                  return alphabet
        } else {
          return false
      }
    }
}
