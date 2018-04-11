//
//  FeedsCommentsTableViewCell.swift
//  FractalAnalytics
//
//  Created by webmobi on 1/5/18.
//  Copyright © 2018 webmobi. All rights reserved.
//

import UIKit

class FeedsCommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
