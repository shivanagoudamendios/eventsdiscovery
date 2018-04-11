//
//  DateTableViewCell.swift
//  webMOBI
//
//  Created by webmobi on 5/30/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var dateimageview: UIImageView!
    @IBOutlet weak var datelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
