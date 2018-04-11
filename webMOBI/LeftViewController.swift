//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
// Created by Webmobi on 2016/04/06.
//

import UIKit
import ObjectMapper
import MBProgressHUD

enum LeftMenu: Int {
    
    case Back = 0
    case Home
    case Agenda
    case AboutUs
    case Exhibitor
    case Maps
    case Awards
    case Speakers
    case WelcomefromChairman
    case UpcomingEvents
    case CurrencyConverter
    case News
    case SocialMedia
    case Sponsors
    case Weather
    case Survey
    case polling
    case ActivityFeed
}
protocol LeftMenuProtocol : class {
    func changeViewController(menu: String,ind:Int)
}

class LeftViewController : UIViewController, LeftMenuProtocol{
//    @IBOutlet weak var previewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var eventbriefheight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var listForTheMenu : [String] = []
    var listForTheMenu1 : [String] = []
    var listForiconCls : [String] = []
    var menus : [String] = [String]()
    
    
    //var selectedAppName = UserDefaults.standard.string(forKey: "selectedAppName")
    var presentverion = 0
    var  presentappurl = ""
    var presentappid = ""
    var hud = MBProgressHUD()
    
    var typedata = [AnyObject]()
    
    //        ["BackEvents","Home","Agenda","About Us","Exhibitor","Map","Awards","Speakers","Welcome from Chairman","Upcoming Events","Currency Converter","News","Social Media","Sponsors","Weather","Survey"]
    var mainViewController: UIViewController!
    var agendaViewController: UIViewController!
    var aboutUsController: UIViewController!
    var exhibitorViewController : UIViewController!
    var NewimageHeaderView: UIView!
    var mapsViewController : UIViewController!
    var awardsViewController : UIViewController!
    var speakerViewcontroller : UIViewController!
    var welcomeFromChairman : UIViewController!
    var upcomingEvents : UIViewController!
    var currencyConvert : UIViewController!
    var newsController : UIViewController!
    var socialMediaController : UIViewController!
    var sponsorsViewController : UIViewController!
    var weatherViewController : UIViewController!
    var surveyController : UIViewController!
    var contactUsController : UIViewController!
    var mybadgeController : UIViewController!
    var inboxViewcontroller : UIViewController!
    var pollinglistController : UIViewController!
    var supportViewController : UIViewController!
     var activityFeedViewController : UIViewController!
    var leaderboardViewController : UIViewController!

       let  preview_flag = UserDefaults.standard.string(forKey: "preview")
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewWillAppear(_ animated: Bool) {
     
        if(preview_flag == "1"){
            self.previewView.isHidden = false
        } else {
            self.previewView.isHidden = true
        }
     }
    
    let previewView : UILabel = {
        let labelView = UILabel()
        labelView.text = "You're in preview mode"
        labelView.textColor = UIColor.white
        labelView.backgroundColor = UIColor.red
        labelView.textAlignment = .center
        return labelView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         tableView.tableFooterView = UIView()
        
        if let borderclr = defaults.string(forKey: "borderColor"){
            self.tableView.separatorColor = UIColor.init(hex: borderclr)
        }
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.tableView.backgroundColor = UIColor.init(hex: themeclr)
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
      
        }
        
