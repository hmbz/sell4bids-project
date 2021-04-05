//
//  productCollectionViewCell.swift
//  Sell4Bids
//
//  Created by admin on 8/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class productCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Properties
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var buyNowBtn: UIButton!
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet var quantityLbl: UILabel!
    @IBOutlet weak var rejectedLbl: UILabel!
   @IBOutlet weak var cancelOrderBtn: UIButton!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }
    
    //MARK:- Private Function
    private func setupViews() {
        buyNowBtn.shadowView()
        cardView.shadowView()
        itemImage.layer.cornerRadius = 6
        itemImage.layer.masksToBounds = true
        serviceView.layer.cornerRadius = 6
        buyNowBtn.isUserInteractionEnabled = false
        serviceView.layer.cornerRadius = 6
        serviceView.layer.masksToBounds = true
        serviceLbl.layer.cornerRadius = 6
        serviceLbl.layer.masksToBounds = true
        
        // Remove the Shakiness of the Cell...
        
        //.......When the value in the shouldRasterize property is true, the layer uses this property to determine whether to scale the rasterized content (and by how much). The default value of this property is 1.0, which indicates that the layer should be rasterized at its current size. Larger values magnify the content and smaller values shrink it............//
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func getButtonText(product: productModelNew){
        
        let currencySymbol : String?
        if product.currencySymbol != "" {
            currencySymbol = product.currencySymbol
        }else {
            currencySymbol = product.currencyString
        }
        let startPrice = String(format: "%.0f", product.startPrice!)
        let itemPrice = "\(currencySymbol ?? "")\(startPrice)"
        
        // Condition to Show Color
        if product.itemCategory?.lowercased() == "services"{
            self.serviceLbl.isHidden = false
            self.serviceView.isHidden = false
            self.serviceLbl.text = "Services"
            let blueColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            self.serviceView.setGradientBackground(colorOne: UIColor.lightGray, colorTwo: blueColor )
            if product.itemAuctionType == "buy-it-now" {
                buyNowBtn.setTitle("Buy at \(itemPrice)", for: .normal)
            }else if product.itemAuctionType == "reserve" || product.itemAuctionType == "non-reserve"{
                buyNowBtn.setTitle("Bid at \(itemPrice)", for: .normal)
            }
        }
        else if product.itemCategory?.lowercased() == "vehicles"{
            self.serviceLbl.isHidden = true
            self.serviceView.isHidden = true
           if product.itemAuctionType == "buy-it-now" {
                buyNowBtn.setTitle("Buy at \(itemPrice)", for: .normal)
            }else if product.itemAuctionType == "reserve" || product.itemAuctionType == "non-reserve"{
                buyNowBtn.setTitle("Bid at \(itemPrice)", for: .normal)
            }
        }
        else if product.itemCategory?.lowercased() == "jobs" {
            self.serviceLbl.isHidden = true
            self.serviceView.isHidden = true
            buyNowBtn.setTitle("Apply at \(itemPrice)", for: .normal)
        }else {
            self.serviceLbl.isHidden = true
            self.serviceView.isHidden = true
            if product.itemAuctionType == "buy-it-now" {
                buyNowBtn.setTitle("Buy at \(itemPrice)", for: .normal)
            }else if product.itemAuctionType == "reserve" || product.itemAuctionType == "non-reserve"{
                buyNowBtn.setTitle("Bid at \(itemPrice)", for: .normal)
            }else {
                // error
            }
        }
    }
    

    func setupDataIntheCollectionView(product: productModelNew){
        
        // Title Of the Item
        titleLbl.text = product.title
        // Showing Quantity
        let quantity = product.quantity ?? 0
        if quantity > 0 {
            quantityLbl.isHidden = false
            quantityLbl.text = "(\(quantity) Available)"
        }else {
            quantityLbl.isHidden = true
        }
        
        // Showing the Image
        itemImage.sd_setShowActivityIndicatorView(true)
        if product.ImagePathSmall?.count ?? 0 > 0 {
            let image = product.ImagePathSmall?[0]  as? String
            let encodedImage = image?.replacingOccurrences(of: " ", with: "%20")
            itemImage.sd_setImageWithURLWithFade(url: URL(string: encodedImage ?? ""), placeholderImage: #imageLiteral(resourceName: "emptyImage"))
        }else {
            if product.ImagePath?.count ?? 0 > 0 {
                let image = product.ImagePath?[0]  as? String
                let encodedImage = image?.replacingOccurrences(of: " ", with: "%20")
                itemImage.sd_setImageWithURLWithFade(url: URL(string: encodedImage ?? ""), placeholderImage: #imageLiteral(resourceName: "emptyImage"))
            }else {
                // No Image Found
            }
        }
        
        if product.imageInfoArray?.count ?? 0 > 0 {
            self.itemImage.contentMode = .scaleAspectFill
        }else {
            self.itemImage.contentMode = .scaleAspectFit
        }
        
        let timestamp = Date().currentTimeMillis()
        let timeRemaining = (product.endTime! - timestamp)
        
        // Condition to show Button Color
        if product.itemCategory?.lowercased() == "services" || product.itemCategory?.lowercased() == "jobs" {
          if product.endTime == -1{
                      self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                   }
           else if timeRemaining == 0 || timeRemaining < -1 {
                self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }else{
                self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
        }else if  product.itemCategory?.lowercased() == "housing"{
          if product.endTime == -1{
             self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
          }else{
            
          
          if product.itemAuctionType == "buy-it-now" {
               if product.quantity == -1 || product.quantity == nil ||  product.quantity == 0{
                  self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
              }
              else if timeRemaining == 0 || timeRemaining < -1 {
                  self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
               }else {
                   self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
               }
          }
          else if product.itemAuctionType == "reserve" || product.itemAuctionType == "non-reserve" {
              if timeRemaining == -1 || timeRemaining < -1 {
                  self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
              }else{
                  self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
              }
          }else {
              self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
          }
          }
        }
        else if product.itemAuctionType == "buy-it-now" {
             if product.quantity == 0 && product.itemCategory?.lowercased() != "jobs" {
                self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            } else if product.endTime == -1 {
                self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
            else if timeRemaining == 0 || timeRemaining < -1 {
                self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
             }else {
                 self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
             }
        }
        else if product.itemAuctionType == "reserve" || product.itemAuctionType == "non-reserve" {
            if timeRemaining == 0 || timeRemaining < -1 {
                self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }else{
                self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
        }else {
            self.buyNowBtn.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
}
