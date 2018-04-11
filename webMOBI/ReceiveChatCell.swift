//
//  ChatCell.swift
//  SocketChat


import UIKit

class ReceiveChatCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateHeight: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeView: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 10
        msgTextView.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
