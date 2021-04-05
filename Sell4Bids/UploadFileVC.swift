//
//  UploadFileVC.swift
//  Sell4Bids
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage

class UploadFileVC: UIViewController , UIDocumentPickerDelegate  {

   
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var chooseFileBtn: UIView!
    @IBOutlet weak var DeleteBtn: UIButton!
    @IBOutlet weak var view3: UIView!
    
    var uid = "vGTlCKza0TMwU2OsItMzOU0nNh32"
    var product = "-LWB_4IpGRXWgnwAB0eO"
    var urlPath = String()
    
    var storageRef = Storage.storage().reference().child("0resume")
    
    var documentPicker : UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: UIDocumentPickerMode.import)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view2.isHidden = true
        view1.addShadow()
        view2.addShadow()
        view3.addShadowAndRound()
        documentPicker.delegate = self
      
    }
    
    func uploadProductImages(referenceOfProduct: DatabaseReference,uid: String, product: Product,imageName: Int, completion: @escaping (Bool) -> () )
    {
        let newMetadata = StorageMetadata()
       storageRef = storageRef.child("\(product)").child("\(uid)")
        
        //storageRef(urlPath, metadata:  newMetadata) { [weak self] (metadata, error) in
       // }
    
    }
    
    @IBAction func ChooseFileAction(_ sender: Any) {
       
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true, completion: nil)
        
         view2.isHidden = false
    }
    
    @IBAction func UploadAction(_ sender: Any) {
     //   view2.isHidden = true
        
       
    }
    
    @IBAction func RemovePdf(_ sender: Any) {
        view2.isHidden = true
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("url here : \(url)")
        print("url here : \(url.pathExtension)")
        print("url here : \(url.pathComponents)")
        print("url here : \(url.path)")
        print("url here : \(url.absoluteString)")
        urlPath = url.path
    }
    
}
