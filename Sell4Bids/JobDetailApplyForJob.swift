//
//  JobDetailApplyForJob.swift
//  Sell4Bids
//
//  Created by Admin on 26/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MobileCoreServices

class JobDetailApplyForJob: UIViewController,UITextViewDelegate , UINavigationControllerDelegate{

    // labels
    @IBOutlet weak var professionalSummarytextField: UILabel!
    @IBOutlet weak var experienceLbl: UILabel!
    @IBOutlet weak var currentSalaryLbl: UILabel!
    @IBOutlet weak var expectedSalaryLbl: UILabel!
    @IBOutlet weak var contactNumberLbl: UILabel!
    @IBOutlet weak var contactEmailLbl: UILabel!
    @IBOutlet weak var applyNowLbl: UILabel!
    
    
    // textFields
    @IBOutlet weak var professionalSummaryTextView: UITextView!
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var currentSalaryTextField: UITextField!
    @IBOutlet weak var expectedSalaryTextField: UITextField!
    @IBOutlet weak var contactNumberTextField: UITextField!
    @IBOutlet weak var contactEmailTextField: UITextField!
    @IBOutlet weak var CVUploadTextField: UITextField!
    
    // UIButtons
    @IBOutlet weak var chooseFile_Button: UIButton!
    @IBOutlet weak var cancel_Button: UIButton!
    @IBOutlet weak var Apply_Now_Button: UIButton!
    
    // NSLayoutConstraint
    @IBOutlet weak var CVUploadConstraints: NSLayoutConstraint!
    
