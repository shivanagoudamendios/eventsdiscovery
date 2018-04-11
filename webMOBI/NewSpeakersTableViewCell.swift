//
//  NewSpeakersTableViewCell.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/21/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit

class NewSpeakersTableViewCell: UITableViewCell {

    @IBOutlet weak var speckerDescLabel: UILabel!
    @IBOutlet weak var speckerNameLabel: UILabel!
    @IBOutlet weak var speckerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        speckerImageView.layer.cornerRadius = 3
        speckerImageView.clipsToBounds = true
        speckerNameLabel.font = UIFont(name: "Proxima Nova-Regular", size: 15)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
