//
//  VehiclesListingStep1VC.swift
//  Sell4Bids
//
//  Created by Admin on 22/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVFoundation
import BSImagePicker
import Photos
import TGPControls



class VehiclesListingStep1VC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    
    @IBOutlet weak var TakeItemconstant: NSLayoutConstraint!
    @IBOutlet weak var ScrollDownConstraint: NSLayoutConstraint!
    @IBOutlet weak var Scrollview: UIScrollView!
    @IBOutlet weak var CloseBtn: NSLayoutConstraint!
    @IBOutlet weak var TopConstraintValue: NSLayoutConstraint!
    @IBOutlet weak var MainImage: UIImageView!
    @IBOutlet weak var ItemImageCollection: UICollectionView!
    @IBOutlet weak var CollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var TakePhotoBtn: UIButton!
    @IBOutlet weak var SelectPhotoBtn: UIButton!
    @IBOutlet weak var ImageCustomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var TakePhotoHeightConstrant: NSLayoutConstraint!
    @IBOutlet weak var TakePhotoView: UIView!
    @IBOutlet weak var Image_Custom_View: UIView!
    @IBOutlet weak var Title_Custom_View: UIView!
    
    @IBOutlet weak var backGroundShahdow: UIView!
    
    
    
    @IBOutlet weak var ItemTitle: UITextField!
    
    @IBOutlet weak var ExtraImagePicker: DesignableView!
    
    @IBOutlet weak var conditionView: UIView!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ConditionValueTextField: UITextField!
    @IBOutlet var conditionTFBorderLine: UILabel!
    @IBOutlet var descriptionTextViewHeight: NSLayoutConstraint!
    @IBOutlet var descriptionBorderLbl: UILabel!
    
    
    var TakePhotoCount = 0
    var SelectPhotoCount = 0
    var CameraView = UIImage()
    var TakePhotoCustomView = Bundle.main.loadNibNamed("TakePhotoCustomView", owner: self, options: nil)?.first as! TakePhotoCustomView
    var ImageCustomView = Bundle.main.loadNibNamed("ItemImageView", owner: self, options: nil)?.first as! ImageCustomView
    var picker2 = UIImagePickerController()
    let vc = BSImagePickerViewController()
    var imageList = [UIImage]()
    var conditionList = [String]()
    
    @IBOutlet weak var PostImage: UIImageView!
    var limitcount = 0
    
    @IBAction func hideShadowandImageView(_ sender: Any) {
        backGroundShahdow.isHidden = true
        ExtraImagePicker.isHidden = true
    }

    
    @IBAction func CloseActionBtn(_ sender: Any) {
        if imageList.count > 0  {
            
            if imageList.count != 0 {
                
                MainImage.image = imageList.last!
                imageList.remove(at: imageList.count - 1)
                print("ImageList Array closed Button == \(imageList)")
            }
            
            ItemImageCollection.reloadData()
            print("ImageList Array closed Button Reload")
        }
        if self.imageList.count <= 0 {
            print("ImageList Array closed Button Internal")
            self.TakePhotoHeightConstrant.constant = 150
            self.TakePhotoView.isHidden =  false
            self.ImageCustomViewHeight.constant = 0
            self.TopConstraintValue.constant = 10
            self.TakeItemconstant.constant = 10
            self.Scrollview.layoutIfNeeded()
            self.CollectionViewHeight.constant = 0
            self.CloseBtn.constant = 0
        }
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customcell = ItemImageCollection.dequeueReusableCell(withReuseIdentifier: "ItemImage", for: indexPath) as! CustomImageCollCellCollectionViewCell
        
        
        
        customcell.ItemImage.image = self.imageList[indexPath.item]
        
        return customcell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        MainImage.image = imageList[indexPath.row]
        MainImage.tag = indexPath.row
        
      
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "Vehicles_ImagePopUpView-identifier")  as! Vehicles_ImagePopUpView
        controller.selectedIndex = indexPath
        print("controller.selectedIndex : \(controller.selectedIndex)")
        controller.view.backgroundColor = UIColor.white
        controller.imagesArray = imageList
        print("imagesArray == \(controller.imagesArray)")
        
        controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true, completion: nil)
        
        
        
        
        
        
        
        
        
    }
    

    
    func getAssetThumbnail(asset: [PHAsset]) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        
        for assets in asset {
            manager.requestImage(for: assets, targetSize: CGSize(width: 200.0, height: 200.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
                
                if self.imageList.count >= 14 {
                    showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "You can add max 14 images")
                    return
                }
                else{
                    self.imageList.append(thumbnail)
                    print("ImageList_Count_getAssetThumbnail  == \(self.imageList.count)")
                    
                    DispatchQueue.main.async {
                        
                        if self.imageList.count > 0 {
                            self.TakePhotoHeightConstrant.constant = 0
                            self.TakePhotoView.isHidden = true
                            self.ImageCustomViewHeight.constant = 200
                            self.TopConstraintValue.constant = 10
                            self.Scrollview.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
                            self.CollectionViewHeight.constant = 80
                            
                            self.CloseBtn.constant = 30
                            
                        }
                        
                        self.MainImage.image = self.imageList.last!
                        self.ItemImageCollection.reloadData()
                        print("thumbnail == \(thumbnail)")
                        
                    }
                }
                
                
                
                
            })
        }
        return thumbnail
    }
    
    
    @objc func Select_Photo_Action() {
        
        vc.maxNumberOfSelections = 14 - limitcount
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("imagelist Count 2 ==\(self.imageList.count) ")
                                            print("Selected: \(asset)")
                                            
        }, deselect: { (asset: PHAsset) -> Void in
            
            print("Deselected: \(asset)")
            print("assests = \(asset.mediaType)")
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            
            print("Cancel: \(assets)")
            
            self.Image_Custom_View.isHidden = false
            
            
        }, finish: { (assets: [PHAsset]) -> Void in
            
            print("Finish: \(assets)")
            
            let image = self.getAssetThumbnail(asset: assets)
            
            DispatchQueue.main.async {
                
                if self.imageList.count > 0 {
                    self.MainImage.isHidden = false
                    self.TakePhotoHeightConstrant.constant = 0
                    self.TakePhotoView.isHidden = true
                    self.ImageCustomViewHeight.constant = 200
                    self.TopConstraintValue.constant = 45
                    self.Scrollview.layoutIfNeeded()
                    self.CollectionViewHeight.constant = 80
                    
                    self.CloseBtn.constant = 30
                    
                    
                }
                
            }
            
            
        }, completion: nil)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        if textField == ConditionValueTextField {
            conditionTFBorderLine.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1)
        }else {
           ItemTitle.placeholder = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ItemTitle.text!.isEmpty {
            ItemTitle.placeholder = "Give title to vehicle"
        }else if textField == ConditionValueTextField{
            conditionTFBorderLine.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ExtraImagePicker.isHidden = true
        self.backGroundShahdow.isHidden = true
        
        if self.imageList.count > 0 {
            
            self.CollectionViewHeight.constant = 80
            self.ItemImageCollection.reloadData()
        }
        if self.imageList.count < 0 {
            
            self.CollectionViewHeight.constant = 0
            
        }
        
    }
    
    @objc func Take_Photo_Action() {
        
        
        performSegue(withIdentifier: "Camera", sender: nil)
        self.dismiss(animated: true, completion: nil)
        
        
    }
  
    
    
    @IBAction func TakeMoreImgeBtn(_ sender: Any) {
        
        performSegue(withIdentifier: "Camera", sender: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func SelectMoreImageBtn(_ sender: Any) {
        
        vc.maxNumberOfSelections = 14 - limitcount
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("imagelist_Count_1 ==\(self.imageList.count) ")
                                            print("Selected: \(asset)")
                                            
                                            
                                            
        }, deselect: { (asset: PHAsset) -> Void in
            
            print("Deselected: \(asset)")
            print("assests = \(asset.mediaType)")
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            
            print("Cancel: \(assets)")
            
        }, finish: { (assets: [PHAsset]) -> Void in
            
            print("Finish: \(assets)")
            
            
            let image = self.getAssetThumbnail(asset: assets)
            
            DispatchQueue.main.async {
                
                if self.imageList.count > 0 {
                    self.MainImage.isHidden = false
                    self.TakePhotoHeightConstrant.constant = 0
                    self.TakePhotoView.isHidden = true
                    self.ImageCustomViewHeight.constant = 200
                    self.TopConstraintValue.constant = 50
                    self.Scrollview.layoutIfNeeded()
                    self.CollectionViewHeight.constant = 80
                    
                    self.CloseBtn.constant = 30
                    
                    
                }
                
            }
            
            
        }, completion: nil)
        
    }
    
    
    
    @objc func showExtraImgView () {
        if imageList.count >= 14 {
            showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "You can add max 14 images.")
        }else {
            self.backGroundShahdow.isHidden = false
            self.ExtraImagePicker.isHidden = false
        }
        
    }
    
