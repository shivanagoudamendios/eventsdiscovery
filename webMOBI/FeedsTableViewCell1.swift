//
//  FeedsTableViewCell1.swift
//  FractalAnalytics
//
//  Created by webmobi on 1/3/18.
//  Copyright © 2018 webmobi. All rights reserved.
//

import UIKit

class FeedsTableViewCell1: UITableViewCell {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postDescriptionTextView: UITextView!
    @IBOutlet weak var likeButton1: UIButton!
    @IBOutlet weak var likeButton2: UIButton!
    @IBOutlet weak var commentButton1: UIButton!
    @IBOutlet weak var commentButton2: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
