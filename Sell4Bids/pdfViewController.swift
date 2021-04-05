//
//  pdfViewController.swift
//  Sell4Bids
//
//  Created by admin on 6/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Alamofire
import PDFKit

class pdfViewController: UIViewController {
    //MARK:- Properties
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var downloadBtn: UIButton!
    
    //MARK:- Variable
     var value = ""
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadBtn.addTarget(self, action: #selector(downloadBtnTapped(sender:)), for: .touchUpInside)
        
        let pdf = value.replacingOccurrences(of: " ", with: "%20")
        let url = URL (string: pdf)
        if url != URL (string: "") {
            let requestObj = URLRequest(url: url!)
            webView.loadRequest(requestObj)
        }else {
            showSwiftMessageWithParams(theme: .info, title: "PDF", body: "No PDF Found")
        }
        
    }
    
    @objc func downloadBtnTapped(sender: UIButton) {
        print("Dowloading")
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let uuid = NSUUID().uuidString
            print(uuid)
            documentsURL.appendPathComponent("\(uuid).pdf")
            return (documentsURL, [.removePreviousFile])
        }
        let url = "\(value)"
        Alamofire.download(url, to: destination).responseData { response in
            if let destinationUrl = response.destinationURL {
                print("destinationUrl \(destinationUrl.absoluteURL)")
//                self.view.makeToast("\(destinationUrl.absoluteURL)")
                showSwiftMessageWithParams(theme: .success, title: "Pdf", body: "\(destinationUrl.absoluteURL)", durationSecs: 10, layout: .messageView, position: .center, completion: { (completion) in
                })
            }
        }
    }

    

  

}
