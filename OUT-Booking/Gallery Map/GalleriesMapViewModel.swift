//
//  GalleriesMapViewModel.swift
//  ArtGallery
//
//  Created by Andreea Lavinia Ionescu on 13/02/2020.
//  Copyright © 2020 Orange Labs Romania. All rights reserved.
//

import UIKit
import MapKit

class GalleriesMapViewModel {
    
    let galleries: GalleryViewModel = GalleryViewModel()
    
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation(latitude: 44.4268, longitude: 26.1025)
    
    func centerMapOnLocation(location: CLLocation) -> MKCoordinateRegion {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
      return coordinateRegion
    }
}
