//
//  GalleryCollectionViewCell.swift
//  ArtGallery
//
//  Created by Andreea Lavinia Ionescu on 06/02/2020.
//  Copyright © 2020 Orange Labs Romania. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCollectionCell(for galleryModel: GalleryModel) {
        titleLabel.text = galleryModel.name
        backgroundImageView.image = UIImage(named: galleryModel.imageName)
    }
    
}
