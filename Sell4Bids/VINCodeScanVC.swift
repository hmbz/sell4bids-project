//
//  VINCodeScanVC.swift
//  Sell4Bids
//
//  Created by admin on 2/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class VINCodeScanVC: UIViewController {
    
    @IBOutlet weak var VinNumberTxt: UITextField!
    @IBOutlet weak var AddDetailsBtn: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var barcodeBtn: UIButton!
    @IBOutlet weak var findDetailsBtn: UIButton!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var View3: UIView!
    
    @IBOutlet weak var carDetailsView: UIView!
    @IBOutlet weak var vehicleDetailsView: UIView!
    
    @IBOutlet weak var Make: UILabel!
    @IBOutlet weak var Model: UILabel!
    @IBOutlet weak var Year: UILabel!
    @IBOutlet weak var kmdDrive: UILabel!
    @IBOutlet weak var fuelType: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var trim: UILabel!
    
    
    @IBOutlet weak var showYearData: UILabel!
    @IBOutlet weak var showMakeData: UILabel!
    @IBOutlet weak var showModelData: UILabel!
    @IBOutlet weak var showTrimData: UILabel!
    @IBOutlet weak var showKmdDriveData: UILabel!
    @IBOutlet weak var showFuelTypeData: UILabel!
    @IBOutlet weak var showColorData: UILabel!
    var country = String()
    
    
    let appColor = UIColor(red: 0.76, green: 0.25, blue: 0.18 , alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addInviteBarButtonToTop()
        addLeftHomeBarButtonToTop()
        addLogoWithLeftBarButton()
        self.title = "Add Vehicle Details"
        
        carDetailsView.isHidden = true
        vehicleDetailsView.isHidden = true
        
        carDetailsView.clipsToBounds = true
        carDetailsView.cardViewBorder()
        carDetailsView.layer.cornerRadius = 8
        
        vehicleDetailsView.clipsToBounds = true
        vehicleDetailsView.cardViewBorder()
        vehicleDetailsView.layer.cornerRadius = 8
        
        AddDetailsBtn.makeCornersRound()
        VinNumberTxt.makeCornersRound()
        
        VinNumberTxt.layer.borderColor = UIColor.black.cgColor
        VinNumberTxt.layer.borderWidth = 2.0
        VinNumberTxt.text = ""
        
        
        View3.makeCornersRound()
        View3.addShadowAndRound()
        View3.layer.cornerRadius = 8
        
        view2.layer.cornerRadius = 8
        view2.clipsToBounds = true
        view2.cardViewBorder()
        
        barcodeBtn.layer.borderColor = UIColor.black.cgColor
        barcodeBtn.layer.borderWidth = 2.0
        barcodeBtn.layer.cornerRadius = 8
        
        findDetailsBtn.makeCornersRound()
        
        
        
    }
    
    
    
    @objc func handleSendMail() {
        print("Mail Sended")
    }
    
    
    @IBAction func barcodeBtnAction(_ sender: Any) {
        
        performSegue(withIdentifier: "camera", sender: nil)
    }
    
    
    
    @IBAction func findDetails(_ sender: Any) {
        
        if (VinNumberTxt.text?.count)! <= 15 || (VinNumberTxt.text?.count)! >= 18 || ((VinNumberTxt.text?.isEmpty)!) {
            
            showSwiftMessageWithParams(theme : .error, title: "VIN Required", body: "Please enter a VIN to continue.")
        }else{
            
            GlocalVINNO = VinNumberTxt.text
            print("gnumberVIN = \(String(describing: GlocalVINNO))")
            let SearchVC = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "CarDetailsAuto") as! CarDetailsAutoVC
            SearchVC.delegate =  self
            SearchVC.VehiclesDetailsStackView = vehicleDetailsView
            SearchVC.viewCarDetailStack = carDetailsView
            present(SearchVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func AddDetails(_ sender: Any) {
        
        let SkipVC = ListingStoryBoard_Bundle.instantiateViewController(withIdentifier: "cardetailsmanual") as! CarDetailsVC
        SkipVC.delegate = self
        SkipVC.VehiclesDetailsStackView = vehicleDetailsView
        SkipVC.viewCarDetailStack = carDetailsView
        SkipVC.country = country
        present(SkipVC, animated: true, completion: nil)
        
        
    }
    
    
}

extension VINCodeScanVC: CarDetailsVCDelegate{
    func CarDetailsVCTapped(getModelValue: String, getMakeValue: String, getYearValue: String, getTrimValue: String, getkmdDrivevalue: String, getfuelTypevalue: String, getColorvalue: String) {
        print("Called Delegate vechiles")
        showYearData.text = getYearValue
        showMakeData.text = getMakeValue
        showModelData.text = getModelValue
        showTrimData.text = getTrimValue
        showKmdDriveData.text = getkmdDrivevalue
        showFuelTypeData.text = getfuelTypevalue
        showColorData.text = getColorvalue
    }
    
    
}
extension VINCodeScanVC: CarDetailsAutoVCDelegate {
    func CarDetailsAutoVCTapped(getModelValue: String, getMakeValue: String, getYearValue: String, getTrimValue: String, getkmdDrivevalue: String, getfuelTypevalue: String, getColorvalue: String) {
        print("Called Delegate vechiles")
        showYearData.text = getYearValue
        showMakeData.text = getMakeValue
        showModelData.text = getModelValue
        showTrimData.text = getTrimValue
        showKmdDriveData.text = getkmdDrivevalue
        showFuelTypeData.text = getfuelTypevalue
        showColorData.text = getColorvalue
    }
    
    
}


