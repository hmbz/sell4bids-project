//
//  ItemListingOneVC.swift
//  Sell4Bids
//
//  Created by admin on 06/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVFoundation
import BSImagePicker
import Photos
import TGPControls


class ItemListingOneVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
    //MARK:- Properties and Outlets
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
    @IBOutlet weak var PostImage: UIImageView!
    
    //MARK:- Variable and Constents
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
        setupViews()
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
    

    
    //MARK:- Actions
    @IBAction func hideShadowandImageView(_ sender: Any) {
        backGroundShahdow.isHidden = true
        ExtraImagePicker.isHidden = true
    }
    
    @IBAction func CloseActionBtn(_ sender: Any) {
        if imageList.count > 0  {
            if imageList.count != 0 {
                MainImage.image = imageList.last!
                imageList.remove(at: imageList.count - 1)
            }
            ItemImageCollection.reloadData()
        }
        if self.imageList.count <= 0 {
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
        DispatchQueue.main.async {
            //vc.doneButton.tintColor = UIColor.white
            self.vc.albumButton.tintColor = UIColor.white
            self.vc.editButtonItem.tintColor = UIColor.white
            self.vc.cancelButton.tintColor = UIColor.white
        }
        //display picture gallery
        self.bs_presentImagePickerController(vc, animated: true,
                                             select: { (asset: PHAsset) -> Void in
                                                
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            print("Finish: \(assets)")
            
            self.getAssetThumbnail(asset: assets)
            
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
            self.getAssetThumbnail(asset: assets)
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
            showSwiftMessageWithParams(theme: .error, title: "ERROR".localizableString(loc: LanguageChangeCode), body: "You can add max 14 images.")
        }else {
            self.backGroundShahdow.isHidden = false
            self.ExtraImagePicker.isHidden = false
        }
        
    }
    
    
    //MARK:- Private Functions
    
    private func getAssetThumbnail(asset: [PHAsset]){
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true

        for assets in asset {
            manager.requestImage(for: assets, targetSize: CGSize(width: 750.0, height: 750.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
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
                    }
                }
            })
          }
    }
    
    private func setupViews() {
        ItemImageCollection.delegate = self
        ItemImageCollection.dataSource = self
        ItemTitle.endEditing(true)
        TakePhotoBtn.endEditing(true)
        SelectPhotoBtn.endEditing(true)
        picker2.delegate = self
        
        Title_Custom_View.addShadow()
        MainImage.makeRedAndRound()
        
        TakePhotoBtn.addTarget(self, action: #selector(Take_Photo_Action), for: .touchUpInside)
        SelectPhotoBtn.addTarget(self, action: #selector(Select_Photo_Action), for: .touchUpInside)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let tapgesturepostimg = UITapGestureRecognizer.init(target: self, action: #selector(showExtraImgView))
        PostImage.addGestureRecognizer(tapgesturepostimg)
        PostImage.isUserInteractionEnabled = true
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

//MARK:- Text Field Delegate
extension ItemListingOneVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Text Field Begin Editing")
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Text Field End Editing")
        if textField.text!.isEmpty{
          textField.placeholder = "What are you selling?"
        }
    }
}

//MARK:- Collection view Delegate
extension ItemListingOneVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
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

//MARK:-  Getting Image and convert
extension ItemListingOneVC : getImageDelegate {
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
            
            limitcount += 1
            MainImage.image = compressImage
            self.imageList.append(compressImage)
            
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


    


