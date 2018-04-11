//
//  NewContactUsViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/19/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import MBProgressHUD
class NewContactUsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var scrollviewinsetsheight: NSLayoutConstraint!
    @IBOutlet weak var contactphone: UILabel!
    @IBOutlet weak var contactemail: UILabel!
    @IBOutlet weak var contactphone1: UILabel!
    @IBOutlet weak var contactemail1: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var messagetextview: UITextView!
    @IBOutlet weak var sendbutton: UIButton!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var lowercontactview: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    var contactData : ContactUs!
    var hud = MBProgressHUD()
    var defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dataFromDefaults = UserDefaults.standard.object(forKey: "ContactusData") as? NSData{
            contactData = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as Data) as? ContactUs
        }
        contactphone1.text = contactData.phone
        contactemail1.text = contactData.toEmail
        messagetextview.layer.cornerRadius = 2
        messagetextview.layer.borderWidth = 0.5
        messagetextview.layer.borderColor = UIColor.lightGray.cgColor
        setShadowButton(view: contactView)
        sendbutton.titleLabel?.font = UIFont.fontAwesome(ofSize: 25)
        sendbutton.setTitle(String.fontAwesomeIcon(code: "fa-paper-plane-o"), for: .normal)
        if let themeclr = UserDefaults.standard.string(forKey: "themeColor") {
            sendbutton.backgroundColor = UIColor.init(hex: themeclr)
            sendbutton.layer.cornerRadius = 27.5
            lowercontactview.backgroundColor = UIColor.init(hex: themeclr)
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(self.keyboardOnScreen(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        center.addObserver(self, selector: #selector(self.keyboardOffScreen(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        sendbutton.addTarget(self, action: #selector(self.submitAction), for: .touchUpInside)
        
        name.delegate = self
        email.delegate = self
        phone.delegate = self
        messagetextview.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(self.donepressed))
        toolbar.setItems([flexSpace,doneButton], animated: true)
        messagetextview.inputAccessoryView = toolbar
        phone.inputAccessoryView = toolbar
        phone.keyboardType = .phonePad
    }

    override func viewDidAppear(_ animated: Bool) {
//        print(currentReachabilityStatus != .notReachable)
//        DispatchQueue.global().async {
//            DispatchQueue.main.async(execute: {
//                var helloWorldTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.sayHello), userInfo: nil, repeats: true)
//            })
//        }
    }
//    
//    func sayHello()
//    {
//        print("print check")
//    }
    
    func donepressed() {
        messagetextview.resignFirstResponder()
        phone.resignFirstResponder()
    }
    func submitAction(sender:UIButton)
    {

        if((phone.text?.trim().characters.count)! > 0 && messagetextview.text.trim().characters.count > 0)
        {
        sendRequest()
        }else
        {
            UIAlertView(title: "Required fields are empty",message:"mobile number and Message should not be empty " ,delegate: nil,cancelButtonTitle: "OK").show()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func sendRequest()
    {
        
        let AppName = self.defaults.string(forKey: "selectedAppName")
        let token = defaults.string(forKey: "token")
        
        
        self.hud.hide(true, afterDelay: 0)
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.labelText = "Processing..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        let request = NSMutableURLRequest(url: NSURL(string: ServerApis.AppContactUsUrl)! as URL)
        request.httpMethod = "POST"
        
        let params = ["appname": AppName as AnyObject,
                      "name":name.text as AnyObject,
                      "email": email.text as AnyObject,
                      "message": messagetextview.text as AnyObject,
                      "to_email": contactData.toEmail as AnyObject,
                      "phone": phone.text as AnyObject
            ] as Dictionary<String, AnyObject>
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "Token")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true, afterDelay: 0)
                        UIAlertView(title: "Request Failed",message:"The Internet connection appears to be offline" ,delegate: nil,cancelButtonTitle: "OK").show()
                        
                    })
                })
                
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true, afterDelay: 0)
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
                            UIAlertView(title: "Success",message:responseString ,delegate: nil,cancelButtonTitle: "OK").show()
                        })
                    })
                    
                }else
                {
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                            UIAlertView(title: "Request Field",message:responseString ,delegate: nil,cancelButtonTitle: "OK").show()
                            
                        })
                    })
                    
                }
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true, afterDelay: 0)
                    })
                })
                
                
            }catch
            {
                print("error")
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true, afterDelay: 0)
                        UIAlertView(title: "Request Failed",message:"Check connection and try again" ,delegate: nil,cancelButtonTitle: "OK").show()
                    })
                })
                
            }
            
        }
        task.resume()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        if(UserDefaults.standard.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
        
        name.text = self.defaults.string(forKey: "name")
        email.text = self.defaults.string(forKey: "Useremail")
        
        let emailicon = String.fontAwesomeIcon(code: "fa-envelope-o")
        contactemail.font = UIFont.fontAwesome(ofSize: 14)
        contactemail.text = emailicon! + "  Email"
        let phoneicon = String.fontAwesomeIcon(code: "fa-mobile")
        contactphone.font = UIFont.fontAwesome(ofSize: 14)
        contactphone.text = phoneicon! + "  Mobile"
        self.automaticallyAdjustsScrollViewInsets = false
        scrollviewinsetsheight.constant = (self.navigationController?.navigationBar.frame.height)! + 20
        name.setBottomBorder()
        email.setBottomBorder()
        phone.setBottomBorder()

    }
    
    func setShadowButton(view: UIView) {
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
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

