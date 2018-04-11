//
//  SponsersTableViewCell.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/21/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import FontAwesome_swift
class SponsersTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setcolorforcategory( color : String,category : String)
    {
        let attachment = NSTextAttachment()
        attachment.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-circle")!, textColor: UIColor(hex:color), size: CGSize(width: 15, height: 15))
        let offsetY: CGFloat = -2.0
        attachment.bounds = CGRect(x: CGFloat(0), y: offsetY, width: CGFloat((attachment.image?.size.width)!), height: CGFloat((attachment.image?.size.height)!))
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: "")
        myString.append(attachmentString)
        let myString1 = NSMutableAttributedString(string: " "+category)
        myString.append(myString1)
        categoryLabel.attributedText = myString
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
