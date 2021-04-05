//
//  producDetailPopUpVC.swift
//  Sell4Bids
//
//  Created by H.M.Ali on 11/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class UpdateProdQuantityPopUpVC: UIViewController,UITextFieldDelegate {
  //MARK:- Properties
  @IBOutlet weak var btnSetQuantity: UIButton!
  weak var delegate: UpdateProdQuantityPopUpVCDelegate!
  @IBOutlet weak var popUpView: UIView!
  @IBOutlet weak var quantityTFO: UITextField!
    @IBOutlet weak var QuantityinStockLbl: UILabel!
    //MARK:- Variables
  var previousData = [String:Any]()
    
    // Changes By Osama Mansoori
    
  override func viewDidLoad() {
    super.viewDidLoad()
    ForLanguageChange()
    btnSetQuantity.layer.borderColor = UIColor.black.cgColor
    btnSetQuantity.layer.borderWidth = 2
    btnSetQuantity.layer.cornerRadius = 8
    
    quantityTFO.delegate = self
    DispatchQueue.main.async {
      self.quantityTFO.becomeFirstResponder()
    }
    // Do any additional setup after loading the view.
    popUpView.layer.cornerRadius = 8
    popUpView.clipsToBounds = true
    quantityTFO.makeRedAndRound()
    btnSetQuantity.addShadowAndRound()
    
  }
    
    func ForLanguageChange(){
        btnSetQuantity.setTitle("SetQuantity".localizableString(loc: LanguageChangeCode), for: .normal)
        QuantityinStockLbl.text = "QuantityinStock".localizableString(loc: LanguageChangeCode)
    }
    
    // Changes by Osama Mansoori.
    @IBAction func TouchCancel(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.clear
        sender.setTitleColor(UIColor.black, for: .normal)
        
    }
    
    // Changes By Osama Mansoori
  @IBAction func setQuantityBtnAction(_ sender: UIButton) {
    
    sender.backgroundColor = UIColor.black
    sender.setTitleColor(UIColor.white, for: .normal)
    
    guard let category = previousData["category"] as? String else{
      self.alert(message: "No category found", title: "ERROR".localizableString(loc: LanguageChangeCode))
      return
    }
    guard let state = previousData["state"] as? String else{
      self.alert(message: "No state found", title: "ERROR".localizableString(loc: LanguageChangeCode))
      return
    }
    guard let type = previousData["auctionType"] as? String else{
      self.alert(message: "No Auction Type found", title: "ERROR".localizableString(loc: LanguageChangeCode))
      return
    }
    guard let id = previousData["id"] as? String else{
      self.alert(message: "No ID found", title: "ERROR".localizableString(loc: LanguageChangeCode))
      return
    }
    
    guard !(quantityTFO.text?.isEmpty)! else{
      self.alert(message: "Please Enter the quantity", title: "No Quantity")
      return
    }
    let quantity = quantityTFO.text!
    let ref = Database.database().reference().child("products").child(category).child(type).child(state).child(id)
    let dic = ["quantity":quantity]
    ref.updateChildValues(dic)
    
    
    let alert = UIAlertController(title: "Quantity changed", message: "Quantity Updated Successfully", preferredStyle: .alert)
    delegate.quantityUpdated(quantity: quantity)
    let ok = UIAlertAction(title: "Ok".localizableString(loc: LanguageChangeCode), style: .default) { (action) in
      self.dismiss(animated: true, completion: nil)
    }
    alert.addAction(ok)
    self.present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func dismisViewBtnAction(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == quantityTFO {
      let temp = string
      let allowedCharacters = CharacterSet.decimalDigits
      let characterSet = CharacterSet(charactersIn: temp)
      let result = allowedCharacters.isSuperset(of: characterSet)
      if result == false{
        let alert = UIAlertController(title: "ERROR".localizableString(loc: LanguageChangeCode), message: "Please enter Numbers only", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok".localizableString(loc: LanguageChangeCode), style: .default, handler: { (action) in
          //textField.text = "$"
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
      }
      return true
    }
    return true
  }
  
}

protocol  UpdateProdQuantityPopUpVCDelegate : class{
  func quantityUpdated(quantity: String)
}
