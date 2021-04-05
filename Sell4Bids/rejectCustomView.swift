//
//  rejectCustomView.swift
//  Sell4Bids
//
//  Created by admin on 12/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class rejectCustomView: UIView, SSRadioButtonControllerDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var btn1: SSRadioButton!
    @IBOutlet weak var btn2: SSRadioButton!
    @IBOutlet weak var btn3: SSRadioButton!
    @IBOutlet weak var btn4: SSRadioButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var continueView: UIView!
    
    //MARK:- Variables
    var radioButtonController: SSRadioButtonsController?
    lazy var selectedBtnTitle = ""
    
    //MARK:- Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        radioButtonController = SSRadioButtonsController(buttons: btn1,btn2, btn3,btn4)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        continueView.shadowView()
        cancelBtn.shadowView()
    }
    
    //MARK:- Radio button Stubs.
    func didSelectButton(selectedButton: UIButton?) {
        let currentButton = radioButtonController?.selectedButton()
        selectedBtnTitle = currentButton?.titleLabel?.text ?? ""
        print(currentButton?.titleLabel?.text ?? "")
       }
}
