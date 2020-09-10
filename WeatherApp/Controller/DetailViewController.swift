//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Macbook Air 13 on 08.09.2020.
//  Copyright © 2020 Macbook Air 13. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    let  dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d, h:mm aaa"
    return dateFormatter
}()

class DetailViewController: UIViewController {
    
// MARK: - IBOutlet
    
        @IBOutlet weak var summeryLabel: UILabel!
        @IBOutlet weak var dataLabel: UILabel!
        @IBOutlet weak var tempLabel: UILabel!
        @IBOutlet weak var cityName: UILabel!
        @IBOutlet weak var WeatherImage: UIImageView!
        @IBOutlet weak var pageControl: UIPageControl!
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var collectionView: UICollectionView!
    
// MARK: - reference
    var weatherDetail: WeatherDetail!
    var locationIndex = 0
    var locationManager:CLLocationManager!
        
       
// MARK: - lifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearUserInterface()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if locationIndex == 0 {
            getLocation()
        }
        
        updateUserInterface()
    }
    
    func clearUserInterface(){
        summeryLabel.text = ""
        dataLabel.text = ""
        tempLabel.text = ""
        cityName.text = ""
        WeatherImage.image = UIImage()
        
    }
     
    func updateUserInterface() {
            let pageVC = UIApplication.shared.windows.first!.rootViewController as! PageViewController
            let weatherLocation = pageVC.weatherLocations[locationIndex]
            weatherDetail = WeatherDetail(name: weatherLocation.name, latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
                       
            pageControl.numberOfPages = pageVC.weatherLocations.count
            pageControl.currentPage = locationIndex
            
            weatherDetail.getData {
                DispatchQueue.main.async {
                    dateFormatter.timeZone = TimeZone(identifier: self.weatherDetail.timezone)
                    let usableDate = Date(timeIntervalSince1970: self.weatherDetail.currentTime)
                    self.dataLabel.text = dateFormatter.string(from: usableDate)
                    self.cityName.text = self.weatherDetail.name
                    self.tempLabel.text = "\(self.weatherDetail.temperature)°"
                    self.summeryLabel.text = self.weatherDetail.summary
                    self.WeatherImage.image = UIImage(named: self.weatherDetail.dayIcon)
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    
                }
            }
        }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? SearchViewController{
            let pageVC = UIApplication.shared.windows.first!.rootViewController as! PageViewController
            destination.weatherLocations = pageVC.weatherLocations
            }
        }
//MARK: - IBAction
    
        @IBAction func unwindFromLocationList(segue: UIStoryboardSegue){
            let source = segue.source as! SearchViewController
            locationIndex = source.selectedLocationIndex
            
            let pageVC = UIApplication.shared.windows.first!.rootViewController as! PageViewController
            pageVC.weatherLocations = source.weatherLocations
            pageVC.setViewControllers([pageVC.createLocationDetail(forPage: locationIndex)], direction: .forward, animated: false, completion: nil)
        }
    
        @IBAction func pageControl(_ sender: UIPageControl) {
            let pageVC = UIApplication.shared.windows.first!.rootViewController as! PageViewController
            
            var direction: UIPageViewController.NavigationDirection = .forward
            if sender.currentPage < locationIndex{
                direction = .reverse
            }
            pageVC.setViewControllers([pageVC.createLocationDetail(forPage: sender.currentPage)], direction: direction, animated: true, completion: nil)
        }
    }

//MARK: - UITableViewDelegate, UITableViewDataSource

extension DetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDetail.dailyWeatherData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DailyTableViewCell
        cell.dailyWeather = weatherDetail.dailyWeatherData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherDetail.hourlyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellHourly", for: indexPath) as! DetailHourlyWeatherCollectionViewCell
            
        cell.hourlyWeather = weatherDetail.hourlyWeatherData[indexPath.row]
        return cell
    }
}

// MARK: - CLLocationManagerDelegate
extension DetailViewController: CLLocationManagerDelegate{
    
    // Get location and automatically check autothorization
    func getLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func handleStatus(status: CLAuthorizationStatus){
        switch status {
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.alertButton(title: "Cлужбу локації відхилино", massage: "Щось обмежує використання геоданих")
        case .denied:
          break
        case .authorizedAlways:
            locationManager.requestLocation()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print(status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleStatus(status: status)
    }
    
    //Deal whith change in location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last ?? CLLocation()
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation) { (placeMarks, error) in
            var locationName = ""
            if placeMarks != nil{
                let placeMark = placeMarks?.last
                locationName = placeMark?.name ?? ""
            } else {
                locationName = "Не можу знайти міцезнаходження"
            }
            let pageVC = UIApplication.shared.windows.first!.rootViewController as! PageViewController
            pageVC.weatherLocations[self.locationIndex].latitude = currentLocation.coordinate.latitude
            pageVC.weatherLocations[self.locationIndex].longitude = currentLocation.coordinate.longitude
            pageVC.weatherLocations[self.locationIndex].name = locationName
            
            self.updateUserInterface()
        }
    }
    
    
    
    //Deal whith error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}


