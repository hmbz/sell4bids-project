//
//  SellForBidsViewController.swift
//  Sell4Bids
//
//  Created by admin on 9/4/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import TGPControls
import Firebase
import Alamofire
import SwiftyJSON


class FiltersVc: UITableViewController,UICollectionViewDelegate {
    
    
    //MARK: - Properties
    @IBOutlet weak var categoriesTextField: UITextField!
    @IBOutlet weak var buyingOptionTextField: UITextField!
    //    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var maxTextField: UITextField!
    @IBOutlet weak var minTextField: UITextField!
    @IBOutlet weak var slider: TGPDiscreteSlider!
    // @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var Countrylist: UITextField!
    //    @IBOutlet weak var Zipcodetxt: UITextField!
    //    @IBOutlet weak var citytxt: UITextField!
    weak var delegate : filtersVCDelegate?
    @IBOutlet weak var btnDone: UIButton!
    // Change By Osama Mansoori 30-January
    
    @IBOutlet weak var CategoryLbl: UILabel!
    @IBOutlet weak var BuyingOptionLbl: UILabel!
    @IBOutlet weak var CountryLbl: UILabel!
    //    @IBOutlet weak var ZipCodeLbl: UILabel!
    //    @IBOutlet weak var CityandStateLbl: UILabel!
    //    @IBOutlet weak var CityLbl: UILabel!
    //    @IBOutlet weak var ChangeCityLbl: UILabel!
    //    @IBOutlet weak var StateLbl: UILabel!
    //    @IBOutlet weak var ChangeZipCodetoChangeStateLbl: UILabel!
    @IBOutlet weak var ConditionLbl: UILabel!
    
    //   @IBOutlet weak var AnyLbl: UILabel!
    @IBOutlet weak var PriceRangeLbl: UILabel!
    
