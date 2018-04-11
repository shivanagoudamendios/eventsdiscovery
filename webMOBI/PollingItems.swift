//
//  PollingItems.swift
//  WebmobiEvents
//
//  Created by webmobi on 9/26/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class PollingItems: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var name : String? = ""
    var poll : [SurveyItems]? = [SurveyItems]()
    
    required init?(map: Map) {
        
    }
    
    init(name: String, poll: [SurveyItems]) {
        self.name = name
        self.poll = poll
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: "name"),
            let poll = aDecoder.decodeObject(forKey: "poll")
            else{
                return nil
        }
        self.init(name: name as! String, poll: poll as! [SurveyItems])
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(name,     forKey: "name")
        aCoder.encode(poll, forKey: "poll")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        poll <- map["poll"]
    }
}

class newPollingItems: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }
    
    var name : String? = ""
    var poll : [newSurveyItems]? = [newSurveyItems]()
    
    required init?(map: Map) {
        
    }
    
    init(name: String, poll: [newSurveyItems]) {
        self.name = name
        self.poll = poll
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: "name"),
            let poll = aDecoder.decodeObject(forKey: "poll")
            else{
                return nil
        }
        self.init(name: name as! String, poll: poll as! [newSurveyItems])
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(name,     forKey: "name")
        aCoder.encode(poll, forKey: "poll")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        poll <- map["poll"]
    }
}
