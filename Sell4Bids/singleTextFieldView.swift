//
//  singleTextFieldView.swift
//  Sell4Bids
//
//  Created by admin on 11/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class singleTextFieldView: UIView, UITextFieldDelegate{

    //MARK:- Properties and Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var textFieldTitleLbl: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var quantityTextFieldBottomLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var appIconHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLblHeight: NSLayoutConstraint!
    
    // UIView Life Cycle
    override func awakeFromNib() {
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
        
        firstTextField.delegate = self
        
        // Cross button functionality
        sendBtn.shadowView()
        crossBtn.shadowView()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        quantityTextFieldBottomLbl.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        quantityTextFieldBottomLbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

}
