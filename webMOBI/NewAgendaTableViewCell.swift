//
//  NewAgendaTableViewCell.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/8/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit

class NewAgendaTableViewCell: UITableViewCell {

    @IBOutlet weak var starttime: UILabel!
    @IBOutlet weak var endtime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var title: UILabel!
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
