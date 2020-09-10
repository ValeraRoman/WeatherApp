//
//  extension.swift
//  WeatherApp
//
//  Created by Macbook Air 13 on 8/21/20.
//  Copyright © 2020 Macbook Air 13. All rights reserved.
//

import UIKit
import GooglePlaces



extension SearchViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
    
    let newLocation = WeatherLocation(name: place.name ?? "no name", latitude: place.coordinate.latitude , longitude: place.coordinate.longitude )
    weatherLocations.append(newLocation)
    tableView.reloadData()
    
    dismiss(animated: true, completion: nil)
    
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

}
