//
//  ShowResumeVC.swift
//  Sell4Bids
//
//  Created by Admin on 09/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ShowResumeVC: UIViewController, UITextViewDelegate {
    
    //MARK:- Properties.
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var professionalSummaryTextView: UITextView!
    @IBOutlet weak var experienceLbl: UILabel!
    
//    @IBOutlet weak var jobCategoryLbl: UILabel!
    @IBOutlet weak var currentSalaryAmountLbl: UILabel!
    @IBOutlet weak var expectedSalaryLbl: UILabel!
    @IBOutlet weak var applicantEmailLbl: UILabel!
    @IBOutlet weak var applicantContactNumberLbl: UILabel!
    
//    @IBOutlet weak var resumeLbl: UILabel!
    @IBOutlet weak var shortlistButtonLbl: ButtonShahdow!
    @IBOutlet weak var rejectedButtonLbl: ButtonShahdow!
    @IBOutlet weak var summaryLblHeight: NSLayoutConstraint!
    @IBOutlet weak var personImg: UIImageView!
    @IBOutlet weak var personImgHeight: NSLayoutConstraint!
    @IBOutlet weak var openResumeBtn: UIButton!
    
    
    //MARK:- Variable.
    var getModelData : GetJobModel?
    lazy var MainAPi = MainSell4BidsApi()
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
        ShowData()
        setupViews()
       
    }
    
    //MARK:- Functions
    private func adjustUITextViewHeight(arg : UITextView){
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    private func ShowData() {
        userNameLbl.text = getModelData!.jobSeekerName
        professionalSummaryTextView.text = getModelData!.professionalSummary
        experienceLbl.text = getModelData!.experience
        currentSalaryAmountLbl.text = "$" + getModelData!.currentSalary
        expectedSalaryLbl.text = "$" + getModelData!.expectedSalary
        applicantEmailLbl.text = getModelData!.jobSeekerEmail
        applicantContactNumberLbl.text = getModelData!.contactNo
        applicantEmailLbl.text = getModelData!.jobSeekerEmail
        personImg.sd_setImage(with: URL(string: getModelData!.image), placeholderImage: UIImage(named:"Profile-image-for-sell4bids-App-1"))
        let check = getModelData?.status
        print(check!)
        if check == "Accepted" {
            shortlistButtonLbl.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            shortlistButtonLbl.isUserInteractionEnabled = false
            rejectedButtonLbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            rejectedButtonLbl.isUserInteractionEnabled = true
            rejectedButtonLbl.addTarget(self, action: #selector(rejectBtnTapped(sender:)), for: .touchUpInside)
        }else if check == "Rejected" {
            shortlistButtonLbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            shortlistButtonLbl.isUserInteractionEnabled = true
            rejectedButtonLbl.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            rejectedButtonLbl.isUserInteractionEnabled = false
            shortlistButtonLbl.addTarget(self, action: #selector(AcceptBtnTapped(sender:)), for: .touchUpInside)
        }else {
            shortlistButtonLbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            shortlistButtonLbl.isUserInteractionEnabled = true
            rejectedButtonLbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            rejectedButtonLbl.isUserInteractionEnabled = true
            rejectedButtonLbl.addTarget(self, action: #selector(rejectBtnTapped(sender:)), for: .touchUpInside)
            shortlistButtonLbl.addTarget(self, action: #selector(AcceptBtnTapped(sender:)), for: .touchUpInside)
        }
        
        
    }
    
    private func setupViews() {
        professionalSummaryTextView.delegate = self
        adjustUITextViewHeight(arg: professionalSummaryTextView)
        openResumeBtn.addBorderWithColorAndWidth()
        shortlistButtonLbl.shadowView()
        rejectedButtonLbl.shadowView()
        openResumeBtn.addTarget(self, action: #selector(openResumeBtnTapped(sender:)), for: .touchUpInside)
        personImg.layer.masksToBounds = true
        personImg.layer.borderWidth = 1.5
        personImg.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        personImg.layer.cornerRadius = personImg.bounds.width / 2
//        rejectedButtonLbl.addTarget(self, action: #selector(rejectBtnTapped(sender:)), for: .touchUpInside)
//        shortlistButtonLbl.addTarget(self, action: #selector(AcceptBtnTapped(sender:)), for: .touchUpInside)
    
        
    }
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Resume"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        
        self.navigationItem.hidesBackButton = true
    }
    
    //MARK:-  Actions
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        
    }
    
    @objc func openResumeBtnTapped(sender: UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "pdfViewController") as! pdfViewController
        vc.value = getModelData!.documentURL
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func rejectBtnTapped(sender: UIButton) {
        let alert = UIAlertController(title: "Reject", message: "Do you want to reject this applicant?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            let jobid = self.getModelData?.userID
            self.RejectApiCall(jobId: jobid!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func AcceptBtnTapped(sender: UIButton) {
        let alert = UIAlertController(title: "Accept", message: "Do you want to Shortlist this applicant?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            let jobid = self.getModelData?.userID
            self.AcceptApiCall(jobId: jobid!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Network Call Function
    
    private func RejectApiCall(jobId : String){
        let URL = MainAPi.IP + MainAPi.JobRejected
        
        let body:[String:Any] = ["job_id": jobId]
        MainAPi.postApiCall(URL: URL, param: body) { (success) in
            if success{
                let status = self.MainAPi.status
                if status == 200{
                    print("200")
                    let message = self.MainAPi.message
                    print(message)
                    showSwiftMessageWithParams(theme: .success, title: "Job Application", body: message, durationSecs: Int(2.0), layout: .messageView, position: .center, completion: { (status) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                else{
                    print("Error")
                    
                }
            }
            else{
                let status = self.MainAPi.status
                print(status)
            }
        }
    }
    
    private func AcceptApiCall(jobId : String){
        let URL = MainAPi.IP + MainAPi.JobShortlistedCandidate
        
        let body:[String:Any] = ["job_id": jobId]
        MainAPi.postApiCall(URL: URL, param: body) { (success) in
            if success{
                let status = self.MainAPi.status
                if status == 200{
                    print("200")
                    let message = self.MainAPi.message
                    showSwiftMessageWithParams(theme: .success, title: "Job Application", body: message, durationSecs: Int(2.0), layout: .messageView, position: .center, completion: { (status) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                else{
                    print("Error")
                    
                }
            }
            else{
                let status = self.MainAPi.status
                print(status)
            }
        }
    }
    
    
}

