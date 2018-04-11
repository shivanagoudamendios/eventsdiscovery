//
//  NewSpeakerDetailsViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/8/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class NewSpeakerDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var sessionslabel: UILabel!
    @IBOutlet weak var contactlabel: UILabel!
    @IBOutlet weak var detaillabel: UILabel!
    @IBOutlet weak var sessionslabelheight: NSLayoutConstraint!
    @IBOutlet weak var contactslabelheight: NSLayoutConstraint!
    @IBOutlet weak var detaillabelheight: NSLayoutConstraint!
    @IBOutlet weak var speakerpic: UIImageView!
    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var ratingview: UIView!
    @IBOutlet weak var speakerdesc: UILabel!
    @IBOutlet weak var speakerDetail: UITextView!
    @IBOutlet weak var speakerName: UILabel!
    @IBOutlet weak var ContactTableView: UITableView!
    @IBOutlet weak var contacttableheight: NSLayoutConstraint!
    @IBOutlet weak var sessionsTableView: UITableView!
    @IBOutlet weak var sessiontableheight: NSLayoutConstraint!
    var speakersDetail : SpeakersDataItems!
    var eventDetailArray = [AgendaDetails]()
    var agendaArray = [AgendaInAgenda]()
    var fromspeakers : Bool = false
    var sociallinks : [String] = [String]()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        getRatings()
        rating.rating = 0
        rating.isUserInteractionEnabled = false
        ContactTableView.delegate = self
        sessionsTableView.delegate = self
        ContactTableView.register(UINib(nibName: "NewSocialMediaTableViewCell", bundle: nil), forCellReuseIdentifier: "NewSocialMediaTableViewCell")
        sessionsTableView.register(UINib(nibName: "NewSessionsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewSessionsTableViewCell")
        
        contacttableheight.constant = 0
        speakerName.text = speakersDetail.name!
        speakerdesc.text = speakersDetail.desc!.html2String
        if (speakersDetail.facebook?.characters.count)! > 0{
            contacttableheight.constant += 82
            sociallinks.append(speakersDetail.facebook!)
        }
        if (speakersDetail.linkedin?.characters.count)! > 0{
            contacttableheight.constant += 82
            sociallinks.append(speakersDetail.linkedin!)
        }
        if ((speakersDetail.linkedin?.characters.count)! == 0) && ((speakersDetail.facebook?.characters.count)! == 0){
            contactslabelheight.constant = 0
            contactlabel.isHidden = true
        }
        
        if (speakersDetail.details?.characters.count)! > 0{
            speakerDetail.attributedText = speakersDetail.details?.html2AttributedStringWithFontSize(fontsize: 15)
//            speakerDetail.font = UIFont.systemFont(ofSize: 16)
        }else{
            speakerDetail.isHidden = true
            detaillabelheight.constant = 0
            detaillabel.isHidden = true
        }
        if (speakersDetail.agendaId?.count)! == 0{
            sessionslabelheight.constant = 0
            sessionslabel.isHidden = true
        }
        sessiontableheight.constant = CGFloat(((speakersDetail.agendaId?.count)!)*82)
        if let data = UserDefaults.standard.object(forKey: "agendadata1") as? NSData {
            let agenda = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [AnyObject]
            agendaArray = Mapper<AgendaInAgenda>().mapArray(JSONObject: agenda)!
            for x in 0 ... agendaArray.count-1 {
                eventDetailArray += agendaArray[x].detail!
            }
        }
        speakerpic.sd_setImage(with: URL(string: speakersDetail.image!), placeholderImage: UIImage(named: "EmptyUser.png"))
        speakerpic.layer.cornerRadius = 3
        ContactTableView.separatorStyle = .none
        sessionsTableView.separatorStyle = .none
        rating.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(sender:)))
        tap1.delegate = self
        ratingview.addGestureRecognizer(tap1)
    }
    
    func handleTap1(sender: UITapGestureRecognizer) {
        print("handleTap1")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        vc.RateType = "fromSpeakers"
        vc.RateID = String(speakersDetail.speakerId!)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ContactTableView{
            return sociallinks.count
        }else{
            return (speakersDetail.agendaId?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ContactTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewSocialMediaTableViewCell", for: indexPath) as! NewSocialMediaTableViewCell
            if (sociallinks[indexPath.row].contains("www.facebook.com")){
                cell.socialnetwork.text = "Facebook"
                cell.sociallink.text = speakersDetail.facebook
                cell.socialimage.image = UIImage(named: "facebookblack")
            }else{
                cell.socialnetwork.text = "LinkedIn"
                cell.sociallink.text = speakersDetail.linkedin
                cell.socialimage.image = UIImage(named: "linkedInblack")
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewSessionsTableViewCell", for: indexPath) as! NewSessionsTableViewCell
            let fromtimeinstr = TimeConversion().stringfrommilliseconds(ms: getagendafromtime(id: speakersDetail.agendaId![indexPath.row] as! Int) , format: "hh:mm a")
            let totimeinstr = TimeConversion().stringfrommilliseconds(ms: getagendatotime(id: speakersDetail.agendaId![indexPath.row] as! Int) , format: "hh:mm a")
            let milli = getagendaname(id: speakersDetail.agendaId![indexPath.row] as! Int)
            cell.startdate.text = TimeConversion().stringfrommilliseconds(ms: milli , format: "E, MMM dd, yyyy")
            cell.eventtime.text = fromtimeinstr + " - " + totimeinstr
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == ContactTableView{
            let cell = tableView.cellForRow(at: indexPath) as! NewSocialMediaTableViewCell
            if cell.sociallink.text!.contains("http"){
                if let url = URL(string: cell.sociallink.text!) {
                    UIApplication.shared.openURL(url)
                }
            }else{
                let socialURL = "http://" + cell.sociallink.text!
                if let url = URL(string: socialURL) {
                    UIApplication.shared.openURL(url)
                }
            }
        }else{
            if fromspeakers{
                let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewEventDetailsViewController") as! NewEventDetailsViewController
                nextViewController.fromfav = false
                nextViewController.EventDetail = getagendadetail(id: speakersDetail.agendaId![indexPath.row] as! Int)
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
    }
    
    func getagendaname(id:Int)->Double{
        var eventDetail = [AgendaDetails]()
        for aA in  agendaArray {
            eventDetail = aA.detail!
            for eD in  eventDetail {
                if(eD.agendaId! == id )
                {
                    return (aA.name!)
                }
                
            }
        }
        
        return 0
        
    }
    
    func getagendadesc(id:Int)->String{
        
        for x in eventDetailArray {
            if(x.agendaId! == id )
            {
                return (x.activity!)
            }
        }
        return ""
        
    }
    
//    func getagendatime(id:Int)->String{
//        for x in eventDetailArray {
//            if(x.agendaId! == id )
//            {
//                return (x.time!)
//            }
//        }
//        return ""
//        
//    }
    
    func getagendafromtime(id:Int)->Double{
        for x in eventDetailArray {
            if(x.agendaId! == id )
            {
                return (x.fromtime!)
            }
        }
        return 0
        
    }
    
    func getagendatotime(id:Int)->Double{
        for x in eventDetailArray {
            if(x.agendaId! == id )
            {
                return (x.totime!)
            }
        }
        return 0
        
    }
    
    func getagendadetail(id:Int)->AgendaDetails{
        var agendadetail : AgendaDetails!
        for detail in eventDetailArray {
            if(detail.agendaId! == id )
            {
                agendadetail = detail
            }
        }
        return agendadetail
    }

    func getRatings()  {
        let appid = self.defaults.string(forKey: "selectedappid")!
        let url = ServerApis.GetRatingUrl + appid + "&type=" + "speakers" + "&type_id=" + String(speakersDetail.speakerId!)
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
                                self.rating.isHidden = false
                                self.rating.rating = responseString as! Float
                            })
                        })
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
