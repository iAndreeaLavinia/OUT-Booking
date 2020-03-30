//
//  ScheduleVisitViewController.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 29/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ScheduleVisitViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    
    @IBOutlet weak var visitorsLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = stackView.bounds.size
                
        checkInButton.isHidden = false
        checkOutButton.isHidden = true
        update(with: 0)
        getAuthorization()
    }
    
    @IBAction func checkINAction(_ sender: Any) {
        checkInButton.isHidden = true
        checkOutButton.isHidden = false
        update(with: 1)
        
        let alertController = UIAlertController(title: "Thank you for Checking IN!",
                                                message: "For healthy reasons, please limit your stay if the place become crowded. If your Device Location is ON, we will automatically Check you OUT when you leave. If not, please press the Check OUT button or we will automatically Check you OUT after a while.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(dismiss)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func checkOUTAction(_ sender: Any) {
        checkInButton.isHidden = false
        checkOutButton.isHidden = true
        update(with: 0)
        let alertController = UIAlertController(title: "Thank you for Checking OUT!",
                                                message: "Using the Check IN and Check OUT options, the other users will get accurate data in real time.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(dismiss)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func notifyAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.addLocalNotification()

        }
        // TO DO call the backend and send a push notification when the shop capacity is less busy
        let alertController = UIAlertController(title: "Notification set",
                                                message: "We will notify you as soon as the place become less busy so that you can stay away from the crowded places and to keep your health stronger.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(dismiss)
        present(alertController, animated: true, completion: nil)
    }
    
    func addLocalNotification() {
        // TO DO - the backedn shoul send this kind of notifications
        
        let content = UNMutableNotificationContent()
        content.title = "Plazza Romania Mall"
        content.body = "This location is less crowded now. Please check again the current status and you are set to go."
        
        // Configure the recurring date.
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date) + 1
        
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.weekday = weekday  // Tuesday
        dateComponents.hour = hour    // 17:00 hours
        dateComponents.minute = minutes    // 17:00 hours

        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }

    }
    
    func getAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound, .badge]) {  granted, error in
            
            if let _ = error {
                // Handle the error here.
            }
        }
    }
    
    
    @IBAction func checkStatusAction(_ sender: Any) {
        update(with: 31)

        //TO DO: call the backend and ask if the number of check ins is lower than the accepted capacity within 5-15 minutes
        let alertController = UIAlertController(title: "This place is crowded now!",
                                                message: "For healthy reasons, please plan your visit later. You can check again the status anytime.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(dismiss)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func getDirectionsAction(_ sender: Any) {
        goToLocation()
    }
    
    func goToLocation() {
        guard let location = APIModel.sharedInstance.lastSelectedLocation else {
            goToABetterPlace()
            return
        }
        let query = "?ll=\(location.latitude),\(location.longitude)"
        let urlString = "http://maps.apple.com/".appending(query)
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func goToABetterPlace() {
        let geocoder = CLGeocoder()
        let locationString = "Bulevardul Timisoara 26"

        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let location = placemarks?.first?.location {
//                    let placemark = CLPlacemark(location: CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
//                             name: "Plaza Romania",
//                    postalAddress: nil)
                        
//                    let mapItem = MKMapItem(placemark: location)
//                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
//                    mapItem.openInMapsWithLaunchOptions(launchOptions)
//
                    let query = "?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
                    let urlString = "http://maps.apple.com/".appending(query)
                    if let url = URL(string: urlString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
    
    func update(with value: Int) {
        var lastSelectedLocation: LocationModel?
        if let loastSelected = APIModel.sharedInstance.lastSelectedLocation {
            lastSelectedLocation = loastSelected
        } else if let firstLocation = APIModel.sharedInstance.locationsList?.first {
            lastSelectedLocation = firstLocation
        }
        
        guard let location = lastSelectedLocation else {
            return
        }
        visitorsLabel.text = "Visitors NOW: " + String(location.visitors + value)
    }
    
}
