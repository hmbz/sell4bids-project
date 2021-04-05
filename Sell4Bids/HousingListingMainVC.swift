//
//  HousingListing_MainVC.swift
//  Sell4Bids
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 admin. All rights reserved.
//  Osama Mansoori

import UIKit
import FlexibleSteppedProgressBar

class HousingListingMainVC: UIViewController, FlexibleSteppedProgressBarDelegate,UITableViewDelegate {
    
    @IBOutlet weak var FlexableBarView: ShadowView!
    
    var SelectedViewIndex = 0
    var ArrayItemsView = [UIViewController]()
    var countView = Int()
    var currency_String = String()
    var currency_Symbol = String()
    var selectOption = String()
    var mainApi = MainSell4BidsApi()
    var latitude = Double()
    var longtitude = Double()
    var listIdentifily = String()
    var accecptOffer = String()
    var autoRelisting = String()
    var Auction_auto_relistingString = String()
    let DoneAlertView = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    let DoneView = Bundle.main.loadNibNamed("Item_Listing_Done_Custom_View", owner: self, options: nil)?.first as! ItemListingDoneCustom
    var itemAuctionType = String()
    
    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var Errorimg: UIImageView!
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.ArrayItemsView[self.countView].view.frame = self.MainItemViewContainer_Outlet.frame
            self.FlexableBarView.frame = self.FlexableBarView.frame
        }
        
        
    }
    
    
    var HousingListingOne = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "HousingListing-1-Identifier") as! HousingListingStepOne
    var HousingListingTwo = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "HousingListing-2-Identifier") as! HousingListingStepTwo
    var ItemListingStepThree = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "ItemBuyandAction") as! ItemListingStepThree
    var ItemListingStepFour = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "ItemListing-Step-Four") as! ItemListingFour
    
    
    @IBOutlet weak var NextBtn: ButtonShahdow!
    @IBOutlet weak var BackBtn: ButtonShahdow!
    @IBOutlet weak var MainItemViewContainer_Outlet: UIView!
    @IBOutlet weak var Itemprogessbar: FlexibleSteppedProgressBar!
    
    @IBAction func dismisskeyboard(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DoneView.succesfullayMessage.text = "This Housing listing is pending for the approval from Admin."
        
        addInviteBarButtonToTop()
        addLeftHomeBarButtonToTop()
        addLogoWithLeftBarButton()
        self.title = "List Housing"
        
        BackBtn.isHidden = true
        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
        
        ArrayItemsView.append(HousingListingOne)
        ArrayItemsView.append(HousingListingTwo)
        ArrayItemsView.append(ItemListingStepFour)
        ArrayItemsView.append(ItemListingStepThree)
        
        
        BackBtn.makeRedAndRound()
        NextBtn.makeRedAndRound()
        ArrayItemsView[0].view.frame = self.MainItemViewContainer_Outlet.frame
        self.MainItemViewContainer_Outlet.addSubview(ArrayItemsView[0].view)
        
        Itemprogessbar.delegate = self
        
        
        Itemprogessbar.currentSelectedTextColor = UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)
        Itemprogessbar.currentSelectedCenterColor = UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)
        Itemprogessbar.selectedOuterCircleStrokeColor = UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)
        DoneView.DoneBtn.addTarget(self, action: #selector(Done_btn_Action), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NextBtn.endEditing(true)
        BackBtn.endEditing(true)
        MainItemViewContainer_Outlet.endEditing(true)
        Itemprogessbar.endEditing(true)
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
                
            case 0: return "Photo"
            case 1: return "Details"
            case 2: return "Location"
            case 3: return "Finish"
                
                
            default:
                return ""
            }
        }
        return ""
    }
    
    // @PopUps/Validations change by SyedSaadAhmed(18-June)
    // @OM 25-02-2019 (For Progress bar Implementation)
    @IBAction func NextBtnOpt(_ sender: Any) {
        
        
        if countView == 0{
            
            print("count..0 = /\(countView)")
            
            if HousingListingOne.imageList.count <= 0 {
                
                _ = SweetAlert().showAlert("Photos", subTitle:"  Please add atleast 01 photo of your item.  " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                return
                
            }
            else if(HousingListingOne.imageList.count > 15)
            {
                let kTitle = "Photos"
                _ = SweetAlert().showAlert( String(kTitle.suffix(30)) , subTitle:"  Maximum 14 photos are allowed to upload." , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                return
            }
                
            else if ((HousingListingOne.ItemTitle.text?.isEmpty)!) {
                
                print("TitleError TextFieldWorking === 1")
                
                _ = SweetAlert().showAlert("Item Title", subTitle:" Please enter a suitable title for your item. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                return
            }
                
            else if (HousingListingOne.ItemTitle.text?.count)! < 3
            {
                print("check count \(HousingListingOne.ItemTitle.text?.count ?? 0)")
                
                _ = SweetAlert().showAlert("Item Title", subTitle:"    Title must have at-least 03 characters. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                return
                
            }
            else if(HousingListingOne.ItemTitle.text?.count)! >= 70
            {
                _ = SweetAlert().showAlert("Item Title", subTitle:" Title must not exceed 70 characters. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                print("TitleError TextFieldWorking === 2")
                return
            }
            else if (HousingListingOne.SelectCategoryName.text == "Select Category" ) || (HousingListingOne.SelectCategoryName.text == "" )
            {
                
                HousingListingOne.SelectCategoryName.shake()
                
                _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"  Please select related category. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                
                print("TakeSelectCategory TextFieldWorking === 1")
                return
                
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
            ArrayItemsView[countView].view.frame = self.MainItemViewContainer_Outlet.frame
            self.MainItemViewContainer_Outlet.addSubview(ArrayItemsView[countView].view)
            
            let category = HousingListingOne.SelectCategoryName.text!
            if category == "Rooms & Shared" || category == "Sublets & Temporary"{
                HousingListingTwo.bathroomArray = ["Private room","Shared room"]
                HousingListingTwo.bedroomArray = ["Private room","Shared room"]
                HousingListingTwo.realEstateViewHeights.constant = 90
                HousingListingTwo.realEstateTextField.isHidden = false
                HousingListingTwo.bedroomViewHeight.constant = 90
                HousingListingTwo.bedroomsTextField.isHidden = false
                HousingListingTwo.bathroomViewHeights.constant = 90
                HousingListingTwo.bathroomTextField.isHidden = false
                HousingListingTwo.laundryViewHeights.constant = 90
                HousingListingTwo.laundryTextField.isHidden = false
                HousingListingTwo.parkingViewHeights.constant = 90
                HousingListingTwo.parkingTextField.isHidden = false
                HousingListingTwo.squareFeetViewHeights.constant = 90
                HousingListingTwo.squareFeetTextField.isHidden = false
                HousingListingTwo.availbleViewHeights.constant = 90
                HousingListingTwo.availableDateTextField.isHidden = false
                HousingListingTwo.openHouseHeights.constant = 90
                HousingListingTwo.openHouseDateTextField.isHidden = false
                HousingListingTwo.additionalViewHeights.constant = 150
            }
            else if category == "Rooms Wanted"{
                HousingListingTwo.bathroomArray = ["0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8+"]
                HousingListingTwo.bedroomArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
                HousingListingTwo.realEstateViewHeights.constant = 0
                HousingListingTwo.realEstateTextField.isHidden = true
                HousingListingTwo.bedroomViewHeight.constant = 0
                HousingListingTwo.bedroomsTextField.isHidden = true
                HousingListingTwo.bathroomViewHeights.constant = 0
                HousingListingTwo.bathroomTextField.isHidden = true
                HousingListingTwo.laundryViewHeights.constant = 0
                HousingListingTwo.laundryTextField.isHidden = true
                HousingListingTwo.parkingViewHeights.constant = 0
                HousingListingTwo.parkingTextField.isHidden = true
                HousingListingTwo.squareFeetViewHeights.constant = 90
                HousingListingTwo.squareFeetTextField.isHidden = false
                HousingListingTwo.availbleViewHeights.constant = 0
                HousingListingTwo.availableDateTextField.isHidden = true
                HousingListingTwo.openHouseHeights.constant = 0
                HousingListingTwo.openHouseDateTextField.isHidden = true
                HousingListingTwo.additionalViewHeights.constant = 150
                
            }
            else if category == "Office & Commercial" || category == "Parking & Storage"{
                HousingListingTwo.bathroomArray = ["0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8+"]
                HousingListingTwo.bedroomArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
                HousingListingTwo.realEstateViewHeights.constant = 0
                HousingListingTwo.realEstateTextField.isHidden = true
                HousingListingTwo.bedroomViewHeight.constant = 0
                HousingListingTwo.bedroomsTextField.isHidden = true
                HousingListingTwo.bathroomViewHeights.constant = 0
                HousingListingTwo.bathroomTextField.isHidden = true
                HousingListingTwo.laundryViewHeights.constant = 0
                HousingListingTwo.laundryTextField.isHidden = true
                HousingListingTwo.parkingViewHeights.constant = 0
                HousingListingTwo.parkingTextField.isHidden = true
                HousingListingTwo.squareFeetViewHeights.constant = 90
                HousingListingTwo.squareFeetTextField.isHidden = false
                HousingListingTwo.availbleViewHeights.constant = 0
                HousingListingTwo.availableDateTextField.isHidden = true
                HousingListingTwo.openHouseHeights.constant = 0
                HousingListingTwo.openHouseDateTextField.isHidden = true
                HousingListingTwo.additionalViewHeights.constant = 0
                
            }
            else {
                HousingListingTwo.bathroomArray = ["0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8+"]
                HousingListingTwo.bedroomArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
                HousingListingTwo.realEstateViewHeights.constant = 90
                HousingListingTwo.realEstateTextField.isHidden = false
                HousingListingTwo.bedroomViewHeight.constant = 90
                HousingListingTwo.bedroomsTextField.isHidden = false
                HousingListingTwo.bathroomViewHeights.constant = 90
                HousingListingTwo.bathroomTextField.isHidden = false
                HousingListingTwo.laundryViewHeights.constant = 90
                HousingListingTwo.laundryTextField.isHidden = false
                HousingListingTwo.parkingViewHeights.constant = 90
                HousingListingTwo.parkingTextField.isHidden = false
                HousingListingTwo.squareFeetViewHeights.constant = 90
                HousingListingTwo.squareFeetTextField.isHidden = false
                HousingListingTwo.availbleViewHeights.constant = 90
                HousingListingTwo.availableDateTextField.isHidden = false
                HousingListingTwo.openHouseHeights.constant = 90
                HousingListingTwo.openHouseDateTextField.isHidden = false
                HousingListingTwo.additionalViewHeights.constant = 150
            }
            
            
            Itemprogessbar.currentIndex = countView
            print("count == 1 \(countView)")
            
        }
            
        else if countView == 1{
            
            let category = HousingListingOne.SelectCategoryName.text!
            if category == "Rooms & Shared" || category == "Sublets & Temporary"{
                if HousingListingTwo.realEstateTextField.text!.isEmpty {
                    self.view.makeToast("Please Select real estate", position:.top)
                    HousingListingTwo.realEstateTextField.becomeFirstResponder()
                }
                else if HousingListingTwo.bedroomsTextField.text!.isEmpty{
                    self.view.makeToast("Please Select No of bedrooms", position:.top)
                    HousingListingTwo.bedroomsTextField.becomeFirstResponder()
                }
                else if HousingListingTwo.bathroomTextField.text!.isEmpty{
                    self.view.makeToast("Please Select No of bathrooms", position:.top)
                    HousingListingTwo.bathroomTextField.becomeFirstResponder()
                }
                else if HousingListingTwo.laundryTextField.text!.isEmpty{
                    self.view.makeToast("Please Select Laundry", position:.top)
                    HousingListingTwo.laundryTextField.becomeFirstResponder()
                }
                else if HousingListingTwo.parkingTextField.text!.isEmpty{
                    self.view.makeToast("Please Select parking", position:.top)
                    HousingListingTwo.parkingTextField.becomeFirstResponder()
                }
                else if HousingListingTwo.descriptionTextView.text!.isEmpty{
                    self.view.makeToast("Please enter descrition at least 50 words", position:.top)
                    HousingListingTwo.descriptionTextView.becomeFirstResponder()
                }
                else if HousingListingTwo.squareFeetTextField.text!.isEmpty{
                    self.view.makeToast("Please enter area", position:.top)
                    HousingListingTwo.squareFeetTextField.becomeFirstResponder()
                }
                else if HousingListingTwo.availableDateTextField.text!.isEmpty{
                    self.view.makeToast("Please specify available date", position:.top)
                    HousingListingTwo.descriptionTextView.becomeFirstResponder()
                }else {
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
                    ArrayItemsView[countView].view.frame = self.MainItemViewContainer_Outlet.frame
                    self.MainItemViewContainer_Outlet.addSubview(ArrayItemsView[countView].view)
                    Itemprogessbar.currentIndex = countView
                    print("countView ==  \(countView)")
                }
            }
            else if category == "Rooms Wanted"{
                
                 if HousingListingTwo.descriptionTextView.text!.isEmpty{
                    self.view.makeToast("Please enter descrition at least 50 words", position:.top)
                    HousingListingTwo.descriptionTextView.becomeFirstResponder()
                }
                else if HousingListingTwo.squareFeetTextField.text!.isEmpty{
                    self.view.makeToast("Please enter area", position:.top)
                    HousingListingTwo.squareFeetTextField.becomeFirstResponder()
                }
                else {
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
                    ArrayItemsView[countView].view.frame = self.MainItemViewContainer_Outlet.frame
                    self.MainItemViewContainer_Outlet.addSubview(ArrayItemsView[countView].view)
                    Itemprogessbar.currentIndex = countView
                    print("countView ==  \(countView)")
                }
            }
            else if category == "Office & Commercial" || category == "Parking & Storage"{
                if HousingListingTwo.descriptionTextView.text!.isEmpty{
                    self.view.makeToast("Please enter descrition at least 50 words", position:.top)
                    HousingListingTwo.descriptionTextView.becomeFirstResponder()
                }
                else if HousingListingTwo.squareFeetTextField.text!.isEmpty{
                    self.view.makeToast("Please enter area", position:.top)
                    HousingListingTwo.squareFeetTextField.becomeFirstResponder()
                }
                else {
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
                    ArrayItemsView[countView].view.frame = self.MainItemViewContainer_Outlet.frame
                    self.MainItemViewContainer_Outlet.addSubview(ArrayItemsView[countView].view)
                    Itemprogessbar.currentIndex = countView
                    print("countView ==  \(countView)")
                }
            }
            else {
                if HousingListingTwo.realEstateTextField.text!.isEmpty {
                    self.view.makeToast("Please Select real estate", position:.top)
                    HousingListingTwo.realEstateTextField.becomeFirstResponder()
                }
                else if HousingListingTwo.bedroomsTextField.text!.isEmpty{
                    self.view.makeToast("Please Select No of bedrooms", position:.top)
                    HousingListingTwo.bedroomsTextField.becomeFirstResponder()
                }
                else if HousingListingTwo.bathroomTextField.text!.isEmpty{
                    self.view.makeToast("Please Select No of bathrooms", position:.top)
                    HousingListingTwo.bathroomTextField.becomeFirstResponder()
                }
                else if HousingListingTwo.laundryTextField.text!.isEmpty{
                    self.view.makeToast("Please Select Laundry", position:.top)
                    HousingListingTwo.laundryTextField.becomeFirstResponder()
                }
                else if HousingListingTwo.parkingTextField.text!.isEmpty{
                    self.view.makeToast("Please Select parking", position:.top)
                    HousingListingTwo.parkingTextField.becomeFirstResponder()
                }
                else if HousingListingTwo.descriptionTextView.text!.isEmpty{
                    self.view.makeToast("Please enter descrition at least 50 words", position:.top)
                    HousingListingTwo.descriptionTextView.becomeFirstResponder()
                }
                else if HousingListingTwo.squareFeetTextField.text!.isEmpty{
                    self.view.makeToast("Please enter area", position:.top)
                    HousingListingTwo.squareFeetTextField.becomeFirstResponder()
                }
                else if HousingListingTwo.availableDateTextField.text!.isEmpty{
                    self.view.makeToast("Please specify available date", position:.top)
                    HousingListingTwo.descriptionTextView.becomeFirstResponder()
                }else {
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
                    ArrayItemsView[countView].view.frame = self.MainItemViewContainer_Outlet.frame
                    self.MainItemViewContainer_Outlet.addSubview(ArrayItemsView[countView].view)
                    Itemprogessbar.currentIndex = countView
                    print("countView ==  \(countView)")
                }
            }
            
            print("count... 1 = \(countView)")
        }
            
        else if countView == 2{
            
            
            if ItemListingStepFour.latitude == 0 && ItemListingStepFour.longtitude == 0 && ItemListingStepFour.city.isEmpty && ItemListingStepFour.country.isEmpty && ItemListingStepFour.state.isEmpty && ItemListingStepFour.zipcode.isEmpty {
                
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
            ArrayItemsView[countView].view.frame = self.MainItemViewContainer_Outlet.frame
            self.MainItemViewContainer_Outlet.addSubview(ArrayItemsView[countView].view)
            Itemprogessbar.currentIndex = countView
            print("count == 1 \(countView)")
            
            // perform work here
            let country = ItemListingStepFour.country.uppercased()
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
                ItemListingStepThree.buyingView.DollarLabel.text = currency_TwoDigitCode + " " + user_Selected_Currency_Symbol
                ItemListingStepThree.buyingView.currencyBtn.setTitle("\(currency_TwoDigitCode + " " + user_Selected_Currency_Symbol)", for: .normal)
                
                ItemListingStepThree.buyingView.currency_Symbol = user_Selected_Currency_Symbol
                print("currency_Symbol == \(ItemListingStepThree.buyingView.currency_Symbol)")
                ItemListingStepThree.buyingView.currency_String = currency_TwoDigitCode
                print("currency_String == \(ItemListingStepThree.buyingView.currency_String)")
                
                ItemListingStepThree.AuctionView.currency_String = currency_TwoDigitCode
                ItemListingStepThree.AuctionView.currency_Symbol = user_Selected_Currency_Symbol
                
            }else{
                ItemListingStepThree.buyingView.DollarLabel.text = currency_ThreeDigitCode + " " + user_Selected_Currency_Symbol
                ItemListingStepThree.buyingView.currencyBtn.setTitle("\(currency_ThreeDigitCode + " " + user_Selected_Currency_Symbol)", for: .normal)
                
                ItemListingStepThree.buyingView.currency_Symbol = user_Selected_Currency_Symbol
                print("currency_Symbol == \(ItemListingStepThree.buyingView.currency_Symbol)")
                ItemListingStepThree.buyingView.currency_String = currency_ThreeDigitCode
                print("currency_String == \(ItemListingStepThree.buyingView.currency_String)")
                
                ItemListingStepThree.AuctionView.currency_String = currency_ThreeDigitCode
                ItemListingStepThree.AuctionView.currency_Symbol = user_Selected_Currency_Symbol
            }
            
        }
        else if countView == 3{
            
            
            if ItemListingStepThree.Change_View.selectedSegmentIndex == 0 && ItemListingStepThree.buyingView.listIndefinitelySwitch.isOn == false{
                
                if ((ItemListingStepThree.buyingView.pricetext.text?.isEmpty)!){
                    
                    print("Quantity TextField === 1")
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter Item Price " , style: .error,buttonTitle:
                        "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    countView = 3
                    return
                }
                    
                    
                else if (!ItemListingStepThree.buyingView.pricetext.text!.isEmpty) {
                    
                    let price : Int = Int(ItemListingStepThree.buyingView.pricetext.text!)!
                    if price <= 0 {
                        
                        _ = SweetAlert().showAlert("Invalid price", subTitle:"     Please enter valid price more than 0.    " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        countView = 3
                        return
                        
                    }
                        
                    else if ((ItemListingStepThree.buyingView.Qantitytxt.text?.isEmpty)!){
                        
                        print("Quantity TextField === 1")
                        _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter Item Quantity " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                        countView = 3
                        return
                    }
                        
                    else if (!ItemListingStepThree.buyingView.Qantitytxt.text!.isEmpty){
                        
                        
                        let Quantity : Int = Int(ItemListingStepThree.buyingView.Qantitytxt.text!)!
                        if Quantity <= 0 {
                            
                            _ = SweetAlert().showAlert("Invalid price", subTitle:"       Please enter valid Quantity more than 0.     " , style: .error,buttonTitle:
                                "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            countView = 3
                            return
                            
                        }
                        
                    }
                }
                if ((ItemListingStepThree.buyingView.listDurationTextField.text!.isEmpty))
                {
                    
                    print("Price TextField === 1")
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter listing days " , style: .error,buttonTitle:
                        "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    
                    countView = 3
                    return
                }
                
                
                
                
                
                if ItemListingStepThree.buyingView.auto_Relisting == true {
                    
                    autoRelisting = "true"
                }
                else{
                    
                    autoRelisting = "false"
                }
                
                if ItemListingStepThree.buyingView.accecptOffer == true {
                    
                    accecptOffer = "true"
                }
                else{
                    
                    accecptOffer = "false"
                    
                }
                
                if ItemListingStepThree.buyingView.list_Iden == true {
                    
                    listIdentifily = "true"
                }
                else{
                    
                    listIdentifily = "false"
                }
                
            }
            
            
            
            if ItemListingStepThree.Change_View.selectedSegmentIndex == 0 && ItemListingStepThree.buyingView.listIndefinitelySwitch.isOn == true {
                
                if ((ItemListingStepThree.buyingView.pricetext.text?.isEmpty)!){
                    
                    print("Quantity TextField === 1")
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter Item Price " , style: .error,buttonTitle:
                        "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    countView = 3
                    return
                }
                    
                    
                else if (!ItemListingStepThree.buyingView.pricetext.text!.isEmpty) {
                    
                    let price : Int = Int(ItemListingStepThree.buyingView.pricetext.text!)!
                    if price <= 0 {
                        
                        _ = SweetAlert().showAlert("Invalid price", subTitle:"     Please enter valid price more than 0.    " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        countView = 3
                        return
                        
                    }
                        
                    else if ((ItemListingStepThree.buyingView.Qantitytxt.text?.isEmpty)!){
                        
                        print("Quantity TextField === 1")
                        _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter Item Quantity " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                        countView = 3
                        return
                    }
                        
                    else if (!ItemListingStepThree.buyingView.Qantitytxt.text!.isEmpty){
                        
                        
                        let Quantity : Int = Int(ItemListingStepThree.buyingView.Qantitytxt.text!)!
                        if Quantity <= 0 {
                            
                            _ = SweetAlert().showAlert("Invalid price", subTitle:"       Please enter valid Quantity more than 0.     " , style: .error,buttonTitle:
                                "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            countView = 3
                            return
                            
                        }
                        
                    }
                }
                if ItemListingStepThree.buyingView.auto_Relisting == true {
                    
                    autoRelisting = "true"
                }
                else{
                    
                    autoRelisting = "false"
                }
                
                if ItemListingStepThree.buyingView.accecptOffer == true {
                    
                    accecptOffer = "true"
                }
                else{
                    
                    accecptOffer = "false"
                    
                }
                
                if ItemListingStepThree.buyingView.list_Iden == true {
                    
                    listIdentifily = "true"
                }
                else{
                    
                    listIdentifily = "false"
                }
            }else if ItemListingStepThree.Change_View.selectedSegmentIndex == 1 && ItemListingStepThree.AuctionView.addReservePriceSwitch.isOn == false {
                
                if ((ItemListingStepThree.AuctionView.startingPriceTextField.text?.isEmpty)!){
                    
                    print("Quantity TextField === 1")
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter Item Price " , style: .error,buttonTitle:
                        "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    countView = 3
                    return
                }
                    
                    
                else if (!ItemListingStepThree.AuctionView.startingPriceTextField.text!.isEmpty) {
                    
                    let startingPriceTextField : Int = Int(ItemListingStepThree.AuctionView.startingPriceTextField.text!)!
                    if startingPriceTextField <= 0 {
                        
                        _ = SweetAlert().showAlert("Invalid price", subTitle:"     Please enter valid price more than 0.    " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        countView = 3
                        return
                        
                    }
                    
                }
                
                
                if ((ItemListingStepThree.AuctionView.listDurationTextField.text!.isEmpty)){
                    
                    print("Price TextField === 1")
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter listing days " , style: .error,buttonTitle:
                        "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    
                    countView = 3
                    return
                }
                
                
                
                if ItemListingStepThree.buyingView.auto_Relisting == true {
                    
                    autoRelisting = "true"
                }
                else{
                    
                    autoRelisting = "false"
                }
                
                if ItemListingStepThree.buyingView.accecptOffer == true {
                    
                    accecptOffer = "true"
                }
                else{
                    
                    accecptOffer = "false"
                    
                }
                
                
                
            }else if ItemListingStepThree.Change_View.selectedSegmentIndex == 1 && ItemListingStepThree.AuctionView.addReservePriceSwitch.isOn == true {
                
                if ((ItemListingStepThree.AuctionView.startingPriceTextField.text?.isEmpty)!){
                    
                    print("Quantity TextField === 1")
                    _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter Item Price " , style: .error,buttonTitle:
                        "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                    countView = 3
                    return
                }
                    
                    
                else if (!ItemListingStepThree.AuctionView.startingPriceTextField.text!.isEmpty) {
                    
                    let startingPriceTextField : Int = Int(ItemListingStepThree.AuctionView.startingPriceTextField.text!)!
                    if startingPriceTextField <= 0 {
                        
                        _ = SweetAlert().showAlert("Invalid price", subTitle:"     Please enter valid price more than 0.    " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        countView = 3
                        return
                        
                    }
                    else if ((ItemListingStepThree.AuctionView.reservePriceTextField.text?.isEmpty)!){
                        
                        print("Quantity TextField === 1")
                        _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter reserve Price " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        countView = 3
                        return
                    }
                        
                    else if (!ItemListingStepThree.AuctionView.reservePriceTextField.text!.isEmpty) {
                        let reservePriceTextField : Int = Int(ItemListingStepThree.AuctionView.reservePriceTextField.text!)!
                        if reservePriceTextField <= 0 {
                            print("Reserve Price is Working")
                            _ = SweetAlert().showAlert("Invalid price", subTitle:"     Please enter valid price more than 0.    " , style: .error,buttonTitle:
                                "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            countView = 3
                            return
                            
                        }
                        else if (startingPriceTextField >= reservePriceTextField) {
                            print("Compare Price Field is Working")
                            _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Reserve Price must be greater then Starting Price   " , style: .error,buttonTitle:
                                "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                            countView = 3
                            
                            return
                            
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    if ((ItemListingStepThree.AuctionView.listDurationTextField.text!.isEmpty)){
                        
                        print("Price TextField === 1")
                        _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"   Please Enter listing days " , style: .error,buttonTitle:
                            "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        
                        countView = 3
                        return
                    }
                    
                    
                    
                    if ItemListingStepThree.AuctionView.Auction_auto_relistingbool == true {
                        
                        autoRelisting = "true"
                    }
                    else{
                        
                        autoRelisting = "false"
                    }
                    
                }
                
            }
            
            
            
            
            if ItemListingStepThree.Change_View.selectedSegmentIndex == 0 {
                selectOption = "Buying"
                itemAuctionType = "buy-it-now"
                print("selectedSegmentIndex-buying == \(ItemListingStepThree.Change_View.selectedSegmentIndex)")
            }
            if  ItemListingStepThree.Change_View.selectedSegmentIndex == 1 {
                selectOption = "Auction-NonReserve"
                itemAuctionType = "non-reserve"
                print("selectedSegmentIndex-Auction-NonReserve == \(ItemListingStepThree.Change_View.selectedSegmentIndex)")
            }
            if ItemListingStepThree.Change_View.selectedSegmentIndex == 1 && ItemListingStepThree.AuctionView.addReservePriceSwitch.isOn == true {
                selectOption = "Auction-Reserve"
                itemAuctionType = "reserve"
                print("selectedSegmentIndex-Auction-Reserve == \(ItemListingStepThree.Change_View.selectedSegmentIndex)")
            }
            if ItemListingStepThree.AuctionView.Auction_auto_relistingbool == true {
                
                Auction_auto_relistingString = "true"
            }
            else{
                
                Auction_auto_relistingString = "false"
            }
            
            
            if ItemListingStepThree.Change_View.selectedSegmentIndex == 0 && ItemListingStepThree.buyingView.listIndefinitelySwitch.isOn == false {
                
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                let Buying_Now_StartingPrice = ItemListingStepThree.buyingView.pricetext.text!.split(separator: "$")
                let Final_Buying_Now_StartingPrice : String = String(Buying_Now_StartingPrice[0])
                let GrandFinal_Buying_Now_StartingPrice : Int = Int(Final_Buying_Now_StartingPrice) ?? 0
                print("GrandFinal_Buying_Now_StartingPrice == \(GrandFinal_Buying_Now_StartingPrice)")
                
                let Housing_noOfBedrooms = HousingListingTwo.bedroomsTextField.text!
                let Final_Housing_noOfBedrooms : String = String(Housing_noOfBedrooms)
                let GrandFinal_Housing_noOfBedrooms : Int = Int(Final_Housing_noOfBedrooms) ?? 0
                print("GrandFinal_Housing_noOfBedrooms == \(GrandFinal_Housing_noOfBedrooms)")
                let squareFeet = Int(HousingListingTwo.squareFeetTextField.text!)
                let Housing_noOfBathrooms = HousingListingTwo.bathroomTextField.text!
                let Final_Housing_noOfBathrooms : String = String(Housing_noOfBathrooms)
                let GrandFinal_Housing_noOfBathrooms : Int = Int(Final_Housing_noOfBathrooms) ?? 0
                print("GrandFinal_Housing_noOfBathrooms == \(GrandFinal_Housing_noOfBathrooms)")
                let address = "\(ItemListingStepFour.city) \(ItemListingStepFour.state), \(ItemListingStepFour.country), \(ItemListingStepFour.zipcode)"
                
                mainApi.HousingListing_Api(lat: ItemListingStepFour.latitude, lng: ItemListingStepFour.longtitude, user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image, user_ID: SessionManager.shared.userId, country: ItemListingStepFour.country, city: ItemListingStepFour.city, title: HousingListingOne.ItemTitle!.text!, itemCategory: "Housing", condition: "", description: HousingListingTwo.descriptionTextView.text!, housingType: HousingListingTwo.realEstateTextField.text!, bedrooms: GrandFinal_Housing_noOfBedrooms, bathrooms: GrandFinal_Housing_noOfBathrooms, laundry: HousingListingTwo.laundryTextField.text!, parking: HousingListingTwo.parkingTextField.text!, address: address, squareFeet: squareFeet ?? 0, availableOn: HousingListingTwo.availableDateTextField.text!, openHouseDate: HousingListingTwo.openHouseDateTextField.text!, petsAccepted: true, noSmoking: true, wheelChairAccess: true, monthlyRent: 15000, roomType: "unknown", bathType: "Unknown", currency_string: "\(ItemListingStepThree.buyingView.currency_String)", currency_symbol: "\(ItemListingStepThree.buyingView.currency_Symbol)", quantity: "\(ItemListingStepThree.buyingView.Qantitytxt.text!)", payPeriod: "nil", autoReList: autoRelisting , acceptOffers: accecptOffer , zipCode: "\(ItemListingStepFour.zipcode)", UI_Image: HousingListingOne.imageList, endTime: "\(ItemListingStepThree.buyingView.selected_date)" , startPrice : "\(GrandFinal_Buying_Now_StartingPrice)" , itemAuctionType: itemAuctionType , visibility: true , reservePrice: "", SelectOption: selectOption, base_price: "") { (status, data, error) in
                    
                    
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
                
            }else if ItemListingStepThree.Change_View.selectedSegmentIndex == 0 && ItemListingStepThree.buyingView.listIndefinitelySwitch.isOn == true{
                
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                let Buying_Now_StartingPrice = ItemListingStepThree.buyingView.pricetext.text!.split(separator: "$")
                let Final_Buying_Now_StartingPrice : String = String(Buying_Now_StartingPrice[0])
                let GrandFinal_Buying_Now_StartingPrice : Int = Int(Final_Buying_Now_StartingPrice) ?? 0
                print("GrandFinal_Buying_Now_StartingPrice == \(GrandFinal_Buying_Now_StartingPrice)")
                
                let Housing_noOfBedrooms = HousingListingTwo.bedroomsTextField.text!
                let Final_Housing_noOfBedrooms : String = String(Housing_noOfBedrooms)
                let GrandFinal_Housing_noOfBedrooms : Int = Int(Final_Housing_noOfBedrooms) ?? 0
                print("GrandFinal_Housing_noOfBedrooms == \(GrandFinal_Housing_noOfBedrooms)")
                let squareFeet = Int(HousingListingTwo.squareFeetTextField.text!)
                let Housing_noOfBathrooms = HousingListingTwo.bathroomTextField.text!
                let Final_Housing_noOfBathrooms : String = String(Housing_noOfBathrooms)
                let GrandFinal_Housing_noOfBathrooms : Int = Int(Final_Housing_noOfBathrooms) ?? 0
                print("GrandFinal_Housing_noOfBathrooms == \(GrandFinal_Housing_noOfBathrooms)")
                let address = "\(ItemListingStepFour.city) \(ItemListingStepFour.state), \(ItemListingStepFour.country), \(ItemListingStepFour.zipcode)"
                
                mainApi.HousingListing_Api(lat: ItemListingStepFour.latitude, lng: ItemListingStepFour.longtitude, user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image, user_ID: SessionManager.shared.userId, country: ItemListingStepFour.country, city: ItemListingStepFour.city, title: HousingListingOne.ItemTitle!.text!, itemCategory: "Housing", condition: "", description: HousingListingTwo.descriptionTextView.text!, housingType: HousingListingTwo.realEstateTextField.text!, bedrooms: GrandFinal_Housing_noOfBedrooms, bathrooms: GrandFinal_Housing_noOfBathrooms, laundry: HousingListingTwo.laundryTextField.text!, parking: HousingListingTwo.parkingTextField.text!, address: address, squareFeet: squareFeet ?? 0, availableOn: HousingListingTwo.availableDateTextField.text!, openHouseDate: HousingListingTwo.openHouseDateTextField.text!, petsAccepted: true, noSmoking: true, wheelChairAccess: true, monthlyRent: 15000, roomType: "unknown", bathType: "Unknown", currency_string: "\(ItemListingStepThree.buyingView.currency_String)", currency_symbol: "\(ItemListingStepThree.buyingView.currency_Symbol)", quantity: "\(ItemListingStepThree.buyingView.Qantitytxt.text!)", payPeriod: "nil", autoReList: autoRelisting , acceptOffers: accecptOffer , zipCode: "\(ItemListingStepFour.zipcode)", UI_Image: HousingListingOne.imageList, endTime: "\(ItemListingStepThree.buyingView.selected_date)" , startPrice : "\(GrandFinal_Buying_Now_StartingPrice)" , itemAuctionType: itemAuctionType , visibility: true , reservePrice: "", SelectOption: selectOption, base_price: "") { (status, data, error) in
                    
                    
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
                
            }else if ItemListingStepThree.Change_View.selectedSegmentIndex == 1 && ItemListingStepThree.AuctionView.addReservePriceSwitch.isOn == true {
                
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                let Buying_Now_StartingPrice = ItemListingStepThree.buyingView.pricetext.text!.split(separator: "$")
                let Final_Buying_Now_StartingPrice : String = String(Buying_Now_StartingPrice[0])
                let GrandFinal_Buying_Now_StartingPrice : Int = Int(Final_Buying_Now_StartingPrice) ?? 0
                print("GrandFinal_Buying_Now_StartingPrice == \(GrandFinal_Buying_Now_StartingPrice)")
                
                let Housing_noOfBedrooms = HousingListingTwo.bedroomsTextField.text!
                let Final_Housing_noOfBedrooms : String = String(Housing_noOfBedrooms)
                let GrandFinal_Housing_noOfBedrooms : Int = Int(Final_Housing_noOfBedrooms) ?? 0
                print("GrandFinal_Housing_noOfBedrooms == \(GrandFinal_Housing_noOfBedrooms)")
                let squareFeet = Int(HousingListingTwo.squareFeetTextField.text!)
                let Housing_noOfBathrooms = HousingListingTwo.bathroomTextField.text!
                let Final_Housing_noOfBathrooms : String = String(Housing_noOfBathrooms)
                let GrandFinal_Housing_noOfBathrooms : Int = Int(Final_Housing_noOfBathrooms) ?? 0
                print("GrandFinal_Housing_noOfBathrooms == \(GrandFinal_Housing_noOfBathrooms)")
                let address = "\(ItemListingStepFour.city) \(ItemListingStepFour.state), \(ItemListingStepFour.country), \(ItemListingStepFour.zipcode)"
                
                mainApi.HousingListing_Api(lat: ItemListingStepFour.latitude, lng: ItemListingStepFour.longtitude, user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image, user_ID: SessionManager.shared.userId, country: ItemListingStepFour.country, city: ItemListingStepFour.city, title: HousingListingOne.ItemTitle!.text!, itemCategory: "Housing", condition: "", description: HousingListingTwo.descriptionTextView.text!, housingType: HousingListingTwo.realEstateTextField.text!, bedrooms: GrandFinal_Housing_noOfBedrooms, bathrooms: GrandFinal_Housing_noOfBathrooms, laundry: HousingListingTwo.laundryTextField.text!, parking: HousingListingTwo.parkingTextField.text!, address: address, squareFeet: squareFeet ?? 0, availableOn: HousingListingTwo.availableDateTextField.text!, openHouseDate: HousingListingTwo.openHouseDateTextField.text!, petsAccepted: true, noSmoking: true, wheelChairAccess: true, monthlyRent: 15000, roomType: "unknown", bathType: "Unknown", currency_string: "\(ItemListingStepThree.buyingView.currency_String)", currency_symbol: "\(ItemListingStepThree.buyingView.currency_Symbol)", quantity: "\(ItemListingStepThree.buyingView.Qantitytxt.text!)", payPeriod: "nil", autoReList: autoRelisting , acceptOffers: accecptOffer , zipCode: "\(ItemListingStepFour.zipcode)", UI_Image: HousingListingOne.imageList, endTime: "\(ItemListingStepThree.buyingView.selected_date)" , startPrice : "\(GrandFinal_Buying_Now_StartingPrice)" , itemAuctionType: itemAuctionType , visibility: true , reservePrice: "", SelectOption: selectOption, base_price: "") { (status, data, error) in
                    
                    
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
            } else if ItemListingStepThree.Change_View.selectedSegmentIndex == 1 && ItemListingStepThree.AuctionView.addReservePriceSwitch.isOn == false {
                
                 self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                let Buying_Now_StartingPrice = ItemListingStepThree.buyingView.pricetext.text!.split(separator: "$")
                let Final_Buying_Now_StartingPrice : String = String(Buying_Now_StartingPrice[0])
                let GrandFinal_Buying_Now_StartingPrice : Int = Int(Final_Buying_Now_StartingPrice) ?? 0
                print("GrandFinal_Buying_Now_StartingPrice == \(GrandFinal_Buying_Now_StartingPrice)")
                
                let Housing_noOfBedrooms = HousingListingTwo.bedroomsTextField.text!
                let Final_Housing_noOfBedrooms : String = String(Housing_noOfBedrooms)
                let GrandFinal_Housing_noOfBedrooms : Int = Int(Final_Housing_noOfBedrooms) ?? 0
                print("GrandFinal_Housing_noOfBedrooms == \(GrandFinal_Housing_noOfBedrooms)")
                let squareFeet = Int(HousingListingTwo.squareFeetTextField.text!)
                let Housing_noOfBathrooms = HousingListingTwo.bathroomTextField.text!
                let Final_Housing_noOfBathrooms : String = String(Housing_noOfBathrooms)
                let GrandFinal_Housing_noOfBathrooms : Int = Int(Final_Housing_noOfBathrooms) ?? 0
                print("GrandFinal_Housing_noOfBathrooms == \(GrandFinal_Housing_noOfBathrooms)")
                let address = "\(ItemListingStepFour.city) \(ItemListingStepFour.state), \(ItemListingStepFour.country), \(ItemListingStepFour.zipcode)"
                
                mainApi.HousingListing_Api(lat: ItemListingStepFour.latitude, lng: ItemListingStepFour.longtitude, user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image, user_ID: SessionManager.shared.userId, country: ItemListingStepFour.country, city: ItemListingStepFour.city, title: HousingListingOne.ItemTitle!.text!, itemCategory: "Housing", condition: "", description: HousingListingTwo.descriptionTextView.text!, housingType: HousingListingTwo.realEstateTextField.text!, bedrooms: GrandFinal_Housing_noOfBedrooms, bathrooms: GrandFinal_Housing_noOfBathrooms, laundry: HousingListingTwo.laundryTextField.text!, parking: HousingListingTwo.parkingTextField.text!, address: address, squareFeet: squareFeet ?? 0, availableOn: HousingListingTwo.availableDateTextField.text!, openHouseDate: HousingListingTwo.openHouseDateTextField.text!, petsAccepted: true, noSmoking: true, wheelChairAccess: true, monthlyRent: 15000, roomType: "unknown", bathType: "Unknown", currency_string: "\(ItemListingStepThree.buyingView.currency_String)", currency_symbol: "\(ItemListingStepThree.buyingView.currency_Symbol)", quantity: "\(ItemListingStepThree.buyingView.Qantitytxt.text!)", payPeriod: "nil", autoReList: autoRelisting , acceptOffers: accecptOffer , zipCode: "\(ItemListingStepFour.zipcode)", UI_Image: HousingListingOne.imageList, endTime: "\(ItemListingStepThree.buyingView.selected_date)" , startPrice : "\(GrandFinal_Buying_Now_StartingPrice)" , itemAuctionType: itemAuctionType , visibility: true , reservePrice: "", SelectOption: selectOption, base_price: "") { (status, data, error) in
                    
                    
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
            ArrayItemsView[countView].view.frame = self.MainItemViewContainer_Outlet.frame
            self.MainItemViewContainer_Outlet.addSubview(ArrayItemsView[countView].view)
            Itemprogessbar.currentIndex = countView
        }
        
    }
}
