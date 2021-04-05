//
//  VINNumberScannerVC.swift
//  Sell4Bids
//
//  Created by admin on 28/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import AVFoundation



class VINNumber {
    var VinNo : String?
    
    init(VinNo : String) {
        self.VinNo = VinNo
    }
}

class CameraView: UIView  {
    
    override class var layerClass: AnyClass {
        get {
            return AVCaptureVideoPreviewLayer.self
        }
    }
    override var layer: AVCaptureVideoPreviewLayer {
        get {
            return super.layer as! AVCaptureVideoPreviewLayer
        }
    }
}

class VINNumberScannerVC: UIViewController , AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    var captureSession = AVCaptureSession()
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    

    
    
     
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
    
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.default(for: AVMediaType.video)
        
        guard let captureDevice = deviceDiscoverySession else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        
  
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.code39,
             AVMetadataObject.ObjectType.code128,
            AVMetadataObject.ObjectType.qr]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
 
        // Start video capture.
        captureSession.startRunning()
 
        // Move the message label and top bar to the front
        view.bringSubview(toFront: messageLabel)
        
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    
 
   
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.code39 {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
              
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.messageLabel.text = metadataObj.stringValue
                    GlocalVINNO = metadataObj.stringValue
                    let alertview = UIAlertController(title: "Barcode Found", message: metadataObj.stringValue, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok".localizableString(loc: LanguageChangeCode), style: UIAlertActionStyle.cancel, handler: { (cancel) in
                             self.navigationController?.popViewController(animated: true)
                    })
                    alertview.addAction(ok)
                    self.present(alertview, animated: true, completion: nil)
               
                }
               

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

protocol BackButtonActionDelegate {
    func pressFinished(text : VINNumber )
    
    
}
