//
//  LeaderTableViewCell.swift
//  webMOBI
//
//  Created by webmobi on 20/03/18.
//  Copyright © 2018 Webmobi. All rights reserved.
//

import UIKit

class LeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var attendeeName: UILabel!
    @IBOutlet weak var attendeeRanking: UILabel!
    @IBOutlet weak var attendeeImage: UIImageView!
    @IBOutlet weak var attendeeNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
