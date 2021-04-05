//
//  HousingListingStepTwoVC.swift
//  Sell4Bids
//
//  Created by admin on 12/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

struct openHouseModel {
    var date: String
    var isSelected: Bool
    var timeStamp: Double
}

class HousingListingStepTwoVC: UIViewController , UITextViewDelegate{
    
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
    // View Heights
    @IBOutlet weak var realEstateHeight: NSLayoutConstraint!
    @IBOutlet weak var bedroomViewHeights: NSLayoutConstraint!
    @IBOutlet weak var bathroomViewHeights: NSLayoutConstraint!
    @IBOutlet weak var laundryViewHeights: NSLayoutConstraint!
    @IBOutlet weak var parkingViewHeights: NSLayoutConstraint!
    @IBOutlet weak var descriptionViewHeighs: NSLayoutConstraint!
    @IBOutlet weak var squareFeetViewHeights: NSLayoutConstraint!
    @IBOutlet weak var availbleOnViewHeight: NSLayoutConstraint!
    @IBOutlet weak var openHouseViewHeights: NSLayoutConstraint!
    @IBOutlet weak var additionalChoiceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var realEstateView: UIView!
    @IBOutlet weak var bedroomsView: UIView!
    @IBOutlet weak var bathroomsView: UIView!
    @IBOutlet weak var laundryView: UIView!
    @IBOutlet weak var parkingView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var squareFeetView: UIView!
    @IBOutlet weak var availbleOnView: UIView!
    @IBOutlet weak var openHouseView: UIView!
    @IBOutlet weak var additionalChoiceView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var openHouseSelectionView: UIView!
    @IBOutlet weak var openHouseTableView: UITableView!
    @IBOutlet weak var openHouseSaveBtn: UIButton!
    @IBOutlet weak var crossBtn: UIButton!
    
    
    
    //MARK:- Variables
    lazy var categoryName = ""
    lazy var bedroomArray = ["Select Number Of rooms","0", "1", "2", "3", "4", "5", "6", "7", "8"]
    lazy var bathroomArray = ["Select Number Of Baths","0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8+"]
    lazy var laundryArray = ["Select Laundry Type","W/D in unit", "W/D hookups", "Laundry in bldg", "Laundry on Site", "No laundry on site"]
    lazy var parkingArray = ["Select Parking Type","Carport", "Attached garage", "Detached garage", "Off-street parking", "Street parking", "Valet parking", "No parking"]
    lazy var realEstateArray = ["Select Category","Apartment","House","Cottage/Cabin","Duplex","Flat","Condo","In-law Suite","Loft","Townhouse","Manufacture","Assisted living","Land"]
    
    lazy var openHouseDateArray = [openHouseModel]()
    lazy var selectedOpenHouseArray = [String]()
    
    lazy var petsSelectionStatus = false
    lazy var furnishedSelectionStatus = false
    lazy var noSmokingSelectionStatus = false
    lazy var wheelChairSelectionStatus = false
    
    lazy var imageArray = [UIImage]()
    lazy var paramDic = [String:Any]()
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    lazy var availableTimeStamp:Double = 0
    lazy var openHouseTimeStamp : Array<Double> = [0]
    
    let datePicker = UIDatePicker()
    
    //MARK:- View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        topMenu()
        setupViewsHeight()
        showDatePicker()
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    
    //MARK:- Actions
    
