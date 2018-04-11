//
//  LoginViewController.swift
//  webMOBI
//
//  Created by webmobi on 5/17/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import FontAwesome_swift

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var secureButton: UIButton!
    
    let defaults = UserDefaults.standard
    let secure = String.fontAwesomeIcon(code: "fa-eye-slash")
    let insecure = String.fontAwesomeIcon(code: "fa-eye")
    var previousEventCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(self.keyboardOnScreen(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        center.addObserver(self, selector: #selector(self.keyboardOffScreen(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        UITextField.appearance().tintColor = UIColor.lightGray
        
        emailAddress.delegate = self
        password.delegate = self
        
        emailAddress.textColor = UIColor.white
        password.textColor = UIColor.white
        
        emailAddress.setBottomBorder()
        password.setBottomBorder()
        
        secureButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 17)
        secureButton.setTitle(String.fontAwesomeIcon(name: .eyeSlash), for: .normal)
        
        loginbutton.backgroundColor = UIColor.white
        loginbutton.layer.cornerRadius = 20
        let origImage = UIImage(named: "Loginicon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        loginbutton.setImage(tintedImage, for: .normal)
        loginbutton.tintColor = UIColor(red: 30/255, green: 112/255, blue: 145/255, alpha: 1)
    }
    
    func isValidEmail(testStr:String) -> Bool {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        checkforloginnotification()
    }
    
    @IBAction func securepassword(_ sender: UIButton) {
        if password.isSecureTextEntry{
            password.isSecureTextEntry = false
            secureButton.setTitle(String.fontAwesomeIcon(name: .eye), for: .normal)
        }else{
            password.isSecureTextEntry = true
            secureButton.setTitle(String.fontAwesomeIcon(name: .eyeSlash), for: .normal)
        }
        if (password.isFirstResponder){
            password.becomeFirstResponder()
        }
    }
    
    @IBAction func forgotpassword(_ sender: UIButton) {
        
        var storyboard = UIStoryboard()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        case .pad:
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        default:
            print("Dvice not detectable")
        }
        let newViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func loginclosebutton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == password{
            let emailtest = isValidEmail(testStr: emailAddress.text!)
            if emailtest != true{
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        UIAlertView(title: "Invalid email", message:"Enter the valid email" ,delegate: nil,cancelButtonTitle: "OK").show()
                        
                    })
                })
                emailAddress.becomeFirstResponder()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            if textField == emailAddress{
                let emailtest = isValidEmail(testStr: emailAddress.text!)
                if emailtest == true{
                    nextField.becomeFirstResponder()
                }else{
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            UIAlertView(title: "Invalid email", message:"Enter the valid email" ,delegate: nil,cancelButtonTitle: "OK").show()
                            
                        })
                    })
                    textField.becomeFirstResponder()
                }
            }
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func keyboardOnScreen(_ notification: Notification){
        
        let info: NSDictionary  = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject).cgRectValue.size
        let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        scrollview.contentInset = contentInsets
        scrollview.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize.height
        
    }
    
    func keyboardOffScreen(_ notification: Notification){
        
        let contentInsets:UIEdgeInsets = UIEdgeInsets.zero
        scrollview.contentInset = contentInsets
        scrollview.scrollIndicatorInsets = contentInsets
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension LoginViewController{
    
    func checkforloginnotification() {
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            print("isRegisteredForRemoteNotifications")
            Login()
        } else {
            print("Not RegisteredForRemoteNotifications")
            DispatchQueue.main.async(execute: {() -> Void in
                let alert = UIAlertController(title: "Login Failed", message: "Enable the notification to login.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                })
                alert.addAction(UIAlertAction(title: "Enable", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    UIApplication.shared.openURL(NSURL(string: "prefs:root=NOTIFICATIONS_ID")! as URL)
                })
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    func Login() {
        if ((password.text?.characters.count)! > 0) && ((emailAddress.text?.characters.count)! > 0){
            if((password.text?.length)! >= 6) && ((password.text?.length)! <= 20){
//                if (password.text?.isAlphanumeric)!{
                    self.view.addLoader()
                    var request = URLRequest(url: URL(string: ServerAPIs.discovery_login)!)
                    request.httpMethod = "POST"
                    
                    let params = ["email": emailAddress.text! as AnyObject,
                                  "password": password.text! as AnyObject,
                                  "loginType": "general" as AnyObject,
                                  "deviceType": "ios" as AnyObject,
                                  "deviceId": defaults.string(forKey: "devicetoken") as AnyObject
                        ] as Dictionary<String, AnyObject>
                    print("params",params)
                    
                    let loginString = NSString(format: "%@:%@", emailAddress.text!, password.text!)
                    let loginData: Data = loginString.data(using: String.Encoding.utf8.rawValue)!
                    let base64LoginString = loginData.base64EncodedString(options: [])
                    
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                    request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
                                if (json["response"] as! Bool) == true {
                                    let data = json["responseString"] as! [String: Any]
                                    let myevents = json["myevents"] as! [Any]
                                    print(myevents)
                                    self.previousEventCount = myevents.count
                                    DispatchQueue.main.async(execute: {() -> Void in
                                        UserDefaults.standard.setValue(data, forKeyPath: "userlogindata")
                                        UserDefaults.standard.set(self.emailAddress.text!, forKey: "discovery_email")
                                        UserDefaults.standard.set(self.password.text!, forKey: "discovery_password")
                                        UserDefaults.standard.set(false, forKey: "didloginfromsocial")
                                        for singleevnt in myevents{
                                            let event = singleevnt as! [String: Any]
                                            self.downloadSingleEvents(id: event["appid"]! as! String, url: event["app_url"]! as! String, obj: event, info_privacy: event["info_privacy"] as! Bool, passwordres: event["private_key"] as! String)
                                        }
                                        if self.previousEventCount == 0{
                                            self.view.removeLoader()
                                            let alert = UIAlertController(title: "SUCCESS", message: "Login Successfull" , preferredStyle: UIAlertControllerStyle.alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                                UIAlertAction in
                                                let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
                                                print("data1[userType] =",data1["userType"]!, "data1[userId] =",data1["userId"]!, "data1[tokenExpirationUtc] =",data1["tokenExpirationUtc"]!, "data1[token] =",data1["token"]!, "data1[username] =",data1["username"]!)
                                                 self.navigationController?.popViewController(animated: true)
                                                NotificationCenter.default.post(name: Notification.Name("cometohome"), object: nil)
                                           //     self.dismiss(animated: true, completion: nil)
                                            })
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                    })
                                }else{
                                    DispatchQueue.main.async(execute: {() -> Void in
                                        self.view.removeLoader()
                                        let alert = UIAlertController(title: "Request Failed", message: json["responseString"] as! String? , preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                            UIAlertAction in
                                            //                                self.dismiss(animated: true, completion: nil)
                                        })
                                        self.present(alert, animated: true, completion: nil)
                                    })
                                }
                            }catch {
                                DispatchQueue.main.async(execute: {() -> Void in
                                    self.view.removeLoader()
                                    let alert = UIAlertController(title: "Request Failed", message: "Try Again." , preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                        UIAlertAction in
                                        
                                    })
                                    self.present(alert, animated: true, completion: nil)
                                })
                            }
                        }else{
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.removeLoader()
                                let alert = UIAlertController(title: "Request Failed", message: "Try Again." , preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    
                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        }
                    }
                    task.resume()
//                }else{
//                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
//                        DispatchQueue.main.async(execute: {() -> Void in
//                            UIAlertView(title: "Invalid Password",message: "Password should not contain any special character",delegate: nil,cancelButtonTitle: "OK").show()
//
//                        })
//                    })
//                }
            }else{
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        UIAlertView(title: "Invalid Password",message: "Password should contain atleast 6 character and less than 20 character",delegate: nil,cancelButtonTitle: "OK").show()

                    })
                })
            }
        }else{
            if ((emailAddress.text?.characters.count)! > 0){
                DispatchQueue.main.async(execute: {() -> Void in
                    let alert = UIAlertController(title: "Enter Password", message: "Password is empty" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        self.password.becomeFirstResponder()
                    })
                    self.present(alert, animated: true, completion: nil)
                })
            }else{
                DispatchQueue.main.async(execute: {() -> Void in
                    let alert = UIAlertController(title: "Enter email", message: "email is empty" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        self.emailAddress.becomeFirstResponder()
                    })
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
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
                                let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
                                print("data1[userType] =",data1["userType"]!, "data1[userId] =",data1["userId"]!, "data1[tokenExpirationUtc] =",data1["tokenExpirationUtc"]!, "data1[token] =",data1["token"]!, "data1[username] =",data1["username"]!)
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
