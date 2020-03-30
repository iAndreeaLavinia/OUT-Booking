//
//  LocationViewModel.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import UIKit

class LocationViewModel {    
    
    var levelsList: [LocationModel] = [LocationModel]()
    
    func getDataFromAPI(result: @escaping (Bool) -> ()) {
        APIModel.sharedInstance.getLocations{ LocationsList, succeeded  in
            guard succeeded == true,
                let LocationsList = LocationsList else {
                
                    self.levelsList = [LocationModel]()
                result(false)
                return
            }
            
            self.levelsList = LocationsList
            result(true)
        }
    }

}
