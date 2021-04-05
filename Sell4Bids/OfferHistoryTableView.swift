//
//  OfferHistoryTableView.swift
//  Sell4Bids
//
//  Created by admin on 30/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class OfferHistoryTableView: UIViewController , UITableViewDelegate , UITableViewDataSource {
  
    var OfferHistory :  OfferModel?
    
    var currenttime = Int64()
    var MainApi = MainSell4BidsApi()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OfferHistory!.offers!.count
    }
    
    
    func TimeStempDateConversion(value:String)->String{
        
        let dd = Double(value)
        let datedd = dd!/1000
        let date = Date(timeIntervalSince1970: datedd )
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/YYYY hh:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        print("timetext1 = \(strDate)")
        return strDate
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabView.dequeueReusableCell(withIdentifier: "Id123", for: indexPath) as! ChatMessageCell
        
        print("data  == \(OfferHistory!.offers![indexPath.row].message)")
       cell.selectionStyle = UITableViewCellSelectionStyle.none
       cell.Autoset()
        if OfferHistory!.offers![indexPath.row].role == "buyer" {
            cell.isIncoming = true
            cell.messageLabel.text = OfferHistory!.offers![indexPath.row].message
            func handleTimeSender() {
                
                let time = Int64(OfferHistory!.offers![indexPath.row].time)
                let f = Date(milliseconds: Int(time))
                let currentTime = self.currenttime
                let difference = Int64(currentTime) - time
                
                let a = "\(f)"
                var m  = a.components(separatedBy: " ")
                var n = m[1].components(separatedBy: ":")
                let thisIsRecivedMessage = self.OfferHistory!.offers![indexPath.row].role == "buyer"
                
                let timeText = "\(n[0])"+":"+"\(n[1])"
                
                   cell.timeLabel.text = timeText
//                cell.timeLabel.text = TimeStempDateConversion(value: self.OfferHistory[indexPath.row].time)
                print("timetext = \(timeText)")
                
            }
            
            handleTimeSender()
            
        }else {
            
            cell.isIncoming = false
            cell.messageLabel.text = OfferHistory!.offers![indexPath.row].message
            func handleTimeSender() {
                
                let time = Int64(OfferHistory!.offers![indexPath.row].time)
                let f = Date(milliseconds: Int(time))
                let currentTime = self.currenttime
                let difference = Int64(currentTime) - time
                
                let a = "\(f)"
                var m  = a.components(separatedBy: " ")
                var n = m[1].components(separatedBy: ":")
                let thisIsRecivedMessage = self.OfferHistory!.offers![indexPath.row].role == "seller"
                
                let timeText = "\(n[0])"+":"+"\(n[1])"
                
                cell.timeLabel.text = timeText
                //                cell.timeLabel.text = TimeStempDateConversion(value: self.OfferHistory[indexPath.row].time)
                print("timetext = \(timeText)")
                
            }
            
            handleTimeSender()
            
        }
        
         cell.Autoset()
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    @IBOutlet weak var tabView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MainApi.ServerTime { (status, data, error) in
            
            if status {
                let currenttime = data!["time"].int64Value
                self.currenttime = currenttime
            }
        }
        // Do any additional setup after loading the view.
        tabView.delegate = self
        tabView.dataSource = self
        
        tabView.register(ChatMessageCell.self, forCellReuseIdentifier: "Id123")
        tabView.separatorStyle = .none
        tabView.reloadData()

        
        
        
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
