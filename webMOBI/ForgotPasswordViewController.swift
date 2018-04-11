//
//  ForgotPasswordViewController.swift
//  webMOBI
//
//  Created by webmobi on 5/29/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var resetemail: UITextField!
    @IBOutlet weak var submitbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetemail.delegate = self
        resetemail.textColor = UIColor.white
        resetemail.setBottomBorder()
        resetemail.placeholder = "Enter Registered Email"
        
        submitbutton.layer.masksToBounds = true
        submitbutton.layer.borderWidth = 2
        submitbutton.layer.borderColor = UIColor.white.cgColor
        submitbutton.layer.cornerRadius = 15

    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromRight
//        self.view.layer.add(transition, forKey: kCATransition)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromLeft
//        self.view.layer.add(transition, forKey: kCATransition)
    }

    override func viewDidAppear(_ animated: Bool) {
        resetemail.becomeFirstResponder()
    }
    
    @IBAction func close(_ sender: UIButton) {
        resetemail.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        forgotPassword()
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

extension ForgotPasswordViewController{

    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func forgotPassword() {
        
        if isValidEmail(testStr: resetemail.text!){
            
            var request = URLRequest(url: URL(string: ServerAPIs.forgot_password)!)
            request.httpMethod = "POST"
            
            let params = ["email": resetemail.text! as AnyObject
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
                                    self.dismiss(animated: false, completion:{
                                        
                                    })
                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        }else{
                            DispatchQueue.main.async(execute: {() -> Void in
                                let alert = UIAlertController(title: "OOPS...!", message: json["responseString"] as! String? , preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    self.dismiss(animated: false, completion: nil)
                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        }
                    }catch {
                        
                    }
                }
            }
            task.resume()
        }else{
            DispatchQueue.main.async(execute: {() -> Void in
                let alert = UIAlertController(title: "Invalid email!", message: "Enter the valid email" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.resetemail.becomeFirstResponder()
                })
                self.present(alert, animated: true, completion: nil)
            })
        }
    }

}
