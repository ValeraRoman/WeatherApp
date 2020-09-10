//
//  SerchControllerView.swift
//  WeatherApp
//
//  Created by Macbook Air 13 on 8/21/20.
//  Copyright © 2020 Macbook Air 13. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchViewController: UIViewController {

 //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
 //MARK: - Reference
    
    var weatherLocations:[WeatherLocation] = []
    var selectedLocationIndex = 0
    var hourlyWeather: WeatherDetail!
    
 //MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        saveLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedLocationIndex = tableView.indexPathForSelectedRow!.row
        saveLocation()
    }
    
    func saveLocation(){
          let encoder = JSONEncoder()
          if let encoded = try? encoder.encode(weatherLocations){
              UserDefaults.standard.set(encoded, forKey: "weatherLocations")
              print("save")
          } else {
              print("Error: don't save")
          }
      }
    
 //MARK: IBAction
    
    @IBAction func editButtonAction(_ sender: UIBarButtonItem) {
        if tableView.isEditing{
            tableView.setEditing(false, animated: true)
            sender.title = "Редагувати"
            addButton.isEnabled = true
        }else{
            tableView.setEditing(true, animated: true)
            sender.title = "Готово"
            addButton.isEnabled = false
        }
    }
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        //Display the autocomplete view controller.
       present(autocompleteController, animated: true, completion: nil)
        
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = weatherLocations[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            weatherLocations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let toMoveItem = weatherLocations[sourceIndexPath.row]
        weatherLocations.remove(at: sourceIndexPath.row)
        weatherLocations.insert(toMoveItem, at: destinationIndexPath.row)
    }
}
