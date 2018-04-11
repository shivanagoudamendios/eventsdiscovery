//
//  CategoryTableViewController.swift
//  webMOBI
//
//  Created by webmobi on 5/22/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class CategoryTableViewController: UITableViewController {
    
    var events : [getPopularEvents] = [getPopularEvents]()
    var categoryurl = ""
    var categorytitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.register(UINib(nibName: "EventsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsTableViewCell")
        tableView.separatorStyle = .none
        self.title = categorytitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        getevents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30/255, green: 112/255, blue: 145/255, alpha: 1)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as! EventsTableViewCell
        cell.location_label.text = events[indexPath.row].location
        cell.app_name_label.text = events[indexPath.row].app_name
        if events[indexPath.row].start_date != nil{
            let str = events[indexPath.row].start_date!
            let index = str.index(str.startIndex, offsetBy: 10)
            cell.date_label.text = str.substring(to: index)
        }else{
            cell.date_label.text = ""
        }
        cell.appImageView.sd_setImage(with: URL(string: events[indexPath.row].app_image!), placeholderImage: UIImage(named: "eventdemoimage"))
        cell.imageView?.sizeToFit()
        cell.selectionStyle = .none
        cell.moredetailbutton.tag = indexPath.row
        cell.discoverymoreDetailBtn.tag = indexPath.row
        cell.downloadeventbutton.tag = indexPath.row
        cell.discoverymoreDetailBtn.removeTarget(self, action: nil, for: .touchUpInside)
        cell.moredetailbutton.removeTarget(self, action: nil, for: .touchUpInside)
        cell.downloadeventbutton.removeTarget(self, action: nil, for: .touchUpInside)
        
        if events[indexPath.row].accesstype == "discovery"{
            cell.downloadeventbutton.isHidden = true
            cell.moredetailbutton.isHidden = true
            cell.discoverymoreDetailBtn.isHidden = false
            cell.discoverymoreDetailBtn.setTitle("More Details", for: .normal)
            cell.discoverymoreDetailBtn.addTarget(self, action: #selector(self.moredetail(_:)), for: .touchUpInside)
        }else
        {
            if(events[indexPath.row].appid?.isEmpty == false)
            {
                let filename = events[indexPath.row].appid!
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
        let bool = CoreDataManager.checkforeventID(id: events[indexPath.row].appid!)
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
        viewController.eventdetail = events[sender.tag]
        navigationController!.pushViewController(viewController, animated: true)
    }
    func addtoFav(_ sender: UIButton) {
        print(sender.tag)
        let bool = CoreDataManager.checkforeventID(id: events[sender.tag].appid!)
        if(bool)
        {
            CoreDataManager.cleanseletedEvent(id: events[sender.tag].appid!)
        }else
        {
            CoreDataManager.storeFavEvents(event: events[sender.tag])
        }
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.tableView.reloadData()
            })
        })
        //DownloadEvent().addtofavorite(event: nearbyevents[sender.tag].toAnyObject())
    }
    
    func openApp(_ sender: UIButton)
    {
        ConnectToSE().openMethodWithNotification(filekey: events[sender.tag].appid!,parent: self)
    }
    
    func downloaddetail(_ sender: UIButton) {
        print(sender.tag)
        let appid = events[sender.tag].appid!
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
                let obj = self.events[sender.tag].toAnyObject()
                if let url = self.events[sender.tag].app_url,let id = self.events[sender.tag].appid{
                    
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
                                    self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 280
        case .pad:
            return 320
        default:
            return 280
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        //        viewController.eventdetail = events[indexPath.row]
        //        navigationController!.pushViewController(viewController, animated: true)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        //        vc.eventdetail = popularevents[indexPath.row]
        //        vc.tbd = true
        //        let navigationController = UINavigationController(rootViewController: vc)
        //        self.present(navigationController, animated: true, completion: nil)
        
    }
    
}

extension CategoryTableViewController{
    
    func getevents() {
        DispatchQueue.main.async(execute: {() -> Void in
            self.view.addLoader()
        })
        getpopularevents(){ receiveddata in
            let response = receiveddata["response"] as! Bool
            DispatchQueue.main.async {
                
                if response == true{
                    print(response)
                    let events = receiveddata["events"] as! [AnyObject]
                    for data in events {
                        let data1 = Mapper<getPopularEvents>().map(JSONObject: data)
                        self.events.append(data1!)
                        self.tableView.reloadData()
                    }
                }else{
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "Request Failed", message: receiveddata["responseString"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    func getpopularevents(completion: @escaping (_ Data: AnyObject) -> ()) {
        
        let requestURL: NSURL = NSURL(string: categoryurl)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            guard error == nil && data != nil else {
                print("error=\(error!)")
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.removeLoader()
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
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                    })
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    
                    completion(parsedData as AnyObject)
                } catch {
                    self.view.removeLoader()
                    print("Error deserializing JSON: \(error)")
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "Request Failed", message: "Try again", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }else if (statusCode == 204){
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.removeLoader()
                    let alert = UIAlertController(title: "Request Failed", message: "Try again", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                    })
                    self.present(alert, animated: true, completion: nil)
                })
            }else if (statusCode == 400){
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.removeLoader()
                    let alert = UIAlertController(title: "Request Failed", message: "Try again", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                    })
                    self.present(alert, animated: true, completion: nil)
                })
            }else{
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.removeLoader()
                    let alert = UIAlertController(title: "Request Failed", message: "Try again", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                    })
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
        task.resume()
    }
}
