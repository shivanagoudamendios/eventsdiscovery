//
//  NewSurveyViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/5/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import MBProgressHUD
protocol CustomCellUpdater {
    func updateTableView(msg : String)
}

class NewSurveyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CustomCellUpdater {
    
    @IBOutlet weak var finishbutton: UIButton!
    @IBOutlet weak var nextquestion: UIButton!
    @IBOutlet weak var previousquestion: UIButton!
    @IBOutlet weak var questionprogressview: UIProgressView!
    @IBOutlet weak var questionnumber: UILabel!
    @IBOutlet weak var surveyquestion: UITextView!
    @IBOutlet weak var surveyanswers: UITableView!
    @IBOutlet weak var BtnsView: UIView!
    let defaults = UserDefaults.standard
    var surveyArray : [newSurveyItems] = [newSurveyItems]()
    var seletedcount : Int = 0
    var totalquestions = 0
    var pollingindex = 0
    var answeredQns : [String : [String]] = [:]
    var pollingname = ""
    var hud = MBProgressHUD()
    func updateTableView(msg : String)
    {
        let selectedqns = surveyArray[seletedcount]
        answeredQns[selectedqns.question!] = [msg]
        surveyanswers.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        surveyquestion.textAlignment = .left
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
            questionprogressview.progressTintColor = UIColor.init(hex: themeclr)
            
            let origImage = UIImage(named: "next")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            nextquestion.setImage(tintedImage, for: .normal)
            nextquestion.tintColor = UIColor.init(hex: themeclr)
            
            let origImage1 = UIImage(named: "previous")
            let tintedImage1 = origImage1?.withRenderingMode(.alwaysTemplate)
            previousquestion.setImage(tintedImage1, for: .normal)
            previousquestion.tintColor = UIColor.init(hex: themeclr)
            
            finishbutton.tintColor = UIColor.init(hex: themeclr)
        }
        BtnsView.layer.borderWidth = 0.5
        BtnsView.layer.borderColor = UIColor.lightGray.cgColor
        questionprogressview.layer.cornerRadius = 5
        questionprogressview.clipsToBounds = true
        questionnumber.text = "Question 1"
        surveyquestion.text = "Bengaluru (also called Bangalore) is the capital of India's southern Karnataka state."
        surveyquestion.font = UIFont.systemFont(ofSize: 16)
        surveyanswers.register(UINib(nibName: "SurveySingleAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "SurveySingleAnswerTableViewCell")
        surveyanswers.register(UINib(nibName: "SurveyMultipleAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "SurveyMultipleAnswerTableViewCell")
        surveyanswers.register(UINib(nibName: "MessageBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageBoxTableViewCell")
        surveyanswers.delegate = self
        surveyanswers.dataSource = self
        surveyanswers.tableFooterView = UIView()
        surveyanswers.bounces = false
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AppointmentViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(defaults.bool(forKey: "fromsurvey")){
        if let dataFromDefaults = defaults.object(forKey: "surveyData"){
            if let dataAtIndex = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as! Data){
                let objectFromDefaults = Mapper<newSurvey>().map(JSONObject: dataAtIndex)?.items
                surveyArray = objectFromDefaults!
            }
        }
        }else
        {
            let dataFromDefaultsAsNsData = defaults.object(forKey: "pollingData")
            if let dataAtIndex = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaultsAsNsData! as! Data){
                let dataFromDefaults = Mapper<Polling>().map(JSONObject: dataAtIndex)?.items
                let pollingArray = dataFromDefaults!
                surveyArray = pollingArray[pollingindex].poll!
            }
        }
            seletedcount = defaults.integer(forKey: "questionno")
            if(surveyArray.count > seletedcount)
            {
                if(answeredQns[surveyArray[seletedcount].question!] == nil)
                {
                    answeredQns[surveyArray[seletedcount].question!] = []
                }
                questionnumber.text = "Question " + (seletedcount + 1).description
                surveyquestion.text = surveyArray[seletedcount].question
                if(surveyArray[seletedcount].type == "messagebox")
                {
                    surveyanswers.rowHeight = 180
                }else
                {
                    surveyanswers.estimatedRowHeight = 60
                    surveyanswers.rowHeight = UITableViewAutomaticDimension
                }
                let value : Float = Float(seletedcount + 1)/Float(surveyArray.count)
                questionprogressview.setProgress(value, animated: true)
                
                if(surveyArray.count == 1)
                {
                    previousquestion.isHidden = true
                    nextquestion.isHidden = true
                    finishbutton.isEnabled = true
                }
                else if(seletedcount == 0)
                {
                    previousquestion.isHidden = true
                    nextquestion.isHidden = false
                    finishbutton.isEnabled = false
                }else if(seletedcount + 1  == surveyArray.count)
                {
                    nextquestion.isHidden = true
                    previousquestion.isHidden = false
                    finishbutton.isEnabled = true
                }else
                {
                    nextquestion.isHidden = false
                    previousquestion.isHidden = false
                    finishbutton.isEnabled = false
                }
                
            }else
            {
                surveyquestion.text = ""
                nextquestion.isHidden = true
                previousquestion.isHidden = true
                finishbutton.isEnabled = false
            }
            
            surveyanswers.reloadData()
        
        totalquestions = surveyArray.count
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {if(defaults.bool(forKey: "fromsurvey"))
        {
            self.setNavigationBarItem()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func nextbuttonAction(_ sender: UIButton) {
        
        var count = defaults.integer(forKey: "questionno")
        count = count + 1
        if(surveyArray.count > count)
        {
            defaults.set(count, forKey: "questionno")
            viewWillAppear(true)
        }
    }
    
    @IBAction func previousbuttonAction(_ sender: UIButton) {
        
        var count = defaults.integer(forKey: "questionno")
        
        if(count > 0)
        {
            count = count - 1
            defaults.set(count, forKey: "questionno")
            viewWillAppear(true)
        }
        
    }
    
    @IBAction func finishbuttonAction(_ sender: UIButton) {
        
//        print(answeredQns)
        var surveyArray = [[String]]()
        for ans in answeredQns{
        
            var array = [String]()
            array.append(ans.key)
            array = array+ans.value
            surveyArray.append(array)
        }
        print(surveyArray)
        submitAns(surveyArrayToBeSubmitted: surveyArray)
    }
    
    
    func submitAns( surveyArrayToBeSubmitted : [[String]] )
    {
        let name = defaults.string(forKey: "name")
        let email = defaults.string(forKey: "Useremail")
        let appid = self.defaults.string(forKey: "selectedappid")!
        let date = defaults.string(forKey: "eventDate")
        let UserId = self.defaults.string(forKey: "EvntUserId")
        let token = defaults.string(forKey: "token")
//        if(self.defaults.bool(forKey: "login") && name != nil)
//        {
//            
        
        
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.labelText = "Submitting Data..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        var request = NSMutableURLRequest(url: NSURL(string: ServerApis.SurveyFeedbackUrl)! as URL)
        if(defaults.bool(forKey: "fromsurvey"))
        {
            request = NSMutableURLRequest(url: NSURL(string: ServerApis.SurveyFeedbackUrl)! as URL)
            request.httpMethod = "POST"
            let params = ["userid": UserId as AnyObject,
                          "username": name as AnyObject,
                          "email": email as AnyObject,
                          "appId": appid as AnyObject,
                          "feedback": surveyArrayToBeSubmitted.description as AnyObject,
                          "submissiondate": currentTimeMillis().description as AnyObject,
                          "eventdate": date as AnyObject
                ] as Dictionary<String, AnyObject>
            print(params)
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        }else
        {
            request = NSMutableURLRequest(url: NSURL(string: ServerApis.pollingUrl)! as URL)
            request.httpMethod = "POST"
            let params = ["userid": UserId as AnyObject,
                          "username": name as AnyObject,
                          "email": email as AnyObject,
                          "appId": appid as AnyObject,
                          "feedback": surveyArrayToBeSubmitted.description as AnyObject,
                          "submissiondate": currentTimeMillis().description as AnyObject,
                          "eventdate": date as AnyObject,
                          "pollName": pollingname as AnyObject
                ] as Dictionary<String, AnyObject>
            print(params)
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        
        request.setValue(token, forHTTPHeaderField: "Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        
                let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                    guard error == nil && data != nil else {                                                          // check for fundamental networking error
                        print("error=\(error)")
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                                UIAlertView(title: "Error",message: "Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                            })
                        })
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                                
                                UIAlertView(title: "Error",message: "Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                                
                            })
                        })
                    }
                    
                    do {
                        let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options:  JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        print("responseString = \(jsonResult) ")
                        let response = (jsonResult["response"] as? Bool)!
                        let responseString = (jsonResult["responseString"] as? String)!
                        
                        if(response){
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                
//                                UIAlertView(title: "Success",message: responseString,delegate: nil,cancelButtonTitle: "OK").show(){
//
                                self.hud.hide(true, afterDelay: 0)
                                 let alert = UIAlertController(title: "Success", message: "Feedback submitted successfully", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    self.dismiss(animated: true, completion: nil)
                                    
                                })
                            
                                self.present(alert, animated: true, completion: nil)
                                
                            })
                            
                        })
                           
                        }else{
                            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    
//                                    UIAlertView(title: "Request Failed",message: responseString,delegate: nil,cancelButtonTitle: "OK").show()
                                    
                                    self.hud.hide(true, afterDelay: 0)
                                })
                            })
                        }
                        
                    }catch
                    {
                        print(error)
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                                UIAlertView(title: "Error",message: "Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                            })
                        })
                    }
                    
                }
                task.resume()
                
            
        
