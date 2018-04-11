//
//  HomeTabViewController1.swift
//  webMOBI
//
//  Created by webmobi on 5/18/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation



class HomeTabViewController1: UIViewController, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate  {
    
    @IBOutlet weak var myEventTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var myeventlabel: UILabel!
    @IBOutlet weak var recommendedlabel: UILabel!
    @IBOutlet weak var myeventlabelheight: NSLayoutConstraint!
    @IBOutlet weak var recommendedlabelheight: NSLayoutConstraint!
    @IBOutlet weak var myeventheight: NSLayoutConstraint!
    @IBOutlet weak var recommendedviewheight: NSLayoutConstraint!
    @IBOutlet weak var myeventscollectionview: UICollectionView!
    @IBOutlet weak var recommendedeventscollectionview: UICollectionView!
    @IBOutlet weak var tradeview: UIView!
    @IBOutlet weak var schoolview: UIView!
    @IBOutlet weak var communityview: UIView!
    @IBOutlet weak var museumview: UIView!
    @IBOutlet weak var personalview: UIView!
    @IBOutlet weak var associationsview: UIView!
    @IBOutlet weak var airportview: UIView!
    @IBOutlet weak var nationalparkview: UIView!
    var myevents : [getPopularEvents] = [getPopularEvents]()
    var recommendedevents : [getPopularEvents] = [getPopularEvents]()
    var locationManager: CLLocationManager!
    var userLocation:CLLocation! = nil
    var geteventflag = true
    let collectionViewheight = 209
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        myeventscollectionview.register(UINib(nibName: "MyEventsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyEventsCollectionViewCell")
        myeventscollectionview.delegate = self
        recommendedeventscollectionview.register(UINib(nibName: "MyEventsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyEventsCollectionViewCell")
        recommendedeventscollectionview.delegate = self
        
        determineMyCurrentLocation()
        setTopLayout()
        initgestureforviews()
        addshadowstoview()
        recommendedviewheight.constant = CGFloat(collectionViewheight)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.removeFilesRequest(sender:)))
        myeventscollectionview.addGestureRecognizer(longPress)
        viewWillAppear(true)
       
    }
    func setTopLayout(){
        switch UIDevice.current.userInterfaceIdiom {
        case .phone :  self.myEventTopConstraint.constant = 25
            
        case .pad :    self.myEventTopConstraint.constant = 80
        default:
            print("Dvice not detectable")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.isNavigationBarHidden = false
        getmyevents()
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReloadMyEvents), name:NSNotification.Name(rawValue: "ReloadMyEvents"), object: nil)
        
        
    }
    
    func ReloadMyEvents() {
        DispatchQueue.global(qos: .background).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.getmyevents()
            })
        })
    }
    
    func getmyevents()
    {
        let testFile1 = FileSaveHelper(fileName: "jsonFile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
        
        // 2
        do {
            let str =  try testFile1.getContentsOfFile()
            let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            
            do
            {
                let message = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers)
                if let jsonResult = message as? [AnyObject]
                {
                    self.myevents = Mapper<getPopularEvents>().mapArray(JSONObject: jsonResult)!
                    
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.myeventscollectionview.reloadData()
                        })
                    })
                    
                }
                else
                {
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.myeventscollectionview.reloadData()
                        })
                    })
                    
                    print("error")
                }
            }
            catch
            {
                print("An error occurred: \(error)")
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.myeventscollectionview.reloadData()
                    })
                })
                
            }
            
        }catch {
            myevents.removeAll()
            myeventscollectionview.reloadData()
            print (error)
        }
        if self.myevents.count == 0{
            self.myeventheight.constant = 0
            self.myeventlabelheight.constant = 0
            self.myeventscollectionview.isHidden = true
            self.myeventlabel.isHidden = true
        }else{
            self.myeventscollectionview.isHidden = false
            self.myeventlabel.isHidden = false
            self.myeventheight.constant = CGFloat(collectionViewheight)
            self.myeventlabelheight.constant = 21
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func addshadowstoview() {
        setShadowToview(view: tradeview)
        setShadowToview(view: schoolview)
        setShadowToview(view: communityview)
        setShadowToview(view: museumview)
        setShadowToview(view: personalview)
        setShadowToview(view: associationsview)
        setShadowToview(view: airportview)
        setShadowToview(view: nationalparkview)
    }
    
    func initgestureforviews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        tradeview.addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(sender:)))
        tap1.delegate = self
        schoolview.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(sender:)))
        tap2.delegate = self
        communityview.addGestureRecognizer(tap2)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap3(sender:)))
        tap3.delegate = self
        museumview.addGestureRecognizer(tap3)
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap4(sender:)))
        tap4.delegate = self
        personalview.addGestureRecognizer(tap4)
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap5(sender:)))
        tap5.delegate = self
        associationsview.addGestureRecognizer(tap5)
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap6(sender:)))
        tap6.delegate = self
        airportview.addGestureRecognizer(tap6)
        let tap7 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap7(sender:)))
        tap7.delegate = self
        nationalparkview.addGestureRecognizer(tap7)
    }
    
    
    
    func handleTap(sender: UITapGestureRecognizer) {
        print("handleTap")
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        viewController.categorytitle = "Trade Show"
        viewController.categoryurl = ServerAPIs.category_trade_show
        navigationController!.pushViewController(viewController, animated: true)
    }
    func handleTap1(sender: UITapGestureRecognizer) {
        print("handleTap1")
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        viewController.categorytitle = "Schools"
        viewController.categoryurl = ServerAPIs.category_schools
        navigationController!.pushViewController(viewController, animated: true)
    }
    func handleTap2(sender: UITapGestureRecognizer) {
        print("handleTap2")
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        viewController.categorytitle = "Community Center"
        viewController.categoryurl = ServerAPIs.category_community_center
        navigationController!.pushViewController(viewController, animated: true)
    }
    func handleTap3(sender: UITapGestureRecognizer) {
        print("handleTap3")
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        viewController.categorytitle = "Museums"
        viewController.categoryurl = ServerAPIs.category_museums
        navigationController!.pushViewController(viewController, animated: true)
    }
    func handleTap4(sender: UITapGestureRecognizer) {
        print("handleTap4")
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        viewController.categorytitle = "Personal Events"
        viewController.categoryurl = ServerAPIs.category_personal_events
        navigationController!.pushViewController(viewController, animated: true)
    }
    func handleTap5(sender: UITapGestureRecognizer) {
        print("handleTap5")
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        viewController.categorytitle = "Associations"
        viewController.categoryurl = ServerAPIs.category_associations
        navigationController!.pushViewController(viewController, animated: true)
    }
    func handleTap6(sender: UITapGestureRecognizer) {
        print("handleTap6")
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        viewController.categorytitle = "Airports"
        viewController.categoryurl = ServerAPIs.category_airports
        navigationController!.pushViewController(viewController, animated: true)
    }
    func handleTap7(sender: UITapGestureRecognizer) {
        print("handleTap7")
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
        viewController.categorytitle = "National Parks"
        viewController.categoryurl = ServerAPIs.category_national_parks
        navigationController!.pushViewController(viewController, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setShadowToview(view: UIView) {
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 0.5
        
    }
    
}

extension HomeTabViewController1: UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myeventscollectionview{
            return myevents.count
        }else{
            return recommendedevents.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == myeventscollectionview{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyEventsCollectionViewCell", for: indexPath) as! MyEventsCollectionViewCell
            if myevents[indexPath.row].app_category != nil{
                cell.location_label.text = myevents[indexPath.row].app_category!
            }else{
                cell.location_label.text = ""
            }
            if myevents[indexPath.row].app_name != nil{
                cell.app_name_label.text = myevents[indexPath.row].app_name!
            }else{
                cell.app_name_label.text = ""
            }
            if myevents[indexPath.row].start_date != nil{
                let str = myevents[indexPath.row].start_date!
                let index = str.index(str.startIndex, offsetBy: 10)
                cell.date_label.text = str.substring(to: index)
            }else{
                cell.date_label.text = ""
            }
            cell.appImageView.sd_setImage(with: URL(string: myevents[indexPath.row].app_image!), placeholderImage: UIImage(named: "eventdemoimage"))
//            cell.appImageView?.sizeToFit()
            setShadowToview(view: cell)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyEventsCollectionViewCell", for: indexPath) as! MyEventsCollectionViewCell
            if recommendedevents[indexPath.row].location != nil{
                cell.location_label.text = recommendedevents[indexPath.row].app_category!
            }else{
                cell.location_label.text = ""
            }
            if recommendedevents[indexPath.row].app_name != nil{
                cell.app_name_label.text = recommendedevents[indexPath.row].app_name!
            }else{
                cell.app_name_label.text = ""
            }
            if recommendedevents[indexPath.row].start_date != nil{
                let str = recommendedevents[indexPath.row].start_date!
                let index = str.index(str.startIndex, offsetBy: 10)
                cell.date_label.text = str.substring(to: index)
            }else{
                cell.date_label.text = ""
            }
            cell.appImageView.sd_setImage(with: URL(string: recommendedevents[indexPath.row].app_image!), placeholderImage: UIImage(named: "eventdemoimage"))
//            cell.appImageView?.sizeToFit()
            setShadowToview(view: cell)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionViewheight-5)*112)/184 , height: collectionViewheight-5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != myeventscollectionview{
            var storyboard = UIStoryboard()
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
            case .pad:
                storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
            default:
                print("Dvice not detectable")
            }
            let viewController = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
            viewController.eventdetail = recommendedevents[indexPath.row]
            navigationController!.pushViewController(viewController, animated: true)
        }else
        {
          //  UserDefaults.standard.set("0", forKey: "preview")
            ConnectToSE().openMethodWithNotification(filekey: myevents[indexPath.row].appid!,parent: self)
        }
    }
}

