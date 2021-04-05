//
//  CarDetailsVC.swift
//  Sell4Bids
//
//  Created by admin on 2/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit



class CarDetailsVC: UIViewController{
    
    var CountView = 0
    var mainApi = MainSell4BidsApi()
    var Years = [String]()
    var MakersArr = [String]()
    var ModelDict = [String]()
    var TrimArray = [String]()
    var FuelTypeArray = [String]()
    var ColorArray = ["Black","Blue","Brown","Gold","Gray","Green","Orange","Purple","Red","Silver","Tan","White","Yellow","Other"]
    var getModelValue = String()
    var getMakeValue = String()
    var getYearValue = String()
    var getTrimValue = String()
    var getkmdDrivevalue = String()
    var getfuelTypevalue = String()
    var getColorvalue = String()
    
    let appColor = UIColor(red: 0.76, green: 0.25, blue: 0.18 , alpha: 1.0)
    var Vehicles_Data : VehiclesModel?
    var delegate : CarDetailsVCDelegate?
    @IBOutlet weak var Make: UITextField!
    @IBOutlet weak var Model: UITextField!
    @IBOutlet weak var Year: UITextField!
    @IBOutlet weak var kmdDrive: UITextField!
    @IBOutlet weak var fuelType: UITextField!
    @IBOutlet weak var color: UITextField!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var ContinueBtn: UIButton!
    @IBOutlet weak var trim: UITextField!
    @IBOutlet weak var navigation: UINavigationBar!
    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var Errorimg: UIImageView!
    
    var country = String()
    var viewCarDetailStack = UIView()
    var VehiclesDetailsStackView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation.barTintColor = UIColor.black
        navigation.addShadowAndRound()
//        TextFieldStyle()
        view1.cardViewBorder()
        ContinueBtn.addShadowAndRound()
        color.keyboardType = UIKeyboardType.alphabet
        kmdDrive.keyboardType = UIKeyboardType.decimalPad
        selectCreatePicker(textField: Make, tag: 1)
        createToolBar(textField: Make)
        
        selectCreatePicker(textField: Model, tag: 2)
        createToolBar(textField: Model)
        
        selectCreatePicker(textField: Year, tag: 3)
        createToolBar(textField: Year)
        
        selectCreatePicker(textField: trim, tag: 4)
        createToolBar(textField: trim)
        
        selectCreatePicker(textField: fuelType, tag: 5)
        createToolBar(textField: fuelType)
        
        selectCreatePicker(textField: color, tag: 7)
        createToolBar(textField: color)
        
        Make.delegate = self
//        Make.makeCornersRound()
        Model.delegate = self
//        Model.makeCornersRound()
        Year.delegate = self
//        Year.makeCornersRound()
        
        trim.delegate = self
//        trim.makeCornersRound()
        fuelType.delegate = self
//        fuelType.makeCornersRound()
        color.delegate = self
//        color.makeCornersRound()
        kmdDrive.delegate = self
        
