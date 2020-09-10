//
//  Extension.swift
//  WeatherApp
//
//  Created by Macbook Air 13 on 10.09.2020.
//  Copyright © 2020 Macbook Air 13. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func alertButton(title: String, massage: String){
        let alertController = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true , completion: nil )
    }
}


