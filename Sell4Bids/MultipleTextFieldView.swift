//
//  MultipleTextFieldView.swift
//  Sell4Bids
//
//  Created by admin on 11/25/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MultipleTextFieldView: UIView, UITextFieldDelegate{

    //MARK:- Properties and Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var priceTextFieldLbl: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceTextFieldBottomLine: UILabel!
    @IBOutlet weak var quantitltTextFieldLbl: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var quantityTextFieldBottomLine: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    
    // UIView Life Cycle
    override func awakeFromNib() {
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 6
        layer.masksToBounds = true
        //...................
        quantityTextField.delegate = self
        priceTextField.delegate = self
        // Cross button functionality
        sendBtn.shadowView()
        crossBtn.shadowView()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == priceTextField {
           priceTextFieldBottomLine.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }else {
           quantityTextFieldBottomLine.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == priceTextField {
           priceTextFieldBottomLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else {
           quantityTextFieldBottomLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

}