        self.fidgetImageView.toggleRotateAndDisplayGif()
        Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
        print("country ==\(country)")
        mainApi.Get_years_Api(country: country){ (status, data, error) in
            
            if status == true {
                
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                let message = data!["message"]
                if message.count > 0 {
                    for msg in message {
                        self.Years.append(msg.1.stringValue)
                        print("message \(msg.1.stringValue)")
                    }
                }
                
                print("status == \(status)")
                print("data == \(data)")
                print("error == \(error)")
                
                
            }
                
            else{
                
                if error.contains("The network connection was lost"){
                    
                    let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                    alert.addAction(ok)
                    
                    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
                if error.contains("The Internet connection appears to be offline.") {
                    
                    let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                    alert.addAction(ok)
                    
                    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                if error.contains("A server with the specified hostname could not be found."){
                    
                    let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                    alert.addAction(ok)
                    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                if error.contains("The request timed out.") {
                    
                    let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                    alert.addAction(ok)
                    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            self.Year.reloadInputViews()
            
        }
        
        
        mainApi.Get_FuelType_Api{ (status, data, error) in
            
            if status == true {
                
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                let message = data!["message"]
                
                if message.count > 0 {
                    for msg in message{
                        
                        self.FuelTypeArray.append(msg.1["title"].stringValue)
                        print("message.title \(msg.1.stringValue)")
                    }
                }
                
                print("status == \(status)")
                print("data == \(data)")
                print("error == \(error)")
                
                
            }
                
            else{
                
                if error.contains("The network connection was lost"){
                    
                    let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                    alert.addAction(ok)
                    
                    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
                if error.contains("The Internet connection appears to be offline.") {
                    
                    let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                    alert.addAction(ok)
                    
                    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                if error.contains("A server with the specified hostname could not be found."){
                    
                    let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                    alert.addAction(ok)
                    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                if error.contains("The request timed out.") {
                    
                    let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                    let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                    alert.addAction(ok)
                    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            self.Year.reloadInputViews()
            
        }
        
        //                let Miles_Driven = kmdDrive.text!.split(separator: "$")
        //                let Final_Miles_Driven : String = String(Miles_Driven[0])
        //                let GrandFinal_Miles_Driven : Int = Int(Final_Miles_Driven)!
        
    }
    
    
    @IBAction func continueBtnAction(_ sender: Any) {
        
        if CountView == 0{
            if (Year.text?.isEmpty)!  {
                
                print("Year_TextFieldWorking === 1")
                
                _ = SweetAlert().showAlert("Add Year", subTitle:"  Please add a Year " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                CountView = 0
                return
            }
                
            else if (Make.text?.isEmpty)! {
                
                print("Make_TextFieldWorking === 1")
                
                _ = SweetAlert().showAlert("Add Make", subTitle:"  Please add a Maker " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                Model.isEnabled = false
                
                CountView = 0
                return
            }
                
            else if (Model.text?.isEmpty)! {
                
                print("Model_TextFieldWorking === 1")
                
                _ = SweetAlert().showAlert("Add Model", subTitle:"  Please add a Model " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                CountView = 0
                return
            }
            else if (trim.text?.isEmpty)! {
                
                print("Model_TextFieldWorking === 1")
                
                _ = SweetAlert().showAlert("Add Trim", subTitle:"  Please add a Trim " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                CountView = 0
                return
            }
                
            else if (kmdDrive.text?.isEmpty)! {
                
                print("kmdDrive_TextFieldWorking === 1")
                
                _ = SweetAlert().showAlert("Add kmdDrive", subTitle:"  Please add a kmdDrive " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                CountView = 0
                return
            }
                
            else if (fuelType.text?.isEmpty)! {
                
                print("FuelType_TextFieldWorking === 1")
                
                
                _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"  Please select related condition. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                CountView = 0
                return
            }
            else if (color.text?.isEmpty)! {
                
                print("color_TextFieldWorking === 1")
                
                
                _ = SweetAlert().showAlert("Add color", subTitle:"  Please add a color " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                CountView = 0
                return
            }
            else if Year.text != nil && Make.text != nil && Model.text != nil && trim.text != nil && kmdDrive.text != nil && fuelType.text != nil && color.text != nil {
                
                delegate?.CarDetailsVCTapped(getModelValue: Model.text!, getMakeValue: Make.text!, getYearValue: Year.text!, getTrimValue: trim.text!, getkmdDrivevalue: kmdDrive.text!, getfuelTypevalue: fuelType.text!, getColorvalue: color.text!)
            }
        }
        VehiclesDetailsStackView.isHidden = false
        viewCarDetailStack.isHidden = false
        dismiss(animated: true, completion: nil)
        
    }
    
    func hideCollectionView(hideYesNo : Bool) {
        
        emptyMessage.text = "No Data Found"
        if hideYesNo == false {
            
            fidgetImageView.isHidden = true
            fidgetImageView.image = nil
            emptyMessage.isHidden = true
            Errorimg.isHidden = true
            
        }
        else  {
            fidgetImageView.isHidden = true
            fidgetImageView.image = nil
            
            
            emptyMessage.isHidden = false
            Errorimg.isHidden = false
        }
    }
    
    
    func TextFieldStyle(){
        Make.makeCornersRound()
        Make.layer.borderColor = UIColor.black.cgColor
        Make.layer.borderWidth = 2.0
        
        Model.makeCornersRound()
        Model.layer.borderColor = UIColor.black.cgColor
        Model.layer.borderWidth = 2.0
        
        Year.makeCornersRound()
        Year.layer.borderColor = UIColor.black.cgColor
        Year.layer.borderWidth = 2.0
        
        trim.makeRedAndRound()
        trim.layer.borderColor = UIColor.black.cgColor
        trim.layer.borderWidth = 2.0
        
        kmdDrive.makeCornersRound()
        kmdDrive.layer.borderColor = UIColor.black.cgColor
        kmdDrive.layer.borderWidth = 2.0
        
        fuelType.makeCornersRound()
        fuelType.layer.borderColor = UIColor.black.cgColor
        fuelType.layer.borderWidth = 2.0
        
        color.makeCornersRound()
        color.layer.borderColor = UIColor.black.cgColor
        color.layer.borderWidth = 2.0
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}




//MARK:- UITextFieldDelegate
extension CarDetailsVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == Make{
            
            if textField.isFirstResponder{
                textField.resignFirstResponder()
                return true
            }
        }
        
        return true
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = ""
        return true
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var groupSize = 2
        let separator = ","
        if string.characters.count == 0 {
            groupSize = 4
        }
        let formatter = NumberFormatter()
        formatter.groupingSeparator = separator
        formatter.groupingSize = groupSize
        formatter.usesGroupingSeparator = true
        formatter.secondaryGroupingSize = 3
        if var number = textField.text, string != "" {
            number = number.replacingOccurrences(of: separator, with: "")
            if let doubleVal = Double(number) {
                let requiredString = formatter.string(from: NSNumber.init(value: doubleVal))
                textField.text = requiredString
            }
            
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
        Make.endEditing(true)
        Model.endEditing(true)
        Year.endEditing(true)
        trim.endEditing(true)
        kmdDrive.endEditing(true)
        fuelType.endEditing(true)
        color.endEditing(true)
    }
}

//MARK:-  UIPickerViewDelegate, UIPickerViewDataSource
extension CarDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return MakersArr.count
        }else if (pickerView.tag == 2){
            return ModelDict.count
        }else if (pickerView.tag == 3){
            return Years.count
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
            return MakersArr[row]
        }else if (pickerView.tag == 2){
            return ModelDict[row]
        }else if (pickerView.tag == 3){
            return Years[row]
        }else if (pickerView.tag == 4) {
            return TrimArray[row]
        }else if (pickerView.tag == 5){
            return FuelTypeArray[row]
        }else if (pickerView.tag == 7){
            return ColorArray[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1)
        {
            Make.text = MakersArr[row]
            getMakeValue = Make.text!
            print("DidSelectGetMake == \(getMakeValue)")
            
            self.fidgetImageView.toggleRotateAndDisplayGif()
            Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
            
            mainApi.Get_Model_Api(year: "\(self.getYearValue)" , make: "\(self.getMakeValue)", country: country) { (status, data, error) in
                
                print("getYearValue(GetModelValue) == \(self.getYearValue)")
                print("getMakeValue(GetModelValue) == \(self.getMakeValue)")
                if status == true{
                    
                    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                    self.ModelDict.removeAll()
                    
                    let message = data!["message"]
                    if message.count > 0 {
                        for msg in message {
                            self.ModelDict.append(msg.1.stringValue)
                            print("message \(msg.1.stringValue)")
                        }
                        
                    }else {
                        print("empty ")
                    }
                    
                    print("status == \(status)")
                    print("data == \(data)")
                    print("error == \(error)")
                }
                else{
                    
                    if error.contains("The network connection was lost"){
                        
                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                        alert.addAction(ok)
                        
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                    if error.contains("The Internet connection appears to be offline.") {
                        
                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                        alert.addAction(ok)
                        
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    if error.contains("A server with the specified hostname could not be found."){
                        
                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                        alert.addAction(ok)
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    if error.contains("The request timed out.") {
                        
                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                        alert.addAction(ok)
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                self.Model.reloadInputViews()
            }
            
        }
            
        else if (pickerView.tag == 2){
            Model.text = ModelDict[row]
            getModelValue = Model.text!
            print("DidSelectGetModel == \(getModelValue)")
            
            self.fidgetImageView.toggleRotateAndDisplayGif()
            Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
            
            mainApi.Get_Trim_Api(year: "\(self.getYearValue)" , make: "\(self.getMakeValue)", model: "\(self.getModelValue)", country: country){ (status, data, error) in
                
                print("getYearValue == \(self.getYearValue)")
                print("getYearValue == \(self.getMakeValue)")
                print("getYearValue == \(self.getModelValue)")
                
                if status == true{
                    
                    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                    self.TrimArray.removeAll()
                    let message = data!["message"]
                    if message.count > 0 {
                        for msg in message {
                            self.TrimArray.append(msg.1.stringValue)
                            print("message \(msg.1.stringValue)")
                        }
                        
                    }else {
                        print("empty ")
                    }
                    
                    print("status == \(status)")
                    print("data == \(data)")
                    print("error == \(error)")
                }
                else{
                    
                    if error.contains("The network connection was lost"){
                        
                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                        alert.addAction(ok)
                        
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                    if error.contains("The Internet connection appears to be offline.") {
                        
                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                        alert.addAction(ok)
                        
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    if error.contains("A server with the specified hostname could not be found."){
                        
                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                        alert.addAction(ok)
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    if error.contains("The request timed out.") {
                        
                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                        alert.addAction(ok)
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                self.trim.reloadInputViews()
            }
        }
            
        else if (pickerView.tag == 3){
            Year.text = Years[row]
            getYearValue = Year.text!
            print("DidSelectGetYear == \(getYearValue)")
            
            self.fidgetImageView.toggleRotateAndDisplayGif()
            Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
            
            mainApi.Get_Make_Api(year: "\(self.getYearValue)", country: country) { (status, data, error) in
                print("getYearValue(GetMakeValue) == \(self.getYearValue)")
                if status == true{
                    self.MakersArr.removeAll()
                    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                    
                    let message = data!["message"]
                    if message.count > 0 {
                        for msg in message {
                            self.MakersArr.append(msg.1.stringValue)
                            print("message \(msg.1.stringValue)")
                        }
                        
                    }else {
                        print("empty ")
                    }
                    
                    print("status == \(status)")
                    print("data == \(data)")
                    print("error == \(error)")
                }
                else{
                    
                    if error.contains("The network connection was lost"){
                        
                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                        alert.addAction(ok)
                        
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                    if error.contains("The Internet connection appears to be offline.") {
                        
                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                        alert.addAction(ok)
                        
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    if error.contains("A server with the specified hostname could not be found."){
                        
                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                        alert.addAction(ok)
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    if error.contains("The request timed out.") {
                        
                        let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                        let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                        alert.addAction(ok)
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                
                self.Make.reloadInputViews()
            }
        }
            
            
        else if (pickerView.tag == 4){
            trim.text = TrimArray[row]
            getTrimValue = trim.text!
        }
        else if (pickerView.tag == 5){
            fuelType.text = FuelTypeArray[row]
            getfuelTypevalue = fuelType.text!
        }else if (pickerView.tag == 7){
            color.text = ColorArray[row]
            getColorvalue = color.text!
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
        if (pickerView.tag == 1) {
            label.text = MakersArr[row]
        }else if (pickerView.tag == 2){
            label.text = ModelDict[row]
        }else if (pickerView.tag == 3){
            label.text = Years[row]
        }else if (pickerView.tag == 4){
            label.text = TrimArray[row]
        }else if (pickerView.tag == 5){
            label.text = FuelTypeArray[row]
        }else if (pickerView.tag == 7){
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
    
}


