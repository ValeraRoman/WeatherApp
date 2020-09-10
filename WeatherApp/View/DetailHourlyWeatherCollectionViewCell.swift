//
//  DetailHourlyWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Macbook Air 13 on 10.09.2020.
//  Copyright © 2020 Macbook Air 13. All rights reserved.
//

import UIKit

class DetailHourlyWeatherCollectionViewCell: UICollectionViewCell {
    
        @IBOutlet weak var hourlyTime: UILabel!
    @IBOutlet weak var hourlyTemperature: UILabel!
    @IBOutlet weak var hourlyImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    
     var hourlyWeather: HourlyWeather! {
        didSet{
            hourlyTime.text = hourlyWeather.hour
            hourlyTemperature.text = "\(hourlyWeather.hourlyTemp)°"
            hourlyImage.image = UIImage(systemName: hourlyWeather.hourlyIcon)
        }
        
    }
}
