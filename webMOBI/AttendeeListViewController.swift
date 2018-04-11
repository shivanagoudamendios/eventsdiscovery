//
//  AttendeeListViewController.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/20/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import MBProgressHUD
class AttendeeListViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var attendeeSearch: UISearchBar!
    @IBOutlet weak var attendeeTableview: UITableView!
    
    var attendeesList : [String : [Attendee]] = [:]
    var originalList : [Attendee] = []
    var defaults = UserDefaults.standard
    var hud = MBProgressHUD()
    var sortkeys : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        attendeeTableview.register(UINib(nibName: "AttendeesTableViewCell", bundle: nil), forCellReuseIdentifier: "AttendeesTableViewCell")
        
        attendeeTableview.tableFooterView = UIView()
        attendeeTableview.estimatedRowHeight = 75
        attendeeTableview.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Attendees"
        
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
            attendeeSearch.barTintColor = UIColor.init(hex: themeclr)
        }
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
        attendeesRequest()
       // setupLayoutImage(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        attendeeSearch.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var filterlist : [Attendee] = []
        if(searchText.length > 0)
        {
            for obj in originalList{
                
                if(obj.first_name?.contains(searchText))!
                {
                    filterlist.append(obj)
                }
                
            }
            seperatebyname(list: filterlist)
        }else
        {
            seperatebyname(list: originalList)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func attendeesRequest()
    {
        
        hud.hide(true)
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.labelText = "Processing..."
        hud.alpha = 0.5
        
        //        if let themeclr = defaults.string(forKey: "themeColor"){
        //            hud.labelColor = UIColor.init(hex: themeclr)
        //            hud.activityIndicatorColor = UIColor.init(hex: themeclr)
        //        }
        
        let token = defaults.string(forKey: "token")
        let urlPath: String = ServerApis.AttendeesUrl+defaults.string(forKey: "selectedappid")!
        let url: URL = URL(string: urlPath.addingPercentEscapes(using: String.Encoding.utf8)!)!
        
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15.0)
        
        request.setValue(token, forHTTPHeaderField: "Token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                //                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true)
                        let alert = UIAlertController(title: "Request Failed", message: "Please Check The connection Try Again", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                })
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //                print("response = \(response)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true)
                        let alert = UIAlertController(title: "Request Failed", message: "Please Check The connection Try Again", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                })
            }else{
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        print("Synchronous\(jsonResult)")
                        let responseFlg = jsonResult["response"] as? Bool
                        let jsonResult1 = jsonResult["responseString"] as AnyObject
                        if(responseFlg)!
                        {
                            
                            var list = Mapper<Attendee>().mapArray(JSONObject: jsonResult1["users"])
                            
                            list = list?.sorted(){ $0.first_name! < $1.first_name! }
                            self.originalList = list!
                            
                            self.seperatebyname(list: list!)
                            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    self.hud.hide(true)
                                })
                            })
                        }else
                        {
                            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    self.hud.hide(true)
                                })
                            })
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true)
                            let alert = UIAlertController(title: "Request Failed", message: "Please Check The connection Try Again", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                    
                }
            }
        }
        task.resume()
    }

    func seperatebyname(list : [Attendee])
    {
        var arraylist : [String : [Attendee]] = [String : [Attendee]]()
        
        for obj in list{
            let firstLetter = String(describing: obj.first_name!.first)
            
            if(arraylist.keys.contains(firstLetter))
            {
                var array = arraylist[firstLetter]
                array?.append(obj)
                arraylist[firstLetter] = array
            }else
            {
                arraylist[firstLetter] = [obj]
            }
            
        }
        self.sortkeys = arraylist.keys.sorted(by: < )
        
        self.attendeesList = arraylist
        DispatchQueue.main.async(execute: {() -> Void in
            self.attendeeTableview.reloadData()
        })
    }
}

