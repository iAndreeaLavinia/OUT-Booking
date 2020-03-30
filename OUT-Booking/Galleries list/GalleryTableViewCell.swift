//
//  GalleryTableViewCell.swift
//  ArtGallery
//
//  Created by Andreea Lavinia Ionescu on 29/01/2020.
//  Copyright © 2020 Orange Labs Romania. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    func configureCell(for galleryModel: GalleryModel) {
        titleLabel.text = galleryModel.name
        backgroundImageView.image = UIImage(named: galleryModel.imageName)
        descriptionTextView.text = galleryModel.information
    }
}
