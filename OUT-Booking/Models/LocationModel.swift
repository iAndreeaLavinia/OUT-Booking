//
//  LocationModel.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 28/03/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import Foundation

class LocationModel: Codable {

    var name: String
    var level: Int
    var information: String
    var imageName: String
    var latitude: Double
    var longitude: Double
    var url: String
    var visitors: Int

    enum CodingKeys: String, CodingKey {
        case name = "location_name"
        case level
        case information
        case imageName
        case latitude
        case longitude
        case url
        case visitors
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        level = try container.decode(Int.self, forKey: .level)
        information = try container.decode(String.self, forKey: .information)
        imageName = try container.decode(String.self, forKey: .imageName)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        url = try container.decode(String.self, forKey: .url)
        visitors = try container.decode(Int.self, forKey: .visitors)
    }
        
}
