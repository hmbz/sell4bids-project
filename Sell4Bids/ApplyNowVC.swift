//
//  ApplyNowVC.swift
//  Sell4Bids
//
//  Created by admin on 11/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MobileCoreServices

class ApplyNowVC: UIViewController, UITextFieldDelegate {
    
    //MARK:- Outlets and properties
    @IBOutlet weak var jobExperienceTextField: UITextField!
    @IBOutlet weak var currencySalaryTextField: UITextField!
    @IBOutlet weak var expectedSalaryTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var addResumeBtn: UIButton!
    @IBOutlet weak var docNameLbl: UILabel!
    @IBOutlet weak var submitApplicationBtn: UIButton!
    @IBOutlet weak var submitStackHeight: NSLayoutConstraint!
    @IBOutlet weak var docNameView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var homeImg: UIImageView!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var crossBtn: UIButton!
    
    
    //MARK:- Variables
    lazy var experienceArray = ["Select One","Less than 1 year(s)","1 Year","2 Year","3 Year","4 Year","5 Year","6 Year","7 Year","8 Year","9 Year","10 Year","More than 10 years"]
    lazy var salaryArray = [String]()
    var selectedProduct : jobsDetailModel?
    var documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
    var mainApi = MainSell4BidsApi()
    var selectResume = false
    // Done Alert View
    let DoneAlertView = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    let DoneView = Bundle.main.loadNibNamed("Item_Listing_Done_Custom_View", owner: self, options: nil)?.first as! ItemListingDoneCustom
    
