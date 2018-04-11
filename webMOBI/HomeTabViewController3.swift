//
//  HomeTabViewController3.swift
//  webMOBI
//
//  Created by webmobi on 5/18/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage

class HomeTabViewController3: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var populareventstableview: UITableView!
    
    var popularevents : [getPopularEvents] = [getPopularEvents]()
    var firstload = true
    private var lastContentOffset: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        print("did load",self.view.frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.isNavigationBarHidden = false
        print("will appear",self.view.frame)
        if firstload == true{
            getevents()
            firstload = false
        }
        self.populareventstableview.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("did appear",self.view.frame)
    }
    
}

extension HomeTabViewController3{
    
    func getevents() {
        getpopularevents(){ receiveddata in
            let response = receiveddata["response"] as! Bool
            DispatchQueue.main.async {
                
                if response == true{
                    print(response)
                    let events = receiveddata["events"] as! [AnyObject]
                    for data in events {
                        let data1 = Mapper<getPopularEvents>().map(JSONObject: data)
                        self.popularevents.append(data1!)
                        self.populareventstableview.reloadData()
                        if data1?.accesstype == "dashboard"{
                            print("dashboard")
                        }
                    }
                }
            }
        }
    }
    
    func initVC() {
        populareventstableview.delegate = self
        populareventstableview.register(UINib(nibName: "EventsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsTableViewCell")
        populareventstableview.separatorStyle = .none
    }
    
    func getpopularevents(completion: @escaping (_ Data: AnyObject) -> ()) {
        self.view.addLoader()
        let requestURL: NSURL = NSURL(string: ServerAPIs.get_popular_events)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            guard error == nil && data != nil else {
                print("error=\(error!)")
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
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.removeLoader()
                })
            })
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            print(statusCode)
            print(data!)
            if (statusCode == 200) {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    //                    print(parsedData)
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularevents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as! EventsTableViewCell
        if popularevents[indexPath.row].app_name != nil{
            cell.app_name_label.text = popularevents[indexPath.row].app_name!
        }else{
            cell.app_name_label.text = ""
        }
        if popularevents[indexPath.row].location != nil{
            cell.location_label.text = popularevents[indexPath.row].location!
        }else{
            cell.location_label.text = ""
        }
        if popularevents[indexPath.row].start_date != nil{
            let str = popularevents[indexPath.row].start_date!
            let index = str.index(str.startIndex, offsetBy: 10)
            cell.date_label.text = str.substring(to: index)
        }else{
            cell.date_label.text = ""
        }
        cell.appImageView.sd_setImage(with: URL(string: popularevents[indexPath.row].app_image!), placeholderImage: UIImage(named: "eventdemoimage"))
        cell.selectionStyle = .none
        cell.moredetailbutton.tag = indexPath.row
        cell.discoverymoreDetailBtn.tag = indexPath.row
        cell.downloadeventbutton.tag = indexPath.row
        cell.discoverymoreDetailBtn.removeTarget(self, action: nil, for: .touchUpInside)
        cell.moredetailbutton.removeTarget(self, action: nil, for: .touchUpInside)
        cell.downloadeventbutton.removeTarget(self, action: nil, for: .touchUpInside)
        
        if popularevents[indexPath.row].accesstype == "discovery"{
            cell.downloadeventbutton.isHidden = true
            cell.moredetailbutton.isHidden = true
            cell.discoverymoreDetailBtn.isHidden = false
            cell.discoverymoreDetailBtn.setTitle("More Details", for: .normal)
            cell.discoverymoreDetailBtn.addTarget(self, action: #selector(self.moredetail(_:)), for: .touchUpInside)
        }else
        {
            if(popularevents[indexPath.row].appid?.isEmpty == false)
            {
                let filename = popularevents[indexPath.row].appid!
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
        let bool = CoreDataManager.checkforeventID(id: popularevents[indexPath.row].appid!)
        cell.changefavbtnlogo(addedinFav: bool)
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: #selector(self.addtoFav(_:)), for: .touchUpInside)
        return cell
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
        let viewController = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        viewController.eventdetail = popularevents[sender.tag]
        navigationController!.pushViewController(viewController, animated: true)
    }
    
    func addtoFav(_ sender: UIButton) {
        print(sender.tag)
        let bool = CoreDataManager.checkforeventID(id: popularevents[sender.tag].appid!)
        if(bool)
        {
            CoreDataManager.cleanseletedEvent(id: popularevents[sender.tag].appid!)
        }else
        {
            CoreDataManager.storeFavEvents(event: popularevents[sender.tag])
        }
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.populareventstableview.reloadData()
            })
        })
        //DownloadEvent().addtofavorite(event: nearbyevents[sender.tag].toAnyObject())
    }
    func openApp(_ sender: UIButton)
    {
      
        ConnectToSE().openMethodWithNotification(filekey: popularevents[sender.tag].appid!,parent: self)
    }
    
    func downloaddetail(_ sender: UIButton) {
        print(sender.tag)
        let appid = popularevents[sender.tag].appid!
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
                let obj = self.popularevents[sender.tag].toAnyObject()
                if let url = self.popularevents[sender.tag].app_url,let id = self.popularevents[sender.tag].appid{
                    
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
                                    self.populareventstableview.reloadData()
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
        //        viewController.eventdetail = popularevents[indexPath.row]
        //        navigationController!.pushViewController(viewController, animated: true)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        //        vc.eventdetail = popularevents[indexPath.row]
        //        vc.tbd = true
        //        let navigationController = UINavigationController(rootViewController: vc)
        //        self.present(navigationController, animated: true, completion: nil)
        
    }
    
}
