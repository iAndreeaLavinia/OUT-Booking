//
//  ViewController.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.labelTopConstraint.constant = UIScreen.main.bounds.height / 2.0
        customizeClearNavigation()
        titleLabel.text = "OUT Booking"
        animateTitle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func customizeClearNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func animateTitle() {
        
        self.labelTopConstraint.constant = 0

        UIView.animate(withDuration: 2.0,
                       animations: {
                        self.contentView.layoutSubviews()
        }) { (_) in
            self.goToLogin()
        }
    }
    
    func goToLogin() {
        DispatchQueue.main.async {
            let controller = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false) {
            }
        }
    }
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToMainViewController",
            let vc: LoginViewController = segue.source as? LoginViewController,
            vc.shouldLogin == true {
            self.goToHomeScreen()
        }
        if segue.identifier == "unwindToLoginViewController" {
            self.goToLogin()
        }
    }
    
    func goToHomeScreen() {
        DispatchQueue.main.async {
            let controller = self.storyboard?.instantiateViewController(identifier: "MainTabBarController") as! UITabBarController
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false) {
            }
        }
    }

}