       tableView.separatorStyle = .none
        
        
        let storyboard : UIStoryboard
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        }
        else {
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        }
        let contactViewController = storyboard.instantiateViewController(withIdentifier: "NewContactUsViewController") as! NewContactUsViewController
        self.contactUsController = UINavigationController(rootViewController: contactViewController)
        
        let agendaViewController = storyboard.instantiateViewController(withIdentifier: "NewAgendaViewController") as! NewAgendaViewController
        self.agendaViewController = UINavigationController(rootViewController: agendaViewController)

        let aboutusController = storyboard.instantiateViewController(withIdentifier: "PresentationWebViewController") as! PresentationWebViewController
        self.aboutUsController = UINavigationController(rootViewController: aboutusController)
        
        let exhibitorController = storyboard.instantiateViewController(withIdentifier: "SponsorsViewController") as! SponsorsViewController
        self.exhibitorViewController = UINavigationController(rootViewController: exhibitorController)
        
        let mapController = storyboard.instantiateViewController(withIdentifier: "MapsTabBarController") as! MapsTabBarController
        self.mapsViewController = UINavigationController(rootViewController: mapController)
        
        let awardController = storyboard.instantiateViewController(withIdentifier: "AwardsListViewController") as! AwardsListViewController
        self.awardsViewController = UINavigationController(rootViewController: awardController)
        
        let speakerController = storyboard.instantiateViewController(withIdentifier: "SpeakerViewController") as! SpeakerViewController
        self.speakerViewcontroller = UINavigationController(rootViewController: speakerController)
        
        let videoController = storyboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        self.welcomeFromChairman = UINavigationController(rootViewController: videoController)
        
        let upcomingController = storyboard.instantiateViewController(withIdentifier: "UpcomingEventsTableViewController") as! UpcomingEventsTableViewController
        self.upcomingEvents = UINavigationController(rootViewController: upcomingController)
        
        let currencyController = storyboard.instantiateViewController(withIdentifier: "CurrencyConverterViewController") as! CurrencyConverterViewController
        self.currencyConvert = UINavigationController(rootViewController: currencyController)
        
        let rssController = storyboard.instantiateViewController(withIdentifier: "RssFeedsViewController") as! RssFeedsViewController
        self.newsController = UINavigationController(rootViewController: rssController)
        
        let socialController = storyboard.instantiateViewController(withIdentifier: "SocialMediaViewController") as! SocialMediaViewController
        self.socialMediaController = UINavigationController(rootViewController: socialController)
        
        let sponsorController = storyboard.instantiateViewController(withIdentifier: "SponsorsViewController") as! SponsorsViewController
        self.sponsorsViewController = UINavigationController(rootViewController: sponsorController)
        
        let weatherController = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        self.weatherViewController = UINavigationController(rootViewController: weatherController)
        
        let surveyController = storyboard.instantiateViewController(withIdentifier: "NewSurveyViewController") as! NewSurveyViewController
        self.surveyController = UINavigationController(rootViewController: surveyController)
        
        let badgeController = storyboard.instantiateViewController(withIdentifier: "QRCodeViewController") as! QRCodeViewController
        self.mybadgeController = UINavigationController(rootViewController: badgeController)
        
        let pollinglist = storyboard.instantiateViewController(withIdentifier: "PollingListTableViewController") as! PollingListTableViewController
        self.pollinglistController = UINavigationController(rootViewController: pollinglist)
        
        let inboxcontroller = storyboard.instantiateViewController(withIdentifier: "AttendeeListViewController") as! AttendeeListViewController
        self.inboxViewcontroller = UINavigationController(rootViewController: inboxcontroller)

        let supportController = storyboard.instantiateViewController(withIdentifier: "ContactUsForMultievents") as! ContactUsForMultievents
        self.supportViewController = UINavigationController(rootViewController: supportController)
        
        self.tableView.registerCellClass(cellClass: BaseTableViewCell.self)
        // Gamification
        let leaderController = storyboard.instantiateViewController(withIdentifier: "LeaderBoardViewController") as! LeaderBoardViewController
        self.leaderboardViewController = UINavigationController(rootViewController : leaderController)
        
        
        
        let activityController = storyboard.instantiateViewController(withIdentifier: "ActivityFeedsViewController") as! ActivityFeedsViewController
        self.activityFeedViewController = UINavigationController(rootViewController: activityController)
        dataParsing()
        
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.labelText = "Checking Update..."
//        hud.minSize = CGSize(width: 150, height: 100)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.hidehudWithNotification), name:NSNotification.Name(rawValue: "hidehomehudNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataparsingWithNotification), name:NSNotification.Name(rawValue: "eventupdateNotification"), object: nil)
        
    }
    
    
    func hidehudWithNotification(notification: NSNotification){
        NotificationCenter.default.removeObserver(self)
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataparsingWithNotification), name:NSNotification.Name(rawValue: "eventupdateNotification"), object: nil)
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.hud.hide(true)
            })
        })
        
    }
    
    func dataparsingWithNotification(notification: NSNotification){
        NotificationCenter.default.removeObserver(self)
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataparsingWithNotification), name:NSNotification.Name(rawValue: "eventupdateNotification"), object: nil)
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.dataParsing()
                self.hud.hide(true)
                
            })
        })
    }
    
    func dataParsing()
    {
       
//        if(defaults.string(forKey: "preview") == "1"){
//            listForTheMenu  = ["This is Preview ","Back To webMOBI"]
//            listForTheMenu1  = ["This is Preview","Back To webMOBI"]
//          } else {
        listForTheMenu  = ["Back To webMOBI"]
        listForTheMenu1  = ["Back To webMOBI"]

//        }
        listForiconCls = ["arrow-left"]
        typedata.removeAll()
        let appid = defaults.string(forKey: "selectedappid")
        
        let testFile1 = FileSaveHelper(fileName: appid!, fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
        
        // 2
        do {
            let str =  try testFile1.getContentsOfFile()
            let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary                   // use anyObj here
                
                if let version : Double = jsonResult!["startdate"] as? Double
                {
                    self.defaults.set(version, forKey: "startdate")
                }
                
                if let version : Double = jsonResult!["enddate"] as? Double
                {
                    self.defaults.set(version, forKey: "enddate")
                }
                
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
                
                
                presentverion = (jsonResult!["version"] as? Int)!
                presentappurl = (jsonResult!["appUrl"] as? String)!
                presentappid = (jsonResult!["appId"] as? String)!
                if let data = jsonResult!["events"] as? [NSDictionary]
                {
                    let tabData = data[0]["tabs"] as! [AnyObject]
                    
                    //                    typedata = tabData as! [AnyObject]
                    
                    let count = tabData.count
                    for index in 0 ..< count{
                        
                        let tab = Mapper<Tabs>().map(JSONObject: tabData[index])!
                        if(tab.type! == "home" || tab.type! == "map" || tab.type! == "agenda" || tab.type! == "currency" || tab.type! == "aboutus" || tab.type! == "speakersData" || tab.type! == "sponsorsData" || tab.type! == "contactUs" || tab.type! == "video" || tab.type! == "survey" || tab.type! == "pdf" || tab.type! == "socialmedia" || tab.type! == "exhibitorsData" || tab.type! == "eventslist" || tab.type! == "rssfeeds" || tab.type! == "weather" || tab.type! == "attendee" || tab.type! == "polling" || tab.type! == "webmobieventapp" || tab.type! == "Mybadge" || tab.type! == "feeds" || tab.type! == "gamification"){
                            listForTheMenu.append(tab.type!)
                            listForTheMenu1.append(tab.title!)
                            listForiconCls.append(tab.iconCls!)
                            typedata.append(tabData[index])
                        }else{
                            print(tab.title!)
                        }
                        
                    }
//                    listForTheMenu.append("Mybadge")
//                    listForTheMenu1.append("My badge")
//                    
//                    listForTheMenu.append("webmobieventapp")
//                    listForTheMenu1.append("webMOBI event app")
                    
                    listForTheMenu.append("Refresh")
                    listForTheMenu1.append("Refresh App")
                    listForiconCls.append("refresh")
                }
                
            } catch {
                print("json error: \(error)")
            }
            
            
        }catch {
            print (error)
        }
        
        menus = listForTheMenu
        tableView.reloadData()
        self.NewimageHeaderView = NewImageHeaderView.loadNib()
        self.view.addSubview(self.NewimageHeaderView)
        
       
        
        self.view.addSubview(self.previewView)
        
        if let borderclr = defaults.string(forKey: "borderColor"){
            self.tableView.separatorColor = UIColor.init(hex: borderclr)
        }
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.tableView.backgroundColor = UIColor.init(hex: themeclr)
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.NewimageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: (self.view.frame.width/2))
        
        let preview_flag = self.defaults.string(forKey: "preview")
        if(preview_flag == "1"){
            self.previewView.isHidden = false
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.previewView.frame = CGRect(x: 0, y: 140, width: self.view.frame.width, height: (self.view.frame.width/6))
                self.eventbriefheight.constant = (self.view.frame.width/2) + 40
            } else {
                self.previewView.frame = CGRect(x: 0, y: 115, width: self.view.frame.width, height: (self.view.frame.width/6))
                self.eventbriefheight.constant = (self.view.frame.width/2) + 30
               
            }
            // self.defaults.set(false, forKey: "preview")
        } else {
            
        self.previewView.isHidden = true
        self.eventbriefheight.constant = (self.view.frame.width/2)
        }
        self.view.layoutIfNeeded()
        
        
    }
    let defaults = UserDefaults.standard;
    func changeViewController(menu: String,ind:Int) {
        viewDidLayoutSubviews()
        var obj: AnyObject
        if(ind > 1)
        {
            obj = MappingData().Fetchdata(index: ind-1,dataobj: typedata)
        }else
        {
            obj = [] as AnyObject
        }
        if menu == "feeds"{
            FeedsSockets.sharedInstance.establishConnection()
        }else{
            if FeedsSockets.sharedInstance.socket.status == .connected {
                FeedsSockets.sharedInstance.closeConnection()
            }
        }
        
        self.defaults.set(false, forKey: "fromhome")
        switch menu {
            
        case "Back To webMOBI":
                    slideMenuController()?.closeLeftNonAnimation()
                    self.dismiss(animated: true, completion: nil)
        case "home":
            
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case "agenda":
            let nsdataObj1 = NSKeyedArchiver.archivedData(withRootObject: obj["agenda"]!!)
            defaults.set(nsdataObj1, forKey: "agendadata1")
            
            if let data = defaults.object(forKey: "agendadata1") as? NSData {
                let agenda = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [AnyObject]
//                var agendaArray1 = agenda
//                var agendaArray = Mapper<AgendaInAgenda>().mapArray(JSONObject: agenda)!
                let title = Mapper<Agenda>().map(JSONObject: obj)?.title
                if(agenda.count > 0){
                    defaults.setValue(true, forKey: "manydates")                    
                    let agendaViewController = storyboard?.instantiateViewController(withIdentifier: "NewAgendaViewController") as! NewAgendaViewController
                    agendaViewController.title = title
                    self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: agendaViewController), close: true)
                }else
                {
                    UIAlertView(title: "NO DATA",message: "Data not available",delegate: nil,cancelButtonTitle: "ok").show()
                }
            }
            
        case "aboutus":
            let aboutUsData = Mapper<AboutUs>().map(JSONObject: obj)
            defaults.set(aboutUsData?.content!, forKey: "aboutUsData")
            
            let aboutusController = storyboard?.instantiateViewController(withIdentifier: "PresentationWebViewController") as! PresentationWebViewController
            aboutusController.title = aboutUsData?.title!
            //            self.aboutUsController = UINavigationController(rootViewController: aboutusController)
            
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: aboutusController), close: true)
        case "exhibitorsData":
            self.defaults.set(false, forKey: "sponsortype")
            self.defaults.set(true, forKey: "favtype")
            
            let dataAtIndex = Mapper<ExhibitorsData>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: obj)
            defaults.set(nsdataObj, forKey: "exhibitorsData")
            
            let exhibitorController = storyboard?.instantiateViewController(withIdentifier: "SponsorsViewController") as! SponsorsViewController
            exhibitorController.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: exhibitorController), close: true)
            
        case "map":
            let dataAtIndex = Mapper<Maps>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
            defaults.set(nsdataObj, forKey: "mapData")
            
            let mapController = storyboard?.instantiateViewController(withIdentifier: "MapsTabBarController") as! MapsTabBarController
            mapController.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: mapController), close: true)
        case "Venue":
            let dataAtIndex = Mapper<Maps>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
            defaults.set(nsdataObj, forKey: "mapData")
            let mapController = storyboard?.instantiateViewController(withIdentifier: "MapsTabBarController") as! MapsTabBarController
            mapController.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: mapController), close: true)
        case "pdf":
            let dataAtIndex = Mapper<Pdf>().map(JSONObject: obj)
