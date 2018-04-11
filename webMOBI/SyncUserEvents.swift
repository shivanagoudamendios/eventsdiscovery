//
//  SyncUserEvents.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 7/7/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation

public class SyncUserEvents{
    
    let defaults = UserDefaults.standard
    
    var localeventData = [AnyObject]()
    var localdata = [AnyObject]()
    var ns = [AnyObject]()
    
    var eventscount = 0
    
    func downloadmyevents(localevents:[AnyObject],emailid:String,loginflag:Bool)
    {
        let request = NSMutableURLRequest(url: NSURL(string: ServerApis.myeventsUrl)! as URL)
        request.httpMethod = "POST"
        
        var tempJson : NSString = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: localevents, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            tempJson = string! as NSString
        }catch let error as NSError{
            print(error.description)
        }
        
        
        let postString = "email="+emailid+"&eventsList="+(tempJson as String)
        print("eventurl",postString)
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadUserEvents"), object: nil)
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        UIAlertView(title: "Sync Failed",message: "Please Check The Connection and Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                    })
                })
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode  is \(httpStatus.statusCode)")
                print("response = \(response)")
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadUserEvents"), object: nil)
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        UIAlertView(title: "Sync Failed",message: "Please Check The Connection and Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                    })
                })
            }
            
            do {
                let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print("myeventsList = \(jsonResult) ")
                let response = (jsonResult["response"] as? Bool)!
                
                if(response == true)
                {
                    let eventdata = (jsonResult["eventsList"] as? [AnyObject])!
                    self.localeventData = eventdata as [AnyObject]
                    self.eventscount =  self.localeventData.count
                    
                    if( self.eventscount == 0)
                    {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadUserEvents"), object: nil)
                    }
                    if(loginflag == true)
                    {
                        for event in  self.localeventData
                        {
                            let appurl =  (event["appUrl"] as? String)!
                            
                            self.singleEvents(appURL: appurl)
                            
                        }
                    }
                    
                }
                else{
                    let responseString = jsonResult["responseString"] as? String
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadUserEvents"), object: nil)
                    
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            UIAlertView(title: "Sync Failed",message: "\(responseString) \n Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                        })
                    })
                }
                
            }catch
            {
                print(error)
                DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        UIAlertView(title: "Sync Failed",message:"Please Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                    })
                })
                
            }
            
        }
        task.resume()
        
    }
    
    func singleEvents(appURL:String)
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
                self.eventscount -= 1
                
                if( self.eventscount == 0)
                {
                    self.addinglocally()
                }
            }else
            {
                
                do {
                    let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    let appid = jsonResult["appId"] as? String
                    
                    let jsonFile = FileSaveHelper(fileName:appid!, fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
                    
                    //3
                    do {
                        
                        try jsonFile.saveFile(dataForJson: jsonResult)
                        
                        self.eventscount -= 1
                        
                        if( self.eventscount == 0)
                        {
                            self.addinglocally()
                        }
                        
                    }
                    catch {
                        print(error)
                        self.eventscount -= 1
                        
                        if( self.eventscount == 0)
                        {
                            self.addinglocally()
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadUserEvents"), object: nil)
                        
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                UIAlertView(title: "Download Failed",message: "Check the Connection Try Again",delegate: nil,cancelButtonTitle: "OK").show()
                            })
                        })
                    }
                    
                    
                }catch
                {
                    print(error)
                    self.eventscount -= 1
                    
                    if( self.eventscount == 0)
                    {
                        self.addinglocally()
                    }
                    
                }
            }
            
            }
        )
        
        
        
    }
    
    func addinglocally()
    {
        for event in  self.localeventData
        {
            let appid = (event["appId"] as? String)!
            
            
            let checkfile = FileSaveHelper(fileName: appid, fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
            
            if(checkfile.fileExists == true)
            {
                ns.append(event)
            }
            else
            {
                print("not avail")
            }
            
        }
        //2
        let jsonFile = FileSaveHelper(fileName:"jsonFile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
        
        //3
        do {
            try jsonFile.saveFile(dataForJson: ns as AnyObject)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadUserEvents"), object: nil)
        }
        catch {
            print(error)
        }
        
    }
    
}
