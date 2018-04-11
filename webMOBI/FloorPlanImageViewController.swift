//
//  FloorPlanImageViewController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/14/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import MBProgressHUD
class FloorPlanImageViewController: UIViewController ,UIScrollViewDelegate{
    let defaults = UserDefaults.standard;
    @IBOutlet var floorImageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
     var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = MBProgressHUD.showAdded(to: self.floorImageView, animated: true)
        hud.labelText = "Loading Image..."
        hud.minSize = CGSize(width: 150, height: 100)
        let urlstring = (self.defaults.value(forKey: "floorImage") as? String!)!
        if((urlstring?.length)! > 0 )
        {
        if let url = NSURL(string: urlstring!) {
            getDataFromUrl(url: url) { (data, response, error)  in
                DispatchQueue.main.async{ () -> Void in
                    guard let data = data, error == nil else { return }
                    self.floorImageView.image = UIImage(data: data as Data)
                    self.hud.hide(true, afterDelay: 0)
                }
                if(error != nil)
                {
                     self.hud.hide(true, afterDelay: 0)
                }
            }
        }
        }else
        {
            self.hud.hide(true, afterDelay: 1)
        }
        
//        dispatch_async(dispatch_get_main_queue()) { () -> Void in
//            self.floorImageView.imageFromUrl((self.defaults.valueForKey("floorImage") as? String!)!)
//        }
        floorImageView.isUserInteractionEnabled = true
        self.scrollView.maximumZoomScale = 6.0
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.delegate = self
        self.scrollView.addSubview(floorImageView)
        
    }
    
    
    func getDataFromUrl(url:NSURL, completion: @escaping ((_ data: NSData?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            completion(data as NSData?, response, error as NSError?)
            }.resume()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return floorImageView
        
    }
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(url: url as URL)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {
                (response, data, error) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData as Data)
                }
            }
        }
    }
}
