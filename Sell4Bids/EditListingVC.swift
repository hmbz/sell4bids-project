//
//  EditListingVC.swift
//  Sell4Bids
//
//  Created by MAC on 05/09/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import TGPControls
import Firebase
import SwiftMessages

class EditListingVC: UIViewController {
  var db = FirebaseDB.shared
    

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityStockLabel: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
  @IBOutlet weak var conditionSlider: TGPDiscreteSlider!
  
  @IBOutlet weak var viewAcceptOffers: UIView!
  @IBOutlet weak var viewAutoRelist: UIView!
  @IBOutlet weak var viewListIndefinitely: UIView!
  @IBOutlet weak var btnUpdateAll: UIButton!
  
  @IBOutlet weak var btnCheckAcceptOffers: UIButton!
  @IBOutlet weak var btnCheckAutoRelist: UIButton!
  @IBOutlet weak var btnCheckListIndefinitely: UIButton!
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var lblConditionValue: xLargeBold!
  
  @IBOutlet weak var tfPrice: DesignableUITextField!
  
  @IBOutlet weak var tfQuantity: DesignableUITextField!
  
  @IBOutlet weak var viewTitle: UIView!
    
    @IBOutlet weak var titleLbl: xLargeBold!
    @IBOutlet weak var descriptionLbl: xLargeBold!
    @IBOutlet weak var conditionlbl: xLargeBold!
    @IBOutlet weak var AcceptOfferLbl: LargeBold!
    @IBOutlet weak var automaticLbl: LargeBold!
    
    @IBOutlet weak var listindefinitelyLbl: LargeBold!
    
    var price = Int()
    var quantityInStock = Int()
    var isFlagNonReserved = Bool()
   
    var isJob = Bool()
    
     var jobSkillsList = ["Other (see description)","Easy","Average","Above average","High","Extreme"]
    
    var conditionList = ["Other (see description)","For Parts","Used","Reconditioned","Open box / like new","New"]
    var productDetail : Products?
      var product : ProductModel?
    
    @objc func handleValueChange(_ sender: TGPDiscreteSlider)
    {
         guard let productData = product else { return }
        let value = Int(sender.value)
        print("Value == \(sender.value)")
        print("isjob ==\(isJob)")
        if let condition = productData.condition, let conditionInt = Int(condition) {
            conditionValue = conditionInt
          
        }
        if isJob == true{
            
            self.lblConditionValue.text = jobSkillsList[value]
            self.conditionValue = value
        }
        else{
            self.lblConditionValue.text = conditionList[value]
            self.conditionValue = value
        }
        
        
    }



