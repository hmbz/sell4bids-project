//
//  HeaderView.swift
//  Sell4Bids
//
//  Created by admin on 12/26/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var containerView: UIView!
    var collectionView: UICollectionView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var cityNameAndStateNameLabel: UILabel!
    @IBOutlet weak var resetLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 117)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 20, height: 100), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = true
//        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    
}
