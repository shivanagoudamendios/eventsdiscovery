//
//  NotificationsViewController.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/28/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import MBProgressHUD
class NotificationsViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var defaults = UserDefaults.standard
    var hud = MBProgressHUD()
    var notificationsArray : [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notifications"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableview.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        
        tableview.tableFooterView = UIView()
        tableview.estimatedRowHeight = 80
        tableview.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.labelText = "Loading ..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        getnotifications()
    }
    
    func getnotifications() {
        
        let appid = self.defaults.string(forKey: "selectedappid")
        let userId = self.defaults.string(forKey: "EvntUserId")
        
        
        let token = defaults.string(forKey: "token")
        
        DispatchQueue.main.async(execute: {() -> Void in
            
            
            
            let urlPath: String = ServerApis.notificationUrl+appid!+"&userid="+userId!+"&device_type=ios"
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
                            let alert = UIAlertController(title: "Request Failed", message: "Please Check The connection Try Again", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.hud.hide(true, afterDelay: 0)
                        })
                    })
                    
                    
                }else
                {
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            print("Synchronous\(jsonResult)")
                            let responseFlg = jsonResult["response"] as? Bool
                            
                            if(responseFlg)!
                            {
                                let jsonResult1 = jsonResult["responseString"] as! [AnyObject]
                                
                                self.notificationsArray = jsonResult1
                                
                                
                                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                                    DispatchQueue.main.async(execute: {() -> Void in
                                        self.hud.hide(true, afterDelay: 0)
                                        self.tableview.reloadData()
                                    })
                                })
                                
                            }else
                            {
                                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                                    DispatchQueue.main.async(execute: {() -> Void in
                                    self.hud.hide(true, afterDelay: 0)
                                let alert = UIAlertController(title: "Request Failed", message: "Please Check The connection Try Again", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    })
                                })
                            }
                            
                            
                            
                        }
                    }catch let error as NSError {
                        print(error.localizedDescription)
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                                let alert = UIAlertController(title: "Request Failed", message: "Please Check The connection Try Again", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            })
                        })
                    }
                    
                }
            })
            
        })
        
        
    }


}
extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  self.notificationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        cell.titleLabel.text = notificationsArray[indexPath.row]["title"] as? String
        cell.descLabel.text = notificationsArray[indexPath.row]["message"] as? String
        cell.timeLabel.text = timeFromMilliseconds((notificationsArray[indexPath.row]["notification_time"] as! Int64))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let NotificationDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationDetailsViewController") as! NotificationDetailsViewController
        NotificationDetailsView.notifyDetails = notificationsArray[indexPath.row]
        self.navigationController?.pushViewController(NotificationDetailsView, animated: true)
        
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
                outputStr =  TimeConversion().stringfrommilliseconds(ms: Double(givendate), format: "dd-MMM")
                
                
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
