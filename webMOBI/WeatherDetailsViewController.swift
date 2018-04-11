//
//  WeatherDetailsViewController.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 5/9/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import MBProgressHUD

class WeatherDetailsViewController: UIViewController {
    
    @IBOutlet weak var weatherDetailView: UIView!
    @IBOutlet weak var weatherTable: UITableView!
    @IBOutlet var lblCityName: UILabel!
    @IBOutlet var lblDayAndTime: UILabel!
    @IBOutlet var lblTypeOfWeather: UILabel!
    @IBOutlet var lblHumidity: UILabel!
    @IBOutlet var imgViewForTypeOfWeather: UIImageView!
    @IBOutlet var lblTemp: UILabel!
    @IBOutlet var lblWindSpeed: UILabel!
    
    let defaults = UserDefaults.standard
    let weatherVc : WeatherViewController = WeatherViewController()
    var cities : [String] = [String]()
    var city : String = String()
    var total : Int = 0
    var dic : NSDictionary = NSDictionary()
    let cache = ImageLoadingWithCache()
    var hud = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dataFromDefaults = defaults.object(forKey: "weatherData") as? NSData{
            if let objectFromDefaults = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as Data) as? Weather{
                if objectFromDefaults.cities! != []{
                    cities = objectFromDefaults.cities!
                    city = cities[0]
                    getTheData(cityName: city)
                    getweekdata(cityName: city)
                }
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherDetailsViewController.cityNameIs), name: NSNotification.Name(rawValue: "cityNameIs"), object: nil);
        weatherDetailView.layer.borderColor = UIColor.gray.cgColor
        weatherDetailView.layer.borderWidth = 0.3
        weatherDetailView.layer.cornerRadius = 5
        weatherTable.layer.borderColor = UIColor.gray.cgColor
        weatherTable.layer.borderWidth = 0.3
        weatherTable.layer.cornerRadius = 5
        weatherTable.tableFooterView = UIView()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func cityNameIs(noti : NSNotification){
        let tag = noti.userInfo!["cityName"] as! String
        if tag == ""{
        }else{
            city = tag
            getTheData(cityName: city)
            getweekdata(cityName: city)
        }
    }
    func setDataIntoTheView(dict : NSDictionary){
        lblCityName.text = city
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE hh:mm a"
        let timeString = String(dateFormatter.string(from: NSDate() as Date))
        lblDayAndTime.text = timeString
        if let main = dict["main"] as? NSDictionary{
            lblTemp.text = String(describing: main.value(forKey: "temp")!) + "°C"
            lblHumidity.text = "Humidity: " + String(describing: main.value(forKey: "humidity")!) + "%"
        }
        if let weather = dict["weather"] as? [NSDictionary]{
            lblTypeOfWeather.text = String(describing: weather[0].value(forKey: "description")!).uppercaseFirst
            if let data = NSData(contentsOf:  NSURL(string: "http://openweathermap.org/img/w/" + String(describing: weather[0].value(forKey: "icon")!) + ".png")! as URL){
                imgViewForTypeOfWeather.image = UIImage(data: data as Data)
            }
        }
        if let wind = dict["wind"] as? NSDictionary{
            lblWindSpeed.text = "Wind: " + String(describing: wind.value(forKey: "speed")!) + " mph"
        }
    }
    func getTheData(cityName : String){
        
        hud = MBProgressHUD.showAdded(to: self.weatherDetailView, animated: true)
        hud.labelText = "Loading Data..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        let apiSTring = "http://api.openweathermap.org/data/2.5/weather?q=" + cityName + "&APPID=e3b2511238a20c8a648ca330e88f8b6b&units=metric"
        let url: NSURL = NSURL(string: apiSTring.addingPercentEscapes(using: .utf8)!)!
        let request1 = NSMutableURLRequest(
            url: url as URL,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15.0)
        //            let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        
        NSURLConnection.sendAsynchronousRequest(request1 as URLRequest, queue: OperationQueue(), completionHandler:{
            (response, data, error)-> Void in
            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    let dic = self.parseJSON(inputData: data! as NSData)
                    print(dic)
                    self.setDataIntoTheView(dict: dic)
                    
                })
            })
            
            }
        )
        
        self.hud.hide(true, afterDelay: 1)
        
        //        let dat = getJSON(apiSTring)
        //        let dic = parseJSON(dat)
        //        print(dic)
        //        setDataIntoTheView(dic)
        //        weatherTable.reloadData()
        
    }
    
    func getweekdata(cityName : String)
    {
        
        let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?q=" + cityName + "&mode=json&units=metric&cnt=7&&APPID=e3b2511238a20c8a648ca330e88f8b6b"
        
        let url: NSURL = NSURL(string: urlString.addingPercentEscapes(using: .utf8)!)!        
        let request1 = NSMutableURLRequest(
            url: url as URL,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15.0)
        //            let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        
        NSURLConnection.sendAsynchronousRequest(request1 as URLRequest, queue: OperationQueue(), completionHandler:{
            (response, data, error)-> Void in
            
            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.dic = self.parseJSON(inputData: data! as NSData)
                    print(self.dic)
                    self.weatherTable.reloadData()
                })
            })
            
            }
        )
        //        let dat = getJSON(urlString)
        
    }
    
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOf: NSURL(string: urlToRequest)! as URL)!
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        do {
            let boardsDictionary: NSDictionary = try JSONSerialization.jsonObject(with: inputData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
            return boardsDictionary
            
        } catch {
            print(error)
        }
        return [:]
    }
    
}
extension WeatherDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WeatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell") as! WeatherTableViewCell
        if  let list = dic["list"] as? [NSDictionary]{
            let date =  NSDate(timeIntervalSince1970: list[indexPath.row].value(forKey: "dt") as! Double)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let timeString = String(dateFormatter.string(from: date as Date))
            cell.dayLabel.text = timeString
            if let tempDict = list[indexPath.row].value(forKey: "temp") as? NSDictionary{
                cell.tmpLabel.text = String(describing: tempDict.value(forKey: "day")!)
            }
            if let weather = list[indexPath.row].value(forKey: "weather") as? [NSDictionary]{
                
                let imgurl = "http://openweathermap.org/img/w/" + String(describing: weather[0].value(forKey: "icon")!) + ".png"
                
               DispatchQueue.main.async(execute: { () -> Void in
                
                self.cache.getImage(url: imgurl, imageView:   cell.imgViewForType, defaultImage: "weather0.png")
                })
                
                
                //                dispatch_async(dispatch_get_main_queue(), {
                //                    if let data = NSData(contentsOfURL:  NSURL(string: "http://openweathermap.org/img/w/" + String(weather[0].valueForKey("icon")!) + ".png")!){
                //                        cell.imgViewForType.image = UIImage(data: data)
                //                    }
                //                })
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

