//
//  TableViewExtension.swift
//  SlideMenuControllerSwift
//
//   Created by Webmobi on 2016/04/06.
//  Copyright (c) 2016 Webmobi. All rights reserved.
//
import UIKit

public extension UITableView {
    
    func registerCellClass(cellClass: AnyClass) {
        let identifier = String.className(aClass: cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(cellClass: AnyClass) {
        let identifier = String.className(aClass: cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(viewClass: AnyClass) {
        let identifier = String.className(aClass: viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(viewClass: AnyClass) {
        let identifier = String.className(aClass: viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
