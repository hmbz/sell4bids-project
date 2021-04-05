//
//  ItemFlexiableBarVC.swift
//  Sell4Bids
//
//  Created by admin on 07/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar


var ListingStoryBoard_Bundle = UIStoryboard.init(name: "Main_Listing_Sell", bundle: nil)

class ItemFlexiableBarVC: UIViewController, FlexibleSteppedProgressBarDelegate,UITableViewDelegate  {
    
    //MARK:- Properties and Outlets
    @IBOutlet weak var FlexableBarView: ShadowView!
    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var Errorimg: UIImageView!
    @IBOutlet weak var NextBtn: ButtonShahdow!
    @IBOutlet weak var BackBtn: ButtonShahdow!
    @IBOutlet weak var MainItemViewContainer_Outlet: UIView!
    @IBOutlet weak var Itemprogessbar: FlexibleSteppedProgressBar!
    
    
    //MARK:- Variable and Constent
    var SelectedViewIndex = 0
    var ArrayItemsView = [UIViewController]()
    var searchController: UISearchController?
    var resultView: UITextView?
    var countView = Int()
    var currency_String = String()
    var currency_Symbol = String()
    var reserve_nonreserve : Bool = false
    var reseveornot = String()
    var selectOption = String()
    var mainApi = MainSell4BidsApi()
    var latitude = Double()
    var longtitude = Double()
    var listIdentifily = String()
    var accecptOffer = String()
    var autoRelisting = String()
    var reserveprice:Bool = false
    var Auction_auto_relistingString = String()
    let DoneAlertView = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
    let DoneView = Bundle.main.loadNibNamed("Item_Listing_Done_Custom_View", owner: self, options: nil)?.first as! ItemListingDoneCustom
    var itemAuctionType = String()
    var ItemListingStepone = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "ItemListing-Step-One") as! ItemListingOneVC
    var ItemListingStepTwo = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "ItemListing-Step-Two") as! ItemListingTwoVC
    var ItemListingStepThree = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "ItemBuyandAction") as! ItemListingStepThree
    var ItemListingStepFour = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "ItemListing-Step-Four") as! ItemListingFour
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    var sessionDic:[String:Any] = UserDefaults.standard.dictionary(forKey: SessionManager.shared.itemListingSession) ?? [:]
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if sessionDic["title"] != nil {
           ItemListingStepone.ItemTitle.text = "\(sessionDic["title"] ?? "")"
        }
        if sessionDic["ItemImages"] != nil {
            ItemListingStepone.imageList = sessionDic["ItemImages"] as! [UIImage]
            DispatchQueue.main.async {
                if self.ItemListingStepone.imageList.count > 0 {
                    self.ItemListingStepone.MainImage.isHidden = false
                    self.ItemListingStepone.TakePhotoHeightConstrant.constant = 0
                    self.ItemListingStepone.TakePhotoView.isHidden = true
                    self.ItemListingStepone.ImageCustomViewHeight.constant = 200
                    self.ItemListingStepone.TopConstraintValue.constant = 45
                    self.ItemListingStepone.Scrollview.layoutIfNeeded()
                    self.ItemListingStepone.CollectionViewHeight.constant = 80
                    self.ItemListingStepone.CloseBtn.constant = 30
                }
            }
        }
        
        DoneView.succesfullayMessage.text = listingFinalMessage.instance.item
        
        topMenu()
        self.title = "List Item"
        topMenu()
        BackBtn.isHidden = true
        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
        
        ArrayItemsView.append(ItemListingStepone)
        ArrayItemsView.append(ItemListingStepTwo)
        ArrayItemsView.append(ItemListingStepFour)
        ArrayItemsView.append(ItemListingStepThree)
        
        BackBtn.makeRedAndRound()
        NextBtn.makeRedAndRound()
        ArrayItemsView[0].view.frame = self.MainItemViewContainer_Outlet.frame
        self.MainItemViewContainer_Outlet.addSubview(ArrayItemsView[0].view)
        
        Itemprogessbar.delegate = self
        
        Itemprogessbar.currentSelectedTextColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1) /*UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)*/
        Itemprogessbar.currentSelectedCenterColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1) /*UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)*/
        Itemprogessbar.selectedOuterCircleStrokeColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1) /*UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)*/
        DoneView.DoneBtn.addTarget(self, action: #selector(Done_btn_Action), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NextBtn.endEditing(true)
        BackBtn.endEditing(true)
        MainItemViewContainer_Outlet.endEditing(true)
        Itemprogessbar.endEditing(true)
        self.view.gestureRecognizers?.forEach(self.view.removeGestureRecognizer(_:))
        
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.ArrayItemsView[self.countView].view.frame = self.MainItemViewContainer_Outlet.frame
            self.FlexableBarView.frame = self.FlexableBarView.frame
        }
    }
    
    //MARK:- Actions
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "List your Item"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        
        self.navigationItem.hidesBackButton = true
    }
    
    
    //MARK:- Actions
    
    @IBAction func dismisskeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped Count view \(countView)")
        self.navigationController?.popViewController(animated: true)
    }
    
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
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
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    
    
    // top bar function
    
    
    
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
    
    // @PopUps/Validations change by SyedSaadAhmed(18-June)
    // @OM 25-02-2019 (For Progress bar Implementation)
    @IBAction func NextBtnOpt(_ sender: Any) {
        
        
        if countView == 0{
           
            
            print("count..0 = /\(countView)")
            
            if ItemListingStepone.imageList.count <= 0 {
                
                _ = SweetAlert().showAlert("Photos", subTitle: "photoalert".localizableString(loc: LanguageChangeCode) , style: .error,buttonTitle:
                  "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                return
                
            }
            else if(ItemListingStepone.imageList.count > 15)
            {
                let kTitle = "Photos"
              _ = SweetAlert().showAlert( String(kTitle.suffix(30)) , subTitle: "strMaximumPhotoAllowed".localizableString(loc: LanguageChangeCode)  , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                return
            }
                
            else if ((ItemListingStepone.ItemTitle.text?.isEmpty)!) {
                
                print("TitleError TextFieldWorking === 1")
                
              _ = SweetAlert().showAlert("Item Title", subTitle: "relatedCatagory".localizableString(loc: LanguageChangeCode) , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
              
                return
            }
                
            else if (ItemListingStepone.ItemTitle.text?.count)! < 3
            {
                print("check count \(ItemListingStepone.ItemTitle.text?.count ?? 0)")
                
              _ = SweetAlert().showAlert("Item Title", subTitle: "strEmptyTitleTextField".localizableString(loc: LanguageChangeCode), style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                return
                
            }
            else if(ItemListingStepone.ItemTitle.text?.count)! >= 70
            {
              _ = SweetAlert().showAlert("Item Title", subTitle:  "exceedStrng".localizableString(loc: LanguageChangeCode)  , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 0
                print("TitleError TextFieldWorking === 2")
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
            Itemprogessbar.currentIndex = countView
            
//            let Buyingparameters = [ "lat": lat , "lng" : lng , "token" : user_Token , "name" : user_Name , "image" : user_Image , "uid" : user_ID , "country_code" : country , "city" : city , "title" : title , "itemCategory" : itemCategory , "condition" : condition , "description" : description , "currency_string" : currency_string , "currency_symbol" : currency_symbol , "quantity" : quantity , "autoReList" : autoReList , "acceptOffers" : acceptOffers , "zipCode" : zipCode , "endTime" : endTime , "itemAuctionType" : itemAuctionType , "visibility" : visibility, "startPrice" : startPrice ,"state":State, "platform" : "iOS"]
            
            sessionDic = [
                "ItemImages" : ItemListingStepone.imageList,
                "title": ItemListingStepone.ItemTitle.text!
            ]
            
            
        }
            
        else if countView == 1{
            
           
            print("count... 1 = \(countView)")
            
            if (ItemListingStepTwo.SelectCategoryName.titleLabel?.text == "Select a Category" ) || (ItemListingStepTwo.SelectCategoryName.titleLabel?.text == "" )
            {
                
                ItemListingStepTwo.SelectCategoryName.shake()
                
              _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:  "relatedCatagory".localizableString(loc: LanguageChangeCode) , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 1
                
                print("TakeSelectCategory TextFieldWorking === 1")
                return
                
            }
            else if (ItemListingStepTwo.ConditionValueTextField.text == "" )
                || (ItemListingStepTwo.ConditionValueTextField.text == "Select Condition")
            {
                
                ItemListingStepTwo.ConditionValueTextField.shake()
                
                _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"Please select related condition. " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 1
                
                print("TakeSelectCategory TextFieldWorking === 1")
                return
                
            }
                
            else if ((ItemListingStepTwo.Descriptiontext.text?.isEmpty)!)
            {
                
                print("DescriptionError in TextField === 1")
                
                _ = SweetAlert().showAlert("Description", subTitle:"  Please Enter Item Description " , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 1
                return
            }
            else if (ItemListingStepTwo.Descriptiontext.text?.count)! < 20
            {
                print("DescriptionTextFieldWorking ===")
                _ = SweetAlert().showAlert("Description", subTitle:"descStrng".localizableString(loc: LanguageChangeCode) , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                
                countView = 1
                return
            }
            else if ( (ItemListingStepTwo.Descriptiontext.text?.count)! > 1200) {
                _ = SweetAlert().showAlert("Description", subTitle:"limitStrng".localizableString(loc: LanguageChangeCode) , style: .error,buttonTitle:
                    "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                countView = 1
                return
            }
                
            else
            {
                
                
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
            
            sessionDic = [
                           "itemCategory":ItemListingStepTwo.SelectCategoryName.titleLabel?.text! ?? "",
                           "condition":ItemListingStepTwo.ConditionValueTextField.text!,
                           "description":ItemListingStepTwo.Descriptiontext.text!
                       ]
            
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
                // For Buying View:
                ItemListingStepThree.buyingView.pricetext.placeholder = currency_TwoDigitCode + " " + user_Selected_Currency_Symbol
                ItemListingStepThree.buyingView.currencyBtn.setTitle("\(currency_TwoDigitCode + " " + user_Selected_Currency_Symbol)", for: .normal)
                
                ItemListingStepThree.buyingView.currency_Symbol = user_Selected_Currency_Symbol
                print("currency_Symbol == \(ItemListingStepThree.buyingView.currency_Symbol)")
                ItemListingStepThree.buyingView.currency_String = currency_TwoDigitCode
                print("currency_String == \(ItemListingStepThree.buyingView.currency_String)")
                
                ItemListingStepThree.AuctionView.currency_String = currency_TwoDigitCode
                ItemListingStepThree.AuctionView.currency_Symbol = user_Selected_Currency_Symbol
                
            }else{
                // For Buying View:
                ItemListingStepThree.buyingView.pricetext.placeholder = currency_ThreeDigitCode + " " + user_Selected_Currency_Symbol
                ItemListingStepThree.buyingView.currencyBtn.setTitle("\(currency_ThreeDigitCode + " " + user_Selected_Currency_Symbol)", for: .normal)
                
                ItemListingStepThree.buyingView.currency_Symbol = user_Selected_Currency_Symbol
                print("currency_Symbol_BuyingView == \(ItemListingStepThree.buyingView.currency_Symbol)")
                ItemListingStepThree.buyingView.currency_String = currency_ThreeDigitCode
                print("currency_String_BuyingView == \(ItemListingStepThree.buyingView.currency_String)")
                
                ItemListingStepThree.AuctionView.currency_String = currency_ThreeDigitCode
                print("currency_String_AuctionView == \(ItemListingStepThree.AuctionView.currency_String)")
                ItemListingStepThree.AuctionView.currency_Symbol = user_Selected_Currency_Symbol
                print("currency_Symbol_AuctionView == \(ItemListingStepThree.AuctionView.currency_Symbol)")
                
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
                        _ = SweetAlert().showAlert("ERROR".localizableString(loc: LanguageChangeCode), subTitle:"Please Enter Item Quantity " , style: .error,buttonTitle:
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
            }
                
                
            else if ItemListingStepThree.Change_View.selectedSegmentIndex == 1 && ItemListingStepThree.AuctionView.addReservePriceSwitch.isOn == false {
                
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
                
                
                
            }
            
            if ItemListingStepThree.Change_View.selectedSegmentIndex == 1 && ItemListingStepThree.AuctionView.addReservePriceSwitch.isOn == true {
                
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
            
            
            print("Token == \(SessionManager.shared.fcmToken)")
            print("Name == \(SessionManager.shared.name)")
            print("User_ID == \(SessionManager.shared.userId)")
            print("ItemTitle == \(ItemListingStepone.ItemTitle!.text!)")
            print("SelectCategoryName == \(ItemListingStepTwo.SelectCategoryName.titleLabel!.text!)")
            print("ConditionValue == \(ItemListingStepTwo.ConditionValueTextField.text!)")
            print("DescriptionText == \(ItemListingStepTwo.Descriptiontext.text!)")
            print("ConditionValue == \(ItemListingStepTwo.ConditionValueTextField.text!)")
            print("Currency String == \(ItemListingStepThree.buyingView.currency_String)")
            print("Currency Symbol == \(ItemListingStepThree.buyingView.currency_Symbol)")
            print("Auto Relisting == \(autoRelisting)")
            print("AcceptOffer ==\(accecptOffer)")
            print("Zipcode ==\(zipCode)")
            print("QuantityText == \(ItemListingStepThree.buyingView.Qantitytxt.text!)")
            print("Image == \(ItemListingStepone.imageList)")
            print("List Duration == \(ItemListingStepThree.buyingView.selected_date)")
            print("Item Price == \(ItemListingStepThree.buyingView.pricetext.text!)")
            print("ItemAuctionType == \(itemAuctionType)")
            print("\(ItemListingStepThree.buyingView.selected_date)")
            print("Select Option == \(selectOption)")
            
            
            
            
            
            if ItemListingStepThree.Change_View.selectedSegmentIndex == 0 && ItemListingStepThree.buyingView.listIndefinitelySwitch.isOn == false {
                
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                let Buying_Now_StartingPrice = ItemListingStepThree.buyingView.pricetext.text!.split(separator: "$")
                let Final_Buying_Now_StartingPrice : String = String(Buying_Now_StartingPrice[0])
                let GrandFinal_Buying_Now_StartingPrice : Int = Int(Final_Buying_Now_StartingPrice)!
                print("GrandFinal_Buying_Now_StartingPrice == \(GrandFinal_Buying_Now_StartingPrice)")
                
                let selectedImageData: NSData = NSData(data:UIImageJPEGRepresentation((ItemListingStepone.imageList.last!), 1)!)
                let selectedImageSize:Int = selectedImageData.length
                print("Image Size: %f KB", selectedImageSize / 1024)
                
                mainApi.ItemListing_Api(lat:ItemListingStepFour.latitude , lng: ItemListingStepFour.longtitude, user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image, user_ID: SessionManager.shared.userId, country: ItemListingStepFour.country, city: ItemListingStepFour.city, title: "\(ItemListingStepone.ItemTitle!.text!)", itemCategory: "\(ItemListingStepTwo.SelectCategoryName.titleLabel!.text!)", condition: "\(ItemListingStepTwo.ConditionValueTextField.text!)" , description: "\(ItemListingStepTwo.Descriptiontext.text!)", currency_string: "\(ItemListingStepThree.buyingView.currency_String)", currency_symbol: "\(ItemListingStepThree.buyingView.currency_Symbol)", quantity: "\(ItemListingStepThree.buyingView.Qantitytxt.text!)", payPeriod: "nil", autoReList: autoRelisting , acceptOffers: accecptOffer , zipCode: "\(ItemListingStepFour.zipcode)", UI_Image: ItemListingStepone.imageList, endTime: "\(ItemListingStepThree.buyingView.selected_date)" , startPrice : "\(GrandFinal_Buying_Now_StartingPrice)" , itemAuctionType: itemAuctionType , visibility: true , reservePrice: "", SelectOption: selectOption, base_price: "", State: ItemListingStepFour.state) { (status, data, error) in
                    if status {
                        
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        self.DoneAlertView.view.frame = self.DoneView.frame
                        self.DoneAlertView.view.addSubview(self.DoneView)
                        self.present(self.DoneAlertView, animated: true, completion: nil)
                        self.DoneView.DoneBtn.makeCornersRound()
                        print("status == \(status)")
                        print("data == \(String(describing: data))")
                        print("error == \(error)")
                    }
                    else{
                        if error.contains("The network connection was lost"){
                          let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode).localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
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
            
            
            if ItemListingStepThree.Change_View.selectedSegmentIndex == 0 && ItemListingStepThree.buyingView.listIndefinitelySwitch.isOn == true{
                
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                let Buying_Now_StartingPrice = ItemListingStepThree.buyingView.pricetext.text!.split(separator: "$")
                let Final_Buying_Now_StartingPrice : String = String(Buying_Now_StartingPrice[0])
                let GrandFinal_Buying_Now_StartingPrice : Int = Int(Final_Buying_Now_StartingPrice)!
                print("GrandFinal_Buying_Now_StartingPrice == \(GrandFinal_Buying_Now_StartingPrice)")
                
                
                
                mainApi.ItemListing_Api(lat:ItemListingStepFour.latitude , lng: ItemListingStepFour.longtitude, user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image, user_ID: SessionManager.shared.userId, country: ItemListingStepFour.country, city: ItemListingStepFour.city, title: "\(ItemListingStepone.ItemTitle!.text!)", itemCategory: "\(ItemListingStepTwo.SelectCategoryName.titleLabel!.text!)", condition: "\(ItemListingStepTwo.ConditionValueTextField.text!)" , description: "\(ItemListingStepTwo.Descriptiontext.text!)", currency_string: "\(ItemListingStepThree.buyingView.currency_String)", currency_symbol: "\(ItemListingStepThree.buyingView.currency_Symbol)", quantity: "\(ItemListingStepThree.buyingView.Qantitytxt.text!)", payPeriod: "nil", autoReList: autoRelisting , acceptOffers: accecptOffer , zipCode: "\(ItemListingStepFour.zipcode)", UI_Image: ItemListingStepone.imageList, endTime: "-1" , startPrice : "\(GrandFinal_Buying_Now_StartingPrice)" , itemAuctionType: itemAuctionType , visibility: true , reservePrice: "", SelectOption: selectOption, base_price: "", State: ItemListingStepFour.state) { (status, data, error) in
                    
                    
                    
                    if status {
                        
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        
                        self.DoneAlertView.view.frame = self.DoneView.frame
                        self.DoneAlertView.view.addSubview(self.DoneView)
                        self.present(self.DoneAlertView, animated: true, completion: nil)
                        self.DoneView.DoneBtn.makeCornersRound()
                        
                        
                        
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
            
            
            
            if ItemListingStepThree.Change_View.selectedSegmentIndex == 1 && ItemListingStepThree.AuctionView.addReservePriceSwitch.isOn == true {
                
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                let Auction_Now_StartingPrice = ItemListingStepThree.AuctionView.startingPriceTextField.text!.split(separator: "$")
                let Final_Auction_Now_StartingPrice : String = String(Auction_Now_StartingPrice[0])
                let GrandFinal_Auction_Now_StartingPrice : Int = Int(Final_Auction_Now_StartingPrice)!
                print("Auction_Now_Starting_Price == \(GrandFinal_Auction_Now_StartingPrice)")
                
                let Auction_Now_ReservicePrice = ItemListingStepThree.AuctionView.reservePriceTextField.text!.split(separator: "$")
                let Final_Auction_Now_ReservicePrice : String = String(Auction_Now_ReservicePrice[0])
                let GrandFinal_Auction_Now_ReservicePrice : Int = Int(Final_Auction_Now_ReservicePrice)!
                print("Auction_Now_Reserive Price == \(GrandFinal_Auction_Now_ReservicePrice)")
                
                mainApi.ItemListing_Api(lat: ItemListingStepFour.latitude , lng: ItemListingStepFour.longtitude, user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image, user_ID: SessionManager.shared.userId, country: ItemListingStepFour.country, city: ItemListingStepFour.city, title: "\(ItemListingStepone.ItemTitle.text!)", itemCategory: "\(ItemListingStepTwo.SelectCategoryName.titleLabel!.text!)", condition: "\(ItemListingStepTwo.ConditionValueTextField.text!)" , description: "\(ItemListingStepTwo.Descriptiontext.text!)", currency_string: "\(ItemListingStepThree.buyingView.currency_String)", currency_symbol: "\(ItemListingStepThree.buyingView.currency_Symbol)", quantity: "\(ItemListingStepThree.buyingView.Qantitytxt.text!)", payPeriod: "nil", autoReList: Auction_auto_relistingString , acceptOffers: accecptOffer , zipCode: "\(ItemListingStepFour.zipcode)", UI_Image: ItemListingStepone.imageList, endTime: "\(ItemListingStepThree.AuctionView.selected_date)" , startPrice : "\(GrandFinal_Auction_Now_StartingPrice)" , itemAuctionType: itemAuctionType , visibility: true , reservePrice: "\(GrandFinal_Auction_Now_ReservicePrice)", SelectOption: selectOption, base_price: "\(GrandFinal_Auction_Now_StartingPrice)", State: ItemListingStepFour.state) { (status, data, error) in
                    
                    
                    
                    if status {
                        
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        
                        self.DoneAlertView.view.frame = self.DoneView.frame
                        self.DoneAlertView.view.addSubview(self.DoneView)
                        self.present(self.DoneAlertView, animated: true, completion: nil)
                        self.DoneView.DoneBtn.makeCornersRound()
                        
                        
                        
                        print("status == \(status)")
                        print("data == \(String(describing: data))")
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
            
            if ItemListingStepThree.Change_View.selectedSegmentIndex == 1 && ItemListingStepThree.AuctionView.addReservePriceSwitch.isOn == false {
                
                self.fidgetImageView.toggleRotateAndDisplayGif()
                Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                let Auction_Now_StartingPrice = ItemListingStepThree.AuctionView.startingPriceTextField.text!.split(separator: "$")
                let Final_Auction_Now_StartingPrice : String = String(Auction_Now_StartingPrice[0])
                let GrandFinal_Auction_Now_StartingPrice : Int = Int(Final_Auction_Now_StartingPrice)!
                print("Auction_Now_Starting_Price == \(GrandFinal_Auction_Now_StartingPrice)")
                
                
                
                mainApi.ItemListing_Api(lat: ItemListingStepFour.latitude , lng: ItemListingStepFour.longtitude, user_Token: SessionManager.shared.fcmToken, user_Name: SessionManager.shared.name, user_Image: SessionManager.shared.image, user_ID: SessionManager.shared.userId, country: ItemListingStepFour.country , city: ItemListingStepFour.city , title: "\(ItemListingStepone.ItemTitle.text!)", itemCategory: "\(ItemListingStepTwo.SelectCategoryName.titleLabel!.text!)", condition: "\(ItemListingStepTwo.ConditionValueTextField.text!)" , description: "\(ItemListingStepTwo.Descriptiontext.text!)", currency_string: "\(ItemListingStepThree.buyingView.currency_String)", currency_symbol: "\(ItemListingStepThree.buyingView.currency_Symbol)", quantity: "\(ItemListingStepThree.buyingView.Qantitytxt.text!)", payPeriod: "nil", autoReList: Auction_auto_relistingString , acceptOffers: accecptOffer , zipCode: "\(ItemListingStepFour.zipcode)", UI_Image: ItemListingStepone.imageList, endTime: "\(ItemListingStepThree.AuctionView.selected_date)" , startPrice : "\(GrandFinal_Auction_Now_StartingPrice)" , itemAuctionType: itemAuctionType , visibility: true , reservePrice: "", SelectOption: selectOption, base_price: "\(GrandFinal_Auction_Now_StartingPrice)", State: "") { (status, data, error) in
                    
                    if status {
                        
                        Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                        self.DoneAlertView.view.frame = self.DoneView.frame
                        self.DoneAlertView.view.addSubview(self.DoneView)
                        self.present(self.DoneAlertView, animated: true, completion: nil)
                        self.DoneView.DoneBtn.makeCornersRound()
                        
                        
                        
                        print("status == \(status)")
                        print("data == \(String(describing: data))")
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
                            
                            _ = SweetAlert().showAlert("Network Error".localizableString(loc: LanguageChangeCode), subTitle:    "Opps Network Error".localizableString(loc: LanguageChangeCode)   , style: .error,buttonTitle:
                                "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
                        }
                        
                        if error.contains("A server with the specified hostname could not be found."){
                            _ = SweetAlert().showAlert("Network Error".localizableString(loc: LanguageChangeCode), subTitle:   "Opps Network Error".localizableString(loc: LanguageChangeCode)   , style: .error,buttonTitle:
                                "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                        }
                        
                        if error.contains("The request timed out.") {
                            _ = SweetAlert().showAlert("Network Error".localizableString(loc: LanguageChangeCode), subTitle:    "Opps Network Error".localizableString(loc: LanguageChangeCode)  , style: .error,buttonTitle:
                                "Ok".localizableString(loc: LanguageChangeCode), buttonColor:UIColor.colorFromRGB(0x000000))
                            
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
