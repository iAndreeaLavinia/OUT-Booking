//
//  LocationManager.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit
import MapKit

protocol LocationManagerDelegate: class {
    func locationDidUpdate(region: MKCoordinateRegion, placemark: CLPlacemark?)
    func didSetPlaces()
    func displayLocationServicesDisabledAlert()
    func displayLocationServicesDeniedAlert()
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    weak var delegate: LocationManagerDelegate?
    
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    func currentLocation() {
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       locationManager.showsBackgroundLocationIndicator = true
       locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle any errors returned from Location Services.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       guard let location = locations.last else {
        return
       }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            guard error == nil else { return }
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 12_000, longitudinalMeters: 12_000)
            self.delegate?.locationDidUpdate(region: region, placemark: placemark?.first)
        }
    }
    
   
}

// MARK: - Location Handling

extension LocationManager {
    func requestLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            displayLocationServicesDisabledAlert()
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        guard status != .denied else {
            displayLocationServicesDeniedAlert()
            return
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func displayLocationServicesDisabledAlert() {
        delegate?.displayLocationServicesDisabledAlert()
    }
    
    func displayLocationServicesDeniedAlert() {
        delegate?.displayLocationServicesDeniedAlert()
    }
}