extension AttendeeListViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sortkeys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sortkeys[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sortkeys[section]
        return  (self.attendeesList[key]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let nib = UINib(nibName: "resultCell", bundle: nil)
        //        tableView.registerNib(nib, forCellReuseIdentifier:"ResultViewCell")
        
        let cell: AttendeesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AttendeesTableViewCell") as! AttendeesTableViewCell
        
        let key = sortkeys[indexPath.section]
        let full_name = (self.attendeesList[key]?[indexPath.row].first_name)! + " " + (self.attendeesList[key]?[indexPath.row].last_name)!
        cell.titleLabel.text = full_name
        if(self.attendeesList[key]?[indexPath.row].designation?.isEmpty == false && self.attendeesList[key]?[indexPath.row].company?.isEmpty == false)
        {
            cell.descLabel.text = (self.attendeesList[key]?[indexPath.row].designation)!+", "+(self.attendeesList[key]?[indexPath.row].company)!
        }else if(self.attendeesList[key]?[indexPath.row].designation?.isEmpty == false)
        {
            cell.descLabel.text = self.attendeesList[key]?[indexPath.row].designation
        }else
        {
            cell.descLabel.text = ""
        }
        
        
        let urlstr = self.attendeesList[key]?[indexPath.row].profile_pic
        if(urlstr?.isEmpty == false)
        {
            cell.ImgView.isHidden = false
            cell.firstCharLabel.isHidden = true
            DispatchQueue.main.async(execute: { () -> Void in
                //                let costumUrl = urlstr! + "?dt=" + self.getCurrentMillis().description
                ImageLoadingWithCache().getImage(url: urlstr!, imageView:  cell.ImgView, defaultImage: "EmptyUser.png")
                
                
            })
        }else
        {
            
            cell.ImgView.isHidden = true
            cell.firstCharLabel.isHidden = false
            cell.firstCharLabel.text =  cell.titleLabel.text?.first
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! AttendeesTableViewCell
        
        let key = sortkeys[indexPath.section]
        let AttendeeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "AttendeeDetailViewController") as! AttendeeDetailViewController
        
        AttendeeDetailView.attendeeId = (self.attendeesList[key]?[indexPath.row].userid)!
        if(self.attendeesList[key]?[indexPath.row].profile_pic?.isEmpty == false)
        {
            AttendeeDetailView.ImgUrl = (self.attendeesList[key]?[indexPath.row].profile_pic)!
            AttendeeDetailView.colorCode = UIColor.white
        }else
        {
            AttendeeDetailView.ImgUrl = ""
            AttendeeDetailView.colorCode = cell.firstCharLabel.backgroundColor
        }
        
        let full_name = (self.attendeesList[key]?[indexPath.row].first_name)! + " " + (self.attendeesList[key]?[indexPath.row].last_name)!
        AttendeeDetailView.attendeename = full_name
        
        if(self.attendeesList[key]?[indexPath.row].designation?.isEmpty == false && self.attendeesList[key]?[indexPath.row].company?.isEmpty == false)
        {
            AttendeeDetailView.attendeeDesc = (self.attendeesList[key]?[indexPath.row].designation)!+", "+(self.attendeesList[key]?[indexPath.row].company)!
        }else if(self.attendeesList[key]?[indexPath.row].designation?.isEmpty == false)
        {
            AttendeeDetailView.attendeeDesc = (self.attendeesList[key]?[indexPath.row].designation)!
        }else
        {
            AttendeeDetailView.attendeeDesc = ""
        }
        
        if(self.attendeesList[key]?[indexPath.row].desc?.isEmpty == false)
        {
            AttendeeDetailView.descriptionfortextview = (self.attendeesList[key]?[indexPath.row].desc)!
        }else
        {
            AttendeeDetailView.descriptionfortextview = ""
        }
        
        if(self.attendeesList[key]?[indexPath.row].blogurl?.isEmpty == false)
        {
            AttendeeDetailView.blog_url = (self.attendeesList[key]?[indexPath.row].blogurl)!
        }else
        {
            AttendeeDetailView.blog_url = ""
        }

        self.navigationController?.pushViewController(AttendeeDetailView, animated: true)
        
    }
    func getCurrentMillis()->Int64{
        return  Int64(NSDate().timeIntervalSince1970 * 1000)
    }
    
}
