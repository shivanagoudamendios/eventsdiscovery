//
//  NotificationTableViewCell.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/28/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import FontAwesome_swift
class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rightArrowImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let themeclr = UserDefaults.standard.string(forKey: "themeColor")
        rightArrowImg.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-arrow-circle-o-right")!, textColor: UIColor(hex:themeclr!), size: CGSize(width: 30, height: 30))
        timeLabel.textColor = UIColor(hex:themeclr!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
