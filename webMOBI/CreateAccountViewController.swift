//
//  CreateAccountViewController.swift
//  webMOBI
//
//  Created by webmobi on 5/15/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var mobilenumber: UITextField!
    @IBOutlet weak var emailid: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstname.setBottomBorder()
        lastname.setBottomBorder()
        mobilenumber.setBottomBorder()
        emailid.setBottomBorder()
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(self.keyboardOnScreen(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        center.addObserver(self, selector: #selector(self.keyboardOffScreen(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

        UITextField.appearance().tintColor = UIColor.lightGray
        
        firstname.textColor = UIColor.white
        lastname.textColor = UIColor.white
        mobilenumber.textColor = UIColor.white
        emailid.textColor = UIColor.white
        
        firstname.delegate = self
        lastname.delegate = self
        mobilenumber.delegate = self
        emailid.delegate = self

        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let nextbutton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.nextpressed))
        
        toolbar.setItems([flexSpace,nextbutton], animated: true)
        mobilenumber.inputAccessoryView = toolbar

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func textFieldShouldReturn(_ sender: UITextField) -> Bool {
        if let nextField = sender.superview?.viewWithTag(sender.tag + 1) as? UITextField {
            if (sender.text?.characters.count)! > 0{
                nextField.becomeFirstResponder()
            }else{
                DispatchQueue.main.async(execute: {() -> Void in
                    let alert = UIAlertController(title: "\(sender.placeholder!) is invalid", message: "\(sender.placeholder!) is empty" , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        sender.becomeFirstResponder()
                    })
                    self.present(alert, animated: true, completion: nil)
                })
            }
        } else {
            sender.resignFirstResponder()
        }
        return false
    }
    
    func nextpressed() {
        if (mobilenumber.text?.characters.count)! > 0{
            emailid.becomeFirstResponder()
        }else{
            DispatchQueue.main.async(execute: {() -> Void in
                let alert = UIAlertController(title: "\(self.mobilenumber.placeholder!) is invalid", message: "\(self.mobilenumber.placeholder!) is empty" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.mobilenumber.becomeFirstResponder()
                })
                self.present(alert, animated: true, completion: nil)
            })
        }
        emailid.becomeFirstResponder()
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
