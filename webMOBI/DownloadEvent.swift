//
//  DownloadEvent.swift
//  webMOBI
//
//  Created by Gnani Naidu on 7/14/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
public class DownloadEvent{
    let defaults = UserDefaults.standard
    func checkfileExist(_filename: String, completion: @escaping (_ Flag: Bool) -> ())
    {
        if(_filename.isEmpty == false)
        {
            let checkfile = FileSaveHelper(fileName: _filename, fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
            if(checkfile.fileExists)
            {
                completion(true)
            }else
            {
                completion(false)
            }
        }else
        {
            completion(false)
        }
    }
    
    func singleEvent(appID : String,appURL:String,event: Any, completion: @escaping (_ Flag: Bool) -> ())
    {
        var urlPath : String = ""
        checkfileExist(_filename: appID){ filepresent in
            if filepresent{
                let preview_flag = self.defaults.string(forKey: "preview")
                if(preview_flag == "0"){
                print("\(appID) is already present")
                completion(false)
                }
                else
                {
                    let baseUrl = "https://s3.amazonaws.com/webmobi/nativeapps/"
                    let preview_flag = self.defaults.string(forKey: "preview")
                    if(preview_flag == "1"){
                        urlPath = baseUrl + appURL + "/temp/appData.json"
                    } else {
                        urlPath = baseUrl + appURL + "/appData.json"
                    }
                    //              urlPath = baseUrl + appURL + "/appData.json"
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
                            completion(false)
                            
                        }else
                        {
                            
                            do {
                                let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                                let fileManager = FileManager.default
//                                let tempFolderPath = NSTemporaryDirectory()
//                                do {
//                                    let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
//                                    for filePath in filePaths {
//                                        if(appID == "filename")
//                                        {
//                                            try fileManager.removeItem(atPath: tempFolderPath + filePath)
//                                        }
//                                    }
//                                } catch {
//                                    print("Could not clear temp folder: \(error)")
//                                }
                                let jsonFile2 = FileSaveHelper(fileName: appID, Extension: .JSON, subDirectory: "SavingFiles",  directory: .documentDirectory)
                                let jsonFile = FileSaveHelper(fileName:appID, fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
                                
                                //3
                                do {
                                    
                                    try jsonFile.saveFile(dataForJson: jsonResult)
                                    DispatchQueue.main.async {
                                        self.addinglocally(event:event)
                                    }
                                    UserDefaults.standard.set(true, forKey: "downloadpreviewapp")
                                    completion(true)
                                }
                                catch {
                                    completion(false)
                                }
                                
                                
                                
                            }catch
                            {
                                print(error)
                                completion(false)
                                
                            }
                        }
                        
                    }
                    )
                }
            }else{
                print("\(appID) is already absent")
                let baseUrl = "https://s3.amazonaws.com/webmobi/nativeapps/"
                let preview_flag = self.defaults.string(forKey: "preview")
                if(preview_flag == "1"){
                        urlPath = baseUrl + appURL + "/temp/appData.json"
                } else {
                        urlPath = baseUrl + appURL + "/appData.json"
                  }
  //              urlPath = baseUrl + appURL + "/appData.json"
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
                        completion(false)
                        
                    }else
                    {
                        
                        do {
                            let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            
                            let jsonFile = FileSaveHelper(fileName:appID, fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
                            
                            //3
                            do {
                                
                                try jsonFile.saveFile(dataForJson: jsonResult)
                                DispatchQueue.main.async {
                                    self.addinglocally(event:event)
                                }
                                completion(true)
                            }
                            catch {
                                completion(false)
                            }
                            
                            
                            
                        }catch
                        {
                            print(error)
                            completion(false)
                            
                        }
                    }
                    
                }
                )
            }
        }
        
        
    }
    
    
    func addtofavorite(event: Any)
    {
        let favevent = Mapper<getPopularEvents>().map(JSONObject: event)
        //        let event = nearbyevents[tag].toAnyObject()
        var ns = [AnyObject]()
        let testFile1 = FileSaveHelper(fileName: "favoritefile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
        
        // 2
        do {
            let str =  try testFile1.getContentsOfFile()
            let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            
            do
            {
                let message = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers)
                if let jsonResult = message as? [AnyObject]
                {
                    for value in jsonResult{
                        let convertvalue = Mapper<getPopularEvents>().map(JSONObject: value)
                        if(convertvalue?.appid != favevent?.appid)
                        {
                            ns.append(value)
                        }
                    }
                    
                    //                    ns = jsonResult
                    
                }
                else
                {
                    print("error")
                }
            }
            catch
            {
                print("An error occurred: \(error)")
            }
            
        }catch {
            print (error)
        }
        
        ns.append(event as AnyObject)
        
        //2
        let jsonFile = FileSaveHelper(fileName:"favoritefile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
        
        //3
        do {
            try jsonFile.saveFile(dataForJson: ns as AnyObject )
            
            
        }
        catch {
            print(error)
        }
        
    }
    
    func addinglocally(event: Any)
    {
        
        //        let event = nearbyevents[tag].toAnyObject()
        var ns = [AnyObject]()
        let testFile1 = FileSaveHelper(fileName: "jsonFile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
        
        // 2
        do {
            let str =  try testFile1.getContentsOfFile()
            let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            
            do
            {
                let message = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers)
                if let jsonResult = message as? [AnyObject]
                {
                    
                    ns = jsonResult
                    
                }
                else
                {
                    print("error")
                }
            }
            catch
            {
                print("An error occurred: \(error)")
            }
            
        }catch {
            print (error)
        }
        
        ns.append(event as AnyObject)
        
        //2
        let jsonFile = FileSaveHelper(fileName:"jsonFile", fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)
        
        //3
        do {
            try jsonFile.saveFile(dataForJson: ns as AnyObject )
            
            
        }
        catch {
            print(error)
        }
        
    }
    
    
}
