//
//  AttendeesTableViewCell.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/20/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit

class AttendeesTableViewCell: UITableViewCell {

    @IBOutlet weak var firstCharLabel: UILabel!
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        ImgView.layer.cornerRadius = 25
        ImgView.clipsToBounds = true
        ImgView.layer.borderColor = UIColor.gray.cgColor
        ImgView.layer.borderWidth = 0.5
        
        firstCharLabel.layer.cornerRadius = 25
        firstCharLabel.clipsToBounds = true
        firstCharLabel.layer.borderColor = UIColor.gray.cgColor
        firstCharLabel.layer.borderWidth = 0.5
        firstCharLabel.backgroundColor = getRandomColor()
        self.selectionStyle = .none
    }
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(randomInt(firstNum: 0.5, secondNum:1.0))
        let green:CGFloat = CGFloat(randomInt(firstNum: 0.5, secondNum:1.0))
        let blue:CGFloat = CGFloat(randomInt(firstNum: 0.5, secondNum:1.0))
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func randomInt(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
