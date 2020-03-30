//
//  LocationsCollectionViewController.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LocationCollectionViewCell"

class LocationsCollectionViewController: UICollectionViewController {

    var viewModel: LocationCollectionViewModel = LocationCollectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel.levelsList.count == 0 {
            viewModel.getDataFromAPI { (suceeded) in
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        viewModel.cellType = .Half
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension LocationsCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.levelsList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? LocationCollectionViewCell
        guard let customCell = cell,
              indexPath.row < viewModel.levelsList.count else {
            return UICollectionViewCell()
        }
        // Configure the cell
        let location = viewModel.levelsList[indexPath.row]
        customCell.configureCollectionCell(for: location)
        
        return customCell
    }
}

// MARK: UICollectionViewDelegate
extension LocationsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let locationInfo: LocationModel = viewModel.levelsList[indexPath.row]
        print("Selected Location: \(locationInfo.name)")
        
        let detailsViewController = storyboard?.instantiateViewController(identifier: "LocationDetailsViewController") as! LocationDetailsViewController
        guard indexPath.row < viewModel.levelsList.count else {
           return
       }
       let location = viewModel.levelsList[indexPath.row]
       detailsViewController.locationInfo = location
       present(detailsViewController, animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension LocationsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = UIScreen.main.bounds.width
        if viewModel.cellType == .Half {
            size = (size) / 2
        }
        
        return CGSize(width: size, height: size)
    }
}
