//
//  MyScheduleViewController.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 5/17/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import MBProgressHUD
import ObjectMapper
class MyScheduleViewController: UITableViewController ,NSURLConnectionDelegate{
    
    
    var data = NSMutableData()
    var scheduledata = [AnyObject]()
    var agendaname = [String]()
    var scheduled = [Double : [AgendaDetails]]()
    var sortkeys : [Double] = []
    let defaults = UserDefaults.standard
    
    var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Schedules"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        
        tableView.register(UINib(nibName: "NewAgendaTableViewCell", bundle: nil), forCellReuseIdentifier: "NewAgendaTableViewCell")
        tableView.register(UINib(nibName: "NewAgendaSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "NewAgendaSectionHeaderView")
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 67
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let favList : [Int64] = CoreDataManager.GetAllScheduleFavorites()
        print(favList)
        
        if let data = defaults.object(forKey: "agendadata1") as? NSData {
            let agenda = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [AnyObject]
            let agendaArray = Mapper<AgendaInAgenda>().mapArray(JSONObject: agenda)!
            self.scheduled = [:]
            for agenda in agendaArray{
                for details in agenda.detail!{
                    if (favList.contains(Int64(details.agendaId!)))
                    {
                        if(scheduled.keys.contains(agenda.name!))
                        {
                            var schedulArray  = scheduled[agenda.name!]
                            schedulArray?.append(details)
                            schedulArray = schedulArray?.sorted() { $0.fromtime! < $1.fromtime! }
                            scheduled[agenda.name!] = schedulArray
                        }else
                        {
                            scheduled[agenda.name!] = [details]
                        }
                        
                       
                    }
                }
                
            }
             self.sortkeys = scheduled.keys.sorted(by: < )
            tableView.reloadData()
        }
        
        self.setNavigationBarItem()
        
    }
   
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sortkeys.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
   override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewAgendaSectionHeaderView") as! NewAgendaSectionHeaderView
            view.sectiontitle.text = TimeConversion().stringfrommilliseconds(ms: sortkeys[section], format: "yyyy-MM-dd")
        return view
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sortkeys[section]
        return  (self.scheduled[key]?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewAgendaTableViewCell", for: indexPath) as! NewAgendaTableViewCell
        let locationicon = String.fontAwesomeIcon(code: "fa-map-marker")
        
            let section = sortkeys[indexPath.section]
            let details = scheduled[section]?[indexPath.row]
            cell.selectionStyle = .none
            cell.starttime.text = TimeConversion().stringfrommilliseconds(ms: (details?.fromtime)!, format: "hh:mm a")
            cell.endtime.text = TimeConversion().stringfrommilliseconds(ms: (details?.totime)!, format: "hh:mm a")
            cell.title.text = (details?.topic)!
            cell.location.font = UIFont.fontAwesome(ofSize: 15)
            cell.location.text = locationicon! + "  " + (details?.location)!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewEventDetailsViewController") as! NewEventDetailsViewController
        nextViewController.title = "Details"
        nextViewController.fromfav = true
        let section = sortkeys[indexPath.section]
        let details = scheduled[section]?[indexPath.row]
        nextViewController.EventDetail = details
       
        nextViewController.fromagenda = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    
}
