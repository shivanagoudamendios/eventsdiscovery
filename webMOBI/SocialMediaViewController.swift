//
//  SocialMediaViewController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/25/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import FontAwesome_swift

class SocialMediaViewController: UITableViewController {
    @IBOutlet var tblViewSocialMedia: UITableView!
    
    let defaults = UserDefaults.standard
    var socialMediaOptionsArray : [SocialMediaItems] = [SocialMediaItems]()
    override func viewDidLoad() {
        
        
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        
        
        tblViewSocialMedia.tableFooterView = UIView()
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
        
        if let dataFromDefaults = defaults.object(forKey: "socialMediaData"){
            if let objectFromDefaullts = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as! Data){
                let dataAtIndex = Mapper<SocialMedia>().map(JSONObject:objectFromDefaullts)?.items
                socialMediaOptionsArray = dataAtIndex!
            }
        }
        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  socialMediaOptionsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SocialMediaTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SocialMediaTableViewCell") as! SocialMediaTableViewCell
        cell.lblSocialMediaTitle.text = socialMediaOptionsArray[indexPath.row].name
        cell.lblSocialMediaUrl.text = socialMediaOptionsArray[indexPath.row].url
        let mediatyep = socialMediaOptionsArray[indexPath.row].type
        
        if(mediatyep?.lowercased() == "facebook" || mediatyep?.lowercased() == "linkedin" || mediatyep?.lowercased() == "twitter" || mediatyep?.lowercased() == "instagram" || mediatyep?.lowercased() == "sharepost"){
            let iconname = "fa-"+socialMediaOptionsArray[indexPath.row].iconCls!
            
            cell.imgLogo.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode(iconname)!, textColor: .black, size: CGSize(width: 30, height: 30))
        }else
        {
            cell.imgLogo.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-link")!, textColor: .black, size: CGSize(width: 30, height: 30))
        }
        
        //        if(socialMediaOptionsArray[indexPath.row].name!.lowercaseString == "facebook"){
        //            cell.imgLogo.image = UIImage(named: "facebook.png")
        //        }
        //        else if(socialMediaOptionsArray[indexPath.row].name!.lowercaseString == "twitter"){
        //            cell.imgLogo.image = UIImage(named: "Twitter.png")
        //        }
        //        else if(socialMediaOptionsArray[indexPath.row].name!.lowercaseString == "instagram"){
        //            cell.imgLogo.image = UIImage(named: "Instagram.png")
        //        }else{
        //            cell.imgLogo.image = UIImage(named: "Share.png")
        //        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = NSURL(string: socialMediaOptionsArray[indexPath.row].url!)
        if(url != nil){
            
            if(socialMediaOptionsArray[indexPath.row].type == "sharepost")
            {
                
                let shareItems:Array = [url]
                let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
                self.present(activityViewController, animated: true, completion: nil)
                
            }else{
                
                defaults.setValue(socialMediaOptionsArray[indexPath.row].url, forKey: "weburls")
                
                let SocialPage = self.storyboard?.instantiateViewController(withIdentifier: "WebPageViewController") as! WebPageViewController
                self.navigationController?.pushViewController(SocialPage, animated: true)
            }
            
            //            if UIApplication.sharedApplication().canOpenURL(url!){
            //                UIApplication.sharedApplication().openURL(url!)
            //            }
        }
        else{
            let textToShare = "Url Not Exits"
            let objectsToShare = [textToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
}
