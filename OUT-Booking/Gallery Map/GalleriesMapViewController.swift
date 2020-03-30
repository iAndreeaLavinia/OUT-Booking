//
//  GalleriesMapViewController.swift
//  ArtGallery
//
//  Created by Andreea Lavinia Ionescu on 13/02/2020.
//  Copyright © 2020 Orange Labs Romania. All rights reserved.
//

import UIKit
import MapKit

class GalleriesMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: LocationManager = LocationManager()
    var viewModel: GalleriesMapViewModel = GalleriesMapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if viewModel.galleries.levelsList.count == 0 {
            viewModel.galleries.getDataFromAPI { [weak self] (suceeded) in
                self?.refreshDataOnMap()
            }
        } else {
            refreshDataOnMap()
        }
    }
    
    func refreshDataOnMap() {
        // Bucharest Location
        let region = self.viewModel.centerMapOnLocation(location: self.viewModel.initialLocation)
        self.mapView.setRegion(region, animated: true)
        self.addAnnotationsOnTheMap()
        self.setUpMapView()
    }
    
    func setUpMapView() {
       mapView.showsUserLocation = true
       mapView.showsCompass = true
       mapView.showsScale = true
       locationManager.currentLocation()
       locationManager.delegate = self
    }
    
    func addAnnotationsOnTheMap() {
        var annotations: [GalleryAnnotation] = [GalleryAnnotation]()
        for galleryModel in viewModel.galleries.levelsList {
            let galleryAnnotation = GalleryAnnotation(gallery: galleryModel)
            annotations.append(galleryAnnotation)
        }
        mapView.addAnnotations(annotations)
    }

}

extension GalleriesMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? GalleryAnnotation else {
            return nil
        }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
              dequeuedView.annotation = annotation
              view = dequeuedView
        } else {
              view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
              view.canShowCallout = true
              view.calloutOffset = CGPoint(x: -5, y: 5)
              view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
  }
}

extension GalleriesMapViewController: LocationManagerDelegate {
    
    func locationDidUpdate(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
}
