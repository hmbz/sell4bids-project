//
//  ServiceListingStepMainVC.swift
//  Sell4Bids
//
//  Created by Admin on 20/02/2019.
//  Copyright © 2019 admin. All rights reserved.


import UIKit
import FlexibleSteppedProgressBar


class ServiceListingStepMainVC: UIViewController, FlexibleSteppedProgressBarDelegate {
    
    // Service's Connections_Outlets || Actions
    @IBOutlet weak var ServiceProgressBar: FlexibleSteppedProgressBar!
    @IBOutlet weak var ServiceMainView: UIView!
    // Servive Button_Outlets
    @IBOutlet weak var ServiceNextbtn: ButtonShahdow!
    @IBOutlet weak var ServiceBackbtn: ButtonShahdow!
    
    // Variable:
    var SelectedViewIndex : Int?
    var ArrayServiceView = [UIViewController]()
    var countView = 0
    var currency_String = String()
    var currency_Symbol = String()
    var NumericalArray = ["1","2","3","4","5","6","7","8","9","0"]
    var mainApi = MainSell4BidsApi()
    var latitude = Double()
    var longtitude = Double()
    var selectButton = String()
    var negotiableSwitch = String()
    var acceptoffer = String()
    var listIdentefily = String()
    let DoneAlertView = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    let DoneView = Bundle.main.loadNibNamed("Item_Listing_Done_Custom_View", owner: self, options: nil)?.first as! ItemListingDoneCustom
    
    let appColor = UIColor(red: 0.76, green: 0.25, blue: 0.18 , alpha: 1.0)
    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var Errorimg: UIImageView!
    // Connection variables of All Three Views in Jobs
    
