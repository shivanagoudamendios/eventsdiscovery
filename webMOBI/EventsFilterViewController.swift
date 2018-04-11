//
//  EventsFilterViewController.swift
//  webMOBI
//
//  Created by webmobi on 5/30/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import CoreLocation

class EventsFilterViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var distancelabel: UILabel!
    @IBOutlet weak var distanceslider: UISlider!
    @IBOutlet weak var startdatetextfeild: UITextField!
    @IBOutlet weak var enddatetextfeild: UITextField!
    @IBOutlet weak var dateselectorview: UIView!
    @IBOutlet weak var dateview: UITableView!
    @IBOutlet weak var distanceview: UIView!
    @IBOutlet weak var eventtypeview: UITableView!
    @IBOutlet weak var datearrowimageview: UIImageView!
    @IBOutlet weak var distancearrowimageview: UIImageView!
    @IBOutlet weak var eventtypearrowimageview: UIImageView!
    @IBOutlet weak var datetapview: UIView!
    @IBOutlet weak var distancetapview: UIView!
    @IBOutlet weak var eventtypetapview: UIView!
    @IBOutlet weak var datetableviewheight: NSLayoutConstraint!
    @IBOutlet weak var dateselectorheight: NSLayoutConstraint!
    @IBOutlet weak var distanceviewheight: NSLayoutConstraint!
    @IBOutlet weak var eventtypeviewheight: NSLayoutConstraint!
    
    var distance = "25"
    var date = ""
    var startdate = ""
    var enddate = ""
    
    var locationManager: CLLocationManager!
    var userLocation:CLLocation! = nil
    let datepicker1 = UIDatePicker()
    let datepicker2 = UIDatePicker()
    let viewselected : UIColor = UIColor(red: 30/225, green: 112/255, blue: 145/255, alpha: 1)
    let viewdeselected : UIColor = UIColor.gray
    let datearray = ["All Dates", "Today", "Tomorrow", "Next Week", "Next Month", "Choose Date"]
    let eventtypes = [
        "All Event",
        "Adhesives & Sealants",
        "Aerospace",
        "Agriculture & Forestry",
        "Air & Water, Mangement",
        "Air, Aviation & Airports",
        "Antiques & Philately",
        "Apparel & Clothing",
        "Architecture & Designing",
        "Astrology",
        "Auto Shows",
        "Automation & Robotics",
        "Automotive",
        "Ayurvedic & Herbal",
        "Baby, Kids & Maternity",
        "Bakery & Confectionery",
        "Banking, Insurance & Finance",
        "Bathroom & Kitchen",
        "Bicycles, Rickshaw",
        "Biotechnology",
        "Book Fairs",
        "Building Construction",
        "Business Services",
        "Cables & Wires",
        "Chemicals & Dyes",
        "Computer Hardware & Software",
        "Consumer & Home Appliances",
        "Consumer Fairs & Carnivals",
        "Cosmetics and Beauty Products",
        "Dies & Moulds",
        "Drugs & Medicines",
        "Education & Training",
        "Electronics & Electrical Goods",
        "Embassies & Consulates",
        "Environment & Waste Management",
        "Fashion Shows",
        "Food & Beverage",
        "Foundry, Casting & Forging",
        "Franchising & Retailing",
        "Furniture",
        "Gems & Jewelry",
        "Gifts",
        "Gifts & Handicrafts",
        "Glass & Glassware",
        "Hand, Machine & Garden Tools",
        "Home Furnishings & Home Textiles",
        "Horticulture & Floriculture",
        "Hospitals & Medical Equipments",
        "Hotel, Restaurant & Catering",
        "Household Consumables",
        "Household Services",
        "HR Consultants",
        "Industrial Products",
        "Internet & Startups",
        "IT & Technology",
        "Knitting & Stitching",
        "Leather & Leather Products",
        "Lifestyle & Fashion",
        "Lights & Lighting",
        "Logistics & transportation",
        "Manufacturing, Fabrication, Repair & Maintenance",
        "Marine & Boat",
        "Meat, Poultry & Seafood",
        "Media & Advertising",
        "Medical & Pharamaceutical",
        "Minerals, Metals & Ores",
        "Miscellaneous",
        "Musical & Organic",
        "Natural Stones",
        "Office & Commerical Supplies",
        "Packing Materials",
        "Paints & Coatings",
        "Paper and Paper Products",
        "Petroleum, Oil & Gas",
        "Pets & Veterinary",
        "Photography & Imaging",
        "Plant, Machinery & Equipment",
        "Plants & Machinery",
        "Plastic & Plastic Products",
        "Power & Energy",
        "Power & Renewable Energy",
        "Printing & Publishing",
        "Railway, Shipping & Aviation",
        "Real Estate",
        "Repair, Maintenance & Cleaning",
        "Research & Development", "Rubber & Rubber Products",
        "Scientific Instruments",
        "Security & Defense",
        "Shipping, Marine & Ports",
        "Solar Energy",
        "Sporting Goods, Toys & Games",
        "Tea & Coffee",
        "Telecom Products & Equipment",
        "Textile, Fabrics & Yarns",
        "Toys & Games",
        "Travel & Tourism",
        "Wedding & Bridal",
        "Wedding & Cutting",
        "Wellness, Health & Fitness",
        "Wine & Spirits"]
    var dateselected : String = ""
    var eventtypeselected : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineMyCurrentLocation()
        dateselectorheight.constant = 0
        dateselectorview.isHidden = true
        datetableviewheight.constant = 0
        distanceviewheight.constant = 0
        eventtypeviewheight.constant = 0
        dateview.isHidden = true
        distanceview.isHidden = true
        eventtypeview.isHidden = true
        initgestureforviews()
        datetapview.backgroundColor = viewdeselected
        distancetapview.backgroundColor = viewdeselected
        eventtypetapview.backgroundColor = viewdeselected
        datearrowimageview.image = UIImage(named: "downarrow")
        distancearrowimageview.image = UIImage(named: "downarrow")
        eventtypearrowimageview.image = UIImage(named: "downarrow")
        
        dateview.delegate = self
        dateview.register(UINib(nibName: "DateTableViewCell", bundle: nil), forCellReuseIdentifier: "DateTableViewCell")
        dateview.isScrollEnabled = false
        
        eventtypeview.delegate = self
        eventtypeview.register(UINib(nibName: "DateTableViewCell", bundle: nil), forCellReuseIdentifier: "DateTableViewCell")
        eventtypeview.isScrollEnabled = false
        createdatepicker1()
        createdatepicker2()
        
        self.distancelabel.text = "Distance \(round(25)) Kms/\(round((25)*0.621371)) miles"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setShadowToview(view: datetapview)
        setShadowToview(view: distancetapview)
        setShadowToview(view: eventtypetapview)
    }
    
    @IBAction func closefilter(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func clearbutton(_ sender: UIButton) {
        dateselected = ""
        eventtypeselected.removeAll()
        dateview.reloadData()
        eventtypeview.reloadData()
        distanceslider.setValue(25, animated: true)
    }
    
    @IBAction func applybutton(_ sender: UIButton) {
        let datecheck = getrequiredparams()
        
        if CLLocationManager.locationServicesEnabled() && (datecheck == true) {
            let params = ["distance": distance as AnyObject,
                          "latitude": String(userLocation.coordinate.latitude) as AnyObject,
                          "longitude": String(userLocation.coordinate.longitude) as AnyObject,
                          "offset": "0" as AnyObject,
                          "date": startdate as AnyObject,
                          "startdate": startdate as AnyObject,
                          "enddate": enddate as AnyObject,
                          "category": String(describing: eventtypeselected) as AnyObject
                ] as Dictionary<String, AnyObject>
            
            NotificationCenter.default.post(name: Notification.Name("filterevents"), object: nil, userInfo: params)
            dismiss(animated: true, completion: nil)
        }else {
            determineMyCurrentLocation()
        }
        
    }
    
    func getrequiredparams() -> Bool{
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        switch dateselected {
        case "All Dates":
            startdate = "anydate"
            enddate = "anydate"

        case "Today":
            let calendar = NSCalendar.current
            startdate = dateformatter.string(from: calendar.date(byAdding: .day, value: 0, to: NSDate() as Date)!)
            enddate = dateformatter.string(from: calendar.date(byAdding: .day, value: 0, to: NSDate() as Date)!)

        case "Tomorrow":
            let calendar = NSCalendar.current
            startdate = dateformatter.string(from: calendar.date(byAdding: .day, value: 0, to: NSDate() as Date)!)
            enddate = dateformatter.string(from: calendar.date(byAdding: .day, value: 0, to: NSDate() as Date)!)
            
        case "Next Week":
            let calendar = NSCalendar.current
            startdate = dateformatter.string(from: calendar.date(byAdding: .day, value: 0, to: NSDate() as Date)!)
            enddate = dateformatter.string(from: calendar.date(byAdding: .day, value: 7, to: NSDate() as Date)!)
            
        case "Next Month":
            let calendar = NSCalendar.current
            startdate = dateformatter.string(from: calendar.date(byAdding: .day, value: 0, to: NSDate() as Date)!)
            enddate = dateformatter.string(from: calendar.date(byAdding: .month, value: 1, to: NSDate() as Date)!)
            
        case "Choose Date":
            if startdatetextfeild.text == ""{
                DispatchQueue.main.async(execute: {() -> Void in
                    let alert = UIAlertController(title: "Request Failed", message: "Please select the start date", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                    })
                    self.present(alert, animated: true, completion: nil)
                })
                return false
            }else if (enddatetextfeild.text == ""){
                DispatchQueue.main.async(execute: {() -> Void in
                    let alert = UIAlertController(title: "Request Failed", message: "Please select the end date", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                    })
                    self.present(alert, animated: true, completion: nil)
                })
                return false
            }
            startdate = startdatetextfeild.text!
            enddate = enddatetextfeild.text!
            
        default:
            startdate = "anydate"
            enddate = "anydate"

        }
        
        if (eventtypeselected.count < 1) || (eventtypeselected[0] == "All Event"){
            eventtypeselected.append("anycategory")
        }
        
        return true

    }

    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
    }
    
    @IBAction func distanceslider(_ sender: UISlider) {
        
        DispatchQueue.main.async {
            self.distancelabel.text = "Distance \(round(sender.value)) Kms/\(round((sender.value)*0.621371)) miles"
            self.distance = String(round((sender.value)*0.621371))
        }
    }
    
}

