//
//  AppDelegate.swift
//  webMOBI
//
//  Created by webmobi on 5/15/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let defaults = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let isMultiEvent = 0
        
        // Multievent application
        
        if isMultiEvent == 1{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard : UIStoryboard
            if UIDevice.current.userInterfaceIdiom == .pad {
                storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
            }
            else {
                storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            }
            
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MultiEventNavigationController") as! UINavigationController
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }else{
            //Discovery app - Container app
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard : UIStoryboard
            if UIDevice.current.userInterfaceIdiom == .pad {
                storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
            }
            else {
                storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            }
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationViewController") as! UINavigationController
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Register for Push Notification
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        registerForPushNotifications(application: application)
        
        if defaults.value(forKey: "isappfirsttime") != nil{
            defaults.set(false, forKey: "isappfirsttime")
        }else{
            defaults.set(true, forKey: "isappfirsttime")
        }
        
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        var bgTaskID: UIBackgroundTaskIdentifier = 0
        bgTaskID = UIApplication.shared.beginBackgroundTask() {
            bgTaskID = UIBackgroundTaskInvalid
        }
        
        
        UIApplication.shared.endBackgroundTask(bgTaskID)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        SocketIOManager.sharedInstance.establishConnection()
        SocketIOManager.sharedInstance.reconnect { (messageInfo) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                print("its connected")
            })
        }
        if let deviceID = defaults.string(forKey: "devicetoken")
        {
            resetBadge(deviceid: deviceID)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        //        self.saveContext()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if LISDKCallbackHandler.shouldHandle(url) {
            return LISDKCallbackHandler.application(application, open: url, sourceApplication: sourceApplication , annotation: annotation)
        }
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication , annotation: annotation)
        return handled
        
    }
    
    //Getting device token
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let tokenChars = UnsafePointer((deviceToken as NSData).bytes.assumingMemoryBound(to:CChar.self))
        var tokenString = ""
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        defaults.setValue(tokenString, forKey: "devicetoken")
        print("Device Token:", tokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Failed to register:", error)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "webMOBI", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("webMOBI.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    NSLog("Unresolved error \(error!), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
    func resetBadge(deviceid:String)
    {
        UIApplication.shared.applicationIconBadgeNumber = 0
        if UserDefaults.standard.value(forKey: "userlogindata") != nil{
            let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
            let token = data1["token"] as! String
            var request = URLRequest(url: URL(string: ServerApis.clearnotifyBadge)!)
            request.httpMethod = "POST"
            
            let params = ["device_id":deviceid as AnyObject] as Dictionary<String, AnyObject>
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.setValue(token, forHTTPHeaderField: "Token")
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error!)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 , httpStatus.statusCode != 200{           // check for http errors
                    print("statusCode should be 201, but is \(httpStatus.statusCode)")
                    print("response = \(response!)")
                }else{
                    
                    do {
                        let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        print("responseString = \(jsonResult) ")
                        let statusflg = jsonResult["response"] as? Bool
                        if(statusflg)!
                        {
                            
                            
                        }else
                        {
                            
                        }
                    }catch
                    {
                        //                    print(error)
                    }
                }
                
            }
            task.resume()
        }else{
            
        }
    }

}

