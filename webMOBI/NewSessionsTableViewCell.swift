//
//  NewSessionsTableViewCell.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/8/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit

class NewSessionsTableViewCell: UITableViewCell {

    @IBOutlet weak var startdate: UILabel!
    @IBOutlet weak var eventtime: UILabel!
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
