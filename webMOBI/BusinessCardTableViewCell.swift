//
//  BusinessCardTableViewCell.swift
//  webMOBI
//
//  Created by webmobi on 27/02/18.
//  Copyright © 2018 Webmobi. All rights reserved.
//

import UIKit

class BusinessCardTableViewCell: UITableViewCell {

    @IBOutlet weak var biuserdesc: UILabel!
    @IBOutlet weak var biusername: UILabel!
    @IBOutlet weak var biuserinfo: UIView!
    @IBOutlet weak var biuserpro: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
