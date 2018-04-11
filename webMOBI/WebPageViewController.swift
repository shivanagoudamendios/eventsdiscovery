//
//  WebPageViewController.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 7/12/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import MBProgressHUD

class WebPageViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet var webpageView: UIWebView!
    
    let defaults = UserDefaults.standard;
    
    var hud = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webpageView.delegate = self
        hud = MBProgressHUD.showAdded(to: self.webpageView, animated: true)
        hud.labelText = "Loading Page..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        let urlString = defaults.value(forKey: "weburls") as? String
        let url = NSURL(string: urlString!.addingPercentEscapes(using: .utf8)!)!
        //        UIApplication.sharedApplication().openURL(url!)
        let requestObj = NSURLRequest(url: url as URL)
        self.webpageView.loadRequest(requestObj as URLRequest)
        
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        hud.hide(true, afterDelay: 0)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        hud.hide(true, afterDelay: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