    //MARK:- View Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
      salaryArray.insert("Select One", at: 0)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UINavigationBar.appearance().tintColor = UIColor.black // your color
        UIBarButtonItem.appearance().setTitleTextAttributes(nil, for: .normal)
    }
    
    //MARK:- functions
    private func setupViews() {
        
        var currencySymbol :String?
        if selectedProduct?.currenySymbol != "" {
            currencySymbol = selectedProduct?.currenySymbol
        }else if selectedProduct?.currencyString != "" {
            currencySymbol = selectedProduct?.currencyString
        }else {
            currencySymbol = CurrencyManager.instance.getCurrencySymbol(Country: selectedProduct?.countryCode ?? "USA")
        }
        if currencySymbol != "" {
          salaryArray = ["\(currencySymbol!)0 - \(currencySymbol!)500","\(currencySymbol!)500 - \(currencySymbol!)1000","\(currencySymbol!)1000 - \(currencySymbol!)2500","\(currencySymbol!)2500 - \(currencySymbol!)5000","More than \(currencySymbol!)5000"]
        }else {
           salaryArray = ["Select One","0 - 500","500 - 1000","1000 - 2500","2500 - 5000","More than 5000"]
        }
        
        jobExperienceTextField.delegate = self
        currencySalaryTextField.delegate = self
        expectedSalaryTextField.delegate = self
        contactTextField.keyboardType = .numberPad
      if Env.isIpad{
         contactTextField.keyboardType = .numberPad
      }
      
        selectCreatePicker(textField: jobExperienceTextField, tag: 1)
        selectCreatePicker(textField: currencySalaryTextField, tag: 2)
        selectCreatePicker(textField: expectedSalaryTextField, tag: 3)
        createToolBar(textField: jobExperienceTextField)
        createToolBar(textField: currencySalaryTextField)
        createToolBar(textField: expectedSalaryTextField)
        
        docNameView.isHidden = true
        submitApplicationBtn.isHidden = true
        submitStackHeight.constant = 50
        crossBtn.isHidden = true
        
        jobExperienceTextField.textAlignment = .center
        currencySalaryTextField.textAlignment = .center
        expectedSalaryTextField.textAlignment = .center
        
        self.summaryTextView.layer.borderWidth = 1.5
        self.summaryTextView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.summaryTextView.layer.cornerRadius = 6
        
        self.docNameView.layer.borderWidth = 1.5
        self.docNameView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.backBtn.addTarget(self, action: #selector(backBtnTapped(sender:)), for: .touchUpInside)
        self.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.addResumeBtn.addTarget(self, action: #selector(addResumeBtnTapped), for: .touchUpInside)
        crossBtn.addTarget(self, action: #selector(crossBtnTapped(sender:)), for: .touchUpInside)
        self.submitApplicationBtn.addTarget(self, action: #selector(submitApplication(sender: )), for: .touchUpInside)
        
    }
    
    //MARK:- Actions
    @objc func backBtnTapped(sender: UIButton) {
        print("Back button Tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func addResumeBtnTapped(_ sender: UIButton) {
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
      NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        self.present(documentPicker, animated: true, completion: nil)
      
    }
    
    @objc func submitApplication(sender: UIButton){
        print("Submit Application button Tapped")
        if jobExperienceTextField.text!.isEmpty || jobExperienceTextField.text == "Select One" {
            self.view.makeToast("Please Select Job Experience", position :.top)
        }else if currencySalaryTextField.text!.isEmpty ||  currencySalaryTextField.text! == "Select One" {
            self.view.makeToast("Please Select Current Salary", position :.top)
        }else if expectedSalaryTextField.text!.isEmpty || expectedSalaryTextField.text == "Select One"{
            self.view.makeToast("Please Select Expected Salary", position :.top)
        }else if contactTextField.text!.isEmpty{
            self.view.makeToast("Please enter Contact Num", position :.top)
        }else if summaryTextView.text!.isEmpty && summaryTextView.text.count < 20 {
            self.view.makeToast("Please enter Summary", position :.top)
        }else {
            mainApi.ApplyForJob_Api(item_id: (selectedProduct?.itemId)!, seller_uid :(selectedProduct?.uid)!, professionalSummary: "\(summaryTextView.text!)", expereince: "\(jobExperienceTextField.text!)", expectedSalary: "\(expectedSalaryTextField.text!)", currentSalary: "\(currencySalaryTextField.text!)", contactNo: "\(contactTextField.text!)", jobSeekerEmail: "", jobSeekerName: SessionManager.shared.name, jobSeekerImage: SessionManager.shared.image, document: "\(docNameLbl.text!)", jobSeekerUid: SessionManager.shared.userId, country_code: selectedProduct?.countryCode ?? "", jobCategory: "\(selectedProduct?.jobCategory ?? "")"){ (status, data, error) in
                
                if status {
                    self.DoneAlertView.view.frame = self.DoneView.frame
                    self.DoneAlertView.view.addSubview(self.DoneView)
                    self.DoneView.DoneBtn.addTarget(self, action: #selector(self.alertDoneBtnTapped), for: .touchUpInside)
                    self.present(self.DoneAlertView, animated: true, completion: nil)
                    self.DoneView.DoneBtn.makeCornersRound()
                    
                }else {
                    self.view.makeToast("Error", position :.top)
                }
            }
        }
    }
    
    @objc func alertDoneBtnTapped(){
        self.DoneAlertView.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func crossBtnTapped(sender: UIButton) {
        docNameView.isHidden = true
        submitApplicationBtn.isHidden = true
        addResumeBtn.isHidden = false
        submitStackHeight.constant = 50
        docNameLbl.text = ""
        crossBtn.isHidden = true
    }
    
}
extension ApplyNowVC : UIDocumentPickerDelegate,UINavigationControllerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let fileName = url.lastPathComponent
        let pdfData  = NSData(contentsOf: url)
        docNameLbl.text = fileName
        addResumeBtn.isHidden = true
        docNameView.isHidden = false
        submitApplicationBtn.isHidden = false
        submitStackHeight.constant = 100
        self.mainApi.fileName = fileName
        self.mainApi.fileData = pdfData!
        self.crossBtn.isHidden = false
    }
}
extension ApplyNowVC: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return experienceArray.count
        }else if pickerView.tag == 2 {
            return salaryArray.count
        }else if pickerView.tag == 3 {
            return salaryArray.count
        }else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return experienceArray[row]
        }else if pickerView.tag == 2 {
            return salaryArray[row]
        }else if pickerView.tag == 3 {
            return salaryArray[row]
        }else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.jobExperienceTextField.text = experienceArray[row]
        }else if pickerView.tag == 2 {
            self.currencySalaryTextField.text = salaryArray[row]
        }else if pickerView.tag == 3 {
            self.expectedSalaryTextField.text = salaryArray[row]
        }else {
            print("Nothing")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label : UILabel
        if let view = view as? UILabel{
            label = view
        }else{
            label = UILabel()
            label.textColor = UIColor.black
            label.textAlignment = .center
            
            if pickerView.tag == 1 {
                label.text = experienceArray[row]
            }else if pickerView.tag == 2 {
                label.text = salaryArray[row]
            }else if pickerView.tag == 3 {
                label.text = salaryArray[row]
            }else {
                print("Nothing")
            }
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
        self.view.endEditing(true)
    }
}
