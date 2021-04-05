//
//  JobListingMainVC.swift
//  Sell4Bids
//
//  Created by Admin on 07/02/2019.
//  Copyright © 2019 admin. All rights reserved.

import UIKit
import FlexibleSteppedProgressBar

class JobListingMainVC: UIViewController,FlexibleSteppedProgressBarDelegate,UIPickerViewAccessibilityDelegate{
    
    // Main Views Connections
    @IBOutlet weak var JobMainView: UIView!
    @IBOutlet weak var JobProgressBar: FlexibleSteppedProgressBar!
    
    
    
    // variables & Atributes
    var ArrayJobView = [UIViewController]()
    var countView = 0
    var SelectedViewIndex : Int?
    var currency_String = String()
    var currency_Symbol = String()
    var mainApi = MainSell4BidsApi()
    var latitude = Double()
    var longtitude = Double()
    var medical = String()
    var Pto = String()
    var k410 = String()
    var acceptoffer = String()
    var listIdentefily = String()
    let DoneAlertView = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    let DoneView = Bundle.main.loadNibNamed("Item_Listing_Done_Custom_View", owner: self, options: nil)?.first as! ItemListingDoneCustom
    
    
    // UI Buttons
    @IBOutlet weak var NextBtn: ButtonShahdow!
    @IBOutlet weak var BackBtn: ButtonShahdow!
    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var Errorimg: UIImageView!
    