    var conditionValue = Int()
    var acceptoffervalue = Bool()
    var autoReListvalue = Bool()
    
 
    var currentStartPrice : String?
  override func viewDidLoad() {
    super.viewDidLoad()
    // Change By Osama Mansoori
    
    ForLanguageChange()
    
    btnUpdateAll.layer.borderColor = UIColor.black.cgColor
    btnUpdateAll.layer.borderWidth = 2
    btnUpdateAll.layer.cornerRadius = 8
    btnCheckAutoRelist.layer.borderColor = UIColor.black.cgColor
    btnCheckAutoRelist.layer.borderWidth = 2
    btnCheckAutoRelist.layer.cornerRadius = 8
    btnCheckAcceptOffers.layer.borderColor = UIColor.black.cgColor
    btnCheckAcceptOffers.layer.borderWidth = 2
    btnCheckAcceptOffers.layer.cornerRadius = 8
    btnCheckListIndefinitely.layer.borderColor = UIColor.black.cgColor
    btnCheckListIndefinitely.layer.borderWidth = 2
    btnCheckListIndefinitely.layer.cornerRadius = 8
    
    print("\(product!.auctionType)")
    
    if product!.auctionType! == "Non-reserve" || product!.auctionType! == "reserve" {
        self.priceLabel.text = "Starting Price".localizableString(loc: LanguageChangeCode)
        self.quantityStockLabel.text = "Reserve Price".localizableString(loc: LanguageChangeCode)
        isFlagNonReserved = true
        print("Action Price = ")
        
    }else {
        self.priceLabel.text = "Price"
        self.quantityStockLabel.text = "Quantity in Stock"
        isFlagNonReserved = false
        print("Action Quantity = ")
    }
    
    setupWithData()
  conditionSlider.addTarget(self, action: #selector(handleValueChange(_:)), for: .valueChanged)
     self.lblConditionValue.text = conditionList[conditionValue]
    setupViews()
  
    
    
  }
    // Change By Osama Mansoori
    func ForLanguageChange(){
        btnUpdateAll.setTitle("Update All".localizableString(loc: LanguageChangeCode), for: .normal)
        titleLbl.text = "Title".localizableString(loc: LanguageChangeCode)
        descriptionLbl.text = "Description".localizableString(loc: LanguageChangeCode)
         conditionlbl.text = "Condition".localizableString(loc: LanguageChangeCode)
        lblConditionValue.text = "ConditionValue".localizableString(loc: LanguageChangeCode)
        priceLabel.text = "Price".localizableString(loc: LanguageChangeCode)
        quantityStockLabel.text = "Quantity in Stock".localizableString(loc: LanguageChangeCode)
        AcceptOfferLbl.text = "Accept Offers".localizableString(loc: LanguageChangeCode)
        automaticLbl.text = "Automatic Relisting".localizableString(loc: LanguageChangeCode)
        listindefinitelyLbl.text = "List Indefinitely".localizableString(loc: LanguageChangeCode)
        
        titleLbl.rightAlign(LanguageCode: LanguageChangeCode)
        descriptionLbl.rightAlign(LanguageCode: LanguageChangeCode)
        conditionlbl.rightAlign(LanguageCode: LanguageChangeCode)
        AcceptOfferLbl.rightAlign(LanguageCode: LanguageChangeCode)
        automaticLbl.rightAlign(LanguageCode: LanguageChangeCode)
        listindefinitelyLbl.rightAlign(LanguageCode: LanguageChangeCode)
    }

  private func setupWithData() {
    guard let productData = product else { return }
    print("Product Key = \(productData.productKey!)")
    titleTextField.text = productData.title ?? ""
    descriptionTextView.text = productData.description ?? ""
   
    
    
    
    if let priceInt = productData.startPrice {
        tfPrice.text = "\(("$"))" + "\(priceInt)"
    }
    
    if let quantityInt = productData.quantity {
      tfQuantity.text = "\(quantityInt)"
    }
  }
  // Change by Osama Mansoori
    
  private func setupViews() {
    
    textViewDescription.makeRedAndRound()
    conditionSlider.makeRedAndRound()
    viewAcceptOffers.makeRedAndRound()
    viewAutoRelist.makeRedAndRound()
    viewListIndefinitely.makeRedAndRound()
    
   // btnCheckAcceptOffers.makeRedAndRound()
   // btnCheckAutoRelist.makeRedAndRound()
   //  btnCheckListIndefinitely.makeRedAndRound()
    
   // btnUpdateAll.addShadowAndRound()
    tfPrice.makeRedAndRound()
    tfQuantity.makeRedAndRound()
    viewTitle.addShadowAndRound()
  }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if product!.auctionType! == "Non-reserve" || product!.auctionType! == "reserve" {
            self.priceLabel.text = "Starting Price"
            self.quantityStockLabel.text = "Reserve Price"
            isFlagNonReserved = true
            self.viewAcceptOffers.isHidden = true
            self.viewListIndefinitely.isHidden = true
            print("Auction = ")
            
        }else {
            self.priceLabel.text = "Price"
            self.quantityStockLabel.text = "Quantity in Stock"
            isFlagNonReserved = false
            print("buying = ")
        }
    }
  let strDetailedDesOfItem = "Detailed description of your item"
    
