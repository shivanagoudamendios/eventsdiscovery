//
//  BusinessCardProfileTableViewCell.swift
//  webMOBI
//
//  Created by webmobi on 28/02/18.
//  Copyright © 2018 Webmobi. All rights reserved.
//

import UIKit

class BusinessCardProfileTableViewCell: UITableViewCell {

   
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