    // Connection variables of All three Views in Jobs
    let JobListingStep1VC = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "JobListingStepOne") as! JobListingStep1VC
    let JobListingStep2VC = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "JobListingStepTwo") as! JobListingStep2VC
    let JobListingStep3VC = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "JobListingStepThree") as! JobListingStep3VC
    let JobSelectLocationVC = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "ItemListing-Step-Four") as! ItemListingFour
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addInviteBarButtonToTop()
        addLeftHomeBarButtonToTop()
        addLogoWithLeftBarButton()
        self.title = "List Job"
        DoneView.succesfullayMessage.text = listingFinalMessage.instance.job
        
        
        BackBtn.isHidden = true
        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
        
        ArrayJobView.append(JobListingStep1VC)
        ArrayJobView.append(JobListingStep2VC)
        ArrayJobView.append(JobSelectLocationVC)
        ArrayJobView.append(JobListingStep3VC)
        
        
        ArrayJobView[countView].view.frame = self.JobMainView.frame
        self.JobMainView.addSubview(ArrayJobView[countView].view)
        
        
        
        // For Colour ProgressBar View
        
        JobProgressBar.currentSelectedTextColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1) /*UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)*/
        JobProgressBar.currentSelectedCenterColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1) /*UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)*/
        JobProgressBar.selectedOuterCircleStrokeColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1)/*UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)*/
        
        JobProgressBar.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        DoneView.DoneBtn.addTarget(self, action: #selector(Done_btn_Action), for: .touchUpInside)
        BackBtn.endEditing(true)
        NextBtn.endEditing(true)
        JobMainView.endEditing(true)
        JobProgressBar.endEditing(true)
        
        NextBtn.addShadowAndRound()
        BackBtn.addShadowAndRound()
        self.view.gestureRecognizers?.forEach(self.view.removeGestureRecognizer(_:))
        
    }
    
    
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
    
    
    
    @IBAction func BackBtnOpt(_ sender: Any) {
        
        
        if  countView < 2 {
            
            BackBtn.isHidden = true
        }
        
        if  countView < 4 {
            
            NextBtn.setTitle("Next", for: .normal)
            NextBtn.setTitleColor(UIColor.white, for: .normal)
            NextBtn.backgroundColor = UIColor.black
            
        }
        
        if countView > 0 {
            countView -= 1
            ArrayJobView[countView].view.frame = self.JobMainView.frame
            self.JobMainView.addSubview(ArrayJobView[countView].view)
            JobProgressBar.currentIndex = countView
            
            
        }
    }
    
    @IBAction func nextBtnViewScreen(_ sender: Any) {
        // @OM 11-02-2019 (For Progress bar Implementation)
        
        if countView == 0 {
            print("count..0 = /\(countView)")
            
            if ((JobListingStep1VC.jobTitleTextField.text?.isEmpty)!) {
                
                print("TitleError TextFieldWorking === 1")
                
                _ = SweetAlert().showAlert("Job Title", subTitle:"  Please enter a suitable title for your Job.  " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                return
            }
            else if (JobListingStep1VC.jobTitleTextField.text?.count)! < 3 {
                print("check count \(JobListingStep1VC.jobTitleTextField.text?.count ?? 0)")
                
                _ = SweetAlert().showAlert("Job Title", subTitle:"     Title must have at-least 03 characters. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                print("TitleError TextFieldWorking === 2")
                return
                
            }
            else if((JobListingStep1VC.jobTitleTextField.text?.count)! > 100){
                print("check count \(JobListingStep1VC.jobTitleTextField.text?.count ?? 0)")
                
                _ = SweetAlert().showAlert("Job Title", subTitle:"  Title must not exceed 70 characters." , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                print("TitleError TextFieldWorking === 2")
                return
            }
            else if (JobListingStep1VC.JobSelectEmploymentTextField.text == "Select Employment Type" ) || (JobListingStep1VC.JobSelectEmploymentTextField.text == "" ){
                JobListingStep1VC.JobSelectEmploymentTextField.shake()
                
                _ = SweetAlert().showAlert("Employment Type", subTitle:"  Please Select an Employment Type. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                print("Select EmploymentType Error TextFieldWorking")
                return
                
            }
            
            if JobListingStep1VC.Medical == true {
                
                medical = "Medical"
            }
            else{
                
                medical = ""
            }
            
            if JobListingStep1VC.PTO == true{
                
                Pto = "PTO"
            }
            else{
                
                Pto = ""
                
            }
            
            if JobListingStep1VC.k401 == true {
                
                k410 = "K410"
            }
            else{
                
                k410 = ""
            }
            
            
            
            countView = 1
            BackBtn.isHidden = false
            BackBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            BackBtn.layer.shadowOffset = CGSize(width: 1, height: 3)
            BackBtn.layer.shadowOpacity = 1.0
            BackBtn.layer.shadowRadius = 10.0
            BackBtn.layer.masksToBounds = true
            BackBtn.backgroundColor = UIColor.black
            BackBtn.layer.cornerRadius = 20
            NextBtn.setTitle("Next", for: .normal)
            NextBtn.setTitleColor(UIColor.white, for: .normal)
            NextBtn.backgroundColor = UIColor.black
            ArrayJobView[countView].view.frame = self.JobMainView.frame
            self.JobMainView.addSubview(ArrayJobView[countView].view)
            
            JobProgressBar.currentIndex = countView
            print("count == \(countView)")
            
        }
            
        else if countView == 1 {
            print("count... 1 = \(countView)")
            
            if (JobListingStep2VC.jobSelectCategoryTextField.text == "Select Category" ) || (JobListingStep2VC.jobSelectCategoryTextField.text == "" ){
                JobListingStep2VC.jobSelectCategoryTextField.shake()
                
                _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"  Please select related category. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 1
                
                print("TakeSelectCategory TextFieldWorking === 1")
                return
                
            }
                
            else if (JobListingStep2VC.jobExperienceTextField.text == "Select Experience" ) || (JobListingStep2VC.jobExperienceTextField.text == "" ){
                JobListingStep2VC.jobExperienceTextField.shake()
                
                _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"  Please select Experience. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 1
                
                print("TakeSelectExperience TextFieldWorking === 1")
                return
                
            }
            else if
                (JobListingStep2VC.jobDesTextView.text?.isEmpty)!{
                _ = SweetAlert().showAlert("Description", subTitle:"  Please Enter Job Description " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 1
                return
            }
            else if
                (JobListingStep2VC.jobDesTextView.text?.count)! < 20{
                print("DescriptionTextFieldWorking ===")
                
                _ = SweetAlert().showAlert("Description", subTitle:"  Please enter a description for your Job with minimum 20 characters. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 1
                return
            }
            else if
                ((JobListingStep2VC.jobDesTextView.text?.count)! > 1500){
                print("DescriptionTextFieldWorking ===")
                
                _ = SweetAlert().showAlert("Description", subTitle:"   Description must not exceed 1200 characters. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 1
                return
            }
                
            else if ((JobListingStep2VC.companyNameTextField.text?.isEmpty)!){
                
                _ = SweetAlert().showAlert("Company Name", subTitle:"   Please provide Company name " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                return
                    countView = 1
                
            }
                
            else if
                (JobListingStep2VC.companyNameTextField.text?.count)! < 5
            {
                print("DescriptionTextFieldWorking ===")
                
                _ = SweetAlert().showAlert("Company Name", subTitle:"   Please enter your company name with minimum 05 characters. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                return
                    countView = 1
                
            }
            else if
                ((JobListingStep2VC.companyNameTextField.text?.count)! > 120){
                print("DescriptionTextFieldWorking ===")
                
                _ = SweetAlert().showAlert("Company Name", subTitle:"   Description must not exceed 120 characters. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                return
                    countView = 1
            }
            
            BackBtn.isHidden = false
            BackBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            BackBtn.layer.shadowOffset = CGSize(width: 1, height: 3)
            BackBtn.layer.shadowOpacity = 1.0
            BackBtn.layer.shadowRadius = 10.0
            BackBtn.layer.masksToBounds = true
            BackBtn.backgroundColor = UIColor.black
            BackBtn.layer.cornerRadius = 20
            NextBtn.setTitle("Next", for: .normal)
            NextBtn.setTitleColor(UIColor.white, for: .normal)
            NextBtn.backgroundColor = UIColor.black
            countView = 2
            ArrayJobView[countView].view.frame = self.JobMainView.frame
            self.JobMainView.addSubview(ArrayJobView[countView].view)
            
            JobProgressBar.currentIndex = countView
            print("countView == 2 \(countView)")
            
            
            
            
            
        }
        else if countView == 2 {
            
            if JobSelectLocationVC.country.isEmpty && JobSelectLocationVC.city.isEmpty  && JobSelectLocationVC.zipcode.isEmpty && JobSelectLocationVC.latitude == 0 && JobSelectLocationVC.longtitude == 0 {
                
                print("Count VIew 3")
                _ = SweetAlert().showAlert("Location", subTitle:"Please select your location." , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 2
                return
            }
            
            BackBtn.isHidden = false
            BackBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            BackBtn.layer.shadowOffset = CGSize(width: 1, height: 3)
            BackBtn.layer.shadowOpacity = 1.0
            BackBtn.layer.shadowRadius = 10.0
            BackBtn.layer.masksToBounds = true
            BackBtn.backgroundColor = UIColor.black
            BackBtn.layer.cornerRadius = 20
            NextBtn.setTitle("Finish", for: .normal)
            NextBtn.setTitleColor(UIColor.white, for: .normal)
            NextBtn.backgroundColor = UIColor.red
            
            countView = 3
            ArrayJobView[countView].view.frame = self.JobMainView.frame
            self.JobMainView.addSubview(ArrayJobView[countView].view)
            
            JobProgressBar.currentIndex = countView
            print("countView == 2 \(countView)")
            
            // perform work here
            let country = JobSelectLocationVC.country.uppercased()
            var currency = ""
            currency = CurrencyManager.instance.getCurrencySymbolForListing(Country: country)
            let user_Selected_Currency_Symbol = CurrencyManager.instance.getCurrencySymbol(Country: country)
            let currency_TwoDigitCode = CurrencyManager.instance.getCurrencyTwoDigitCode(Country: country)
            let currency_ThreeDigitCode = CurrencyManager.instance.getCurrencyThreeDigitCode(Country: country)
            
            
            
            print("country == \(country)")
            print("currency == \(currency)")
            print("Symbol == \(user_Selected_Currency_Symbol)")
            print("twoDigitCode == \(currency_TwoDigitCode)")
            print("threeDigitCode == \(currency_ThreeDigitCode)")
            
            if currency_ThreeDigitCode.isEmpty{
                JobListingStep3VC.JobSalaryTextField.placeholder = currency_TwoDigitCode + " " + user_Selected_Currency_Symbol
                JobListingStep3VC.currencyBtn.setTitle("\(currency_TwoDigitCode + " " + user_Selected_Currency_Symbol)", for: .normal)
                
                JobListingStep3VC.currency_Symbol = user_Selected_Currency_Symbol
                print("currency_Symbol == \(JobListingStep3VC.currency_Symbol)")
                JobListingStep3VC.currency_String = currency_TwoDigitCode
                print("currency_String == \(JobListingStep3VC.currency_String)")
            }else{
                JobListingStep3VC.JobSalaryTextField.placeholder = currency_ThreeDigitCode + " " + user_Selected_Currency_Symbol
                JobListingStep3VC.currencyBtn.setTitle("\(currency_ThreeDigitCode + " " + user_Selected_Currency_Symbol)", for: .normal)
                
                JobListingStep3VC.currency_Symbol = user_Selected_Currency_Symbol
                print("currency_Symbol == \(JobListingStep3VC.currency_Symbol)")
                JobListingStep3VC.currency_String = currency_ThreeDigitCode
                print("currency_String == \(JobListingStep3VC.currency_String)")
            }
            
        }
        else if countView == 3 {
            
            if JobListingStep3VC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isOn == false {
                
                if ((JobListingStep3VC.JobSalaryTextField.text?.isEmpty)!){
                    
                    print("Price TextField === 1")
                    
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter Salary " , style: .error,buttonTitle:
                        "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    countView = 3
                    return
                }
                    
                else if (!JobListingStep3VC.JobSalaryTextField.text!.isEmpty) {
                    
                    let price : Int = Int(JobListingStep3VC.JobSalaryTextField.text!)!
                    
                    if price <= 0 {
                        
                        countView = 3
                        
                        _ = SweetAlert().showAlert("Invalid price", subTitle:"   Salary must be greater than 0." , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        return
                        
                    }
                        
                        
                    else if ((JobListingStep3VC.TakeDurationAndOffersCustom.listingDurationTextField.text?.isEmpty)!){
                        
                        print("Price TextField === 1")
                        _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter listing days " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                        countView = 3
                        return
                    }
                        
                    else if (JobListingStep3VC.TakeDurationAndOffersCustom.payPeriodTextField.text?.isEmpty == true ){
                        
                        JobListingStep3VC.TakeDurationAndOffersCustom.payPeriodTextField.shake()
                        
                        _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"  Please select Pay period. " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        countView = 3
                        
                        return
                        
                    }
                    
                    
                    
                }
            }
                
            else if JobListingStep3VC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isOn == true {
                
                if ((JobListingStep3VC.JobSalaryTextField.text?.isEmpty)!){
                    
                    print("Price TextField === 1")
                    
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter Salary " , style: .error,buttonTitle:
                        "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    countView = 3
                    return
                }
                    
                else if (!JobListingStep3VC.JobSalaryTextField.text!.isEmpty) {
                    
                    let price : Int = Int(JobListingStep3VC.JobSalaryTextField.text!)!
                    
                    if price <= 0 {
                        
                        countView = 3
                        
                        _ = SweetAlert().showAlert("Invalid price", subTitle:"   Salary must be greater then 0." , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        return
                        
                    }
                        
                    else if (JobListingStep3VC.TakeDurationAndOffersCustom.payPeriodTextField.text?.isEmpty == true ){
                        
                        JobListingStep3VC.TakeDurationAndOffersCustom.payPeriodTextField.shake()
                        
                        _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"  Please select Pay period. " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        countView = 3
                        
                        return
                        
                    }
                    
                    
                    
                }
            }
            
            
            if JobListingStep3VC.AcceptOffer == true {
                
                acceptoffer = "true"
            }
            else{
                
                acceptoffer = "false"
            }
            
            print("Country == \(JobSelectLocationVC.country)")
            print("City == \(JobSelectLocationVC.city)")
            print("Zipcode == \(JobSelectLocationVC.zipcode)")
            print("Latitude == \(JobSelectLocationVC.latitude)")
            print("Longitude == \(JobSelectLocationVC.longtitude)")
            print("Job Title == \(JobListingStep1VC.jobTitleTextField.text!)")
            print("Job Employment Type == \(JobListingStep1VC.JobSelectEmploymentTextField.text!)")
            print("PTO == \(Pto)")
            print("Medical == \(medical)")
            print("FZOK == \(k410)")
            print("Job Select Job Category == \(JobListingStep2VC.jobSelectCategoryTextField.text!)")
            print("Job Select Job Experience == \(JobListingStep2VC.jobExperienceTextField.text!)")
            print("Job Description == \(JobListingStep2VC.jobDesTextView.text!)")
            print("Job Salary == \(JobListingStep3VC.JobSalaryTextField.text!)")
            print("Currency_Symbol ==\(JobListingStep3VC.currency_Symbol)")
            print("Currency_String ==\(JobListingStep3VC.currency_String)")
            print("Pay period == \(JobListingStep3VC.Select_payPeriod)")
            let jobsalary = JobListingStep3VC.JobSalaryTextField.text!.split(separator: "$")
            
            let image = UIImage.init()
            
            
            
            if JobListingStep3VC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isSelected == true{
                
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                
                // OsamaMansoori (24-07-2019)
                mainApi.JobListing_Api(lat: JobSelectLocationVC.latitude, lng: JobSelectLocationVC.longtitude, user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image, user_ID: SessionManager.shared.userId, country: JobSelectLocationVC.country, city: JobSelectLocationVC.city, title: "\(JobListingStep1VC.jobTitleTextField.text!)", employmentType: "\(JobListingStep1VC.JobSelectEmploymentTextField.text!)", Medical : medical , PTO: Pto , K401 : k410, jobCategory: "\(JobListingStep2VC.jobSelectCategoryTextField.text!)", jobExperiance: "\(JobListingStep2VC.jobExperienceTextField.text!)", description: "\(JobListingStep2VC.jobDesTextView.text!)", currency_string: "\(JobListingStep3VC.currency_String)", currency_symbol: "\(JobListingStep3VC.currency_Symbol)", startPrice: "\(jobsalary[0])", endTime: "-1", payPeriod: "\(JobListingStep3VC.Select_payPeriod)", acceptOffers: acceptoffer, zipCode: JobSelectLocationVC.zipcode, visibility: true, UI_Image: [image], itemAuctionType: "buy-it-now", itemCategory: "Jobs", companyName: "\(JobListingStep2VC.companyNameTextField.text!)", companyDescription: "\(JobListingStep2VC.companyDescriptionTextView.text!)", State: JobSelectLocationVC.state) { (status, data, error) in
                    
                    
                    
                    if status {
                        
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        
                        self.DoneAlertView.view.frame = self.DoneView.frame
                        self.DoneAlertView.view.addSubview(self.DoneView)
                        self.present(self.DoneAlertView, animated: true, completion: nil)
                        self.DoneView.DoneBtn.makeCornersRound()
                        
                        
                        
                        print("status == \(status)")
                        print("data == \(data)")
                        print("error == \(error)")
                        
                        
                    }
                    else{
                        
                        if error.contains("The network connection was lost"){
                            
                            let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        }
                        
                        if error.contains("The Internet connection appears to be offline.") {
                            
                            let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        if error.contains("The request timed out.") {
                            
                            let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
            else{
                
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                
                // OsamaMansoori (24-07-2019)
                mainApi.JobListing_Api(lat: JobSelectLocationVC.latitude, lng: JobSelectLocationVC.longtitude, user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image, user_ID: SessionManager.shared.userId, country: JobSelectLocationVC.country, city: JobSelectLocationVC.city, title: "\(JobListingStep1VC.jobTitleTextField.text!)", employmentType: "\(JobListingStep1VC.JobSelectEmploymentTextField.text!)", Medical : medical , PTO: Pto , K401 : k410, jobCategory: "\(JobListingStep2VC.jobSelectCategoryTextField.text!)", jobExperiance: "\(JobListingStep2VC.jobExperienceTextField.text!)", description: "\(JobListingStep2VC.jobDesTextView.text!)", currency_string: "\(JobListingStep3VC.currency_String)", currency_symbol: "\(JobListingStep3VC.currency_Symbol)", startPrice: "\(jobsalary[0])", endTime: "\(JobListingStep3VC.selected_date)", payPeriod: "\(JobListingStep3VC.Select_payPeriod)", acceptOffers: acceptoffer, zipCode: JobSelectLocationVC.zipcode, visibility: true, UI_Image: [image], itemAuctionType: "buy-it-now", itemCategory: "Jobs", companyName: "\(JobListingStep2VC.companyNameTextField.text!)", companyDescription: "\(JobListingStep2VC.companyDescriptionTextView.text!)", State: JobSelectLocationVC.state) { (status, data, error) in
                    
                    
                    
                    if status {
                        
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        
                        self.DoneAlertView.view.frame = self.DoneView.frame
                        self.DoneAlertView.view.addSubview(self.DoneView)
                        self.present(self.DoneAlertView, animated: true, completion: nil)
                        self.DoneView.DoneBtn.makeCornersRound()
                        
                        
                        
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
                            
                            let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        if error.contains("The request timed out.") {
                            
                            let alert = UIAlertController.init(title: "Network Error", message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
            
        }
        
        
    }
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        print("disappeare")
        countView = 0
        print("count.. disapear call")
    }
    
    // Main VC Implementation for ProgressBar
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        
        print("Index Selected")
    }
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     willSelectItemAtIndex index: Int) {
        
        print("Index selected!")
        
        
        SelectedViewIndex = index
    }
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return true
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if position == FlexibleSteppedProgressBarTextLocation.bottom {
            switch index {
                
            case 0: return "Details"
            case 1: return "Category"
            case 2: return "Location"
            case 3: return "Post"
                
                
            default:
                return ""
            }
        }
        return ""
    }
    
    
    
}


