//
//  VehiclesListingOneVC.swift
//  Sell4Bids
//
//  Created by Admin on 21/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVFoundation
import BSImagePicker
import Photos

//var VehicleStoryboard = UIStoryboard.init(name: "ItemsSell", bundle: nil)
//var VehicleStoryboard2 = UIStoryboard.init(name: "VehiclesSell", bundle: nil)

class VehiclesListingOneVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
    
    var TakePhotoCount = 0
    var SelectPhotoCount = 0
    var CameraView = UIImage()
    var TakePhotoCustomView = Bundle.main.loadNibNamed("TakePhotoCustomView", owner: self, options: nil)?.first as! TakePhotoCustomView
    var ImageCustomView = Bundle.main.loadNibNamed("ItemImageView", owner: self, options: nil)?.first as! ImageCustomView
    var TitleCustomView = Bundle.main.loadNibNamed("ItemDetailView", owner: self, options: nil)?.first as! TitleCustomView
    var picker2 = UIImagePickerController()
    let vc = BSImagePickerViewController()
    var imageList = [UIImage]()
    
    
    
    @IBOutlet weak var PostImage: UIImageView!
    
    @IBAction func hideShadowandImageView(_ sender: Any) {
        backGroundShahdow.isHidden = true
        ExtraImagePicker.isHidden = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Info = \(info)")
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            
            print("No image found")
            return
        }
        
        imageList.append(image)
        MainImage.image = image
        
        DispatchQueue.main.async {
            if self.imageList.count > 0 {
                self.TakePhotoHeightConstrant.constant = 0
                self.TakePhotoView.isHidden = true
                self.ImageCustomViewHeight.constant = 200
                self.TopConstraintValue.constant = 10
                
                self.CollectionViewHeight.constant = 80
                
                self.CloseBtn.constant = 30
                
            }
            
            self.ItemImageCollection.reloadData()
        }
        self.backGroundShahdow.isHidden = true
        self.ExtraImagePicker.isHidden = true
        
        
        UIView.animate(withDuration: 2.0, delay: 0.10, options: .beginFromCurrentState, animations: {
            
            let transition = CATransition()
            transition.duration = 25
            transition.type = kCATransitionPush
            transition.subtype = kCAOnOrderIn
            
            self.view.layer.add(transition, forKey: kCATransition)
            
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
    
    @IBAction func CloseActionBtn(_ sender: Any) {
        if imageList.count > 0  {
            imageList.remove(at: imageList.count - 1)
            ItemImageCollection.reloadData()
        }
        if self.imageList.count == 0 {
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
        
        
        
        
    }
    
    
    
    
    
    
    
    func getAssetThumbnail(asset: [PHAsset]) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        imageList.removeAll()
        option.isSynchronous = true
        
        
        for assets in asset {
            manager.requestImage(for: assets, targetSize: CGSize(width: 200.0, height: 200.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
                self.imageList.append(thumbnail)
                
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
                    
                    self.ItemImageCollection.reloadData()
                    print("thumbnail == \(thumbnail)")
                }
                
                
            })
            
        }
        
        return thumbnail
    }
    
    @objc func Select_Photo_Action() {
        
        
        vc.maxNumberOfSelections = 14
        
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("Selected: \(asset)")
                                            
        }, deselect: { (asset: PHAsset) -> Void in
            print("Deselected: \(asset)")
            print("assests = \(asset.mediaType)")
        }, cancel: { (assets: [PHAsset]) -> Void in
            print("Cancel: \(assets)")
            //self.presentingViewController?.dismiss(animated: true, completion: nil)
            
            //Ahmed Baloch Jan 21
            
        }, finish: { (assets: [PHAsset]) -> Void in
            
            print("Finish: \(assets)")
            
            let image = self.getAssetThumbnail(asset: assets)
            
            DispatchQueue.main.async {
                //                                self.ItemListingStepone.HideTakePhotoView()
                //                                self.ItemListingStepone.ShowImageView()
                self.MainImage.image = image
                if self.imageList.count > 0 {
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.MainImage.image = CameraView
        self.imageList.append(CameraView)
        
        
        if self.imageList.count > 0 {
            
            self.TakePhotoHeightConstrant.constant = 0
            self.TakePhotoView.isHidden = true
            self.ImageCustomViewHeight.constant = 200
            self.TopConstraintValue.constant = 45
            self.Scrollview.layoutIfNeeded()
            self.CollectionViewHeight.constant = 80
            
            self.CloseBtn.constant = 30
            
            
        }
        
        DispatchQueue.main.async {
            self.ItemImageCollection.reloadData()
        }
    }
    
    @objc func Take_Photo_Action() {
        
        
        performSegue(withIdentifier: "Camera", sender: nil)
        self.dismiss(animated: true, completion: nil)
        
        //self.presentingViewController?.dismiss(animated: false, completion:nil)
        
        //        if UIImagePickerController.isSourceTypeAvailable(.camera)
        //        {
        //            TakePhotoCount += 1
        //            picker2.sourceType = .camera
        //
        //
        //            self.present(picker2, animated: true, completion: nil)
        //
        //        }
        //        else{
        //            self.alert(message: "No camera availabe", title: "ERROR")
        //        }
        //
    }
    
    
    
    
    @IBAction func TakeMoreImgeBtn(_ sender: Any) {
        performSegue(withIdentifier: "Camera", sender: nil)
    }
    
    
    
    @IBAction func SelectMoreImageBtn(_ sender: Any) {
        
        
        
        vc.maxNumberOfSelections = 14
        
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("Selected: \(asset)")
                                            
        }, deselect: { (asset: PHAsset) -> Void in
            print("Deselected: \(asset)")
            print("assests = \(asset.mediaType)")
        }, cancel: { (assets: [PHAsset]) -> Void in
            print("Cancel: \(assets)")
            //Ahmed Baloch Jan 21
            
        }, finish: { (assets: [PHAsset]) -> Void in
            
            print("Finish: \(assets)")
            
            let image = self.getAssetThumbnail(asset: assets)
            DispatchQueue.main.async {
                //                self.ItemListingStepone.HideTakePhotoView()
                //                self.ItemListingStepone.ShowImageView()
                self.MainImage.image = image
                if self.imageList.count > 0 {
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
        self.backGroundShahdow.isHidden = false
        self.ExtraImagePicker.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        TakePhotoBtn.addTarget(self, action: #selector(Take_Photo_Action), for: .touchUpInside)
        
        SelectPhotoBtn.addTarget(self, action: #selector(Select_Photo_Action), for: .touchUpInside)
        
        
        
        ItemImageCollection.delegate = self
        ItemImageCollection.dataSource = self
        
        
        picker2.delegate = self
        
        let tapgesturepostimg = UITapGestureRecognizer.init(target: self, action: #selector(showExtraImgView))
        
        PostImage.addGestureRecognizer(tapgesturepostimg)
        PostImage.isUserInteractionEnabled = true
        
        
        Title_Custom_View.addShadow()
        
        
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Camera" {
            if let navigationController = segue.destination as? UINavigationController {
                let childViewController = navigationController.topViewController as? CameraOwnViewController
                childViewController?.delegate = self
            }
            
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension VehiclesListingOneVC : getImageDelegate {
    func getCapturedImg(img: UIImage) {
        print("Called Delegate Camera")
        self.CameraView = img
    }
    
    
}
