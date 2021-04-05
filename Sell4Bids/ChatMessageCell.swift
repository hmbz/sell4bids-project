//
//  ChatMessageCell.swift
//  GroupedMessagesLBTA
//
//  Created by Brian Voong on 8/25/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    let timeLabel = UILabel()
    let imagetick = UIImageView()
    let refreshbutton = UIButton()
    let namelabel = UILabel()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var leadingConstraintLabel : NSLayoutConstraint!
    var isIncoming = Bool()

    func Autoset () {
        print("isincoming \(isIncoming)")
        if isIncoming {
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
            leadingConstraintLabel.isActive = true
        } else {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            leadingConstraintLabel.isActive = true
        }
         bubbleBackgroundView.backgroundColor = isIncoming ? UIColor(red: 231/256, green: 229/256, blue: 237/256, alpha: 1.0) : UIColor(red: 0/256, green: 137/256, blue: 249/256, alpha: 1.0)
        messageLabel.textColor = isIncoming ? .black : .white
        timeLabel.textColor = isIncoming ? .black : .white
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        bubbleBackgroundView.backgroundColor = .yellow
        bubbleBackgroundView.layer.cornerRadius = 25
        bubbleBackgroundView.addShadowAndRoundChat()
        bubbleBackgroundView.layoutMargins = .init(top: 10, left: 10, bottom: 25, right: 10)
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        imagetick.translatesAutoresizingMaskIntoConstraints = false
        refreshbutton.translatesAutoresizingMaskIntoConstraints = false
       
        //12
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        namelabel.font = UIFont.systemFont(ofSize: 12)
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        
      
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        addSubview(namelabel)
        addSubview(timeLabel)
        addSubview(imagetick)
        addSubview(refreshbutton)
        
        // lets set up some constraints for our label
        let constraints = [
           
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 180),
            messageLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 19),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            
            namelabel.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: -13),

            timeLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -5),
            timeLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -22),
            imagetick.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -5),
            imagetick.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -5),
            refreshbutton.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -19),
            refreshbutton.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -5),
                        ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        leadingConstraintLabel = namelabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIScreen.main.bounds.width/2 - 45)
        leadingConstraintLabel.isActive = false

        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
        trailingConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}







