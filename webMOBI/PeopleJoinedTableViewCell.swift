//
//  PeopleJoinedTableViewCell.swift
//  webMOBI
//
//  Created by webmobi on 5/22/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit

class PeopleJoinedTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userdetail: UILabel!
    @IBOutlet weak var profileimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
