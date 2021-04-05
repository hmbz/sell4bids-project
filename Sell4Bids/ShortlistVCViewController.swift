//
//  ShortlistVCViewController.swift
//  Sell4Bids
//
//  Created by Admin on 03/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ShortlistVCViewController: UIViewController {
    
    @IBOutlet weak var DimView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var Errorimg: UIImageView!
    
    var ProductDetails = [JobDetails]()
    var MainAPi = MainSell4BidsApi()
    var products_Details : JobDetails?
    var getJOBMOdel = [GetJobModel]()
    var nav:UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Osama Mansoori == 2")
        self.getJOBMOdel.removeAll()
        tableView.delegate = self
        tableView.dataSource = self
        fidgetImageView.toggleRotateAndDisplayGif()
        getShortlistData()
        
    }
    
    func getShortlistData(){
        
        
        Spinner.load_Spinner(image: self.fidgetImageView, view: self.DimView)
        print("Shortlist Api is Here")
        MainAPi.Job_CV_Shortlist_Api(job_id: "5ca30cc8e9c27efa0e73c5cf") { (status, data, error) in
            
            if status == true {
                self.getJOBMOdel.removeAll()
                Spinner.stop_Spinner(image: self.fidgetImageView, view: self.DimView)
                
                let message = data!["message"]
                print("message = \(message)")
                if message.count > 0 {
                    
                    
                    for msg in message{
                        
                        let userID = msg.1["_id"].stringValue
                        let name = msg.1["name"].stringValue
                        let experience = msg.1["experience"].stringValue
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
                        
                        
                        self.getJOBMOdel.append(getJobItems)
                        print("getjobdata = \(self.getJOBMOdel.count)")
                        self.tableView.reloadData()
                    }
                    
                }else{
                    
                    //self.hideCollectionView(hideYesNo: true)
                    
                }
            }else{
                
            }
            
            if error.contains("The network connection was lost"){
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            if error.contains("The Internet connection appears to be offline.") {
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            if error.contains("A server with the specified hostname could not be found."){
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                
                self.present(alert, animated: true, completion: nil)
            }
            
            if error.contains("The request timed out.") {
                
                let alert = UIAlertController.init(title: "Network Error".localizableString(loc: LanguageChangeCode), message: "Opps Network Error".localizableString(loc: LanguageChangeCode), preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok".localizableString(loc: LanguageChangeCode), style: .cancel, handler: nil)
                alert.addAction(ok)
                fidget.stopfiget(fidgetView: self.fidgetImageView)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
}


extension ShortlistVCViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getJOBMOdel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard getJOBMOdel.count > 0 else {
            print("getJob array count is 0")
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Shortlist_RejectCell
        let UsersInfo = getJOBMOdel[indexPath.row]
        cell.ShortlistUserNameLbl.text = UsersInfo.jobSeekerName
        cell.YearsLbl.text = UsersInfo.experience
        cell.CurrentSalaryPriceLbl.text = UsersInfo.currentSalary
        cell.ShortlistuserImage.sd_setImage(with: URL(string: UsersInfo.image), placeholderImage: UIImage(named:"emptyImage"))
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.updateUIForFollower()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectUser = getJOBMOdel[indexPath.row]
        
        let ShortlistResume =  UIStoryBoardJob_Detail2.instantiateViewController(withIdentifier: "ShortlistResumeVC-identifier") as! ShortlistResumeVC
        
        ShortlistResume.getModelData = selectUser
        
        present(ShortlistResume, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
        
    }
    
}

