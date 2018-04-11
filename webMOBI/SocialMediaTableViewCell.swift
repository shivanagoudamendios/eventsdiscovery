//
//  SocialMediaTableViewCell.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/25/16.

import UIKit

class SocialMediaTableViewCell: UITableViewCell {
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var lblSocialMediaTitle: UILabel!
    @IBOutlet var lblSocialMediaUrl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblSocialMediaTitle.font = UIFont(name: "Proxima Nova-Regular", size: (lblSocialMediaTitle.font?.pointSize)!)
        self.selectionStyle = .none
       // lblSocialMediaUrl.font = UIFont(name: "Proxima Nova-Thin", size: (lblSocialMediaTitle.font?.pointSize)!)
    }
    
}
