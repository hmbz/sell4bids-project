//
//  HousingListingStepOneVC.swift
//  Sell4Bids
//
//  Created by admin on 12/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class HousingListingStepOneVC: UIViewController,UICollectionViewDelegateFlowLayout{
    //MARK:- Outlets and Properties
    @IBOutlet weak var selectPhotoView: UIView!
    @IBOutlet weak var selectPhotoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var takePhotoTitleLbl: UILabel!
    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var selectPhotoBtn: UIButton!
    @IBOutlet weak var showPhotoView: UIView!
    @IBOutlet weak var showPhotoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lastSelectedImageView: UIImageView!
    @IBOutlet weak var deSelectPhotoBtn: UIButton!
    @IBOutlet weak var selectMoreImageView: UIImageView!
    @IBOutlet weak var selectedImagesCollectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleFieldBorderLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var moreTakePhotoBtn: DesignableButton!
    @IBOutlet weak var moreSelectPhotoBtn: DesignableButton!
    @IBOutlet var moreView: DesignableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryTextFieldBorderLine: UILabel!
    
    
    //MARK:- Variables and Constents
    lazy var imageArray = [UIImage]()
    lazy var MyCollectionViewCellId: String = "itemDetailCollectionViewCell"
    var imagePicker: UIImagePickerController!
    let BSImagePicker = BSImagePickerViewController()
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    lazy var imageSelectionIndex = 0
    let CategoryArray = ["Select Category","Apartment for rent","Apartment for sale","House for rent","Housing Wanted","Rooms & Shared","Rooms Wanted","Office & Commercial","Parking & Storage", "Sublets & Temporary"]
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        topMenu()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barTintColor = UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
    }
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    
    //MARK:- Actions
    @objc func ProfileimageTapped(sender : UIButton) {
        let storyBoard = UIStoryboard(name: "myProfileSB", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ImageView") as! ImageView
        vc.selectedImage = imageArray[imageSelectionIndex]
        vc.userName = "Item Listing"
        vc.controller = "listing"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        print("Select More Image")
        if self.imageArray.count >= 14 {
            showSwiftMessageWithParams(theme: .error, title: "strMaximumPhotoLimitReached".localizableString(loc: LanguageChangeCode), body: "strMaximumPhotoAllowed".localizableString(loc: LanguageChangeCode))
        }
        else{
            self.shadowView.isHidden = false
            self.moreTakePhotoBtn.isHidden = false
            self.moreSelectPhotoBtn.isHidden = false
            self.moreView.isHidden = false
        }
    }
    
    @objc func takePhotoBtnTapped(sender: UIButton){
        print("Take Photo")
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func selectPhotoBtnTapped(sender: UIButton){
        print("Select Photo")
        BSImagePicker.maxNumberOfSelections = 14
        BSImagePicker.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.BSImagePicker.albumButton.tintColor = UIColor.white
        self.BSImagePicker.editButtonItem.tintColor = UIColor.white
        self.BSImagePicker.cancelButton.tintColor = UIColor.white
        self.BSImagePicker.toolbar.tintColor = UIColor.white
        //display picture gallery
        self.bs_presentImagePickerController(BSImagePicker, animated: true,
                                             select: { (asset: PHAsset) -> Void in
                                                
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            print("Finish: \(assets)")
            self.getAssetThumbnail(asset: assets)
            // Hiding Show Image View
            DispatchQueue.main.async {
                self.shadowView.isHidden = true
                self.moreTakePhotoBtn.isHidden = true
                self.moreSelectPhotoBtn.isHidden = true
                self.moreView.isHidden = true
                
                self.showPhotoViewHeight.constant = 160
                self.showPhotoView.isHidden = false
                self.selectedImagesCollectionView.isHidden = false
                self.deSelectPhotoBtn.isHidden = false
                self.lastSelectedImageView.isHidden = false
                self.selectMoreImageView.isHidden = false
                
                // Show Select Photo View
                
                self.selectPhotoViewHeight.constant = 0
                self.takePhotoTitleLbl.isHidden = true
                self.takePhotoBtn.isHidden = true
                self.selectPhotoBtn.isHidden = true
            }
            
        }, completion: nil)
    }
    
    @objc func nextBtnTapped(sender: UIButton){
        print("next")
        if imageArray.count < 1 {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strEmptyImageArray".localizableString(loc: LanguageChangeCode))
        }else if titleTextField.text!.isEmpty && titleTextField.text!.count < 3{
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strEmptyTitleTextField".localizableString(loc: LanguageChangeCode))
        }
        else if categoryTextField.text!.isEmpty || categoryTextField.text! == "Select Category" {
            showSwiftMessageWithParams(theme: .error, title: "strListing".localizableString(loc: LanguageChangeCode), body: "strEmptyCategory".localizableString(loc: LanguageChangeCode))
        }
        else {
            let SB = UIStoryboard(name: "Listing", bundle: nil)
            let vc = SB.instantiateViewController(withIdentifier: "HousingListingStepTwoVC") as! HousingListingStepTwoVC
            vc.imageArray = self.imageArray
            vc.categoryName = categoryTextField.text!
            vc.paramDic.updateValue(titleTextField.text!, forKey: "title")
            vc.paramDic.updateValue(categoryTextField.text!, forKey: "housingCategory")
            UserDefaults.standard.set(vc.paramDic, forKey: "housingTitleDic")
            let imageData = NSKeyedArchiver.archivedData(withRootObject: self.imageArray)
            UserDefaults.standard.set(imageData, forKey: "housingImagesArray")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func deselectImageBtnTapped(sender: UIButton) {
        print("Deselect Photo")
        if imageArray.count > 0  {
            if imageArray.count == 1 {
                imageArray.remove(at: imageArray.count - 1)
                selectedImagesCollectionView.reloadData()
                
                // Hiding Show Image View
                showPhotoViewHeight.constant = 0
                showPhotoView.isHidden = true
                selectedImagesCollectionView.isHidden = true
                self.deSelectPhotoBtn.isHidden = true
                self.lastSelectedImageView.isHidden = true
                self.selectMoreImageView.isHidden = true
                
                // Show Select Photo View
                
                self.selectPhotoViewHeight.constant = 150
                self.takePhotoTitleLbl.isHidden = false
                self.takePhotoBtn.isHidden = false
                self.selectPhotoBtn.isHidden = false
                
            }else {
                imageArray.remove(at: imageArray.count - 1)
                selectedImagesCollectionView.reloadData()
            }
            self.lastSelectedImageView.image = imageArray.last
        }
    }
    
    
    //MARK:- Private functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesBegan(touches , with:event)
           let touch = touches.first
           if touch?.view == shadowView {
            self.shadowView.isHidden = true
            self.moreTakePhotoBtn.isHidden = true
            self.moreSelectPhotoBtn.isHidden = true
            self.moreView.isHidden = true
               UIView.animate(withDuration: 0.3) {
                   self.view.layoutIfNeeded()
               }
           }
       }
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Title"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    
    private func setupViews() {
        let SessionDic: [String: Any]? = UserDefaults.standard.dictionary(forKey: "housingTitleDic")
        if SessionDic != nil {
            titleTextField.text = "\(SessionDic?["title"] ?? "")"
            categoryTextField.text = "\(SessionDic?["housingCategory"] ?? "")"
        }
        
        let imageData = UserDefaults.standard.object(forKey: "housingImagesArray") as? NSData

        if let imageData = imageData {
            let imageArray = NSKeyedUnarchiver.unarchiveObject(with: imageData as Data) as? [UIImage]
//                Hiding Show Image View
            showPhotoViewHeight.constant = 160
            showPhotoView.isHidden = false
            selectedImagesCollectionView.isHidden = false
            self.deSelectPhotoBtn.isHidden = false
            self.lastSelectedImageView.isHidden = false
            self.selectMoreImageView.isHidden = false
            
            // Show Select Photo View
            
            self.selectPhotoViewHeight.constant = 0
            self.takePhotoTitleLbl.isHidden = true
            self.takePhotoBtn.isHidden = true
            self.selectPhotoBtn.isHidden = true
            
            // Item to show Data
            
            self.lastSelectedImageView.image = imageArray?.last
            self.imageArray = imageArray!
            self.selectedImagesCollectionView.reloadData()
        }else {
            // Hiding Show Image View
            showPhotoViewHeight.constant = 0
            showPhotoView.isHidden = true
            selectedImagesCollectionView.isHidden = true
            self.deSelectPhotoBtn.isHidden = true
            self.lastSelectedImageView.isHidden = true
            self.selectMoreImageView.isHidden = true
            
            // Show Select Photo View
            
            self.selectPhotoViewHeight.constant = 150
            self.takePhotoTitleLbl.isHidden = false
            self.takePhotoBtn.isHidden = false
            self.selectPhotoBtn.isHidden = false
        }
        
        
        selectedImagesCollectionView.delegate = self
        selectedImagesCollectionView.dataSource = self
        
        self.tabBarController?.tabBar.isHidden = true
        
        takePhotoBtn.shadowView()
        takePhotoBtn.layer.borderWidth = 1.0
        takePhotoBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        selectPhotoBtn.shadowView()
        selectPhotoBtn.layer.borderWidth = 1.0
        selectPhotoBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        moreSelectPhotoBtn.shadowView()
        moreSelectPhotoBtn.layer.borderWidth = 1.0
        moreSelectPhotoBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        moreTakePhotoBtn.shadowView()
        moreTakePhotoBtn.layer.borderWidth = 1.0
        moreTakePhotoBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        lastSelectedImageView.layer.cornerRadius = 6
        lastSelectedImageView.layer.masksToBounds = true
        lastSelectedImageView.layer.borderWidth = 1.0
        lastSelectedImageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        selectMoreImageView.isUserInteractionEnabled = true
        selectMoreImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        self.selectedImagesCollectionView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        
        nextBtn.shadowView()
        
        takePhotoBtn.addTarget(self, action: #selector(takePhotoBtnTapped(sender:)), for: .touchUpInside)
        selectPhotoBtn.addTarget(self, action: #selector(selectPhotoBtnTapped(sender:)), for: .touchUpInside)
    
        moreTakePhotoBtn.addTarget(self, action: #selector(takePhotoBtnTapped(sender:)), for: .touchUpInside)
        moreSelectPhotoBtn.addTarget(self, action: #selector(selectPhotoBtnTapped(sender:)), for: .touchUpInside)
        
        nextBtn.addTarget(self, action: #selector(nextBtnTapped(sender:)), for: .touchUpInside)
        deSelectPhotoBtn.addTarget(self, action: #selector(deselectImageBtnTapped(sender:)), for: .touchUpInside)
        
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(ProfileimageTapped))
        lastSelectedImageView.isUserInteractionEnabled = true
        lastSelectedImageView.addGestureRecognizer(tapOnImage)
        
        selectCreatePicker(textField: categoryTextField, tag: 1)
        createToolBar(textField: categoryTextField)
    }
    
    private func getAssetThumbnail(asset: [PHAsset]){
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        
        for assets in asset {
            manager.requestImage(for: assets, targetSize: CGSize(width: 750.0, height: 750.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
                if self.imageArray.count >= 14 {
                    showSwiftMessageWithParams(theme: .error, title: "strMaximumPhotoLimitReached".localizableString(loc: LanguageChangeCode), body: "strMaximumPhotoAllowed".localizableString(loc: LanguageChangeCode))
                }
                else{
                    self.imageArray.append(thumbnail)
                    self.lastSelectedImageView.image = self.imageArray.last
                    self.selectedImagesCollectionView.reloadData()
                }
            })
        }
    }
}
//TODO:- Collection View Delgate and DataSource
extension HousingListingStepOneVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! itemDetailCollectionViewCell
        cell.userImage.image = imageArray[indexPath.row]
        cell.userImage.layer.cornerRadius = 6
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.userImage.layer.borderWidth = 0.5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.lastSelectedImageView.image = self.imageArray[indexPath.row]
        self.imageSelectionIndex = indexPath.row
    }
    
}
//TODO:- Text field Delegate Functions
extension HousingListingStepOneVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleFieldBorderLbl.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        titleFieldBorderLbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
//TODO:- Image Picker Functions
extension HousingListingStepOneVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("No image found")
            return
        }
        self.shadowView.isHidden = true
        self.moreTakePhotoBtn.isHidden = true
        self.moreSelectPhotoBtn.isHidden = true
        self.moreView.isHidden = true
        
        // Hiding Show Image View
        showPhotoViewHeight.constant = 160
        showPhotoView.isHidden = false
        selectedImagesCollectionView.isHidden = false
        self.deSelectPhotoBtn.isHidden = false
        self.lastSelectedImageView.isHidden = false
        self.selectMoreImageView.isHidden = false
        
        // Show Select Photo View
        
        self.selectPhotoViewHeight.constant = 0
        self.takePhotoTitleLbl.isHidden = true
        self.takePhotoBtn.isHidden = true
        self.selectPhotoBtn.isHidden = true
        
        let imageSizeBEforeCompression = getImageSize(Image: image)
        print("Image Size Before Compression = \(imageSizeBEforeCompression)")
        let compressImage = resizeImageData(image: image)
        print(compressImage)
        let imageSizeAfterCompression = getImageSize(Image: compressImage)
        print("Image Size Before Compression = \(imageSizeAfterCompression)")
        
        self.lastSelectedImageView.image = compressImage
        self.imageArray.append(compressImage)
        self.selectedImagesCollectionView.reloadData()
    }
}
//MARK:-  UIPickerViewDelegate, UIPickerViewDataSource
extension HousingListingStepOneVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return CategoryArray.count
        }else{
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            return CategoryArray[row]
        }else {
          return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1){
            categoryTextField.text = CategoryArray[row]
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
        label.text = CategoryArray[row]
        return label
    }
    
    
    
    func selectCreatePicker(textField: UITextField, tag: Int){
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
    
    @objc func handleDone(){
        self.view.endEditing(true)
    }
    
}
