//
//  LocationAnnotation.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    
    var title: String? {
        return location.name
    }
    
    var subtitle: String? {
        return location.information
    }
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    let location: LocationModel
      
    init(location: LocationModel) {
        self.location = location
        super.init()
    }  
}
