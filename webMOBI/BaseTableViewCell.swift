//
//  BaseTableViewCell.swift
//  SlideMenuControllerSwift
//
//   Created by Webmobi on 2016/04/06.
//  Copyright (c) 2016 Webmobi. All rights reserved.
//
import UIKit
import FontAwesome_swift 
public class BaseTableViewCell : UITableViewCell {
    class var identifier: String { return String.className(aClass: self) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public override func awakeFromNib() {
    }
    
    public func setup() {
    }
    
    public class func height() -> CGFloat {
        return 48
    }
    
    public func setData(data: Any?) {
        self.backgroundColor = UINavigationController().navigationBar.barTintColor
//        self.textLabel?.font = UIFont.italicSystemFontOfSize(18)
        self.textLabel?.textColor = UIColor.white
        if let menuText = data as? String {
            self.textLabel?.text = menuText
            
            let fullNameArr = menuText.components(separatedBy: " ")
            
            self.imageView?.image = UIImage(named: fullNameArr[0])
            if(self.imageView?.image == nil)
            {
            self.imageView?.image = UIImage(named: menuText.trimmingCharacters(in: NSCharacterSet.whitespaces))
            }
        }
        
    }
    
    public func setImg(data: Any?) {
        self.backgroundColor = UINavigationController().navigationBar.barTintColor
        //        self.textLabel?.font = UIFont.italicSystemFontOfSize(18)
        self.textLabel?.textColor = UIColor.white
        if let menuText = data as? String {
            
            let iconname = "fa-"+menuText
           
            self.imageView?.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode(iconname)!, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
                        
            //            if(self.imageView?.image == nil)
            //            {
            //                self.imageView?.image = UIImage(named: menuText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
            //            }
        }
        
    }

    
    
    
    
    override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }
    
    // ignore the default handling
    override public func setSelected(_ selected: Bool, animated: Bool) {
        
    }
  
}
