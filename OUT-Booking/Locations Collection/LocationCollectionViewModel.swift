//
//  LocationsCollectionViewModel.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit

enum LocationCollectionType {
    case Full
    case Half
}

class LocationCollectionViewModel: LocationViewModel {
    
    var cellType: LocationCollectionType = .Full

}
