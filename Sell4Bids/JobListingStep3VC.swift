//
//  JobListingStep3VC.swift
//  Sell4Bids
//
//  Created by Admin on 07/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class JobListingStep3VC: UIViewController {
    
    
    var JobDurationAndOffersVC = UIViewController()
    var JobSalaryStepVC = UIViewController()
    @IBOutlet weak var jobSalaryView: UIView!
    @IBOutlet weak var jobDurationAndOffersView: UIView!
    
    var Storyboard = UIStoryboard.init(name: "JobListing", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let  JobDurationAndOffers = Storyboard.instantiateViewController(withIdentifier: "JobSalary")
        Storyboard.instantiateViewController(withIdentifier: "JobDuration&Offers")
        jobSalaryView.frame = JobDurationAndOffers.view.frame
        jobSalaryView.addSubview(JobDurationAndOffers.view)
        jobDurationAndOffersView.frame = JobDurationAndOffers.view.frame
    jobDurationAndOffersView.addSubview(JobDurationAndOffers.view)
    }
}

