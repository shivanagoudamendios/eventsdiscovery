//
//  ChatViewController.swift
//  SocketChat
//

import UIKit
import MBProgressHUD
import ObjectMapper
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var sentButton: UIButton!
    @IBOutlet var enterMsgView: UIView!
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var tvMessageEditor: UITextView!
    @IBOutlet weak var conBottomEditor: NSLayoutConstraint!
    @IBOutlet weak var lblNewsBanner: UILabel!
    
    let defaults = UserDefaults.standard
    var fromname: String!
    var toname: String!
    var toUserId : String!
    var fromUserId: String!
    var appid: String!
    var chatMessages = [[String: AnyObject]]()
    var username: String!
    var bannerLabelTimer: Timer!
    var hud = MBProgressHUD()
    var frompeoplejoined = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = username
        tblChat.separatorStyle = .none
        tvMessageEditor.layer.borderColor = UIColor(hex:"edf0f4").cgColor
        tvMessageEditor.layer.borderWidth = 0.5
        tvMessageEditor.layer.cornerRadius = 10
        tvMessageEditor.font = UIFont(name: "Helvetica Neue", size: 15)
        sentButton.layer.cornerRadius = 20
        if frompeoplejoined{
            let logindata = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
            fromname = logindata["username"] as! String
            fromUserId = logindata["userId"] as! String
        }else{
            fromname = self.defaults.string(forKey: "name")
            fromUserId = self.defaults.string(forKey: "EvntUserId")
            appid = defaults.string(forKey: "selectedappid")
        }
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.sentButton.backgroundColor = UIColor.init(hex: themeclr)
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.handleKeyboardDidShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.handleKeyboardDidHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.down
        swipeGestureRecognizer.delegate = self
        view.addGestureRecognizer(swipeGestureRecognizer)
        
        
        getHistory()
        
    }
    
    func getHistory()
    {   hud.hide(true)
        hud = MBProgressHUD.showAdded(to: self.tblChat, animated: true)
        hud.labelText = "Loading History..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        let token = defaults.value(forKey: "token") as? String
        
        let urlPath: String = ServerApis.historyChatUrl+self.appid!+"&user_id="+self.fromUserId!+"&recipient_id="+self.toUserId!+"&chat_type=single"
        
        let url: URL = URL(string: urlPath.addingPercentEscapes(using: String.Encoding.utf8)!)!
        
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15.0)
        
        request.setValue(token, forHTTPHeaderField: "Token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true)
                        let alert = UIAlertController(title: "Request Failed", message: "Please Check The connection Try Again", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                })
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200,httpStatus.statusCode != 201 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true)
                        let alert = UIAlertController(title: "Request Failed", message: "Please Check The connection Try Again", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                })
            }else{
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        print("Synchronous\(jsonResult)")
                        let responseFlg = jsonResult["response"] as? Bool // false should be true for chat to work
                        let jsonResult1 = jsonResult["responseString"] as AnyObject
                        if(responseFlg)!
                        {
                            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    self.hud.hide(true)
                                    let chats =  Mapper<ChatHistory>().mapArray(JSONObject: jsonResult1["messages"]!)
                                    
                                    self.chatMessages.removeAll()
                                    
                                    for chat in chats!{
                                        
                                        var messageDictionary = [String: AnyObject]()
                                        messageDictionary["id"] = chat.id as AnyObject?
                                        messageDictionary["msg"] = chat.message_body as AnyObject?
                                        messageDictionary["From_UserID"] = chat.sender_id as AnyObject?
                                        messageDictionary["From_UserName"] = chat.sender_name as AnyObject?
                                        messageDictionary["TimeinMilli"] = chat.create_date as AnyObject?
                                        messageDictionary["msg_datatype"] = chat.msg_datatype as AnyObject?
                                        self.chatMessages.append(messageDictionary)
                                        
                                    }
                                    self.chatMessages = self.chatMessages.sorted() { ($0["TimeinMilli"] as! String) < ($1["TimeinMilli"] as! String) }
                                    
                                    self.tblChat.reloadData()
                                        {
                                            self.tableViewScrollToBottom()
                                    }
                                    
                                })
                            })
                        }else
                        {
                            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    self.hud.hide(true)
                                    let alert = UIAlertController(title: "Request Failed", message: jsonResult1 as? String, preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                })
                            })
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true)
                            let alert = UIAlertController(title: "Request Failed", message: "Please Check The connection Try Again", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                }
            }
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaults.set(true, forKey: "checklivechat")
        defaults.set(toUserId, forKey: "currentchatUserID")
        configureTableView()
        configureNewsBannerLabel()
        configureOtherUserActivityLabel()
        tvMessageEditor.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set(false, forKey: "checklivechat")
        defaults.set("", forKey: "currentchatUserID")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                let getappid = messageInfo["appid"] as! String
                if(getappid == self.appid)
                {
                    self.chatMessages.append(messageInfo)
                    self.tblChat.reloadData()
                        {
                            self.tableViewScrollToBottom()
                    }
                }
            })
        }
        
        SocketIOManager.sharedInstance.reconnect { (messageInfo) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                print("its working ")
            })
        }
        SocketIOManager.sharedInstance.confirmCheckin { (messageInfo) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                print("Connected")
            })
        }
        SocketIOManager.sharedInstance.sentChatMessage { (messageInfo) -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                let getappid = messageInfo["appid"] as! String
                
                if(getappid == self.appid)
                {
                    if((messageInfo["msg"] as? String)?.isEmpty == false)
                    {
                        self.chatMessages.removeLast()
                        self.chatMessages.append(messageInfo)
                        
                        self.tblChat.reloadData()
                            {
                                self.tableViewScrollToBottom()
                        }
                    }
                }
            })
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: IBAction Methods
    
    @IBAction func sendMessage(sender: AnyObject) {
        if tvMessageEditor.text.characters.count > 0 {
            
            
            let currentTime = getCurrentMillis()
            
            var messageDictionary = [String: AnyObject]()
            messageDictionary["id"] =  currentTime.description as AnyObject?
            messageDictionary["msg"] =  tvMessageEditor.text! as AnyObject?
            messageDictionary["From_UserID"] = fromUserId as AnyObject?
            messageDictionary["From_UserName"] = fromname as AnyObject?
            messageDictionary["TimeinMilli"] = currentTime.description as AnyObject?
            messageDictionary["msg_datatype"] = "normal" as AnyObject?
            
            
            self.chatMessages.append(messageDictionary)
            self.tblChat.reloadData()
                {
                    self.tableViewScrollToBottom()
            }
            
            SocketIOManager.sharedInstance.sendMessage(To_UserID: toUserId!,To_UserName: toname!,From_UserID: fromUserId!,From_UserName: fromname!,appid: appid!,appname:"Fractal Analytics 2017",chat_type:"single",TimeinMilli: currentTime.description,msg: tvMessageEditor.text!,msg_datatype:"")
            tvMessageEditor.text = ""
            //            tvMessageEditor.resignFirstResponder()
        }
    }
    
    
    func getCurrentMillis()->Int64{
        return  Int64(NSDate().timeIntervalSince1970 * 1000)
    }
    
    
    
    // MARK: Custom Methods
    
    func configureTableView() {
        tblChat.delegate = self
        tblChat.dataSource = self
        tblChat.register(UINib(nibName: "ReceiveChatCell", bundle: nil), forCellReuseIdentifier: "ReceiveChatCell")
        tblChat.register(UINib(nibName: "SendChatCell", bundle: nil), forCellReuseIdentifier: "SendChatCell")
        tblChat.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "idCellChat")
        tblChat.estimatedRowHeight = 90.0
        tblChat.rowHeight = UITableViewAutomaticDimension
        tblChat.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    func configureNewsBannerLabel() {
        lblNewsBanner.layer.cornerRadius = 15.0
        lblNewsBanner.clipsToBounds = true
        lblNewsBanner.alpha = 0.0
    }
    
    
    func configureOtherUserActivityLabel() {
        //        lblOtherUserActivityStatus.hidden = true
        //        lblOtherUserActivityStatus.text = ""
    }
    
    
    func handleKeyboardDidShowNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                conBottomEditor.constant = keyboardFrame.size.height
                view.layoutIfNeeded()
            }
        }
    }
    
    
    func handleKeyboardDidHideNotification(notification: NSNotification) {
        conBottomEditor.constant = 0
        view.layoutIfNeeded()
    }
    
    
    func scrollToBottom() {
        //        let delay = 0.1 * Double(NSEC_PER_SEC)
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                
                if self.chatMessages.count > 0 {
                    let lastRowIndexPath =  IndexPath(row: self.chatMessages.count - 1, section: 0) //NSIndexPath(forRow: self.chatMessages.count - 1, inSection: 0)
                    self.tblChat.scrollToRow(at: lastRowIndexPath, at: UITableViewScrollPosition.bottom, animated: false)
                }
            })
        })
    }
    
    func tableViewScrollToBottom()
    {
        if self.tblChat.contentSize.height > self.tblChat.frame.size.height
        {
            let offset:CGPoint = CGPoint(x: 0,y :self.tblChat.contentSize.height-self.tblChat.frame.size.height)
            self.tblChat.setContentOffset(offset, animated: false)
        }
    }
    
    func showBannerLabelAnimated() {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.lblNewsBanner.alpha = 1.0
            
        }) { (finished) -> Void in
            self.bannerLabelTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ChatViewController.hideBannerLabel), userInfo: nil, repeats: false)
        }
    }
    
    
    func hideBannerLabel() {
        if bannerLabelTimer != nil {
            bannerLabelTimer.invalidate()
            bannerLabelTimer = nil
        }
        
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.lblNewsBanner.alpha = 0.0
            
        }) { (finished) -> Void in
        }
    }
    
    
    
    func dismissKeyboard() {
        if tvMessageEditor.isFirstResponder {
            tvMessageEditor.resignFirstResponder()
            conBottomEditor.constant = 0
            view.layoutIfNeeded()
        }
    }
    
    
    
    
    // MARK: UITableView Delegate and Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Msgs =  Mapper<Messages>().mapArray(JSONObject: chatMessages)!
        
        let currentChatMessage = Msgs[indexPath.row]
        let senderNickname = currentChatMessage.From_UserName
        let message = currentChatMessage.msg
        let messageDate = currentChatMessage.TimeinMilli
        
        if(senderNickname == self.fromname){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SendChatCell", for: indexPath) as! SendChatCell
            
            cell.msgTextView.text = message
            cell.titleLabel.text = ""
            cell.backView.backgroundColor = self.navigationController?.navigationBar.barTintColor
            cell.timeView.text = timeFromMilliseconds(Msgs[indexPath.row].TimeinMilli!)
            var prevDate = ""
            if(indexPath.row > 0 )
            {
                prevDate = dateFromMilliseconds(Msgs[indexPath.row - 1].TimeinMilli!)
            }
            let presentDate = dateFromMilliseconds(Msgs[indexPath.row].TimeinMilli! )
            
            if(prevDate != presentDate)
            {
                cell.dateLabel.text = dateFromMilliseconds(messageDate!)
                cell.dateHeight.constant = 30.0
                cell.dateLabel.isHidden = false
                
            }else
            {
                cell.dateLabel.text = ""
                cell.dateHeight.constant = 0.0
                cell.dateLabel.isHidden = true
            }
            
            return cell
        }
            
        else
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiveChatCell", for: indexPath) as! ReceiveChatCell
            
            cell.msgTextView.text = message
            cell.titleLabel.text = ""
            cell.timeView.text = timeFromMilliseconds(Msgs[indexPath.row].TimeinMilli!)
            var prevDate = ""
            if(indexPath.row > 0 )
            {
                prevDate = dateFromMilliseconds(Msgs[indexPath.row - 1].TimeinMilli!)
            }
            let presentDate = dateFromMilliseconds(Msgs[indexPath.row].TimeinMilli! )
            
            if(prevDate != presentDate)
            {
                cell.dateLabel.text = dateFromMilliseconds(messageDate!)
                cell.dateHeight.constant = 30.0
                cell.dateLabel.isHidden = false
                
            }else
            {
                cell.dateLabel.text = ""
                cell.dateHeight.constant = 0.0
                cell.dateLabel.isHidden = true
            }
            
            return cell
        }
    }
    
    func timeFromMilliseconds(_ ms: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let gettingdate =  Date(timeIntervalSince1970:Double(ms)! / 1000.0).description
        
        let date = dateFormatter.date(from: gettingdate)// create   date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        
        return dateFormatter.string(from: date!)
    }
    //converting milliseconds to date format
    func dateFromMilliseconds(_ ms: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let gettingdate =  Date(timeIntervalSince1970:Double(ms)! / 1000.0).description
        
        let date = dateFormatter.date(from: gettingdate)// create   date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        
        return dateFormatter.string(from: date!)
    }
    
    
    
    // MARK: UITextViewDelegate Methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //        SocketIOManager.sharedInstance.sendStartTypingMessage(nickname)
        
        return true
    }
    
    
    // MARK: UIGestureRecognizerDelegate Methods
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    func calculateHeightForString(inString:String) -> CGFloat
    {
        let messageString = inString
        let attributes = [ NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15.0)! ]
        let attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: attributes)
        let rect:CGRect = attrString!.boundingRect(with: CGSize(width: 300.0, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
        let requredSize:CGRect = rect
        return requredSize.height  //to include button's in your tableview
        
    }
    
    
}
extension UITableView
{
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}




