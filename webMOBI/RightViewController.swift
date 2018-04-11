//
//  RightViewController.swift
//  SlideMenuControllerSwift
//
//   Created by Webmobi on 2016/04/06.
//

import UIKit
import MBProgressHUD

enum RightMenu: Int {
    case Myschedules = 0
    case Mycompanies
    case MyNotes
    case MyChats
    case Notifications
   // case Settings
    
}
protocol RightMenuProtocol : class {
    func changeViewController(menu: RightMenu)
}



class RightViewController : UIViewController , RightMenuProtocol {
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var rightTableView: UITableView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginimg: UIImageView!
    //    var menus = ["My schedules","My companies","Rich notification","Push notification","Calendar","InBox","My Slots"]
    var menus = ["My Schedules","My Companies","My Notes","My Chats","Notifications"]
    var fontAwsomeImgs = ["calendar-check-o","calendar-check-o","sticky-note-o","commenting-o","bell","gear"]
    var mainViewController: UIViewController!
    var myschedulesViewController: UIViewController!
    var mycompaniesViewController: UIViewController!
    var notescontroller : UIViewController!
    var ChatsViewcontroller : UIViewController!
    var notificationscontroller : UIViewController!
    var mysettingscontroller : UIViewController!
    
    var hud = MBProgressHUD()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func logoutWithNotifications(notification: NSNotification){
        
        //        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.loginLabel.text = "Login"
        //self.menus = self.menus.filter{$0 != "Settings"}
        
        self.rightTableView.reloadData()
        self.view.reloadInputViews()
        self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.logoutWithNotifications(_:)), name:"LogoutNotification", object: nil)
    }
    
    func openchatUsers(notification: NSNotification){
        
        let userInfo = notification.userInfo
        guard let section  = userInfo?["section"] as? Int else{
            return
        }
        
        if let menu = RightMenu(rawValue: section) {
            self.changeViewController(menu: menu)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightTableView.separatorStyle = .none
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.logoutWithNotifications), name:NSNotification.Name(rawValue: "LogoutNotification"), object: nil)
//        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openchatUsers), name:NSNotification.Name(rawValue: "Connectchatusers"), object: nil)
        
        self.loginLabel.layer.cornerRadius = 17.5
        self.loginLabel.clipsToBounds = true
        rightTableView.tableFooterView = UIView()
        
        
        let storyboard : UIStoryboard
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        }
        else {
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        }
        
        let mainView = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.mainViewController = UINavigationController(rootViewController: mainView)
        
        let myschedulesView = storyboard.instantiateViewController(withIdentifier: "MyScheduleViewController") as! MyScheduleViewController
        self.myschedulesViewController = UINavigationController(rootViewController: myschedulesView)
        
        let mycompaniesView = storyboard.instantiateViewController(withIdentifier: "SponsorsViewController") as! SponsorsViewController
        self.mycompaniesViewController = UINavigationController(rootViewController: mycompaniesView)
        
        let notes = storyboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        self.notescontroller = UINavigationController(rootViewController: notes)
        
        let pushnotificationView = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        self.notificationscontroller = UINavigationController(rootViewController: pushnotificationView)
        
        
        let ChatsView = storyboard.instantiateViewController(withIdentifier: "UsersListForChatting") as! UsersListForChatting
        self.ChatsViewcontroller = UINavigationController(rootViewController: ChatsView)
        
