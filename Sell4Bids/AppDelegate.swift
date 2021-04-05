//
//  AppDelegate.swift
//  Sell4Bids
//
//  Created by admin on 8/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseInstanceID
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import AppRater
import GooglePlaces
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
import SwiftyStoreKit
import SwiftyJSON
//import SocketIO
import SwiftyJSON
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    //MARK:- Variables
    let notificationCenter = UNUserNotificationCenter.current() //  for Notifications
    let options: UNAuthorizationOptions = [.alert, .sound, .badge] // Notification Option
    let gcmMessageIDKey = "gcm.message_id" // for Push notification
    private var Printer = PinterestLayout() // for setting the coulumn in home Layout
    var window: UIWindow?
    // Used for google Api's
    struct SensitiveStrings {
        /*Original AIzaSyDElOr_AjZsW7h_CAWtLl3BdXNXYMBDiZs*/
        static let GMS_SERVICES_API_KEY: [UInt8] = [26, 26, 31, 13, 63, 77, 6, 44, 8, 60, 92, 30, 49, 26, 30, 22, 59, 82, 15, 62, 55, 36, 123, 84, 2, 63, 124, 32, 14, 61, 45, 44, 117, 109, 12, 23, 58, 46, 1]
        /*Original AIzaSyDElOr_AjZsW7h_CAWtLl3BdXNXYMBDiZsC*/
        static let GMS_PLACES_API_KEY: [UInt8] = [26, 26, 31, 13, 63, 77, 6, 44, 8, 60, 92, 30, 49, 26, 30, 22, 59, 82, 15, 62, 55, 36, 123, 84, 2, 63, 124, 32, 14, 61, 45, 44, 117, 109, 12, 23, 58, 46, 1]
    }
    
    //MARK:- App Life Cycle
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
      ApplicationDelegate.shared.application(
                 application,
                 didFinishLaunchingWithOptions: launchOptions
             )
      
        // For Push Notifications
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()

        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()

        
        FirebaseApp.configure()
        
        
        
        // Increment for Store Reviews
        StoreReviewHelper.incrementAppOpenedCount()
        
        // Setting Up KeyBoard
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableDebugging = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // For Notification Siren
        Siren.shared.wail()

        // Requesting Notification server.
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        
        // Setting Up the Number of coulumns in the Home Layout
        print("Device Name  : \(UIDevice.modelName)")
        if Env.isIpad && Env.isIphoneMedium{
            Printer.get_numberOfColumns(numbersofColumns: 3)
        }
        else if UIDevice.isSmall {
            Printer.get_numberOfColumns(numbersofColumns: 3)
            print("Ipad = \(UIDevice.isSmall)")
        }else {
            Printer.get_numberOfColumns(numbersofColumns: 3)
        }
        
        // Setting Up crashlytics
        Fabric.with([Crashlytics.self])
        
        // Configuring for Googgle signIn
        GIDSignIn.sharedInstance().clientID = "679420335008-dq9qhdg7utobpk39gaajs8a6ahsl1k2r.apps.googleusercontent.com"
//          FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //GoogleMaps API Keys
        Obfuscator.obfuscate()
        GMSServices.provideAPIKey("AIzaSyDrU4jdzEOaKS-eDk2H0_C9Sv__HOhdaVI")
        GMSPlacesClient.provideAPIKey("AIzaSyDrU4jdzEOaKS-eDk2H0_C9Sv__HOhdaVI")
        
        // Setting Up the Color of the Navigation Bar (Custom)
        UINavigationBar.appearance().barTintColor = UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
        UINavigationController().navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        
        // Custom Search bar Font Size
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.boldSystemFont(ofSize: 20)
        UITextField.appearance().tintColor = UIColor.black
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
//        socket = manager.defaultSocket
//        socket?.connect()
    }
    
    
  
  
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
//        socket = manager.defaultSocket
//        socket?.on(clientEvent: .connect) {data, ack in
//            print("socket connected")
//            socket?.emitWithAck("chat_message", "Ahmed").timingOut(after: 0) {data in
//                socket?.emit("chat_message", "Ahmed" )
//            }
//        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("i am terminating")
        
