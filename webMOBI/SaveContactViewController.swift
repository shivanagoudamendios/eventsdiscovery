//
//  SaveContactViewController.swift
//  webMOBI
//
//  Created by shanmukh dm on 23/02/18.
//  Copyright © 2018 Webmobi. All rights reserved.
//

import UIKit
import MBProgressHUD


class SaveContactViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    var defaults = UserDefaults.standard
//    let appid = UserDefaults.standard.string(forKey: "selectedappid")
   
    var hud = MBProgressHUD()
    var delegate : refreshviewcontroller?
    @IBOutlet weak var scrollview: UIScrollView!
    var imagePicker: UIImagePickerController!
    @IBAction func RescanAction(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func sendAction(_ sender: Any) {
        self.view.endEditing(true)

        if (firstnametxtField.text?.count)! < 1 || (lastnametxtField.text?.count)! < 1  {
           let alertview = UIAlertController(title : "Fail", message: "Name  should not be empty", preferredStyle: .alert)
            alertview.addAction(UIAlertAction(title: "Ok", style: .default){
                UIAlertAction in
            })
            self.present(alertview, animated: true, completion: nil)

        } else {
            
            submitData()
            
        }
        
        
    }
    @IBOutlet weak var additionaltxtField: UITextField!
    @IBOutlet weak var lastnametxtField: UITextField!
    @IBOutlet weak var firstnametxtField: UITextField!
    @IBOutlet weak var cardimageheight: NSLayoutConstraint!
    @IBOutlet weak var cardImg: UIImageView!
    var cardImage:UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardImg.image = cardImage
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        additionaltxtField.delegate = self
        lastnametxtField.delegate = self
        firstnametxtField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.cardImage = image
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollview.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollview.contentInset = contentInset
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollview.contentInset = contentInset
        
    }
    func submitData(){
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.labelText = "Saving..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        let appid = self.defaults.value(forKey: "userlogindata") as! [String: Any]
        let userid = appid["userId"] as! String
        let email = defaults.string(forKey: "discovery_email")
        let filedata = ".png"
       
        self.hud.hide(true, afterDelay: 0)
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.labelText = "Saving..."
        hud.minSize = CGSize(width: 150, height: 100)
        let image = cardImage.toBase64()
        let request = NSMutableURLRequest(url: NSURL(string: ServerApis.businessCard)! as URL)
        request.httpMethod = "POST"
        let params = ["appid": appid as AnyObject,
                      "userid": userid as AnyObject,
                      "flag": "create" as AnyObject,
                      "file_name":  firstnametxtField.text! + "_" + lastnametxtField.text! + ".png" as AnyObject,
                      "contenttype": "image/png" as AnyObject,
                      "filedata" : image  as AnyObject,
//                      "contact_id" : 1 as AnyObject,
                    "email" : email as AnyObject,
                      "first_name": firstnametxtField.text as AnyObject,
                      "last_name": lastnametxtField.text as AnyObject,
                      "contact_info": additionaltxtField.text as AnyObject,
                      "item_flag":  "photo" as AnyObject
                      
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
                        if UserDefaults.standard.bool(forKey: "didsync") == false{
                            UserDefaults.standard.set(true, forKey: "didsync")
                        }
                        let alert = UIAlertController(title: "Request Failed", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            self.dismiss(animated: true, completion: nil)
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
                                self.hud.hide(true, afterDelay: 0.5)
//                                self.savenotes()
//                                self.updateCoreDataBool()
                                let alert = UIAlertController(title: "SUCCESS", message: responseString, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    self.delegate?.refreshview()
                                    self.navigationController?.popViewController(animated: true)
//                                    self.dismiss(animated: true, completion: {self.delegate?.refreshview()})
                              

                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        })
                    }else{
                        let responseString = json["responseString"] as! String
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0.5)
                                if UserDefaults.standard.bool(forKey: "didsync") == false{
                                    UserDefaults.standard.set(true, forKey: "didsync")
                                }
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
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0.5)
                            if UserDefaults.standard.bool(forKey: "didsync") == false{
                                UserDefaults.standard.set(true, forKey: "didsync")
                            }
                            let alert = UIAlertController(title: "Request Failed", message: "Notes not saved!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                    self.hud.hide(true, afterDelay: 0.5)
                }
            }else{
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true, afterDelay: 0.5)
                        if UserDefaults.standard.bool(forKey: "didsync") == false{
                            UserDefaults.standard.set(true, forKey: "didsync")
                        }
                        let alert = UIAlertController(title: "Request Failed", message: "Notes not saved!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            self.dismiss(animated: true, completion: nil)
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                })
                self.hud.hide(true, afterDelay: 0.5)
            }
        })
        task.resume()
    }
}
