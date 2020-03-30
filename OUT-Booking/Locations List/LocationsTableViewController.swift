//
//  LocationsTableViewController.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit
import MapKit

class LocationsTableViewController: UITableViewController {
    
    private enum SegueID: String {
        case showDetail
        case showAll
    }
    
    private var places: [MKMapItem]? {
        didSet {
            tableView.reloadData()
            viewAllButton.isEnabled = places != nil
        }
    }
    private var suggestionController: SuggestionsTableViewController!
    private var searchController: UISearchController!
    @IBOutlet private var viewAllButton: UIBarButtonItem!
    
    var viewModel: LocationViewModel = LocationViewModel()
    private let locationManager = CLLocationManager()
    private var currentPlacemark: CLPlacemark?
    private var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    private var foregroundRestorationObserver: NSObjectProtocol?
    
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locationManager.delegate = self
        
        suggestionController = SuggestionsTableViewController(style: .grouped)
        suggestionController.tableView.delegate = self

        searchController = UISearchController(searchResultsController: suggestionController)
        searchController.searchResultsUpdater = suggestionController
        
        let name = UIApplication.willEnterForegroundNotification
        foregroundRestorationObserver = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: { [unowned self] (_) in
            // Get a new location when returning from Settings to enable location services.
            self.requestLocation()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigation()
        if viewModel.levelsList.count == 0 {
            viewModel.getDataFromAPI { (suceeded) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func customizeNavigation() {
       // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController
        
        // Keep the search bar visible at all times.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.delegate = self
        
        /*
         Search is presenting a view controller, and needs the presentation context to be defined by a controller in the
         presented view controller hierarchy.
         */
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestLocation()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
        locationManager.delegate = self
    }
    
    
    // MARK: - Actions
    
    @IBAction func showAllAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: SegueID.showAll.rawValue, sender: nil)
    }
    
    
    /// - Parameter suggestedCompletion: A search completion provided by `MKLocalSearchCompleter` when tapping on a search completion table row
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }
    
    /// - Parameter queryString: A search string from the text the user entered into `UISearchBar`
    private func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = queryString
        search(using: searchRequest)
    }
    
    /// - Tag: SearchRequest
    private func search(using searchRequest: MKLocalSearch.Request) {
        // Confine the map search area to an area around the user's current location.
        searchRequest.region = boundingRegion
        
        // Include only point of interest results. This excludes results based on address matches.
        searchRequest.resultTypes = .pointOfInterest
        
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [unowned self] (response, error) in
            guard error == nil else {
                self.displaySearchError(error)
                return
            }
            
            self.places = response?.mapItems
            
            // Used when setting the map's region in `prepareForSegue`.
            if let updatedRegion = response?.boundingRegion {
                self.boundingRegion = updatedRegion
            }
        }
    }
    
    private func displaySearchError(_ error: Error?) {
        if let error = error as NSError?, let errorString = error.userInfo[NSLocalizedDescriptionKey] as? String {
            let alertController = UIAlertController(title: "Could not find any places.", message: errorString, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
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
        let cell: LocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell

        if let mapItem = places?[indexPath.row] {
            cell.configureCell(forPlacemark: mapItem)
        } else {
            // TO DO
            guard indexPath.row < viewModel.levelsList.count else {
                return UITableViewCell()
            }
            let location = viewModel.levelsList[indexPath.row]
            // Configure the cell...
            cell.configureCell(for: location)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == suggestionController.tableView {
            if let suggestionsList = suggestionController.completerResults,
                suggestionsList.count < indexPath.row {
            let suggestion = suggestionsList[indexPath.row]
            searchController.isActive = false
            searchController.searchBar.text = suggestion.title
                search(for: suggestion)
                performSegue(withIdentifier: SegueID.showDetail.rawValue, sender: nil)
            }

        } else {
            let detailsViewController = storyboard?.instantiateViewController(identifier: "LocationDetailsViewController") as! LocationDetailsViewController
            guard indexPath.row < viewModel.levelsList.count else {
                return
            }
            let location = viewModel.levelsList[indexPath.row]
            detailsViewController.locationInfo = location
            present(detailsViewController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapViewController = segue.destination as? LocationsMapViewController else {
            return
        }
        
        if segue.identifier == SegueID.showDetail.rawValue {
            // Get the single item.
            guard let selectedItemPath = tableView.indexPathForSelectedRow,
                let mapItem = places?[selectedItemPath.row] else {
                    return
            }
            
            // Pass the new bounding region to the map destination view controller and center it on the single placemark.
            var region = boundingRegion
            region.center = mapItem.placemark.coordinate
            mapViewController.boundingRegion = region
            
            // Pass the individual place to our map destination view controller.
            mapViewController.mapItems = [mapItem]
        } else if segue.identifier == SegueID.showAll.rawValue {
            
            // Pass the new bounding region to the map destination view controller.
            mapViewController.boundingRegion = boundingRegion
            
            // Pass the list of places found to our map destination view controller.
            mapViewController.mapItems = places
        }
    }
}

extension LocationsTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // The user tapped search on the `UISearchBar` or on the keyboard. Since they didn't
        // select a row with a suggested completion, run the search with the query text in the search field.
        search(for: searchBar.text)
    }
}


extension LocationsTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       guard let location = locations.last else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            guard error == nil else { return }
            
            self.currentPlacemark = placemark?.first
            self.boundingRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 12_000, longitudinalMeters: 12_000)
            self.suggestionController.updatePlacemark(self.currentPlacemark, boundingRegion: self.boundingRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle any errors returned from Location Services.
    }
}