extension EventsFilterViewController : UIGestureRecognizerDelegate{
    func initgestureforviews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        datetapview.addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(sender:)))
        tap1.delegate = self
        distancetapview.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(sender:)))
        tap2.delegate = self
        eventtypetapview.addGestureRecognizer(tap2)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        dateview.isHidden = false
        distanceviewheight.constant = 0
        eventtypeviewheight.constant = 0
        distanceview.isHidden = true
        eventtypeview.isHidden = true
        datetapview.backgroundColor = viewselected
        distancetapview.backgroundColor = viewdeselected
        eventtypetapview.backgroundColor = viewdeselected
        datearrowimageview.image = UIImage(named: "uparrow")
        distancearrowimageview.image = UIImage(named: "downarrow")
        eventtypearrowimageview.image = UIImage(named: "downarrow")
        let height = (datearray.count) * 44
        datetableviewheight.constant = CGFloat(height)
    }
    
    func handleTap1(sender: UITapGestureRecognizer) {
        distanceview.isHidden = false
        datetableviewheight.constant = 0
        distanceviewheight.constant = 87
        eventtypeviewheight.constant = 0
        dateview.isHidden = true
        eventtypeview.isHidden = true
        datetapview.backgroundColor = viewdeselected
        distancetapview.backgroundColor = viewselected
        eventtypetapview.backgroundColor = viewdeselected
        datearrowimageview.image = UIImage(named: "downarrow")
        distancearrowimageview.image = UIImage(named: "uparrow")
        eventtypearrowimageview.image = UIImage(named: "downarrow")
    }
    
    func handleTap2(sender: UITapGestureRecognizer) {
        eventtypeview.isHidden = false
        datetableviewheight.constant = 0
        distanceviewheight.constant = 0
        distanceview.isHidden = true
        dateview.isHidden = true
        datetapview.backgroundColor = viewdeselected
        distancetapview.backgroundColor = viewdeselected
        eventtypetapview.backgroundColor = viewselected
        datearrowimageview.image = UIImage(named: "downarrow")
        distancearrowimageview.image = UIImage(named: "downarrow")
        eventtypearrowimageview.image = UIImage(named: "uparrow")
        let height = (eventtypes.count) * 44
        eventtypeviewheight.constant = CGFloat(height)
    }
    
    func setShadowToview(view: UIView) {
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 0.5
    }
    
}

