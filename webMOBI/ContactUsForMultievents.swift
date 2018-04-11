//
//  ContactUsForMultievents.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 10/3/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import MBProgressHUD
class ContactUsForMultievents: UIViewController,UITextFieldDelegate,UIPickerViewDelegate {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var selectQuestionField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var mobileNoField: UITextField!
    @IBOutlet weak var emailIdField: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    var attendeePickerView = UIPickerView()
    var names : [String] = ["Get app support","Get webMOBI app for my event"]
    var dataAtIndex : Int = 0
    var hud = MBProgressHUD()
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        
        self.title = "ContactUs"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        if(defaults.bool(forKey: "frommultievent"))
        {
            self.navigationController?.navigationBar.barTintColor = UIColor(hex: "edf0f4")
            self.navigationController?.navigationBar.tintColor = UIColor(hex: "2a2a2a")
        }else
        {
            if let themeclr = defaults.string(forKey: "themeColor"){
                self.navigationController?.navigationBar.isTranslucent = true
                self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
                self.navigationController?.navigationBar.tintColor = UIColor.white
            }
        }
        
        SubmitButton.layer.cornerRadius = 5
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(ContactUsForMultievents.keyboardOnScreen), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        center.addObserver(self, selector: #selector(ContactUsForMultievents.keyboardOffScreen), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        firstNameField.delegate = self
        selectQuestionField.delegate = self
        lastNameField.delegate = self
        mobileNoField.delegate = self
        emailIdField.delegate = self
        
        attendeePickerView.delegate = self
        attendeePickerView.layer.backgroundColor = UIColor.white.cgColor
        attendeePickerView.tag = 0
        
        
        selectQuestionField.inputView = attendeePickerView
        attendeeTypePicker(picker: attendeePickerView)
       
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            let toolbarDone = UIToolbar.init()
            toolbarDone.sizeToFit()
            let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                                  target: self, action: #selector(ContactUsForMultievents.doneButton_Clicked))
            
            toolbarDone.items = [barBtnDone] // You can even add cancel button too
            mobileNoField.inputAccessoryView = toolbarDone
            
        }
        
      
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItemForHome()
    }
    
    func doneButton_Clicked(textField: UITextField)
    {
        mobileNoField.resignFirstResponder()
        emailIdField.becomeFirstResponder()
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if(textField == emailIdField )
        {
            if(isValidEmail(testStr: emailIdField.text!))
            {
                let nextTag: Int = textField.tag + 1
                
                let nextResponder: UIResponder? = textField.superview?.superview?.viewWithTag(nextTag)
                
                if let nextR = nextResponder
                {
                    // Found next responder, so set it.
                    nextR.becomeFirstResponder()
                }
                else
                {
                    // Not found, so remove keyboard.
                    textField.resignFirstResponder()
                }
                
            }else
            {
                emailIdField.becomeFirstResponder()
                UIAlertView(title: "Invalid Email Format",message: "Check the Email and Try Again",delegate: nil,cancelButtonTitle: "OK").show()
            }
        }else
        {
            let nextTag: Int = textField.tag + 1
            
            let nextResponder: UIResponder? = textField.superview?.superview?.viewWithTag(nextTag)
            
            if let nextR = nextResponder
            {
                // Found next responder, so set it.
                nextR.becomeFirstResponder()
            }
            else
            {
                // Not found, so remove keyboard.
                textField.resignFirstResponder()
            }
            
        }
        
        
        return false
    }
    
    
    func keyboardOnScreen(notification: NSNotification){
        
        let info: NSDictionary  = notification.userInfo! as NSDictionary
        
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject).cgRectValue.size
        
        let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        
        scrollview.contentInset = contentInsets
        
        scrollview.scrollIndicatorInsets = contentInsets
        
        var aRect: CGRect = self.view.frame
        
        aRect.size.height -= kbSize.height
        
        
    }
    
    
    
    
    
    func keyboardOffScreen(notification: NSNotification){
        
        let contentInsets:UIEdgeInsets = UIEdgeInsets.zero
        
        scrollview.contentInset = contentInsets
        
        scrollview.scrollIndicatorInsets = contentInsets
        
        
    }
    
    func attendeeTypePicker(picker : UIPickerView){
        let toolBar = UIToolbar()
        toolBar.barStyle = .black
        toolBar.isTranslucent = true
        toolBar.backgroundColor = UIColor.white
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        // Adds the buttons
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ContactUsForMultievents.attendeedoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ContactUsForMultievents.attendeecancelClick))
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //Create the view
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        inputView.layer.backgroundColor = UIColor.clear.cgColor
        attendeePickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240)
        inputView.addSubview(attendeePickerView)
        selectQuestionField.inputView = inputView
        selectQuestionField.inputAccessoryView = toolBar
    }
    func attendeedoneClick(){
        selectQuestionField.text = names[attendeePickerView.selectedRow(inComponent: 0)]
        dataAtIndex = attendeePickerView.selectedRow(inComponent: 0)
        selectQuestionField.resignFirstResponder()
    }
    func attendeecancelClick(){
        selectQuestionField.resignFirstResponder()
    }
    
    //    Set number of rows in components
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(pickerView.tag == 0){
            return names.count
        }else{
            return 0
        }
        
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var res: String = ""
        if(pickerView.tag == 0){
            res = names[row]
        }
        return res
    }
    @IBAction func submitAction(sender: AnyObject) {
        
        if(isValidEmail(testStr: emailIdField.text!))
        {
            
            if(selectQuestionField.text?.length == 0)
            {
                UIAlertView(title: "Question Field Empty",message: "Please Select Question",delegate: nil,cancelButtonTitle: "OK").show()
                selectQuestionField.becomeFirstResponder()
            }else if (firstNameField.text?.length == 0)
            {
                UIAlertView(title: "FirstName Empty",message: "Please Enter FirstName",delegate: nil,cancelButtonTitle: "OK").show()
                firstNameField.becomeFirstResponder()
            }else if (lastNameField.text?.length == 0)
            {
                UIAlertView(title: "LastName Empty",message: "Please Enter LastName",delegate: nil,cancelButtonTitle: "OK").show()
                lastNameField.becomeFirstResponder()
            }else if (mobileNoField.text?.length == 0)
            {
                UIAlertView(title: "MobileNo Empty",message: "Please Enter MobileNo",delegate: nil,cancelButtonTitle: "OK").show()
                mobileNoField.becomeFirstResponder()
            }else
            {
                sendingmail()
            }
            
            
            
        }else
        {
            emailIdField.becomeFirstResponder()
            UIAlertView(title: "Invalid Email Format",message: "Check the Email and Try Again",delegate: nil,cancelButtonTitle: "OK").show()
        }
        
        
    }
    
    func sendingmail()
    {
            
            hud = MBProgressHUD.showAdded(to: self.view.window, animated: true)
            hud.labelText = "Sending Data..."
            hud.minSize = CGSize(width: 150, height: 100)
        
          let time = NSTimeZone.local.secondsFromGMT(for: NSDate() as Date)
          let timezone = secondsToHoursMinutesSeconds(seconds: time)
        
            let request = NSMutableURLRequest(url: NSURL(string:ServerApis.AppContactUsUrl )! as URL)
            request.httpMethod = "POST"
            let str = "appId=webmobi"+"&email="+emailIdField.text!+"&toEmail=support@webmobi.com"
        
            let str1 = str+"&name="+firstNameField.text!+" "+lastNameField.text!+"&timeZone="+timezone+"&entryDate="
        
            let postString = str1+NSDate().description+"&phone="+mobileNoField.text!+"&feedback="+selectQuestionField.text!
            print(postString)
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                        })
                    })
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                        })
                    })
                }
                
                do {
                    let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print("responseString = \(jsonResult) ")
                    let response = (jsonResult["response"] as? String)!
                    if(response == "success")
                    {
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                                UIAlertView(title: "success",message: "Submitted Successfully",delegate: nil,cancelButtonTitle: "OK").show()
                                
                            })
                        })
                        
                    }else
                    {
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                           DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                            })
                        })
                    }
                }catch
                {
                    print("error")
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                            
                        })
                    })
                }
                
            }
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

}
