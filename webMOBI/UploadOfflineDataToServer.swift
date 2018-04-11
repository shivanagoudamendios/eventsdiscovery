//
//  UploadOfflineDataToServer.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/30/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class UploadOfflineDataToServer {
    let defaults = UserDefaults.standard
    
    var data = [String : AnyObject]()
    static func uploadData(){
        
        
    }
    
    func getAllNotesforserver() {
        data = [String : AnyObject]()
       var notes = [[String : AnyObject]]()
        let AgendaNote = CoreDataManager.fetchAgendaNotes()
        
        for a in AgendaNote{
            var note = [String : AnyObject]()
            note["id"] = a.notesID! as AnyObject
            note["last_updated"] = a.lastUpdated! as AnyObject
            note["name"] = a.notesName! as AnyObject
            note["notes"] = a.notesString! as AnyObject
            note["type"] = a.notesType! as AnyObject
            notes.append(note)
        }
        
        let sponsorsNote = CoreDataManager.fetchSponsorsNotes()
        for a in sponsorsNote{
            var note = [String : AnyObject]()
            note["id"] = a.notesID! as AnyObject
            note["last_updated"] = a.lastUpdated! as AnyObject
            note["name"] = a.notesName! as AnyObject
            note["notes"] = a.notesString! as AnyObject
            note["type"] = a.notesType! as AnyObject
            notes.append(note)
        }
        
        let exhibitorsNote = CoreDataManager.fetchExhibitorsNotes()
        for a in exhibitorsNote{
            var note = [String : AnyObject]()
            note["id"] = a.notesID! as AnyObject
            note["last_updated"] = a.lastUpdated! as AnyObject
            note["name"] = a.notesName! as AnyObject
            note["notes"] = a.notesString! as AnyObject
            note["type"] = a.notesType! as AnyObject
            notes.append(note)
        }
        var sync_data = [String : AnyObject]()
        sync_data["notes"] = notes as AnyObject
        sync_data["schedules"] = self.defaults.value(forKey: "schedules") as AnyObject?
        sync_data["sponsor_favorites"] = self.defaults.value(forKey: "sponsor_favorites") as AnyObject?
        sync_data["exhibitor_favorites"] = self.defaults.value(forKey: "exhibitor_favorites") as AnyObject?
        
        data["sync_data"] = sync_data as AnyObject?
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: data["sync_data"],
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
            print("json",theJSONData)
            sendToServer(syndData : theJSONText!)
        }
        
    }
    
    func sendToServer(syndData : String) {
        
        if(defaults.bool(forKey: "login"))
        {
        let appid = self.defaults.string(forKey: "selectedappid")
        let userid = defaults.string(forKey: "EvntUserId")!
        let token = defaults.string(forKey: "token")
        let request = NSMutableURLRequest(url: NSURL(string: ServerApis.syncUrl)! as URL)
        request.httpMethod = "POST"
        let params = ["userid": userid as AnyObject,
                      "appid":appid as AnyObject,
                      "sync_data": syndData as AnyObject
            ] as Dictionary<String, AnyObject>
        print(params)
        request.setValue(token, forHTTPHeaderField: "Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            guard error == nil && data != nil else {
                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in

                        
                    })
                })
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200){
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as! [String: Any]
                    print(json)
                    if ((json["response"] as! Bool) == true){
                        let responseString = json["responseString"] as! String
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                               print("Sync Success")
                                UserDefaults.standard.set(false, forKey: "didsync")
                            })
                        })
                    }else{
                        let responseString = json["responseString"] as! String
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                print("Sync Unsuccess")
                            })
                        })
                    }
                }catch {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            print("Sync Unsuccess")
                        })
                    })

                }
            }else{
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                       print("Sync Unsuccess")
                    })
                })

            }
        })
        task.resume()
        }
    }
        

}
