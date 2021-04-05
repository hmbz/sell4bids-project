//
//  ItemListingTwoVC.swift
//  Sell4Bids
//
//  Created by admin on 07/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import TGPControls


class ItemListingTwoVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var CategoryView: UIView!
    @IBOutlet weak var ConditionView: UIView!
    @IBOutlet weak var DescriptionView: UIView!
    @IBOutlet weak var SelectCategoryName: UIButton!
    @IBOutlet weak var Descriptiontext: UITextView!
    @IBOutlet weak var ConditionValueTextField: UITextField!
    @IBOutlet var descriptionTextHeight: NSLayoutConstraint!
    @IBOutlet var descriptionTextborderLbl: UILabel!
    
    var conditionList = [String]()
    
    @IBAction func btnSelectACategoryTapped(_ sender: Any) {
        
        
        let mainStoryboard = UIStoryboard(name: "Main_Listing_Sell", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "SelectCategory") as! SelectItemCategory
        
        self.present(homeViewController, animated: true, completion: nil)
        
        
    }
    
//    func adjustTextViewHeight() {
//        let fixedWidth = Descriptiontext.frame.size.width
//        let newSize = Descriptiontext.sizeThatFits(CGSize(width: fixedWidth, height: self.descriptionTextHeight.constant ))
//        self.descriptionTextHeight.constant = newSize.height
//        self.view.layoutIfNeeded()
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        adjustTextViewHeight()
//    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        conditionList = ["Other (see description)","For Parts","Used","Reconditioned","Open box / like new","New"]
        ConditionValueTextField.delegate = self
        selectCreatePicker(textField: ConditionValueTextField, tag: 1)
        createToolBar(textField: ConditionValueTextField)
//        ConditionValueTextField.makeCornersRound()
//        ConditionValueTextField.layer.borderWidth = 1.0
        ConditionValueTextField.textAlignment = .center
        Descriptiontext.delegate = self
        Descriptiontext.text = "Details of Items"
        Descriptiontext.textColor = UIColor.lightGray
        
        CategoryView.addShadow()
        ConditionView.addShadow()
        DescriptionView.addShadow()
        Descriptiontext.toolbarPlaceholder = "DescriptionView"

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        Descriptiontext.endEditing(true)
        SelectCategoryName.endEditing(true)
        DescriptionView.endEditing(true)
        ConditionView.endEditing(true)
        CategoryView.endEditing(true)
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if Descriptiontext.textColor == UIColor.lightGray {
            Descriptiontext.text = nil
            Descriptiontext.textColor = UIColor.black
        }
        
        descriptionTextborderLbl.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if Descriptiontext.text.isEmpty {
            Descriptiontext.text = "Details of Items"
            Descriptiontext.textColor = UIColor.lightGray
        }
         descriptionTextborderLbl.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    


}
extension ItemListingTwoVC : UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return conditionList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return conditionList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ConditionValueTextField.text! = conditionList[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label : UILabel
        
        if let view = view as? UILabel{
            label = view
        }else{
            label = UILabel()
            label.textColor = UIColor.black
//            label.font = AdaptiveLayout.normalBold
            label.textAlignment = .center
            label.text = conditionList[row]
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
        ConditionValueTextField.endEditing(true)
        
    }
}
