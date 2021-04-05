//
//  CarDetailsAutoVC.swift
//  Sell4Bids
//
//  Created by admin on 2/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CarDetailsAutoVC: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource, UITextFieldDelegate {
    
    var delegate: CarDetailsAutoVCDelegate?
    var getModelValue = String()
    var getMakeValue = String()
    var getYearValue = String()
    var getTrimValue = String()
    var getkmdDrivevalue = String()
    var getfuelTypevalue = String()
    var getColorvalue = String()
    
    var MakersArr = ["Honda", "Toyota", "Audi", "Mclaren", "Hyndai"]
    var ModelDict = ["Honda":["Accord","Amaze","Avancier","Ballade","Brio"],"Toyota":["Century","Crown","Camry","MIRAI","Mark X","Allion"]]
    var ModelArr = [String]()
    var Years = (1990...2019).map{String($0)}
    var CountView = 0
    var MakePickerView = UIPickerView()
    var ModelPickerView = UIPickerView()
    var YearPickerView = UIPickerView()
    var fuelTypePickerView = UIPickerView()
    var colorPickerView = UIPickerView()
    
    let appColor = UIColor(red: 0.76, green: 0.25, blue: 0.18 , alpha: 1.0)
    
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
    // Variables:
    var VinNumber = String()
    var viewCarDetailStack = UIView()
    var VehiclesDetailsStackView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigation.barTintColor = UIColor.black
        navigation.addShadowAndRound()
        getVehicleData()
        fidgetImageView.toggleRotateAndDisplayGif()
        TextFieldStyle()
        fuelType.keyboardType = UIKeyboardType.alphabet
        color.keyboardType = UIKeyboardType.alphabet
        kmdDrive.keyboardType = UIKeyboardType.decimalPad
        MakePickerView.delegate = self
        ModelPickerView.delegate = self
        YearPickerView.delegate = self
        fuelTypePickerView.delegate = self
        colorPickerView.delegate = self
        kmdDrive.delegate = self
        
        Model.inputView = ModelPickerView
        Make.inputView = MakePickerView
        Year.inputView = YearPickerView
        view1.cardViewBorder()
        ContinueBtn.addShadowAndRound()
        
        if trim.text == ""{
            getTrimValue = trim.text!
            
        }
        if kmdDrive.text == ""{
            getkmdDrivevalue = kmdDrive.text!
            
        }
        if fuelType.text == ""{
            getfuelTypevalue = fuelType.text!
        }
        if color.text == ""{
            getColorvalue = color.text!
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        
        if CountView == 0{
           
            if (Year.text?.isEmpty)! {
                
                print("Year_TextFieldWorking === 1")
                
                showSwiftMessageWithParams(theme: .error, title: "Add Year", body: "Please add a Year")
                CountView = 0
                return
            }
            
            else if (Make.text?.isEmpty)! {
                
                print("Make_TextFieldWorking === 1")
                showSwiftMessageWithParams(theme: .error, title: "Add Make", body: "Please add a Maker")
                CountView = 0
                return
            }
                
            else if (Model.text?.isEmpty)! {
                
                print("Model_TextFieldWorking === 1")
                showSwiftMessageWithParams(theme: .error, title: "Add Model", body: "Please add a Model")
                CountView = 0
                return
            }
                
           
            else if (trim.text?.isEmpty)! {
                
                print("Model_TextFieldWorking === 1")
                showSwiftMessageWithParams(theme: .error, title: "Add Trim", body: "Please add a Trim")
                CountView = 0
                return
            }
                
            else if (kmdDrive.text?.isEmpty)! {
                
                print("kmdDrive_TextFieldWorking === 1")
                
                showSwiftMessageWithParams(theme: .error, title: "Add kmdDrive", body: "Please add a kmdDrive")
                CountView = 0
                return
            }
            else if (fuelType.text?.isEmpty)! {
                
                print("FuelType_TextFieldWorking === 1")
                
                showSwiftMessageWithParams(theme: .error, title: "Add FuelType", body: "Please add a FuelType")
                CountView = 0
                return
            }
            else if (color.text?.isEmpty)! {
                
                print("color_TextFieldWorking === 1")
                
                showSwiftMessageWithParams(theme: .error, title: "Add color", body: "Please add a color")
                CountView = 0
                return
            }
            else if Year.text != nil && Make.text != nil && Model.text != nil && trim.text != nil && kmdDrive.text != nil && fuelType.text != nil && color.text != nil {
                
                delegate?.CarDetailsAutoVCTapped(getModelValue: Model.text!, getMakeValue: Make.text!, getYearValue: Year.text!, getTrimValue: trim.text!, getkmdDrivevalue: kmdDrive.text!, getfuelTypevalue: fuelType.text!, getColorvalue: color.text!)
            }
        }
        VehiclesDetailsStackView.isHidden = false
        viewCarDetailStack.isHidden = false
        dismiss(animated: true, completion: nil)

        
    }
    
      func getVehicleData(){
        
        self.fidgetImageView.toggleRotateAndDisplayGif()
        Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
        
        let value = GlocalVINNO?.split(separator: "I")
        DispatchQueue.main.async {
            self.VinNumber =  String((value?[0] ?? ""))
    
            let url = "http://api.marketcheck.com/v1/vin/\(value?[0] ?? " " )/specs?api_key=7RlHupav8leC7Y4TsGdMJyixbTAkylLS"
            
            
            let header = ["Host": "marketcheck-prod.apigee.net"] as! HTTPHeaders
            Alamofire.request(url, method: .get , encoding: JSONEncoding.default , headers : header).responseJSON { (request) in
                
                switch(request.result) {
                    
                    
                case .success(_):
                    
                    Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                    
                    let swiftymessage = JSON(request.result.value)
                    
                    print("Value = \(swiftymessage)")
                    
                    self.Make.text = swiftymessage["make"].stringValue
                    self.Model.text = swiftymessage["model"].stringValue
                    self.kmdDrive.text = swiftymessage["millage"].stringValue
                    self.Year.text = swiftymessage["year"].stringValue
                    self.fuelType.text = swiftymessage["fuel_type"].stringValue
                    self.color.text = swiftymessage["color"].stringValue
                    
                    
                case .failure(let error):
                    print("Error = \(error)")
                    
                }
                
                
            }
            
        }
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
    
    
    func SelectModel(MakeS:String){
        ModelArr.removeAll()
        for item in ModelDict{
            if item.key == MakeS{
                ModelArr = item.value
                Model.text = ModelArr[0]
                break
            }else{
                ModelArr = [""]
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == MakePickerView{
            return MakersArr.count
        }else if pickerView == ModelPickerView{
            return ModelArr.count
        }else if pickerView == YearPickerView{
            return Years.count
        }
        else{
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == MakePickerView{
            return MakersArr[row]
        }else if pickerView == ModelPickerView{
            return ModelArr[row]
        }else if pickerView == YearPickerView{
            return Years[row]
        }
        else{
            return "0"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == MakePickerView{
            Make.text = MakersArr[row]
            SelectModel(MakeS: MakersArr[row])
            getModelValue = Make.text!
        }else if pickerView == ModelPickerView{
            Model.text = ModelArr[row]
            getModelValue = Model.text!
        }else if pickerView == YearPickerView{
            Year.text = Years[row]
            getYearValue = Year.text!
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
        
        trim.makeCornersRound()
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
}
