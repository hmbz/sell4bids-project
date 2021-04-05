//
//  HousingListing_One.swift
//  Sell4Bids
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 admin. All rights reserved.
//  Osama Mansoori

import UIKit
import AVFoundation
import BSImagePicker
import Photos

class HousingListingStepOne: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,getImageDelegate {
    
    //MARK:- Outlets and Properties
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
    @IBOutlet weak var Categories_Custom_View: UIView!
    @IBOutlet weak var backGroundShahdow: UIView!
    @IBOutlet weak var ItemTitle: UITextField!
    @IBOutlet weak var ExtraImagePicker: DesignableView!
    @IBOutlet weak var SelectCategoryName: textFieldWithNoCopyPasteSelect!
    @IBOutlet weak var PostImage: UIImageView!
    
    
    //MARK:- Variables
    var CategoryArray = ["Any","Apartment for rent","Apartment for sale","House for rent","Housing Wanted","Rooms"]
    var HousingArray = ["All Housing","Apartment for rent","Apartment for sale","House for rent","House for sale","Housing Wanted"]
    var limitcount = 0
    var TakePhotoCount = 0
    var SelectPhotoCount = 0
    var CameraView = UIImage()
    var TakePhotoCustomView = Bundle.main.loadNibNamed("TakePhotoCustomView", owner: self, options: nil)?.first as! TakePhotoCustomView
    var ImageCustomView = Bundle.main.loadNibNamed("ItemImageView", owner: self, options: nil)?.first as! ImageCustomView
    var picker2 = UIImagePickerController()
    let vc = BSImagePickerViewController()
    var imageList = [UIImage]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        MainImage.makeRedAndRound()
        TakePhotoBtn.addTarget(self, action: #selector(Take_Photo_Action), for: .touchUpInside)
        SelectPhotoBtn.addTarget(self, action: #selector(Select_Photo_Action), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        ItemImageCollection.delegate = self
        ItemImageCollection.dataSource = self
        ItemTitle.endEditing(true)
        TakePhotoBtn.endEditing(true)
        SelectPhotoBtn.endEditing(true)
        
        picker2.delegate = self
        let tapgesturepostimg = UITapGestureRecognizer.init(target: self, action: #selector(showExtraImgView))
        PostImage.addGestureRecognizer(tapgesturepostimg)
        PostImage.isUserInteractionEnabled = true
        Title_Custom_View.addShadow()
        Categories_Custom_View.addShadow()
        selectCreatePicker(textField: SelectCategoryName, tag: 1)
        createToolBar(textField: SelectCategoryName)
        SelectCategoryName.delegate = self
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Camera" {
            if let navigationController = segue.destination as? UINavigationController {
                let childViewController = navigationController.topViewController as? CameraOwnViewController
                childViewController?.delegate = self
            }
            
        }
    }
    
    
    //MARK:-Actions
    
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
            print(image)
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
    
    // TakePhotoAction:
      @objc func Take_Photo_Action() {
          performSegue(withIdentifier: "Camera", sender: nil)
          self.dismiss(animated: true, completion: nil)
      }
      
      
      
      // TakeMoreImages:
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
            print(image)
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
    
    @objc func showExtraImgView () {
        if imageList.count >= 14 {
            showSwiftMessageWithParams(theme: .error, title: "Error", body: "You can add max 14 images.")
        }else {
            self.backGroundShahdow.isHidden = false
            self.ExtraImagePicker.isHidden = false
        }
        
    }
    
    
    //MARK:- Private Functions
    internal func getCapturedImg(img: UIImage) {
        print("Called Delegate Camera")
        
        if imageList.count >= 14 {
            showSwiftMessageWithParams(theme: .error, title: "Error", body: "Maximum Image Selection limit is 14")
            return
        }
        else{
            print("image detail == \(img.description)")
            limitcount += 1
            MainImage.image = img
            self.imageList.append(img)
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
    
    private func getAssetThumbnail(asset: [PHAsset]) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        
        for assets in asset {
            manager.requestImage(for: assets, targetSize: CGSize(width: 200.0, height: 200.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
                
                if self.imageList.count >= 14 {
                    showSwiftMessageWithParams(theme: .error, title: "Error", body: "You can add max 14 images")
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
    
    private func TextFieldStyle(){
        ItemTitle.makeCornersRound()
        ItemTitle.layer.borderColor = UIColor.black.cgColor
        ItemTitle.layer.borderWidth = 1.0
        
        SelectCategoryName.makeCornersRound()
        SelectCategoryName.layer.borderColor = UIColor.black.cgColor
        SelectCategoryName.layer.borderWidth = 1.0
    }
 
}

//MARK:- UITextFieldDelegate functions and actions
extension HousingListingStepOne : UITextFieldDelegate {
    
    
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
     func textFieldDidBeginEditing(_ textField: UITextField) {
         textField.placeholder = nil
     }
     func textFieldDidEndEditing(_ textField: UITextField) {
         if textField.text!.isEmpty {
             if textField == ItemTitle {
                 textField.placeholder = "Give title to housing"
             }else if textField == SelectCategoryName{
                 textField.placeholder = "Select Category"
             }else {
                 textField.placeholder = "Housing type"
             }
         }
         
     }
    @objc func handleDone(){
        SelectCategoryName.endEditing(true)
    }
}


//MARK:-  UIPickerViewDelegate, UIPickerViewDataSource
extension HousingListingStepOne: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return CategoryArray.count
        }else if (pickerView.tag == 2){
            return HousingArray.count
        }else{
            return CategoryArray.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            return CategoryArray[row]
        }else if (pickerView.tag == 2){
            return HousingArray[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            SelectCategoryName.text = CategoryArray[row]
        }
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
        
        if (pickerView.tag == 1) {
            label.text = CategoryArray[row]
        }else if (pickerView.tag == 2){
            label.text = HousingArray[row]
        }
        return label
    }
    
    
    
    func selectCreatePicker(textField: UITextField, tag: Int){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.tag = tag
        textField.inputView = pickerView
        
    }
    
}

//MARK:- Collection Views Delegate and Stubs
extension HousingListingStepOne: UICollectionViewDataSource,UICollectionViewDelegate{
    
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
        
    }
}





