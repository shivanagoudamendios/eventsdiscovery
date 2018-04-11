//
//  QRCodeViewController.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 9/27/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import QRCode

class QRCodeViewController: UIViewController {

    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var QRCodeImg: UIImageView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Badge"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.setNavigationBarItem()
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        
        if let user = defaults.string(forKey: "name"){
        
            UserNameLabel.text = user
        }
        if let appname = defaults.string(forKey: "selectedAppName"){
            
            eventTitleLabel.text = appname
        }
        if let userid = defaults.string(forKey: "EvntUserId"){
            
            let qrCode = QRCode(userid)
            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.QRCodeImg.image = qrCode?.image
                })
            })
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}
