//
//  RatingViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/16/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import MBProgressHUD

class RatingViewController: UIViewController, FloatRatingViewDelegate {
    
    @IBOutlet weak var blurview: UIView!
    @IBOutlet weak var ratingview: FloatRatingView!
    @IBOutlet weak var ratingbacground: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    var ratingvalue : Float = 0.0
    var RateType = ""
    var RateID = ""
    let defaults = UserDefaults.standard
    var hud = MBProgressHUD()
    var updatedValue : Double!
    var action = ""
    var ratetype = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingview.delegate = self
        ratingview.rating = ratingvalue
        ratingview.editable = true
        ratingview.floatRatings = true
        updatedValue = Double(ratingvalue)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurview.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurview.addSubview(blurEffectView)
        self.view.bringSubview(toFront: ratingbacground)
        ratingbacground.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func getRatingValue() {
        let appid = self.defaults.string(forKey: "selectedappid")
        let idToStore = "\(appid!)\(RateID)"

        switch RateType {
        case "fromAgenda":
            ratetype = "agenda"
            if CoreDataManager.checkforAgendaRatingID(id: idToStore){
                ratingview.rating = Float(CoreDataManager.GetRatingfromAgendaID(id: idToStore).rating)
                action = "update"
            }else{
                ratingview.rating = 0.0
                action = "create"
            }
        case "fromSpeakers":
            ratetype = "speakers"
            if CoreDataManager.checkforSpeakersRatingID(id: idToStore){
                ratingview.rating = Float(CoreDataManager.GetRatingfromSpeakersID(id: idToStore).rating)
                action = "update"
            }else{
                ratingview.rating = 0.0
                action = "create"
            }
        default:
            ratingview.rating = 0.0
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let themeclr = UserDefaults.standard.string(forKey: "themeColor"){
            cancelButton.layer.cornerRadius = 13.5
            rateButton.layer.cornerRadius = 13.5
            cancelButton.layer.borderWidth = 2
            cancelButton.layer.borderColor = UIColor.init(hex: themeclr).cgColor
            rateButton.layer.borderWidth = 2
            rateButton.layer.borderColor = UIColor.init(hex: themeclr).cgColor
            cancelButton.setTitleColor(UIColor.init(hex: themeclr), for: .normal)
            rateButton.setTitleColor(UIColor.init(hex: themeclr), for: .normal)
        }
        getRatingValue()
    }
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        let ss = NSString(format: "%.2f", rating) as String
        print("is updating",ss)
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        print(rating)
        updatedValue = Double(rating)
        //        let ss = NSString(format: "%.2f", self.ratingview.rating) as String
        //        print("did update",ss)
        //        if self.defaults.bool(forKey: "login")
        //        {
        //            ratingupdate(rate: ss)
        //        }else
        //        {
        //            UIAlertView(title: "User Not Login",message:"Please Login First" ,delegate: nil,cancelButtonTitle: "OK").show()
        //        }
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rate(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: "userlogindata") != nil{
            postRating()
        }else{
            let alert = UIAlertController(title: "Not Logged in", message: "Login Required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.dismiss(animated: true, completion: nil)
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postRating() {
        if updatedValue > 0{
            
            let appid = self.defaults.string(forKey: "selectedappid")
            let userid = defaults.string(forKey: "EvntUserId")!
            if userid.characters.count > 0{
                hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.labelText = "Rating..."
                hud.minSize = CGSize(width: 150, height: 100)
                
                self.hud.hide(true, afterDelay: 0)
                hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.labelText = "Rating..."
                hud.minSize = CGSize(width: 150, height: 100)
                
                let request = NSMutableURLRequest(url: NSURL(string: ServerApis.SetRatingUrl)! as URL)
                request.httpMethod = "POST"
                
                let params = ["userid": userid as AnyObject,
                              "appid": appid as AnyObject,
                              "type": ratetype as AnyObject,
                              "type_id": RateID as AnyObject,
                              "rating": updatedValue as AnyObject,
                              "action": action as AnyObject
                    ] as Dictionary<String, AnyObject>
                print(params)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
                
                let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
                    guard error == nil && data != nil else {
                        print("error=\(error)")
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
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
                                let responseString = json["responseString"] as! String
                                let rating_average = json["rating_average"] as! Double
                                self.saveRatingToCoreData(responseaveragevalue: Int16(round(self.updatedValue)))
                                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                                    DispatchQueue.main.async(execute: {() -> Void in
                                        self.hud.hide(true, afterDelay: 0.5)
                                        let alert = UIAlertController(title: "SUCCESS", message: responseString, preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                            UIAlertAction in
                                            self.dismiss(animated: true, completion: nil)
                                        })
                                        self.present(alert, animated: true, completion: nil)
                                    })
                                })
                            }else{
                                let responseString = json["responseString"] as! String
                                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                                    DispatchQueue.main.async(execute: {() -> Void in
                                        self.hud.hide(true, afterDelay: 0.5)
                                        let alert = UIAlertController(title: "Request Failed", message: responseString, preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                            UIAlertAction in
                                            self.dismiss(animated: true, completion: nil)
                                        })
                                        self.present(alert, animated: true, completion: nil)
                                    })
                                })
                            }
                        }catch {
                            print("json")
                            self.hud.hide(true, afterDelay: 0.5)
                        }
                    }else{
                        print("json")
                        self.hud.hide(true, afterDelay: 0.5)
                    }
                })
                task.resume()
            }else{
                let alert = UIAlertController(title: "Request Failed", message: "Login required for rating.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                })
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.hud.hide(true, afterDelay: 0.5)
                    let alert = UIAlertController(title: "Request Failed", message: "Please give the rating.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                    })
                    self.present(alert, animated: true, completion: nil)
                })
            })
        }
    }
    
    func saveRatingToCoreData(responseaveragevalue: Int16) {
        let appid = self.defaults.string(forKey: "selectedappid")!
        let userid = defaults.string(forKey: "EvntUserId")!
        let idToStore = "\(appid)\(RateID))"

        if ratetype == "agenda"{
            if CoreDataManager.checkforAgendaRatingID(id: idToStore){
                CoreDataManager.UpdateRatingsfromAgendaID(type_id: idToStore, rating: responseaveragevalue)
            }else{
                CoreDataManager.storeAgendaRating(appid: appid, rating: responseaveragevalue, rating_id: "", rating_type: "agenda", type_id: idToStore, userid: userid)
            }
        }else{
            if CoreDataManager.checkforSpeakersRatingID(id: idToStore){
                CoreDataManager.UpdateRatingsfromSpeakersID(type_id: idToStore, rating: responseaveragevalue)
            }else{
                CoreDataManager.storeSpeakersRating(appid: appid, rating: responseaveragevalue, rating_id: "", rating_type: "speaker", type_id: idToStore, userid: userid)
            }
        }
    }
}
