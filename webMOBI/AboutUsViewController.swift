//
//  AboutUsViewController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/9/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class AboutUsViewController : UIViewController{
    
    @IBOutlet var textViewAboutUsDescription: UITextView!
    
    let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if let themeclr = defaults.string(forKey: "themeColor"){
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }

        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
        
        if let aboutUsData = defaults.string(forKey: "aboutUsData"){
            
            DispatchQueue.main.async(execute: {() -> Void in
                
                self.textViewAboutUsDescription.attributedText = aboutUsData.html2AttributedString
                
//                self.textViewAboutUsDescription.attributedText = try! NSAttributedString(
//                    data: aboutUsData.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
//                    options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
//                    documentAttributes: nil)
            })
            
            
//            self.textViewAboutUsDescription.layer.borderColor = UIColor.black.cgColor
//            self.textViewAboutUsDescription.layer.borderWidth = 0.5
//            self.textViewAboutUsDescription.layer.cornerRadius = 5
        }
        
    }
    
}
