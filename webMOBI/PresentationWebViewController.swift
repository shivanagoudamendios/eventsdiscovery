//
//  PresentationWebViewController.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 6/30/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import MBProgressHUD

class PresentationWebViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet var presentationpage: UIWebView!
    
    let defaults = UserDefaults.standard;
    
    var hud = MBProgressHUD()
    
    override func viewDidLoad() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.presentationpage.scrollView.bounces = false
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
                
                self.presentationpage.loadHTMLString(aboutUsData, baseURL: nil)
            })
        }
        
    }
    func webViewDidStartLoad(webView: UIWebView) {
        
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        //        hud.hide(true, afterDelay: 0)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        //        hud.hide(true, afterDelay: 0)
    }
    
    
    
    
}