    @objc func nextBtnTapped(sender: UIButton){
        print(openHouseTimeStamp)
        if categoryName == "Rooms & Shared" || categoryName == "Sublets & Temporary"{
            if realEstateTextField.text!.isEmpty || realEstateTextField.text == "Select Category"{
              showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strRealEstateSelection".localizableString(loc: LanguageChangeCode))
                realEstateTextField.becomeFirstResponder()
            }
            else if bedroomsTextField.text!.isEmpty || bedroomsTextField.text! == "Select Number Of rooms" || bedroomsTextField.text! == "Slect Type"{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strBedRoomsSelection".localizableString(loc: LanguageChangeCode))
                bedroomsTextField.becomeFirstResponder()
            }
            else if bathroomTextField.text!.isEmpty || bathroomTextField.text == "Select Number Of Baths" || bathroomTextField.text! ==  "Select Type"{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strBathroomsSelection".localizableString(loc: LanguageChangeCode))
                bathroomTextField.becomeFirstResponder()
            }
            else if laundryTextField.text!.isEmpty ||  laundryTextField.text! == "Select Laundry Type"{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strLaundrySelection".localizableString(loc: LanguageChangeCode))
                laundryTextField.becomeFirstResponder()
            }
            else if parkingTextField.text!.isEmpty ||  parkingTextField.text! == "Select Parking Type"{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strParkingSelection".localizableString(loc: LanguageChangeCode))
                parkingTextField.becomeFirstResponder()
            }
            else if descriptionTextView.text!.isEmpty || descriptionTextView.text!.count < 20 {
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: strDescriptionValidation)
                descriptionTextView.becomeFirstResponder()
            }
            else if squareFeetTextField.text!.isEmpty || squareFeetTextField.text!.count < 1 {
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strSquareFeetValidation".localizableString(loc: LanguageChangeCode))
                squareFeetTextField.becomeFirstResponder()
            }
            else if availableDateTextField.text!.isEmpty{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strAvailableOnDateSelection".localizableString(loc: LanguageChangeCode))
                descriptionTextView.becomeFirstResponder()
            }else {
               // Send Functionality
                let SB = UIStoryboard(name: "Listing", bundle: nil)
                let vc = SB.instantiateViewController(withIdentifier: "ItemListingLocationVC") as! ItemListingLocationVC
                vc.controllerName = "housing"
                //Session Update
                vc.imageArray = self.imageArray
                vc.housingCategory = categoryName
                // Updating Values
                vc.paramDic.updateValue("Housing", forKey: "itemCategory")
                vc.paramDic.updateValue(realEstateTextField.text!, forKey: "housingType")
                vc.paramDic.updateValue(bedroomsTextField.text!, forKey: "bedrooms")
                vc.paramDic.updateValue(bathroomTextField.text!, forKey: "bathrooms")
                vc.paramDic.updateValue(laundryTextField.text!, forKey: "laundry")
                vc.paramDic.updateValue(parkingTextField.text!, forKey: "parking")
                vc.paramDic.updateValue(descriptionTextView.text!, forKey: "description")
                vc.paramDic.updateValue(squareFeetTextField.text!, forKey: "squareFeet")
                vc.paramDic.updateValue(availableTimeStamp, forKey: "availableOn")
                vc.paramDic.updateValue(openHouseTimeStamp, forKey: "openHouseDate")
                vc.paramDic.updateValue(noSmokingSelectionStatus, forKey: "noSmoking")
                vc.paramDic.updateValue(wheelChairSelectionStatus, forKey: "wheelChairAccess")
                vc.paramDic.updateValue(furnishedSelectionStatus, forKey: "furnished")
                vc.paramDic.updateValue(petsSelectionStatus, forKey: "petsAccepted")
                
                vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
                vc.paramDic.updateValue(self.paramDic["housingCategory"] ?? "", forKey: "housingCategory")
                
                UserDefaults.standard.set(vc.paramDic, forKey: "housingDescriptionDic")
                print(vc.paramDic)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if categoryName == "Rooms Wanted"{
            
            if descriptionTextView.text!.isEmpty || descriptionTextView.text!.count < 20 {
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: strDescriptionValidation)
                descriptionTextView.becomeFirstResponder()
            }
            else if squareFeetTextField.text!.isEmpty || squareFeetTextField.text!.count < 1{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strSquareFeetValidation".localizableString(loc: LanguageChangeCode))
                squareFeetTextField.becomeFirstResponder()
            }
            else {
               // Send Button Functionality
                let SB = UIStoryboard(name: "Listing", bundle: nil)
                let vc = SB.instantiateViewController(withIdentifier: "ItemListingLocationVC") as! ItemListingLocationVC
                vc.controllerName = "housing"
                //Session Update
                vc.imageArray = self.imageArray
                vc.housingCategory = categoryName
                // Updating Values
                vc.paramDic.updateValue("Housing", forKey: "itemCategory")
                vc.paramDic.updateValue(descriptionTextView.text!, forKey: "description")
                vc.paramDic.updateValue(squareFeetTextField.text!, forKey: "squareFeet")
                vc.paramDic.updateValue(noSmokingSelectionStatus, forKey: "noSmoking")
                vc.paramDic.updateValue(wheelChairSelectionStatus, forKey: "wheelChairAccess")
                vc.paramDic.updateValue(furnishedSelectionStatus, forKey: "furnished")
                vc.paramDic.updateValue(petsSelectionStatus, forKey: "petsAccepted")
                
                vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
                vc.paramDic.updateValue(self.paramDic["housingCategory"] ?? "", forKey: "housingCategory")
                UserDefaults.standard.set(vc.paramDic, forKey: "housingDescriptionDic")
                print(vc.paramDic)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if categoryName == "Office & Commercial" || categoryName == "Parking & Storage"{
            if descriptionTextView.text!.isEmpty || descriptionTextView.text!.count < 20 {
            showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: strDescriptionValidation)
            descriptionTextView.becomeFirstResponder()
            }
           else if squareFeetTextField.text!.isEmpty || squareFeetTextField.text!.count < 1{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strSquareFeetValidation".localizableString(loc: LanguageChangeCode))
                squareFeetTextField.becomeFirstResponder()
            }
            else {
                // Send Button
                let SB = UIStoryboard(name: "Listing", bundle: nil)
                let vc = SB.instantiateViewController(withIdentifier: "ItemListingLocationVC") as! ItemListingLocationVC
                vc.controllerName = "housing"
                //Session Update
                vc.imageArray = self.imageArray
                vc.housingCategory = categoryName
                // Updating Values
                vc.paramDic.updateValue("Housing", forKey: "itemCategory")
                vc.paramDic.updateValue(descriptionTextView.text!, forKey: "description")
                vc.paramDic.updateValue(squareFeetTextField.text!, forKey: "squareFeet")
               
                vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
                vc.paramDic.updateValue(self.paramDic["housingCategory"] ?? "", forKey: "housingCategory")
                UserDefaults.standard.set(vc.paramDic, forKey: "housingDescriptionDic")
                print(vc.paramDic)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            if realEstateTextField.text!.isEmpty || realEstateTextField.text == "Select Category"{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strRealEstateSelection".localizableString(loc: LanguageChangeCode))
                realEstateTextField.becomeFirstResponder()
            }
            else if bedroomsTextField.text!.isEmpty{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strBedRoomsSelection".localizableString(loc: LanguageChangeCode))
                bedroomsTextField.becomeFirstResponder()
            }
            else if bathroomTextField.text!.isEmpty{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strBathroomsSelection".localizableString(loc: LanguageChangeCode))
                bathroomTextField.becomeFirstResponder()
            }
            else if laundryTextField.text!.isEmpty{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strLaundrySelection".localizableString(loc: LanguageChangeCode))
                laundryTextField.becomeFirstResponder()
            }
            else if parkingTextField.text!.isEmpty{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strParkingSelection".localizableString(loc: LanguageChangeCode))
                parkingTextField.becomeFirstResponder()
            }
            else if descriptionTextView.text!.isEmpty || descriptionTextView.text!.count < 20 {
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: strDescriptionValidation)
                descriptionTextView.becomeFirstResponder()
            }
            else if squareFeetTextField.text!.isEmpty || squareFeetTextField.text!.count < 1 {
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strSquareFeetValidation".localizableString(loc: LanguageChangeCode))
                squareFeetTextField.becomeFirstResponder()
            }
            else if availableDateTextField.text!.isEmpty{
                showSwiftMessageWithParams(theme: .info, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strAvailableOnDateSelection".localizableString(loc: LanguageChangeCode))
                descriptionTextView.becomeFirstResponder()
            }else {
                // Send Button
                let SB = UIStoryboard(name: "Listing", bundle: nil)
                let vc = SB.instantiateViewController(withIdentifier: "ItemListingLocationVC") as! ItemListingLocationVC
                vc.controllerName = "housing"
                //Session Update
                vc.imageArray = self.imageArray
                vc.housingCategory = categoryName
                // Updating Values
                vc.paramDic.updateValue("Housing", forKey: "itemCategory")
                vc.paramDic.updateValue(realEstateTextField.text!, forKey: "housingType")
                vc.paramDic.updateValue(bedroomsTextField.text!, forKey: "bedrooms")
                vc.paramDic.updateValue(bathroomTextField.text!, forKey: "bathrooms")
                vc.paramDic.updateValue(laundryTextField.text!, forKey: "laundry")
                vc.paramDic.updateValue(parkingTextField.text!, forKey: "parking")
                vc.paramDic.updateValue(descriptionTextView.text!, forKey: "description")
                vc.paramDic.updateValue(squareFeetTextField.text!, forKey: "squareFeet")
                vc.paramDic.updateValue(availableTimeStamp, forKey: "availableOn")
                vc.paramDic.updateValue(openHouseTimeStamp, forKey: "openHouseDate")
                vc.paramDic.updateValue(noSmokingSelectionStatus, forKey: "noSmoking")
                vc.paramDic.updateValue(wheelChairSelectionStatus, forKey: "wheelChairAccess")
                vc.paramDic.updateValue(furnishedSelectionStatus, forKey: "furnished")
                vc.paramDic.updateValue(petsSelectionStatus, forKey: "petsAccepted")
                
                vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
                vc.paramDic.updateValue(self.paramDic["housingCategory"] ?? "", forKey: "housingCategory")
                UserDefaults.standard.set(vc.paramDic, forKey: "housingDescriptionDic")
                print(vc.paramDic)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func saveBtnTapped(sender: UIButton){
        //Save Button Tapped
        self.shadowView.isHidden = true
        self.openHouseSelectionView.isHidden = true
    }
    
    @objc func crossBtnTapped(sender: UIButton){
        //Save Button Tapped
        self.shadowView.isHidden = true
        self.openHouseSelectionView.isHidden = true
    }
    
    
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
    }
    
    @objc func petsAccepted (sender:UIButton){
        if petsSelectionStatus == false {
            petsSelectionStatus = true
            PetsAccepted.backgroundColor = UIColor.black
            PetsAccepted.setTitleColor(.white, for: .normal)
        }else if petsSelectionStatus == true{
            petsSelectionStatus = false
            PetsAccepted.backgroundColor = UIColor.white
            PetsAccepted.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func Furnished (sender:UIButton){
        if furnishedSelectionStatus == false {
            furnishedSelectionStatus = true
            Furnished.backgroundColor = UIColor.black
            Furnished.setTitleColor(.white, for: .normal)
        }else if furnishedSelectionStatus == true{
            furnishedSelectionStatus = false
            Furnished.backgroundColor = UIColor.white
            Furnished.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func noSmoking (sender:UIButton){
        if noSmokingSelectionStatus == false {
            noSmokingSelectionStatus = true
            NoSmoking.backgroundColor = UIColor.black
            NoSmoking.setTitleColor(.white, for: .normal)
        }else if noSmokingSelectionStatus == true{
            noSmokingSelectionStatus = false
            NoSmoking.backgroundColor = UIColor.white
            NoSmoking.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func wheelChairAccess (sender:UIButton){
        if wheelChairSelectionStatus == false {
            wheelChairSelectionStatus = true
            WheelChairAccess.backgroundColor = UIColor.black
            WheelChairAccess.setTitleColor(.white, for: .normal)
        }else if wheelChairSelectionStatus == true {
            wheelChairSelectionStatus = false
            WheelChairAccess.backgroundColor = UIColor.white
            WheelChairAccess.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        availableDateTextField.text = formatter.string(from: datePicker.date)
        // time interval since 1970
        let myTimeStamp = datePicker.date.timeIntervalSince1970 * 1000
        availableTimeStamp = Double(myTimeStamp)
        let dateStr = availableDateTextField.text!
        let calendar = Calendar(identifier: .gregorian)
        if let currDate = formatter.date(from: dateStr) {
            for i in 1...30 {
                let newDate = calendar.date(byAdding: .day, value: i, to: currDate)!
                let finalDate = formatter.string(from: newDate)
                let timeStamp = convertStringToTimeStamp(yourDate: finalDate)
                let date = openHouseModel.init(date: finalDate, isSelected: false, timeStamp: timeStamp)
                openHouseDateArray.append(date)
            }
        }
        openHouseDateTextField.isUserInteractionEnabled = true
        openHouseTableView.delegate = self
        openHouseTableView.dataSource = self
        openHouseTableView.reloadData()
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    
    //MARK:- Private Function
    //TODO:- this function is used to dismiss the drawer view by pressing the ShadowView
    
    private func convertStringToTimeStamp(yourDate: String) -> Double {
        //initialize the Date Formatter
        let dateFormatter = DateFormatter()
        //specify the date Format
        dateFormatter.dateFormat = "dd-MM-yyyy"
        //get date from string
        let dateString = dateFormatter.date(from: yourDate)
        //get timestamp from Date
        let dateTimeStamp  = dateString!.timeIntervalSince1970 * 1000
        return dateTimeStamp
    }
    
    private func openHouseFunctionality() {
        self.view.endEditing(true)
        self.shadowView.isHidden = false
        self.openHouseSelectionView.isHidden = false
    }
    
    func showDatePicker(){
        //Formate Date
        availableDateTextField.delegate = self
        datePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        availableDateTextField.inputAccessoryView = toolbar
        availableDateTextField.inputView = datePicker
    }
    
    private func setupViewsHeight(){
        if categoryName == "Rooms & Shared" || categoryName == "Sublets & Temporary"{
            bathroomArray = ["Select Type","Private Bath","Shared Bath"]
            bedroomArray = ["Select Type","Private room","Shared room"]
            
            realEstateHeight.constant = 84
            realEstateTextField.isHidden = false
            realEstateView.isHidden = false
            bedroomViewHeights.constant = 84
            bedroomsTextField.isHidden = false
            bedroomsView.isHidden = false
            bathroomViewHeights.constant = 84
            bathroomTextField.isHidden = false
            bathroomsView.isHidden = false
            laundryViewHeights.constant = 84
            laundryTextField.isHidden = false
            laundryView.isHidden = false
            parkingViewHeights.constant = 84
            parkingTextField.isHidden = false
            parkingView.isHidden = false
            squareFeetViewHeights.constant = 84
            squareFeetTextField.isHidden = false
            squareFeetView.isHidden = false
            availbleOnViewHeight.constant = 84
            availableDateTextField.isHidden = false
            availbleOnView.isHidden = false
            openHouseViewHeights.constant = 84
            openHouseDateTextField.isHidden = false
            openHouseView.isHidden = false
            additionalChoiceViewHeight.constant = 150
            additionalChoiceView.isHidden = false
        }
        else if categoryName == "Rooms Wanted"{
            bathroomArray = ["Select Number Of Baths","0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8+"]
            bedroomArray = ["Select Number Of rooms","0", "1", "2", "3", "4", "5", "6", "7", "8"]
            realEstateHeight.constant = 0
            realEstateTextField.isHidden = true
            realEstateView.isHidden = true
            bedroomViewHeights.constant = 0
            bedroomsTextField.isHidden = true
            bedroomsView.isHidden = true
            bathroomViewHeights.constant = 0
            bathroomTextField.isHidden = true
            bathroomsView.isHidden = true
            laundryViewHeights.constant = 0
            laundryTextField.isHidden = true
            laundryView.isHidden = true
            parkingViewHeights.constant = 0
            parkingTextField.isHidden = true
            parkingView.isHidden = true
            squareFeetViewHeights.constant = 84
            squareFeetTextField.isHidden = false
            squareFeetView.isHidden = false
            availbleOnViewHeight.constant = 0
            availableDateTextField.isHidden = true
            availbleOnView.isHidden = true
            openHouseViewHeights.constant = 0
            openHouseDateTextField.isHidden = true
            openHouseView.isHidden = true
            additionalChoiceViewHeight.constant = 150
            additionalChoiceView.isHidden = false
            
        }
        else if categoryName == "Office & Commercial" || categoryName == "Parking & Storage"{
            bathroomArray = ["Select Number Of Baths","0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8+"]
            bedroomArray = ["Select Number Of rooms","0", "1", "2", "3", "4", "5", "6", "7", "8"]
            realEstateHeight.constant = 0
            realEstateTextField.isHidden = true
            realEstateView.isHidden = true
            bedroomViewHeights.constant = 0
            bedroomsTextField.isHidden = true
            bedroomsView.isHidden = true
            bathroomViewHeights.constant = 0
            bathroomTextField.isHidden = true
            bathroomsView.isHidden = true
            laundryViewHeights.constant = 0
            laundryTextField.isHidden = true
            laundryView.isHidden = true
            parkingViewHeights.constant = 0
            parkingTextField.isHidden = true
            parkingView.isHidden = true
            squareFeetViewHeights.constant = 90
            squareFeetTextField.isHidden = false
            squareFeetView.isHidden = false
            availbleOnViewHeight.constant = 0
            availableDateTextField.isHidden = true
            availbleOnView.isHidden = true
            openHouseViewHeights.constant = 0
            openHouseDateTextField.isHidden = true
            openHouseView.isHidden = true
            additionalChoiceViewHeight.constant = 0
            additionalChoiceView.isHidden = true
            
        }
        else {
            bathroomArray = ["Select Number Of Baths","0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8+"]
            bedroomArray = ["Select Number Of rooms","0", "1", "2", "3", "4", "5", "6", "7", "8"]
            realEstateHeight.constant = 90
            realEstateTextField.isHidden = false
            realEstateView.isHidden = false
            bedroomViewHeights.constant = 90
            bedroomsTextField.isHidden = false
            bedroomsView.isHidden = false
            bathroomViewHeights.constant = 90
            bathroomTextField.isHidden = false
            bathroomsView.isHidden = false
            laundryViewHeights.constant = 90
            laundryTextField.isHidden = false
            laundryView.isHidden = false
            parkingViewHeights.constant = 90
            parkingTextField.isHidden = false
            parkingView.isHidden = false
            squareFeetViewHeights.constant = 90
            squareFeetTextField.isHidden = false
            squareFeetView.isHidden = false
            availbleOnViewHeight.constant = 90
            availableDateTextField.isHidden = false
            availbleOnView.isHidden = false
            openHouseViewHeights.constant = 90
            openHouseDateTextField.isHidden = false
            openHouseView.isHidden = false
            additionalChoiceViewHeight.constant = 150
            additionalChoiceView.isHidden = false
        }
    }
    
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Description"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    private func setupViews() {
        squareFeetTextField.delegate = self
        squareFeetTextField.tag = 1
        descriptionTextView.delegate = self
        descriptionTextView.text = "Housing Description"
        descriptionTextView.textColor = UIColor.lightGray
        
        openHouseDateTextField.isUserInteractionEnabled = false
        
        let SessionDic: [String: Any]? = UserDefaults.standard.dictionary(forKey: "housingDescriptionDic")
               if SessionDic != nil {
                
                let housingCategory = "\(SessionDic?["housingCategory"] ?? "")"
                if housingCategory == categoryName {
                    realEstateTextField.text = "\(SessionDic?["housingType"] ?? "")"
                    bedroomsTextField.text = "\(SessionDic?["bedrooms"] ?? "")"
                    bathroomTextField.text = "\(SessionDic?["bathrooms"] ?? "")"
                    laundryTextField.text = "\(SessionDic?["laundry"] ?? "")"
                    parkingTextField.text = "\(SessionDic?["parking"] ?? "")"
                    let desc = "\(SessionDic?["description"] ?? "")"
                    print(desc)
                    if desc != "" {
                        descriptionTextView.text = desc
                        descriptionTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    }
                    squareFeetTextField.text = "\(SessionDic?["squareFeet"] ?? "")"
                    let timeStamp = "\(SessionDic?["availableOn"] ?? "")"
                    if timeStamp != "" {
                        if let timeResult = (SessionDic?["availableOn"] as? Double) {
                            availableTimeStamp = timeResult
                            let date = Date(timeIntervalSince1970: timeResult / 1000)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                            dateFormatter.timeZone = .current
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            let localDate = dateFormatter.string(from: date)
                            availableDateTextField.text = "\(localDate)"
                            
                            let calendar = Calendar(identifier: .gregorian)
                            if let currDate = dateFormatter.date(from: localDate) {
                                for i in 1...30 {
                                    let newDate = calendar.date(byAdding: .day, value: i, to: currDate)!
                                    let finalDate = dateFormatter.string(from: newDate)
                                    print(finalDate)
                                    let timeStamp = convertStringToTimeStamp(yourDate: finalDate)
                                    let date = openHouseModel.init(date: finalDate, isSelected: false, timeStamp: timeStamp)
                                    openHouseDateArray.append(date)
                                }
                            }
                            print(openHouseDateArray)
                            openHouseDateTextField.isUserInteractionEnabled = true
                            openHouseTableView.delegate = self
                            openHouseTableView.dataSource = self
                            openHouseTableView.reloadData()
                            self.view.endEditing(true)
                        }
                    }
                    
                    let openHouseDate = SessionDic?["openHouseDate"]
                    if openHouseDate != nil {
                        openHouseTimeStamp.removeAll()
                        let array = SessionDic!["openHouseDate"] as! Array<Double>
                        openHouseTimeStamp = array
                        for item in array{
                            let text = item
                            let date = Date(timeIntervalSince1970: text / 1000)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                            dateFormatter.timeZone = .current
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            let localDate = dateFormatter.string(from: date)
                            selectedOpenHouseArray.append(localDate)
                        }
                        let text = selectedOpenHouseArray.joined(separator: ",")
                        openHouseDateTextField.text = text
                    }
                    let noSmoking = SessionDic?["noSmoking"]
                    if noSmoking != nil {
                        self.noSmokingSelectionStatus = SessionDic?["noSmoking"] as! Bool
                        if self.noSmokingSelectionStatus == true {
                            NoSmoking.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                            NoSmoking.setTitleColor(.white, for: .normal)
                        }
                    }
                    let wheel = SessionDic?["wheelChairAccess"]
                    if wheel != nil {
                        self.wheelChairSelectionStatus = SessionDic?["wheelChairAccess"] as! Bool
                        if self.wheelChairSelectionStatus == true {
                            WheelChairAccess.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                            WheelChairAccess.setTitleColor(.white, for: .normal)
                        }
                    }
                    let furnished = SessionDic?["furnished"]
                    if furnished != nil {
                        self.furnishedSelectionStatus = SessionDic?["furnished"] as! Bool
                        if self.furnishedSelectionStatus == true {
                            Furnished.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                            Furnished.setTitleColor(.white, for: .normal)
                        }
                    }
                    let pets = SessionDic?["petsAccepted"]
                    if pets != nil {
                        self.petsSelectionStatus = SessionDic?["petsAccepted"] as! Bool
                        if self.petsSelectionStatus == true {
                            PetsAccepted.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                            PetsAccepted.setTitleColor(.white, for: .normal)
                        }
                    }
                }else {
                    realEstateTextField.text = ""
                    bedroomsTextField.text = ""
                    bathroomTextField.text = ""
                    laundryTextField.text = ""
                    parkingTextField.text = ""
                    descriptionTextView.text = ""
                    squareFeetTextField.text = ""
                    availableTimeStamp = 0
                    PetsAccepted.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    PetsAccepted.setTitleColor(.black, for: .normal)
                    Furnished.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    Furnished.setTitleColor(.black, for: .normal)
                    WheelChairAccess.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    WheelChairAccess.setTitleColor(.black, for: .normal)
                    NoSmoking.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    NoSmoking.setTitleColor(.black, for: .normal)
                }
            }
        
        
        
        // Assigning Delegate to the Text Fields
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
        
        openHouseDateTextField.delegate = self
        
        //Assigning Button Actions
        PetsAccepted.addTarget(self, action: #selector(petsAccepted(sender:)), for: .touchUpInside)
        Furnished.addTarget(self, action: #selector(Furnished(sender:)), for: .touchUpInside)
        NoSmoking.addTarget(self, action: #selector(noSmoking(sender:)), for: .touchUpInside)
        WheelChairAccess.addTarget(self, action: #selector(wheelChairAccess(sender:)), for: .touchUpInside)
        
        openHouseSaveBtn.addTarget(self, action: #selector(saveBtnTapped(sender:)), for: .touchUpInside)
        
        crossBtn.addTarget(self, action: #selector(crossBtnTapped(sender:)), for: .touchUpInside)
        
        
        // Assigning Button Animation
        PetsAccepted.makeBlackBorder()
        Furnished.makeBlackBorder()
        NoSmoking.makeBlackBorder()
        WheelChairAccess.makeBlackBorder()
        nextBtn.shadowView()
        crossBtn.shadowView()
        
        showDownImageOnTextField(TextField: realEstateTextField)
        showDownImageOnTextField(TextField: bedroomsTextField)
        showDownImageOnTextField(TextField: bathroomTextField)
        showDownImageOnTextField(TextField: laundryTextField)
        showDownImageOnTextField(TextField: parkingTextField)
        
        showDownImageOnTextField(TextField: availableDateTextField)
        showDownImageOnTextField(TextField: openHouseDateTextField)
        
        nextBtn.addTarget(self, action: #selector(nextBtnTapped(sender:)), for: .touchUpInside)
    }
}

//MARK:- Text Delgate, Action and Function
extension HousingListingStepTwoVC : UITextFieldDelegate {
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == openHouseDateTextField {
            openHouseFunctionality()
        }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 1{
            if (textField.text?.count)! > 7 {
                let maxLength = 8
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

//MARK:-  Picker View Delgate and Data Source
extension HousingListingStepTwoVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
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
        self.view.endEditing(true)
    }
}
//MARK:- TABLE VIEW DELEGATE AND DATA-SOURCE
extension HousingListingStepTwoVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openHouseDateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = openHouseTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! openHouseTableViewCell
        let array = openHouseDateArray
        guard indexPath.row < array.count else {return cell}
        cell.dateLbl.text = array[indexPath.row].date
        if array[indexPath.row].isSelected == true {
            cell.checkImg.image = #imageLiteral(resourceName: "Single-Tick")
            selectedOpenHouseArray.append(array[indexPath.row].date)
            openHouseTimeStamp.append(array[indexPath.row].timeStamp)
        }else {
            selectedOpenHouseArray.removeAll(where : {$0 == array[indexPath.row].date})
            openHouseTimeStamp.removeAll(where : {$0 == array[indexPath.row].timeStamp})
            cell.checkImg.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openHouseDateArray[indexPath.row].isSelected = !openHouseDateArray[indexPath.row].isSelected
        openHouseTableView.reloadRows(at: [indexPath], with: .fade)
        print(selectedOpenHouseArray)
        if selectedOpenHouseArray.count <= 3 {
            
            let text = selectedOpenHouseArray.joined(separator: ",")
            openHouseDateTextField.text = text
        }else {
            self.view.makeToast("You can select up to 3 open house dates", position:.top)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
