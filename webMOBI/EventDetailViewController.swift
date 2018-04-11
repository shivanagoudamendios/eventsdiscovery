//
//  EventDetailViewController.swift
//  webMOBI
//
//  Created by webmobi on 5/18/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage
import FontAwesome_swift
import EventKit

class EventDetailViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var calendarandinviteheight: NSLayoutConstraint!
    @IBOutlet weak var calendarandinviteview: UIView!
    @IBOutlet weak var lowerbuttonheight: NSLayoutConstraint!
    @IBOutlet weak var peoplejoinedheight: NSLayoutConstraint!
    @IBOutlet weak var eventimageView: UIImageView!
    @IBOutlet weak var detail_textview: UITextView!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var location_label: UILabel!
    @IBOutlet weak var app_name_label: UILabel!
    @IBOutlet weak var addtocalendar: UIButton!
    @IBOutlet weak var invite: UIButton!
    @IBOutlet weak var profileimage1: UIImageView!
    @IBOutlet weak var profileimage2: UIImageView!
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var peoplejoinedview: UIView!
    @IBOutlet weak var peoplecount: UILabel!
    @IBOutlet weak var lowerbutton: UIButton!
    var eventdetail : getPopularEvents!
    var logindata: [String: Any] = [String: Any]()
    var joinedprofile: [String: Any] = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileimage1.layer.masksToBounds = true
        profileimage2.layer.masksToBounds = true
        profileimage1.layer.borderWidth = 2
        profileimage2.layer.borderWidth = 2
        profileimage1.layer.borderColor = UIColor.white.cgColor
        profileimage2.layer.borderColor = UIColor.white.cgColor
        profileimage1.layer.cornerRadius = 17
        profileimage2.layer.cornerRadius = 17
        
        if (eventdetail.users?.count)! > 0{
            if eventdetail.users?.count == 1{
                profileimage1.sd_setImage(with: URL(string: eventdetail.users?[0]["profile_pic"]! as! String), placeholderImage: UIImage(named: "Emptyuser"))
            }else if eventdetail.users?.count == 2{
                profileimage1.sd_setImage(with: URL(string: eventdetail.users?[0]["profile_pic"]! as! String), placeholderImage: UIImage(named: "Emptyuser"))
                profileimage1.sd_setImage(with: URL(string: eventdetail.users?[1]["profile_pic"]! as! String), placeholderImage: UIImage(named: "Emptyuser"))
            }else{
                for count in 0...1{
                    profileimage1.sd_setImage(with: URL(string: eventdetail.users?[count]["profile_pic"]! as! String), placeholderImage: UIImage(named: "Emptyuser"))
                }
            }
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30/255, green: 112/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        addtocalendar.layer.borderColor = UIColor.gray.cgColor
        addtocalendar.layer.borderWidth = 1.0
        addtocalendar.layer.cornerRadius = 15
        invite.layer.borderColor = UIColor.gray.cgColor
        invite.layer.borderWidth = 1.0
        invite.layer.cornerRadius = 15
        initializecontroller()
        
        mapview.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        peoplejoinedview.addGestureRecognizer(tap)
        eventimageView.sd_setImage(with: URL(string: eventdetail.app_image!), placeholderImage: UIImage(named: "eventdemoimage"))
        if UserDefaults.standard.value(forKey: "userlogindata") == nil{

        }else{
            logindata = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
            print("logindata[userType] =",logindata["userType"]!, "logindata[userId] =",logindata["userId"]!, "logindata[tokenExpirationUtc] =",logindata["tokenExpirationUtc"]!, "logindata[token] =",logindata["token"]!)
        }
        
//        if(eventdetail.app_url?.isEmpty == false)
//        {
//            DownloadEvent().checkfileExist(_filename: eventdetail.app_url!){ existflag in
//                if(existflag)
//                {
//                    self.lowerbutton.isHidden = true
//                    self.lowerbuttonheight.constant = 0
//                }else
//                {
//                    self.lowerbutton.isHidden = false
//                }
//            }
//            
//        }else
//        {
//            lowerbutton.isHidden = false
//        }
        
    }
    
    func getprofilepic() {
        if (eventdetail.users?.count)! > 0{
            if (eventdetail.users?.count)! == 1{
                let profilestr1 = eventdetail.users?[0] as! [String: Any]
                print(profilestr1["userid"] as! String)
            }else {
                let profilestr1 = eventdetail.users?[0] as! [String: Any]
                print(profilestr1["userid"] as! String)
                let profilestr2 = eventdetail.users?[1] as! [String: Any]
                print(profilestr2["userid"] as! String)
            }
            
            for checkuserid in eventdetail.users! {
                let userdetail = checkuserid as! [String: Any]
                if let logindetail = UserDefaults.standard.value(forKey: "userlogindata") as?  [String: Any]{
                    if (userdetail["userid"] as! String) == (logindetail["userId"] as! String){
                        lowerbuttonheight.constant = 0
                    }
                }
            }
            
        }else {
            print("No people joined")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if eventdetail.accesstype == "discovery"{
            getprofilepic()
            self.lowerbutton.setTitle("Register", for: .normal)
        }else
        {
            calendarandinviteheight.constant = 0
            calendarandinviteview.isHidden = true
            if(eventdetail.appid?.isEmpty == false)
            {
                DownloadEvent().checkfileExist(_filename: eventdetail.appid!){ existflag in
                    if(existflag)
                    {
                        self.lowerbutton.setTitle("Open Event", for: .normal)
                    }else
                    {
                        self.lowerbutton.setTitle("Download", for: .normal)
                    }
                }
                
            }else
            {
                self.lowerbutton.setTitle("Download", for: .normal)
            }
            
        }
        let str = eventdetail.start_date!
        let index = str.index(str.startIndex, offsetBy: 10)
        if (self.presentingViewController != nil){
            print("VC Presented")
            let btn1 = UIButton(type: .custom)
            btn1.setImage(UIImage(named: "CloseIcon"), for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            btn1.addTarget(self, action: #selector(self.dismissbutton(sender:)), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: btn1)
            self.navigationItem.setLeftBarButton(item1, animated: true)
        }else{
            print("VC Navigated")
        }
        let locationicon = String.fontAwesomeIcon(code: "fa-map-marker")
        location_label.font = UIFont.fontAwesome(ofSize: 15)
        if eventdetail.location != nil{
            location_label.text = locationicon! + " " + eventdetail.location!
        }else{
            location_label.text = locationicon!
        }
        location_label.textColor = UIColor.gray
        let calendar = String.fontAwesomeIcon(code: "fa-calendar")
        date_label.font = UIFont.fontAwesome(ofSize: 15)
        date_label.text = calendar! +  " " + str.substring(to: index)
        date_label.textColor = UIColor.gray
        self.navigationController?.hidesBarsOnSwipe = false
        //        self.navigationController?.hidesBarsOnTap = true
        app_name_label.text = eventdetail.app_name
        //        location_label.text = eventdetail.location
        //        date_label.text = str.substring(to: index)
        detail_textview.attributedText = eventdetail.app_description?.html2AttributedString
        detail_textview.font = .systemFont(ofSize: 18)
        if eventdetail.users == nil{
            peoplecount.text = "0 people joined"
        }else{
            peoplecount.text = "\((eventdetail.users?.count)!) people joined"
        }
        if eventdetail.users_length! < 1{
            peoplejoinedheight.constant = 0
            peoplejoinedview.isHidden = true
        }
//        if eventdetail.accesstype == "discovery"{
//            peoplejoinedview.isHidden = false
//            lowerbutton.setTitle("Register", for: .normal)
//        }else{
//            peoplejoinedheight.constant = 0
//            peoplejoinedview.isHidden = true
//            lowerbutton.setTitle("Download", for: .normal)
//        }
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        print("handleTap")
        if UserDefaults.standard.value(forKey: "userlogindata") != nil{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "PeopleJoinedTableViewController") as! PeopleJoinedTableViewController
            view.appid = eventdetail.appid!
            self.navigationController?.pushViewController(view, animated: true)
        }else{
            let alert = UIAlertController(title: "Not Logged in", message: "Login Required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in

            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapview.mapType = .standard
        var location : CLLocationCoordinate2D!
        location = CLLocationCoordinate2D(latitude: eventdetail.latitude!,longitude: eventdetail.longitude!)
        let region = MKCoordinateRegionMakeWithDistance(location, 300, 300)
        mapview.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = eventdetail.location
//        annotation.subtitle = "Bangalore, IN"
        mapview.addAnnotation(annotation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func lowerbutton(_ sender: UIButton) {
        if eventdetail.accesstype == "discovery"{
            register()
        }else{
            DownloadEvent().checkfileExist(_filename: eventdetail.appid!){ existflag in
                if(existflag)
                {
                    ConnectToSE().openMethodWithNotification(filekey: self.eventdetail.appid!,parent: self)
                }else
                {
                    self.downloadApp()
                }
            }
        }
    }
    
    func downloadApp(){
        let appid = eventdetail.appid!
        var userid = ""
        if UserDefaults.standard.value(forKey: "userlogindata") != nil{
            let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
            userid = data1["userId"]! as! String
        }
        
        let params = ["appid": appid as AnyObject,
                      "device_id": UserDefaults.standard.string(forKey: "devicetoken") as AnyObject,
                      "device_type": "ios" as AnyObject,
                      "userid": userid as AnyObject
            ] as Dictionary<String, AnyObject>
        print(params)
        deviceapp(params: params) { receiveddata in
            
            print(receiveddata)
            if (receiveddata["response"] as! Bool) == true{
                let obj = self.eventdetail.toAnyObject()
                if let url = self.eventdetail.app_url,let id = self.eventdetail.appid{
                    
                    DownloadEvent().singleEvent(appID:id,appURL: url,event:obj){ receiveddata in
                        print(receiveddata)
                        if(receiveddata){
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadMyEvents"), object: nil)
                            var password = ""
                            if UserDefaults.standard.value(forKey: "userlogindata") != nil{
                                password = UserDefaults.standard.string(forKey: "discovery_password")!
                            }
                            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    CoreDataManager.storeDownlodedEvent(appid: id, isfirstlogin: false, password: password)
                                    self.view.removeLoader()
                                    self.viewWillAppear(true)
                                })
                            })
                        }else{
                            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    UIAlertView(title: "Request Failed",message: "Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                                    self.view.removeLoader()
                                })
                            })
                        }
                    }
                }else
                {
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            UIAlertView(title: "Request Failed",message: "Event not available",delegate: nil,cancelButtonTitle: "OK").show()
                            self.view.removeLoader()
                        })
                    })
                }
            }else{
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        UIAlertView(title: "Request Failed",message: receiveddata["responseString"] as? String ,delegate: nil,cancelButtonTitle: "OK").show()
                    })
                })
            }
        }
    }
    
    func deviceapp(params: Dictionary<String, AnyObject>, completion: @escaping (_ Data: AnyObject) -> ()) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.addLoader()
            })
        })
        var request = URLRequest(url: URL(string: ServerAPIs.device_app)!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "ERROR CODE: \((error as! NSError).code)", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                })
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    completion(parsedData as AnyObject)
                } catch {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.view.removeLoader()
                        })
                    })
                    print("Error deserializing JSON: \(error)")
                }
            }else {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "Request Failed", message: "Try Again.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                })
            }
        }
        task.resume()
    }
    
    func register() {
        if UserDefaults.standard.value(forKey: "userlogindata") != nil{
            registeruser(){ receiveddata in
                DispatchQueue.main.async {
                    let response = receiveddata["response"] as! Bool
                    if response == true{
                        DispatchQueue.main.async(execute: {() -> Void in
                            let alert = UIAlertController(title: "SUCCESS", message: "Registered Successfully", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    }else{
                        DispatchQueue.main.async(execute: {() -> Void in
                            let alert = UIAlertController(title: "Request Failed", message: receiveddata["responseString"]! as! String?, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
                }
            }
        }else{
            DispatchQueue.main.async(execute: {() -> Void in
                let alert = UIAlertController(title: "Not Logged in", message: "Login Required", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    
                })
                
                alert.addAction(UIAlertAction(title: "LOGIN", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.presentloginscreen()
                })
                
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    func presentloginscreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }

    func registeruser(completion: @escaping (_ Data: AnyObject) -> ()) {

        let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
        let email = UserDefaults.standard.string(forKey: "discovery_email")
        var request = URLRequest(url: URL(string: ServerAPIs.discovery_register)!)
        request.httpMethod = "POST"
        
        let params = ["userid": data1["userId"]! as AnyObject,
                      "appid": eventdetail.appid as AnyObject,
                      "email": email as AnyObject,
                      "username": data1["username"]! as AnyObject,
                      "deviceType": "ios" as AnyObject,
                      "deviceId": UserDefaults.standard.string(forKey: "devicetoken") as AnyObject
            ] as Dictionary<String, AnyObject>
        print("params",params)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue(logindata["token"] as! String, forHTTPHeaderField: "token")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
            
            guard error == nil && data != nil else {
                print("error=\(error!)")
                DispatchQueue.main.async(execute: {() -> Void in
                    let alert = UIAlertController(title: "ERROR CODE: \((error as! NSError).code)", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                    })
                    self.present(alert, animated: true, completion: nil)
                })
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            print(statusCode)
            print(data!)
            if (statusCode == 200) {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    
                    completion(parsedData as AnyObject)
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
            }else {
                
            }
        }
        task.resume()
    }
    
    func initializecontroller() {
        
        //        let btn1 = UIButton(type: .custom)
        //        btn1.setImage(UIImage(named: "leftarrow"), for: .normal)
        //        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //        btn1.addTarget(self, action: #selector(self.backbutton), for: .touchUpInside)
        //        let item1 = UIBarButtonItem(customView: btn1)
        //        self.navigationItem.setLeftBarButton(item1, animated: true)
        //
        
        let btn2 = UIButton(type: .custom)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.addTarget(self, action: #selector(self.likebutton), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        let bool = CoreDataManager.checkforeventID(id: eventdetail.appid!)
        
        if(bool)
        {
            let img = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-heart")!, textColor: UIColor.red, size: CGSize(width: 30, height: 30))
            btn2.setImage(img, for: .normal)
            btn2.tintColor = UIColor.red
        }else
        {
            let img = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-heart-o")!, textColor: UIColor.white, size: CGSize(width: 30, height: 30))
            btn2.setImage(img, for: .normal)
            btn2.tintColor = UIColor.white
        }
        
        self.invite.addTarget(self, action: #selector(self.sharebutton(sender:)), for: .touchUpInside)
        self.addtocalendar.addTarget(self, action: #selector(self.addtocalendar(sender:)), for: .touchUpInside)
//        
//        let btn3 = UIButton(type: .custom)
//        btn3.setImage(UIImage(named: "share"), for: .normal)
//        btn3.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        btn3.addTarget(self, action: #selector(self.sharebutton), for: .touchUpInside)
//        let item3 = UIBarButtonItem(customView: btn3)
//        self.navigationItem.setRightBarButtonItems([item2], animated: true)
        
    }
    
    func dismissbutton(sender: UIButton) {
        ////        _ = self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("cometohome"), object: nil)
    }
    
    func likebutton(sender: UIButton) {
        let bool = CoreDataManager.checkforeventID(id: eventdetail.appid!)
        if(bool)
        {
            CoreDataManager.cleanseletedEvent(id: eventdetail.appid!)
        }else
        {
            CoreDataManager.storeFavEvents(event: eventdetail)
        }
        initializecontroller()
    }
    
    func addtocalendar(sender: UIButton) {
        
        let eventStore = EKEventStore()
        let dateFormatter = DateFormatter()
        var eventdaddedcount = 0
        var iseventexist = false
        let date1 = eventdetail.start_date!
        let date2 = eventdetail.end_date!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSZ"
        let startdate = dateFormatter.date(from: date1)
        let enddate = dateFormatter.date(from: date2)
        
        let predicate = eventStore.predicateForEvents(withStart: startdate!, end: enddate!, calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)
        if existingEvents.count > 0{
            for singleEvent in existingEvents {
                if singleEvent.title == eventdetail.app_name! {
                    print("exist")
                    iseventexist = true
                }
            }
            if iseventexist == true{
                eventdaddedcount = 0
            }else{
                print("not exist")
                eventdaddedcount += 1
                addEventToCalendar(title: eventdetail.app_name!, description: "Event: \(eventdetail.app_name) at \(eventdetail.location)", startDate: date1, endDate: date2)
            }
        }else{
            print("not exist")
            eventdaddedcount += 1
            addEventToCalendar(title: eventdetail.app_name!, description: "Event: \(eventdetail.app_name) at \(eventdetail.location)", startDate: date1, endDate: date2)
        }

        if eventdaddedcount > 0{
            let alert = UIAlertController(title: "SUCCESS", message: "Event added to your calendar.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            })
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Request Failed", message: "Event already Added", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: String, endDate: String, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSZ"
                let stdate = dateFormatter.date(from: startDate)
                let etdate = dateFormatter.date(from: endDate)
                event.startDate = stdate!
                event.endDate = etdate!
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    func sharebutton(sender: UIButton) {
        // text to share
        let str = eventdetail.start_date!
        let index = str.index(str.startIndex, offsetBy: 10)
        let attributedtext = "Event: \(eventdetail.app_name!)\nDate: \(str.substring(to: index))\nLocation: \(eventdetail.location!)\n"
        let text = attributedtext
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
