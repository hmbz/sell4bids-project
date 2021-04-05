//
//  VehcilesDetailsVC.swift
//  Sell4Bids
//
//  Created by admin on 29/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


class VehcilesDetailsVC: UIViewController ,UITableViewDelegate , UITableViewDataSource{

    
    
    
    
    
    var VehiclesDetailsHeading = [String]()
    var VehiclesDeailsText = [String]()
    
    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.TableView.delegate = self
        self.TableView.dataSource = self
        self.TableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VehiclesDetailsHeading.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "VCell", for: indexPath) as! VehcilesDetailsCell
        cell.VehiclesHeading.text = self.VehiclesDetailsHeading[indexPath.row]
        cell.VehiclesText.text = self.VehiclesDeailsText[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.modelName.contains("iPhone") {
            return 70
        }else {
            return 90
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
