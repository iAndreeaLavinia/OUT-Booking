//
//  LocationsMapViewController.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit
import MapKit

class LocationsMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    private enum AnnotationReuseID: String {
        case pin
    }
    
    var mapItems: [MKMapItem]?
    var boundingRegion: MKCoordinateRegion?
    
    var locationManager: LocationManager = LocationManager()
    var viewModel: LocationsMapViewModel = LocationsMapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizeMapView()
        
        if viewModel.Locations.levelsList.count == 0 {
            viewModel.Locations.getDataFromAPI { [weak self] (suceeded) in
                self?.refreshDataOnMap()
            }
        } else {
            refreshDataOnMap()
        }
    }
        
    func refreshDataOnMap() {
        // Bucharest Location
        let region = self.viewModel.centerMapOnLocation(location: mapView.userLocation.location ?? self.viewModel.initialLocation)
        mapView.setRegion(region, animated: true)
        addAnnotationsOnTheMap()
        addResultedAnnotationsOnTheMap()
        self.setUpMapView()
    }
    
    func setUpMapView() {
       mapView.showsUserLocation = true
       mapView.showsCompass = true
       mapView.showsScale = true
       locationManager.currentLocation()
       locationManager.delegate = self
    }
    
    func customizeMapView() {
        if let region = boundingRegion {
            mapView.region = region
        }
        mapView.delegate = self
        
        // Show the compass button in the navigation bar.
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        mapView.showsCompass = true // Use the compass in the navigation bar instead.
        mapView.showsUserLocation = true
        // Make sure `MKPinAnnotationView` and the reuse identifier is recognized in this map view.
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationReuseID.pin.rawValue)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func addAnnotationsOnTheMap() {
        var annotations: [LocationAnnotation] = [LocationAnnotation]()
        for locationModel in viewModel.Locations.levelsList {
            let locationAnnotation = LocationAnnotation(location: locationModel)
            annotations.append(locationAnnotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func addResultedAnnotationsOnTheMap() {
        guard let mapItems = mapItems else {
            return
        }
        if mapItems.count == 1, let item = mapItems.first {
          title = item.name
        } else {
          title = NSLocalizedString("TITLE_ALL_PLACES", comment: "All Places view controller title")
        }

        // Turn the array of MKMapItem objects into an annotation with a title and URL that can be shown on the map.
        let annotations = mapItems.compactMap { (mapItem) -> PlaceAnnotation? in
          guard let coordinate = mapItem.placemark.location?.coordinate else { return nil }
          
          let annotation = PlaceAnnotation(coordinate: coordinate)
          annotation.title = mapItem.name
          annotation.url = mapItem.url
          
          return annotation
        }
        mapView.addAnnotations(annotations)
    }

}

extension LocationsMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? PlaceAnnotation {
            // Annotation views should be dequeued from a reuse queue to be efficent.
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationReuseID.pin.rawValue, for: annotation) as? MKMarkerAnnotationView
            view?.canShowCallout = true
            view?.clusteringIdentifier = "searchResult"
            
            // If the annotation has a URL, add an extra Info button to the annotation so users can open the URL.
            if annotation.url != nil {
                let infoButton = UIButton(type: .detailDisclosure)
                view?.rightCalloutAccessoryView = infoButton
            }
            
            return view
        }
                
        if let annotation = annotation as? LocationAnnotation {
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
        return nil

  }
}

extension LocationsMapViewController: LocationManagerDelegate {
    func displayLocationServicesDeniedAlert() {
        let message = NSLocalizedString("LOCATION_SERVICES_DENIED", comment: "Location services are denied")
        let alertController = UIAlertController(title: NSLocalizedString("LOCATION_SERVICES_ALERT_TITLE", comment: "Location services alert title"),
                                                message: message,
                                                preferredStyle: .alert)
        let settingsButtonTitle = NSLocalizedString("BUTTON_SETTINGS", comment: "Settings alert button")
        let openSettingsAction = UIAlertAction(title: settingsButtonTitle, style: .default) { (_) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                // Take the user to the Settings app to change permissions.
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        
        let cancelButtonTitle = NSLocalizedString("BUTTON_CANCEL", comment: "Location denied cancel button")
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(openSettingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayLocationServicesDisabledAlert() {
        let message = NSLocalizedString("LOCATION_SERVICES_DISABLED", comment: "Location services are disabled")
        let alertController = UIAlertController(title: NSLocalizedString("LOCATION_SERVICES_ALERT_TITLE", comment: "Location services alert title"),
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("BUTTON_OK", comment: "OK alert button"), style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func didSetPlaces() {
        
    }
    
    func shouldDisplayError(error: Error?) {
        if let error = error as NSError?, let errorString = error.userInfo[NSLocalizedDescriptionKey] as? String {
            let alertController = UIAlertController(title: "Could not find any places.", message: errorString, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func locationDidUpdate(region: MKCoordinateRegion, placemark: CLPlacemark?) {
        // TO DO:
        //Check locally if a placemark is a public place, category: supermarket, hypermarket, hospital, shop
        // send the location to the server from 5 to 5 minutes
    }
}
