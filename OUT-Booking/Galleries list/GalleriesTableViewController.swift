//
//  GalleriesTableViewController.swift
//  ArtGallery
//
//  Created by Andreea Lavinia Ionescu on 29/01/2020.
//  Copyright © 2020 Orange Labs Romania. All rights reserved.
//

import UIKit

class GalleriesTableViewController: UITableViewController {

    var viewModel: GalleryViewModel = GalleryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAuthorization()
        
        if viewModel.levelsList.count == 0 {
            viewModel.getDataFromAPI { (suceeded) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.levelsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GalleryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GalleryTableViewCell", for: indexPath) as! GalleryTableViewCell

        guard indexPath.row < viewModel.levelsList.count else {
            return UITableViewCell()
        }
        
        let gallery = viewModel.levelsList[indexPath.row]
        // Configure the cell...
        cell.configureCell(for: gallery)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsViewController = storyboard?.instantiateViewController(identifier: "GlalleryDetailsViewController") as! GlalleryDetailsViewController
        //        detailsViewController.modalPresentationStyle = .fullScreen
                present(detailsViewController, animated: true, completion: nil)
        
    }
    
    func getAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound, .badge]) {  granted, error in
            
            if let error = error {
                // Handle the error here.
            }
        }
    }
    
    func getAllNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            print(notifications)
        }
    }
  
    func addLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Staff Meeting"
        content.body = "Every Tuesday at 5pm"
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.weekday = 3  // Tuesday
        dateComponents.hour = 17    // 17:00 hours
           
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
           self.getAllNotifications()
        }

    }
    
}
