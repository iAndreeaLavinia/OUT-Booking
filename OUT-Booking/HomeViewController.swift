//
//  LocationsViewController.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var screenTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var screenContainerView: UIView!
        
    private lazy var LocationsTableViewController: LocationsTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "LocationsTableViewController") as! LocationsTableViewController
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        return viewController
    }()

    private lazy var LocationsCollectionViewController: LocationsCollectionViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "LocationsCollectionViewController") as! LocationsCollectionViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    private lazy var LocationsMapViewController: LocationsMapViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "LocationsMapViewController") as! LocationsMapViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        screenTypeSegmentedControl.accessibilityIdentifier = "viewTypeSegementedControlIdentifier"
        
        screenTypeSegmentedControl.selectedSegmentIndex = 0
        add(asChildViewController: LocationsMapViewController)
    }

    @IBAction func screenTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            add(asChildViewController: LocationsMapViewController)
        case 1:
            add(asChildViewController: LocationsCollectionViewController)
        default:
            add(asChildViewController: LocationsTableViewController)
        }
        
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        for view in screenContainerView.subviews{
            view.removeFromSuperview()
        }
        
        addChild(viewController)

        // Add Child View as Subview
        screenContainerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = screenContainerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
}
