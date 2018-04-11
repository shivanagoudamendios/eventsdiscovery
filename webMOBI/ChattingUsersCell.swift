//
//  ChattingUsersCell.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 7/29/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit

class ChattingUsersCell: UITableViewCell {
    
    @IBOutlet var userImg: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet weak var userRole: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var companyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        badgeLabel.layer.cornerRadius = 12.5
        badgeLabel.clipsToBounds = true
        
        userName.font = UIFont(name: "Proxima Nova-Regular", size: 15)
        userRole.font = UIFont(name: "Proxima Nova-Regular", size: 12)
        companyName.font = UIFont(name: "Proxima Nova-Regular", size: 12)
        self.selectionStyle = .none
    }
}

