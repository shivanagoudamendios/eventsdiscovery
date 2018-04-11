//
//  PollingTableViewCell.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 9/26/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit

class PollingTableViewCell: UITableViewCell {

    @IBOutlet weak var pollingName: UILabel!
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
