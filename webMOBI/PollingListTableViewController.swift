//
//  PollingListTableViewController.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 9/26/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class PollingListTableViewController: UITableViewController {

    var pollingArray = [newPollingItems]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        tableView.tableFooterView = UIView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        super.viewWillAppear(animated)
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
        
        let dataFromDefaultsAsNsData = defaults.object(forKey: "pollingData")
        if let dataAtIndex = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaultsAsNsData! as! Data){
            let dataFromDefaults = Mapper<Polling>().map(JSONObject: dataAtIndex)?.items
            pollingArray = dataFromDefaults!
            tableView.reloadData()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pollingArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let nib = UINib(nibName: "resultCell", bundle: nil)
        //        tableView.registerNib(nib, forCellReuseIdentifier:"ResultViewCell")
        
        let cell: PollingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PollingTableViewCell") as! PollingTableViewCell
        cell.pollingName.text = pollingArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let survayview = self.storyboard?.instantiateViewController(withIdentifier: "NewSurveyViewController") as! NewSurveyViewController
        survayview.title = ""
        survayview.pollingname = pollingArray[indexPath.row].name!
        survayview.pollingindex = indexPath.row
        var plooingData : [newSurveyItems] = [newSurveyItems]()
        let dataFromDefaultsAsNsData = defaults.object(forKey: "pollingData")
        if let dataAtIndex = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaultsAsNsData! as! Data){
            let dataFromDefaults = Mapper<Polling>().map(JSONObject: dataAtIndex)?.items
            let pollingArray = dataFromDefaults!
            plooingData = pollingArray[indexPath.row].poll!
        }

        
//        let dataAtIndex = pollingArray[indexPath.row].poll
//        let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
//        defaults.set(nsdataObj, forKey: "surveyData")
        defaults.set(0, forKey: "questionno")
//        if let dataFromDefaults = defaults.object(forKey: "surveyData") as? NSData{
//            if let objectFromDefaults = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as Data) as? [newSurveyItems]{
                if(plooingData.count > 0)
                {
                    self.navigationController?.pushViewController(survayview, animated: true)
                }else
                {
                    UIAlertView(title: "Survey Not Available",message: "No Questions Available",delegate: nil,cancelButtonTitle: "OK").show()
                }
//            }
//        }

        
        
    }

}
