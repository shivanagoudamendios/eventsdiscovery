//
//  WeatherViewController.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 5/9/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, DKScrollingTabControllerDelegate {
    public func scrollingTabController(_ controller: DKScrollingTabController!, selection: UInt) {
        
    }

    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var weatherView: UIView!
    let tabController = DKScrollingTabController()
    let defaults = UserDefaults.standard
    var cities : [String] = [String]()
    var city : String = String()
    
    override func viewDidLoad() {
        
        if let themeclr = defaults.string(forKey: "themeColor"){
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
            tabController.unselectedBackgroundColor = UIColor.init(hex: themeclr)
        }
        if let selectclr = defaults.string(forKey: "selectColor"){
        
        tabController.selectedBackgroundColor = UIColor.init(hex: selectclr)
        }
        
        super.viewDidLoad()
        if let dataFromDefaults = defaults.object(forKey: "weatherData") as? NSData{
            if let objectFromDefaults = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as Data) as? Weather{
                if objectFromDefaults.cities! != []{
                    cities = objectFromDefaults.cities!
                    city = cities[0]
                    let tagflag = ["cityName": city]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cityNameIs"), object: nil, userInfo: tagflag)
                }
            }
        }
        
        
        tabController.delegate = self
        
        self.addChildViewController(tabController)
        tabController .didMove(toParentViewController: self)
        self.view.addSubview(tabController.view)
        if UIDevice.current.userInterfaceIdiom == .pad {
            tabController.view.frame = CGRect(x: 0, y: 60, width: 1000, height: 50)
            tabController.buttonPadding = 50
        }
        else {
            tabController.view.frame = CGRect(x: 0, y: 60, width: 320, height: 40)
            tabController.buttonPadding = 25
        }
        //        if cities != []{
        cities.append("Search")
        tabController.selection = cities
        //        }
        //        ["zero", "one", "two", "three", "Search"]
        
        searchView.isHidden = true
        weatherView.isHidden = false
        
    }
    func ScrollingTabController(controller: DKScrollingTabController!, selection: UInt) {
        print("tapped \(selection)", terminator: "\n")
        if(selection >= UInt(cities.count-1))
        {
            searchView.isHidden = false
            weatherView.isHidden = true
        }else
        {
            searchView.isHidden = true
            weatherView.isHidden = false
            city = cities[Int(selection)]
            let tagflag = ["cityName": city]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cityNameIs"), object: nil, userInfo: tagflag)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBarItem()
        
        self.title = "Weather"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