    // Variables
    var currencyChar : Character = "$"
    var currency_String = String()
    var currency_Symbol = String()
    var countView = 0
    var check = true
    var mainApi = MainSell4BidsApi()
    var SelectJobExperience: [String] = ["Select Job Experience","Less then 1 Year","1 Year","2 Years","3 Years","4 Years","5 Years","greater than 5 Years"," 7 Years","10 Years","greater than 10 Years"]
    var documentPicker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document", kUTTypePDF as String], in: .import)
   
    
    //  DoneView
    let DoneAlertView = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    let DoneView = Bundle.main.loadNibNamed("Item_Listing_Done_Custom_View", owner: self, options: nil)?.first as! ItemListingDoneCustom
    var products_DetailsApply : JobDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseFile_Button.addTarget(self, action: #selector(uPloadNewResumeAction), for: .touchUpInside)
        
        TextFieldStyle()
        
        CVUploadConstraints.constant = 0
        
        if chooseFile_Button.isSelected == true {
            CVUploadConstraints.constant = 45
            chooseFile_Button.setTitle("Upload", for: .normal)
            chooseFile_Button.setTitleColor(UIColor.white, for: .normal)
            chooseFile_Button.backgroundColor = UIColor.red
            }
        
        professionalSummaryTextView.delegate = self
        experienceTextField.delegate = self
        currentSalaryTextField.delegate = self
        expectedSalaryTextField.delegate = self
        contactNumberTextField.delegate = self
        contactEmailTextField.delegate = self
        CVUploadTextField.delegate = self
        professionalSummaryTextView.text = "Enter Your Professional Summary"
        professionalSummaryTextView.textColor = UIColor.lightGray
        
        currentSalaryTextField.keyboardType = UIKeyboardType.decimalPad
        expectedSalaryTextField.keyboardType = UIKeyboardType.decimalPad
        contactNumberTextField.keyboardType = UIKeyboardType.decimalPad
        
        chooseFile_Button.makeCornersRound()
        cancel_Button.makeCornersRound()
        Apply_Now_Button.makeCornersRound()
        
        selectCreatePicker(textField: experienceTextField, tag: 1)
        createToolBar(textField: experienceTextField)
        
        experienceTextField.delegate = self
        experienceTextField.makeCornersRound()
        
        currentSalaryTextField.delegate = self
        expectedSalaryTextField.delegate = self
        
        if gpscountry == "USA" {
            self.currency_String = "US Dollars"
            self.currency_Symbol = "$"
            self.currencyChar = "$"
            
        }else if gpscountry == "IN" {
            self.currency_String = "Indains rupees"
            self.currency_Symbol = "₹"
            self.currencyChar = "₹"
        }
        
        DoneView.DoneBtn.addTarget(self, action: #selector(Done_btn_Action), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        professionalSummaryTextView.endEditing(true)
        experienceTextField.endEditing(true)
        currentSalaryTextField.endEditing(true)
        expectedSalaryTextField.endEditing(true)
        contactNumberTextField.endEditing(true)
        contactEmailTextField.endEditing(true)
        CVUploadTextField.endEditing(true)
        cancel_Button.endEditing(true)
        Apply_Now_Button.endEditing(true)
        chooseFile_Button.endEditing(true)
        
    }
    
    
    
    
    // Professional Summary PlaceHolder Coding:
    func textViewDidBeginEditing(_ textView: UITextView) {
        if professionalSummaryTextView.textColor == UIColor.lightGray {
            professionalSummaryTextView.text = nil
            professionalSummaryTextView.textColor = UIColor.black
        }
    }
    
    
    // Professional Summary PlaceHolder Coding:
    func textViewDidEndEditing(_ textView: UITextView) {
        if professionalSummaryTextView.text.isEmpty {
            professionalSummaryTextView.text = "Enter Your Professional Summary"
            professionalSummaryTextView.textColor = UIColor.lightGray
        }
    }
    
    
    // Done Button View Function:
    @objc func Done_btn_Action(){
        
        DoneView.DoneBtn.isSelected = !DoneView.DoneBtn.isSelected
        
        if DoneView.DoneBtn.isSelected == true{
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
        else {
            DispatchQueue.main.async {
                self.DoneView.DoneBtn.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
    }

    
    // Email Validation :
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    let left_Button = UIButton(type: .custom)
    let Right_button = UIButton(type: .custom)
    
    
    @objc func LeftView(){
        
        left_Button.setImage(UIImage(named: "cross_128_20_red"), for: .normal)
        left_Button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        left_Button.frame = CGRect(x: CGFloat(25), y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
        CVUploadTextField.leftView = left_Button
        CVUploadTextField.leftViewMode = .always
        
        //        button.addTarget(self, action: #selector(self.showpass), for: .touchUpInside)
        
    }
    @objc func RightView(){
        
        Right_button.setImage(UIImage(named: "cross_128_20_red"), for: .normal)
        Right_button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        Right_button.frame = CGRect(x: CGFloat(25), y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
        CVUploadTextField.rightView = Right_button
        CVUploadTextField.rightViewMode = .always
        //        button.addTarget(self, action: #selector(self.showpass), for: .touchUpInside)
    }
    
    
    
    // Apply Now Implementation:
    @IBAction func apply_Now_Btn(_ sender: Any) {
        
        if countView == 0 {
            
            if ((professionalSummaryTextView.text?.isEmpty)!)
            {
                
                print("DescriptionError in TextField === 1")
                showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "Please Enter Professional Summary")
                professionalSummaryTextView.shake()
                countView = 0
                return
            }
            else if (professionalSummaryTextView.text?.count)! < 20 || (professionalSummaryTextView.text?.count)! > 1500
            {
                print("Description_TextFieldWorking ===")
                showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "Please enter minimum 20 and maximum 1500 characters.")
                professionalSummaryTextView.shake()
                countView = 0
                return
            }
                
            
            else if (experienceTextField.text == "Select Job Experience" ) || (experienceTextField.text == "" )
            {
                experienceTextField.shake()
                showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "Please select Experience.")
                countView = 0
                
                print("Experience_TextField === 1")
                return
            }
            
                
            else if ((currentSalaryTextField.text?.isEmpty)!)
            {
                print("CurrentSalary_TextField === 1")
                showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "Please Enter Current Salary")
                currentSalaryTextField.shake()
                countView = 0
                return
            }
            else if (currentSalaryTextField.text?.count)! < 2 || (currentSalaryTextField.text?.count)! > 6
            {
                print("check count \(currentSalaryTextField.text?.count ?? 0)")
                showSwiftMessageWithParams(theme: .error, title: "Current Salary Error", body: "Text lenght should be more then 1 charactors and less then 6 charactors ")
                currentSalaryTextField.shake()
                countView = 0
                print("CurrentSalary_TextField === 2")
                return
                
            }
                
                
                
            else if ((expectedSalaryTextField.text?.isEmpty)!)
            {
                
                print("ExpectedSalary_TextField === 1")
                showSwiftMessageWithParams(theme: .error, title: "Expected Salary Error", body: "Please Enter Expected Salary")
                expectedSalaryTextField.shake()
                countView = 0
                return
            }
                
            else if (expectedSalaryTextField.text?.count)! < 2 || (expectedSalaryTextField.text?.count)! > 6
            {
                print("check count \(String(describing: expectedSalaryTextField.text?.count))")
                showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "Price text lenght should be more then 1 charactors and less then 6 charactors ")
                countView = 0
                print("ExpectedSalary_TextField == 2")
                return
                
            }
                
                
            else if ((contactNumberTextField.text?.isEmpty)!)
            {
                print("ContactNumberTextField_IS_Empty === 1")
                showSwiftMessageWithParams(theme: .error, title: "Contact Number Error", body: "Please Enter Contact Number")
                contactNumberTextField.shake()
                countView = 0
                return
            }
            else if (contactNumberTextField.text?.count)! < 7 || (contactNumberTextField.text?.count)! > 20
            {
                print("check count \(contactNumberTextField.text?.count ?? 0)")
                showSwiftMessageWithParams(theme: .error, title: "Contact Number Error", body: "Text lenght should be more then 7 charactors and less then 20 charactors ")
                contactNumberTextField.shake()
                countView = 0
                print("ContactNumber_TextField_Count === 2")
                return
                
            }
                
                
            else if ((contactEmailTextField.text?.isEmpty)!)
            {
                
                print("ContactEmail_TextField === 1")
                showSwiftMessageWithParams(theme: .error, title: "Contact Email Error", body: "Please Enter Contact Email")
                contactEmailTextField.shake()
                countView = 0
                return
            }
            else if ((CVUploadTextField.text?.isEmpty)!)
            {
                
                print("Document_TextField === 1")
                showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "Please Enter Document")
                countView = 0
                return
            }
            
            let JobDetailCurrentSalary = currentSalaryTextField.text!.split(separator: "$")
            let JobDetailExpectedSalary = expectedSalaryTextField.text!.split(separator: "$")
            
            // Apply For Job Api Implement Here:
            print("ID ==\(products_DetailsApply?.id)")
            print("UID == \(products_DetailsApply?.uid)")
            print("Professional Summary == \(professionalSummaryTextView.text!)")
            print("Experience == \(experienceTextField.text!)")
            print("Expected Salary == \(JobDetailExpectedSalary[0])")
            print("Current Salary == \(JobDetailCurrentSalary[0])")
            print("Contact Number == \(contactNumberTextField.text!)")
            print("Contact Email == \(contactEmailTextField.text!)")
            print("Name == \(SessionManager.shared.name)")
            print("Image == \(SessionManager.shared.image)")
            print("userId == \(SessionManager.shared.userId)")
            
            mainApi.ApplyForJob_Api(item_id: (products_DetailsApply?.id)!, seller_uid :(products_DetailsApply?.uid)!, professionalSummary: "\(professionalSummaryTextView.text!)", expereince: "\(experienceTextField.text!)", expectedSalary: "\(JobDetailExpectedSalary[0])", currentSalary: "\(JobDetailCurrentSalary[0])", contactNo: "\(contactNumberTextField.text!)", jobSeekerEmail: "\(contactEmailTextField.text!)", jobSeekerName: SessionManager.shared.name, jobSeekerImage: SessionManager.shared.image, document: "\(CVUploadTextField.text!)", jobSeekerUid: SessionManager.shared.userId, country_code: gpscountry, jobCategory: "\(products_DetailsApply!.jobCategory)"){ (status, data, error) in
                
                if status {
                    self.DoneAlertView.view.frame = self.DoneView.frame
                    self.DoneAlertView.view.addSubview(self.DoneView)
                    self.present(self.DoneAlertView, animated: true, completion: nil)
                    self.DoneView.DoneBtn.makeCornersRound()
                    
                }
                
                print("status == \(status)")
                print("data == \(data)")
                print("error == \(error)")
                
            }
            
        }
        
    }
    
