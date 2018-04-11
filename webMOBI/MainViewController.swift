//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//   Created by Webmobi on 2016/04/06.
//

import UIKit
import ObjectMapper
import MBProgressHUD
import ReachabilitySwift

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    let defaults = UserDefaults.standard
    
    var HomeArray = [HomeItems]()
    var HomeArray1 = [HomeItems]()
    //    var ImageData = [NSData]()
    var Tabdata = [AnyObject]()
    var count = 0
    var appurlid = ""
    
    var hud = MBProgressHUD()
    let cache = ImageLoadingWithCache()
    var timerflag = false
    var eventdate :Int64 = 0
    var reachability: Reachability?
    
    override func viewDidLoad() {
        
        
        //        if !(self.defaults.boolForKey("login"))
        //        {
        //
        //
        //            let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        //            self.presentViewController(loginController, animated: false, completion: nil)
        //        }
        
        
        
        homeCollectionView.register(UINib(nibName: "TimerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimerCollectionViewCell")
        
        
        self.setNavigationBarItem()
        
//        let appurl =  defaults.string(forKey: "selectedappurl")
        
        let appid =  defaults.string(forKey: "selectedappid")
        
        defaults.setValue(appid, forKey: "presentapp")
        
//        let version =  defaults.integer(forKey: "selectedversion")
        
//        if(!defaults.bool(forKey: "logoutflag"))
//        {
//            
//            hud = MBProgressHUD.showAdded(to: self.homeCollectionView, animated: true)
//            hud.labelText = "Checking Update..."
//            hud.minSize = CGSize(width: 150, height: 100)
//            
//            CheckNewUpdate().checkupdate(appURL: appurl!,appID: appid!,VC: self,version: version)
//        }
        updatedata()
        NotificationCenter.default.addObserver(self, selector: #selector(self.hidehudWithNotification), name:NSNotification.Name(rawValue: "hidehomehudNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataparsingWithNotification), name:NSNotification.Name(rawValue: "eventupdateNotification"), object: nil)
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.reachability = Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        startNotifier()
        if UserDefaults.standard.value(forKey: "userlogindata") != nil{
            if CoreDataManager.checkforDownloadedAppID(id: self.defaults.string(forKey: "selectedappid")!) {
                let logindetail = CoreDataManager.GetLoginDetailfromAppID(id: self.defaults.string(forKey: "selectedappid")!) as DownloadedEvents
                if logindetail.isfirstlogin == false{
                    login_user()
                }else{
                    let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
                    let name = data1["username"]! as! String
                    defaults.setValue(name, forKey: "name")

                    let logindata = CoreDataManager.GetLoginDataFromAppID(id: self.defaults.string(forKey: "selectedappid")!)
                    GetLoginData(data: logindata.data! as Data)
                }
            }else{
                print("App not Downloaded")
            }
        }else{
//            UIAlertView(title: "No login found",message:"Login Required!" ,delegate: nil,cancelButtonTitle: "OK").show()
        }
       // setupLayoutImage(self.view.window!)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func login_user() {

        let appid = self.defaults.string(forKey: "selectedappid")
        let email = self.defaults.string(forKey: "discovery_email")
        var password = self.defaults.string(forKey: "discovery_password")
        let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
        let name = data1["username"]! as! String
        let userid = data1["userId"]! as! String
        defaults.setValue(name, forKey: "name")

        self.hud.hide(true, afterDelay: 0)
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.labelText = "User Login..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        var userid_flag:String!
        if isValidEmail(testStr: email!){
            userid_flag = "false"
        }else{
            userid_flag = "true"
        }
        
        var login_url = ""
        var params : Dictionary<String, AnyObject>?
        if defaults.bool(forKey: "infoprivacy1"){
            login_url = ServerApis.UserLoginUrl
            let logindetail = CoreDataManager.GetLoginDetailfromAppID(id: appid!) as DownloadedEvents
            password = logindetail.password
            params = ["appid": appid as AnyObject,
                      "info_privacy": String(defaults.bool(forKey: "infoprivacy1")) as AnyObject,
                      "deviceType": "ios" as AnyObject,
                      "deviceId": defaults.string(forKey: "devicetoken") as AnyObject,
                      "userid_flag": userid_flag as AnyObject
                ] as Dictionary<String, AnyObject>
        }else{
            login_url = ServerApis.UserLoginUrl_public
            params = ["appid": appid as AnyObject,
                      "deviceType": "ios" as AnyObject,
                      "deviceId": defaults.string(forKey: "devicetoken") as AnyObject,
                      "username": name as AnyObject,
                      "userid": userid as AnyObject,
                      "email": email as AnyObject
                ] as Dictionary<String, AnyObject>
        }
        print(params!)
        let request = NSMutableURLRequest(url: NSURL(string: login_url)! as URL)
        request.httpMethod = "POST"

        let loginString = NSString(format: "%@:%@", email!, password!)
        let loginData: Data = loginString.data(using: String.Encoding.utf8.rawValue)!
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params!, options: [])
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                self.defaults.set(false, forKey: "login")
                
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true, afterDelay: 0)
                        UIAlertView(title: "Login Failed",message:"The Internet connection appears to be offline" ,delegate: nil,cancelButtonTitle: "OK").show()
                        
                    })
                })
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                self.defaults.set(false, forKey: "login")
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true, afterDelay: 0)
                        UIAlertView(title: "Login Failed",message:"Check connection and try again" ,delegate: nil,cancelButtonTitle: "OK").show()
                    })
                })
            }
            
            do {
                let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print("responseString = \(jsonResult) ")
                let response = (jsonResult["response"] as? Bool)!
                if(response == true)
                {
                    CoreDataManager.UpdateFirstLoginfromAppID(AppID: self.defaults.string(forKey: "selectedappid")!, isfirstlogin: true)
                    CoreDataManager.LoginDetailForAppID(appid: self.defaults.string(forKey: "selectedappid")!, data: data!)
                    let responseString = jsonResult["responseString"] as! [String: Any]
                    let notes = responseString["notes"] as! [String: Any]
                    let ratings = responseString["ratings"] as! [String: Any]
                    self.saveAllToCoreData(notes: notes, ratings: ratings)
                    let exhibitor_favorites = responseString["exhibitor_favorites"] as? [Int]
                    let appid = self.defaults.string(forKey: "selectedappid")
                    for id in exhibitor_favorites!{
                        print(id)
                        let idToStore = "\(appid!)\(id)"
                        if CoreDataManager.checkExhibitorInFavorites(id: idToStore) == false{
                            CoreDataManager.AddExhibitorToFavorites(id: idToStore, eventid: Int64(id))
                        }
                    }
                    
                    let schedules = responseString["schedules"] as? [Int]
                    for id in schedules!{
                        print(id)
                        let idToStore = "\(appid!)\(id)"
                        if CoreDataManager.checkScheduleInFavorites(id: idToStore) == false{
                            CoreDataManager.AddScheduleToFavorites(id: idToStore, eventid: Int64(id))
                        }
                    }
                    
                    let sponsor_favorites = responseString["sponsor_favorites"] as? [Int]
                    for id in sponsor_favorites!{
                        print(id)
                        let idToStore = "\(appid!)\(id)"
                        if CoreDataManager.checkSponsorsInFavorites(id: idToStore) == false{
                            CoreDataManager.AddSponsorsToFavorites(id: idToStore, eventid: Int64(id))
                        }
                    }

//                    self.defaults.setValue((responseString["schedules"] as? [Int])!, forKey: "schedules")
//                    self.defaults.setValue((responseString["sponsor_favorites"] as? [Int])!, forKey: "sponsor_favorites")
                    let token = responseString["token"] as! [String : Any]
                    self.defaults.setValue((token["token"] as? String)!, forKey: "token")
                    self.defaults.setValue((token["userId"] as? String)!, forKey: "EvntUserId")
                    self.defaults.set(true, forKey: "login")
                    self.defaults.setValue(email!, forKey: "email")
                    self.defaults.setValue(email!, forKey: "Useremail")
                    self.defaults.setValue((token["username"] as? String)!, forKey: "name")
                    
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.defaults.set(false, forKey: "infoprivacy")
                            self.view.reloadInputViews()
                           // self.dismiss(animated: true, completion: nil)
                        })
                    })
                    
                }else
                {
                    self.defaults.set(false, forKey: "login")
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                            UIAlertView(title: "Login Failed",message: jsonResult["responseString"] as! String ,delegate: nil,cancelButtonTitle: "OK").show()
                            
                        })
                    })
                    
                }
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true, afterDelay: 0)
                    })
                })
            }catch
            {
                self.defaults.set(false, forKey: "login")
                print("error")
                
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true, afterDelay: 0)
                        UIAlertView(title: "Login Failed",message:"Check connection and try again" ,delegate: nil,cancelButtonTitle: "OK").show()
                    })
                })
                
            }
            
        }
        task.resume()
        
    }
    
    func GetLoginData(data: Data) {
        let email = self.defaults.string(forKey: "discovery_email")
        do{
            let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            print("responseString = \(jsonResult) ")
            let response = (jsonResult["response"] as? Bool)!
            if(response == true)
            {
                let responseString = jsonResult["responseString"] as! [String: Any]
              //  let notes = responseString["notes"] as! [String: Any]
             //   let ratings = responseString["ratings"] as! [String: Any]
                //self.saveAllToCoreData(notes: notes, ratings: ratings)
//                self.defaults.setValue((responseString["exhibitor_favorites"] as? [Int])!, forKey: "exhibitor_favorites")
                
               // self.defaults.setValue((responseString["schedules"] as? [Int])!, forKey: "schedules")
              //  self.defaults.setValue((responseString["sponsor_favorites"] as? [Int])!, forKey: "sponsor_favorites")
                let token = responseString["token"] as! [String : Any]
                self.defaults.setValue((token["token"] as? String)!, forKey: "token")
                self.defaults.setValue((token["userId"] as? String)!, forKey: "EvntUserId")
                self.defaults.set(true, forKey: "login")
                self.defaults.setValue(email, forKey: "email")
                self.defaults.setValue(email, forKey: "Useremail")
                self.defaults.setValue((token["username"] as? String)!, forKey: "name")
                
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.defaults.set(false, forKey: "infoprivacy")
                        self.view.reloadInputViews()
                        // self.dismiss(animated: true, completion: nil)
                    })
                })
                
            }else
            {
                self.defaults.set(false, forKey: "login")
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        UIAlertView(title: "Login Failed",message: jsonResult["responseString"] as! String ,delegate: nil,cancelButtonTitle: "OK").show()
                        
                    })
                })
                
            }
        }catch
        {
            self.defaults.set(false, forKey: "login")
            print("error")
            
            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    UIAlertView(title: "Login Failed",message:"Check connection and try again" ,delegate: nil,cancelButtonTitle: "OK").show()
                })
            })
            
        }
    }
    
    func saveAllToCoreData(notes: [String:Any], ratings : [String: Any]) {
        let allagenda = notes["agenda"] as! [AnyObject]
        for agenda in allagenda{
            let agendadata = agenda as! [String: Any]
            print(agendadata["type"] as! String)
            print(Int64(agendadata["id"] as! String)!)
            print(agendadata["name"] as! String)
            print(agendadata["notes"] as! String)
            print(Int64(agendadata["last_updated"] as! String)!)
            
            let appid = self.defaults.string(forKey: "selectedappid")
            let idToStore = "\(appid!)\(agendadata["id"]!)"
            
            if CoreDataManager.checkforAgendaID(id: idToStore){
                CoreDataManager.UpdateNotesfromAgendaID(agendaID: idToStore, agendaNotes: (agendadata["notes"] as! String), agendaDidAdd: true, lastUpdated: (Int64(agendadata["last_updated"] as! String)!))
            }else{
                CoreDataManager.storeAgendaNotes(agendaID: idToStore, agendaNotes: (agendadata["notes"] as! String), agendaDidAdd: true, agendaName: (agendadata["name"] as! String), lastUpdated: (Int64(agendadata["last_updated"] as! String)!), notesType: (agendadata["type"] as! String))
            }
        }
        
        let allexhibitors = notes["exhibitors"] as! [AnyObject]
        for exhibitor in allexhibitors{
            let exhibitorsdata = exhibitor as! [String: Any]
            print(exhibitorsdata["type"] as! String)
            print(Int64(exhibitorsdata["id"] as! String)!)
            print(exhibitorsdata["name"] as! String)
            print(exhibitorsdata["notes"] as! String)
            print(Int64(exhibitorsdata["last_updated"] as! String)!)
            let appid = self.defaults.string(forKey: "selectedappid")
            let idToStore = "\(appid!)\(exhibitorsdata["id"]!)"

            if CoreDataManager.checkforExhibitorsID(id: idToStore){
                CoreDataManager.UpdateNotesfromExhibitorsID(exhibitorsID: idToStore, exhibitorsNotes: (exhibitorsdata["notes"] as! String), exhibitorsDidAdd: true, lastUpdated: (Int64(exhibitorsdata["last_updated"] as! String)!))
            }else{
                CoreDataManager.storeExhibitorsNotes(exhibitorsID: idToStore, exhibitorsNotes: (exhibitorsdata["notes"] as! String), exhibitorsDidAdd: true, exhibitorsName: (exhibitorsdata["name"] as! String), lastUpdated: (Int64(exhibitorsdata["last_updated"] as! String)!), notesType: (exhibitorsdata["type"] as! String))
            }
        }
        
        let allsponsors = notes["sponsors"] as! [AnyObject]
        for sponsor in allsponsors{
            let sponsordata = sponsor as! [String: Any]
            print(sponsordata["type"] as! String)
            print(Int64(sponsordata["id"] as! String)!)
            print(sponsordata["name"] as! String)
            print(sponsordata["notes"] as! String)
            print(Int64(sponsordata["last_updated"] as! String)!)
            let appid = self.defaults.string(forKey: "selectedappid")
            let idToStore = "\(appid!)\(sponsordata["id"]!)"

            if CoreDataManager.checkforSponsorsID(id: idToStore){
                CoreDataManager.UpdateNotesfromSponsorsID(sponsorsID: idToStore, sponsorsNotes: (sponsordata["notes"] as! String), sponsorsDidAdd: true, lastUpdated: (Int64(sponsordata["last_updated"] as! String)!))
            }else{
                CoreDataManager.storeSponsorsNotes(sponsorsID: idToStore, sponsorsNotes: (sponsordata["notes"] as! String), sponsorsDidAdd: true, sponsorsName: (sponsordata["name"] as! String), lastUpdated: (Int64(sponsordata["last_updated"] as! String)!), notesType: (sponsordata["type"] as! String))
            }
        }
        
        let allagendaratings = ratings["agenda"] as! [AnyObject]
        for agendarating in allagendaratings{
            let agendadata = agendarating as! [String: Any]
            print(agendadata["appid"] as! String)
            print(agendadata["rating"]!)
            print(agendadata["rating_id"] as! String)
            print(agendadata["rating_type"] as! String)
            print(Int64(agendadata["type_id"] as! String)!)
            print(agendadata["userid"] as! String)
            let appid = self.defaults.string(forKey: "selectedappid")
            let idToStore = "\(appid!)\((agendadata["type_id"]!))"
            
            if CoreDataManager.checkforAgendaRatingID(id: idToStore){
                CoreDataManager.UpdateRatingsfromAgendaID(type_id: idToStore, rating: (agendadata["rating"]! as! Int16))
            }else{
                CoreDataManager.storeAgendaRating(appid: idToStore, rating: Int16(round(agendadata["rating"]! as! Double)), rating_id: (agendadata["rating_id"] as! String), rating_type: (agendadata["rating_type"] as! String), type_id: (agendadata["type_id"] as! String), userid: (agendadata["userid"] as! String))
            }
        }
        
        let allspeakersratings = ratings["speakers"] as! [AnyObject]
        for speakerrating in allspeakersratings{
            let speakerdata = speakerrating as! [String: Any]
            print(speakerdata["appid"] as! String)
            print(speakerdata["rating"]!)
            print(speakerdata["rating_id"] as! String)
            print(speakerdata["rating_type"] as! String)
            print(Int64(speakerdata["type_id"] as! String)!)
            print(speakerdata["userid"] as! String)
            let appid = self.defaults.string(forKey: "selectedappid")
            let idToStore = "\(appid!)\((speakerdata["type_id"]!))"

            if CoreDataManager.checkforSpeakersRatingID(id: idToStore){
                CoreDataManager.UpdateRatingsfromSpeakersID(type_id: idToStore, rating: Int16(round(speakerdata["rating"]! as! Double)))
            }else{
                CoreDataManager.storeSpeakersRating(appid: idToStore, rating: Int16(round(speakerdata["rating"]! as! Double)), rating_id: (speakerdata["rating_id"] as! String), rating_type: (speakerdata["rating_type"] as! String), type_id: (speakerdata["type_id"] as! String), userid: (speakerdata["userid"] as! String))
            }
        }
        
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start\notifier")
            return
        }
    }

    func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            if UserDefaults.standard.bool(forKey: "didsync") == true{
                DispatchQueue.global(qos: .background).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
//                        UploadOfflineDataToServer().getAllNotesforserver()
                    })
                })
            }
            print("Reachable")
        } else {
            print("Not Reachable")
        }
    }
    
    func dataparsingWithNotification(notification: NSNotification){
        NotificationCenter.default.removeObserver(self)
        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.updatedata()
                self.homeCollectionView.reloadData()
                self.hud.hide(true)
            })
        })
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataparsingWithNotification), name:NSNotification.Name(rawValue: "eventupdateNotification"), object: nil)
    }
    
    func hidehudWithNotification(notification: NSNotification){
        NotificationCenter.default.removeObserver(self)
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.hud.hide(true)
            })
        })
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataparsingWithNotification), name:NSNotification.Name(rawValue: "eventupdateNotification"), object: nil)
        
    }
    
    func updatedata()
    {
        if let appurl = defaults.string(forKey: "selectedappurl"){
            appurlid = appurl
        }
        if let appid = defaults.string(forKey: "selectedappid"){
            let testFile1 = FileSaveHelper(fileName: appid, fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
            // 2
            do {
                let str =  try testFile1.getContentsOfFile()
                let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)
                
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary                   // use anyObj here
                    
                    if let infoprivacy : Bool = jsonResult!["info_privacy"] as? Bool
                    {
                        
                        self.defaults.set(infoprivacy, forKey: "infoprivacy1")
                        if(  self.defaults.bool(forKey: "login"))
                        {
                            self.defaults.set(false, forKey: "infoprivacy")
                        }else
                        {
                            self.defaults.set(infoprivacy, forKey: "infoprivacy")
                        }
                    }else
                    {
                        self.defaults.set(false, forKey: "infoprivacy")
                        self.defaults.set(false, forKey: "infoprivacy1")
                    }
                    
                    if let timer : Bool = jsonResult!["timer"] as? Bool
                    {
                        self.timerflag = timer
                        
                        if let givendate  = jsonResult!["startdate"] as? Int64{
                            
                            eventdate = givendate
                            
                            let presentdate = Int64(NSDate().timeIntervalSince1970*1000)
                            if(givendate > presentdate)
                            {
                                self.timerflag = true
                            }else
                            {
                                self.timerflag = false
                            }
                            
                        }else
                        {
                            self.timerflag = false
                        }
                        
                    }else
                    {
                        self.timerflag = false
                    }
                    
                    
                    self.defaults.setValue(jsonResult!["appName"] as? String, forKey: "selectedAppName")
                    
                    if let themeclor : String = jsonResult!["theme_color"] as? String
                    {
                        self.defaults.setValue(themeclor, forKey: "themeColor")
                        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclor)
                    }else
                    {
                        self.defaults.setValue("307aea", forKey: "themeColor")
                        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: "307aea",alpha: 2.0)
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
                    
                    if let data = jsonResult!["events"] as? [NSDictionary]
                    {
                        if let evntdate : Double = jsonResult!["startdate"] as? Double
                        {
                            let eventDate = TimeConversion().stringfrommilliseconds(ms: evntdate, format: "yyyy-MM-dd")
                            defaults.setValue(eventDate, forKey: "eventDate")
                        }
                        
                        //                        if let evntdate : String = data[0]["date"] as? String
                        //                        {
                        //                            self.eventdate = evntdate
                        //
                        //                            defaults.setValue(evntdate, forKey: "eventDate")
                        //
                        //                            if(self.timerflag) {
                        //                                let dateFormatter = DateFormatter()
                        //                                dateFormatter.dateFormat = "dd MMM yyyy"
                        //                                let date = dateFormatter.date(from: self.eventdate)
                        //                                let presentdate = Int64(NSDate().timeIntervalSince1970*1000)
                        //
                        //                                if(date != nil)
                        //                                {
                        //
                        //                                    let givendate = Int64(date!.timeIntervalSince1970*1000)
                        //
                        //                                    if(givendate > presentdate)
                        //                                    {
                        //                                        self.timerflag = true
                        //                                    }else
                        //                                    {
                        //                                        self.timerflag = false
                        //                                    }
                        //                                }else
                        //                                {
                        //                                    self.timerflag = false
                        //                                }
                        //                            }
                        //                        }else
                        //                        {
                        //                            self.timerflag = false
                        //                        }
                        
                        
                        let tabData = data[0]["tabs"] as! [AnyObject]
                        Tabdata = tabData
                        
                        let count = tabData.count
                        for index in 0 ..< count{
                            if Mapper<Home>().map(JSONObject:tabData[index])?.type == "home"{
                                let dataAtIndex = Mapper<Home>().map(JSONObject:tabData[index])
                                HomeArray1 = (dataAtIndex?.items!)!
                            }
                            if Mapper<AboutUs>().map(JSONObject:tabData[index])?.type == "aboutus"{
                                let aboutUsData = Mapper<AboutUs>().map(JSONObject:tabData[index])?.content!
                                defaults.set(aboutUsData, forKey: "aboutUsData")
                            }
                            if Mapper<Pdf>().map(JSONObject:tabData[index])?.type == "pdf"{
                                let dataAtIndex = Mapper<Pdf>().map(JSONObject:tabData[index])
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                                defaults.set(nsdataObj, forKey: "pdfData")
                            }
                            if Mapper<SpeakersData>().map(JSONObject:tabData[index])?.type == "speakersData"{
                                //                                let dataAtIndex = Mapper<SpeakersData>().map(JSONObject:tabData[index])?.items
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: tabData[index])
                                defaults.set(nsdataObj, forKey: "speckerData")
                            }
                            if Mapper<SpeakersData>().map(JSONObject:tabData[index])?.type == "speakersData"{
                                //                                let dataAtIndex = Mapper<SpeakersData>().map(JSONObject:tabData[index])?.items
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: tabData[index])
                                defaults.set(nsdataObj, forKey: "speakersData")
                            }
                            if Mapper<Agenda>().map(JSONObject:tabData[index])?.type == "agenda"{
                                defaults.set((tabData[index]["agenda"]!! as AnyObject).count, forKey: "AgendaCount")
                                let nsdataObj1 = NSKeyedArchiver.archivedData(withRootObject: tabData[index]["agenda"]!!)
                                defaults.set(nsdataObj1, forKey: "agendadata1")
                                
                                //                                let dataAtIndex = Mapper<Agenda>().map(tabData[index])
                                //                                let nsdataObj = NSKeyedArchiver.archivedDataWithRootObject(dataAtIndex!.agenda!)
                                //                                defaults.setObject(nsdataObj, forKey: "agendadata")
                            }
                            if Mapper<Maps>().map(JSONObject:tabData[index])?.type == "map"{
                                let dataAtIndex = Mapper<Maps>().map(JSONObject:tabData[index])
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                                defaults.set(nsdataObj, forKey: "mapData")
                            }
                            if Mapper<RssFeeds>().map(JSONObject:tabData[index])?.type == "rssfeeds"{
                                let dataAtIndex = Mapper<RssFeeds>().map(JSONObject:tabData[index])?.url!
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                                defaults.set(nsdataObj, forKey: "rssData")
                            }
                            if Mapper<SocialMedia>().map(JSONObject:tabData[index])?.type == "socialmedia"{
                                //                                let dataAtIndex = Mapper<SocialMedia>().map(JSONObject:tabData[index])?.items
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: tabData[index])
                                defaults.set(nsdataObj, forKey: "socialMediaData")
                            }
                            if Mapper<SponsorsData>().map(JSONObject:tabData[index])?.type == "sponsorsData"{
                                //                                let dataAtIndex = Mapper<SponsorsData>().map(JSONObject:tabData[index])?.items
                                let dataAtIndex = Mapper<SponsorsData>().map(JSONObject:tabData[index])
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                                defaults.set(nsdataObj, forKey: "sponsorsData")
                            }
                            if Mapper<ExhibitorsData>().map(JSONObject:tabData[index])?.type == "exhibitorsData"{
                                //                                let dataAtIndex = Mapper<ExhibitorsData>().map(JSONObject:tabData[index])?.items
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: tabData[index])
                                defaults.set(nsdataObj, forKey: "exhibitorsData")
                            }
                            if Mapper<newSurvey>().map(JSONObject:tabData[index])?.type == "survey"{
                                //                                let dataAtIndex = Mapper<Survey>().map(JSONObject:tabData[index])?.items
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: tabData[index])
                                defaults.set(nsdataObj, forKey: "surveyData")
                            }
                            if Mapper<UpcomingEventlist>().map(JSONObject:tabData[index])?.type == "eventslist"{
                                let dataAtIndex = Mapper<UpcomingEventlist>().map(JSONObject:tabData[index])?.items!
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                                defaults.set(nsdataObj, forKey: "upcomingEVentData")
                            }
                            if Mapper<Video>().map(JSONObject:tabData[index])?.type == "video"{
                                let dataAtIndex = Mapper<Video>().map(JSONObject:tabData[index])
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                                defaults.set(nsdataObj, forKey: "videoData")
                            }
                            if Mapper<Weather>().map(JSONObject:tabData[index])?.type == "weather"{
                                let dataAtIndex = Mapper<Weather>().map(JSONObject:tabData[index])
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                                defaults.set(nsdataObj, forKey: "weatherData")
                            }
                            
                            if Mapper<ContactUs>().map(JSONObject:tabData[index])?.type == "contactUs"{
                                let dataAtIndex = Mapper<ContactUs>().map(JSONObject:tabData[index])
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                                defaults.set(nsdataObj, forKey: "ContactusData")
                            }
                            
                            if Mapper<Polling>().map(JSONObject:tabData[index])?.type == "polling"{
                                //                                let dataAtIndex = Mapper<Polling>().map(JSONObject:tabData[index])?.items
                                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: tabData[index])
                                defaults.set(nsdataObj, forKey: "pollingData")
                            }
                            
                        }
                        HomeArray.removeAll()
                        //                        ImageData.removeAll()
                        self.count = 1
                        for dta in HomeArray1{
                            
                            if(dta.value!.contains("map") || dta.value!.contains("agenda") || dta.value!.contains("currency") || dta.value!.contains("aboutus") || dta.value!.contains("speakersData") || dta.value!.contains("sponsorsData")  || dta.value!.contains("contactUs") || dta.value!.contains("video")  || dta.value!.contains("survey")  || dta.value!.contains("pdf")  || dta.value!.contains("socialmedia") || dta.value!.contains("exhibitorsData")  || dta.value!.contains("eventslist") || dta.value!.contains("rssfeeds")   || dta.value!.contains("weather") || dta.value!.contains("polling") || dta.value!.contains("attendee") || dta.value!.contains("myschedule")){
                                HomeArray.append(dta)
                                
                            }else{
                                print(dta.value!)
                            }
                        }
                        
                        
                    }
                    
                } catch {
                    print("json error: \(error)")
                }
                
                
            }catch {
                print (error)
            }
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
        self.title = "Home"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDataFromUrl(url:NSURL, completion: @escaping ((_ data: NSData?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            completion(data as NSData?, response, error as NSError?)
            }.resume()
    }
    
    func getMenuId(value:String) -> String {
        
        
        for dta in Tabdata
        {
            if((dta["checkvalue"] as? String) != nil)
            {
                if((dta["checkvalue"] as? String) == value)
                {
                    return (dta["title"] as? String)!
                }
            }else {
                
                if((dta["type"] as? String) == String(value.characters.dropLast()))
                {
                    return (dta["title"] as? String)!
                }
                
            }
            
            
        }
        
        return ""
        
        
    }
    
    
    func fetchingdata(str:String)-> AnyObject
    {
        let count = Tabdata.count
        for index in 0 ..< count{
            if Mapper<AboutUs>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<Pdf>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<SpeakersData>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<Agenda>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<Maps>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<RssFeeds>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<SocialMedia>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<SponsorsData>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<ExhibitorsData>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<newSurvey>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<UpcomingEventlist>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<Video>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<Weather>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<Polling>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }else if Mapper<ContactUs>().map(JSONObject: Tabdata[index])?.checkvalue == str{
                return Tabdata[index]
            }
            
        }
        return [] as AnyObject
        
    }
    
    
    func openViewController(value:String,obj:AnyObject) {
        switch value {
        case "map":
            
            if(obj.count > 0){
                let dataAtIndex = Mapper<Maps>().map(JSONObject: obj)
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                defaults.set(nsdataObj, forKey: "mapData")
                let mapController = self.storyboard?.instantiateViewController(withIdentifier: "MapsTabBarController") as! MapsTabBarController
                mapController.title = dataAtIndex?.title
                self.navigationController?.pushViewController(mapController, animated: true)
            }            
            break
            
        case "agenda":
            if(obj.count > 0){
                let nsdataObj1 = NSKeyedArchiver.archivedData(withRootObject: obj["agenda"]!!)
                defaults.set(nsdataObj1, forKey: "agendadata1")
            }
            
            if let data = defaults.object(forKey: "agendadata1") as? NSData {
                let agenda = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [AnyObject]
//                var agendaArray1 = agenda
//                var agendaArray = Mapper<AgendaInAgenda>().mapArray(JSONObject: agenda)!
                if(agenda.count > 0){
                    let title = Mapper<Agenda>().map(JSONObject: obj)?.title
                    defaults.setValue(true, forKey: "manydates")
                    let agendaViewController = self.storyboard?.instantiateViewController(withIdentifier:
                        "NewAgendaViewController") as! NewAgendaViewController
                    agendaViewController.title = title
                    self.navigationController?.pushViewController(agendaViewController, animated: true)
                }else
                {
                    UIAlertView(title: "NO DATA",message: "Data not available",delegate: nil,cancelButtonTitle: "ok").show()
                }
            }
            
            //            defaults.setValue(true, forKey: "manydates")
            //            let agendaViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewAgendaViewController") as! NewAgendaViewController
            //            self.navigationController?.pushViewController(agendaViewController, animated: true)
            
            break
            
            
        case "currency":
            
            let currencyController = storyboard?.instantiateViewController(withIdentifier: "CurrencyConverterViewController") as! CurrencyConverterViewController
            self.navigationController?.pushViewController(currencyController, animated: true)
            break
            
        case "aboutus":
            if(obj.count > 0){
                let aboutUsData = Mapper<AboutUs>().map(JSONObject: obj)
                defaults.set(aboutUsData?.content!, forKey: "aboutUsData")
                let aboutusController = storyboard?.instantiateViewController(withIdentifier: "PresentationWebViewController") as! PresentationWebViewController
                aboutusController.title = aboutUsData?.title
                self.navigationController?.pushViewController(aboutusController, animated: true)
            }
            
            break
  
        case "speakersData":
            if(obj.count > 0){
                //                let dataAtIndex = Mapper<SpeakersData>().map(JSONObject: obj)?.items
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: obj)
                defaults.set(nsdataObj, forKey: "speakersData")
                
                let dataAtIndex1 = Mapper<SpeakersData>().map(JSONObject: obj)
                let nsdataObj1 = NSKeyedArchiver.archivedData(withRootObject: obj)
                defaults.set(nsdataObj1, forKey: "speckerData")
                let speakerController = storyboard?.instantiateViewController(withIdentifier: "SpeakerViewController") as! SpeakerViewController
                speakerController.title = dataAtIndex1?.title
                self.navigationController?.pushViewController(speakerController, animated: true)
            }
            
            break
            
        case "sponsorsData":
            if(obj.count > 0){
                //                let dataAtIndex = Mapper<SponsorsData>().map(JSONObject: obj)?.items
                let dataAtIndex = Mapper<SponsorsData>().map(JSONObject: obj)
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                defaults.set(nsdataObj, forKey: "sponsorsData")
                
                let sponsorController = storyboard?.instantiateViewController(withIdentifier: "SponsorsViewController") as! SponsorsViewController
                sponsorController.title = dataAtIndex?.title
                self.navigationController?.pushViewController(sponsorController, animated: true)
                self.defaults.set(true, forKey: "sponsortype")
                self.defaults.set(false, forKey: "favtype")
            }
            
            break
            
        case "contactUs":
            
            if(obj.count > 0){
                let dataAtIndex = Mapper<ContactUs>().map(JSONObject: obj)
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                defaults.set(nsdataObj, forKey: "ContactusData")
                let contactViewController = storyboard?.instantiateViewController(withIdentifier: "NewContactUsViewController") as! NewContactUsViewController
                contactViewController.title = dataAtIndex?.title
                self.navigationController?.pushViewController(contactViewController, animated: true)
            }
            
            
            break
            
        case "video":
            if(obj.count > 0){
                let dataAtIndex = Mapper<Video>().map(JSONObject: obj)
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                defaults.set(nsdataObj, forKey: "videoData")
                let videoController = storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
                videoController.title = dataAtIndex?.title
                self.navigationController?.pushViewController(videoController, animated: true)
            }
            
            break
            
        case "survey":
            if(obj.count > 0){
                //                let dataAtIndex = Mapper<Survey>().map(JSONObject: obj)?.items
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: obj)
                
                defaults.set(nsdataObj, forKey: "surveyData")
            }
            defaults.set(true, forKey: "fromsurvey")
            
            
            defaults.set(0, forKey: "questionno")
            if let dataFromDefaults = defaults.object(forKey: "surveyData"){
                if let dataAtIndex = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as! Data){
                    let objectFromDefaults = Mapper<newSurvey>().map(JSONObject: dataAtIndex)
                    if((objectFromDefaults?.items?.count)! > 0)
                    {
                        let surveyController = storyboard?.instantiateViewController(withIdentifier: "NewSurveyViewController") as! NewSurveyViewController
                        surveyController.title = objectFromDefaults?.title
                        self.navigationController?.pushViewController(surveyController, animated: true)
                    }else
                    {
                        UIAlertView(title: "Survey Not Available",message: "No Questions Available",delegate: nil,cancelButtonTitle: "OK").show()
                    }
                }
            }
            break
            
        case "pdf":
            if(obj.count > 0){
                let dataAtIndex = Mapper<Pdf>().map(JSONObject: obj)
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
                defaults.set(nsdataObj, forKey: "pdfData")
                let awardController = storyboard?.instantiateViewController(withIdentifier: "AwardsListViewController") as! AwardsListViewController
                awardController.title = dataAtIndex?.title
                self.navigationController?.pushViewController(awardController, animated: true)
            }
            
            break
            
        case "Social":
            if(obj.count > 0){
                let dataAtIndex = Mapper<SocialMedia>().map(JSONObject: obj)
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: obj)
                defaults.set(nsdataObj, forKey: "socialMediaData")
                let socialController = storyboard?.instantiateViewController(withIdentifier: "SocialMediaViewController") as! SocialMediaViewController
                socialController.title = dataAtIndex?.title
                self.navigationController?.pushViewController(socialController, animated: true)
            }
            
            break
            
        case "socialmedia":
            if(obj.count > 0){
                let dataAtIndex = Mapper<SocialMedia>().map(JSONObject: obj)
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: obj)
                defaults.set(nsdataObj, forKey: "socialMediaData")
                let socialController = storyboard?.instantiateViewController(withIdentifier: "SocialMediaViewController") as! SocialMediaViewController
                socialController.title = dataAtIndex?.title
                self.navigationController?.pushViewController(socialController, animated: true)
            }
            
            break
            
        case "exhibitorsData":
            if(obj.count > 0){
                let dataAtIndex = Mapper<ExhibitorsData>().map(JSONObject: obj)
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: obj)
                defaults.set(nsdataObj, forKey: "exhibitorsData")
                let exhibitorController = storyboard?.instantiateViewController(withIdentifier: "SponsorsViewController") as! SponsorsViewController
                exhibitorController.title = dataAtIndex?.title
                self.navigationController?.pushViewController(exhibitorController, animated: true)
                self.defaults.set(false, forKey: "sponsortype")
                self.defaults.set(true, forKey: "favtype")
            }
            
            break
            
        case "rssfeeds":
            if(obj.count > 0){
                let dataAtIndex = Mapper<RssFeeds>().map(JSONObject: obj)
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!.url!)
                defaults.set(nsdataObj, forKey: "rssData")
                let rssController = storyboard?.instantiateViewController(withIdentifier: "RssFeedsViewController") as! RssFeedsViewController
                rssController.title = dataAtIndex?.title
                self.navigationController?.pushViewController(rssController, animated: true)
            }
            
            break
        case "eventslist":
            if(obj.count > 0){
                let dataAtIndex = Mapper<UpcomingEventlist>().map(JSONObject: obj)
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!.items!)
                defaults.set(nsdataObj, forKey: "upcomingEVentData")
                let upcomingController = storyboard?.instantiateViewController(withIdentifier: "UpcomingEventsTableViewController") as! UpcomingEventsTableViewController
                upcomingController.title = dataAtIndex?.title
                self.navigationController?.pushViewController(upcomingController, animated: true)
            }
            
            break
        case "polling":
            if(obj.count > 0){
                let dataAtIndex = Mapper<Polling>().map(JSONObject: obj)
                let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: obj)
                defaults.set(nsdataObj, forKey: "pollingData")
                defaults.set(false, forKey: "fromsurvey")
                
                let pollingController = storyboard?.instantiateViewController(withIdentifier: "PollingListTableViewController") as! PollingListTableViewController
                pollingController.title = dataAtIndex?.title
                self.navigationController?.pushViewController(pollingController, animated: true)
            }
            break
            
        case "attendee":
            
            
            if self.defaults.bool(forKey: "login")
            {
                let UsersList = storyboard?.instantiateViewController(withIdentifier: "AttendeeListViewController") as! AttendeeListViewController
                self.navigationController?.pushViewController(UsersList, animated: true)
            }else
            {
               // presentloginscreen()
               UIAlertView(title: "Please Login",message: "Please Login and try again",delegate: nil,cancelButtonTitle: "OK").show()
            }
            break
        case "mySchedule":
            if self.defaults.bool(forKey: "login")
            {
                let mySchedule = storyboard?.instantiateViewController(withIdentifier: "MyScheduleViewController") as! MyScheduleViewController
                self.navigationController?.pushViewController(mySchedule, animated: true)
            }else
            {
              //  presentloginscreen()
               UIAlertView(title: "Please Login",message: "Please Login and try again",delegate: nil,cancelButtonTitle: "OK").show()
            }
            break
        default: break
            
            
        }
    }
    