    @IBAction func TouchCancel(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.clear
        sender.setTitleColor(UIColor.black, for: .normal)
        
    }
    
  //MARK:- Actions
  @IBAction func btnUpdateAllTapped(_ sender: UIButton) {
   
    sender.backgroundColor = UIColor.black
    sender.setTitleColor(UIColor.white, for: .normal)
    
    if (titleTextField.text?.isEmpty)! && descriptionTextView.text.isEmpty && (tfPrice.text?.isEmpty)! && (tfQuantity.text?.isEmpty)! {
        showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "Please enter required number of characters".localizableString(loc: LanguageChangeCode))
        
    }else if descriptionTextView.text.count < 20 || descriptionTextView.text.count > 1500 {
        showSwiftMessageWithParams(theme: .error, title: "Description Error", body: "Please enter minimum 20 and maximum 1500 characters".localizableString(loc: LanguageChangeCode))
        return
        
    }else if titleTextField.text!.count < 5 || (titleTextField.text?.count)! > 20 {
        
        showSwiftMessageWithParams(theme: .error, title: "Title Error", body: "Please enter minimum 5 and maximum 20 characters".localizableString(loc: LanguageChangeCode))
        
    }else if tfPrice.text!.count > 6 {
        showSwiftMessageWithParams(theme: .error, title: "Price Error", body: "Please enter minimum 1 and maximum 6 characters".localizableString(loc: LanguageChangeCode))
        
    }else if (tfQuantity.text?.count)! > 6 {
        showSwiftMessageWithParams(theme: .error, title: "Quantity Error", body: "Please enter minimum 1 and maximum 6 characters.".localizableString(loc: LanguageChangeCode))
        
    }else {
        let dbRef = Database.database().reference()
        
        
        
        
        let dic = ["description":self.descriptionTextView.text! ,"startPrice": self.tfPrice.text! , "quantity" : self.tfQuantity.text! , "conditionValue" :  lblConditionValue.text! , "title" : titleTextField.text! , "acceptOffers" : acceptoffervalue.description , "autoReList" : autoReListvalue.description ] as [String : String]
        print("Dic = \(dic)")
        
        let des =   dbRef.child("products").child((product?.categoryName)!).child(product!.auctionType!).child(product!.state!).child((product?.productKey!)!)
        let des1 = dbRef.child("items").child((product?.productKey)!)
        //
        //des1.updateChildValues(dic)
        
        des1.updateChildValues(dic) { (error, snapshot) in
            if error == nil {
                showSwiftMessageWithParams( theme: .info, title: "Edit listing", body: "Edit listing successfully completed.".localizableString(loc: LanguageChangeCode))
            }else {
                showSwiftMessageWithParams( theme: .info, title: "Edit Listing", body: "Edit Listing not completed.".localizableString(loc: LanguageChangeCode))
            }
        }
        
        des.updateChildValues(dic) { (error, snapshot) in
            print("Snap = \(snapshot)")
            print("error = \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
   
   
    
    }
    
    
    
  @IBAction func btnAcceptOffersTapped(_ sender: UIButton) {
    
    sender.backgroundColor = UIColor.black
    sender.setTitleColor(UIColor.white, for: .normal)
    
    sender.isSelected = !sender.isSelected
    acceptoffervalue = !sender.isSelected
  }
  
  @IBAction func btnAutoRelistTapped(_ sender: UIButton) {
    
    sender.backgroundColor = UIColor.black
    sender.setTitleColor(UIColor.white, for: .normal)
    
    sender.isSelected = !sender.isSelected
    autoReListvalue = !sender.isSelected
  }
 
  @IBAction func btnListIndefTapped(_ sender: UIButton) {
    
    sender.backgroundColor = UIColor.black
    sender.setTitleColor(UIColor.white, for: .normal)
    
    sender.isSelected = !sender.isSelected
  }
  
}