extension EventsFilterViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dateview{
            return datearray.count
        }else{
            return eventtypes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dateview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateTableViewCell", for: indexPath) as! DateTableViewCell
            cell.datelabel.text = datearray[indexPath.row]
            if datearray[indexPath.row] == dateselected{
                cell.dateimageview.image = UIImage(named: "radioselected")
            }else
            {
                cell.dateimageview.image = UIImage(named: "radiodeselected")
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateTableViewCell", for: indexPath) as! DateTableViewCell
            cell.datelabel.text = eventtypes[indexPath.row]
            if(eventtypeselected.contains(eventtypes[indexPath.row])){
                cell.dateimageview.layer.borderWidth = 2
                cell.dateimageview.layer.borderColor = viewselected.cgColor
                cell.dateimageview.image = UIImage(named: "tickmark")
            }else{
                cell.dateimageview.layer.borderWidth = 2
                cell.dateimageview.layer.borderColor = viewdeselected.cgColor
                cell.dateimageview.image = nil
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == dateview{
            return 44
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == dateview{
            dateselected = datearray[indexPath.row]
            dateview.reloadData()
            if datearray[indexPath.row] == "Choose Date"{
                dateselectorview.isHidden = false
                dateselectorheight.constant = 79
            }else if (dateselectorview.isHidden == false){
                dateselectorheight.constant = 0
                dateselectorview.isHidden = true
            }
        }else{
            if(eventtypeselected.contains(eventtypes[indexPath.row]))
            {
                eventtypeselected = eventtypeselected.filter{$0 != eventtypes[indexPath.row]}
            }else
            {
                eventtypeselected.append(eventtypes[indexPath.row])
            }
            eventtypeview.reloadData()
        }
    }
    
    func createdatepicker1() {
        
        datepicker1.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.datepickerdonepressed1))
        toolbar.setItems([donebutton], animated: false)
        
        startdatetextfeild.inputAccessoryView = toolbar
        
        startdatetextfeild.inputView = datepicker1
    }
    
    func datepickerdonepressed1() {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
//        dateformatter.dateStyle = .short
//        dateformatter.timeStyle = .none
        
//        startdatetextfeild.text = "\(datepicker.date)"
        startdatetextfeild.text = dateformatter.string(from: datepicker1.date)
        self.view.endEditing(true)
    }
    
    func createdatepicker2() {
        
        datepicker2.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.datepickerdonepressed2))
        toolbar.setItems([donebutton], animated: false)
        
        enddatetextfeild.inputAccessoryView = toolbar
        
        enddatetextfeild.inputView = datepicker2
    }
    
    func datepickerdonepressed2() {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        enddatetextfeild.text = dateformatter.string(from: datepicker2.date)
        self.view.endEditing(true)
    }
    
}
