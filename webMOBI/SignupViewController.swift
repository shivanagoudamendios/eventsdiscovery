//
//  SignupViewController.swift
//  webMOBI
//
//  Created by webmobi on 5/17/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var Container02: UIView!
    @IBOutlet weak var Container01: UIView!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.Container02.alpha = 0
        nextButton.backgroundColor = UIColor.white
        nextButton.layer.cornerRadius = 25
        let origImage = UIImage(named: "Loginicon")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        nextButton.setImage(tintedImage, for: .normal)
        nextButton.tintColor = UIColor(red: 30/255, green: 112/255, blue: 145/255, alpha: 1)

    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion:{
            NotificationCenter.default.post(name: Notification.Name("cometoroot"), object: nil)
        })
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if Container01.alpha == 1 {
            let vc = childViewControllers.first as! CreateAccountViewController
            if ((vc.firstname.text?.characters.count)! > 0) && ((vc.lastname.text?.characters.count)! > 0) && ((vc.mobilenumber.text?.characters.count)! > 0) && ((vc.emailid.text?.characters.count)! > 0) && isValidEmail(testStr: vc.emailid.text!){
                self.Container01.fadeOut()
                self.Container02.fadeIn()
            }else{
                if isValidEmail(testStr: vc.emailid.text!){
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "Request Failed", message: "Insufficient Data", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                }else{
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "Invalid email", message: "Enter valid email", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                }
                
            }
        }else{
            let vc = childViewControllers.last as! EnterPasswordViewController
            if ((vc.passwordtextfield.text?.characters.count)! > 0){
                if ((vc.passwordtextfield.text?.characters.count)! > 8){
                    Signup()
                }else{
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "Request Failed", message: "Password must be longer than 8 characters", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }else{
                DispatchQueue.main.async(execute: {() -> Void in
                    let alert = UIAlertController(title: "Empty password", message: "Enter the password!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                    })
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}

extension SignupViewController{
    
    func Signup() {
        
        var request = URLRequest(url: URL(string: ServerAPIs.discovery_signup)!)
        request.httpMethod = "POST"
        let vc1 = childViewControllers.first as! CreateAccountViewController
        let vc2 = childViewControllers.last as! EnterPasswordViewController
        let params = ["firstname": vc1.firstname.text! as AnyObject,
                      "lastname": vc1.lastname.text! as AnyObject,
                      "email": vc1.emailid.text! as AnyObject,
                      "password": vc2.passwordtextfield.text! as AnyObject,
                      "mobile": vc1.mobilenumber.text! as AnyObject,
                      "loginType": "general" as AnyObject,
                      "timezone": "Asia/Kolkata" as AnyObject,
                      "userType": "registered" as AnyObject,
                      "appType": "discovery" as AnyObject
                      ] as Dictionary<String, AnyObject>
        print("params",params)
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
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
                        DispatchQueue.main.async(execute: {() -> Void in
                            let alert = UIAlertController(title: "SUCCESS", message: json["responseString"] as! String? , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                self.dismiss(animated: true, completion:{
                                    NotificationCenter.default.post(name: Notification.Name("cometoroot"), object: nil)
                                })
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    }else{
                        DispatchQueue.main.async(execute: {() -> Void in
                            let alert = UIAlertController(title: "OOPS...!", message: json["responseString"] as! String? , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
                }catch {
                    
                }
            }
        }
        task.resume()
    }
    
}
