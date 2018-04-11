//
//  NewEventDetailTableViewCell.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/7/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit

class NewEventDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var profileimageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
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
