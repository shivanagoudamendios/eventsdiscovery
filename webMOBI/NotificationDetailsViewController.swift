//
//  NotificationDetailsViewController.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/28/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit

class NotificationDetailsViewController: UIViewController {
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    var notifyDetails : AnyObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let dateStr = TimeConversion().stringfrommilliseconds(ms: Double((notifyDetails?["notification_time"] as? Int64)!), format: "dd-MMM-yyyy HH:mm:ss")
        
        titleLabel.layer.cornerRadius = 5
        titleLabel.clipsToBounds = true
        titleLabel.layer.borderWidth = 0.5
        titleLabel.layer.borderColor = UIColor.lightGray.cgColor
        titleLabel.textAlignment = .center
        
        dateLabel.text = dateStr
        titleLabel.text = notifyDetails?["title"] as? String
        descTextView.text = notifyDetails?["message"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
