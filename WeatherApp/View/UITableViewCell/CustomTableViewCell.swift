//
//  CustomTableViewCell.swift
//  WeatherApp
//
//  Created by Macbook Air 13 on 8/20/20.
//  Copyright © 2020 Macbook Air 13. All rights reserved.
//

import UIKit

class CustomTableViewCell:UITableViewCell{
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    
    
    
     var identifier: String? {
        return "CustomTableViewCell"
    }
    
}
