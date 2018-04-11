//
//  UsersListForChatting.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 7/29/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import MBProgressHUD
import ObjectMapper
class UsersListForChatting: UIViewController,UISearchBarDelegate{
    
    @IBOutlet weak var userSearch: UISearchBar!
    @IBOutlet weak var userTableview: UITableView!
    var refreshControl: UIRefreshControl!
    
    //    var UserArray :[AnyObject] = [AnyObject]()
    //    var UserArray1 :[AnyObject] = [AnyObject]()
    var userMessages = [[String: AnyObject]]()
    var userMessages1 = [[String: AnyObject]]()
    
    let defaults = UserDefaults.standard
    var hud = MBProgressHUD()
    func updatebudgeWithNotification(notification: NSNotification){
        refreshusers()
        //        userTableview.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Chats"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        
        userTableview.addSubview(refreshControl)
        
        
        self.edgesForExtendedLayout = .init(rawValue: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updatebudgeWithNotification), name:NSNotification.Name(rawValue: "budgeNotification"), object: nil)
        
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
            userSearch.barTintColor = UIColor.init(hex: themeclr)
        }
        
        userSearch.delegate = self
        
        userTableview.register(UINib(nibName: "ChatUsersTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatUsersTableViewCell")
        
        userTableview.tableFooterView = UIView()
        userTableview.rowHeight = 70
        //        userTableview.rowHeight = UITableViewAutomaticDimension
        userTableview.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        userMessages1.removeAll()
        if(searchText.length > 0)
        {
            for aa in userMessages
            {
                if((aa["name"]! as AnyObject).lowercased.contains(searchText.lowercased()))
                {
                    userMessages1.append(aa)
                }
            }
            userTableview.reloadData()
        }else
        {
            userMessages1 = userMessages
            userTableview.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func refresh(sender:AnyObject) {
        
        refreshusers()
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
        
        hud = MBProgressHUD.showAdded(to: self.userTableview, animated: true)
        hud.labelText = "Loading Data..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        refreshusers()
        
    }
    
    func refreshusers() {
        
        let appid = self.defaults.string(forKey: "selectedappid")
        let userId = self.defaults.string(forKey: "EvntUserId")
        userSearch.text = ""
        
        
        let token = defaults.string(forKey: "token")
        
        DispatchQueue.main.async(execute: {() -> Void in
            
            
            
            let urlPath: String = ServerApis.chattingUsersUrl+appid!+"&user_id="+userId!
            print(urlPath)
            let urlStr : String = urlPath.addingPercentEscapes(using: .utf8)!
            let url: NSURL = NSURL(string: urlStr as String)!
            var request1 = URLRequest(
                url: url as URL,
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                timeoutInterval: 15.0)
            
            request1.setValue(token, forHTTPHeaderField: "Token")
            
            NSURLConnection.sendAsynchronousRequest(request1, queue: OperationQueue(), completionHandler:{
                (response, data, error)-> Void in
                
                if(error != nil)
                {
                    print(error!)
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.refreshControl.endRefreshing()
                            self.hud.hide(true, afterDelay: 0)
                            self.refreshControl.endRefreshing()
                        })
                    })
                    
                    
                }else
                {
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            print("Synchronous\(jsonResult)")
                            let responseFlg = jsonResult["response"] as? Bool
                            let jsonResult1 = jsonResult["responseString"] as AnyObject
                            if(responseFlg)!
                            {
                                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                                    DispatchQueue.main.async(execute: {() -> Void in
                                        
                                        self.hud.hide(true)
                                        self.refreshControl.endRefreshing()
                                        let received =  Mapper<ChatUsersList>().map(JSONObject: jsonResult1)!.receivemsg
                                        let sended =  Mapper<ChatUsersList>().map(JSONObject: jsonResult1)!.sendmsg
                                        //                                    let grouped =  Mapper<ChatUsersList>().map(JSONObject: jsonResult1)!.groupmsg
                                        self.userMessages.removeAll()
                                        
                                        
                                        var Messages = [[String: AnyObject]]()
                                        
                                        for usr in received{
                                            if(usr.sender_id?.length != nil )
                                            {
                                                if( usr.sender_id != "group")
                                                {
                                                    var messageDictionary = [String: AnyObject]()
                                                    messageDictionary["chat_type"] = "single" as AnyObject?
                                                    messageDictionary["id"] = usr.sender_id as AnyObject?
                                                    messageDictionary["name"] = usr.sender_name as AnyObject?
                                                    messageDictionary["message"] = usr.message_body as AnyObject?
                                                    messageDictionary["msg_datatype"] = usr.msg_datatype as AnyObject?
                                                    messageDictionary["create_date"] = usr.create_date as AnyObject?
                                                    messageDictionary["profile_pic"] = usr.profile_image_url as AnyObject?
                                                    messageDictionary["unread_count"] = usr.unread_count as AnyObject?
                                                    Messages.append(messageDictionary)
                                                }
                                            }
                                            
                                        }
                                        
                                        for usr in sended{
                                            
                                            var messageDictionary = [String: AnyObject]()
                                            messageDictionary["chat_type"] = "single" as AnyObject?
                                            messageDictionary["id"] = usr.sender_id as AnyObject?
                                            messageDictionary["name"] = usr.sender_name as AnyObject?
                                            messageDictionary["message"] = usr.message_body as AnyObject?
                                            messageDictionary["msg_datatype"] = usr.msg_datatype as AnyObject?
                                            messageDictionary["create_date"] = usr.create_date as AnyObject?
                                            messageDictionary["profile_pic"] = usr.profile_image_url as AnyObject?
                                            messageDictionary["unread_count"] = usr.unread_count as AnyObject?
                                            Messages.append(messageDictionary)
                                            
                                        }
                                        Messages = Messages.sorted() { ($0["create_date"] as! String) > ($1["create_date"] as! String) }
                                        
                                        self.userMessages += Messages
                                        self.userMessages1 = self.userMessages
                                        self.userTableview.reloadData()
                                    })
                                })
                            }else
                            {
                                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                                    DispatchQueue.main.async(execute: {() -> Void in
                                        self.hud.hide(true)
                                        self.refreshControl.endRefreshing()
                                        let alert = UIAlertController(title: "Request Failed", message: jsonResult1 as? String, preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    })
                                })
                            }
                        }
                    }catch let error as NSError {
                        print(error.localizedDescription)
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                                self.refreshControl.endRefreshing()
                            })
                        })
                    }
                    
                }
            })
            
        })
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromUrl(url:NSURL, completion: @escaping ((_ data: NSData?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            completion(data as NSData?, response, error as NSError?)
            }.resume()
    }
    
    func timeFromMilliseconds(_ givendate: Int64) -> String {
        
        let presentdate = Int64(Date().timeIntervalSince1970 * 1000)
        var outputStr = ""
        if(givendate <= presentdate)
        {
            let differencetime = presentdate - givendate
            let days  = Int64(differencetime / 86400000)
            let Hours = Int64(((differencetime / 1000) - (days * 86400)) / 3600)
            let Minutes = Int64 (((differencetime / 1000) - ((days * 86400) + (Hours * 3600))) / 60)
            //            let Seconds = (differencetime/1000)%60
            if(days > 1)
            {
                outputStr =  TimeConversion().localtimestringfrommilliseconds(ms: Double(givendate), format: "dd-MMM")
            }else if(days == 1)
            {
                outputStr = "yesterday"
            }else if(Hours > 0)
            {
                outputStr = Hours.description + " hours ago"
            }else if(Minutes > 0)
            {
                outputStr = Minutes.description + " min ago"
            }else
            {
                outputStr = "0 min ago"
            }
            
        }else
        {
            
        }
        
        return outputStr
    }
    
    
}
extension UsersListForChatting: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  userMessages1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let nib = UINib(nibName: "resultCell", bundle: nil)
        //        tableView.registerNib(nib, forCellReuseIdentifier:"ResultViewCell")
        
        let cell: ChatUsersTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChatUsersTableViewCell") as! ChatUsersTableViewCell
        
        let currentusrMessage =  Mapper<Sendmsgs>().map(JSONObject: userMessages1[indexPath.row])!
        
        if  currentusrMessage.unread_count! > 0 {
            
            cell.unreadCount.text = currentusrMessage.unread_count?.description
            cell.unreadCount.isHidden = true
        }else
        {
            cell.unreadCount.isHidden = true
        }
        cell.userName.text = currentusrMessage.sender_name
        cell.lastMsg.text = currentusrMessage.message_body
        cell.lastMsgTime.text = timeFromMilliseconds(Int64(currentusrMessage.create_date!)!)
        let urlstr = currentusrMessage.profile_image_url!
        if(urlstr.characters.count > 0)
        {
            cell.ImgView.isHidden = false
            cell.firstCharLabel.isHidden = true
            DispatchQueue.main.async(execute: { () -> Void in
                
                ImageLoadingWithCache().getImage(url: urlstr, imageView:  cell.ImgView, defaultImage: "EmptyUser.png")
                
                
            })
        }else
        {
            cell.ImgView.isHidden = true
            cell.firstCharLabel.isHidden = false
            cell.firstCharLabel.text =  cell.userName.text?.first
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SocketIOManager.sharedInstance.establishConnection()
        SocketIOManager.sharedInstance.reconnect { (messageInfo) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                print("its connected")
            })
        }
        //        SocketIOManager.sharedInstance.establishConnection(user_id: self.defaults.string(forKey: "EvntUserId")!)
        let currentusrMessage =  Mapper<Sendmsgs>().map(JSONObject: userMessages1[indexPath.row])!
        
        let ChatView = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        ChatView.username = currentusrMessage.sender_name
        ChatView.toUserId = currentusrMessage.sender_id
        ChatView.toname = currentusrMessage.sender_name
        self.navigationController?.pushViewController(ChatView, animated: true)
        
    }
    
}
