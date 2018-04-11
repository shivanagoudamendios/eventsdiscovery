//
//  HomeTabViewController2.swift
//  webMOBI
//
//  Created by webmobi on 5/18/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import CoreLocation
import ObjectMapper
import SDWebImage

class HomeTabViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var eventstableview: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    private var lastContentOffset: CGFloat = 0
    var locationManager: CLLocationManager!
    var userLocation:CLLocation! = nil
    var geteventflag = true
    
    var nearbyevents : [getPopularEvents] = [getPopularEvents]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBtnTitle = String.fontAwesomeIcon(code: "fa-sliders")
        filterButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 17)
        filterButton.setTitle(backBtnTitle! + " FILTER", for: .normal)
        
        filterButton.layer.cornerRadius = filterButton.frame.height/2
        filterButton.layer.borderColor = UIColor(red: 30/255, green: 112/255, blue: 145/255, alpha: 1).cgColor
        filterButton.layer.borderWidth = 1
        filterButton.layer.masksToBounds = false
        filterButton.layer.shadowColor = UIColor.black.cgColor
        filterButton.layer.shadowOpacity = 0.7
        filterButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        filterButton.layer.shadowRadius = 3
        
        // Do any additional setup after loading the view.
        eventstableview.delegate = self
        eventstableview.register(UINib(nibName: "EventsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsTableViewCell")
        eventstableview.separatorStyle = .none
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.filterevents),
            name: Notification.Name("filterevents"),
            object: nil)
        
    }
    
    func filterevents(notification: NSNotification) {
        if CLLocationManager.locationServicesEnabled() {
            getevents(params: notification.userInfo as! Dictionary<String, AnyObject>)
            geteventflag = false
        }else {
            determineMyCurrentLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.determineMyCurrentLocation()
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.isNavigationBarHidden = false
        super.viewWillAppear(animated)
        checkforloginaccess()
//        let userdata = UserDefaults.standard.value(forKey: "userlogindata")
//        if userdata == nil{
//            let alert = UIAlertController(title: "Not Logged in", message: "Login Required", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default){
//                UIAlertAction in
//                self.tabBarController?.selectedIndex = 0
//            })
//            self.present(alert, animated: true, completion: nil)
//        }

        
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
    
    func checkforloginaccess() {
        if UserDefaults.standard.value(forKey: "userlogindata") == nil{
            self.tabBarController?.selectedIndex = 0
            presentloginscreen()
//            let alert = UIAlertController(title: "Not Logged in", message: "Login Required", preferredStyle: UIAlertControllerStyle.alert)
//
//            //            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
//            //                UIAlertAction in
//            //                self.tabBarController?.selectedIndex = 0
//            //                //self.checkforloginaccess()
//            //            })
//
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                UIAlertAction in
//
//                self.presentloginscreen()
//                self.tabBarController?.selectedIndex = 0
//            })
//
//            self.present(alert, animated: true, completion: nil)
        }else{
            print("Already LoggedIn")
        }
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let vc = storyboard.instantiateViewController(withIdentifier: "EventsFilterViewController") as! EventsFilterViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        filterButton.alpha = 1
        self.eventstableview.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            if filterButton.alpha > 0{
                print("to top")
                filterButton.fadeOut()
            }
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            if filterButton.alpha < 1{
                print("to bottom")
                filterButton.fadeIn()
            }
            
        }
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyevents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as! EventsTableViewCell
        if nearbyevents[indexPath.row].location != nil{
            cell.location_label.text = nearbyevents[indexPath.row].location!
        }else{
            cell.location_label.text = ""
        }
        if nearbyevents[indexPath.row].app_name != nil{
            cell.app_name_label.text = nearbyevents[indexPath.row].app_name!
        }else{
            cell.app_name_label.text = ""
        }
        if nearbyevents[indexPath.row].start_date != nil{
            let str = nearbyevents[indexPath.row].start_date!
            let index = str.index(str.startIndex, offsetBy: 10)
            cell.date_label.text = str.substring(to: index)
        }else{
            cell.date_label.text = ""
        }
        cell.appImageView.sd_setImage(with: URL(string: nearbyevents[indexPath.row].app_image!), placeholderImage: UIImage(named: "eventdemoimage"))
        cell.imageView?.sizeToFit()
        cell.selectionStyle = .none
        cell.moredetailbutton.tag = indexPath.row
        cell.discoverymoreDetailBtn.tag = indexPath.row
        cell.downloadeventbutton.tag = indexPath.row
        cell.discoverymoreDetailBtn.removeTarget(self, action: nil, for: .touchUpInside)
        cell.moredetailbutton.removeTarget(self, action: nil, for: .touchUpInside)
        cell.downloadeventbutton.removeTarget(self, action: nil, for: .touchUpInside)
        
        if nearbyevents[indexPath.row].accesstype == "discovery"{
            cell.downloadeventbutton.isHidden = true
            cell.moredetailbutton.isHidden = true
            cell.discoverymoreDetailBtn.isHidden = false
            cell.discoverymoreDetailBtn.setTitle("More Details", for: .normal)
            cell.discoverymoreDetailBtn.addTarget(self, action: #selector(self.moredetail(_:)), for: .touchUpInside)
        }else
        {
            if(nearbyevents[indexPath.row].appid?.isEmpty == false)
            {
                let filename = nearbyevents[indexPath.row].appid!
                DownloadEvent().checkfileExist(_filename:filename){ existflag in
                    if(existflag)
                    {
                        cell.downloadeventbutton.isHidden = true
                        cell.moredetailbutton.isHidden = true
                        cell.discoverymoreDetailBtn.isHidden = false
                        cell.discoverymoreDetailBtn.setTitle("Open Event", for: .normal)
                        cell.discoverymoreDetailBtn.addTarget(self, action: #selector(self.openApp(_:)), for: .touchUpInside)
                    }else
                    {
                        cell.downloadeventbutton.isHidden = false
                        cell.moredetailbutton.isHidden = false
                        cell.discoverymoreDetailBtn.isHidden = true
                        cell.moredetailbutton.addTarget(self, action: #selector(self.moredetail(_:)), for: .touchUpInside)
                        cell.downloadeventbutton.addTarget(self, action: #selector(self.downloaddetail(_:)), for: .touchUpInside)
                    }
                }
            }else
            {
                cell.downloadeventbutton.isHidden = true
                cell.moredetailbutton.isHidden = true
                cell.discoverymoreDetailBtn.isHidden = false
                cell.discoverymoreDetailBtn.setTitle("More Details", for: .normal)
                cell.discoverymoreDetailBtn.addTarget(self, action: #selector(self.moredetail(_:)), for: .touchUpInside)
            }
            
        }
        let bool = CoreDataManager.checkforeventID(id: nearbyevents[indexPath.row].appid!)
        cell.changefavbtnlogo(addedinFav: bool)
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: #selector(self.addtoFav(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func openApp(_ sender: UIButton)
    {
        ConnectToSE().openMethodWithNotification(filekey: nearbyevents[sender.tag].appid!,parent: self)
    }
    
    func moredetail(_ sender: UIButton) {
        print(sender.tag)
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        if(UserDefaults.standard.string(forKey: "userlogindata") !=  nil){
            let viewController = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
            viewController.eventdetail = nearbyevents[sender.tag]
            navigationController!.pushViewController(viewController, animated: true)
        } else {
            let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            //viewController.eventdetail = nearbyevents[sender.tag]
            self.navigationController!.pushViewController(viewController, animated: true)

        }
    
    }
    
    func addtoFav(_ sender: UIButton) {
        print(sender.tag)
        let bool = CoreDataManager.checkforeventID(id: nearbyevents[sender.tag].appid!)
        if(bool)
        {
            CoreDataManager.cleanseletedEvent(id: nearbyevents[sender.tag].appid!)
        }else
        {
            CoreDataManager.storeFavEvents(event: nearbyevents[sender.tag])
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.eventstableview.reloadData()
            })
        })
        //DownloadEvent().addtofavorite(event: nearbyevents[sender.tag].toAnyObject())
    }
    
    func downloaddetail(_ sender: UIButton) {
        print(sender.tag)
        let appid = nearbyevents[sender.tag].appid!
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
        deviceapp(params: params){ receiveddata in
            
            print(receiveddata)
            if (receiveddata["response"] as! Bool) == true{
                let obj = self.nearbyevents[sender.tag].toAnyObject()
                if let url = self.nearbyevents[sender.tag].app_url,let id = self.nearbyevents[sender.tag].appid{

                    DownloadEvent().singleEvent(appID:id,appURL: url,event:obj){ receiveddata in
                        if(receiveddata){
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadMyEvents"), object: nil)
                            var password = ""
                            if UserDefaults.standard.value(forKey: "userlogindata") != nil{
                                password = UserDefaults.standard.string(forKey: "discovery_password")!
                            }
                            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    CoreDataManager.storeDownlodedEvent(appid: id, isfirstlogin: false, password: password)
                                    self.eventstableview.reloadData()
                                    self.view.removeLoader()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 280
        case .pad:
            return 320
        default:
            return 280
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let viewController = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        //        viewController.eventdetail = nearbyevents[indexPath.row]
        //        navigationController!.pushViewController(viewController, animated: true)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        //        vc.tbd = false
        //        let navigationController = UINavigationController(rootViewController: vc)
        //        self.present(navigationController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeTabViewController2{
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined, .restricted, .denied:
            print("No access")
            DispatchQueue.main.async(execute: {() -> Void in
                let appname = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
                let alert = UIAlertController(title: "Location Not Enabled", message: "\(appname) is not able to access location.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LogoutNotification"), object: nil)
                })
                alert.addAction(UIAlertAction(title: "Enable", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LogoutNotification"), object: nil)
                    UIApplication.shared.openURL(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL)
                })
                self.present(alert, animated: true, completion: nil)
            })
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        //        print("user latitude = \(userLocation.coordinate.latitude)")
        //        print("user longitude = \(userLocation.coordinate.longitude)")
        if geteventflag == true{
            getevents(params: getparams())
            geteventflag = false
        }
    }
    
    func getevents(params: Dictionary<String, AnyObject>) {
        getnearbyevents(params: params){ receiveddata in
            DispatchQueue.main.async {
                let response = receiveddata["response"] as! Bool
                
                if response == true{
                    print(receiveddata)
                    let events = receiveddata["events"] as! [AnyObject]
                    //                    for data in events {
                    //
                    //                        let data1 = Mapper<getPopularEvents>().map(JSONObject: data)
                    //                        self.nearbyevents.append(data1!)
                    //                        self.eventstableview.reloadData()
                    //                    }
                    self.nearbyevents = Mapper<getPopularEvents>().mapArray(JSONObject: events)!
                    self.eventstableview.reloadData()
                }else{
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "Requset Failed", message: "There are no events present for this filter", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    func getparams() -> Dictionary<String, AnyObject> {
        let params = ["distance": String(round((25)*0.621371)) as AnyObject,
                      "latitude": String(userLocation.coordinate.latitude) as AnyObject,
                      "longitude": String(userLocation.coordinate.longitude) as AnyObject,
                      "offset": String(nearbyevents.count) as AnyObject,
                      "date": "anydate" as AnyObject,
                      "startdate": "" as AnyObject,
                      "enddate": "" as AnyObject,
                      "category": "anycategory" as AnyObject
            ] as Dictionary<String, AnyObject>
        
        return params
    }
    
    func getnearbyevents(params: Dictionary<String, AnyObject>, completion: @escaping (_ Data: AnyObject) -> ()) {
        self.view.addLoader()
        var request = URLRequest(url: URL(string: ServerAPIs.nearby_events)!)
        request.httpMethod = "POST"
        //        let params = ["distance": "10" as AnyObject,
        //                      "latitude": String(userLocation.coordinate.latitude) as AnyObject,
        //                      "longitude": String(userLocation.coordinate.longitude) as AnyObject,
        //                      "offset": "0" as AnyObject,
        //                      "date": "anydate" as AnyObject,
        //                      "startdate": "" as AnyObject,
        //                      "enddate": "" as AnyObject,
        //                      "category": "anycategory" as AnyObject
        //            ] as Dictionary<String, AnyObject>
        print("params",params)
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
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.removeLoader()
                })
            })
            
            if (statusCode == 200) {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    completion(parsedData as AnyObject)
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
            }else {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
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
    
}
