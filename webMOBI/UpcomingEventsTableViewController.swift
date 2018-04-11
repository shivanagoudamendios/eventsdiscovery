//
//  UpcomingEventsTableViewController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/19/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class UpcomingEventsTableViewController: UITableViewController {
    
    @IBOutlet var tblViewUpcomingEvents: UITableView!
    var upcomingEventsArray = [Items]()
    
    let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        
        if let themeclr = defaults.string(forKey: "themeColor"){
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        
        tblViewUpcomingEvents.tableFooterView = UIView()
        
       
        
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        tblViewUpcomingEvents.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
        
        if let dataFromDefaults = defaults.object(forKey: "upcomingEVentData") as? NSData{
            if let objectFromDefaults = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as Data) as? [Items]{
                upcomingEventsArray = objectFromDefaults
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  upcomingEventsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UpcomingEventsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UpcomingEventsTableViewCell") as! UpcomingEventsTableViewCell
        cell.lblUpcomingEventName.text = upcomingEventsArray[indexPath.row].name
        cell.lblUpcomitEventTime.text = upcomingEventsArray[indexPath.row].date
        cell.imgEvent.imageFromUrl(urlString: upcomingEventsArray[indexPath.row].image_url!)
        cell.imgEvent.layer.cornerRadius = cell.imgEvent.frame.width/4.0
        cell.imgEvent.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = upcomingEventsArray[indexPath.row].link
        
        defaults.setValue(urlString, forKey: "weburls")
        
        let SocialPage = self.storyboard?.instantiateViewController(withIdentifier: "WebPageViewController") as! WebPageViewController
        self.navigationController?.pushViewController(SocialPage, animated: true)
        
        //        let url = NSURL(string: urlString!)
        //        UIApplication.sharedApplication().openURL(url!)
    }
    
    
}
