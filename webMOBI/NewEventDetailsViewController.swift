//
//  NewEventDetailsViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/7/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import MBProgressHUD
class NewEventDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var speakersLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var addtoschedule: UIButton!
    @IBOutlet weak var ratethisview: UIView!
    @IBOutlet weak var datetimeview: UIView!
    @IBOutlet weak var addnotesview: UIView!
    @IBOutlet weak var descriptiontext: UITextView!
    @IBOutlet weak var categoryIcon: UILabel!
    @IBOutlet weak var locationIcon: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var eventTopic: UILabel!
    @IBOutlet weak var speakers: UITableView!
    @IBOutlet weak var speakerstableheight: NSLayoutConstraint!
    @IBOutlet weak var addNotes: UILabel!
    @IBOutlet weak var addNotesIcon: UILabel!
    @IBOutlet weak var rateThisIcon: FloatRatingView!
    @IBOutlet weak var pdfFile: UILabel!
    @IBOutlet weak var pdfview: UIView!
    @IBOutlet weak var pdfviewheight: NSLayoutConstraint!
    @IBOutlet weak var speakersLabel: UILabel!
    
    var EventDetail : AgendaDetails!
    var speckrdata = [SpeakersDataItems]()
    var speakerscount = 0
    var favList : [Int64] = []
    var fromagenda : Bool = false
    var hud = MBProgressHUD()
    var defaults = UserDefaults.standard
    var fromfav  = false
    @IBAction func addscheduleAction(_ sender: UIButton) {
       
        if(defaults.bool(forKey: "login"))
        {
            var Mark = ""
            let appid = self.defaults.string(forKey: "selectedappid")
            let token = defaults.string(forKey: "token")
            let UserId = self.defaults.string(forKey: "EvntUserId")
            let idToStore = "\(appid!)\(self.EventDetail.agendaId!)"
            if(CoreDataManager.checkScheduleInFavorites(id: idToStore))
            {
                Mark = "unmark"
                CoreDataManager.RemoveScheduleFromFavorites(id: idToStore)
            }else{
                Mark = "mark"
                CoreDataManager.AddScheduleToFavorites(id: idToStore, eventid: (Int64(self.EventDetail.agendaId!)))
            }
            
            self.hud.hide(true, afterDelay: 0)
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.labelText = "Processing..."
            hud.minSize = CGSize(width: 150, height: 100)
            
            let request = NSMutableURLRequest(url: NSURL(string: ServerApis.ScheduleUrl)! as URL)
            request.httpMethod = "POST"
            favList = CoreDataManager.GetAllScheduleFavorites()
            let params = ["appid": appid as AnyObject,
                          "userid":UserId as AnyObject,
                          "action": Mark as AnyObject,
                          "schedules": favList.description as AnyObject
                ] as Dictionary<String, AnyObject>
            print(params)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(token, forHTTPHeaderField: "Token")
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {
                    print("error=\(error)")
                    if(CoreDataManager.checkScheduleInFavorites(id: idToStore)){
                        CoreDataManager.RemoveScheduleFromFavorites(id: idToStore)
                    }
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                            if UserDefaults.standard.bool(forKey: "didsync") == false{
                                UserDefaults.standard.set(true, forKey: "didsync")
                            }
                            let alert = UIAlertController(title: "Request Failed", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    if(CoreDataManager.checkScheduleInFavorites(id: idToStore)){
                        CoreDataManager.RemoveScheduleFromFavorites(id: idToStore)
                    }
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                            if UserDefaults.standard.bool(forKey: "didsync") == false{
                                UserDefaults.standard.set(true, forKey: "didsync")
                            }
                            UIAlertView(title: "Request Failed",message:"Check connection and try again" ,delegate: nil,cancelButtonTitle: "OK").show()
                            
                        })
                    })
                }
                
                do {
                    let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print("responseString = \(jsonResult) ")
                    let response = (jsonResult["response"] as? Bool)!
                    let responseString = (jsonResult["responseString"] as? String)!
                    if(response == true)
                    {
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                                if(self.fromfav){
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
                            })
                        })
                        
                    }else
                    {
                        if(CoreDataManager.checkScheduleInFavorites(id: idToStore)){
                            CoreDataManager.RemoveScheduleFromFavorites(id: idToStore)
                        }
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                                CoreDataManager.RemoveScheduleFromFavorites(id: idToStore)
                                if UserDefaults.standard.bool(forKey: "didsync") == false{
                                    UserDefaults.standard.set(true, forKey: "didsync")
                                }
                                UIAlertView(title: "Request Field",message:responseString ,delegate: nil,cancelButtonTitle: "OK").show()
                                
                            })
                        })
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                            if UserDefaults.standard.bool(forKey: "didsync") == false{
                                UserDefaults.standard.set(true, forKey: "didsync")
                            }
                        })
                    })
                }catch
                {
                    
                    print("error")
                    if(CoreDataManager.checkScheduleInFavorites(id: idToStore)){
                        CoreDataManager.RemoveScheduleFromFavorites(id: idToStore)
                    }
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                            if UserDefaults.standard.bool(forKey: "didsync") == false{
                                UserDefaults.standard.set(true, forKey: "didsync")
                            }
                            UIAlertView(title: "Request Failed",message:"Check connection and try again" ,delegate: nil,cancelButtonTitle: "OK").show()
                        })
                    })
                    
                }
                DispatchQueue.main.async(execute: {() -> Void in
                    if(CoreDataManager.checkScheduleInFavorites(id: idToStore))
                    {
                        let checkicon = String.fontAwesomeIcon(code: "fa-check")
                        self.addtoschedule.setTitle(checkicon! + " " + "REMOVE FROM MY SCHEDULE", for: .normal)
                    }else{
                        let addicon = String.fontAwesomeIcon(code: "fa-plus-circle")
                        self.addtoschedule.setTitle(addicon! + " " + "ADD TO MY SCHEDULE", for: .normal)
                    }
                })
            }
            task.resume()
        }else
        {
            UIAlertView(title: "Request Failed",message:"Please Login and try again" ,delegate: nil,cancelButtonTitle: "OK").show()
        }
    }
    
    func openMap(sender:UITapGestureRecognizer) {
        let dataAtIndex = Mapper<Maps>().map(JSONObject: EventDetail.location_detail)
        let nsdataObj = NSKeyedArchiver.archivedData(withRootObject: dataAtIndex!)
        defaults.set(nsdataObj, forKey: "mapData")
        
        let mapController = storyboard?.instantiateViewController(withIdentifier: "MapsTabBarController") as! MapsTabBarController
        mapController.title = dataAtIndex?.title
        self.navigationController?.pushViewController(mapController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rateThisIcon.rating = 0
        
        if EventDetail.location_detail.count > 0{
            let locationtap = UITapGestureRecognizer(target: self, action: #selector(self.openMap(sender:)))
            location.isUserInteractionEnabled = true
            location.addGestureRecognizer(locationtap)
        }

        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.openAttachment))
        tap.delegate = self
        pdfFile.addGestureRecognizer(tap)
        
        datetimeview.layer.cornerRadius = 5
        datetimeview.layer.borderColor = UIColor.lightGray.cgColor
        datetimeview.layer.borderWidth = 1
        rateThisIcon.isUserInteractionEnabled = false
        speakerstableheight.constant = 0
        speakerscount = (EventDetail.speakerId?.count)!
        speakerstableheight.constant = CGFloat(speakerscount * 82)
        if speakerscount == 0{
            speakersLabelHeight.constant = 0
            speakers.isHidden = true
            speakersLabel.isHidden = true
        }
        speakers.register(UINib(nibName: "NewEventDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "NewEventDetailTableViewCell")
        speakers.reloadData()
        if let data = UserDefaults.standard.object(forKey: "speckerData"){
            let dataAtIndex = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
            speckrdata = (Mapper<SpeakersData>().map(JSONObject:dataAtIndex)?.items)!
        }
        initgestureforviews()
        rateThisIcon.isHidden = true
    }
    
    func openAttachment(sender: UITapGestureRecognizer) {
        if EventDetail.attachment_url?.isEmpty == false{
            let AwardsView = self.storyboard?.instantiateViewController(withIdentifier: "AwardsViewController") as! AwardsViewController
            AwardsView.title = "Attachment"
            AwardsView.urlString = EventDetail.attachment_url!
            self.navigationController?.pushViewController(AwardsView, animated: true)
        }else{
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                let alert = UIAlertController(title: "Request Failed", message: "No Attachment Found", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                })
                self.present(alert, animated: true, completion: nil)
            })
        })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appid = self.defaults.string(forKey: "selectedappid")
        getRatings()
        let pdficon = String.fontAwesomeIcon(code: "fa-file-pdf-o")
        pdfFile.isUserInteractionEnabled = true
        pdfFile.font = UIFont.fontAwesome(ofSize: 15)
        pdfFile.text = pdficon! + "  Attachment"
        if EventDetail.attachment_url!.characters.count > 0{
            pdfview.isHidden = false
        }else{
            pdfview.isHidden = true
        }

        let locationicon = String.fontAwesomeIcon(code: "fa-map-marker")
        let categoryicon = String.fontAwesomeIcon(code: "fa-circle")
        let addnotesicon = String.fontAwesomeIcon(code: "fa-pencil-square-o")
        locationIcon.font = UIFont.fontAwesome(ofSize: 15)
        categoryIcon.font = UIFont.fontAwesome(ofSize: 15)
        addNotesIcon.font = UIFont.fontAwesome(ofSize: 15)
        location.text = EventDetail.location!
        category.text = EventDetail.category!
        let fromtimeinstr = TimeConversion().stringfrommilliseconds(ms: EventDetail.fromtime! , format: "hh:mm a")
        let totimeinstr = TimeConversion().stringfrommilliseconds(ms: EventDetail.totime! , format: "hh:mm a")
        time.text = fromtimeinstr + " - " + totimeinstr
        if EventDetail.desc?.isEmpty == true{
            descriptiontext.isHidden = true
        }else{
            descriptiontext.attributedText = EventDetail.desc?.html2AttributedString
            descriptiontext.font = UIFont.systemFont(ofSize: 16)
        }
        addNotesIcon.text = addnotesicon!
        locationIcon.text = locationicon!
        categoryIcon.text = categoryicon!
        startDate.text = TimeConversion().stringfrommilliseconds(ms: EventDetail.fromtime! , format: "E, MMM dd, yyyy")
        eventTopic.text = EventDetail.topic!
        addtoschedule.titleLabel?.font = UIFont.fontAwesome(ofSize: 15)
        let Scheduleid = "\(appid!)\(EventDetail.agendaId!)"
        if(CoreDataManager.checkScheduleInFavorites(id: Scheduleid))
        {
            let checkicon = String.fontAwesomeIcon(code: "fa-check")
            addtoschedule.setTitle(checkicon! + " " + "REMOVE FROM MY SCHEDULE", for: .normal)
        }else{
            let addicon = String.fontAwesomeIcon(code: "fa-plus-circle")
            addtoschedule.setTitle(addicon! + " " + "ADD TO MY SCHEDULE", for: .normal)
        }
        
        if let themeclr = UserDefaults.standard.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
            categoryIcon.textColor = UIColor.red
            addNotesIcon.textColor = UIColor.init(hex: themeclr)
            addNotes.textColor = UIColor.init(hex: themeclr)
            locationIcon.textColor = UIColor.gray
            category.textColor = UIColor.gray
            location.textColor = UIColor.gray
            addtoschedule.setTitleColor(UIColor.init(hex: themeclr), for: .normal)
        }
    }
    
    func initgestureforviews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        addnotesview.addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(sender:)))
        tap1.delegate = self
        ratethisview.addGestureRecognizer(tap1)

    }

    func handleTap(sender: UITapGestureRecognizer) {
        print("handleTap")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNotesViewController") as! AddNotesViewController
        vc.NoteID = Int64(EventDetail.agendaId!)
        vc.NoteType = "fromAgenda"
        vc.NoteName = EventDetail.topic!
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func handleTap1(sender: UITapGestureRecognizer) {
        print("handleTap1")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        vc.RateType = "fromAgenda"
        vc.RateID = String(EventDetail.agendaId!)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getspeckername(id:Int)->(name:String,desc:String,imageurl:String){
        
        var spckercount = speckrdata.count
        
        while(spckercount > 0) {
            if(speckrdata[spckercount-1].speakerId! == id )
            {
                return (speckrdata[spckercount-1].name!,speckrdata[spckercount-1].desc!, speckrdata[spckercount-1].image!)
            }
            spckercount -= 1;
        }
        return ("","","")
    }
    
    func getspeckerdetail(id:Int) -> SpeakersDataItems{
        
        var spckercount = speckrdata.count
        var speakerdetail : SpeakersDataItems!
        while(spckercount > 0) {
            if(speckrdata[spckercount-1].speakerId! == id )
            {
                speakerdetail = speckrdata[spckercount-1]
            }
            spckercount -= 1;
        }
        return speakerdetail
    }

    
}

extension NewEventDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if speakerscount > 0{
            speakersLabel.isHidden = false
        }else{
            speakersLabel.isHidden = true
        }
        return speakerscount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewEventDetailTableViewCell", for: indexPath) as! NewEventDetailTableViewCell
        let speakerdetail = getspeckername(id: EventDetail.speakerId![indexPath.row] as! Int)
        cell.name.text = speakerdetail.name
        cell.desc.text = speakerdetail.desc.html2String
        cell.profileimageView.layer.cornerRadius = 3
        cell.profileimageView?.sd_setImage(with: URL(string: speakerdetail.imageurl), placeholderImage: UIImage(named: "EmptyUser.png"))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fromagenda{
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewSpeakerDetailsViewController") as! NewSpeakerDetailsViewController
            nextViewController.speakersDetail = getspeckerdetail(id: EventDetail.speakerId![indexPath.row] as! Int)
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    func getRatings()  {
        let appid = self.defaults.string(forKey: "selectedappid")!
        let url = ServerApis.GetRatingUrl + appid + "&type=" + "agenda" + "&type_id=" + String(EventDetail.agendaId!)
        print(url)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            guard error == nil && data != nil else {
                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "Request Failed", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
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
            
            if (statusCode == 200){
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as! [String: Any]
                    if ((json["response"] as! Bool) == true){
                        let responseString = json["responseString"]!
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.rateThisIcon.isHidden = false
                                self.rateThisIcon.rating = responseString as! Float
                            })
                        })
                    }else{
                        let responseString = json["responseString"] as! String
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                let alert = UIAlertController(title: "Request Failed", message: "Rating could not be updated.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        })
                    }
                }catch {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            let alert = UIAlertController(title: "Request Failed", message: "Rating could not be updated.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                }
            }else{
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "Request Failed", message: "Rating could not be updated.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                })
            }
        })
        task.resume()
        
    }
}


