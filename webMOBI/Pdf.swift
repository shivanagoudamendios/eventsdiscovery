//
//  Pdf.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/18/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import Foundation
import ObjectMapper

class Pdf: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(type,     forKey: "type")
        aCoder.encode(checkvalue,     forKey: "checkvalue")
        aCoder.encode(iconCls, forKey: "iconCls")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(caption, forKey: "caption")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(pdfurl, forKey: "pdfurl")
    }

    var type : String? = ""
    var checkvalue : String? = ""
    var iconCls : String? = ""
    var title : String? = ""
    var caption  : String? = ""
    var name : String? = ""
    var pdfurl:[Pdfurl]  =  [Pdfurl]()
    
    required init?(map: Map) {
        
    }
    
    init(type: String, checkvalue: String,iconCls: String,title: String,caption: String,name: String,pdfurl: [Pdfurl]) {
        self.type = type
        self.checkvalue = checkvalue
        self.iconCls = iconCls
        self.title = title
        self.caption = caption
        self.name = name
        self.pdfurl = pdfurl
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let type = aDecoder.decodeObject(forKey: "type"),
            let checkvalue = aDecoder.decodeObject(forKey: "checkvalue"),
            let iconCls = aDecoder.decodeObject(forKey: "iconCls"),
            let title = aDecoder.decodeObject(forKey: "title"),
            let caption = aDecoder.decodeObject(forKey: "caption"),
            let name = aDecoder.decodeObject(forKey: "name"),
            let pdfurl = aDecoder.decodeObject(forKey: "pdfurl")
            else{
                return nil
        }
        self.init(type: type as! String,checkvalue: checkvalue as! String, iconCls: iconCls as! String,title: title as! String,caption: caption as! String,name: name as! String,pdfurl: pdfurl as! [Pdfurl])
    }
    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encode(type,     forKey: "type")
//        aCoder.encode(checkvalue,     forKey: "checkvalue")
//        aCoder.encode(iconCls, forKey: "iconCls")
//        aCoder.encode(title, forKey: "title")
//        aCoder.encode(caption, forKey: "caption")
//        aCoder.encode(name, forKey: "name")
//        aCoder.encode(pdfurl, forKey: "pdfurl")
//    }
    
    // Mappable
    func mapping(map: Map) {
        type <- map["type"]
        checkvalue <- map["checkvalue"]
        iconCls <- map["iconCls"]
        title <- map["title"]
        caption <- map["caption"]
        name <- map["name"]
        pdfurl <- map["pdfurl"]
    }
}

class Pdfurl: NSObject,Mappable,NSCoding {
    
    var name : String? = ""
    var details :[PdfDetails]  =  [PdfDetails]()
    
    required init?(map: Map) {
        
    }
    
    init(name: String,details: [PdfDetails]) {
        self.name = name
        self.details = details
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: "name"),
            let details = aDecoder.decodeObject(forKey: "details")
            else{
                return nil
        }
        self.init(name: name as! String,details: details as! [PdfDetails])
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name,  forKey: "name")
        aCoder.encode(details,  forKey: "details")
    }
    
    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        details <- map["details"]
    }
}

class PdfDetails: NSObject,Mappable,NSCoding {
    
    var attachment_id : String? = ""
    var attachment_type : String? = ""
    var attachment_name : String? = ""
    var attachment_category : String? = ""
    var attachment_url : String? = ""
    
    required init?(map: Map) {
        
    }
    
    init(attachment_id: String,attachment_type: String,attachment_name: String,attachment_category: String,attachment_url: String) {
        self.attachment_id = attachment_id
        self.attachment_type = attachment_type
        self.attachment_name = attachment_name
        self.attachment_category = attachment_category
        self.attachment_url = attachment_url
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let attachment_id = aDecoder.decodeObject(forKey: "attachment_id"),
            let attachment_type = aDecoder.decodeObject(forKey: "attachment_type"),
            let attachment_name = aDecoder.decodeObject(forKey: "attachment_name"),
            let attachment_category = aDecoder.decodeObject(forKey: "attachment_category"),
            let attachment_url = aDecoder.decodeObject(forKey: "attachment_url")
            else{
                return nil
        }
        self.init(attachment_id: attachment_id as! String,attachment_type: attachment_type as! String,attachment_name: attachment_name as! String,attachment_category: attachment_category as! String,attachment_url: attachment_url as! String)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(attachment_id,  forKey: "attachment_id")
        aCoder.encode(attachment_type,  forKey: "attachment_type")
        aCoder.encode(attachment_name,  forKey: "attachment_name")
        aCoder.encode(attachment_category,  forKey: "attachment_category")
        aCoder.encode(attachment_url,  forKey: "attachment_url")
    }
    
    // Mappable
    func mapping(map: Map) {
        attachment_id <- map["attachment_id"]
        attachment_type <- map["attachment_type"]
        attachment_name <- map["attachment_name"]
        attachment_category <- map["attachment_category"]
        attachment_url <- map["attachment_url"]
    }
}

