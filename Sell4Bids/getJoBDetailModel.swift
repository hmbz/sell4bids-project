//
//  getJoBDetailModel.swift
//  Sell4Bids
//
//  Created by Admin on 04/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class GetJobModel{
    var Name = String()
    var userID = String()
    var image = String()
    var experience = String()
    var currentSalary = String()
    var expectedSalary = String()
    var item_id = String()
    var professionalSummary = String()
    var contactNo = String()
    var jobSeekerEmail = String()
    var jobSeekerName = String()
    var jobCategory = String()
    var jobSeekerUid = String()
    var status = String()
    var documentURL = String()
    
    
    init(name : String , userid : String , image : String, experience : String , currentSalary : String , expectedSalary : String , item_id : String , professionalSummary : String, contactNo : String , jobSeekerEmail : String , jobSeekerName : String , jobCategory : String , jobSeekerUid : String, status : String , documentURL : String) {
        
        
        self.Name = name
        self.userID = userid
        self.image = image
        self.experience = experience
        self.currentSalary = currentSalary
        self.expectedSalary = expectedSalary
        self.item_id = item_id
        self.professionalSummary = professionalSummary
        self.contactNo = contactNo
        self.jobSeekerEmail = jobSeekerEmail
        self.jobSeekerName = jobSeekerName
        self.jobCategory = jobCategory
        self.jobSeekerUid = jobSeekerUid
        self.status = status
        self.documentURL = documentURL
        
    }
}
