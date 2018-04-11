//
//  RssFeedsViewController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/20/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import MBProgressHUD

class RssFeedsViewController: UITableViewController {
    @IBOutlet var tblViewRssFeeds: UITableView!
    var rssFeedsTitlesArray : [String] = [String]()
    var rssFeedsDatesArray : [String] = [String]()
    var rssFeedsAuthorsArray : [String] = [String]()
    var urlToGetRssFeeds : String = ""
    var responseData : [AnyObject] = [AnyObject]()
    
    let defaults = UserDefaults.standard;
    
    var hud = MBProgressHUD()
    override func viewDidLoad() {
        
       if let themeclr = defaults.string(forKey: "themeColor"){
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        
        tblViewRssFeeds.tableFooterView = UIView()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
        getUrlFromJson()
        if(urlToGetRssFeeds != ""){
            
            
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.labelText = "Loading Data..."
            hud.minSize = CGSize(width: 150, height: 100)
            
            DispatchQueue.main.async(execute: {() -> Void in
                
                let urlPath: String = "https://ajax.googleapis.com/ajax/services/feed/load?v=2.0&q=" + self.urlToGetRssFeeds + "&num=10"
                print(urlPath)
                let urlStr : String = urlPath.addingPercentEscapes(using: .utf8)!
                let url: NSURL = NSURL(string: urlStr as String)!
                let request1 = NSMutableURLRequest(
                    url: url as URL,
                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                    timeoutInterval: 15.0)
                
                NSURLConnection.sendAsynchronousRequest(request1 as URLRequest, queue: OperationQueue(), completionHandler:{
                    (response, data, error)-> Void in
                    
                    if(error != nil)
                    {
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                            })
                        })
                    }else
                    {
                        do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            
                            print(jsonResult)
                            let response = jsonResult.value(forKey: "responseData") as! NSDictionary
                            let feed = response["feed"] as! NSDictionary
                            self.responseData = (feed.value(forKey: "entries") as AnyObject) as! [AnyObject]
                            self.tblViewRssFeeds.reloadData()
                            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    self.hud.hide(true, afterDelay: 0)
                                })
                            })
                            
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                            })
                        })
                    }
                    
                    
                    
                }
                })
                
            })
            
            
        }
        
    }
    
    func getUrlFromJson(){
        if let dataFromDefaults = defaults.object(forKey: "rssData") as? NSData{
            if let stringFromDefaults = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as Data) as? String{
                urlToGetRssFeeds = stringFromDefaults
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  responseData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RssFeedsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RssFeedsTableViewCell") as! RssFeedsTableViewCell
        cell.lblFeedName.text = responseData[indexPath.row].value(forKey: "title") as? String
        let author = responseData[indexPath.row].value(forKey: "author") as? String
        if(author != ""){
            cell.lblFeedBy.text = "by" + author!
        }
        cell.lblFeedDate.text = responseData[indexPath.row].value(forKey: "publishedDate") as? String
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.cornerRadius = 5
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaults.set(responseData[indexPath.row]["title"] as? String, forKey: "newsDataTitle")
        defaults.set(responseData[indexPath.row]["author"] as? String, forKey: "newsDataAuthor")
        defaults.set(responseData[indexPath.row]["publishedDate"] as? String, forKey: "newsDataPublishDate")
        defaults.set(responseData[indexPath.row]["content"] as? String, forKey: "newsDataContent")
        
    }
    
    
    
}
