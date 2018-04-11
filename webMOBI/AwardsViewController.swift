//
//  AwardsViewController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/14/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import MBProgressHUD

class AwardsViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet var viewPdf: UIWebView!
    
    let defaults = UserDefaults.standard;
    var hud = MBProgressHUD()
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let themeclr = defaults.string(forKey: "themeColor"){
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        viewPdf.delegate = self
        hud = MBProgressHUD.showAdded(to: self.viewPdf, animated: true)
        hud.labelText = "Loading Page..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        
        if(urlString.length > 0)
        {
            let url = NSURL(string: urlString.addingPercentEscapes(using: .utf8)!)!
            //        UIApplication.sharedApplication().openURL(url!)
            let requestObj = NSURLRequest(url: url as URL)
            viewPdf.loadRequest(requestObj as URLRequest)
        }
        
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        hud.hide(true, afterDelay: 0)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error?) {
        
        hud.hide(true, afterDelay: 0)
    }
    
}
