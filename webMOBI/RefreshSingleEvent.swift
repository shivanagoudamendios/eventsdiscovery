//
//  RefreshSingleEvent.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 7/14/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation

public class RefreshSingleEvent{
    
    
    func refreshEvent(appURL:String,version:Int,appID:String)
    {
        
        //        self.singleEvent(appURL: appURL)
        
        let urlPath: String = ServerApis.getlatestversionUrl+appID
        //            let url: NSURL = NSURL(string: urlPath)!
        
        let url: NSURL = NSURL(string: urlPath.addingPercentEscapes(using: .utf8)!)!
        
        let request1 = NSMutableURLRequest(
            url: url as URL,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15.0)
        
        //            let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        
        NSURLConnection.sendAsynchronousRequest(request1 as URLRequest, queue: OperationQueue(), completionHandler:{
            (response, data, error)-> Void in
            
            if(error != nil)
            {
                print(error!)
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        UIAlertView(title: "Request Failed",message: "Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehudNotification"), object: nil)
                    })
                })
                
                
            }else
            {
                
                do {
                    let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    
                    if((jsonResult["response"] as? Bool) != false)
                    {
                        let updateversion = jsonResult["responseString"] as? Int
                        if(updateversion! <= version)
                        {
                            print("its upto date")
                            
                            
                            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    
                                    UIAlertView(title: "No updates available",message: "",delegate: nil,cancelButtonTitle: "OK").show()
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehudNotification"), object: nil)
                                })
                            })
                            
                        }
                        else
                        {
                            self.singleEvent(appURL: appURL)
                            
                        }
                    }else
                    {
                        print("error")
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                
                                UIAlertView(title: "Request Failed",message: "Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehudNotification"), object: nil)
                            })
                        })
                        
                    }
                    
                    
                }catch
                {
                    print(error)
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            
                            UIAlertView(title: "Request Failed",message: "Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehudNotification"), object: nil)
                        })
                    })
                    
                }
            }
            
        }
        )
    }
    
    
    func singleEvent(appURL:String)
    {
        
        let baseUrl = "https://s3.amazonaws.com/webmobi/nativeapps/"
        
        let urlPath: String = baseUrl + appURL + "/appData.json"
        
        let urlStr : String = urlPath.addingPercentEscapes(using: .utf8)!
        let url: NSURL = NSURL(string: urlStr as String)!
        let request1 = NSMutableURLRequest(
            url: url as URL,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15.0)
        
        //            let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        
        NSURLConnection.sendAsynchronousRequest(request1 as URLRequest, queue: OperationQueue(), completionHandler:{
            (response, data, error)-> Void in
            
            if(error != nil)
            {
                print(error!)
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        UIAlertView(title: "Request Failed",message: "Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                    })
                })
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehudNotification"), object: nil)
                
            }else
            {
                
                do {
                    let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print(jsonResult)
                    
                    let appid = jsonResult["appId"] as? String
                    
                    let jsonFile = FileSaveHelper(fileName:appid!, fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
                    
                    //3
                    do {
                        
                        try jsonFile.saveFile(dataForJson: jsonResult)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "eventupdateNotification"), object: nil)
                        
                    }
                    catch {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehudNotification"), object: nil)
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                UIAlertView(title: "Download Failed",message: "Check the Connection Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                            })
                        })
                    }
                    
                    
                    
                }catch
                {
                    print(error)
                    
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            UIAlertView(title: "Request Failed",message: "Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                        })
                    })
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehudNotification"), object: nil)
                    
                }
            }
            
        }
        )
        
    }
    
    
}
