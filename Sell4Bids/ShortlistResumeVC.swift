//
//  ShortlistResumeVC.swift
//  Sell4Bids
//
//  Created by Admin on 10/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ShortlistResumeVC: UIViewController {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var professionalSummaryTextView: UITextView!
    @IBOutlet weak var experienceLbl: UILabel!
    @IBOutlet weak var jobCategoryLbl: UILabel!
    @IBOutlet weak var currencySymbolLbl: UILabel!
    @IBOutlet weak var currentSalaryAmountLbl: UILabel!
    @IBOutlet weak var expectedSalaryLbl: UILabel!
    @IBOutlet weak var expectedSalaryCurrencySignLbl: UILabel!
    @IBOutlet weak var applicantEmailLbl: UILabel!
    @IBOutlet weak var applicantContactNumberLbl: UILabel!
    @IBOutlet weak var resumeLbl: UILabel!
    @IBOutlet weak var shortlistButtonLbl: ButtonShahdow!
    @IBOutlet weak var rejectedButtonLbl: ButtonShahdow!
    @IBOutlet weak var navigation: UINavigationBar!
    var getModelData : GetJobModel?
    
    @IBOutlet weak var userNameStackView: UIStackView!
    @IBOutlet weak var professionalSummaryStackView: UIStackView!
    @IBOutlet weak var resumeDetailsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shortlistButtonLbl.isHidden = true
        navigation.barTintColor = UIColor.black
        navigation.addShadowAndRound()
        userNameStackView.addShadowAndRound()
        professionalSummaryStackView.addShadowAndRound()
        resumeDetailsStackView.addShadowAndRound()
        
        userNameLbl.text = getModelData!.jobSeekerName
        professionalSummaryTextView.text = getModelData!.professionalSummary
        experienceLbl.text = getModelData!.experience
        currentSalaryAmountLbl.text = getModelData!.currentSalary
        jobCategoryLbl.text = getModelData!.jobCategory
        expectedSalaryLbl.text = getModelData!.expectedSalary
        applicantEmailLbl.text = getModelData!.jobSeekerEmail
        applicantContactNumberLbl.text = getModelData!.contactNo
        resumeLbl.text = getModelData!.documentURL
        applicantEmailLbl.text = getModelData!.jobSeekerEmail
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