//    func presentloginscreen() {
//        var storyboard = UIStoryboard()
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
//        }
//        else {
//            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
//        }
//        let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
//
//        self.present(vc, animated: true, completion: nil)
//
//    }
//
}



extension MainViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        //        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        //        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        //        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        //        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        //        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        //        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        //        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        //        print("SlideMenuControllerDelegate: rightDidClose")
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func individualWidthGivenTotalItems(numberOfItems: CGFloat) -> CGFloat {
        
        if numberOfItems == 0 {
            return 0
        }
        let collectionViewWidth = homeCollectionView.bounds.size.width
        let inset: CGFloat = 5.0
        let width: CGFloat = floor((collectionViewWidth - (numberOfItems - 1) * inset - 15 ) / numberOfItems)
        return width
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(self.timerflag == false)
        {
            return HomeArray.count
        }else
        {
            return HomeArray.count+1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if(self.timerflag == false)
        {
            
            let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath as IndexPath) as! HomeCollectionViewCell
            
            
            cell.TitleLabel.text = getMenuId(value: (HomeArray[indexPath.row].value!))
            cell.oddcellTitleLabel.text = getMenuId(value: (HomeArray[indexPath.row].value!))
            
            let stripclr = defaults.string(forKey: "stripColor")
            
            cell.oddcellTitleLabel.backgroundColor = UIColor.init(hex: stripclr!,alpha: 0.8)
            
            cell.titleimage.image = cell.titleimage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.titleimage.tintColor = UIColor.init(hex: stripclr!,alpha: 0.8)
            
            let urlstring = HomeArray[indexPath.row].imageUrl
            if(urlstring != nil)
            {
                if(urlstring!.length > 0)
                {
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        ImageLoadingWithCache().getImage(url: urlstring!, imageView:  cell.HomeImageView, defaultImage: (String((self.HomeArray[indexPath.row].value!).characters.dropLast())+"0"))
                    })
                }else
                {
                    DispatchQueue.main.async(execute: { () -> Void in
                        cell.HomeImageView.image = UIImage(named: (String((self.HomeArray[indexPath.row].value!).characters.dropLast())+"0"))
                    })
                }
                
            }else
            {
                DispatchQueue.main.async(execute: { () -> Void in
                    cell.HomeImageView.image = UIImage(named: (String((self.HomeArray[indexPath.row].value!).characters.dropLast())+"0"))
                })
            }
            
            
            
            cell.layer.cornerRadius = 10
            
            count += 1
            cell.titleimage.isHidden = true
            cell.TitleLabel.isHidden = true
            cell.oddcellTitleLabel.isHidden = false
            
            //            if(HomeArray.count % 2 == 0)
            //            {
            //                if( indexPath.row == 0 || indexPath.row == HomeArray.count - 1 )
            //                {
            //
            //                    cell.titleimage.hidden = true
            //                    cell.TitleLabel.hidden = true
            //                    cell.oddcellTitleLabel.hidden = false
            //
            //                }else
            //                {
            //                    cell.titleimage.hidden = false
            //                    cell.TitleLabel.hidden = false
            //                    cell.oddcellTitleLabel.hidden = true
            //                }
            //            }else
            //            {
            //                if( indexPath.row == 0 )
            //                {
            //                    cell.titleimage.hidden = true
            //                    cell.TitleLabel.hidden = true
            //                    cell.oddcellTitleLabel.hidden = false
            //
            //                }else
            //                {
            //                    cell.titleimage.hidden = false
            //                    cell.TitleLabel.hidden = false
            //                    cell.oddcellTitleLabel.hidden = true
            //                }
            //
            //            }
            
            
            return cell
            
            
        }else
        {
            if(indexPath.row < HomeArray.count)
            {
                let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath as IndexPath) as! HomeCollectionViewCell
                
                
                cell.TitleLabel.text = getMenuId(value: (HomeArray[indexPath.row].value!))
                cell.oddcellTitleLabel.text = getMenuId(value: (HomeArray[indexPath.row].value!))
                let stripclr = defaults.string(forKey: "stripColor")
                
                cell.oddcellTitleLabel.backgroundColor = UIColor.init(hex: stripclr!,alpha: 0.8)
                
                cell.titleimage.image = cell.titleimage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                cell.titleimage.tintColor = UIColor.init(hex: stripclr!,alpha: 0.8)
                
                let urlstring = HomeArray[indexPath.row].imageUrl
                
                if(urlstring != nil)
                {
                    if(urlstring!.length > 0)
                    {
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            ImageLoadingWithCache().getImage(url: urlstring!, imageView:  cell.HomeImageView, defaultImage: (String((self.HomeArray[indexPath.row].value!).characters.dropLast())+"0"))
                        })
                    }else
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            cell.HomeImageView.image = UIImage(named: (String((self.HomeArray[indexPath.row].value!).characters.dropLast())+"0"))
                        })
                    }
                    
                }else
                {
                    DispatchQueue.main.async(execute: { () -> Void in
                        cell.HomeImageView.image = UIImage(named: (String((self.HomeArray[indexPath.row].value!).characters.dropLast())+"0"))
                    })
                }
                
                
                
                cell.layer.cornerRadius = 10
                
                count += 1
                
                cell.titleimage.isHidden = true
                cell.TitleLabel.isHidden = true
                cell.oddcellTitleLabel.isHidden = false
                
                //                if(HomeArray.count % 2 == 0)
                //                {
                //                    if( indexPath.row == 0 || indexPath.row == HomeArray.count - 1 )
                //                    {
                //                        cell.titleimage.hidden = true
                //                        cell.TitleLabel.hidden = true
                //                        cell.oddcellTitleLabel.hidden = false
                //                    }else
                //                    {
                //                        cell.titleimage.hidden = false
                //                        cell.TitleLabel.hidden = false
                //                        cell.oddcellTitleLabel.hidden = true
                //                    }
                //                }else
                //                {
                //                    if( indexPath.row == 0 )
                //                    {
                //                        cell.titleimage.hidden = true
                //                        cell.TitleLabel.hidden = true
                //                        cell.oddcellTitleLabel.hidden = false
                //
                //                    }else
                //                    {
                //                        cell.titleimage.hidden = false
                //                        cell.TitleLabel.hidden = false
                //                        cell.oddcellTitleLabel.hidden = true
                //                    }
                //
                //                }
                
                
                
                return cell
            }else
            {
                let cell: TimerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimerCollectionViewCell", for: indexPath as IndexPath) as! TimerCollectionViewCell
                
                if let themeclr = defaults.string(forKey: "themeColor"){
                    cell.changecolor(color: themeclr)
                }
                
                cell.timer(StartDate: eventdate)
                
                return cell
            }
            
            
            
        }
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if(self.timerflag == false)
        {
            
            if(defaults.bool(forKey: "infoprivacy"))
            {
                UIAlertView(title: "Access Denied",message: "This is Private Event Please Contact Support Team",delegate: nil,cancelButtonTitle: "OK").show()
                
            }else
            {
                self.defaults.set(true, forKey: "fromhome")
                
                if(getMenuId(value: (HomeArray[indexPath.row].value!)).length > 0)
                {
                    let typeString = String((HomeArray[indexPath.row].value!).characters.dropLast())
                    
                    let selectobj = fetchingdata(str: HomeArray[indexPath.row].value!)
                    
                    openViewController(value: typeString,obj: selectobj)
                }
            }
            return true
        }else
        {
            if(indexPath.row < HomeArray.count)
            {
                if(defaults.bool(forKey: "infoprivacy"))
                {
                    if self.defaults.bool(forKey: "Firstlogin")
                    {
                        UIAlertView(title: "Access Denied",message: "This is Private Event Please Contact Support Team",delegate: nil,cancelButtonTitle: "OK").show()
                    }else
                    {
                        UIAlertView(title: "Please Login",message: "Please Login and try again",delegate: nil,cancelButtonTitle: "OK").show()
                    }
                    
                }else
                {
                    self.defaults.set(true, forKey: "fromhome")
                    
                    if(getMenuId(value: (HomeArray[indexPath.row].value!)).length > 0)
                    {
                        let typeString = String((HomeArray[indexPath.row].value!).characters.dropLast())
                        
                        let selectobj = fetchingdata(str: HomeArray[indexPath.row].value!)
                        
                        openViewController(value: typeString,obj: selectobj)
                    }
                }
                return true
            }
            else
            {
                return true
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = CGSize(width: 0, height: 0)
        if(self.timerflag == false)
        {
            
            if(HomeArray.count % 2 == 0)
            {
                if( indexPath.row == 0 || indexPath.row == HomeArray.count - 1 )
                {
                    let numberOfCells: CGFloat = 1
                    
                    let width = individualWidthGivenTotalItems(numberOfItems: numberOfCells)
                    
                    if(indexPath.row == HomeArray.count - 1 ){
                        cellSize = CGSize(width: width + 5, height: width * 2 / 5)
                    }else
                    {
                        cellSize = CGSize(width: width, height: width * 2 / 5)
                    }
                }else
                {
                    let numberOfCells: CGFloat = 2
                    
                    let width = individualWidthGivenTotalItems(numberOfItems: numberOfCells)
                    
                    cellSize = CGSize(width: width, height: width * 2 / 3)
                }
            }else
            {
                if( indexPath.row == 0 )
                {
                    let numberOfCells: CGFloat = 1
                    
                    let width = individualWidthGivenTotalItems(numberOfItems: numberOfCells)
                    
                    cellSize = CGSize(width: width, height: width * 2 / 5)
                }else
                {
                    let numberOfCells: CGFloat = 2
                    
                    let width = individualWidthGivenTotalItems(numberOfItems: numberOfCells)
                    
                    cellSize = CGSize(width: width, height: width * 2 / 3)
                }
                
            }
            
            return cellSize
        }else
        {
            if(indexPath.row < HomeArray.count)
            {
                if(HomeArray.count % 2 == 0)
                {
                    if( indexPath.row == 0 || indexPath.row == HomeArray.count - 1 )
                    {
                        let numberOfCells: CGFloat = 1
                        
                        let width = individualWidthGivenTotalItems(numberOfItems: numberOfCells)
                        
                        if(indexPath.row == HomeArray.count - 1 ){
                            cellSize = CGSize(width: width + 5, height: width * 2 / 5)
                        }else
                        {
                            cellSize = CGSize(width: width, height: width * 2 / 5)
                        }
                    }else
                    {
                        let numberOfCells: CGFloat = 2
                        
                        let width = individualWidthGivenTotalItems(numberOfItems: numberOfCells)
                        
                        cellSize = CGSize(width: width, height: width * 2 / 3)
                    }
                }else
                {
                    if( indexPath.row == 0 )
                    {
                        let numberOfCells: CGFloat = 1
                        
                        let width = individualWidthGivenTotalItems(numberOfItems: numberOfCells)
                        
                        cellSize = CGSize(width: width, height: width * 2 / 5)
                    }else
                    {
                        let numberOfCells: CGFloat = 2
                        
                        let width = individualWidthGivenTotalItems(numberOfItems: numberOfCells)
                        
                        cellSize = CGSize(width: width, height: width * 2 / 3)
                    }
                    
                }
                
                return cellSize
                
            }else
            {
                let numberOfCells: CGFloat = 1
                
                let width = individualWidthGivenTotalItems(numberOfItems: numberOfCells)
                
                cellSize = CGSize(width: width, height: width * 2 / 5)
                
                return cellSize
            }
            
        }
    }
}









