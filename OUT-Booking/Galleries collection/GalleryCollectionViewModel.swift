//
//  GalleryCollectionViewModel.swift
//  ArtGallery
//
//  Created by Andreea Lavinia Ionescu on 06/02/2020.
//  Copyright © 2020 Orange Labs Romania. All rights reserved.
//

import UIKit

enum GalleryCollectionType {
    case Full
    case Half
}

class GalleryCollectionViewModel: GalleryViewModel {
    
    var cellType: GalleryCollectionType = .Full

}
