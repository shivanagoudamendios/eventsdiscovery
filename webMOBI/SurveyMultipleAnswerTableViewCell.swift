//
//  SurveyMultipleAnswerTableViewCell.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/5/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit

class SurveyMultipleAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedimageview: UIImageView!
    @IBOutlet weak var selectedlabel: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        selectedimageview.layer.borderColor = UIColor.gray.cgColor
//        selectedimageview.layer.borderWidth = 1
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