//            let nsdataObj = NSKeyedArchiver.archivedDataWithRootObject(obj["pdfurl"]!!)
            
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
            defaults.set(nsdataObj, forKey: "pdfData")
            let awardController = storyboard?.instantiateViewController(withIdentifier: "AwardsListViewController") as! AwardsListViewController
            awardController.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: awardController), close: true)
        case "speakersData":
            let dataAtIndex = Mapper<SpeakersData>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: obj)
            defaults.set(nsdataObj, forKey: "speakersData")
            
            let speakerController = storyboard?.instantiateViewController(withIdentifier: "SpeakerViewController") as! SpeakerViewController
            speakerController.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: speakerController), close: true)
        case "video":
            let dataAtIndex = Mapper<Video>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
            defaults.set(nsdataObj, forKey: "videoData")
            let videoController = storyboard?.instantiateViewController(withIdentifier: "VideolistViewController") as! VideolistViewController
            videoController.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: videoController), close: true)
        case "eventslist":
            let dataAtIndex = Mapper<UpcomingEventlist>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!.items!)
            defaults.set(nsdataObj, forKey: "upcomingEVentData")
            
            let upcomingController = storyboard?.instantiateViewController(withIdentifier: "UpcomingEventsTableViewController") as! UpcomingEventsTableViewController
            upcomingController.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: upcomingController), close: true)
        case "currency":
            self.slideMenuController()?.changeMainViewController(self.currencyConvert, close: true)
        case "rssfeeds":
            let dataAtIndex = Mapper<RssFeeds>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!.url!)
            defaults.set(nsdataObj, forKey: "rssData")
            let rssController = storyboard?.instantiateViewController(withIdentifier: "RssFeedsViewController") as! RssFeedsViewController
            rssController.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: rssController), close: true)
        case "Social":
            let dataAtIndex = Mapper<SocialMedia>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: obj)
            defaults.set(nsdataObj, forKey: "socialMediaData")
            let socialController = storyboard?.instantiateViewController(withIdentifier: "SocialMediaViewController") as! SocialMediaViewController
            socialController.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: socialController), close: true)
        case "socialmedia":
            let dataAtIndex = Mapper<SocialMedia>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: obj)
            defaults.set(nsdataObj, forKey: "socialMediaData")
            let socialController = storyboard?.instantiateViewController(withIdentifier: "SocialMediaViewController") as! SocialMediaViewController
            socialController.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: socialController), close: true)
        case "sponsorsData":
            self.defaults.set(true, forKey: "sponsortype")
            self.defaults.set(false, forKey: "favtype")
