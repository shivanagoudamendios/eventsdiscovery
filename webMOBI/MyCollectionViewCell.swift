//
//  MyCollectionViewCell.swift
//  DynamicCollectionViewCellWithAutoLayout-Demo
//
//  Created by Honghao Zhang on 2014-09-26.
//  Copyright (c) 2014 HonghaoZ. All rights reserved.
//

import UIKit

// Check System Version
let isIOS7: Bool = !isIOS8
let isIOS8: Bool = floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var lastupdated: UILabel!
    
    let kLabelVerticalInsets: CGFloat = 8.0
    let kLabelHorizontalInsets: CGFloat = 8.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.layer.masksToBounds = true
        backgroundview.backgroundColor = getRandomColor()
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(randomInt(firstNum: 0.5, secondNum:1.0))
        let green:CGFloat = CGFloat(randomInt(firstNum: 0.5, secondNum:1.0))
        let blue:CGFloat = CGFloat(randomInt(firstNum: 0.5, secondNum:1.0))
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func randomInt(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    // In layoutSubViews, need set preferredMaxLayoutWidth for multiple lines label
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configCell(_ title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes
    {
        let attr: UICollectionViewLayoutAttributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        
        var newFrame = attr.frame
        self.frame = newFrame
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let desiredHeight: CGFloat = self.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        newFrame.size.height = desiredHeight
        attr.frame = newFrame
        return attr
    }
}