//        socket!.on(clientEvent: .connect) {data, ack in
//            print("socket connected")
//            socket!.emitWithAck("chat_message", "Ahmed").timingOut(after: 0) {data in
//                socket!.emit("chat_message", "Ahmed" )
//            }
//        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
//       Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
//       Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
        
        let state : UIApplicationState = application.applicationState
        if (state == .inactive || state == .background) {
            // go to screen relevant to Notification content
            print("background")
        } else {
            // App is in UIApplicationStateActive (running in foreground)
            print("foreground")
            // Print full message.
            let response = JSON(userInfo)
            print(response)
            guard let jsonDic = response.dictionary else {return}
            let notificationText = jsonDic["notif_text"]?.string ?? ""
            let messageID = jsonDic[gcmMessageIDKey]?.string ?? ""
            //        let chat = userInfo["chat"]
            //        let chatDic = JSON(chat)
            //        print(chatDic)
            let notificationTitle = jsonDic["notif_title"]?.string ?? ""
            //        let apsDic = jsonDic["aps"]?.dictionary
            //        let alertDic = apsDic?["alert"]?.dictionary
            //        let apsTitle = alertDic?["title"]?.string ?? ""
            let notificationMessage = jsonDic["gcm.notification.message"]?.string ?? ""
            let notificationType = jsonDic["notif_type"]?.string ?? ""
            let notificationImage = jsonDic["notif_image"]?.string ?? ""
            print("Notification Text", notificationText)
            print("Notification titile", notificationTitle)
            print("Notification Message",notificationMessage)
            print("Notification Type",notificationType)
            print("Notification Image",notificationImage)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let content = UNMutableNotificationContent()
            content.title = notificationTitle
            content.body = notificationMessage
            content.sound = UNNotificationSound.default()
            content.badge = 1
            
            let request = UNNotificationRequest(identifier: messageID, content: content, trigger: trigger)
            self.notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
            
            completionHandler(UIBackgroundFetchResult.newData)
        }
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                SessionManager.shared.fcmToken = result.token
            }
        })
    }
    
    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
    
    
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) {
          [weak self] granted, error in
            
          print("Permission granted: \(granted)")
          guard granted else { return }
          self?.getNotificationSettings()
      }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }

      }
    }


    

}
// MARK:- Google SignIn functions
extension AppDelegate:GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let err = error{
            print("Failed to log into Google: ", err)
            return
        }
        print("Successfully logged into Google ",user)
    }
    // Handle both Facebook and google In App Login
  
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
           
           let googleDidHandle = GIDSignIn.sharedInstance().handle(url)
           guard let urlScheme = url.scheme else { return false }
           if urlScheme.hasPrefix("fb") {
           return ApplicationDelegate.shared.application(
                       app,
                       open: url,
                       sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                       annotation: options[UIApplication.OpenURLOptionsKey.annotation]
                   )

//               return ApplicationDelegate.shared.application(app, open: url, options: options)
           }
           return googleDidHandle || true
       }
  
       

  // Swift
  //
  // SceneDelegate.swift
  @available(iOS 13.0, *)
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      guard let url = URLContexts.first?.url else {
          return
      }

      ApplicationDelegate.shared.application(
          UIApplication.shared,
          open: url,
          sourceApplication: nil,
          annotation: [UIApplication.OpenURLOptionsKey.annotation]
      )
  }

      
  
  
  
  
  
  
       func application(_ application: UIApplication,open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
           let googleDidHandle = GIDSignIn.sharedInstance().handle(url)
           
           return googleDidHandle
       }
}

extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([.alert,.sound,.badge])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}

extension AppDelegate: MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")

      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Message Data",remoteMessage.appData)
    }
}

