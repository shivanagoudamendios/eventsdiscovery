//
//  TimerCollectionViewCell.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 9/24/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit

class TimerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    
    var startDate :Int64 = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        daysLabel.layer.cornerRadius = 5
        daysLabel.clipsToBounds = true
        hoursLabel.layer.cornerRadius = 5
        hoursLabel.clipsToBounds = true
        minLabel.layer.cornerRadius = 5
        minLabel.clipsToBounds = true
        secLabel.layer.cornerRadius = 5
        secLabel.clipsToBounds = true
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TimerCollectionViewCell.countdown), userInfo: nil, repeats: true)
    }
    func changecolor(color:String)
    {
        daysLabel.backgroundColor = UIColor(hex:color )
        hoursLabel.backgroundColor = UIColor(hex:color )
        minLabel.backgroundColor = UIColor(hex:color )
        secLabel.backgroundColor = UIColor(hex:color )
    }
    
    func timer(StartDate:Int64) {
        
        if(StartDate > 0)
        {
            startDate = StartDate
            
        }
        
        
    }
    func countdown() {
        
        let presentdate = Int64(NSDate().timeIntervalSince1970*1000)
        
        if(startDate > presentdate)
        {
            let differencetime = startDate - presentdate
            let days  = Int64(differencetime / 86400000)
            let Hours = Int64(((differencetime / 1000) - (days * 86400)) / 3600)
            let Minutes = Int64 (((differencetime / 1000) - ((days * 86400) + (Hours * 3600))) / 60)
            let Seconds = (differencetime/1000)%60
            
            daysLabel.text = days.description
            hoursLabel.text = Hours.description
            minLabel.text = Minutes.description
            secLabel.text = Seconds.description
        }else
        {
            daysLabel.text = "0"
            hoursLabel.text = "0"
            minLabel.text = "0"
            secLabel.text = "0"
            
        }
        
    }
    
}