//            let dataAtIndex = Mapper<SponsorsData>().map(JSONObject: obj)?.items
            let dataAtIndex = Mapper<SponsorsData>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
            defaults.set(nsdataObj, forKey: "sponsorsData")
            let sponsorsView = storyboard?.instantiateViewController(withIdentifier: "SponsorsViewController") as! SponsorsViewController
            sponsorsView.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: sponsorsView), close: true)
            
        case "weather":
            let dataAtIndex = Mapper<Weather>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
            defaults.set(nsdataObj, forKey: "weatherData")
            self.slideMenuController()?.changeMainViewController(self.weatherViewController, close: true)
        case "survey":
            
            defaults.set(true, forKey: "fromsurvey")
            
            let getobj = Mapper<newSurvey>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: obj)
            defaults.set(nsdataObj, forKey: "surveyData")
            defaults.set(0, forKey: "questionno")
            if let dataFromDefaults = defaults.object(forKey: "surveyData"){
                if let dataAtIndex = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as! Data){
                    let objectFromDefaults = (Mapper<newSurvey>().map(JSONObject: dataAtIndex)?.items)!
                    if(objectFromDefaults.count > 0)
                    {
                        let surveyController = storyboard?.instantiateViewController(withIdentifier: "NewSurveyViewController") as! NewSurveyViewController
                        surveyController.title = getobj?.title
                        self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: surveyController), close: true)
                    }else
                    {
                        UIAlertView(title: "Survey Not Available",message: "No Questions Available",delegate: nil,cancelButtonTitle: "OK").show()
                    }
                }
            }
        case "contactUs":
            
            let dataAtIndex = Mapper<ContactUs>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
            defaults.set(nsdataObj, forKey: "ContactusData")
            let contactViewController = storyboard?.instantiateViewController(withIdentifier: "NewContactUsViewController") as! NewContactUsViewController
            contactViewController.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: contactViewController), close: true)
        case "Refresh":
            
            self.hud.hide(true, afterDelay: 0)
            hud = MBProgressHUD.showAdded(to: self.view.window, animated: true)
            hud.labelText = "Checking Update..."
            hud.minSize = CGSize(width: 150, height: 100)
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.dataparsingWithNotification), name:NSNotification.Name(rawValue: "eventupdateNotification"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.hidehudWithNotification), name:NSNotification.Name(rawValue: "hidehudNotification"), object: nil)
            
            RefreshSingleEvent().refreshEvent(appURL: presentappurl, version: presentverion,appID:presentappid)
        //            UIAlertView(title: "Comming Soon",message: "Refreshing App Implementing",delegate: nil,cancelButtonTitle: "OK").show()
         case "polling":
            
            defaults.set(false, forKey: "fromsurvey")
            
             let dataAtIndex = Mapper<Polling>().map(JSONObject: obj)
            let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: obj)