//    @objc func handleValueChange(_ sender: TGPDiscreteSlider)
//    {
//
//        let value = Int(sender.value)
//        self.conditionValue.text = conditionList[value]
//        print("Slide Value== \(sender.value)")
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        adjustTextViewHeight()
        
        
        conditionList = ["New","Used","For Parts","Other (see description)"]
        ConditionValueTextField.delegate = self
        selectCreatePicker(textField: ConditionValueTextField, tag: 1)
        createToolBar(textField: ConditionValueTextField)
//        ConditionValueTextField.makeCornersRound()
//        ConditionValueTextField.layer.borderWidth = 1.0
        
        
//        MainImage.makeRedAndRound()
        descriptionTextView.delegate = self
        descriptionTextView.text = "Vehicle Description"
        descriptionTextView.textColor = UIColor.lightGray
//        descriptionTextView.makeCornersRound()
//        descriptionTextView.layer.borderWidth = 1.0
        descriptionView.addShadow()
        conditionView.addShadow()
        
        TakePhotoBtn.addTarget(self, action: #selector(Take_Photo_Action), for: .touchUpInside)
        
        SelectPhotoBtn.addTarget(self, action: #selector(Select_Photo_Action), for: .touchUpInside)
        
        
        
        ItemImageCollection.delegate = self
        ItemImageCollection.dataSource = self
        
        
        
        picker2.delegate = self
        
        let tapgesturepostimg = UITapGestureRecognizer.init(target: self, action: #selector(showExtraImgView))
        
        PostImage.addGestureRecognizer(tapgesturepostimg)
        PostImage.isUserInteractionEnabled = true
        
        
        Title_Custom_View.addShadow()
        TakePhotoView.addShadow()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        TakePhotoBtn.endEditing(true)
        SelectPhotoBtn.endEditing(true)
        ItemTitle.endEditing(true)
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
//    func adjustTextViewHeight() {
//        let fixedWidth = descriptionTextView.frame.size.width
//        let newSize = descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: self.descriptionTextViewHeight.constant))
//        self.descriptionTextViewHeight.constant = newSize.height
//        self.view.layoutIfNeeded()
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        adjustTextViewHeight()
//    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
        }
        descriptionBorderLbl.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0, blue: 0.003921568627, alpha: 1)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Vehicle Description"
            descriptionTextView.textColor = UIColor.lightGray
        }
        descriptionBorderLbl.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Camera" {
            if let navigationController = segue.destination as? UINavigationController {
                let childViewController = navigationController.topViewController as? CameraOwnViewController
                childViewController?.delegate = self
            }
            
        }
    }
    
}

