//
//  MappingData.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 7/18/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

public class MappingData{
    
    
    func Fetchdata(index:Int,dataobj:[AnyObject]) ->AnyObject
    {
        
        if(dataobj.count > index)
        {
            return dataobj[index]
        }else
        {
            return [] as AnyObject
        }
        
    }
    
    
}