    // Cancel Button Implementation:
    @IBAction func cancel_Button(_ sender: Any) {
        
        print("Cancel Button is Working")
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty{
            if textField == experienceTextField{
                textField.placeholder = "Select Year"
            }
            else if textField == currentSalaryTextField{
                textField.placeholder = "Select Current Salary"
            }
            else if textField == expectedSalaryTextField{
                textField.placeholder = "Select Expected Salary"
            }
            else if textField == contactNumberTextField{
                textField.placeholder = "e.g. XXXX-XXXXXXX"
            }
            else if textField == contactEmailTextField{
                textField.placeholder = "e.g. email@gmail.com "
            }
            else if textField == CVUploadTextField {
                textField.placeholder = "e.g. (.Doc / .PDF)"
            }else {
                // Expected.
            }
        }
    }
    
    
    
    // TextField Designing:
    func TextFieldStyle(){
      
        
//        professionalSummaryTextView.layer.borderWidth = 1.0
//        professionalSummaryTextView.makeCornersRound()
        
        
        
//        experienceTextField.layer.borderWidth = 1.0
//        experienceTextField.makeCornersRound()
        experienceTextField.textAlignment = .center
        
//        currentSalaryTextField.layer.borderWidth = 1.0
//        currentSalaryTextField.makeCornersRound()
        currentSalaryTextField.textAlignment = .center
        
//
//        expectedSalaryTextField.layer.borderWidth = 1.0
//        expectedSalaryTextField.makeCornersRound()
        expectedSalaryTextField.textAlignment = .center
        
//        contactNumberTextField.layer.borderWidth = 1.0
//        contactNumberTextField.makeCornersRound()
        contactNumberTextField.textAlignment = .center
        
//        contactEmailTextField.layer.borderWidth = 1.0
//        contactEmailTextField.makeCornersRound()
        contactEmailTextField.textAlignment = .center
        
//        CVUploadTextField.layer.borderWidth = 1.0
//        CVUploadTextField.makeCornersRound()
        CVUploadTextField.textAlignment = .center
        
    }

