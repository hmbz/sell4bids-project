//
//  CameraOwnViewController.swift
//  Sell4Bids
//
//  Created by admin on 12/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVFoundation



class CameraOwnViewController: UIViewController,  UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
  
    

    @IBOutlet weak var ImageView: UIImageView!
      var ImageDelegate : getImageDelegate?
    @IBOutlet weak var ActivityLoading: UIActivityIndicatorView!
    var CameraController = UIImagePickerController()
    var delegate : getImageDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Loading Camera"
        CameraController.delegate = self
        CameraController.sourceType = .camera
        self.present(CameraController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
}
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("called camera")
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            
            print("No image found")
            return
        }
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
        self.ImageView.image = image
        self.delegate?.getCapturedImg(img: image)
        
        
        self.title = "Captured Image"
     
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
       
            self.dismiss(animated: false, completion: nil)
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

protocol getImageDelegate : class {
    func getCapturedImg(img : UIImage)
}
