//
//  StringExtension.swift
//  SlideMenuControllerSwift
//
//   Created by Webmobi on 2016/04/06.
//  Copyright (c) 2016 Webmobi. All rights reserved.
//

import Foundation

extension String {
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: self.index(startIndex, offsetBy: from))  //substringFrom(self.startIndex.advancedBy(from))
    }
    
    var length: Int {
        return self.characters.count
    }
    
    var parseJSONString: [AnyObject] {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [AnyObject] {
                    return jsonResult
                }
            } catch  {
                return []
            }

        } else {
            // Lossless conversion of the string was not possible
            return []
        }
        return []
    }
    
}
