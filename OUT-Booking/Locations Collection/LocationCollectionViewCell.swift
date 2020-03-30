//
//  locationCollectionViewCell.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCollectionCell(for locationModel: LocationModel) {
        titleLabel.text = locationModel.name
        backgroundImageView.image = UIImage(named: locationModel.imageName)
    }
    
}
