//
//  SettingsViewController.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = stackView.bounds.size
        getAuthorization()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        performSegue(withIdentifier: "unwindToLoginViewController", sender: nil)
    }
    
    func getAuthorization() {
          let center = UNUserNotificationCenter.current()
          center.requestAuthorization(options:[.alert, .sound, .badge]) {  granted, error in
              
              if let _ = error {
                  // Handle the error here.
              }
          }
      }
    
    @IBAction func didChangeHealthyAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Healthy status changed",
                                                message: "Whenever you are not feeling good, please remain inside and avoid contact with other people. If the symptoms getting worse, please ask for Medical Help.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(dismiss)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didChangeNotificationsSwitch(_ sender: Any) {
         let alertController = UIAlertController(title: "Notifications set",
                                                 message: "Whenever your GPS location will dramatically change or the altitude of your device get low the application will send you a notification to remind you the healthy advices for traveling in public places.", preferredStyle: .alert)
         let dismiss = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
         alertController.addAction(dismiss)
         present(alertController, animated: true, completion: nil)
    }
    
    func getAllNotifications() {
          UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
              print(notifications)
          }
      }
    
    // TO DO: set user notification to remember when he/she must go to the store - present maps directions
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

extension SettingsViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
