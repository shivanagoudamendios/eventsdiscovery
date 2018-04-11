//
//  VideoViewController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/15/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import MBProgressHUD

class VideoViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet var VideoWebpage: UIWebView!
    let defaults = UserDefaults.standard
    var hud = MBProgressHUD()
    var videoUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        VideoWebpage.delegate = self
        
        super.viewWillAppear(animated)
        if(videoUrl.isEmpty == false)
        {
                hud = MBProgressHUD.showAdded(to: self.VideoWebpage, animated: true)
                hud.labelText = "Loading Page..."
                hud.minSize = CGSize(width: 150, height: 100)
        
                let url = NSURL(string: videoUrl.addingPercentEscapes(using: .utf8)!)!
                
                let requestObj = NSURLRequest(url: url as URL)
                self.VideoWebpage.loadRequest(requestObj as URLRequest)
                
        }
        
        
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        hud.hide(true, afterDelay: 0)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: Error?) {
        
        hud.hide(true, afterDelay: 0)
    }
    
    
}
