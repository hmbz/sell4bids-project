//
//  SelectItemCategory.swift
//  Sell4Bids
//
//  Created by Admin on 25/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class SelectItemCategory: UITableViewController {
    
    var isJob = false
    var flagFilteringResults = false
    var filteredCategories :[String] = []
    var filteredJobs :[String] = []
    var selectCategory = String()
    weak var delegate : SelectItemCategoryVCDelegate?
    @IBOutlet weak var searchBarFilterCategories: UISearchBar!
    
    var itemsCategory: [String] = ["Accessories","Antiques", "Arts and                               Crafts", "Baby and Kids", "Bags",
                                 "Boats and Marines","Books","Business Equipment","Campers and RVs","Cars and Accessories",
                                 "CDs and DVDs","Clothing","Collectible Toys","Computers and Accessories","Costumes",
                                 "Coupons", "Electronics","Exercise","Fashion", "Free and Donations",
                                 "Furniture","Gadgets","Games","Halloween","Hobbies",
                                 "Home Decor","Home and Garden","Household Appliances", "Jewelry", "Kids Toys",
                                 "Makeup and Beauty","Motorcycles and Accessories","Musical Equipment","Outdoor and Camping","Pet & Animals","Pet Accessories",
                                 "Tickets","Tools","Phone and Tablets","Shoes","Sports Equipment",
                                 "Video Games","Wallets","Watches","Wedding","Others"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if flagFilteringResults {
            return filteredJobs.count
        }else {
            return itemsCategory.count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath) //as! TableViewCell
        
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cell.textLabel?.textColor = UIColor.darkGray
        
        if flagFilteringResults {
            cell.textLabel?.text = filteredJobs[indexPath.row]
        }else {
            cell.textLabel?.text = itemsCategory[indexPath.row]
        }
        
        return cell
    }
    
    // Changes by Osama Mansoori
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if flagFilteringResults {
            
            selectCategory = filteredJobs[indexPath.row]
            let controller = self.presentingViewController as! ItemListingTwoVC
            controller.SelectCategoryName.setTitle(selectCategory, for: .normal)
            
            self.presentingViewController?.dismiss(animated: false, completion: nil)
            
        }else {
            selectCategory = itemsCategory[indexPath.row]
            let controller = self.presentingViewController as! ItemListingTwoVC
            controller.SelectCategoryName.setTitle(selectCategory, for: .normal)
            
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
       
        
        //    if isJob {
        //      var jobType = ""
        //
        //      if flagFilteringResults {
        //        jobType = filteredJobs[indexPath.row]
        //      }else {
        //        jobType = jobCategory[indexPath.row]
        //      }
        //      delegate?.categorySelected(catName: jobType)
        //      dismiss(animated: true, completion: nil)
        //    }
        
        //    else {
        //      var catName = ""
        //      if flagFilteringResults {
        //        catName = filteredCategories[indexPath.row]
        //      }else { catName = categoriesArray[indexPath.row ]}
        //      delegate?.categorySelected(catName: catName)
        //      dismiss(animated: true, completion: nil)
        //    }
        // self.navigationController?.popViewController(animated: false)
        
    }
    
}
protocol SelectItemCategoryVCDelegate : class {
    func categorySelected(catName: String)
}
extension SelectItemCategory : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            flagFilteringResults = false
            
        }else {
            if !flagFilteringResults { flagFilteringResults = true }
            
            filteredJobs = itemsCategory.filter({ (aJob) -> Bool in
                return aJob.lowercased().contains(searchText.lowercased())
            })
            
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

