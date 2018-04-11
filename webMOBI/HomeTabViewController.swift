//
//  HomeTabViewController.swift
//  webMOBI
//
//  Created by webmobi on 5/24/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import CoreLocation

protocol openFavouritesTVC {
    func openfavourites()
    
}


class HomeTabViewController: UITabBarController,openFavouritesTVC {
    
    
    var userclose : Bool!
    var defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.DismissVC),
            name: Notification.Name("cometohome"),
            object: nil)
        initnaviogationbar()
        userclose = true
        createtabs()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.gray], for:.normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blue], for:.selected)
        if(self.selectedIndex == 3 ||  self.selectedIndex == 0 ||  self.selectedIndex == 1 || self.selectedIndex == 2)
        {
            self.selectedIndex = 0
            
        }
    
        
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.logoutWithNotifications), name:NSNotification.Name(rawValue: "LogoutNotification"), object: nil)
        
    }
    
    func logoutWithNotifications() {
        self.selectedIndex = 0
       UserDefaults.standard.removeObject(forKey: "userlogindata")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userclose == true {
            if (self.defaults.value(forKey: "isappfirsttime") as! Bool) == false{
                checkforlocationaccess()
            }
            userclose = false
        }
    }
    
}

extension HomeTabViewController{
    
    func DismissVC(notification: NSNotification)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createtabs() {
        
        let tab1 = HomeTabViewController1()
        let tabItem1 = UITabBarItem(title: "Home", image: UIImage(named: "homeunselected") , selectedImage: UIImage(named: "homeselected"))
        tabItem1.tag = 0
        tab1.tabBarItem = tabItem1
        
//        let tab2 = HomeTabViewController3()
        let tab2 = AddtocontactsViewController()
        let tabItem2 = UITabBarItem(title: "Contacts", image: UIImage(named: "contacts") , selectedImage: UIImage(named: "contactsSelected"))
        tabItem2.tag = 1
        tab2.tabBarItem = tabItem2
        
        let tab3 = HomeTabViewController2()
        let tabItem3 = UITabBarItem(title: "Near By", image: UIImage(named: "nearbyunselected") , selectedImage: UIImage(named: "nearbyselected"))
        tabItem3.tag = 2
        tab3.tabBarItem = tabItem3

        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Device not detectable")
        }
//        let tab5 = storyboard.instantiateViewController(withIdentifier: "EmptyViewController") as! EmptyViewController
        let tab5 = HomeOptionViewController()
        let tabItem5 = UITabBarItem(title: "More", image: UIImage(named: "tabbarmenu") , selectedImage: UIImage(named: "tabbarmenufull"))
        tabItem5.tag = 3
        tab5.tabBarItem = tabItem5
        
        self.viewControllers = [tab1, tab2, tab3, tab5]
        
    }
    
    func initnaviogationbar() {
        let themecl = UserDefaults.standard.value(forKey: "themeColor")
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30/255, green: 112/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: ((self.navigationController?.navigationBar.frame.size.width)!-30) , height: 30))
        customView.layer.cornerRadius = 5
        customView.backgroundColor = UIColor(red: 30/255, green: 112/255, blue: 145/255, alpha: 0.5)
        
        let imageName = "search"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        customView.addSubview(imageView)
        
        let btn1 = UIButton(type: .custom)
        btn1.frame = CGRect(x: 30, y: 0, width: ((customView.frame.size.width)-60) , height: 30)
        btn1.backgroundColor = UIColor.clear
        btn1.setTitle("Search", for: .normal)
        btn1.contentHorizontalAlignment = .left
        btn1.alpha = 0.5
        btn1.addTarget(self, action: #selector(self.search(_:)), for: .touchUpInside)
        customView.addSubview(btn1)
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "locker"), for: .normal)
        btn2.frame = CGRect(x: customView.frame.size.width - 45, y: 5, width: 20 , height: 20)
        btn2.backgroundColor = UIColor.clear
        btn2.addTarget(self, action: #selector(self.securesearch(_:)), for: .touchUpInside)
        customView.addSubview(btn2)
        
        let item1 = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = item1
        
//        let btn3 = UIButton(type: .custom)
//        btn3.setImage(UIImage(named: "dotmenu"), for: .normal)
//        btn3.frame = CGRect(x: customView.frame.size.width - 35, y: 5, width: 20 , height: 20)
//        btn3.backgroundColor = UIColor.clear
//        btn3.addTarget(self, action: #selector(self.option(_:)), for: .touchUpInside)
//        let item2 = UIBarButtonItem(customView: btn3)
//        self.navigationItem.rightBarButtonItem = item2
        
    }
    
    func option(_ sender : UIButton) {
//        let newViewController = HomeOptionViewController(nibName: "HomeOptionViewController", bundle: nil)
//        newViewController.modalPresentationStyle = .overFullScreen
//        newViewController.delegate = self
//        self.present(newViewController, animated: false, completion: nil)
    }
    
    func openfavourites() {
        let newViewController = FavoritesTableViewController(nibName: "FavoritesTableViewController", bundle: nil)
        navigationController!.pushViewController(newViewController, animated: true)
        
    }
    
    func openprofile()
    {
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let newViewController : NewMySettingsViewController = storyboard.instantiateViewController(withIdentifier: "NewMySettingsViewController") as! NewMySettingsViewController
        navigationController!.pushViewController(newViewController, animated: true)
    }
    
    func securesearch(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: "userlogindata") == nil{
            DispatchQueue.main.async(execute: {() -> Void in
                let alert = UIAlertController(title: "Not Logged in", message: "Login to enter private events", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                })
                self.present(alert, animated: true, completion: nil)
            })
        }else{
            let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            vc.isprivate_event = true
            vc.userid = data1["userId"]! as! String
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func search(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.checkforlogin = "Default"
        vc.isprivate_event = false
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(tabBar.tag)
        
        if(item.title == "Profile")
        {
            if UserDefaults.standard.value(forKey: "userlogindata") == nil{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
                let navigationController = UINavigationController(rootViewController: vc)
                self.present(navigationController, animated: false, completion: nil)
            }else{
                openprofile()
            }
        }
        
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func presentloginscreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func checkforloginaccess() {
        if UserDefaults.standard.value(forKey: "userlogindata") == nil{
         
            let alert = UIAlertController(title: "Not Logged in", message: "Login Required", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
                UIAlertAction in
                //self.checkforloginaccess()
            })
            
            alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.presentloginscreen()
            })
            
            self.present(alert, animated: true, completion: nil)
          
        }else{
            print("Already LoggedIn")
        }
    }
    
    func checkforlocationaccess() {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                DispatchQueue.main.async(execute: {() -> Void in
                    let appname = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                    let alert = UIAlertController(title: "Location Not Enabled", message: "\(appname) is not able to access location.", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
//                        UIAlertAction in
//                        self.checkforloginaccess()
//                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Enable", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        UIApplication.shared.openURL(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL)
                    })
                    self.present(alert, animated: true, completion: nil)
                })
            case .authorizedAlways, .authorizedWhenInUse:
              print("log")
                //  checkforloginaccess()
            }
        }
    }
}
