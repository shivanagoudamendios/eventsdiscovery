//
//  WeatherTableViewCell.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 5/9/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet var imgViewForType: UIImageView!
    @IBOutlet weak var tmpLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    
    
}
