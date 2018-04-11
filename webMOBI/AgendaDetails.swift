//
//  AgendaDetails.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/1/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class AgendaDetails: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(location,     forKey: "location")
        aCoder.encode(activity, forKey: "activity")
        aCoder.encode(topic,     forKey: "topic")
        aCoder.encode(desc,     forKey: "desc")
        aCoder.encode(category, forKey: "category")
        aCoder.encode(speakerId, forKey: "speakerId")
        aCoder.encode(takeaway, forKey: "takeaway")
        aCoder.encode(agendaId, forKey: "agendaId")
        aCoder.encode(fromtime, forKey: "fromtime")
        aCoder.encode(totime, forKey: "totime")
        aCoder.encode(attachment_type, forKey: "attachment_type")
        aCoder.encode(attachment_name, forKey: "attachment_name")
        aCoder.encode(attachment_url, forKey: "attachment_url")
        aCoder.encode(attachment_url, forKey: "location_detail")//location_detail
    }
    
    var location : String? = ""
    var location_detail : [String: Any] = [String: Any]()
    var activity : String? = ""
    var topic : String? = ""
    var desc : String? = ""
    var category : String? = ""
    var speakerId : NSArray? = []
    var takeaway : String = ""
    var agendaId : Int? = 0
    var fromtime : Double? = 0
    var totime : Double? = 0
    var attachment_type : String? = ""
    var attachment_name : String? = ""
    var attachment_url : String? = ""
    
    required init?(map: Map) {
        
    }
    
    init(location: String, location_detail: [String: Any], activity: String, topic: String,desc: String, category: String, speakerId: NSArray,takeaway: String, agendaId: Int, fromtime : Double, totime : Double, attachment_type: String, attachment_name: String, attachment_url: String) {
        self.location = location
        self.location_detail = location_detail
        self.activity = activity
        self.topic = topic
        self.desc = desc
        self.category = category
        self.speakerId = speakerId
        self.takeaway = takeaway
        self.agendaId = agendaId
        self.fromtime = fromtime
        self.totime = totime
        self.attachment_type = attachment_type
        self.attachment_name = attachment_name
        self.attachment_url = attachment_url
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let location = aDecoder.decodeObject(forKey: "location"),
            let location_detail = aDecoder.decodeObject(forKey: "location_detail"),
            let activity = aDecoder.decodeObject(forKey: "activity"),
            let topic = aDecoder.decodeObject(forKey: "topic"),
            let desc = aDecoder.decodeObject(forKey: "desc"),
            let category = aDecoder.decodeObject(forKey: "category"),
            let speakerId = aDecoder.decodeObject(forKey: "speakerId"),
            let takeaway = aDecoder.decodeObject(forKey: "takeaway"),
            let agendaId = aDecoder.decodeObject(forKey: "agendaId"),
            let fromtime = aDecoder.decodeObject(forKey: "fromtime"),
            let totime = aDecoder.decodeObject(forKey: "totime"),
            let attachment_type = aDecoder.decodeObject(forKey: "attachment_type"),
            let attachment_name = aDecoder.decodeObject(forKey: "attachment_name"),
            let attachment_url = aDecoder.decodeObject(forKey: "attachment_url")
            
            else{
                return nil
        }
        self.init(location: location as! String, location_detail: location_detail as! [String: Any], activity: activity as! String, topic: topic as! String,desc: desc as! String, category: category as! String, speakerId: speakerId as! NSArray,takeaway: takeaway as! String, agendaId: agendaId as! Int ,fromtime: fromtime as! Double , totime: totime as! Double, attachment_type: attachment_type as! String, attachment_name: attachment_name as! String, attachment_url: attachment_url as! String)
    }
    
    //    func encodeWithCoder(aCoder: NSCoder) {
    //        aCoder.encode(location,     forKey: "location")
    //        aCoder.encode(activity, forKey: "activity")
    //        aCoder.encode(time,    forKey: "time")
    //        aCoder.encode(topic,     forKey: "topic")
    //        aCoder.encode(desc,     forKey: "desc")
    //        aCoder.encode(category, forKey: "category")
    //        aCoder.encode(speakerId, forKey: "speakerId")
    //        aCoder.encode(takeaway, forKey: "takeaway")
    //        aCoder.encode(agendaId, forKey: "agendaId")
    //        aCoder.encode(pdflink, forKey: "pdflink")
    //
    //    }
    
    
    // Mappable
    func mapping(map: Map) {
        location <- map["location"]
        location_detail <- map["location_detail"]
        activity <- map["activity"]
        topic <- map["topic"]
        desc <- map["description"]
        category <- map["category"]
        speakerId <- map["speakerId"]
        takeaway <- map["takeaway"]
        agendaId <- map["agendaId"]
        fromtime <- map["fromtime"]
        totime <- map["totime"]
        attachment_type <- map["attachment_type"]
        attachment_name <- map["attachment_name"]
        attachment_url <- map["attachment_url"]
    }
}
