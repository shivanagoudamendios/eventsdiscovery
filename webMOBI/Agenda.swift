//
//  Agenda.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/1/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class Agenda: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var type : String? = ""
    var checkvalue : String? = ""
    var iconCls : String? = ""
    var title : String? = ""
    var caption  : String? = ""
    var agenda : [AgendaInAgenda]? = [AgendaInAgenda]()
    var survey  : String? = ""
    
    
    
    required init?(map: Map) {
        
    }
    
    init(type: String,checkvalue: String, iconCls: String, title: String, caption: String,agenda: [AgendaInAgenda], survey: String) {
        self.type = type
        self.checkvalue = checkvalue
        self.iconCls = iconCls
        self.title = title
        self.caption = caption
        self.agenda = agenda
        self.survey = survey
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let type = aDecoder.decodeObject(forKey: "type"),
            let checkvalue = aDecoder.decodeObject(forKey: "checkvalue"),
            let iconCls = aDecoder.decodeObject(forKey: "iconCls"),
            let title = aDecoder.decodeObject(forKey: "title"),
            let caption = aDecoder.decodeObject(forKey: "caption"),
            let agenda = aDecoder.decodeObject(forKey: "agenda"),
            let survey = aDecoder.decodeObject(forKey: "survey")
            else{
                return nil
        }
        self.init(type: type as! String,checkvalue: checkvalue as! String, iconCls: iconCls as! String, title: title as! String, caption: caption as! String,agenda: agenda as! [AgendaInAgenda], survey: survey as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(type,     forKey: "type")
        aCoder.encode(checkvalue,     forKey: "checkvalue")
        aCoder.encode(iconCls, forKey: "iconCls")
        aCoder.encode(title,    forKey: "title")
        aCoder.encode(caption,     forKey: "caption")
        aCoder.encode(agenda, forKey: "agenda")
        aCoder.encode(survey, forKey: "items")
    }
    
    
    
    // Mappable
    func mapping(map: Map) {
        type <- map["type"]
        checkvalue <- map["checkvalue"]
        iconCls <- map["iconCls"]
        title <- map["title"]
        caption <- map["caption"]
        agenda <- map["agenda"]
        survey <- map["survey"]
    }
}