//            let nsdataObj = NSKeyedArchiver.archivedDataWithRootObject(obj)
            defaults.set(nsdataObj, forKey: "pollingData")
            
            let pollinglist = storyboard?.instantiateViewController(withIdentifier: "PollingListTableViewController") as! PollingListTableViewController
            pollinglist.title = dataAtIndex?.title
            self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: pollinglist), close: true)
            
        case "Mybadge":
            if self.defaults.bool(forKey: "login")
            {
                self.slideMenuController()?.changeMainViewController(self.mybadgeController, close: true)
            }else
            {
                presentloginscreen()
                //UIAlertView(title: "Please Login",message: "Please Login and try again",delegate: nil,cancelButtonTitle: "OK").show()
            }
        case "attendee":
            if self.defaults.bool(forKey: "login")
            {
                self.slideMenuController()?.changeMainViewController(self.inboxViewcontroller, close: true)
            }else
            {
                presentloginscreen()
                //UIAlertView(title: "Please Login",message: "Please Login and try again",delegate: nil,cancelButtonTitle: "OK").show()
            }
        case "webmobieventapp":
            defaults.set(false, forKey: "frommultievent")
            self.slideMenuController()?.changeMainViewController(self.supportViewController, close: true)
            
        case "gamification":
            if self.defaults.bool(forKey: "login")
            {
                let leaderController = storyboard?.instantiateViewController(withIdentifier: "LeaderBoardViewController") as! LeaderBoardViewController
                leaderController.title = "Leader Board"
                self.slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: leaderController), close: true)
                dataParsing()
            }else
            {
                presentloginscreen()
                //UIAlertView(title: "Please Login",message: "Please Login and try again",delegate: nil,cancelButtonTitle: "OK").show()
            }
            defaults.set(false, forKey: "gmaification")
            
            
        case "feeds":
            self.slideMenuController()?.changeMainViewController(self.activityFeedViewController, close: true)
            
        default :
            dismiss(animated: true, completion: nil)
            
            
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


extension LeftViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     //   let preview_flag = self.defaults.string(forKey: "preview")
        let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)

   //     if(preview_flag == "1"){
//            var newView = UIView(frame: CGRect(x: 100, y: 100  , width: 200, height: 100))
//            newView.backgroundColor = UIColor.red
//            cell.contentView.addSubview(newView)
//
//            eventbriefheight.constant = self.view.frame.height
//            preview.isHidden = false
//        } else {
//            preview.isHidden = true
//        }
        
//
        cell.setData( data: listForTheMenu1[indexPath.row])
        
        cell.setImg(data: listForiconCls[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(defaults.bool(forKey: "infoprivacy") && indexPath.row != 0 )
        {
            UIAlertView(title: "Access Denied",message: "This is Private Event Please Contact Support Team",delegate: nil,cancelButtonTitle: "OK").show()
            
        }else
        {
//            changeViewController(menu: (listForTheMenu[indexPath.row] as String).trimmingCharacters(in: .whitespaces)),ind: indexPath.row)
            
            changeViewController(menu: listForTheMenu[indexPath.row].trimmingCharacters(in: .whitespaces), ind: indexPath.row)
        }
        
    }
}

extension LeftViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}
