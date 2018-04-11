//
//  CheckNewUpdate.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 7/26/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
public class CheckNewUpdate{
    
    
    func checkupdate(appURL:String,appID:String,VC:UIViewController,version:Int)
    {
        
              
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
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehomehudNotification"), object: nil)
                    })
                })

                
            }else
            {
                
                do {
                    let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    
                    if((jsonResult["response"] as? Bool) != false)
                    {
                        let updateversion = jsonResult["responseString"] as? Int
                        if(updateversion == version)
                        {
                           print("its upto date")
                            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehomehudNotification"), object: nil)
                                })
                            })

                        }
                        else
                        {
                            
                            let alertCtrl = UIAlertController(title: "Update available", message: "You want to Update Event", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "Update", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                
                               self.singleEvent(appURL: appURL)
                                
                               
                            }
                            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                                UIAlertAction in
                                NSLog("Cancel Pressed")
                                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                                    DispatchQueue.main.async(execute: {() -> Void in
                                        
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehomehudNotification"), object: nil)
                                    })
                                })

                            }
                            
                            // Add the actions
                            alertCtrl.addAction(okAction)
                            alertCtrl.addAction(cancelAction)
                           
                            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    VC.present(alertCtrl, animated: true, completion: nil)
                                })
                            })
                            
                        }
                    }else
                    {
                        print("error")
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in

                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehomehudNotification"), object: nil)
                            })
                        })

                    }
                    
                    
                }catch
                {
                    print(error)
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehomehudNotification"), object: nil)
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
        
        let urlStr : NSString = urlPath.addingPercentEscapes(using: .utf8)! as NSString
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehomehudNotification"), object: nil)
                        UIAlertView(title: "Request Failed",message: "Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                       
                    })
                })
                
            }else
            {
                
                do {
                    let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    
                    let appid = jsonResult["appId"] as? String
                    
                    let jsonFile = FileSaveHelper(fileName:appid!, fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
                    
                    //3
                    do {
                        
                        try jsonFile.saveFile(dataForJson: jsonResult)
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "eventupdateNotification"), object: nil)
                            })
                        })
                    }
                    catch {
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehomehudNotification"), object: nil)
                                UIAlertView(title: "Download Failed",message: "Check the Connection Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                            })
                        })
                    }
                    
                    
                    
                }catch
                {
                    print(error)
                    
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            
                             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidehomehudNotification"), object: nil)
                            
                            UIAlertView(title: "Request Failed",message: "Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                            
                        })
                    })
                    
                }
            }
            
            }
        )
        
        
        
    }
    
    
}
