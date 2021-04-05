//
//  StepTwoVC.swift
//  socialLogins
//
//  Created by H.M.Ali on 10/4/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import JKDropDown
import TGPControls
import Alamofire
import SwiftyJSON


class StepTwoVC: UIViewController,UITextFieldDelegate, UITextViewDelegate , BackButtonActionDelegate   {
  
    var VINNo : String?
    var VehiclesDetailsHeading = ["Made In","Year","Trim","Overall Length","Highway Miles","Antibrake System","Make","Steering Type","Cylinders","Engine","Model"]
    var VehiclesDetailsText = [String]()
    
    
    func pressFinished(text: VINNumber) {
        print("Called Delegate VIN")
        VINNo = text.VinNo
    }
    
   
    
 
    
    
    
    
    
    

    
    
    
  //MARK:- Properties
  @IBOutlet weak var conditionTitleLabel: UILabel!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var conditionLabel: UILabel!
  @IBOutlet weak var slider: TGPDiscreteSlider!
  @IBOutlet weak var top: UIView!
  @IBOutlet weak var buttonSelect: UIButton!
  @IBOutlet weak var nextBtn: DesignableButton!
  var defaults = UserDefaults.standard
  var VinNumber = String()
    
    @IBOutlet weak var VinNumberText: UITextField!
    @IBOutlet weak var DescribationTextviewWidth: NSLayoutConstraint!
    @IBOutlet weak var DescribationWidht: NSLayoutConstraint!
    
    
    // Change By Osama Mansoori
    @IBOutlet weak var CategoryLbl: UILabel!
    @IBOutlet weak var DescriptionLbl: xLargeBold!
    @IBOutlet weak var VINNumberLbl: UILabel!
    
  //MARK:- Variables
  var buttonFrame : CGRect?
  var dropDownObject: JKDropDown? = JKDropDown()
  var category: String = ""
  var iscategory = false
  var consitionValue = 0
  var jobValues = [String:Any]()
    var itemsValues = [String : Any]()
    var vehiclesValues = [String : Any]()
  var isJob = false
    var isVehicle = false
    var isItem = false
  var picker = UIPickerView()
    var Made_in = String()
    var Year = String()
    var Trim = String()
    var OverallLenght = String()
    var HighwayMiles = String()
    var AntibrakeSystem = String()
    var Make = String()
    var Steering = String()
    var Cylinders = String()
    var Engine = String()
    var Model = String()
    
    @IBOutlet weak var ViewBarCode: UIButton!
    
    
   
    
  
  var jobCategory = ["Accounting & Finance","Admin", "Automotive", "Business", "Construction", "Creative", "Customer Services", "Education", "Engineering",
                     "Food & Restaurants", "Healthcare", "Hotel & Hospitality", "Human Resources", "Labor", "Manufacturing", "Marketing", "Personal Care", "Real Estate",
                     "Retail & Wholesale", "Sales", "Salon, Spa & Fitness", "Security", "Skilled Trade & Craft", "Technical Support", "Transportation",
                     "TV, Film & Video", "Web & Info Design", "Writing & Editing", "Other", "Maintenance & Installation", "Office"]
  
  
  var conditionList = ["Other (see description)","For Parts","Used","Reconditioned","Open box / like new","New"]
  var jobSkillsList = ["Other (see description)","Easy","Average","Above average","High","Extreme"]
  var categories = ["Accessories","Antiques", "Arts & Crafts", "Baby & Kids", "Bags",
                    "Boats & Marines","Books","Business Equipments", "Campers & RVs","Cars & Accessories",
                    "CDs and DVDs","Clothing","Collectible Toys","Computers & Accessories","Costumes",
                    "Coupons", "Electronics","Exercise","Fashion", "Free & Donations",
                    "Furniture","Gadgets","Games","Halloween","Hobbies",
                    "Home Decor","Home & Garden","Household Appliances","Kids Toys", "Jewelry",
                    "Makeup & Beauty","Motorcycles & Accessories","Musical Equipments","Outdoor & Camping","Pet Accessories",
                    "Tickets","Tools","Phone & Tablets","Shoes","Sports Equipment",
                    "Video Games","Wallets","Watches","Wedding"]
  
  
  
  @IBOutlet weak var viewProdCategory: UIView!
  @IBOutlet weak var viewProdCondition: UIView!
  @IBOutlet weak var viewDescription: UIView!
  