    //MARK: - Variables
    var titleview = Bundle.main.loadNibNamed("NavigationBarMainView",
                                             owner: self, options: nil)?.first as! NavigationBarMainView
    var categoryToFilter = ""
    var buyingOptionToFilter = ""
    var stateToFilter = "NY"
    var conditionFilter = "Any"
   var buyOptionArray:[String] = ["Select one","Any","Buy Now","Bidding"]
    var priceMinFilter : Int?
    var priceMaxFilter: Int?
    var currency = String()
    var indiaZipCode: IndiaPinCodeModel?
    var UsaZipCode : USAZipCodeModel?
    var currency_Symbol = "$"
    var dbRef:DatabaseReference!
    var databaseHandle:DatabaseHandle?
    var latitude: Double?
    var longitude : Double?
    var sliderData = ["Any","For Parts","Used",
                      "Reconditioned","Open box / Like new","New"]
    var selectedCategory:String?
    var selectedBuyingOption:String?
    var selectedStateName:String?
    let catPicker = UIPickerView()
    let picker2 = UIPickerView()
    let picker3 = UIPickerView()
    let countrypicker = UIPickerView()
    var endTimee:Double = 0
    var resultProductsArray = [ProductModel]()
    var filterProductArray = [ProductModel]()
    var allProductsArray = [ProductModel]()
    var buyItNowString = ""
    var reserveString = ""
    var nonReserveString = ""
    var MainApis = MainSell4BidsApi()
    var HomeView = UIStoryboard.init(name: "homeTab", bundle: nil)
    var selfWasPushed = false
    public var cityAndStateName = ""
    var currencyChar : Character = "$"
    // @AK
    var countryF = ""
    lazy var countryName = ""
    var conditionFilterF = ""
    var cityF = ""
    var buyingOptionToFilterF = ""
    var categoryToFilterF = ""
    var MinPriceF = ""
    var MaxPriceF = ""
    var MainApi = MainSell4BidsApi()
    lazy var apiDic:[String:Any] = [:]
    
    
    
    
    private func setupApidicAnshowData(body:[String:Any]) {
        let Category = body["itemCategory"] ?? nil
        let AuctionType = body["itemAuctionType"] ?? nil
        let country = body["country"] ?? nil
//        let condition = body["condition"] ?? nil
        let maxPrice = body["maxPrice"] ?? nil
        let minPrice = body["minPrice"] ?? nil
        self.categoriesTextField.text = Category as? String
        self.buyingOptionTextField.text = AuctionType as? String
        self.Countrylist.text = country as? String
        self.minTextField.text = minPrice as? String
        self.maxTextField.text = maxPrice as? String
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        categoriesTextField.applyBlackCorner()
        buyingOptionTextField.applyBlackCorner()
        Countrylist.applyBlackCorner()
        slider.applyBlackCorner()
        maxTextField.applyBlackCorner()
        minTextField.applyBlackCorner()
        btnDone.shadowView()
        categoriesTextField.text = categoryToFilter
        self.tabBarController?.tabBar.isHidden = true
        minTextField.delegate = self
        maxTextField.delegate = self
        
        //navigation properties.
        self.navigationItem.title = "Filters"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //when click outside on view dismiss pickerview.
        self.view.endEditing(true)
        
        //calling functions.
        createCategoryPicker()
        createToolbar()
        slider.addTarget(self, action: #selector(handleValueChange(_:)), for: .valueChanged)
        addRefreshBarButtonToNav()
        setupApidicAnshowData(body: apiDic)
      setupViews()
    }
    
    //MARK:- Functions
   
    
    //left navigationbar button with sell4bids icons
    private func setupLeftBarButtons() {
        
        //define cancel function on cancel button with selector cancelTabBtnTapped.
        let cancelBarBtn = UIBarButtonItem.init(title: "Cancel", style: .done,
                                                target: self, action: #selector(cancelTabBtnTapped))
        
        //define custom button for icon
        let button = UIButton.init(type: .custom)
        
        //set sell4bids icon image on button
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        
        //define width and height on custom button.
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem.init(customView: button)
        
        
        //add buttons on left side in navigationitem.
        navigationItem.leftBarButtonItems = [cancelBarBtn, barButton]
    }
    
    
    
    //trigger define with boolen value .
    private func setupViews() {
      let a = UserDefaults.standard.value(forKey: "category")
      let b = UserDefaults.standard.value(forKey: "buyingoption")
       let c = UserDefaults.standard.value(forKey: "condition")
      let d = UserDefaults.standard.value(forKey: "slidervalue")
      let e = UserDefaults.standard.value(forKey: "min")
       let f = UserDefaults.standard.value(forKey: "max")
       let g = UserDefaults.standard.value(forKey: "location")
       let h = UserDefaults.standard.value(forKey: "symbol")
      if h != nil{
        self.maxTextField.placeholder = "\(String(describing: h!)) Max"
        self.minTextField.placeholder = "\(String(describing: h!)) Min"
        
      }
      
      if a != nil{
        self.categoriesTextField.text = a as? String
      }
      if b != nil{
        self.buyingOptionTextField.text = b  as? String
      }else{
         self.buyingOptionTextField.text = "Buying Options"
      }
      if c != nil{
        self.conditionLabel.text = c as? String
        
      }
      if d != nil{
        self.slider.value = d as! CGFloat
      }
      if e != nil{
        self.minTextField.text = e as? String
      }
      if f != nil{
             self.maxTextField.text = f as? String
           }
      if g != nil{
        self.Countrylist.text = g as? String
      }
      
        if !selfWasPushed {
            setupLeftBarButtons()
        }
        //define custom color which used on textfield and pickerview
        _ = UIColor(red: 0.76, green: 0.25, blue: 0.18 , alpha: 1.0)
        //set keyboard type as numberpad
        minTextField.keyboardType = UIKeyboardType.numberPad
        maxTextField.keyboardType = UIKeyboardType.numberPad
    }
    
    private func addRefreshBarButtonToNav() {
        //define title on reset all button, define selector function refreshBtnInNavTapped.
        let barBtnRefresh = UIBarButtonItem.init(title: "Reset All".localizableString(loc: LanguageChangeCode), style: .done, target: self, action: #selector(refreshBtnInNavTapped))
        //add button on left side in navigationbar.
        navigationItem.rightBarButtonItem = barBtnRefresh
        
    }
    
    @objc private func refreshBtnInNavTapped() {
        //define defaults value when user tab on Reset All button.
        DispatchQueue.main.async {
            self.categoriesTextField.text = "All"
            self.buyingOptionTextField.text = "Any"
            self.slider.value = 0
            self.minTextField.text = ""
            self.maxTextField.text = ""
            self.priceMaxFilter = nil
            self.priceMaxFilter = nil
            self.Countrylist.text = ""
          UserDefaults.standard.set(nil, forKey: "category")
                UserDefaults.standard.set(nil, forKey: "condition")
            UserDefaults.standard.set(nil, forKey: "buyingoption")
                UserDefaults.standard.set(nil, forKey: "slidervalue")
                UserDefaults.standard.set(nil, forKey: "min")
                UserDefaults.standard.set(nil, forKey: "max")
                UserDefaults.standard.set(nil, forKey: "location")
               UserDefaults.standard.value(forKey: "symbol")
        }
        DispatchQueue.main.async {
            self.resignFirstResponder()
            self.view.endEditing(true)
        }
        
        
    }
    
    //when tap on click btn it popview from navigationcontroller.
    @objc func cancelTabBtnTapped(){
        if selfWasPushed {
            self.navigationController?.popViewController(animated: true)
        }else {
            //was presented
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    func createCategoryPicker() {
        catPicker.delegate = self
        picker2.delegate = self
        countrypicker.delegate = self
        categoriesTextField.inputView = catPicker
        buyingOptionTextField.inputView = picker2
        //        Countrylist.inputView = countrypicker
        catPicker.backgroundColor = .groupTableViewBackground
    }
    
    func createToolbar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //customozation
        toolBar.barTintColor = .red
        toolBar.tintColor = .white
        let doneButton = UIBarButtonItem(title: "Done", style: .plain,
                                         target: self, action: #selector(FiltersVc.dismissKeyBoard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        categoriesTextField.inputAccessoryView = toolBar
        buyingOptionTextField.inputAccessoryView = toolBar
        
        
    }
    
    @objc func dismissKeyBoard(){
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyBoard()
        
    }
    
    
    
    //MARK: - Actions
    //if tab on condition slider it assign value on condition label.
    @objc func handleValueChange(_ sender: TGPDiscreteSlider){
        //set slider value in constant variable named value.
        let value = Int(sender.value)
        self.conditionLabel.text = sliderData[value]
        conditionFilterF = sliderData[value]
       UserDefaults.standard.set(self.conditionLabel.text, forKey: "condition")
      UserDefaults.standard.set(self.slider.value, forKey: "slidervalue")
    }
    
    @objc func doneBtn(){
        //filterNewData()
        //
       UserDefaults.standard.set(nil, forKey: "category")
       UserDefaults.standard.set(nil, forKey: "condition")
       UserDefaults.standard.set(nil, forKey: "slidervalue")
       UserDefaults.standard.set(nil, forKey: "min")
       UserDefaults.standard.set(nil, forKey: "max")
       UserDefaults.standard.set(nil, forKey: "location")
       UserDefaults.standard.value(forKey: "symbol")
       
        self.performSegue(withIdentifier: "done", sender: self)
    }
    
    @IBAction func btnDoneFilteringTapped(_ sender: UIButton) {

        
        let category = categoriesTextField.text!
        let buyOption = buyingOptionTextField.text!
        let location = countryName
        let latitude = "\(self.latitude!)"
        let longitude = "\(self.longitude!)"
        let condition = conditionLabel.text!
        let maxPrice = maxTextField.text!
        let minPrice = minTextField.text!
        
        var body: [String:Any] = [:]
        
        if category != "" {
            body.updateValue(category, forKey: "itemCategory")
        }
        if buyOption != "" && buyOption != "Any" {
            body.updateValue(buyingOptionToFilter, forKey: "itemAuctionType")
        }
      if buyOption != "" && buyOption == "Any" {
                 body.updateValue(buyingOptionToFilter, forKey: "itemAuctionType")
             }
        if location != "" && latitude != "" && longitude != "" {
            body.updateValue(location, forKey: "country")
            body.updateValue(latitude, forKey: "lat")
            body.updateValue(longitude, forKey: "lng")
        }
        if condition != "" && condition != "Any" {
            body.updateValue(condition, forKey: "condition")
        }
        if maxPrice != "" {
            body.updateValue(maxPrice, forKey: "maxPrice")
        }
        if minPrice != "" {
            body.updateValue(minPrice, forKey: "minPrice")
        }
        body.updateValue("0", forKey: "start")
        body.updateValue("25", forKey: "limit")
        delegate?.getFilterData(param: body)
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - UIPickerViewDelegate,UIPickerViewDataSource
extension FiltersVc: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == catPicker {
            //for selecting all input
            return categoriesArray.count + 1
        }
        else if pickerView == picker2 {
            //for selecting all input
            return buyOptionArray.count
        }else if pickerView == countrypicker {
            //for selecing country input
            return countryList.count
        }else {
            return  1
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == catPicker {
            if row == 0 { return "All" }
            return categoriesArray[row - 1]
        }
        else if pickerView == picker2{
          
              return buyOptionArray[row]
          
            
        }else if pickerView == countrypicker {
            return countryList[row]
        }else {
            return " "
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == catPicker {
            if row == 0 {
                categoryToFilter = ""
                categoryToFilterF = ""
            }
            else {
                categoryToFilter = categoriesArray[row - 1]
                categoryToFilterF = categoriesArray[row - 1]
              
            }
            categoriesTextField.text =  categoryToFilter
          UserDefaults.standard.set(categoriesTextField.text, forKey: "category")
        }//end if pickerView == catPicker {
        else if pickerView == picker2 {
           
              buyingOptionToFilter = buyOptionArray[row ]
                buyingOptionToFilterF = buyOptionArray[row]
                buyingOptionTextField.text =  buyingOptionToFilter
                if buyOptionArray[row] == "Buy Now" {
                    buyingOptionToFilter = "buy-it-now"
                    buyingOptionToFilterF = "buy-it-now"
                }else if buyOptionArray[row] == "Any" {
                  buyingOptionToFilter = ""
                  buyingOptionToFilterF = ""
                }
                else {
                    buyingOptionToFilter = "reserve"
                    buyingOptionToFilterF = "reserve"
                }
             UserDefaults.standard.set( buyingOptionTextField.text, forKey: "buyingoption")
        }else if pickerView == countrypicker {
            countryF = countryList[row]
            if countryList[row] == "USA" {
                currency = "$"
                self.titleview.citystateZIpcode.text = self.cityAndStateName
            }else if countryList[row] == "IN" {
                currency = "₹"
            }
            
            Countrylist.text = countryList[row]
            self.view.endEditing(true)
            
            
            
        }//end else if pickerView == picker2 {
        
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
    }
}


//MARK:- UITextFieldDelegate
extension FiltersVc : UITextFieldDelegate{
  
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == maxTextField {
            let currencySymbol = CurrencyManager.instance.getCurrencySymbolForListing(Country: gpscountry)
            self.maxTextField.text = currencySymbol
          
        }
        else if textField == minTextField{
            let currencySymbol = CurrencyManager.instance.getCurrencySymbolForListing(Country: gpscountry)
            self.minTextField.text = currencySymbol
          
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == Countrylist {
            let vc = storyboard!.instantiateViewController(withIdentifier: "FilterLocationVC") as! FilterLocationVC
            vc.selectionDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
   
//      func  textFieldShouldReturn(_ textField: UITextField){
//        if textField == maxTextField {
//          UserDefaults.standard.setValue(maxTextField.text, forKey: "max")
//        }
//        if textField == minTextField {
//           UserDefaults.standard.setValue(maxTextField.text, forKey: "min")
//        }
//      }
    }
  func  textFieldDidEndEditing(_ textField: UITextField) {
       if textField == maxTextField {
         UserDefaults.standard.setValue(maxTextField.text, forKey: "max")
       }
       if textField == minTextField {
          UserDefaults.standard.setValue(minTextField.text, forKey: "min")
       }
       }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if  textField == maxTextField || textField == minTextField {
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


protocol filtersVCDelegate: class {
    func getFilterData(param:[String:Any])
}
extension FiltersVc: LocationSelectionDelegate {
  
  
    func didTappedLocation(LocName: String, Lat: Double, Longitude: Double, country: String, provience: String) {
        self.Countrylist.text = LocName + "," + provience + country
      UserDefaults.standard.set(self.Countrylist.text, forKey: "location")
        self.latitude = Lat
        self.longitude = Longitude
        self.countryName = country
        self.cityAndStateName = LocName + "," + country
        self.maxTextField.becomeFirstResponder()
        let Country = country.uppercased()
        let CurrencySymbol = CurrencyManager.instance.getCurrencySymbolForListing(Country: Country)
        print(CurrencySymbol)
       self.maxTextField.placeholder = "\(CurrencySymbol) Max"
        self.minTextField.placeholder = "\(CurrencySymbol) Min"
      UserDefaults.standard.set(CurrencySymbol, forKey: "symbol")
        
    }
}

