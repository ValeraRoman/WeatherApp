//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by Macbook Air 13 on 09.09.2020.
//  Copyright © 2020 Macbook Air 13. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    //@IBOutlet 
    
    @IBOutlet weak var imageSummery: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var summery: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    
    var dailyWeather: DailyWeather! {
        didSet{
            imageSummery.image = UIImage(systemName: dailyWeather.dailyIcon)
            dayLabel.text = dailyWeather.dailyWeekday
            maxTemp.text = "\(dailyWeather.dailyHigh)°"
            minTemp.text = "\(dailyWeather.dailyLow)°"
            summery.text = dailyWeather.dailySummary
               }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
