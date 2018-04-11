//
//  SearchViewController.swift
//  webMOBI
//
//  Created by webmobi on 5/18/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var infolabel: UILabel!
    @IBOutlet weak var searchtableview: UITableView!
    @IBOutlet weak var blurimageview: UIImageView!
    @IBOutlet weak var searchtextfield: UITextField!
    @IBOutlet weak var blurview: UIView!
    var checkforlogin = ""
    var searchevents : [getPopularEvents] = [getPopularEvents]()
    var isprivate_event : Bool = false
    var userid = ""
    var searched_key = ""
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        searchtextfield.setBottomBorder()
        self.view.isOpaque = true
        searchtextfield.textColor = UIColor.white
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurview.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurview.addSubview(blurEffectView)
        searchtableview.tableFooterView = UIView()
        searchtableview.delegate = self
        searchtableview.register(UINib(nibName: "EventsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsTableViewCell")
        searchtableview.register(UINib(nibName: "EventsPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsPreviewTableViewCell")
        searchtableview.separatorStyle = .none
        if checkforlogin == "Default"{
            infolabel.isHidden = true
        }else{
            infolabel.isHidden = false
        }
        searchtextfield.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchevents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if infolabel.isHidden == false{
            infolabel.isHidden = true
        }
        if searchtableview.backgroundColor != UIColor.white{
            searchtableview.backgroundColor = UIColor.white
        }
        let preview_flag = defaults.string(forKey: "preview")
      
        if(preview_flag == "1"){
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventsPreviewTableViewCell", for: indexPath) as! EventsPreviewTableViewCell
            let str = searchevents[indexPath.row].start_date!
            let index = str.index(str.startIndex, offsetBy: 10)
            cell.app_name_label.text = searchevents[indexPath.row].app_name
            cell.location_label.text = searchevents[indexPath.row].location
            cell.appImageView.sd_setImage(with: URL(string: searchevents[indexPath.row].app_image!), placeholderImage: UIImage(named: "eventdemoimage"))
            cell.date_label.text = str.substring(to: index)
            cell.selectionStyle = .none
            cell.moredetailbutton.tag = indexPath.row
            cell.discoverymoreDetailBtn.tag = indexPath.row
            cell.downloadeventbutton.tag = indexPath.row
            cell.discoverymoreDetailBtn.removeTarget(self, action: nil, for: .touchUpInside)
            cell.moredetailbutton.removeTarget(self, action: nil, for: .touchUpInside)
            cell.downloadeventbutton.removeTarget(self, action: nil, for: .touchUpInside)
            
            
            if searchevents[indexPath.row].accesstype == "discovery"{
                cell.downloadeventbutton.isHidden = true
                cell.moredetailbutton.isHidden = true
                cell.discoverymoreDetailBtn.isHidden = false
                cell.discoverymoreDetailBtn.setTitle("More Details", for: .normal)
                cell.discoverymoreDetailBtn.addTarget(self, action: #selector(self.moredetail(_:)), for: .touchUpInside)
            }else
            {
                
                if(searchevents[indexPath.row].appid?.isEmpty == false)
                {
                    let filename = searchevents[indexPath.row].appid!
                   
                    DownloadEvent().checkfileExist(_filename:filename){ existflag in
                        if(existflag)
                        {
//                            UserDefaults.standard.set(false, forKey: "downloadpreviewapp")
                            if(UserDefaults.standard.bool(forKey: "downloadpreviewapp"))
                            {
                                let fileManager = FileManager.default
                                let tempFolderPath = NSTemporaryDirectory()
                                do {
                                    let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
                                    for filePath in filePaths {
                                        if(filePath == "filename")
                                        {
                                        try fileManager.removeItem(atPath: tempFolderPath + filePath)
                                        }
                                    }
                                } catch {
                                    print("Could not clear temp folder: \(error)")
                                }
                            cell.downloadeventbutton.isHidden = true
                            cell.moredetailbutton.isHidden = true
                            cell.discoverymoreDetailBtn.isHidden = false
                            cell.discoverymoreDetailBtn.setTitle("Preview", for: .normal)
                            cell.discoverymoreDetailBtn.addTarget(self, action: #selector(self.openApp(_:)), for: .touchUpInside)
                            }
                            else
                            {
                            cell.downloadeventbutton.isHidden = false
                            cell.moredetailbutton.isHidden = false
                            cell.discoverymoreDetailBtn.isHidden = true
                            cell.moredetailbutton.addTarget(self, action: #selector(self.moredetail(_:)), for: .touchUpInside)
                            cell.downloadeventbutton.addTarget(self, action: #selector(self.downloaddetail(_:)), for: .touchUpInside)
                            }
                        }else
                        {
                            cell.downloadeventbutton.isHidden = false
                            cell.moredetailbutton.isHidden = false
                            cell.discoverymoreDetailBtn.isHidden = true
                            cell.moredetailbutton.addTarget(self, action: #selector(self.moredetail(_:)), for: .touchUpInside)
                            cell.downloadeventbutton.addTarget(self, action: #selector(self.downloaddetail(_:)), for: .touchUpInside)
                        }
                    }
//                    cell.downloadeventbutton.isHidden = false
//                    cell.moredetailbutton.isHidden = false
//                    cell.discoverymoreDetailBtn.isHidden = true
//                    cell.moredetailbutton.addTarget(self, action: #selector(self.moredetail(_:)), for: .touchUpInside)
//                    cell.downloadeventbutton.addTarget(self, action: #selector(self.previewdetail(_:)), for: .touchUpInside)
//
//
                    
                }else
                {
                    cell.downloadeventbutton.isHidden = true
                    cell.moredetailbutton.isHidden = true
                    cell.discoverymoreDetailBtn.isHidden = false
                    cell.discoverymoreDetailBtn.setTitle("More Details", for: .normal)
                    cell.discoverymoreDetailBtn.addTarget(self, action: #selector(self.moredetail(_:)), for: .touchUpInside)
                }
                
                
        }
            let bool = CoreDataManager.checkforeventID(id: searchevents[indexPath.row].appid!)
            cell.changefavbtnlogo(addedinFav: bool)
            cell.favBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action: #selector(self.addtoFav(_:)), for: .touchUpInside)
            return cell
        }else {
           let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as! EventsTableViewCell
            
        
        
        let str = searchevents[indexPath.row].start_date!
        let index = str.index(str.startIndex, offsetBy: 10)
        cell.app_name_label.text = searchevents[indexPath.row].app_name
        cell.location_label.text = searchevents[indexPath.row].location
        cell.appImageView.sd_setImage(with: URL(string: searchevents[indexPath.row].app_image!), placeholderImage: UIImage(named: "eventdemoimage"))
        cell.date_label.text = str.substring(to: index)
        cell.selectionStyle = .none
        cell.moredetailbutton.tag = indexPath.row
        cell.discoverymoreDetailBtn.tag = indexPath.row
        cell.downloadeventbutton.tag = indexPath.row
        cell.discoverymoreDetailBtn.removeTarget(self, action: nil, for: .touchUpInside)
        cell.moredetailbutton.removeTarget(self, action: nil, for: .touchUpInside)
        cell.downloadeventbutton.removeTarget(self, action: nil, for: .touchUpInside)
   
        
        if searchevents[indexPath.row].accesstype == "discovery"{
            cell.downloadeventbutton.isHidden = true
            cell.moredetailbutton.isHidden = true
            cell.discoverymoreDetailBtn.isHidden = false
            cell.discoverymoreDetailBtn.setTitle("More Details", for: .normal)
            cell.discoverymoreDetailBtn.addTarget(self, action: #selector(self.moredetail(_:)), for: .touchUpInside)
        }else
        {
            if(searchevents[indexPath.row].appid?.isEmpty == false)
            {
                let filename = searchevents[indexPath.row].appid!
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
            let bool = CoreDataManager.checkforeventID(id: searchevents[indexPath.row].appid!)
            cell.changefavbtnlogo(addedinFav: bool)
            cell.favBtn.tag = indexPath.row
            cell.favBtn.addTarget(self, action: #selector(self.addtoFav(_:)), for: .touchUpInside)
            return cell
            }
       
    }
    
    func addtoFav(_ sender: UIButton) {
        print(sender.tag)
        let bool = CoreDataManager.checkforeventID(id: searchevents[sender.tag].appid!)
        if(bool)
        {
            CoreDataManager.cleanseletedEvent(id: searchevents[sender.tag].appid!)
        }else
        {
            CoreDataManager.storeFavEvents(event: searchevents[sender.tag])
        }
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.searchtableview.reloadData()
            })
        })
        //DownloadEvent().addtofavorite(event: nearbyevents[sender.tag].toAnyObject())
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
        let vc = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        vc.eventdetail = searchevents[sender.tag]
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func openApp(_ sender: UIButton)
    {
        ConnectToSE().openMethodWithNotification(filekey: searchevents[sender.tag].appid!,parent: self)
    }
    
    func downloaddetail(_ sender: UIButton) {
        print(sender.tag)
        let appid = searchevents[sender.tag].appid!
        self.defaults.set(appid, forKey: "single_appid")
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
                let obj = self.searchevents[sender.tag].toAnyObject()
                if let url = self.searchevents[sender.tag].app_url,let id = self.searchevents[sender.tag].appid{
                    
                    DownloadEvent().singleEvent(appID:id,appURL: url,event:obj){ receiveddata in
                        if(receiveddata){
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadMyEvents"), object: nil)
                            var password = ""
                            if UserDefaults.standard.value(forKey: "userlogindata") != nil{
                                if self.isprivate_event{
                                    password = self.searched_key
                                }else{
                                    password = UserDefaults.standard.string(forKey: "discovery_password")!
                                }
                            }
                            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    CoreDataManager.storeDownlodedEvent(appid: id, isfirstlogin: false, password: password)
                                    self.searchtableview.reloadData()
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
        return 280
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
//        vc.eventdetail = searchevents[indexPath.row]
//        let navigationController = UINavigationController(rootViewController: vc)
//        self.present(navigationController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchcloseButtonAction(_ sender: UIButton) {
        //         _ = self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getevents()
        if isprivate_event{
            searched_key = searchtextfield.text!
        }else{
            var password = ""
            if UserDefaults.standard.value(forKey: "userlogindata") != nil{
                password = UserDefaults.standard.string(forKey: "discovery_password")!
            }
            searched_key = password
        }
        searchtextfield.resignFirstResponder()
        return true
    }
}

extension SearchViewController{
    func getevents() {
        self.view.addLoader()
        getpopularevents(){ receiveddata in
            let response = receiveddata["response"] as! Bool
            DispatchQueue.main.async {
                
                if response == true{
//                    print(response)
                    let events = receiveddata["events"] as! [AnyObject]
                    self.searchevents.removeAll()
                    for data in events {
                        let data1 = Mapper<getPopularEvents>().map(JSONObject: data)
                        self.searchevents.append(data1!)
                        self.searchtableview.reloadData()
                        if data1?.accesstype == "dashboard"{
                            print("dashboard")
                        }
                    }
                    self.view.removeLoader()
                }else{
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "Request Failed", message: receiveddata["responseString"]! as! String?, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    //
    //    func initVC() {
    //        searchtableview.delegate = self
    //        searchtableview.register(UINib(nibName: "EventsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsTableViewCell")
    //        searchtableview.separatorStyle = .none
    //    }
    
    func getpopularevents(completion: @escaping (_ Data: AnyObject) -> ()) {
        var event_url = ""
        var searchstr = searchtextfield.text!
        searchstr = searchstr.lowercased()
        if(searchstr.contains("_preview")){
            self.defaults.set(true, forKey: "preview")
            let search = searchstr.replacingOccurrences(of: "_", with: " ")
            let searcharray = search.components(separatedBy: " ")
            
                if isprivate_event{
                    event_url = ServerAPIs.private_event_search + searcharray[0] + "&userid=" + userid
                }else{
                    event_url = ServerAPIs.event_search + searcharray[0] + "&preview_flag=1"
                }
            UserDefaults.standard.set(false, forKey: "downloadpreviewapp")

        } else {
        self.defaults.set(false, forKey: "preview")
        if isprivate_event{
            event_url = ServerAPIs.private_event_search + searchstr + "&userid=" + userid
        }else{
            event_url = ServerAPIs.event_search + searchstr +  "&preview_flag=0"
        }
        }
        let requestURL: NSURL = NSURL(string: (event_url).addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
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
//            print(data!)
            if (statusCode == 200) {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
//                    print(parsedData)
                    if ((parsedData["response"] as! Bool) == true){
                        completion(parsedData as AnyObject)
                    }else{
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.view.removeLoader()
                            let alert = UIAlertController(title: "Request Failed", message: parsedData["responseString"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
                } catch {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "Request Failed", message: "Try Again", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }else {
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.removeLoader()
                    let alert = UIAlertController(title: "Request Failed", message: "Try Again", preferredStyle: UIAlertControllerStyle.alert)
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
