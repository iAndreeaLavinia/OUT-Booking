//
//  LocationTableViewCell.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit
import MapKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    func configureCell(for locationModel: LocationModel) {
        titleLabel.text = locationModel.name
        backgroundImageView.image = UIImage(named: locationModel.imageName)
        descriptionTextView.text = locationModel.information
    }
    
    func configureCell(forPlacemark mapItem: MKMapItem?) {
        titleLabel.text = mapItem?.name
        backgroundImageView.image = UIImage(named: "inside")
        descriptionTextView.text = mapItem?.placemark.formattedAddress
    }
}