extension HomeTabViewController1{
    
     func getevents() {
        getrecomendedevents(){ receiveddata in
            let response = receiveddata["response"] as! Bool
            DispatchQueue.main.async {
                
                if response == true{
                    print(response)
                    let events = receiveddata["events"] as! [AnyObject]
                    for data in events {
                        let data1 = Mapper<getPopularEvents>().map(JSONObject: data)
                        self.recommendedevents.append(data1!)
                        self.recommendedeventscollectionview.reloadData()
                    }
                    if self.recommendedevents.count == 0{
                        self.recommendedviewheight.constant = 0
                        self.recommendedlabelheight.constant = 0
                        self.recommendedeventscollectionview.isHidden = true
                        self.recommendedlabel.isHidden = true
                    }
                }else{
                    DispatchQueue.main.async(execute: {() -> Void in
                        if self.recommendedevents.count == 0{
                            self.recommendedviewheight.constant = 0
                            self.recommendedlabelheight.constant = 0
                            self.recommendedeventscollectionview.isHidden = true
                            self.recommendedlabel.isHidden = true
                        }
                        /*
                        let alert = UIAlertController(title: "Request Failed", message: receiveddata["responseString"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)*/
                    })
                }
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
      //  locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
      
                DispatchQueue.main.async(execute: {() -> Void in
                    if self.recommendedevents.count == 0{
                        self.recommendedviewheight.constant = 0
                        self.recommendedlabelheight.constant = 0
                        self.recommendedeventscollectionview.isHidden = true
                        self.recommendedlabel.isHidden = true
                    }
//                    let appname = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
//                    let alert = UIAlertController(title: "Location Not Enabled", message: "\(appname) is not able to access location.", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
//                        UIAlertAction in
//                    })
//                    alert.addAction(UIAlertAction(title: "Enable", style: UIAlertActionStyle.default) {
//                        UIAlertAction in
//                        UIApplication.shared.openURL(NSURL(string: "prefs:root=LOCATION_SERVICES")! as URL)
//                    })
//                    self.present(alert, animated: true, completion: nil)
                })
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        if geteventflag == true{
            DispatchQueue.global(qos: .background).async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.getevents()
                })
            })
            geteventflag = false
        }
        
    }
    
    func getrecomendedevents(completion: @escaping (_ Data: AnyObject) -> ()) {
        
        let requestURL: NSURL = NSURL(string: ServerAPIs.recommended_event + "latitude=\(userLocation.coordinate.latitude)&longitude=\(userLocation.coordinate.longitude)&distance=10")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            guard error == nil && data != nil else {
                print("error=\(error!)")
                /*
                DispatchQueue.main.async(execute: {() -> Void in
                    if self.recommendedevents.count == 0{
                        self.recommendedviewheight.constant = 0
                        self.recommendedlabelheight.constant = 0
                        self.recommendedeventscollectionview.isHidden = true
                        self.recommendedlabel.isHidden = true
                    }
                    let alert = UIAlertController(title: "ERROR CODE: \((error as! NSError).code)", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                    })
                    self.present(alert, animated: true, completion: nil)
                })*/
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            print(statusCode)
            print(data!)
            if (statusCode == 200) {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    print(parsedData)
                    completion(parsedData as AnyObject)
                } catch {
                    DispatchQueue.main.async(execute: {() -> Void in
                        if self.recommendedevents.count == 0{
                            self.recommendedviewheight.constant = 0
                            self.recommendedlabelheight.constant = 0
                            self.recommendedeventscollectionview.isHidden = true
                            self.recommendedlabel.isHidden = true
                        }
                    })
                    print("Error deserializing JSON: \(error)")
                }
            }else {
                DispatchQueue.main.async(execute: {() -> Void in
                    if self.recommendedevents.count == 0{
                        self.recommendedviewheight.constant = 0
                        self.recommendedlabelheight.constant = 0
                        self.recommendedeventscollectionview.isHidden = true
                        self.recommendedlabel.isHidden = true
                    }
                })
                print("status code is not 200")
            }
        }
        task.resume()
    }
    
    func removeFilesRequest(sender: UILongPressGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.began {
            let touchPoint = sender.location(in: myeventscollectionview)
            if let indexPath = myeventscollectionview.indexPathForItem(at: touchPoint) {
                print(indexPath.row)
                let alert = UIAlertController(title: "Remove Event!!!", message: "You are about to remove \"\(myevents[indexPath.row].app_name!)\"" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                })
                alert.addAction(UIAlertAction(title: "Remove", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.removeFilesFromDocs(appidtoremove: self.myevents[indexPath.row].appid!)
                    self.removinglocally(appidtoremove: self.myevents[indexPath.row].appid!)
                })
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func removeFilesFromDocs(appidtoremove: String) {
        let fileManager = FileManager.default
        let directory = FileManager.SearchPathDirectory.documentDirectory
        let filepath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
        let subDirectory = "SavingFiles"
        let file = filepath + "/\(subDirectory)/\(appidtoremove).json"
        do {
            try fileManager.removeItem(atPath: file)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }

    func removinglocally(appidtoremove: String)
    {
        
        //        let event = nearbyevents[tag].toAnyObject()
        var ns = [AnyObject]()
        let testFile1 = FileSaveHelper(fileName: "jsonFile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
        
        // 2
        do {
            let str =  try testFile1.getContentsOfFile()
            let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            
            do
            {
                let message = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers)
                if let jsonResult = message as? [AnyObject]
                {
                    
                    ns = jsonResult
                    
                }
                else
                {
                    print("error")
                }
            }
            catch
            {
                print("An error occurred: \(error)")
            }
            
        }catch {
            print (error)
        }
        
        print(ns)
        let ns1 = ns[0] as! [String: Any]
        print(ns1)
        
        for count in 0 ..< ns.count {
            let ns1 = ns[count] as! [String: Any]
            print(ns1["appid"]!)
            if (ns1["appid"] as! String) == appidtoremove{
                ns.remove(at: count)
                let jsonFile = FileSaveHelper(fileName:"jsonFile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
                
                do {
                    try jsonFile.saveFile(dataForJson: ns as AnyObject )
                }
                catch {
                    print(error)
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadMyEvents"), object: nil)

                return
            }
        }
        
    }

}
