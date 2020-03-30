//
//  LocationsMapViewModel.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit
import MapKit

class LocationsMapViewModel {
    
    let Locations: LocationViewModel = LocationViewModel()
    
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation(latitude: 44.4435153, longitude: 26.0335983)
    
    func centerMapOnLocation(location: CLLocation) -> MKCoordinateRegion {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
      return coordinateRegion
    }
}
