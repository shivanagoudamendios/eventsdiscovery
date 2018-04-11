//
//  SpeakersDataItems.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/1/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class SpeakersDataItems: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    
    var name : String? = ""
    var desc : String? = ""
    var details : String? = ""
    var image  : String? = ""
    var facebook : String? = ""
    var linkedin : String? = ""
    var speakerId : Int? = 0
    var agendaId : [AnyObject]? = [AnyObject]()
    
    
    required init?(map: Map) {
        
    }
    
    init(name: String, desc: String, details: String, image: String,facebook: String,linkedin: String,speakerId: Int, agendaId: [AnyObject]) {
        self.name = name
        self.desc = desc
        self.details = details
        self.image = image
        self.facebook = facebook
        self.linkedin = linkedin
        self.speakerId = speakerId
        self.agendaId = agendaId
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: "name"),
            let desc = aDecoder.decodeObject(forKey: "desc"),
            let details = aDecoder.decodeObject(forKey: "details"),
            let image = aDecoder.decodeObject(forKey: "image"),
            let facebook = aDecoder.decodeObject(forKey: "facebook"),
            let linkedin = aDecoder.decodeObject(forKey: "linkedin"),
            let speakerId = aDecoder.decodeObject(forKey: "speakerId"),
            let agendaId = aDecoder.decodeObject(forKey: "agendaId")
            else{
                return nil
        }
        self.init(name: name as! String, desc: desc as! String, details: details as! String, image: image as! String, facebook: facebook as! String, linkedin: linkedin as! String,speakerId: speakerId as! Int, agendaId: agendaId as! [AnyObject])
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(name,     forKey: "name")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(details,    forKey: "details")
        aCoder.encode(image,     forKey: "image")
        aCoder.encode(facebook,     forKey: "facebook")
        aCoder.encode(linkedin,     forKey: "linkedin")
        aCoder.encode(speakerId, forKey: "speakerId")
        aCoder.encode(agendaId,    forKey: "agendaId")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        desc <- map["description"]
        details <- map["details"]
        image <- map["image"]
        facebook <- map["facebook"]
        linkedin <- map["linkedin"]
        speakerId <- map["speakerId"]
        agendaId <- map["agendaId"]
    }
}
