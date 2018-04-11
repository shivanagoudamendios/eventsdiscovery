//
//  ChangePasswordViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/29/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
//import MBProgressHUD

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var changepasswordButton: UIButton!
    @IBOutlet weak var oldpassword: UITextField!
    @IBOutlet weak var newpassword: UITextField!
    @IBOutlet weak var retypepassword: UITextField!
//    var hud = MBProgressHUD()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldpassword.delegate = self
        newpassword.delegate = self
        retypepassword.delegate = self
        oldpassword.setBottomBorder()
        newpassword.setBottomBorder()
        retypepassword.setBottomBorder()
        
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(self.keyboardOnScreen(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        center.addObserver(self, selector: #selector(self.keyboardOffScreen(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func changepasswordAction(_ sender: UIButton) {
        let count1 = oldpassword.text!.characters.count
        let count2 = newpassword.text!.characters.count
        let count3 = retypepassword.text!.characters.count
        if count1 >= 8 && count2 >= 8 && count3 >= 8 && count1 <= 20 && count2 <= 20 && count3 <= 20{
            if (oldpassword.text?.isAlphanumeric)! && (newpassword.text?.isAlphanumeric)! && (retypepassword.text?.isAlphanumeric)! {
                if ((newpassword.text!) == (retypepassword.text!)){
                    changepassword()
                }else{
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            let alert = UIAlertController(title: "Request Failed", message: "Password mismatch!!!", preferredStyle: UIAlertControllerStyle.alert)
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
                        let alert = UIAlertController(title: "Invalid Password", message: "Password should not contain any special character", preferredStyle: UIAlertControllerStyle.alert)
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
                    let alert = UIAlertController(title: "Request Failed", message: "Password should contain atleast 8 character and less than 20 character", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        
                    })
                    self.present(alert, animated: true, completion: nil)
                })
            })
        }
    }
    
    func changepassword() {
        
        self.view.addLoader()

        let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
        let userId = data1["userId"]! as! String

        let request = NSMutableURLRequest(url: NSURL(string: ServerApis.ChangepasswordUrl)! as URL)
        request.httpMethod = "POST"
        let params = ["userid": userId as AnyObject,
                      "deviceId": defaults.string(forKey: "devicetoken") as AnyObject,
                      "old_pass": oldpassword.text! as AnyObject,
                      "new_pass": newpassword.text! as AnyObject
            ] as Dictionary<String, AnyObject>
        print(params)
        let token = data1["token"]! as! String
        request.setValue(token, forHTTPHeaderField: "Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            guard error == nil && data != nil else {
                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
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
                    print(json)
                    if ((json["response"] as! Bool) == true){
                        let responseString = json["responseString"] as! String
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.removeLoader()
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
                                self.view.removeLoader()
                                let alert = UIAlertController(title: "Request Failed", message: responseString, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
//                                    self.dismiss(animated: true, completion: nil)
                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        })
                    }
                }catch {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.view.removeLoader()
                            let alert = UIAlertController(title: "Request Failed", message: "Notes not saved!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
//                                self.dismiss(animated: true, completion: nil)
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                    self.view.removeLoader()
                }
            }else{
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "Request Failed", message: "Notes not saved!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
//                            self.dismiss(animated: true, completion: nil)
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                })
                self.view.removeLoader()
            }
        })
        task.resume()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }

}
