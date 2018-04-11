//
//  MessageBoxTableViewCell.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/5/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit

class MessageBoxTableViewCell: UITableViewCell {

    @IBOutlet weak var feedbackTextView: UITextView!
     var delegate: CustomCellUpdater?
    override func awakeFromNib() {
        super.awakeFromNib()
        feedbackTextView.layer.borderWidth = 1.0
        feedbackTextView.layer.borderColor = UIColor.gray.cgColor
        feedbackTextView.layer.cornerRadius = 5
        self.selectionStyle = .none
        
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self, action: #selector(self.doneButton_Clicked))
        
        toolbarDone.items = [barBtnDone] // You can even add cancel button too
        feedbackTextView.inputAccessoryView = toolbarDone
        
    }
    
    func doneButton_Clicked(sender : UIButton){
        
        self.feedbackTextView.resignFirstResponder()
        delegate?.updateTableView(msg: self.feedbackTextView.text)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
