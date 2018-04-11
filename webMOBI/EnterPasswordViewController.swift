//
//  EnterPasswordViewController.swift
//  webMOBI
//
//  Created by webmobi on 5/15/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit

class EnterPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var passwordtextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordtextfield.setBottomBorder()
        passwordtextfield.textColor = UIColor.white
        passwordtextfield.delegate = self
        UITextField.appearance().tintColor = UIColor.lightGray

        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(self.keyboardOnScreen(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        center.addObserver(self, selector: #selector(self.keyboardOffScreen(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordtextfield.resignFirstResponder()
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
