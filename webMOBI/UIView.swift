//
//  UIView.swift
//  SlideMenuControllerSwift
//
//  Created by Webmobi on 2016/04/06.
//  Copyright (c) 2016 Webmobi. All rights reserved.
//

import UIKit

extension UIView {
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(aClass: viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
}
