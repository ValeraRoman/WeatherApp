
//
//  PageViewController.swift
//  WeatherApp
//
//  Created by Macbook Air 13 on 8/22/20.
//  Copyright © 2020 Macbook Air 13. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    //MARK: - Reference
    var weatherLocations: [WeatherLocation] = []

// MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        
        loadLocation()
        setViewControllers([createLocationDetail(forPage: 0)], direction: .reverse, animated: false, completion: nil)
    }
    
    func createLocationDetail(forPage page: Int) -> DetailViewController{
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "weatherPage") as! DetailViewController
        detailVC.locationIndex = page
        return detailVC
    }
    
//MARK: - LoadLocation
    func loadLocation(){
         guard let locations = UserDefaults.standard.value(forKey: "weatherLocations")
             as? Data else {
                 print("Error: Could not")
                // Get first location
                weatherLocations.append(WeatherLocation(name: "Поточне місцезнаходження", latitude: 0.0 , longitude: 0.0 ))
                 return
         }
         let decoder = JSONDecoder()
         if let weatherLocations = try? decoder.decode(Array.self, from: locations) as [WeatherLocation]{
             self.weatherLocations = weatherLocations
             print("load")
         } else {
             print("ERROR: could no decode data")
         }
        if weatherLocations.isEmpty{
            weatherLocations.append(WeatherLocation(name: "Поточне місцезнаходження", latitude: 0.0 , longitude: 0.0))

        }
     }
}
//MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailViewController {
            if currentViewController.locationIndex > 0{
                return createLocationDetail(forPage: currentViewController.locationIndex - 1)
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailViewController {
            if currentViewController.locationIndex < weatherLocations.count - 1 {
                    return createLocationDetail(forPage: currentViewController.locationIndex + 1)
                }
            }
        return nil
    }

}
