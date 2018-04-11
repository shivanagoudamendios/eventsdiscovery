//
//  ConnectToSE.swift
//  webMOBI
//
//  Created by Gnani Naidu on 7/20/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import Foundation
public class ConnectToSE{
    let defaults = UserDefaults.standard
    func openMethodWithNotification(filekey : String, parent : UIViewController){
        
        
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
        
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor.white
        
        self.defaults.set(filekey, forKey: "selectedappid")
        
        let testFile1 = FileSaveHelper(fileName: filekey, fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
        // 2
        do {
            let str =  try testFile1.getContentsOfFile()
            let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary                   // use anyObj here
                if let version : Int = jsonResult!["version"] as? Int
                {
                    self.defaults.set(version, forKey: "selectedversion")
                }
                
                if let version : Double = jsonResult!["startdate"] as? Double
                {
                    self.defaults.set(version, forKey: "startdate")
                }
                
                if let version : Double = jsonResult!["enddate"] as? Double
                {
                    self.defaults.set(version, forKey: "enddate")
                }
                
                if let infoprivacy : Bool = jsonResult!["info_privacy"] as? Bool
                {
                    self.defaults.set(infoprivacy, forKey: "infoprivacy")
                    print("privacy ",infoprivacy)
                }else
                {
                    self.defaults.set(false, forKey: "infoprivacy")
                    print("privacy ",false)
                }
                
                if let themeclor : String = jsonResult!["theme_color"] as? String
                {
                    self.defaults.setValue(themeclor, forKey: "themeColor")
                    nvc.navigationBar.barTintColor = UIColor.init(hex: themeclor)
                }else
                {
                    self.defaults.setValue("307aea", forKey: "themeColor")
                    nvc.navigationBar.barTintColor = UIColor.init(hex: "307aea",alpha: 2.0)
                }
                
                if let borderclor : String = jsonResult!["theme_border"] as? String
                {
                    self.defaults.setValue(borderclor, forKey: "borderColor")
                }else
                {
                    self.defaults.setValue("FFFFFF", forKey: "borderColor")
                }
                if let stripscolr : String = jsonResult!["theme_strips"] as? String
                {
                    self.defaults.setValue(stripscolr, forKey: "stripColor")
                }else
                {
                    self.defaults.setValue("0000FF", forKey: "stripColor")
                }
                if let selectcolr : String = jsonResult!["theme_selected"] as? String
                {
                    self.defaults.setValue(selectcolr, forKey: "selectColor")
                }else
                {
                    self.defaults.setValue("004776", forKey: "selectColor")
                }
                
                
            } catch {
                print("json error: \(error)")
            }
            
            
        }catch {
            print (error)
        }
        
        
        //        if self.defaults.bool(forKey: "Firstlogin")
        //        {
        //            EvntRegister().eventRigister()
        //        }else
        //        {
        //            self.defaults.set(false, forKey: "login")
        //            print("not login")
        //        }
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        let xx:AppDelegate = AppDelegate()
        
        xx.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        //        xx.window?.rootViewController = slideMenuController
        //        xx.window?.makeKeyAndVisible()
        //        self.navigationController?.pushViewController(slideMenuController, animated: true)
        parent.present(slideMenuController, animated: true, completion: nil)
        
    }
    
}
