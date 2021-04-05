//
//  SwiftMessages.swift
//  Sell4Bids
//
//  Created by admin on 3/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import SwiftMessages


///swift message with icon, title, text and an OK button
//func showSwiftMessageWithParams(theme: Theme , title: String, body: String, durationSecs: Int = 7, layout: MessageView.Layout = MessageView.Layout.cardView, position: SwiftMessages.PresentationStyle = SwiftMessages.PresentationStyle.center,  completion: @escaping (Bool) -> () = { _ in } ) {
//
//  let messageView = MessageView.viewFromNib(layout: layout)
//
//
//    var config = SwiftMessages.Config()
//    config.ignoreDuplicates = true
//  config.presentationStyle = position
//  messageView.configureDropShadow()
//  let titleSize :CGFloat = Env.isIpad ? 25: 20
//  let messageSize :CGFloat = Env.isIpad ? 20: 17
//  messageView.titleLabel?.font = UIFont.boldSystemFont(ofSize: titleSize)
//  messageView.bodyLabel?.font = UIFont.boldSystemFont(ofSize: messageSize)
//  config.dimMode = .blur(style: .dark, alpha: 0.5, interactive: true)
//  messageView.configureTheme(theme)
//  messageView.button?.isHidden = true
//  messageView.buttonTapHandler = { _ in SwiftMessages.hide() }
//
//  messageView.configureContent(title: title, body: body)
//  config.duration = durationSecs == -1 ? .forever : .seconds(seconds: 7)
//  messageView.iconImageView?.image = #imageLiteral(resourceName: "Sell4BidsIcon48")
//  let size = CGSize.init(width: 48, height: 48)
//  messageView.configureIcon(withSize: size , contentMode: UIViewContentMode.center)
//  messageView.button?.setTitle("Ok".localizableString(loc: LanguageChangeCode), for: .normal)
//  messageView.button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: messageSize)
//  messageView.button?.isHidden = false
////
//  config.eventListeners.append({ (event) in
//    if case .didHide = event {
//      completion(true)
//
//    }
//
//
//  })
//  SwiftMessages.hide()
//  SwiftMessages.show(config: config, view: messageView)
//
//}
func showSwiftMessageWithParams(theme: Theme , title: String, body: String, layout: MessageView.Layout = MessageView.Layout.cardView, position: Int = 0, completion: @escaping (Bool) -> () = { _ in } ) {

  let view = MessageView.viewFromNib(layout: layout)
  var config = SwiftMessages.Config()
  config.dimMode = .gray(interactive: true)
  if position == 0 {
    config.presentationStyle = .center
  }else {
    config.presentationStyle = .top
  }
    
    let HeadingFontSize : CGFloat = Env.isIpad ? 30 : 25
  let bodyFontSize = HeadingFontSize - 5
  view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
  view.bodyLabel?.font = UIFont.boldSystemFont(ofSize: bodyFontSize)
  view.configureDropShadow()
  
  view.configureTheme(theme)
  view.button?.isHidden = true
  view.configureContent(title: title, body: body)
  view.iconImageView?.image = #imageLiteral(resourceName: "hammer_white")
    
  config.eventListeners.append({ (event) in
    if case .didHide = event {
      completion(true)

    }

  })

  SwiftMessages.show(config: config, view: view)

}

func showSwiftMessageWithParams(theme: Theme , title: String, body: String, durationSecs: Int, layout: MessageView.Layout = MessageView.Layout.cardView, position: SwiftMessages.PresentationStyle = SwiftMessages.PresentationStyle.center,  completion: @escaping (Bool) -> () = { _ in } ) {

  let messageView = MessageView.viewFromNib(layout: layout)

  var config = SwiftMessages.Config()
  config.presentationStyle = position
  messageView.configureDropShadow()
  let titleSize :CGFloat = Env.isIpad ? 25: 20
  let messageSize :CGFloat = Env.isIpad ? 20: 17
  messageView.titleLabel?.font = UIFont.boldSystemFont(ofSize: titleSize)
  messageView.bodyLabel?.font = UIFont.boldSystemFont(ofSize: messageSize)
  config.dimMode = .gray(interactive: true)
  messageView.configureTheme(theme)
  messageView.button?.isHidden = true
  messageView.buttonTapHandler = { _ in SwiftMessages.hide() }

  messageView.configureContent(title: title, body: body)
  config.duration = durationSecs == -1 ? .forever : .seconds(seconds: 7)

  messageView.iconImageView?.image = #imageLiteral(resourceName: "hammer_white")
  messageView.iconImageView?.backgroundColor = .white
  messageView.iconImageView?.layer.cornerRadius = 6
  messageView.iconImageView?.layer.masksToBounds = true
  let size = CGSize.init(width: 50, height: 50)
  messageView.configureIcon(withSize: size , contentMode: UIViewContentMode.center)
  messageView.button?.setTitle("Ok".localizableString(loc: LanguageChangeCode), for: .normal)
  messageView.button?.titleLabel?.font = UIFont.boldSystemFont(ofSize: messageSize)
  messageView.button?.isHidden = false
  config.eventListeners.append({ (event) in
    if case .didHide = event {
      completion(true)

    }


  })
  SwiftMessages.hide()
  SwiftMessages.show(config: config, view: messageView)

}
