//
//  OpenHourlyWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Macbook Air 13 on 09.09.2020.
//  Copyright © 2020 Macbook Air 13. All rights reserved.
//

import UIKit

class OpenHourlyWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hourlyLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  var hourlyWeather: HourlyWeather! {
        didSet{
            hourlyLabel.text = hourlyWeather.hour
            weatherIcon.image = UIImage(systemName: hourlyWeather.hourlyIcon)
            tempLabel.text = "\(hourlyWeather.hourlyTemp)"
        }
    }

}
