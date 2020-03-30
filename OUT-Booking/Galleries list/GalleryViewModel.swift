//
//  GalleryViewModel.swift
//  ArtGallery
//
//  Created by Andreea Lavinia Ionescu on 29/01/2020.
//  Copyright © 2020 Orange Labs Romania. All rights reserved.
//

import UIKit

class GalleryViewModel {
    
    var levelsList: [GalleryModel] = [GalleryModel]()
    
    func getDataFromAPI(result: @escaping (Bool) -> ()) {
        let session: APIModel = APIModel()
        session.getGalleries{ galleriesList, succeeded  in
            guard succeeded == true,
                let galleriesList = galleriesList else {
                
                    self.levelsList = [GalleryModel]()
                result(false)
                return
            }
            
            self.levelsList = galleriesList
            result(true)
        }
    }

}