extension VehiclesListingStep1VC : getImageDelegate {
    func getCapturedImg(img: UIImage) {
        print("Called Delegate Camera")
        
        let imageSizeBEforeCompression = getImageSize(Image: img)
        print("Image Size Before Compression = \(imageSizeBEforeCompression)")
        let compressImage = resizeImageData(image: img)
        print(compressImage)
        let imageSizeAfterCompression = getImageSize(Image: compressImage)
        print("Image Size Before Compression = \(imageSizeAfterCompression)")
        
        if imageList.count >= 14 {
            showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "Maximum Image Selection limit is 14")
            return
        }
        else{
            print("image detail == \(compressImage.description)")
            
            limitcount += 1
            MainImage.image = compressImage
            self.imageList.append(compressImage)
            print("Imagelist Count == \(self.imageList.count)")
            
            
            self.TakePhotoHeightConstrant.constant = 0
            self.TakePhotoView.isHidden = true
            self.ImageCustomViewHeight.constant = 200
            self.TopConstraintValue.constant = 45
            self.Scrollview.layoutIfNeeded()
            self.CollectionViewHeight.constant = 80
            
            
            self.CloseBtn.constant = 30
            self.ItemImageCollection.reloadData()
            
            
            
            
        }
    }
    
    
}


extension VehiclesListingStep1VC: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    
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
