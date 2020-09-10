//
//  MainView.swift
//  WeatherApp
//
//  Created by Macbook Air 13 on 8/20/20.
//  Copyright © 2020 Macbook Air 13. All rights reserved.
//

import UIKit

class MainView:UIView{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.firstInit()
    }
    
    fileprivate func firstInit(){
        
        self.tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
    }
    
}

    
    
    

