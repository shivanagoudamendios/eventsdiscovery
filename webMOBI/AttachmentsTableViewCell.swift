//
//  AttachmentsTableViewCell.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/27/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit

class AttachmentsTableViewCell: UITableViewCell {

    @IBOutlet weak var attachTypeImg: UIImageView!
    @IBOutlet weak var AttachmentTitle: UILabel!
    @IBOutlet weak var downloadAttachmentImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