//        }else
//        {
//            UIAlertView(title: "Not Login or Name Not Available",message: "Please check the Login or Name",delegate: nil,cancelButtonTitle: "OK").show()
//        }
    }
    
    func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if surveyArray.count > seletedcount{
            if (surveyArray[seletedcount].type != "messagebox")
            {
                return surveyArray[seletedcount].answer.count
            }else
            {
                return 1
            }
        }else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selectedqns = surveyArray[seletedcount]
        let themeclr = defaults.string(forKey: "themeColor")
        if selectedqns.type == "single"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveySingleAnswerTableViewCell", for: indexPath) as! SurveySingleAnswerTableViewCell
            cell.selectedlabel.text = selectedqns.answer[indexPath.row]
            if(answeredQns[selectedqns.question!]?.contains(selectedqns.answer[indexPath.row]))!
            {
                cell.selectedimageview?.image = UIImage(named:"selectsingle")?.maskWithColor(color: UIColor(hex:themeclr!))
            }else
            {
                cell.selectedimageview?.image = UIImage(named:"unselect")?.maskWithColor(color: UIColor(hex:themeclr!))
            }
            return cell
        }else if selectedqns.type == "multiple"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyMultipleAnswerTableViewCell", for: indexPath) as! SurveyMultipleAnswerTableViewCell
            cell.selectedlabel.text = selectedqns.answer[indexPath.row]
            if(answeredQns[selectedqns.question!]?.contains(selectedqns.answer[indexPath.row]))!
            {
                cell.selectedimageview?.image = UIImage(named:"check")?.maskWithColor(color: UIColor(hex:themeclr!))
            }else
            {
                cell.selectedimageview?.image = UIImage(named:"uncheck")?.maskWithColor(color: UIColor(hex:themeclr!))
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageBoxTableViewCell", for: indexPath) as! MessageBoxTableViewCell
            cell.delegate = self
            cell.feedbackTextView.text = ""
            if((answeredQns[selectedqns.question!]?.count)! > 0)
            {
               cell.feedbackTextView.text = answeredQns[selectedqns.question!]?[0]
            }else
            {
                answeredQns[selectedqns.question!] = []
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedqns = surveyArray[seletedcount]
        
        if selectedqns.type == "single"{
            answeredQns[selectedqns.question!] = [selectedqns.answer[indexPath.row]]
            tableView.reloadData()
        }else if selectedqns.type == "multiple"{
            var selectedans = answeredQns[selectedqns.question!]
            if(selectedans?.contains(selectedqns.answer[indexPath.row]))!{
                selectedans =  selectedans?.filter(){$0 != selectedqns.answer[indexPath.row]}
            }else
            {
                selectedans?.append(selectedqns.answer[indexPath.row])
            }
            answeredQns[selectedqns.question!] = selectedans
            tableView.reloadData()
        }
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // print("Scrolled")
        
    }
}
extension UIImage {
    
    func maskWithColor( color:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        color.setFill()
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        context.draw(self.cgImage!, in: rect)
        
        context.setBlendMode(CGBlendMode.sourceIn)
        context.addRect(rect)
        context.drawPath(using: CGPathDrawingMode.fill)
        
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return coloredImage!
    }
}
