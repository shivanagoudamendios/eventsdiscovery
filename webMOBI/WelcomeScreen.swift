

//
//  WelcomeScreen.swift
//  webMOBI
//
//  Created by webmobi on 5/15/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class WelcomeScreen: UIViewController {
    
    @IBOutlet weak var facebookuiview: UIView!
    @IBOutlet weak var linkedinuiview: UIView!
    @IBOutlet weak var createaccount: UIButton!
    @IBOutlet weak var termsTextView: UITextView!
    let defaults = UserDefaults.standard
    var previousEventCount = 0
    
    func LevelChanged(notification: NSNotification)
    {
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.LevelChanged),
            name: Notification.Name("cometoroot"),
            object: nil)
        self.navigationController?.isNavigationBarHidden = true
        //Create background Image to scale and fit the view
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "LaunchImage")!.draw(in: self.view.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor! = UIColor(patternImage: image!)
        
        facebookuiview.layer.cornerRadius = 15
        linkedinuiview.layer.cornerRadius = 15
        createaccount.layer.borderWidth = 2
        createaccount.layer.borderColor = UIColor.white.cgColor
        createaccount.layer.cornerRadius = 15
        termsTextView.text = "Terms & Conditions\nAll copyright, trademarks, design rights, and other intellectual properties belong to webMOBI and/or third parties. webMOBI reserves all the rights and doesn’t grant a right or license to use any intellectual property including trademark, design or copyright."
        termsTextView.textColor = UIColor.white
    }
    
    @IBAction func welcomecloseAction(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "userclose")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func facebookconnect(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {() -> Void in
            self.view.addLoader()
        })
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions : [ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.removeLoader()
                })
            case .cancelled:
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.removeLoader()
                })
                print("User cancelled login.")
                
            case .success(grantedPermissions: let grantedPermissions, declinedPermissions: let declinedPermissions, token: let accessToken):
                print(grantedPermissions, declinedPermissions, accessToken)
                print("Logged in!")
                let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large), email, link, id"])
                
                graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                    let res = result as! [String: Any]
                    print(res)
                    let pictures = res["picture"] as! [String: [String: Any]]
                    let fb_id = res["id"] as! String
                    let firstname = res["first_name"] as! String
                    let lastname = res["last_name"] as! String
                    let profilelink = res["link"] as! String
                    let email = res["email"] as! String
                    let profilpicurl = pictures["data"]?["url"] as! String
                    self.SocialConnect(media_type: "facebook", fb_id: fb_id, linked_in_id: "", firstname: firstname, lastname: lastname, email: email, profile_pic_url: profilpicurl, company: "", designation: "")
                })
            }
        }
    }
    
    @IBAction func linkedinconnect(_ sender: UIButton) {

        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.addLoader()
            })
            print("success called!")
            print(LISDKSessionManager.sharedInstance().session)
            
            let url = "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,email-address,location:(name),industry,public-profile-url,picture-url,primary-twitter-account,network,skills,summary,phone-numbers,date-of-birth,main-address,positions:(title,company:(name)),educations:(school-name,field-of-study,start-date,end-date,degree,activities))"
            
            if LISDKSessionManager.hasValidSession() {
                LISDKAPIHelper.sharedInstance().getRequest(url, success: { (response) -> Void in
                    let str = response?.data
                    do {
                        let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: str!.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        print(jsonResult)
                        var PictureURL = ""
                        let linkedin_id = jsonResult.value(forKey: "id") as? String
                        let email = jsonResult.value(forKey: "emailAddress") as? String
                        let FirstName = jsonResult.value(forKey: "firstName") as? String
                        let LastName = jsonResult.value(forKey: "lastName") as? String
                        if jsonResult.value(forKey: "pictureUrl") != nil{
                            PictureURL = (jsonResult.value(forKey: "pictureUrl") as? String)!
                        }
                        let  posobj = (jsonResult.value(forKey: "positions")! as AnyObject).value(forKey: "values") as? [AnyObject]
                        var companyname = ""
                        var job = ""
                        if((posobj?.count)! > 0)
                        {
                            let companyname1 = posobj?[0]["company"] as? [String: AnyObject]
                            companyname = companyname1?["name"] as! String
                            job = (posobj![0]["title"] as? String)!
                        }
                        
                        self.SocialConnect(media_type: "linkedin", fb_id: "", linked_in_id: linkedin_id!, firstname: FirstName!, lastname: LastName!, email: email!, profile_pic_url: PictureURL, company: companyname, designation: job)
                    }catch
                    {
                        print(error)
                        
                    }
                }, error: { (error) -> Void in
                    print(error!)
                })
            }
        }) { (error) -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.removeLoader()
            })
            print("Error: \(error!)")
        }
    }
    
    func SocialConnect(media_type: String, fb_id: String, linked_in_id: String, firstname: String, lastname: String, email: String, profile_pic_url: String, company: String, designation: String) {
        
        let time = Int(NSTimeZone.local.secondsFromGMT())
        let timezone = secondsToHoursMinutesSeconds(seconds: time)
        
        var request = URLRequest(url: URL(string: ServerAPIs.discovery_social_media_connect)!)
        request.httpMethod = "POST"
        let params = ["media_type": media_type as AnyObject,
                      "fb_id": fb_id as AnyObject,
                      "linked_in_id": linked_in_id as AnyObject,
                      "first_name": firstname as AnyObject,
                      "last_name": lastname as AnyObject,
                      "email": email as AnyObject,
                      "profile_pic_url": profile_pic_url as AnyObject,
                      "company": company as AnyObject,
                      "designation": designation as AnyObject,
                      "deviceId": defaults.string(forKey: "devicetoken") as AnyObject,
                      "deviceType": "ios" as AnyObject,
                      "timezone": timezone as AnyObject
            ] as Dictionary<String, AnyObject>
        print("params",params)
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            guard error == nil && data != nil else {
                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "ERROR CODE: \((error as! NSError).code)", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
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
                    print(json)
                    if (json["response"] as! Bool) == true{
                        let data = json["responseString"] as! [String: Any]
                        let myevents = json["myevents"] as! [Any]
                        print(myevents)
                        self.previousEventCount = myevents.count
                        UserDefaults.standard.setValue(data, forKeyPath: "userlogindata")
                        UserDefaults.standard.set(email, forKey: "discovery_email")
                        UserDefaults.standard.set("", forKey: "discovery_password")
                        UserDefaults.standard.set(true, forKey: "didloginfromsocial")
                        for singleevnt in myevents{
                            let event = singleevnt as! [String: Any]
                            self.downloadSingleEvents(id: event["appid"]! as! String, url: event["app_url"]! as! String, obj: event, info_privacy: event["info_privacy"] as! Bool, passwordres: event["private_key"] as! String)
                        }
                        DispatchQueue.main.async(execute: {() -> Void in
                            if self.previousEventCount == 0{
                                self.view.removeLoader()
                                let alert = UIAlertController(title: "SUCCESS", message: "Login Successfull" , preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    NotificationCenter.default.post(name: Notification.Name("cometohome"), object: nil)
                                })
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    }else{
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.view.removeLoader()
                            let alert = UIAlertController(title: "OOPS...!", message: json["responseString"] as! String? , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
                }catch {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                    })
                    print("json")
                }
            }else{
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.removeLoader()
                    let alert = UIAlertController(title: "Request Failed", message: "Please try again!" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        
                    })
                    self.present(alert, animated: true, completion: nil)
                })
            }
        })
        task.resume()
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        var time = ""
        if(seconds >= 0)
        {
            time = "+"+Int(seconds / 3600).description+":"+Int((seconds % 3600) / 60).description
        }else
        {
            time = "-"+Int(abs(seconds) / 3600).description+":"+Int((abs(seconds) % 3600) / 60).description
        }
        return time
    }
    
    func downloadSingleEvents(id : String, url:String, obj: Any, info_privacy: Bool, passwordres: String) {
        DownloadEvent().singleEvent(appID:id,appURL: url,event:obj){ receiveddata in
            if(receiveddata){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadMyEvents"), object: nil)
                var password = ""
                if UserDefaults.standard.value(forKey: "userlogindata") != nil{
                    if info_privacy == true{
                        password = passwordres
                    }else{
                        password = UserDefaults.standard.string(forKey: "discovery_password")!
                    }
                }
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        CoreDataManager.storeDownlodedEvent(appid: id, isfirstlogin: false, password: password)
                        self.previousEventCount -= 1
                        if self.previousEventCount == 0{
                            self.view.removeLoader()
                            let alert = UIAlertController(title: "SUCCESS", message: "Login Successfull" , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                NotificationCenter.default.post(name: Notification.Name("cometohome"), object: nil)
                            })
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                })
            }else{
                self.previousEventCount -= 1
            }
        }
    }
}