  var previousData = [String:Any]()
  //MARK:- View Life Cycle
   
    
   
    
    fileprivate func addDoneLeftBarBtn() {
        
        let barbuttonHome = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(self.barBtnInNav))
        barbuttonHome.image = UIImage(named: "BackArrow24")
        
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        
        self.navigationItem.leftBarButtonItems = [barbuttonHome, barButton]
    }
    @objc func barBtnInNav() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func getVinDetails() {
        let value = GlocalVINNO?.split(separator: "I")
        DispatchQueue.main.async {
            self.VinNumber =  String((value?[0] ?? ""))
            self.VinNumberText.text = String((value?[0] ?? ""))
            let url = "http://api.marketcheck.com/v1/vin/\(value?[0] ?? " " )/specs?api_key=7RlHupav8leC7Y4TsGdMJyixbTAkylLS"
            
            
            let header = ["Host": "marketcheck-prod.apigee.net"] as! HTTPHeaders
            Alamofire.request(url, method: .get , encoding: JSONEncoding.default , headers : header).responseJSON { (request) in
                
                switch(request.result) {
                    
                    
                case .success(_):
                    let swiftymessage = JSON(request.result.value)
                    
                    print("Value = \(swiftymessage)")
                    
                    self.Made_in = swiftymessage["made_in"].stringValue
                    self.VehiclesDetailsText.append(self.Made_in)
                    self.Year = swiftymessage["year"].stringValue
                    self.VehiclesDetailsText.append(self.Year)
                    self.Trim = swiftymessage["trim"].stringValue
                    self.VehiclesDetailsText.append(self.Trim)
                    self.OverallLenght = swiftymessage["overall_length"].stringValue
                    self.VehiclesDetailsText.append(self.OverallLenght)
                    self.HighwayMiles = swiftymessage["highway_miles"].stringValue
                    self.VehiclesDetailsText.append(self.HighwayMiles)
                    self.AntibrakeSystem = swiftymessage["antibrake_sys"].stringValue
                    self.VehiclesDetailsText.append(self.AntibrakeSystem)
                    self.Make = swiftymessage["make"].stringValue
                    self.VehiclesDetailsText.append(self.Make)
                    self.Steering = swiftymessage["steering_type"].stringValue
                    self.VehiclesDetailsText.append(self.Steering)
                    self.Cylinders = swiftymessage["cylinders"].stringValue
                    self.VehiclesDetailsText.append(self.Cylinders)
                    self.Engine = swiftymessage["engine"].stringValue
                    self.VehiclesDetailsText.append(self.Engine)
                    self.Model = swiftymessage["model"].stringValue
                    self.VehiclesDetailsText.append(self.Model)
                    
                    
                    let storyboard = UIStoryboard.init(name: "sellTab", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "ShowVehiclesDetails") as? VehcilesDetailsVC
                    controller!.title = "Vehicles Details"
                    controller!.VehiclesDetailsHeading = self.VehiclesDetailsHeading
                    controller!.VehiclesDeailsText = self.VehiclesDetailsText
                    
                    
                    self.navigationController?.pushViewController(controller!, animated: true)
                    
                    
                    
                case .failure(let error):
                    print("Error = \(error)")
                }
                
                
            }
            
        }
    }
  override func viewDidLoad() {
    super.viewDidLoad()
    // Changes by Osama Mansoori.
    
    ForLanguageChange()
    nextBtn.layer.borderColor = UIColor.black.cgColor
    nextBtn.layer.borderWidth = 2
    nextBtn.layer.cornerRadius = 8
    self.VinNumberText.delegate = self
    
    //if item was not posted it retrive data from System
    //Ahmed Baloch
    
    print("Finished == \(Finished) , isJob \(isJob)")

    
    if Finished == false {
    if isJob {
        
        if self.defaults.value(forKey: "JobDescription") as? String != nil {
            let description = self.defaults.value(forKey: "JobDescription") as? String
            descriptionTextView.text = description!
        }
        
        
        
        if self.defaults.value(forKey: "JobCondition") as? Int != nil {
            let savedValue = self.defaults.value(forKey: "JobCondition") as? CGFloat
            let value = self.defaults.value(forKey: "JobCondition") as? Int
            self.conditionLabel.text = jobSkillsList[value!]
            self.slider.value = savedValue!
        }
        
        if self.defaults.value(forKey: "JobCategory") as? String != nil {
            let savedJobCategory = self.defaults.value(forKey: "JobCategory") as? String
             self.buttonSelect.setTitle(savedJobCategory, for: .normal)
        }
    }else {
        
        
        
        if self.defaults.value(forKey: "category") as? String != nil {
        let category = self.defaults.value(forKey: "category") as? String
           self.buttonSelect.setTitle(category, for: .normal)
        }
        
        if self.defaults.value(forKey: "description") as? String != nil {
            let description = self.defaults.value(forKey: "description") as? String
            descriptionTextView.text = description!
        }
        
        
        
        
        if self.defaults.value(forKey: "condition") as? Int != nil {
            let savedValue = self.defaults.value(forKey: "condition") as? CGFloat
            let value = self.defaults.value(forKey: "condition") as? Int
            self.conditionLabel.text = conditionList[value!]
            self.slider.value = savedValue!
        }
        
    }
    }
    
    
    
    
    
     addLeftHomeBarButtonToTop()
     addDoneLeftBarBtn()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    navigationItem.title = "Describe item"
    buttonFrame = view.convert(buttonSelect.frame, to: view)
    slider.addTarget(self, action: #selector(handleValueChange(_:)), for: .valueChanged)
    descriptionTextView.textColor = UIColor.darkGray
    descriptionTextView.delegate = self
    descriptionTextView.layer.borderWidth = 2
    descriptionTextView.layer.borderColor = UIColor.red.cgColor

    slider.layer.borderWidth = 2
    slider.layer.borderColor = UIColor.red.cgColor
    

    NotificationCenter.default.addObserver(self, selector: #selector(valueSelected(_:)), name: Notification.Name("ValueSelected"), object: nil)
    // nextBtn.addShadowView()
 
    
//    if isJob == true{
//        conditionTitleLabel.text = "Toughness"
//        buttonSelect.setTitle("Select Job Category", for: .normal)
//        //descriptionTextView.text = "Detail description of job."
//        descriptionTextView.textColor = UIColor.darkGray
//    }
//    else{
//        conditionTitleLabel.text = "Condition"
//         buttonSelect.setTitle("Select Category", for: .normal)
//
//        //descriptionTextView.text = "Detail description of your item."
//        descriptionTextView.textColor = UIColor.darkGray
//    }
    setupViews()
    
  }
    
    
    // Change By Osama Mansoori
    func ForLanguageChange(){
        buttonSelect.setTitle("SelectCategorySTVC".localizableString(loc: LanguageChangeCode), for: .normal)
        nextBtn.setTitle("NextBtnSTVC".localizableString(loc: LanguageChangeCode), for: .normal)
        CategoryLbl.text = "CategorySTVC".localizableString(loc: LanguageChangeCode)
        conditionTitleLabel.text = "ConditionTitleLblSTVC".localizableString(loc: LanguageChangeCode)
        DescriptionLbl.text = "DescriptionSTVC".localizableString(loc: LanguageChangeCode)
        VINNumberLbl.text = "VIMNumberSTVC".localizableString(loc: LanguageChangeCode)
        
        
        // Right Align Implementation
        // Change By Osama Mansoori
        
        CategoryLbl.rightAlign(LanguageCode: LanguageChangeCode)
        DescriptionLbl.rightAlign(LanguageCode: LanguageChangeCode)
        conditionTitleLabel.rightAlign(LanguageCode: LanguageChangeCode)
        VINNumberLbl.rightAlign(LanguageCode: LanguageChangeCode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let value = GlocalVINNO?.split(separator: "I")
   
            self.VinNumberText.text = String((value?[0] ?? ""))
        if !(VinNumberText.text?.isEmpty)! {
            let button = UIButton()
            button.setImage(UIImage(named: "eye.png"), for: .normal)
            button.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
            button.addTarget(self, action: #selector(getVinDetails), for: .touchUpInside)
            self.VinNumberText.rightViewMode = .always
            self.VinNumberText.rightView = button
        }
        
        
        }
        
//        if defaults.value(forKey: "category") != nil {
//            let titlecategory = defaults.value(forKey: "category") as? String
//            print("titlecategory = \(titlecategory!)")
//            
//            self.buttonSelect.setTitle(titlecategory!, for: .normal)
//        }
//        
//        if defaults.value(forKey: "condition") != nil {
//            let condition = defaults.value(forKey: "condition") as? Int
//            print("condition = \(condition!)")
//            self.conditionLabel.text = jobSkillsList[condition!]
//            self.consitionValue = condition!
//        }
//        
//        if defaults.value(forKey: "description") != nil {
//            let descriptiontext = defaults.value(forKey: "description") as? String
//            print("descriptiontext = \(descriptiontext!)")
//            self.descriptionTextView.text = descriptiontext!
//        }
//        
        
        
    
  
  private func setupViews() {
    
    if Finished {
    var textViewText = strDetailedDesOfItem
    if self.isJob { textViewText = strDetailedDescOfJob }
    descriptionTextView.tintColor = UIColor.black
    DispatchQueue.main.async {
      self.descriptionTextView.text = textViewText
    }
    }
    viewProdCategory.addShadow()
    viewProdCondition.addShadow()
    viewDescription.addShadow()
    buttonSelect.makeRedAndRound()
    slider.makeRedAndRound()
    descriptionTextView.makeRedAndRound()
    // Changes By Osama Mansoori.
    
    // nextBtn.addShadowAndRound()
    
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    buttonFrame = view.convert(buttonSelect.frame, to: view)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first{
      
      
      if descriptionTextView.isFirstResponder == true{
        if touch.view != self.descriptionTextView{
          descriptionTextView.resignFirstResponder()
        }
      }
      
    }
  }
  
  @IBAction func btnSelectACategoryTapped(_ sender: Any) {
    
    self.performSegue(withIdentifier: "stepTwoToSelectACat", sender: isJob)
    
   
  }
  
  @objc func handleValueChange(_ sender: TGPDiscreteSlider)
  {
    let value = Int(sender.value)
    print("Value == \(sender.value)")
    print("isjob ==\(isJob)")
    if isJob == true{
      
      self.conditionLabel.text = jobSkillsList[value]
         self.consitionValue = value
    }
    else{
        
        
      self.conditionLabel.text = conditionList[value]
         self.consitionValue = value
    }

   
  }
  
  let strDetailedDesOfItem = "Detailed description of your item"
  let strDetailedDescOfJob = "Detailed description of Job"
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView == descriptionTextView{
      DispatchQueue.main.async {
        let text = textView.text
        if text == self.strDetailedDescOfJob || text == self.strDetailedDesOfItem {
          textView.textColor = UIColor.black
          textView.text = ""
        }
      }
      
      
    }
  }

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
   
    if textView == descriptionTextView{
      if text == "\n"{
        
        textView.resignFirstResponder()
        return true
      }
    }
    return true
  }
    
    

    
  func textViewDidEndEditing(_ textView: UITextView) {
 
   
    if textView == descriptionTextView{
        
      if textView.text == ""{
        textView.textColor = UIColor.darkGray
        if self.isJob {
            textView.text = strDetailedDescOfJob
        }else {
            textView.text = strDetailedDesOfItem
        }
        
      }
    }
  }
  
  @objc func valueSelected(_ notification: Notification){
    
    let value = notification.object as! String
   
    self.buttonSelect.setTitle("\(value)", for: .normal)
   
    
  }
    
    @IBAction func TouchCancel(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.clear
        sender.setTitleColor(UIColor.black, for: .normal)
        
    }
  
  @IBAction func nextBtnAction(_ sender: Any) {
    
    nextBtn.backgroundColor = UIColor.black
    nextBtn.setTitleColor(UIColor.white, for: .normal)
    
    //Save Half Data on System.
    //Ahmed Baloch
    print("isFinished == \(Finished)")
    if Finished == false {
    if isJob {
        self.defaults.set(descriptionTextView.text, forKey: "JobDescription")
        
        self.defaults.set(self.buttonSelect.titleLabel?.text, forKey: "JobCategory")
        
        self.defaults.set(self.slider.value, forKey: "JobCondition")
        
    }else {
        print("Next Category == \(self.buttonSelect.titleLabel?.text)")
          self.defaults.setValue(self.buttonSelect.titleLabel?.text!, forKey: "category")
        
        self.defaults.set(self.slider.value, forKey: "condition")
        
        self.defaults.set(descriptionTextView.text!, forKey: "description")
    }
    }
    
    
    var dic = [String:Any]()
    guard let category = self.buttonSelect.title(for: .normal) else{
      
      
        showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "Please select related category.")
      return
    }
    if isJob == true{
      if  self.buttonSelect.titleLabel?.text == "Select Job Category" {
        buttonSelect.shake()
        showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "Please Select a Job Category to Proceed")
       
        
        return
      }
    }else{
      if  self.buttonSelect.titleLabel?.text == "Select Category" {
        //self.alert(message: "Please select a product Category to Proceed ", title: "Select Category")
        
        
        buttonSelect.shake()
        showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "Please select a product Category to Proceed")
        
        return
      }
    }
    
    
    guard let condition = self.conditionLabel.text else{
      
     
        showSwiftMessageWithParams(theme: .error, title: "Description Error", body: "Please select the condition.")
      return
    }
    var description = ""
    if self.descriptionTextView.text != nil && self.descriptionTextView.text != ""{
        if self.descriptionTextView.text.count < 20 || self.descriptionTextView.text.count > 1500    {
            showSwiftMessageWithParams(theme: .error, title: "Description Error", body: "Please enter minimum 20 and maximum 1500 characters.")
            return
            
        }else if self.descriptionTextView.text != strDetailedDesOfItem{
        description = self.descriptionTextView.text
      } else{
        
         showSwiftMessageWithParams(theme: .error, title: "Description Error", body: "Please enter detail description of your  item,so that buyers can understand what you are offering.")
        
        
        
     
        return
      }
      
    }
    else{
     
        showSwiftMessageWithParams(theme: .error, title: "Description Error", body: "Please enter detail description of your  item,so that buyers can understand what you are offering.")
      return
    }
   
    
    
    if isJob == true{
        let conditiontext = self.consitionValue as! Int
        
        
        print("conditiontext = \(conditiontext)")
        
        
      dic = ["title":self.jobValues["title"],"employmentType":self.jobValues["employmentType"],"benefits":self.jobValues["benefits"],"category":category as! String,"condition":condition as! String,"conditionValue":self.consitionValue as! Int,"description":description as! String] as [String: Any]
      
    }
      
    else if isItem == true {
        
        
       
      dic = ["images": previousData["imageList"] as! [UIImage],"title":self.previousData["title"] as! String, "category":category as! String,"condition":condition as! String,"conditionValue":self.consitionValue as! Int,"description":description as! String] as [String: Any]
        
       
        
        let conditiontext = self.consitionValue as! Int
        
        
        print("conditiontext = \(conditiontext)")
        
      
        
        print("Description Text = \(descriptionTextView.text!)")
        
        
        print("Selected Category = \(String(describing: buttonSelect.titleLabel?.text))")
    }else if isVehicle == true {
        
    
        dic = ["images": previousData["imageList"] as! [UIImage],"title":self.previousData["title"] as! String, "category":category ,"condition":condition ,"conditionValue":self.consitionValue ,"VinNumber": VinNumber as! String, "Made_in" : self.Made_in as! String , "Year": self.Year as! String, "Trim" : self.Trim as! String , "OverallLenght" : self.OverallLenght , "HighwayMiles" :  self.HighwayMiles , "AntibrakeSystem" : self.AntibrakeSystem as! String , "Make" : self.Make as! String , "Steering" : self.Steering , "Cylinders" : self.Cylinders , "Engine" : self.Engine as! String , "Model" :  self.Model as! String ] as [String: Any]
        
        
    
    
    }
    
    
    
    
    performSegue(withIdentifier: "fromStep2ToStep3", sender: dic)
  }
  
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
////    if segue.identifier == "ali"{
////
////      let data = sender as! Bool
////      let destination = segue.destination as! SelectACategoryOpt
////      destination.isJob = self.isJob
////
////
////    }
//    if segue.identifier == "fromStep2ToStep3"{
//      let destination = segue.destination as! Step3VC
//      destination.previousData = sender as! [String:Any]
//      if isJob == true{
//        destination.isJob = true
//      }
//      else if isItem == true {
//        destination.isItem = true
//      }else if isVehicle == true {
//        destination.isVehicle = true
//        }
//    }
//    if segue.identifier == "stepTwoToSelectACat" {
////      guard let dest = segue.destination as? SelectACategoryOpt else {
//        return
//      }
//      dest.isJob = self.isJob
//      dest.delegate = self
//    }
    
  }
  

//extension StepTwoVC: SelectACategoryVCDelegate {
//  func categorySelected(catName: String) {
//
//    if catName.contains("Vehicles")  {
//        self.DescribationWidht.constant = 0
//        self.DescribationTextviewWidth.constant = 0
//    }else {
//        self.DescribationWidht.constant = 151
//        self.DescribationTextviewWidth.constant = 115
//    }
//    DispatchQueue.main.async {
//
//       self.buttonSelect.setTitle(catName, for: .normal)
//
//
//  }
//}
//}