    @objc func uPloadNewResumeAction() {
        print("print Called Browser")
        dismiss(animated: true, completion: nil)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
}





//MARK:-  UIDocumentPickerDelegate
extension JobDetailApplyForJob : UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("Url == \(url)")
        
        let fileName = url.lastPathComponent
        let pdfData  = NSData(contentsOf: url)
        print("pdf data\(pdfData)")
        CVUploadTextField.text = fileName
        print("fileName == \(fileName)")
       
        self.mainApi.fileName = fileName
        self.mainApi.fileData = pdfData!
        
        
    }
}



//MARK:-  UIPickerViewDelegate, UIPickerViewDataSource
extension JobDetailApplyForJob: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return SelectJobExperience.count
        
        }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return SelectJobExperience[row]
        
        }
        

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        experienceTextField.text = SelectJobExperience[row]
        
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
        
        label.font = AdaptiveLayout.normalBold
        
        label.text = SelectJobExperience[row]
        
        return label
    }
    
    
    
    func selectCreatePicker(textField: UITextField, tag: Int){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.tag = tag
        textField.inputView = pickerView
        
    }
    
}


//MARK:- UITextFieldDelegate
extension JobDetailApplyForJob : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == experienceTextField{
            
            if textField.isFirstResponder{
                textField.resignFirstResponder()
                return true
            }
        }
        else if textField == currentSalaryTextField {
            textField.resignFirstResponder()
            currentSalaryTextField.becomeFirstResponder()
        }
        else if textField == expectedSalaryTextField {
            textField.resignFirstResponder()
            expectedSalaryTextField.becomeFirstResponder()
        }
        else if textField == contactNumberTextField {
            textField.resignFirstResponder()
            contactNumberTextField.becomeFirstResponder()
        }
        else if textField == contactEmailTextField {
            textField.resignFirstResponder()
            contactEmailTextField.becomeFirstResponder()
        }
        return true
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      
        if textField == experienceTextField{
            return true
        }
        
        if textField.tag == 2 || textField.tag == 3 {
            print("called Editing")
            var price = textField.text
            let i = price!.characters.index(of: currencyChar)
            if i != nil {
                
                price!.remove(at: i!)
            }else {
                print("called Editing nil")
            }
            textField.text = price!
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 2 || textField.tag == 3 {
            
            let temp = textField.text
            if gpscountry == "USA" {
                if temp?.contains(currency_Symbol)==false  {
                    textField.text = currency_Symbol + temp!
                    check = true
                }
            }else if  gpscountry == "IN" {
                if temp?.contains(currency_Symbol)==false  {
                    textField.text = currency_Symbol + temp!
                    self.check = true
                }
            }
        }
        // Email Validation Coding Here:
        if textField.tag == 5 {
            //scrollView.setContentOffset(CGPoint(x: 0, y: 20 ), animated: true)
            
            if (contactEmailTextField.text?.count)! < 254 {
                
                
                if !(contactEmailTextField.text?.isEmpty)! {
                    if !isValidEmail(testStr: contactEmailTextField.text!) {
                        contactEmailLbl.text = "Invalid Emaild Address"
                    }
                }else {
                    contactEmailLbl.text = "Contact Email"
                }
            }else {
                contactEmailLbl.text = "maximum charaters allowed 254"
            }
        }
        return true
    }
    
    ///for disabling the employment type text field entering text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == experienceTextField {
            return false
        }
        
        if textField.tag == 2 || textField.tag == 3{
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
        experienceTextField.endEditing(true)
    }
    
    
    
}


