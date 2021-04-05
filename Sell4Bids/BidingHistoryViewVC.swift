//
//  BidingHistoryViewVC.swift
//  Sell4Bids
//
//  Created by Admin on 02/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class BidingHistoryViewVC: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var BidingTableView: UITableView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fidgetImgView: UIImageView!
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var navigationView: UIView!
    
    //MARK:- Variables
    var titleview = Bundle.main.loadNibNamed("simpleTopView", owner: self, options: nil)?.first as! simpleTopView
    var biddingArray : biddingHistoryModel?
    var itemId :String?
    var currencySymbol: String?
    
    
    // MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      self.emptyMessage.isHidden = true
      
        getBidingHistoryData()
        SetUpViews()
        self.navigationController?.isToolbarHidden = false
    }
    
    //MARK:- Private functions
    private func SetUpViews() {
        titleview.titleLbl.text = "Bidding History"
        titleview.homeImg.layer.cornerRadius = 6
        titleview.homeImg.layer.masksToBounds = true
        titleview.inviteBtn.addTarget(self, action: #selector(inviteBarBtnTapped(_:)), for: .touchUpInside)
        titleview.backBtn.addTarget(self, action: #selector(homeBtnTapped(sender:)), for: .touchUpInside)
//        self.navigationView.addSubview(titleview)
        self.navigationItem.titleView = titleview
    }
    
    @objc func homeBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
        self.dismiss(animated: true, completion: nil)
    }
    override func viewLayoutMarginsDidChange() {
//        let name = UIDevice.modelName
//        let deviceName = name.replacingOccurrences(of: "Simulator ", with: "")
//        if deviceName == "iPhone X" || deviceName == "iPhone Xs" || deviceName == "iPhone Xs Max" || deviceName == "iPhone XR" || deviceName == "iPhone 11" || deviceName == "iPhone 11 Pro" || deviceName == "iPhone 11 Pro Max"{
//            navigationViewHeight.constant = 70
//            titleview.frame =  CGRect(x:0, y: 0, width: (navigationView.frame.width), height: 40)
//        }else {
//            navigationViewHeight.constant = 50
//            titleview.frame =  CGRect(x:0, y: 20, width: (navigationView.frame.width), height: 40)
//        }
      titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)

    }
    
    private func getBidingHistoryData(){
        let parameter:[String:Any] = ["item_id" : self.itemId ?? "" , "start" : 0 , "limit" : 30]
        Networking.instance.postApiCall(url: biddingHistoryUrl, param: parameter) { (response, Error, StatusCode) in
            guard let jsonDic = response.dictionary else {return}
            let totalCount = jsonDic["totalCount"]?.int ?? 0
            let maxBid = jsonDic["maxBid"]?.string ?? ""
            let status = jsonDic["status"]?.bool ?? false
            
            let winner = jsonDic["winner"]?.string ?? ""
            let msgArray = jsonDic["message"]?.array ?? []
            var userDetailsArray = [userModelForBidding]()
            for item in msgArray {
                guard let msgDic = item.dictionary else {return}
                let itemId = msgDic["item_id"]?.string ?? ""
                let bidAmount = msgDic["bid"]?.string ?? ""
                let userDetailsDic = msgDic["userDetails"]?.dictionary
                let userImg = userDetailsDic?["image"]?.string ?? ""
                let userName = userDetailsDic?["name"]?.string ?? ""
                let userTotalRatings = userDetailsDic?["totalratings"]?.int ?? -1
                let userId = userDetailsDic?["_id"]?.string ?? ""
                let userAverageRating = userDetailsDic?["averagerating"]?.float ?? -1
                let object = userModelForBidding.init(itemId: itemId, bidAmount: bidAmount, userImg: userImg, userName: userName, userTotalRatings: userTotalRatings, userId: userId, userAverageRating: userAverageRating)
                userDetailsArray.append(object)
            }
            self.biddingArray = biddingHistoryModel.init(totalCount: totalCount, maxBid: maxBid, status: status, winner: winner, userDetails: userDetailsArray)
          if (self.biddingArray?.totalCount)!>0{
            self.emptyMessage.isHidden = true
          }else{
            self.emptyMessage.isHidden = false
          }
            self.BidingTableView.isHidden = false
            self.fidgetImgView.isHidden = true
           
            self.BidingTableView.reloadData()
        }
    }
    
    
    func hideBidderName (name : String) ->  String {
        var newName = ""
        for (i, char ) in name.enumerated() {
            newName += String( i == 0 || i == 1 ? char : "*" )
        }
        return newName
    }
    
}

//MARK:- Table View Life cycle.
extension BidingHistoryViewVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return biddingArray?.userDetails.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BidingTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BidingHistoryCellVC
        
        let orderData = biddingArray?.userDetails[indexPath.row]
        cell.bidPrice.text =  "\(self.currencySymbol ?? "")\(orderData?.bidAmount ?? "")"
        cell.bidingUserName.text = hideBidderName(name: orderData?.userName ?? "Sell4Bids")
        var Array = [Int64]()
        for item in biddingArray?.userDetails ?? []{
            let amount = Int64(item.bidAmount ?? "")
            Array.append(amount ?? 0)
        }
        print(Array)
        let BidAmount = Array.max()
        let price = BidAmount
        let checkPrice = Int64(orderData?.bidAmount ?? "")
        if checkPrice == Int64(price ?? 0) {
            cell.seperateLbl.isHidden = false
            cell.lblCeilingAmount.isHidden = false
            cell.lblCeilingAmountStatic.isHidden = false
            cell.ceilingAmountHeight.constant = 30
            cell.celingLblHeight.constant = 30
            cell.bidingCardView.backgroundColor = #colorLiteral(red: 1, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        }else {
            cell.seperateLbl.isHidden = true
            cell.lblCeilingAmount.isHidden = true
            cell.lblCeilingAmountStatic.isHidden = true
            cell.ceilingAmountHeight.constant = 0
            cell.celingLblHeight.constant = 0
            cell.bidingCardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        cell.bidingCardView.shadowView()
        cell.bidingCardView.layer.cornerRadius = 6
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let orderData = biddingArray?.userDetails[indexPath.row]
        
        var Array = [Int64]()
        for item in biddingArray?.userDetails ?? []{
            let amount = Int64(item.bidAmount ?? "")
            Array.append(amount ?? 0)
        }
        print(Array)
        let BidAmount = Array.max()
        let price = BidAmount
        let checkPrice = Int64(orderData?.bidAmount ?? "")
        if checkPrice == price{
            return 80
        }else {
            return 50
        }
        
    }
}