//        let settingscontroller = storyboard.instantiateViewController(withIdentifier: "NewMySettingsViewController") as! NewMySettingsViewController
//        self.mysettingscontroller = UINavigationController(rootViewController: settingscontroller)
        
        
        
        self.rightTableView.registerCellClass(cellClass: BaseTableViewCell.self)
        
        loginLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RightViewController.loginUser))
        loginLabel.addGestureRecognizer(tapGesture)
    }
    
    func userregister()
    {
        let appid = self.defaults.string(forKey: "selectedappid")
        let email = self.defaults.string(forKey: "Useremail")
        let name = self.defaults.string(forKey: "name")
        
        self.hud.hide(true, afterDelay: 0)
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.labelText = "User Login..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        
        let request = NSMutableURLRequest(url: NSURL(string: ServerApis.UserRegisterUrl)! as URL)
        request.httpMethod = "POST"
        let str1 = "os=ios&timezone=+05:30&osversion=9.0&countryCode=NA&countryName=NA&cityName=NA&registrationtime=NA"
        var deviceid = ""
        if let device:String = defaults.string(forKey: "devicetoken")
        {
            deviceid = device
        }
        
        //        let deviceid = UIDevice.currentDevice().identifierForVendor?.UUIDString
        
        let str2 = "&appId="+appid!+"&email="+email!
        let postString = str1+str2+"&name="+name!+"&deviceId="+deviceid
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                self.defaults.set(false, forKey: "login")
                self.loginLabel.text = "Login"
                
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true, afterDelay: 0)
                        UIAlertView(title: "Login Failed",message:"The Internet connection appears to be offline" ,delegate: nil,cancelButtonTitle: "OK").show()
                        
                    })
                })
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                self.defaults.set(false, forKey: "login")
                self.loginLabel.text = "Login"
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
                    self.defaults.setValue((jsonResult["userId"] as? String)!, forKey: "EvntUserId")
                    self.defaults.set(true, forKey: "login")
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.defaults.set(false, forKey: "infoprivacy")
                            let name = (self.defaults.value(forKey: "name") as? String)!.characters.split{$0 == " "}.map(String.init)
                            self.loginLabel.text = "Hi " + name[0]
                            self.view.reloadInputViews()
                        })
                    })
                }else
                {
                    self.defaults.set(false, forKey: "login")
                    self.loginLabel.text = "Login"
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
                self.loginLabel.text = "Login"
                
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
    
    func refreshMethodWithNotification(notification: NSNotification){
        //        NSNotificationCenter.defaultCenter().removeObserver(self)
//        self.userregister()
    }
    
    func loginUser(sender:UITapGestureRecognizer){
        
        //        if self.defaults.boolForKey("Firstlogin")
        //        {
        if !(self.defaults.bool(forKey: "login"))
        {
            //            NSNotificationCenter.defaultCenter().removeObserver(self)
            NotificationCenter.default.addObserver(self, selector: #selector(self.refreshMethodWithNotification), name:NSNotification.Name(rawValue: "singleeventlogin"), object: nil)
            
            let WelcomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
            WelcomeScreen.modalTransitionStyle = .crossDissolve
            self.present(WelcomeScreen, animated: true, completion: nil)
        }
        
        
        //
        //        if (self.defaults.boolForKey("login") == false)
        //        {
        //            let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        //            self.presentViewController(loginController, animated: false, completion: nil)
        //
        //        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if let borderclr = defaults.string(forKey: "borderColor"){
            self.rightTableView.separatorColor = UIColor.init(hex: borderclr)
        }
        if let themeclr = defaults.string(forKey: "themeColor"){
            rightTableView.backgroundColor = UIColor.init(hex: themeclr)
            
            self.loginView.backgroundColor = UIColor.init(hex: themeclr)
        }
        
        if let strip = self.defaults.string(forKey: "selectColor"){
            
            self.loginLabel.backgroundColor = UIColor.init(hex: strip)
        }
        
        if self.defaults.bool(forKey: "login")
        {
            let name = (self.defaults.value(forKey: "name") as? String)!.characters.split{$0 == " "}.map(String.init)
            self.loginLabel.text = "Hi " + name[0]
            loginimg.isHidden = true
//            menus.append("My Settings")
        }else
        {
            loginLabel.text = "Login"
            loginimg.isHidden = false
//            menus = menus.filter{$0 != "My Settings"}
            
        }
        
        self.rightTableView.reloadData()
        
    }
    
    //    override func viewWillDisappear(animated: Bool) {
    //         NSNotificationCenter.defaultCenter().removeObserver(self)
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    let defaults = UserDefaults.standard;
    func changeViewController(menu: RightMenu) {
        self.defaults.set(false, forKey: "fromhome")
        switch menu {
        case .Myschedules:
            
            self.slideMenuController()?.changeMainViewController(self.myschedulesViewController, close: true)
            
        case .Mycompanies:
            
            self.defaults.set(true, forKey: "sponsortype")
            self.defaults.set(true, forKey: "favtype")
            let mycompaniesView = storyboard?.instantiateViewController(withIdentifier: "SponsorsViewController") as! SponsorsViewController
            mycompaniesView.title = "My Companies"
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: mycompaniesView), close: true)
        case .MyNotes:
            
            self.slideMenuController()?.changeMainViewController(self.notescontroller, close: true)
            
        case .MyChats:
            
            self.slideMenuController()?.changeMainViewController(self.ChatsViewcontroller, close: true)
            
        case .Notifications:
            
            self.slideMenuController()?.changeMainViewController(self.notificationscontroller, close: true)
            
//        case .Settings:
//            
//            self.slideMenuController()?.changeMainViewController(self.mysettingscontroller, close: true)
            
        }
    }
}

extension RightViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = RightMenu(rawValue: indexPath.item) {
            switch menu {
            case .Myschedules, .Mycompanies,  .MyNotes , .MyChats ,.Notifications   :
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
}

extension RightViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = RightMenu(rawValue: indexPath.item) {
            switch menu {
            case .Myschedules, .Mycompanies,  .MyNotes , .MyChats ,.Notifications   :
                
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(data: menus[indexPath.row])
                cell.setImg(data: fontAwsomeImgs[indexPath.row])
                return cell
                
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.defaults.bool(forKey: "login")
        {
            if(defaults.bool(forKey: "infoprivacy"))
            {
                UIAlertView(title: "Access Denied",message: "This is Private Event Please Contact Support Team",delegate: nil,cancelButtonTitle: "OK").show()
                
            }else
            {
                
                if let menu = RightMenu(rawValue: indexPath.item) {
                    self.changeViewController(menu: menu)
                }
            }
        }else
        {
            presentloginscreen()
            //UIAlertView(title: "User Not Login",message:"Please Login First" ,delegate: nil,cancelButtonTitle: "OK").show()
        }
        
    }
    func presentloginscreen() {
                var storyboard = UIStoryboard()
                if UIDevice.current.userInterfaceIdiom == .pad {
                    storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
                }
                else {
                    storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
                }
                let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
        
                self.present(vc, animated: true, completion: nil)
        
            }
    
    
}

extension RightViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.rightTableView == scrollView {
            
        }
    }
}


