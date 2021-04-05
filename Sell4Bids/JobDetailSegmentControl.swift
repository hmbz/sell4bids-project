//
//  JobDetailSegmentControl.swift
//  Sell4Bids
//
//  Created by Admin on 03/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class JobDetailSegmentControl: UIViewController {
    
    
    //MARK:- Properties
    @IBOutlet weak var Change_View: UISegmentedControl!
    @IBOutlet weak var appTableView: UITableView!
    @IBOutlet weak var noItemFoundImage: UIImageView!
    @IBOutlet weak var fidgetSpinner: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    //MARK:- Variable
    lazy var MainAPi = MainSell4BidsApi()
    lazy var allJobArray = [GetJobModel]()
    lazy var shortListArray = [GetJobModel]()
    lazy var rejectedArray = [GetJobModel]()
    lazy var itemId = ""
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        allJobArray.removeAll()
        shortListArray.removeAll()
        rejectedArray.removeAll()
        segmentControl.selectedSegmentIndex = 0
        self.appTableView.tag = 0
        getViewAllJobOfApplyDetails()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        allJobArray.removeAll()
        shortListArray.removeAll()
        rejectedArray.removeAll()
        appTableView.reloadData()
    }
    
    //MARK:- Top Bar Setting
    // setting variable for top bar View
    lazy var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    
    // top bar function
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.titleLbl.text = "Job Application"
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
        
    }
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    // going back directly towards the home
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")

    }
    
    
    
    override func viewLayoutMarginsDidChange() {
//        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
        print("titleview width = \(titleview.frame.width)")
    }
    

    
    //MARK:- Actions
    
    @IBAction func Segment_Value(_ sender: UISegmentedControl){
        let getIndex = segmentControl.selectedSegmentIndex
        print(getIndex)
        switch getIndex {
        case 0:
            print("All")
            appTableView.tag = 0
            allJobArray.removeAll()
            shortListArray.removeAll()
            rejectedArray.removeAll()
            appTableView.reloadData()
            getViewAllJobOfApplyDetails()
        case 1 :
            print("ShortList")
           appTableView.tag = 1
            allJobArray.removeAll()
            shortListArray.removeAll()
            rejectedArray.removeAll()
            appTableView.reloadData()
//            getShortlistData()
             getViewAllJobOfApplyDetails()
            
        case 2:
            print("Rejected")
            appTableView.tag = 2
            allJobArray.removeAll()
            shortListArray.removeAll()
            rejectedArray.removeAll()
            appTableView.reloadData()
//            getRejectedData()
            getViewAllJobOfApplyDetails()
           
        default:
            print("No Index")
        }
        
 
    }
 
    private func getViewAllJobOfApplyDetails(){
        self.fidgetSpinner.toggleRotateAndDisplayGif()
        Spinner.load_Spinner(image: self.fidgetSpinner, view: self.shadowView)
        print("ViewApplications Api is Here")
        MainAPi.View_Applications(item_id: itemId, seller_uid: SessionManager.shared.userId, start: 0 , limit: 10) { (status, data, error) in
            if status == true {
                Spinner.stop_Spinner(image: self.fidgetSpinner, view: self.shadowView)
                self.allJobArray.removeAll()
                let message = data!["message"]
                print("message = \(message)")
                self.noItemFoundImage.isHidden = false
                if message.count > 0 {
                    for msg in message{
                        let userID = msg.1["_id"].stringValue
                        let name = msg.1["name"].stringValue
                        let experience = msg.1["jobExperience"].stringValue
                        let currentSalary = msg.1["currentSalary"].stringValue
                        let expectedSalary = msg.1["expectedSalary"].stringValue
                        let item_id = msg.1["item_id"].stringValue
                        let professionalSummary = msg.1["professionalSummary"].stringValue
                        let contactNo = msg.1["contactNo"].stringValue
                        let jobSeekerEmail = msg.1["jobSeekerEmail"].stringValue
                        let jobSeekerName = msg.1["jobSeekerName"].stringValue
                        let jobCategory = msg.1["jobCategory"].stringValue
                        let jobSeekerUid = msg.1["jobSeekerUid"].stringValue
                        let status = msg.1["status"].stringValue
                        let documentURL = msg.1["documentURL"].stringValue
                        
                        let user = msg.1["users"]
                        var img = String()
                        for usr in user{
                            img = usr.1["image"].stringValue
                        }
                        let getJobItems = GetJobModel.init(name: name, userid: userID, image: img, experience: experience, currentSalary: currentSalary, expectedSalary: expectedSalary, item_id: item_id, professionalSummary: professionalSummary, contactNo: contactNo, jobSeekerEmail: jobSeekerEmail, jobSeekerName: jobSeekerName, jobCategory: jobCategory, jobSeekerUid: jobSeekerUid, status: status, documentURL: documentURL)
//                        print("\(getJobItems.documentURL)")
                        if status == "Accepted" {
                            self.shortListArray.append(getJobItems)
                        }
                        else if status == "Rejected" {
                            self.rejectedArray.append(getJobItems)
                        }
                        self.allJobArray.append(getJobItems)
                        
                        
                        print("getjobdata = \(self.allJobArray.count)")
                        self.appTableView.reloadData()
                        self.noItemFoundImage.isHidden = true
                    
                    }
                    
                }else{
                    print("No Data found")
                }
            }else{
                
            }
            
            if error.contains("The network connection was lost"){
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetSpinner)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            if error.contains("The Internet connection appears to be offline.") {
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                fidget.stopfiget(fidgetView: self.fidgetSpinner)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            if error.contains("A server with the specified hostname could not be found."){
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetSpinner)
                
                self.present(alert, animated: true, completion: nil)
            }
            
            if error.contains("The request timed out.") {
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetSpinner)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
}
//MARK:- Table View Life cycle.
extension JobDetailSegmentControl: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appTableView.tag == 0 {
            return allJobArray.count
        }else if appTableView.tag == 1 {
             return shortListArray.count
        }else if appTableView.tag == 2 {
             return rejectedArray.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = appTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! jobAppTabViewCell
        
        
        if appTableView.tag == 0 {
            let UsersInfo = allJobArray[indexPath.row]
            cell.itemLbl.text = UsersInfo.jobSeekerName
            cell.experienceLbl.text = UsersInfo.experience
            cell.salaryLbl.text = "$" + UsersInfo.currentSalary
            cell.ItemImage.sd_setImage(with: URL(string: UsersInfo.image), placeholderImage: UIImage(named:"Profile-image-for-sell4bids-App-1"))
        }else if appTableView.tag == 1 {
            let UsersInfo = shortListArray[indexPath.row]
            cell.itemLbl.text = UsersInfo.jobSeekerName
            cell.experienceLbl.text = UsersInfo.experience
            cell.salaryLbl.text = "$" + UsersInfo.currentSalary
            cell.ItemImage.sd_setImage(with: URL(string: UsersInfo.image), placeholderImage: UIImage(named:"Profile-image-for-sell4bids-App-1"))
        }else {
            let UsersInfo = rejectedArray[indexPath.row]
            cell.itemLbl.text = UsersInfo.jobSeekerName
            cell.experienceLbl.text = UsersInfo.experience
            cell.salaryLbl.text = "$" + UsersInfo.currentSalary
            cell.ItemImage.sd_setImage(with: URL(string: UsersInfo.image), placeholderImage: UIImage(named:"Profile-image-for-sell4bids-App-1"))
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if appTableView.tag == 0 {
            let UsersInfo = allJobArray[indexPath.row]
            let vc = storyboard?.instantiateViewController(withIdentifier: "ShowResumeVC-identifier") as! ShowResumeVC
            vc.getModelData = UsersInfo
            self.navigationController?.pushViewController(vc, animated: true)
           
        }else if appTableView.tag == 1 {
            let UsersInfo = shortListArray[indexPath.row]
            let vc = storyboard?.instantiateViewController(withIdentifier: "ShowResumeVC-identifier") as! ShowResumeVC
            vc.getModelData = UsersInfo
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else {
            let UsersInfo = rejectedArray[indexPath.row]
            let vc = storyboard?.instantiateViewController(withIdentifier: "ShowResumeVC-identifier") as! ShowResumeVC
            vc.getModelData = UsersInfo
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
}
