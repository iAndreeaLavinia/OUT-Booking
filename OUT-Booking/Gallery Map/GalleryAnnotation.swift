//
//  GalleryAnnotation.swift
//  ArtGallery
//
//  Created by Andreea Lavinia Ionescu on 13/02/2020.
//  Copyright © 2020 Orange Labs Romania. All rights reserved.
//

import UIKit
import MapKit

class GalleryAnnotation: NSObject, MKAnnotation {
    
    var title: String? {
        return gallery.name
    }
    
    var subtitle: String? {
        return gallery.information
    }
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: gallery.latitude, longitude: gallery.longitude)
    }
    
    let gallery: GalleryModel
      
    init(gallery: GalleryModel) {
        self.gallery = gallery
        super.init()
    }  
}
