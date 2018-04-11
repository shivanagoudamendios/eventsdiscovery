//
//  FloorPlansViewController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/14/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class FloorPlansViewController: UITableViewController {
    var floorsArray = [Floors]()
    let defaults = UserDefaults.standard;
    override func viewDidLoad() {
                
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let dataFromDefaultInNsData = defaults.object(forKey: "mapData") as? NSData{
            if let mapData = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaultInNsData as Data) as? Maps{
                floorsArray = mapData.floors!
            }
        }
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
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
        return floorsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FloorPlansTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FloorPlansTableViewCell") as! FloorPlansTableViewCell
        cell.lblFloorName.text = floorsArray[indexPath.row].name
        cell.imgViewNext.image = UIImage(named: "next.png")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.defaults.setValue(floorsArray[indexPath.row].name, forKey: "floorName")
        self.defaults.setValue(floorsArray[indexPath.row].imageUrl, forKey: "floorImage")
        let floorImagePageView = self.storyboard?.instantiateViewController(withIdentifier: "FloorPlanImageViewController") as! FloorPlanImageViewController
        self.navigationController?.show(floorImagePageView, sender: self)
        
    }
  
    
}
