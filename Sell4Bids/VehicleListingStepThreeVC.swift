//
//  VehicleListingStepThreeVC.swift
//  Sell4Bids
//
//  Created by admin on 12/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class VehicleListingStepThreeVC: UIViewController {
    
    //MARK:- Outlets and properties
    @IBOutlet weak var vinNumberTextField: UITextField!
    @IBOutlet weak var scanVinBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var skipVinBtn: UIButton!
    @IBOutlet weak var vinView: UIView!
    @IBOutlet weak var vinViewHeight: NSLayoutConstraint!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var makeLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var trimLbl: UILabel!
    @IBOutlet weak var fuelTypeLbl: UILabel!
    @IBOutlet weak var milesDrivenLbl: UILabel!
    @IBOutlet weak var colorLbl: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK:- Variable and constent
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    lazy var imageArray = [UIImage]()
    lazy var country = ""
    lazy var paramDic = [String:Any]()
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
        setupView()
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    //MARK:- Actions
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
    }
    
    @objc func barCodeScanBtnTapped(sender: UIButton){
        let vc = ScannerViewController()
        vc.selectionDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clearBtnTapped(sender: UIButton){
        self.vinView.isHidden = false
        self.vinViewHeight.constant = 139
        self.detailView.isHidden = true
        self.yearLbl.text = ""
        self.makeLbl.text = ""
        self.modelLbl.text = ""
        self.trimLbl.text = ""
        self.fuelTypeLbl.text = ""
        self.milesDrivenLbl.text = ""
        self.colorLbl.text = ""
    }
    
    @objc func editBtnTapped(sender: UIButton){
        let SB = UIStoryboard(name: "Listing", bundle: nil)
        let vc = SB.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! AddVehicleDetailsVC
        vc.country = self.country
        vc.getYearValue = yearLbl.text!
        vc.getMakeValue = makeLbl.text!
        vc.getModelValue = modelLbl.text!
        vc.getTrimValue = trimLbl.text!
        vc.getfuelTypevalue = fuelTypeLbl.text!
        vc.getMilesValue = milesDrivenLbl.text!
        vc.getColorvalue = colorLbl.text!
        vc.selectionDelegate = self
        vc.editStatus = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @objc func skipBtnTapped(sender: UIButton){
        let SB = UIStoryboard(name: "Listing", bundle: nil)
        let vc = SB.instantiateViewController(withIdentifier: "VehicleDetailsVC") as! AddVehicleDetailsVC
        vc.country = self.country
        vc.selectionDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func nextBtnTapped(sender: UIButton) {
        if vinViewHeight.constant == 0{
            let SB = UIStoryboard(name: "Listing", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "VehicleListingPostVC") as! VehicleListingPostVC
            vc.imageArray = self.imageArray
            vc.country = self.country
            //Step One Attributes
            vc.paramDic.updateValue(self.paramDic["title"] ?? "", forKey: "title")
            vc.paramDic.updateValue(self.paramDic["description"] ?? "", forKey: "description")
            vc.paramDic.updateValue(self.paramDic["condition"] ?? "", forKey: "condition")
            // Location View Attributes
            vc.paramDic.updateValue(self.paramDic["lat"] ?? "", forKey: "lat")
            vc.paramDic.updateValue(self.paramDic["lng"] ?? "", forKey: "lng")
            vc.paramDic.updateValue(self.paramDic["token"] ?? "", forKey: "token")
            vc.paramDic.updateValue(self.paramDic["name"] ?? "", forKey: "name")
            vc.paramDic.updateValue(self.paramDic["uid"] ?? "", forKey: "uid")
            vc.paramDic.updateValue(self.paramDic["image"] ?? "", forKey: "image")
            vc.paramDic.updateValue(self.paramDic["country_code"] ?? "", forKey: "country_code")
            vc.paramDic.updateValue(self.paramDic["city"] ?? "", forKey: "city")
            vc.paramDic.updateValue(self.paramDic["zipcode"] ?? "", forKey: "zipcode")
            vc.paramDic.updateValue(self.paramDic["state"] ?? "", forKey: "state")
            // New Elemets
            vc.paramDic.updateValue("Vehicles", forKey: "itemCategory")
            vc.paramDic.updateValue(yearLbl.text!, forKey: "year")
            vc.paramDic.updateValue(makeLbl.text!, forKey: "make")
            vc.paramDic.updateValue(modelLbl.text!, forKey: "model")
            vc.paramDic.updateValue(milesDrivenLbl.text!, forKey: "miles_driven")
            vc.paramDic.updateValue(fuelTypeLbl.text!, forKey: "fuel_type")
            vc.paramDic.updateValue(colorLbl.text!, forKey: "color")
            vc.paramDic.updateValue(trimLbl.text!, forKey: "trim")
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            showSwiftMessageWithParams(theme: .info, title: "Listing", body: "Please fill in all the fields")
        }
    }
    
    //MARK:- Private Function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Vehicle Details"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    
    private func setupView() {
        scanBtn.shadowView()
        scanVinBtn.shadowView()
        skipVinBtn.shadowView()
        nextBtn.shadowView()
        editBtn.shadowView()
        clearBtn.shadowView()
        clearBtn.addTarget(self, action: #selector(clearBtnTapped(sender:)), for: .touchUpInside)
        scanVinBtn.addTarget(self, action: #selector(barCodeScanBtnTapped(sender:)), for: .touchUpInside)
        scanBtn.addTarget(self, action: #selector(getVehicleData), for: .touchUpInside)
        skipVinBtn.addTarget(self, action: #selector(skipBtnTapped(sender:)), for: .touchUpInside)
        editBtn.addTarget(self, action: #selector(editBtnTapped(sender:)), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(nextBtnTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func getVehicleData(sender: UIButton){
        if vinNumberTextField.text!.isEmpty || vinNumberTextField.text!.count < 17 {
            showSwiftMessageWithParams(theme: .info, title: "Vin Number", body: "Please Enter 17 Digit Vin Number")
            vinNumberTextField.becomeFirstResponder()
        }else {
            let value = vinNumberTextField.text?.split(separator: "I")
            DispatchQueue.main.async {
                let url = "http://api.marketcheck.com/v1/vin/\(value?[0] ?? " " )/specs?api_key=7RlHupav8leC7Y4TsGdMJyixbTAkylLS"
                let header = ["Host": "marketcheck-prod.apigee.net"]
                Alamofire.request(url, method: .get , encoding: JSONEncoding.default , headers : header).responseJSON { (response) in
                    print("Request: \(String(describing: response.request))")   // original url request
                    print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(response.result)")// response serialization result
                    print(response)
                    switch response.result {
                    case .success(_):
                        print(response)
                        guard let data = response.data else {return}
                        do {
                            if let jsonDic = try JSON(data: data).dictionary{
                                let fuelType = jsonDic["fuel_type"]?.string ?? ""
                                let trim = jsonDic["trim"]?.string ?? ""
                                let make = jsonDic["make"]?.string ?? ""
                                let model = jsonDic["model"]?.string ?? ""
                                let year = jsonDic["year"]?.int ?? 0
                                self.vinView.isHidden = true
                                self.vinViewHeight.constant = 0
                                self.detailView.isHidden = false
                                self.yearLbl.text = "\(year)"
                                self.makeLbl.text = make
                                self.modelLbl.text = model
                                self.trimLbl.text = trim
                                self.fuelTypeLbl.text = fuelType
                                self.milesDrivenLbl.text = ""
                                self.colorLbl.text = ""
                            }
                        }
                        catch let jsonErr{
                            print(jsonErr.localizedDescription)
                        }
                        
                    case .failure(let error):
                        print("Error = \(error)")
                    }
                }
            }
        }
    }
}
extension VehicleListingStepThreeVC: ScanVinDelegate {
    func didRecieveBarCode(Code: String) {
        if Code.count < 17 {
            showSwiftMessageWithParams(theme: .info, title: "Vin Number", body: "Invalid Vin Number please enter the Vin Number")
            vinNumberTextField.becomeFirstResponder()
        }else {
            vinNumberTextField.text = Code
        }
    }
}
extension VehicleListingStepThreeVC: AddDetailsDelegate {
    func didRecievData(year: String, Make: String, Model: String, Trim: String, FuelType: String, Color: String, Miles: String) {
        print(year)
        self.vinView.isHidden = true
        self.vinViewHeight.constant = 0
        self.detailView.isHidden = false
        self.yearLbl.text = year
        self.makeLbl.text = Make
        self.modelLbl.text = Model
        self.trimLbl.text = Trim
        self.fuelTypeLbl.text = FuelType
        self.milesDrivenLbl.text = Miles
        self.colorLbl.text = Color
    }
    
    
}
