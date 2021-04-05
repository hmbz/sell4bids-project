//
//  EdBotViewController.swift
//  Sell4Bids
//
//  Created by admin on 12/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON
import Speech

class EdBotViewController: UIViewController {
    
    //MARK:- Properties and Outlets
    @IBOutlet weak var edCollectionView: UICollectionView!
    @IBOutlet weak var inputTextView: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var suggessionOneBtn: UIButton!
    @IBOutlet weak var suggessionTwoBtn: UIButton!
    @IBOutlet weak var suggessionThreeBtn: UIButton!
    @IBOutlet weak var suggessionFourBtn: UIButton!
    @IBOutlet weak var suggessionFiveBtn: UIButton!
    @IBOutlet weak var suggessionSixBtn: UIButton!
    @IBOutlet weak var suggessionSevenBtn: UIButton!
    @IBOutlet weak var voiceSearchGif: UIImageView!
    
    //MARK:- Variable
    lazy var titleview = Bundle.main.loadNibNamed("EdTopBarView", owner: self, options: nil)?.first as! EdTopBarView
    lazy var messageLogArray = [MessageLogModel]()
    let cellId = "cell123"
    var webSocket : SocketIOClient?
    let webManager = SocketManager(socketURL: URL(string: "https://chatbot.sell4bids.com/")!, config: [.log(true), .compress])
    var suggestionArray = ["   Hi   "," what is sell4bids? "," How it works for sellers? "," How it works for sellers? "," How auction works? "," How do i list on Sell4Bids? "," Can I share my listing on social media? "]
    lazy var voiceCheck = true
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        socketSetup(msg: "banner1", id: 124)
        setupViews()
        topMenu()
        inputTextView.addTarget(self, action: #selector(EdBotViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.isHidden = true
         navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.20239, green: 0.31236, blue: 0.53646, alpha: 1)
    }
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x:0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: 40)
    }
    
    //MARK:- Actions
    // performing back button functionality
    @objc func backbtnTapped(sender: UIButton){
        print("Back button tapped")
        self.navigationController?.popViewController(animated: true)
    }
    // going back directly towards the home
    @objc func infoBtnTapped(sender: UIButton) {
        print("Home Button Tapped")
     let SB = UIStoryboard(name: "Home", bundle: nil)
     let vc = SB.instantiateViewController(withIdentifier: "EdBotInfoVC") as! EdBotInfoVC
     self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 0 {
            sendBtn.setImage(UIImage(named: "Chat Send"), for: .normal)
            voiceCheck = false
        }else {
            sendBtn.setImage(UIImage(named: "voice"), for: .normal)
            voiceCheck = true
        }
    }
    
    @objc func sendButtonTapped() {
        if voiceCheck == true {
            voiceSearchGif.loadGif(name: "searchGif")
            voiceSearchGif.isHidden = false
            requestVoicePermission { (granted) in
                if  granted {
                    self.recordAndRecognizeSpeech()
                    self.sendBtn.setImage(UIImage(named: "Chat Send"), for: .normal)
                }else {
                    print("Warning: Permission not granted")
                }
            }
        }else {
            print("Send Button Tapped")
            if inputTextView.text!.isEmpty {
                print("Please enter Some text")
            }else {
                let message = MessageLogModel.init(id: 190, message: inputTextView.text!, seenStatus: false, senderId: 123)
                messageLogArray.append(message)
                self.edCollectionView.reloadData()
                scrollTowordsBottom()
                let msg = inputTextView.text!
                let customeData = ["userId":SessionManager.shared.userId]
                let messageDic:[String:Any] = ["message":msg,"customData":customeData]
                print(messageDic)
                self.webSocket?.emit("user_uttered", messageDic)
                self.inputTextView.text = ""
            }
        }
        
    }
    
    @objc func suggessionBtnTapped(sender: UIButton){
        let msg = sender.titleLabel?.text
        let message = MessageLogModel.init(id: 190, message: msg, seenStatus: false, senderId: 123)
        messageLogArray.append(message)
        self.edCollectionView.reloadData()
        scrollTowordsBottom()
        let customeData = ["userId":SessionManager.shared.userId]
        let messageDic:[String:Any] = ["message":msg ?? "","customData":customeData]
        self.webSocket?.emit("user_uttered", messageDic)
    }
    
    // TODO:- Voice Search Functionality
    //Variables for Voice Recoginition
    var speechRecognizer : SFSpeechRecognizer? = SFSpeechRecognizer()
    var audioEngine = AVAudioEngine()
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask : SFSpeechRecognitionTask?
    var recognizedTest = ""
    var timer = Timer()
    
    // access permission
    func requestVoicePermission(completion: @escaping (Bool) -> ()) {
        let recordingSession = AVAudioSession()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            switch recordingSession.recordPermission() {
            case AVAudioSessionRecordPermission.granted:
                print("Permission granted")
                SFSpeechRecognizer.requestAuthorization({ (authStatus) in
                    OperationQueue.main.addOperation {
                        switch authStatus {
                        case .authorized:
                            completion(true)
                        case .denied:
                            completion(false)
                            self.view.makeToast("Speech Recognition Permission not granted.")
                        case .restricted:
                            self.view.makeToast( "Speech Recognition Permission Restricted.")
                            completion(false)
                        case .notDetermined:
                            self.view.makeToast("Speech Recognition Permission not Determined.")
                            completion(false)
                        }
                    }
                })
            case AVAudioSessionRecordPermission.denied:
                print("user had denied Permission earlier")
                let title = "Microphone permission Denied"
                let mess = "Go to Settings -> Privacy -> Microphone, find GigsGenie and tap on the switch to allow microphone to process your voice."
                let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok".localizableString(loc: LanguageChangeCode), style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    completion(false)
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            case AVAudioSessionRecordPermission.undetermined:
                print("Request permission here")
                // Handle granted
                recordingSession.requestRecordPermission(){ (allowed) in
                    if allowed {
                        SFSpeechRecognizer.requestAuthorization({ (authStatus) in
                            OperationQueue.main.addOperation {
                                switch authStatus {
                                case .authorized:
                                    completion(true)
                                case .denied:
                                    completion(false)
                                    self.view.makeToast("Speech Recognition Permission not granted.")
                                case .restricted:
                                    self.view.makeToast("Speech Recognition Permission Restricted.")
                                    completion(false)
                                case .notDetermined:
                                    self.view.makeToast("Speech Recognition Permission not Determined.")
                                    completion(false)
                                }
                            }
                        })
                    } else {
                        print("Denied")
                        self.view.makeToast("Permission Denied.")
                        let alert = UIAlertController(title: "We need your permission to process your Speech", message: "Go to Settings -> Privacy -> Microphone, find ChoiceGenie and tap on the switch to allow speech recognition.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok".localizableString(loc: LanguageChangeCode), style: .default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                            completion(false)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } catch {
            print("try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord) failed")
        }
    }
    // recode Function
    private func recordAndRecognizeSpeech() {
        audioEngine = AVAudioEngine()
        speechRecognizer = SFSpeechRecognizer()
        request = SFSpeechAudioBufferRecognitionRequest()
        recognitionTask = SFSpeechRecognitionTask()
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        //InstallTap configures the node and sets up the request instance with the proper buffer on the proper bus.
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        //When user did not speak for four seconds
        timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { (timer) in
            //utilityFunctions.hide(view: self.imgFidget)
            print("4 seconds have been passed and you did not speak")
            self.view.makeToast("Sorry, we did not get that. Tap on the microphone to try Again.", duration: 2.0, position: .center)
            self.audioEngine.stop()
            self.recognitionTask?.cancel()
            let node = self.audioEngine.inputNode
            node.removeTap(onBus: 0)
        }
        audioEngine.prepare()
        do{
            try audioEngine.start()
            //Then, make a few more checks to make sure the recognizer is available for the device and for the locale, since it will take into account location to get language
            guard  let myRecognizer = SFSpeechRecognizer() else {
                return
            }
            if !myRecognizer.isAvailable{
                //recognier not available right now
                print("recognizer not available")
                return
            }
            var timerDidFinishTalk = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
            })
            
            //Next, call the recognitionTask method on the recognizer. This is where the recognition happens.
            
            recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                //utilityFunctions.show(view: self.imgFidget)
                guard let result = result else {
                    print("There was an error: (error!)")
                    return
                }
                
                timerDidFinishTalk.invalidate()
                if self.timer.isValid { self.timer.invalidate() }
                timerDidFinishTalk = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (timer) in
                    self.timer.invalidate()
                    let searchText = result.bestTranscription.formattedString
                    DispatchQueue.main.async {
                        print("Successfully recognized your speech.")
//                        self.inputTextView.text = searchText
                        self.stopSpeechRecognition()
                        self.voiceSearchGif.isHidden = true
                        let message = MessageLogModel.init(id: 190, message: searchText, seenStatus: false, senderId: 123)
                        self.messageLogArray.append(message)
                        self.edCollectionView.reloadData()
                        self.scrollTowordsBottom()
                        let msg = searchText
                        let customeData = ["userId":SessionManager.shared.userId]
                        let messageDic:[String:Any] = ["message":msg,"customData":customeData]
                        print(messageDic)
                        self.webSocket?.emit("user_uttered", messageDic)
                        self.inputTextView.text = ""
                    }
                    self.recognitionTask?.finish()
                    node.removeTap(onBus: 0)
                    self.request.endAudio()
                    self.recognitionTask = nil
                    self.audioEngine.stop()
                })
            })
        }catch{
            print("let result = result failed")
            return print(error)
        }
    }
    
    // if some one want to stop search
    private func stopSpeechRecognition(){
        self.request.endAudio()
        self.audioEngine.stop()
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
    }
    
    
    //MARK:- Private Function
    func updateCollectionContentInset() {
        let contentSize = edCollectionView.collectionViewLayout.collectionViewContentSize
        var contentInsetTop = edCollectionView.bounds.size.height

            contentInsetTop -= contentSize.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
        }
        edCollectionView.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
    func scrollTowordsBottom() {
        guard !messageLogArray.isEmpty else { return }
        let lastIndex = messageLogArray.count - 1
         edCollectionView.scrollToItem(at: IndexPath(item: lastIndex, section: 0), at: .centeredVertically, animated: true)
    }
    
    private func topMenu() {
        self.navigationItem.titleView = titleview
        titleview.backBtn.addTarget(self, action: #selector(backbtnTapped(sender:)), for: .touchUpInside)
        titleview.infoBtn.addTarget(self, action: #selector(infoBtnTapped(sender:)), for: .touchUpInside)
        self.navigationItem.hidesBackButton = true
    }
    
    private func sizeToButton(Btn: UIButton){
        Btn.sizeToFit()
        Btn.sizeThatFits(CGSize.zero)
        Btn.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        Btn.shadowView()
        Btn.layer.cornerRadius = 20
    }
    
    private func setupViews(){
        
        suggessionOneBtn.setTitle(suggestionArray[0], for: .normal)
        sizeToButton(Btn: suggessionOneBtn)
        suggessionOneBtn.addTarget(self, action: #selector(suggessionBtnTapped(sender:)), for: .touchUpInside)
        suggessionTwoBtn.setTitle(suggestionArray[1], for: .normal)
        sizeToButton(Btn: suggessionTwoBtn)
        suggessionTwoBtn.addTarget(self, action: #selector(suggessionBtnTapped(sender:)), for: .touchUpInside)
        suggessionThreeBtn.setTitle(suggestionArray[2], for: .normal)
        sizeToButton(Btn: suggessionThreeBtn)
        suggessionThreeBtn.addTarget(self, action: #selector(suggessionBtnTapped(sender:)), for: .touchUpInside)
        suggessionFourBtn.setTitle(suggestionArray[3], for: .normal)
        sizeToButton(Btn: suggessionFourBtn)
        suggessionFourBtn.addTarget(self, action: #selector(suggessionBtnTapped(sender:)), for: .touchUpInside)
        suggessionFiveBtn.setTitle(suggestionArray[4], for: .normal)
        sizeToButton(Btn: suggessionFiveBtn)
        suggessionFiveBtn.addTarget(self, action: #selector(suggessionBtnTapped(sender:)), for: .touchUpInside)
        suggessionSixBtn.setTitle(suggestionArray[5], for: .normal)
        sizeToButton(Btn: suggessionSixBtn)
        suggessionSixBtn.addTarget(self, action: #selector(suggessionBtnTapped(sender:)), for: .touchUpInside)
        suggessionSevenBtn.setTitle(suggestionArray[6], for: .normal)
        sizeToButton(Btn: suggessionSevenBtn)
        suggessionSevenBtn.addTarget(self, action: #selector(suggessionBtnTapped(sender:)), for: .touchUpInside)

        inputTextView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.cornerRadius = 25
        sendBtn.shadowView()
//        inputTextView.delegate = self
        inputTextView.attributedPlaceholder = NSAttributedString(string: "strEdTextFieldPlaceholder".localizableString(loc: LanguageChangeCode),
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        inputTextView.tintColor = .white
        
//        sendBtn.setImage(UIImage(named: "Chat Send"), for: .normal)
        
        sendBtn.layer.cornerRadius = 25
        edCollectionView.register(chatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        sendBtn.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        let headerNib = UINib(nibName: "EdHeaderView", bundle: nil)
        edCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "EdHeaderView")
        if let flowLayout = self.edCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionHeadersPinToVisibleBounds = false
        }
    }
    
    private func socketSetup(msg: String,id: Int) {
        webSocket = webManager.defaultSocket
        webSocket?.on(clientEvent: .connect, callback: { (data, ack) in
            print("Socket Connected")
            let customeData = ["userId":SessionManager.shared.userId]
            let messageDic:[String:Any] = ["message":msg,"customData":customeData]
            self.webSocket?.emit("user_uttered", messageDic)
        })
        setupChatModel()
    }
    
    private func setupChatModel() {
        webSocket?.on("bot_uttered", callback: { (response, Error) in
            print(response)
            let data = JSON(response)
            print(data)
            let jsonArray = data.array ?? []
            let jsonDic = jsonArray[0].dictionary
            let text = jsonDic?["text"]?.string ?? ""
            if text.contains("action"){
              if text.contains("actionChat".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "chat", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "MyChatList") as! MyChatListVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
              else if text.contains("actionWatching".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "myWatchListList", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "ActiveWatchListVc") as! ActiveWatchListVc
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if text.contains("actionSelling".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "MySellVc") as! SellingVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if text.contains("actionBuying".localizableString(loc: LanguageChangeCode)){
                    
                    let SB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "BidsVc") as! BuyingAndBidsVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if text.contains("actionBought".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "BoughtAndWinsVc") as! BoughtAndWinsVc
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if text.contains("actionBids".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "BidsItemsVC") as! BidsVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if text.contains("actionFollower".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "FollowersVc") as! FollowersVc
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if text.contains("actionFollowing".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "FollowingVc") as! FollowingVc
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if text.contains("actionBlocklist".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "mySell4BidsTab", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "BlockUserVc") as! BlockUserVc
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if text.contains("actionItems".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "Listing", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "ItemListingStepOneVC") as! ItemListingStepOneVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if text.contains("actionVehicles".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "Listing", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "VehicleListingStepOneVC") as! VehicleListingStepOneVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if text.contains("actionRealEstate".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "Listing", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "HousingListingStepOneVC") as! HousingListingStepOneVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if text.contains("actionServices".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "Listing", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "ServiceListingStepOneVC") as! ServiceListingStepOneVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if text.contains("actionJobs".localizableString(loc: LanguageChangeCode)){
                    let SB = UIStoryboard(name: "Listing", bundle: nil)
                    let vc = SB.instantiateViewController(withIdentifier: "JobListingStepOneVC") as! JobListingStepOneVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else {
                let msg = MessageLogModel.init(id: 2, message: text, seenStatus: true, senderId: 124)
                self.messageLogArray.append(msg)
                self.edCollectionView.reloadData()
                self.edCollectionView.scrollToBottom()
            }
        })
        webSocket?.connect()
    }
    
}
//MARK:- Collection View Delegate
extension EdBotViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageLogArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! chatLogMessageCell
        cell.messageTextView.text = messageLogArray[indexPath.item].message
        if let messageText = messageLogArray[indexPath.item].message {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText ).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            let userId = 123
            if messageLogArray[indexPath.item].senderId == userId {
                // Outgoing messages
                cell.profileImageView.isHidden = true
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
                cell.messageTextView.textColor = UIColor.white
                cell.textBubbleView.backgroundColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 1, alpha: 1)
            }else {
                // incoming messages
                cell.profileImageView.isHidden = false
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 6)
                cell.messageTextView.textColor = UIColor.black
                cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let messageText = messageLogArray[indexPath.row].message ?? ""
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 20 + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextView.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EdHeaderView", for: indexPath) as! EdHeaderView
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM dd, yyyy  h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let dateString = formatter.string(from: Date())
        print(dateString)  
        headerView.timeLbl.text = dateString
        formatter.dateFormat = "HH:mm"
        let currentTime = formatter.string(from: Date())
        print(currentTime)
        let splitTime = currentTime.components(separatedBy: ":")
        let Time = Int(splitTime[0])
        if Time ?? 0 < 12 && Time ?? 0 > 00 {
            print("Good Morning")
            headerView.greetingImg.image = UIImage(named: "morning")
            headerView.greetingLbl.text = "Good Morning"
        }else if Time ?? 0 < 16 && Time ?? 0 > 12 {
            print("Good After Noon")
            headerView.greetingImg.image = UIImage(named: "afterNoon")
            headerView.greetingLbl.text = "Good After Noon"
        }else if Time ?? 0 < 20 && Time ?? 0 > 16 {
            print("Good Evening")
            headerView.greetingImg.image = UIImage(named: "Evening")
            headerView.greetingLbl.text = "Good Evening"
        }else if Time ?? 0 < 20 && Time ?? 0 > 00 {
            headerView.greetingImg.image = UIImage(named: "Night")
            headerView.greetingLbl.text = "Good Night"
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: 220)
    }
    
}
//MARK:- Chat Cell
class chatLogMessageCell: BaseCell{
    
    let messageTextView : UITextView = {
       let textView = UITextView()
        textView.text = "Sample Message"
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.backgroundColor = UIColor.clear
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let textBubbleView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.image = #imageLiteral(resourceName: "ed_bot")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addConstrainstsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstrainstsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        profileImageView.backgroundColor = UIColor.red
    }
    
    func setupCell(MessageModel: MessageLogModel?, image: UIImage?){
        messageTextView.text = MessageModel?.message
        profileImageView.image = image
        if let messageText = MessageModel?.message {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText ).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
        let userId = 123
            if MessageModel?.senderId == userId {
                profileImageView.isHidden = true
                messageTextView.frame = CGRect(x: 45 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                textBubbleView.frame = CGRect(x: 45, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
            }else {
                profileImageView.isHidden = false
                messageTextView.frame = CGRect(x: 45 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                textBubbleView.frame = CGRect(x: 45, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
            }
            
        
        }
    }
}
//MARK:- Chat Model
struct MessageLogModel {
    var id : Int?
    var message : String?
    var seenStatus : Bool?
    var senderId : Int?
    
    init(id: Int?, message: String?, seenStatus: Bool?, senderId: Int?) {
        self.id = id
        self.message = message
        self.seenStatus = seenStatus
        self.senderId = senderId
    }
}
//extension EdBotViewController:UITextFieldDelegate{
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        sendBtn.setImage(UIImage(named: "Chat Send"), for: .normal)
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        sendBtn.setImage(UIImage(named: "voice"), for: .normal)
//    }
//}
