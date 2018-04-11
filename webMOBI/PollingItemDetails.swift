//
//  PollingItemDetails.swift
//  WebmobiEvents
//
//  Created by webmobi on 9/26/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class PollingItemDetails: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var question : String? = ""
    var ans1 : String? = ""
    var ans2 : String? = ""
    var ans3 : String? = ""
    var ans4 : String? = ""
    var ans5 : String? = ""
    var ans6 : String? = ""
    var ans7 : String? = ""
    var ans8 : String? = ""
    var ans9 : String? = ""
    var ans10 : String? = ""
    var detail : String? = ""
    var type : String? = ""
    
    required init?(map: Map) {
        
    }
    
    init(question: String, ans1: String,ans2: String,ans3: String,ans4: String,ans5: String,ans6: String,ans7: String,ans8: String,ans9: String,ans10: String, detail: String,type: String) {
        self.question = question
        self.ans1 = ans1
        self.ans2 = ans2
        self.ans3 = ans3
        self.ans4 = ans4
        self.ans5 = ans5
        self.ans6 = ans6
        self.ans7 = ans7
        self.ans8 = ans8
        self.ans9 = ans9
        self.ans10 = ans10
        self.detail = detail
        self.type = type
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let question = aDecoder.decodeObject(forKey: "question"),
            let ans1 = aDecoder.decodeObject(forKey: "ans1"),
            let ans2 = aDecoder.decodeObject(forKey: "ans2"),
            let ans3 = aDecoder.decodeObject(forKey: "ans3"),
            let ans4 = aDecoder.decodeObject(forKey: "ans4"),
            let ans5 = aDecoder.decodeObject(forKey: "ans5"),
            let ans6 = aDecoder.decodeObject(forKey: "ans6"),
            let ans7 = aDecoder.decodeObject(forKey: "ans7"),
            let ans8 = aDecoder.decodeObject(forKey: "ans8"),
            let ans9 = aDecoder.decodeObject(forKey: "ans9"),
            let ans10 = aDecoder.decodeObject(forKey: "ans10"),
            let detail = aDecoder.decodeObject(forKey: "detail"),
            let type = aDecoder.decodeObject(forKey: "type")
            
            else{
                return nil
        }
        self.init(question: question as! String, ans1: ans1 as! String,ans2: ans2 as! String,ans3: ans3 as! String,ans4: ans4 as! String,ans5: ans5 as! String,ans6: ans6 as! String,ans7: ans7 as! String,ans8: ans8 as! String ,ans9: ans9 as! String,ans10: ans10 as! String,detail: detail as! String,type: type as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(question,     forKey: "question")
        aCoder.encode(ans1, forKey: "ans1")
        aCoder.encode(ans2, forKey: "ans2")
        aCoder.encode(ans3, forKey: "ans3")
        aCoder.encode(ans4, forKey: "ans4")
        aCoder.encode(ans5, forKey: "ans5")
        aCoder.encode(ans6, forKey: "ans6")
        aCoder.encode(ans7, forKey: "ans7")
        aCoder.encode(ans8, forKey: "ans8")
        aCoder.encode(ans9, forKey: "ans9")
        aCoder.encode(ans10, forKey: "ans10")
        aCoder.encode(detail, forKey: "detail")
        aCoder.encode(type, forKey: "type")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        question <- map["question"]
        ans1 <- map["ans1"]
        ans2 <- map["ans2"]
        ans3 <- map["ans3"]
        ans4 <- map["ans4"]
        ans5 <- map["ans5"]
        ans6 <- map["ans6"]
        ans7 <- map["ans7"]
        ans8 <- map["ans8"]
        ans9 <- map["ans9"]
        ans10 <- map["ans10"]
        detail <- map["detail"]
        type <- map["type"]
    }
    func getAns(i : Int) -> String{
        switch(i){
        case 1 : return ans1!;
        case 2 : return ans2!;
        case 3 : return ans3!;
        case 4 : return ans4!;
        case 5 : return ans5!;
        case 6 : return ans6!;
        case 7 : return ans7!;
        case 8 : return ans8!;
        case 9 : return ans9!;
        case 10 : return ans10!;
        default: return "";
        }
    }
}
