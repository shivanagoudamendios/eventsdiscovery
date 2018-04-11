//
//  ImageLoadingWithCache.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 6/30/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import SDWebImage

class ImageLoadingWithCache {
    
    var imageCache = [String:UIImage]()
    
    func getImage(url: String, imageView: UIImageView, defaultImage: String) {
        //        imageView.image = UIImage(named: defaultImage)
        
        imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: defaultImage)!)
        
        //        if let img = imageCache[url] {
        //             dispatch_async(dispatch_get_main_queue()) { () -> Void in
        //                imageView.image = img
        //                imageView.layer.cornerRadius = 5
        //                imageView.clipsToBounds = true
        //            }
        //        } else {
        //
        ////            getimage(url) { (result) -> Void in
        ////                if let imgValue = result {
        ////                    self.imageCache[url] = imgValue
        ////
        ////                    dispatch_async(dispatch_get_main_queue(), {
        ////                        imageView.image = imgValue
        ////                        imageView.layer.cornerRadius = 5
        ////                        imageView.clipsToBounds = true
        ////
        ////                    })
        ////                }else
        ////                {
        ////                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
        ////                        imageView.image = UIImage(named: defaultImage)
        ////                        imageView.layer.cornerRadius = 5
        ////                        imageView.clipsToBounds = true
        ////                    }
        ////
        ////                }
        ////            }
        //
        //
        
    }
    
    func getimage(url:String,completion: ((_ result:UIImage?) -> Void)!) {
        
        let request: NSURLRequest = NSURLRequest(url: NSURL(string: url.addingPercentEscapes(using: String.Encoding.utf8)!)! as URL)
        let mainQueue = OperationQueue.main
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                let image = UIImage(data: data!)
                
                DispatchQueue.main.async(execute: {
                    completion(image)
//                    completion(result: image)

                })
            }
            else {
                completion(nil)
//                completion(result: nil)
            }
        })
        
    }
    
    
}