    let ServiceListingStep1VariableVC = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "ServiceListingStep1-Identifier") as! ServiceListingStep1VC
    let ServiceListingStep2VariableVC = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "ServiceListingStepTwoIdentifier") as! ServiceListingStep2VC
    let ServiceListingStep3VariableVC = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "ServiceListingStepThreeVCIdentifier") as! ServiceListingStep3VC
    let ServiceListingSelectLocationVariableVC = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "ItemListing-Step-Four") as! ItemListingFour
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        DoneView.succesfullayMessage.text = listingFinalMessage.instance.service
        addInviteBarButtonToTop()
        addLeftHomeBarButtonToTop()
        addLogoWithLeftBarButton()
        self.title = "List Services"
        ServiceBackbtn.isHidden = true
        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
        
        ArrayServiceView.append(ServiceListingStep1VariableVC)
        ArrayServiceView.append(ServiceListingStep2VariableVC)
        ArrayServiceView.append(ServiceListingSelectLocationVariableVC)
        ArrayServiceView.append(ServiceListingStep3VariableVC)
        
        
        ArrayServiceView[countView].view.frame = self.ServiceMainView.frame
        self.ServiceMainView.addSubview(ArrayServiceView[countView].view)
        
        ServiceProgressBar.currentSelectedTextColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1)/*UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)*/
        ServiceProgressBar.currentSelectedCenterColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1) /*UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)*/
        ServiceProgressBar.selectedOuterCircleStrokeColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1) /*UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)*/
        
        self.view.gestureRecognizers?.forEach(self.view.removeGestureRecognizer(_:))
        
        
        
        ServiceProgressBar.delegate = self
        DoneView.DoneBtn.addTarget(self, action: #selector(Done_btn_Action), for: .touchUpInside)
        
        ServiceBackbtn.endEditing(true)
        ServiceNextbtn.endEditing(true)
        
        
        
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
    
    
    @IBAction func ServiceBackBtnOpt(_ sender: Any) {
        
        
        if  countView < 2 {
            
            ServiceBackbtn.isHidden = true
        }
        if  countView < 4 {
            
            ServiceNextbtn.setTitle("Next", for: .normal)
            ServiceNextbtn.setTitleColor(UIColor.white, for: .normal)
            ServiceNextbtn.backgroundColor = UIColor.black
        }
        
        if countView > 0 {
            countView -= 1
            ArrayServiceView[countView].view.frame = self.ServiceMainView.frame
            self.ServiceMainView.addSubview(ArrayServiceView[countView].view)
            ServiceProgressBar.currentIndex = countView
            
        }
        
    }
    
    
    
    @IBAction func ServiceNextBtnOpt(_ sender: Any) {
        // @OM 11-02-2019 (For Progress bar Implementation)
        
        
        if countView == 0 {
            
            if ServiceListingStep1VariableVC.imageList.count <= 0 {
                
                _ = SweetAlert().showAlert("Photos", subTitle:"  Please add atleast 01 photo of your Service.  " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                return
            }
            else if(ServiceListingStep1VariableVC.imageList.count > 15){
                let kTitle = "Photos"
                _ = SweetAlert().showAlert( String(kTitle.suffix(30)) , subTitle:"  Maximum 14 photos are allowed to upload." , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                return
            }
                
            else if ((ServiceListingStep1VariableVC.ServiceTitleTextField.text?.isEmpty)!) {
                
                print("TitleError TextFieldWorking === 1")
                
                _ = SweetAlert().showAlert("Item Title", subTitle:" Please enter a suitable title for your Service. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                return
            }
            else if (ServiceListingStep1VariableVC.ServiceTitleTextField.text?.count)! < 3 || (ServiceListingStep1VariableVC.ServiceTitleTextField.text?.count)! > 50 {
                print("check count \(ServiceListingStep1VariableVC.ServiceTitleTextField.text?.count ?? 0)")
                _ = SweetAlert().showAlert("Item Title", subTitle:"  Title must have at-least 03 characters. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                
                countView = 0
                print("TitleError TextFieldWorking === 2")
                return
                
            }
            else if (ServiceListingStep1VariableVC.ServiceTitleTextField.text?.count)! >= 70{
                _ = SweetAlert().showAlert("Item Title", subTitle:" Title must not exceed 70 characters. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                print("TitleError TextFieldWorking === 2")
                return
            }
            else if (ServiceListingStep1VariableVC.WantSwitch.isOn == false)
                && (ServiceListingStep1VariableVC.OfferSwitch.isOn == false)
            {
                _ = SweetAlert().showAlert("Selection", subTitle:" Please select want or offer " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                print("TitleError TextFieldWorking === 2")
                return
            }
            
            
            
            ServiceBackbtn.isHidden = false
            ServiceBackbtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            ServiceBackbtn.layer.shadowOffset = CGSize(width: 1, height: 3)
            ServiceBackbtn.layer.shadowOpacity = 1.0
            ServiceBackbtn.layer.shadowRadius = 10.0
            ServiceBackbtn.layer.masksToBounds = true
            ServiceBackbtn.backgroundColor = UIColor.black
            ServiceBackbtn.layer.cornerRadius = 20
            ServiceNextbtn.setTitle("Next", for: .normal)
            ServiceNextbtn.setTitleColor(UIColor.white, for: .normal)
            ServiceNextbtn.backgroundColor = UIColor.black
            countView = 1
            ArrayServiceView[countView].view.frame = self.ServiceMainView.frame
            self.ServiceMainView.addSubview(ArrayServiceView[countView].view)
            
            ServiceProgressBar.currentIndex = countView
            print("count == \(countView)")
            
            if ServiceListingStep1VariableVC.OfferSwitch.isOn == true{
                selectButton = "\(ServiceListingStep1VariableVC.selectbtn)"
                print("selectButton_Offer ==!\(selectButton)")
            }
            if ServiceListingStep1VariableVC.WantSwitch.isOn == true{
                selectButton = "\(ServiceListingStep1VariableVC.selectbtn)"
                print("selectButton_Want ==!\(selectButton)")
            }
        }
        else if countView == 1{
            print("count... 1 = \(countView)")
            
            if
                (ServiceListingStep2VariableVC.ServiceTypeTextField.text == "Select Service Type" ) || (ServiceListingStep2VariableVC.ServiceTypeTextField.text == "" )
            {
                ServiceListingStep2VariableVC.ServiceTypeTextField.shake()
                
                _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"  Please select service type. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 1
                
                print("TakeSelectCategory TextFieldWorking === 1")
                return
            }
                
            else if ((ServiceListingStep2VariableVC.ServiceDescriptionTextView.text?.isEmpty)!)
            {
                
                print("DescriptionError in TextField === 1")
                
                _ = SweetAlert().showAlert("Description", subTitle:"  Please Enter Service Description " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 1
                return
            }
            else if (ServiceListingStep2VariableVC.ServiceDescriptionTextView.text?.count)! < 20
            {
                print("DescriptionTextFieldWorking ===")
                _ = SweetAlert().showAlert("Description", subTitle:"   Please enter a description for your Service with minimum 20 characters. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                
                countView = 1
                return
            }
            else if ((ServiceListingStep2VariableVC.ServiceDescriptionTextView.text?.count)! > 1200){
                _ = SweetAlert().showAlert("Description", subTitle:"   Description must not exceed 1200 characters. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 2
                return
            }
            
            ServiceBackbtn.isHidden = false
            ServiceBackbtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            ServiceBackbtn.layer.shadowOffset = CGSize(width: 1, height: 3)
            ServiceBackbtn.layer.shadowOpacity = 1.0
            ServiceBackbtn.layer.shadowRadius = 10.0
            ServiceBackbtn.layer.masksToBounds = true
            ServiceBackbtn.backgroundColor = UIColor.black
            ServiceBackbtn.layer.cornerRadius = 20
            ServiceNextbtn.setTitle("Next", for: .normal)
            ServiceNextbtn.setTitleColor(UIColor.white, for: .normal)
            ServiceNextbtn.backgroundColor = UIColor.black
            countView = 2
            ArrayServiceView[countView].view.frame = self.ServiceMainView.frame
            self.ServiceMainView.addSubview(ArrayServiceView[countView].view)
            
            ServiceProgressBar.currentIndex = countView
            print("countView == 2 \(countView)")
            
            
            
        }
            
        else if countView == 2{
            
            if ServiceListingSelectLocationVariableVC.latitude == 0.0 && ServiceListingSelectLocationVariableVC.longtitude == 0.0 || ServiceListingSelectLocationVariableVC.country.isEmpty && ServiceListingSelectLocationVariableVC.city.isEmpty && ServiceListingSelectLocationVariableVC.state.isEmpty {
                
                _ = SweetAlert().showAlert("Location", subTitle:"Please select your location." , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                
                countView = 2
                return
            }
            
            
            ServiceBackbtn.isHidden = false
            ServiceBackbtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            ServiceBackbtn.layer.shadowOffset = CGSize(width: 1, height: 3)
            ServiceBackbtn.layer.shadowOpacity = 1.0
            ServiceBackbtn.layer.shadowRadius = 10.0
            ServiceBackbtn.layer.masksToBounds = true
            ServiceBackbtn.backgroundColor = UIColor.black
            ServiceBackbtn.layer.cornerRadius = 20
            ServiceNextbtn.setTitle("Finish", for: .normal)
            ServiceNextbtn.setTitleColor(UIColor.white, for: .normal)
            ServiceNextbtn.backgroundColor = UIColor.red
            countView = 3
            ArrayServiceView[countView].view.frame = self.ServiceMainView.frame
            self.ServiceMainView.addSubview(ArrayServiceView[countView].view)
            
            ServiceProgressBar.currentIndex = countView
            print("count == \(countView)")
            
            // perform work here
            let country = ServiceListingSelectLocationVariableVC.country.uppercased()
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
                ServiceListingStep3VariableVC.DollarLabel.text = currency_TwoDigitCode + " " + user_Selected_Currency_Symbol
                ServiceListingStep3VariableVC.currencyBtn.setTitle("\(currency_TwoDigitCode + " " + user_Selected_Currency_Symbol)", for: .normal)
                
                ServiceListingStep3VariableVC.currency_Symbol = user_Selected_Currency_Symbol
                print("currency_Symbol == \(ServiceListingStep3VariableVC.currency_Symbol)")
                ServiceListingStep3VariableVC.currency_String = currency_TwoDigitCode
                print("currency_String == \(ServiceListingStep3VariableVC.currency_String)")
            }else{
                ServiceListingStep3VariableVC.DollarLabel.text = currency_ThreeDigitCode + " " + user_Selected_Currency_Symbol
                ServiceListingStep3VariableVC.currencyBtn.setTitle("\(currency_ThreeDigitCode + " " + user_Selected_Currency_Symbol)", for: .normal)
                
                ServiceListingStep3VariableVC.currency_Symbol = user_Selected_Currency_Symbol
                print("currency_Symbol == \(ServiceListingStep3VariableVC.currency_Symbol)")
                ServiceListingStep3VariableVC.currency_String = currency_ThreeDigitCode
                print("currency_String == \(ServiceListingStep3VariableVC.currency_String)")
            }
        }
            
        else if countView == 3{
            
            if ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isOn == false {
                
                if ((ServiceListingStep3VariableVC.JobSalaryTextField.text?.isEmpty)!){
                    
                    print("Price TextField === 1")
                    
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter Price " , style: .error,buttonTitle:
                        "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    countView = 3
                    return
                }
                    
                else if (!ServiceListingStep3VariableVC.JobSalaryTextField.text!.isEmpty) {
                    
                    let price : Int = Int(ServiceListingStep3VariableVC.JobSalaryTextField.text!)!
                    
                    if price <= 0 {
                        
                        countView = 3
                        
                        _ = SweetAlert().showAlert("Invalid price", subTitle:"   Price must be greater than 0." , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        return
                        
                    }
                        
                        
                    else if ((ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.listingDurationTextField.text?.isEmpty)!){
                        
                        print("Price TextField === 1")
                        _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter list days " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                        countView = 3
                        return
                    }
                        
                    else if (ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.payPeriodTextField.text?.isEmpty == true ){
                        
                        ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.payPeriodTextField.shake()
                        
                        _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"  Please select Pay period. " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        countView = 3
                        
                        return
                        
                    }
                    
                    
                    
                }
            }
                
            else if ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isOn == true {
                
                if ((ServiceListingStep3VariableVC.JobSalaryTextField.text?.isEmpty)!){
                    
                    print("Price TextField === 1")
                    
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter Price " , style: .error,buttonTitle:
                        "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    countView = 3
                    return
                }
                    
                else if (!ServiceListingStep3VariableVC.JobSalaryTextField.text!.isEmpty) {
                    
                    let price : Int = Int(ServiceListingStep3VariableVC.JobSalaryTextField.text!)!
                    
                    if price <= 0 {
                        
                        countView = 3
                        
                        _ = SweetAlert().showAlert("Invalid price", subTitle:"   Price must be greater then 0." , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        return
                        
                    }
                        
                    else if (ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.payPeriodTextField.text?.isEmpty == true ){
                        
                        ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.payPeriodTextField.shake()
                        
                        _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"  Please select Pay period. " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        countView = 3
                        
                        return
                        
                    }
                    
                    
                    
                }
            }
            
            if ServiceListingStep3VariableVC.AcceptOffer == true {
                
                negotiableSwitch = "true"
            }
            else{
                
                negotiableSwitch = "false"
            }
            print("selected_date ==!\(ServiceListingStep3VariableVC.selected_date)")
            print("SelectButton_CountView_3 == \(ServiceListingStep1VariableVC.selectbtn)")
            print("Print_1\(ServiceListingStep1VariableVC.WantSwitch.isOn)")
            print("Print_1.1\(ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isOn)")
            let ServiceBasePrice = ServiceListingStep3VariableVC.JobSalaryTextField.text!.split(separator: "$")
            
            if ServiceListingStep1VariableVC.selectbtn == "Want" && ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isOn == true{
                
                print("SelectButton_1 == \(ServiceListingStep1VariableVC.selectbtn)")
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                
                // OsamaMansoori (24-07-2019)
                mainApi.ServiceListing_Api(lat: ServiceListingSelectLocationVariableVC.latitude  , lng: ServiceListingSelectLocationVariableVC.longtitude  , user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image, user_ID: SessionManager.shared.userId, country: ServiceListingSelectLocationVariableVC.country, city: ServiceListingSelectLocationVariableVC.city, title: "\(ServiceListingStep1VariableVC.ServiceTitleTextField.text!)", serviceType: "\(ServiceListingStep2VariableVC.ServiceTypeTextField.text!)", description: "\(ServiceListingStep2VariableVC.ServiceDescriptionTextView.text!)", currency_string: ServiceListingStep3VariableVC.currency_String, currency_symbol: ServiceListingStep3VariableVC.currency_Symbol, servicePrice : "\(ServiceBasePrice[0])", negotiable: negotiableSwitch, zipCode: ServiceListingSelectLocationVariableVC.zipcode, visibility: true, UI_Image: ServiceListingStep1VariableVC.imageList, itemAuctionType: "buy-it-now", itemCategory: "Services", endTime: "-1", payPeriod: "\(ServiceListingStep3VariableVC.Select_payPeriod)", userRole: "\(ServiceListingStep1VariableVC.selectbtn)", selectButton: ServiceListingStep1VariableVC.selectbtn, State: ServiceListingSelectLocationVariableVC.state){ (status, data, error) in
                    
                    
                    
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
                            
                            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        if error.contains("The request timed out.") {
                            
                            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
            
            print("Print_2\(ServiceListingStep1VariableVC.WantSwitch.isOn)")
            print("Print_2.2\(ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isOn)")
            
            if ServiceListingStep1VariableVC.selectbtn == "Want"
                && ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isOn == false{
                
                print("SelectButton_2 == \(ServiceListingStep1VariableVC.selectbtn)")
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                // OsamaMansoori (24-07-2019)
                mainApi.ServiceListing_Api(lat: ServiceListingSelectLocationVariableVC.latitude  , lng: ServiceListingSelectLocationVariableVC.longtitude  , user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image, user_ID: SessionManager.shared.userId, country: ServiceListingSelectLocationVariableVC.country, city: ServiceListingSelectLocationVariableVC.city, title: "\(ServiceListingStep1VariableVC.ServiceTitleTextField.text!)", serviceType: "\(ServiceListingStep2VariableVC.ServiceTypeTextField.text!)", description: "\(ServiceListingStep2VariableVC.ServiceDescriptionTextView.text!)", currency_string: ServiceListingStep3VariableVC.currency_String, currency_symbol: ServiceListingStep3VariableVC.currency_Symbol, servicePrice : "\(ServiceBasePrice[0])", negotiable: negotiableSwitch, zipCode: ServiceListingSelectLocationVariableVC.zipcode, visibility: true, UI_Image: ServiceListingStep1VariableVC.imageList, itemAuctionType: "buy-it-now", itemCategory: "Services", endTime: "\(ServiceListingStep3VariableVC.selected_date)", payPeriod: "\(ServiceListingStep3VariableVC.Select_payPeriod)", userRole: "\(ServiceListingStep1VariableVC.selectbtn)", selectButton: ServiceListingStep1VariableVC.selectbtn, State: ServiceListingSelectLocationVariableVC.state){ (status, data, error) in
                    
                    
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
                            
                            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        if error.contains("The request timed out.") {
                            
                            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
            
            
            print("Print_3\(ServiceListingStep1VariableVC.OfferSwitch.isOn)")
            print("Print_3.3\(ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isOn)")
            
            if ServiceListingStep1VariableVC.selectbtn == "Offer" && ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isOn == false{
                
                print("SelectButton_3 == \(ServiceListingStep1VariableVC.selectbtn)")
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                
                mainApi.ServiceListing_Api(lat: ServiceListingSelectLocationVariableVC.latitude , lng: ServiceListingSelectLocationVariableVC.longtitude , user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image , user_ID: SessionManager.shared.userId, country: ServiceListingSelectLocationVariableVC.country, city: ServiceListingSelectLocationVariableVC.city, title: "\(ServiceListingStep1VariableVC.ServiceTitleTextField.text!)", serviceType: "\(ServiceListingStep2VariableVC.ServiceTypeTextField.text!)", description: "\(ServiceListingStep2VariableVC.ServiceDescriptionTextView.text!)", currency_string: ServiceListingStep3VariableVC.currency_String, currency_symbol: ServiceListingStep3VariableVC.currency_Symbol, servicePrice : "\(ServiceBasePrice[0])", negotiable: negotiableSwitch, zipCode: ServiceListingSelectLocationVariableVC.zipcode, visibility: true, UI_Image: ServiceListingStep1VariableVC.imageList, itemAuctionType: "buy-it-now", itemCategory: "Services", endTime: "\(ServiceListingStep3VariableVC.selected_date)", payPeriod: "\(ServiceListingStep3VariableVC.Select_payPeriod)", userRole: "\(ServiceListingStep1VariableVC.selectbtn)", selectButton: ServiceListingStep1VariableVC.selectbtn, State: ServiceListingSelectLocationVariableVC.state){ (status, data, error) in
                    
                    
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
                            
                            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        if error.contains("The request timed out.") {
                            
                            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
            
            print("Print_4\(ServiceListingStep1VariableVC.OfferSwitch.isOn)")
            print("Print_4.4\(ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isOn)")
            
            if ServiceListingStep1VariableVC.selectbtn == "Offer" && ServiceListingStep3VariableVC.TakeDurationAndOffersCustom.listIndefinitelySwitch.isOn == true{
                
                print("SelectButton_4 == \(ServiceListingStep1VariableVC.selectbtn)")
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                mainApi.ServiceListing_Api(lat: ServiceListingSelectLocationVariableVC.latitude , lng: ServiceListingSelectLocationVariableVC.longtitude , user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image , user_ID: SessionManager.shared.userId, country: ServiceListingSelectLocationVariableVC.country, city: ServiceListingSelectLocationVariableVC.city, title: "\(ServiceListingStep1VariableVC.ServiceTitleTextField.text!)", serviceType: "\(ServiceListingStep2VariableVC.ServiceTypeTextField.text!)", description: "\(ServiceListingStep2VariableVC.ServiceDescriptionTextView.text!)", currency_string: ServiceListingStep3VariableVC.currency_String, currency_symbol: ServiceListingStep3VariableVC.currency_Symbol, servicePrice : "\(ServiceBasePrice[0])", negotiable: negotiableSwitch, zipCode: ServiceListingSelectLocationVariableVC.zipcode, visibility: true, UI_Image: ServiceListingStep1VariableVC.imageList, itemAuctionType: "buy-it-now", itemCategory: "Services", endTime: "-1", payPeriod: "\(ServiceListingStep3VariableVC.Select_payPeriod)", userRole: "\(ServiceListingStep1VariableVC.selectbtn)", selectButton: ServiceListingStep1VariableVC.selectbtn, State: ServiceListingSelectLocationVariableVC.state){ (status, data, error) in
                    
                    
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
                            
                            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            
                            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                            let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                            alert.addAction(ok)
                            Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        if error.contains("The request timed out.") {
                            
                            let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
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
                
                
            case 0: return "Title"
            case 1: return "Details"
            case 2: return "Location"
            case 3: return "Post"
                
                
            default:
                return ""
            }
        }
        return ""
    }
    
    
    
}
