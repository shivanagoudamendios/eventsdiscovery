//
//  NewAgendaViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/5/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class NewAgendaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var filter: UILabel!
    var indexPathForFirstRow = IndexPath(row: 0, section: 0)
    @IBOutlet weak var eventlisttableview: UITableView!
    @IBOutlet weak var currentmonth: UILabel!
    @IBOutlet weak var dateselectcollectionview: UICollectionView!
    //    let section = ["pizza", "deep dish pizza", "calzone"]
    //    let items = [["Margarita", "BBQ Chicken", "Pepperoni"], ["sausage", "meat lovers", "veggie lovers"], ["sausage", "chicken pesto", "prawns", "mushrooms"]]
    let defaults = UserDefaults.standard
    var agendacount = 0
    var agendaArray = [AgendaInAgenda]()
    var DatesortedArray : [Double:[AgendaDetails]] = [Double:[AgendaDetails]]()
    var DatesortedArray1 : [Double] = [Double]()
    var CategorysortedArray : [String:[AgendaDetails]] = [String:[AgendaDetails]]()
    var CategorysortedArray1 : [String] = [String]()
    var dateArray : [String] = [String]()
    var dayArray : [String] = [String]()
    var eventdate : Double = 0.0
    var disabledcells : [Bool] = [Bool]()
    var eventsdaycount : Int = 0
    var startdate : Double = 0
    var enddate : Double = 0
    var datefilter : Bool = true
    private var lastContentOffset: CGFloat = 0
    var allDatesInMillis : [Double] = [Double]()
    var allDatesInMillisFromJson : [Double] = [Double]()
    var oneDayInMilli : Double = 86400000
    var didSelectDate : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = defaults.object(forKey: "agendadata1") as? NSData {
            
            allDatesInMillisFromJson.removeAll()
            let agenda = NSKeyedUnarchiver.unarchiveObject(with: data as Data)
            agendaArray = Mapper<AgendaInAgenda>().mapArray(JSONObject: agenda)!
            for count in 0..<agendaArray.count{
                allDatesInMillisFromJson.append(agendaArray[count].name!)
            }
            
        }
        
        dateselectcollectionview.delegate = self
        eventlisttableview.register(UINib(nibName: "NewAgendaTableViewCell", bundle: nil), forCellReuseIdentifier: "NewAgendaTableViewCell")
        eventlisttableview.register(UINib(nibName: "NewAgendaSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "NewAgendaSectionHeaderView")
        eventlisttableview.separatorStyle = .none
        eventlisttableview.tableFooterView = UIView()
        eventlisttableview.estimatedRowHeight = 67
        eventlisttableview.rowHeight = UITableViewAutomaticDimension
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
            filter.backgroundColor = UIColor.init(hex: themeclr)
        }
        if (self.defaults.bool(forKey: "startdate")){
            startdate = self.defaults.value(forKey: "startdate") as! Double
        }
        if (self.defaults.bool(forKey: "enddate")){
            enddate = self.defaults.value(forKey: "enddate") as! Double
        }
        currentmonth.text = TimeConversion().stringfrommilliseconds(ms: startdate, format: "MMMM yyyy")
        let date1 = NSDate(timeIntervalSince1970: (enddate / 1000.0))
        let date2 = NSDate(timeIntervalSince1970: (startdate / 1000.0))
        
        print(date1.timeIntervalSince(date2 as Date))
        print(((Int(date1.timeIntervalSince(date2 as Date)))/(24 * 60 * 60))+1)
        eventsdaycount = ((Int(date1.timeIntervalSince(date2 as Date)))/(24 * 60 * 60))+1
        
        for count in 0..<eventsdaycount{
            allDatesInMillis.append(startdate + (oneDayInMilli * Double(count)))
        }
        
        setFilterButton(view: filter)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        filter.isUserInteractionEnabled = true
        filter.addGestureRecognizer(tap)
        
        if datefilter{
            ArrangeDataForDate()
        }else{
            ArrangeDataForCategory()
        }
        if eventsdaycount < 7{
            setDate(daycount: eventsdaycount)
        }else{
            setDateForMoreThanSevenDays()
        }
        
    }
    
    func setFilterButton(view: UIView) {
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 0.5
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        if datefilter{
            datefilter = false
            filter.text = "Filter By Time"
            ArrangeDataForCategory()
        }else{
            datefilter = true
            filter.text = "Filter By Category"
            ArrangeDataForDate()
        }
        eventlisttableview.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func ArrangeDataForDate()  {
        if let data = defaults.object(forKey: "agendadata1") as? NSData {
            
            agendaArray.removeAll()
            let agenda = NSKeyedUnarchiver.unarchiveObject(with: data as Data)
            agendaArray = Mapper<AgendaInAgenda>().mapArray(JSONObject: agenda)!
            let milli = allDatesInMillis[agendacount]
            
            if allDatesInMillisFromJson.contains(milli) {
                
                DatesortedArray.removeAll()
                DatesortedArray1.removeAll()
                
                let index = allDatesInMillisFromJson.index(of: milli)!
                if agendaArray[index].name! == milli {
                    print("Gotcha")
                    
                    currentmonth.text = TimeConversion().stringfrommilliseconds(ms: allDatesInMillis[agendacount], format: "MMMM yyyy")
                    
                    eventdate = agendaArray[index].name!
                    let temp = agendaArray[index].detail
                    
                    for data in temp! {
                        if DatesortedArray.keys.contains(data.fromtime!){
                            var sortedArray1 = DatesortedArray[data.fromtime!]
                            sortedArray1?.append(data)
                            let sortedArray2 = sortedArray1?.sorted() { $0.totime! < $1.totime! }
                            DatesortedArray[data.fromtime!] = sortedArray2!
                        }else{
                            DatesortedArray[data.fromtime!] = [data]
                        }
                    }
                    
                    let KeysArray = DatesortedArray.keys
                    let sortedArray2 = KeysArray.sorted(by: <)
                    
                    DatesortedArray1 = sortedArray2
                    dateselectcollectionview.reloadData()
                    eventlisttableview.reloadData()
                    let indexPath = IndexPath(row: 0, section: 0)
                    eventlisttableview.scrollToRow(at: indexPath, at: .top, animated: false)
                    if (dayArray.count > 0) && (DatesortedArray.count > 0){
                        dateselectcollectionview.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
                    }
                }
            }else{
                //No sessions available for this date
                eventdate = milli
                let alert = UIAlertController(title: "No sessions available for this date.", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func ArrangeDataForCategory()  {
        if let data = defaults.object(forKey: "agendadata1") as? NSData {
            
            agendaArray.removeAll()
            let agenda = NSKeyedUnarchiver.unarchiveObject(with: data as Data)
            agendaArray = Mapper<AgendaInAgenda>().mapArray(JSONObject: agenda)!
            let milli = allDatesInMillis[agendacount]
            
            if allDatesInMillisFromJson.contains(milli){
                
                CategorysortedArray.removeAll()
                CategorysortedArray1.removeAll()
                
                let index = allDatesInMillisFromJson.index(of: milli)!
                if agendaArray[index].name! == milli{
                    print("Gotcha")
                    
                    currentmonth.text = TimeConversion().stringfrommilliseconds(ms: allDatesInMillis[agendacount], format: "MMMM yyyy")
                    
                    eventdate = agendaArray[index].name!
                    let temp = agendaArray[index].detail
                    
                    for data in temp!{
                        if CategorysortedArray.keys.contains(data.category!){
                            var sortedArray1 = CategorysortedArray[data.category!]
                            sortedArray1?.append(data)
                            let sortedArray2 = sortedArray1?.sorted() { $0.category!.lowercased() < $1.category!.lowercased() }
                            CategorysortedArray[data.category!] = sortedArray2!
                        }else{
                            CategorysortedArray[data.category!] = [data]
                        }
                    }
                    
                    CategorysortedArray1 = CategorysortedArray.keys.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                    dateselectcollectionview.reloadData()
                    eventlisttableview.reloadData()
                    let indexPath = IndexPath(row: 0, section: 0)
                    eventlisttableview.scrollToRow(at: indexPath, at: .top, animated: false)
                    if (dayArray.count > 0) && (DatesortedArray.count > 0){
                        dateselectcollectionview.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
                    }
                }
            }else{
                //No sessions available for this date
                eventdate = milli
                let alert = UIAlertController(title: "No sessions available for this date.", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
    }
    
    func setPreAndFuture(day : Int, referancedate: Double) {
        let calendar = NSCalendar.current
        let date = Date(timeIntervalSince1970: TimeInterval(referancedate / 1000))
        let DaysAgo = calendar.date(byAdding: .day, value: day, to: date)
        dayArray.append(TimeConversion().stringfromdate(date: DaysAgo!, format: "E"))
        dateArray.append(TimeConversion().stringfromdate(date: DaysAgo!, format: "dd"))
        disabledcells.append(false)
    }
    
    func setDateAndDay(day : Int, referancedate: Double) {
        let calendar = NSCalendar.current
        let date = Date(timeIntervalSince1970: TimeInterval(referancedate / 1000))
        let DaysAgo = calendar.date(byAdding: .day, value: day, to: date)
        dayArray.append(TimeConversion().stringfromdate(date: DaysAgo!, format: "E"))
        dateArray.append(TimeConversion().stringfromdate(date: DaysAgo!, format: "dd"))
        disabledcells.append(true)
    }
    
    func setDateForMoreThanSevenDays() {
        for count in 0..<eventsdaycount{
            setDateAndDay(day: count, referancedate: eventdate)
        }
        dateselectcollectionview.selectItem(at: IndexPath(row: 0, section: 0) , animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func setDate(daycount: Int) {
        switch (daycount) {
        case (1):
            setPreAndFuture(day: -3, referancedate: eventdate)
            setPreAndFuture(day: -2, referancedate: eventdate)
            setPreAndFuture(day: -1, referancedate: eventdate)
            setDateAndDay(day: 0, referancedate: eventdate)
            setPreAndFuture(day: 1, referancedate: eventdate)
            setPreAndFuture(day: 2, referancedate: eventdate)
            setPreAndFuture(day: 3, referancedate: eventdate)
            dateselectcollectionview.reloadData()
            indexPathForFirstRow = IndexPath(row: 3, section: 0)
            dateselectcollectionview.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
        case (2):
            setPreAndFuture(day: -2, referancedate: eventdate)
            setPreAndFuture(day: -1, referancedate: eventdate)
            setDateAndDay(day: 0, referancedate: eventdate)
            setDateAndDay(day: 1, referancedate: eventdate)
            setPreAndFuture(day: 2, referancedate: eventdate)
            setPreAndFuture(day: 3, referancedate: eventdate)
            setPreAndFuture(day: 4, referancedate: eventdate)
            dateselectcollectionview.reloadData()
            indexPathForFirstRow = IndexPath(row: 2, section: 0)
            dateselectcollectionview.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
        case (3):
            setPreAndFuture(day: -2, referancedate: eventdate)
            setPreAndFuture(day: -1, referancedate: eventdate)
            setDateAndDay(day: 0, referancedate: eventdate)
            setDateAndDay(day: 1, referancedate: eventdate)
            setDateAndDay(day: 2, referancedate: eventdate)
            setPreAndFuture(day: 3, referancedate: eventdate)
            setPreAndFuture(day: 4, referancedate: eventdate)
            dateselectcollectionview.reloadData()
            indexPathForFirstRow = IndexPath(row: 2, section: 0)
            dateselectcollectionview.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
        case (4):
            setPreAndFuture(day: -1, referancedate: eventdate)
            setDateAndDay(day: 0, referancedate: eventdate)
            setDateAndDay(day: 1, referancedate: eventdate)
            setDateAndDay(day: 2, referancedate: eventdate)
            setDateAndDay(day: 3, referancedate: eventdate)
            setPreAndFuture(day: 4, referancedate: eventdate)
            setPreAndFuture(day: 5, referancedate: eventdate)
            dateselectcollectionview.reloadData()
            indexPathForFirstRow = IndexPath(row: 1, section: 0)
            dateselectcollectionview.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
        case (5):
            setPreAndFuture(day: -1, referancedate: eventdate)
            setDateAndDay(day: 0, referancedate: eventdate)
            setDateAndDay(day: 1, referancedate: eventdate)
            setDateAndDay(day: 2, referancedate: eventdate)
            setDateAndDay(day: 3, referancedate: eventdate)
            setDateAndDay(day: 4, referancedate: eventdate)
            setPreAndFuture(day: 5, referancedate: eventdate)
            dateselectcollectionview.reloadData()
            indexPathForFirstRow = IndexPath(row: 1, section: 0)
            dateselectcollectionview.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
        case (6):
            setDateAndDay(day: 0, referancedate: eventdate)
            setDateAndDay(day: 1, referancedate: eventdate)
            setDateAndDay(day: 2, referancedate: eventdate)
            setDateAndDay(day: 3, referancedate: eventdate)
            setDateAndDay(day: 4, referancedate: eventdate)
            setDateAndDay(day: 5, referancedate: eventdate)
            setPreAndFuture(day: 6, referancedate: eventdate)
            dateselectcollectionview.reloadData()
            indexPathForFirstRow = IndexPath(row: 0, section: 0)
            dateselectcollectionview.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .centeredHorizontally)
            
        default:
            print(daycount)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
        cell.daylabel.text = dayArray[indexPath.row]
        cell.datelabel.text = dateArray[indexPath.row]
        if eventsdaycount >= 7 && didSelectDate == false{
            currentmonth.text = TimeConversion().stringfrommilliseconds(ms: allDatesInMillis[indexPath.row], format: "MMMM yyyy")
        }else{
            if agendacount == indexPath.row {
                currentmonth.text = TimeConversion().stringfrommilliseconds(ms: allDatesInMillis[indexPath.row], format: "MMMM yyyy")
            }
        }
        //        print("Printing Date: ", TimeConversion().stringfrommilliseconds(ms: allDatesInMillis[indexPath.row], format: "MMMM yyyy"))
        if cell.isSelected{
            let themeclr = defaults.string(forKey: "themeColor")
            cell.layer.cornerRadius = 22
            cell.backgroundColor = UIColor.init(hex: themeclr!)
            cell.datelabel.textColor = UIColor.white
            cell.daylabel.textColor = UIColor.white
        }else{
            cell.layer.cornerRadius = 0
            cell.backgroundColor = UIColor.white
            cell.datelabel.textColor = UIColor.black
            cell.daylabel.textColor = UIColor.black
            cell.datelabel.font = UIFont.boldSystemFont(ofSize: 12.0)
            cell.daylabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        }
        
        if disabledcells[indexPath.row] == false{
            cell.datelabel.textColor = UIColor.gray
            cell.daylabel.textColor = UIColor.gray
            cell.isUserInteractionEnabled = false
        }else{
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let _ = scrollView as? UITableView {
            print("tableview")
        } else if let _ = scrollView as? UICollectionView {
            //  print("collectionView")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let _ = scrollView as? UITableView {
            print("tableview")
        } else if let _ = scrollView as? UICollectionView {
            if didSelectDate == true{
                didSelectDate = false
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let minspace = (screenWidth - 308)/6
        return minspace
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(eventsdaycount < 7)
        {
            let removevalue = (7 - eventsdaycount)/2
            agendacount = indexPath.row - removevalue
            currentmonth.text = TimeConversion().stringfrommilliseconds(ms: allDatesInMillis[agendacount], format: "MMMM yyyy")
            indexPathForFirstRow = IndexPath(row: indexPath.row, section: indexPath.section)
        }else
        {
            let milli = allDatesInMillis[indexPath.row]
            if allDatesInMillisFromJson.contains(milli){
                agendacount = indexPath.row
                indexPathForFirstRow = IndexPath(row: indexPath.row, section: indexPath.section)
            }else{
                //No sessions available for this date
                let alert = UIAlertController(title: "No sessions available for this date.", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            //            agendacount = indexPath.row
        }
        
        if datefilter{
            ArrangeDataForDate()
        }else{
            ArrangeDataForCategory()
        }
        didSelectDate = true
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension NewAgendaViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if datefilter{
            return DatesortedArray.keys.count
        }else{
            return CategorysortedArray.keys.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datefilter{
            let time = DatesortedArray1[section]
            return (DatesortedArray[time]?.count)!
        }else{
            let time = CategorysortedArray1[section]
            return (CategorysortedArray[time]?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewAgendaTableViewCell", for: indexPath) as! NewAgendaTableViewCell
        let locationicon = String.fontAwesomeIcon(code: "fa-map-marker")
        if datefilter{
            let section = DatesortedArray1[indexPath.section]
            let details = DatesortedArray[section]?[indexPath.row]
            cell.selectionStyle = .none
            cell.starttime.text = TimeConversion().stringfrommilliseconds(ms: (details?.fromtime)!, format: "hh:mm a")
            cell.endtime.text = TimeConversion().stringfrommilliseconds(ms: (details?.totime)!, format: "hh:mm a")
            cell.title.text = (details?.topic)!
            cell.location.font = UIFont.fontAwesome(ofSize: 15)
            cell.location.text = locationicon! + "  " + (details?.location)!
        }else{
            let section = CategorysortedArray1[indexPath.section]
            let details = CategorysortedArray[section]?[indexPath.row]
            cell.selectionStyle = .none
            cell.starttime.text = TimeConversion().stringfrommilliseconds(ms: (details?.fromtime)!, format: "hh:mm a")
            cell.endtime.text = TimeConversion().stringfrommilliseconds(ms: (details?.totime)!, format: "hh:mm a")
            cell.title.text = (details?.topic)!
            cell.location.font = UIFont.fontAwesome(ofSize: 15)
            cell.location.text = locationicon! + "  " +  (details?.location)!
        }
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 67
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewAgendaSectionHeaderView") as! NewAgendaSectionHeaderView
        if datefilter{
            view.sectiontitle.text = TimeConversion().stringfrommilliseconds(ms: DatesortedArray1[section], format: "hh:mm a")
        }else{
            view.sectiontitle.text = CategorysortedArray1[section]
        }
        return view
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewEventDetailsViewController") as! NewEventDetailsViewController
        nextViewController.title = "Details"
        nextViewController.fromfav = false
        if datefilter{
            let section = DatesortedArray1[indexPath.section]
            let details = DatesortedArray[section]?[indexPath.row]
            nextViewController.EventDetail = details
        }else{
            let section = CategorysortedArray1[indexPath.section]
            let details = CategorysortedArray[section]?[indexPath.row]
            nextViewController.EventDetail = details
        }
        nextViewController.fromagenda = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
