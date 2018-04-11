//
//  NewSocialMediaTableViewCell.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/8/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit

class NewSocialMediaTableViewCell: UITableViewCell {

    @IBOutlet weak var socialimage: UIImageView!
    @IBOutlet weak var sociallink: UILabel!
    @IBOutlet weak var socialnetwork: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
