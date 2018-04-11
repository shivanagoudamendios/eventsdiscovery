//
//  MapsTabBarController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/11/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class MapsTabBarController: UITabBarController {
    let defaults = UserDefaults.standard;
    
    @IBOutlet var tabBarViewController: UITabBar!
    override func viewDidLoad() {
        
        if let themeclr = defaults.string(forKey: "themeColor"){
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        tabBarViewController.barTintColor = UIColor.init(hex: themeclr)
        tabBarViewController.tintColor = UIColor.white
        }
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for:.normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.selected)
        
        super.viewDidLoad()
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
        
        if let dataFromDefaults = defaults.object(forKey: "mapData") as? NSData{
            if let objectFromDefaults = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as Data) as? Maps{
                let maps = objectFromDefaults
                if (maps.floors?.count)! < 1{
                    if  let arrayOfTabBarItems = tabBarViewController.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
                        tabBarItem.isEnabled = false
                        
                    }
                }
                if maps.venue == "" {
                    if  let arrayOfTabBarItems = tabBarViewController.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[0] as? UITabBarItem {
                        tabBarItem.isEnabled = false
                    }
                    if  let arrayOfTabBarItems = tabBarViewController.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
                        tabBarItem.isEnabled = false
                    }
                }
            }
        }
        
    }
    
    
    
}
