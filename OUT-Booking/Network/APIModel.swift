//
//  APIModel.swift
//  OUT-Booking
//
//  Created by Andreea Lavinia Ionescu on 20/02/2020.
//  Copyright © 2020 AndreeaLavinia. All rights reserved.
//

import Foundation

typealias LocationApiListCallback = (([LocationModel]?, Bool) -> Void)

protocol LocationApiProtocol: class {
    func didGetLocations(Locations: [LocationModel]?)
}

class APIModel {

    weak var delegate: LocationApiProtocol?
    var locationsList: [LocationModel]?
    var lastSelectedLocation: LocationModel?
    
    class var sharedInstance: APIModel {
        struct Static {
            static let instance : APIModel = APIModel()
        }
        return Static.instance
    }

    func getLocations(_ onResult: @escaping LocationApiListCallback) {
        let url = URL(string: "https://getUserLocationsHistory.com")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "code": 100,
        ]

        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil || data == nil {
                print("Error!")
               // Mock data
                self.parseMockData { (locations, succeeded) in
                    onResult(locations, succeeded)
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Server error!")
                // Mock data
                self.parseMockData { (locations, succeeded) in
                    onResult(locations, succeeded)
                }
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                // Mock data
                
                self.parseMockData { (locations, succeeded) in
                    onResult(locations, succeeded)
                }
                return
            }
            //Success code
        }
        
        task.resume()
    }
    
    func parseMockData(_ onResult: @escaping LocationApiListCallback) {
        // We get data from our local mock JSON file
        guard let mockData = self.getDataFromMockJSON() else {
            onResult(nil, false)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let galeriesList = try decoder.decode([LocationModel].self, from: mockData)
            self.locationsList = galeriesList
            self.lastSelectedLocation = galeriesList.first
            
            self.delegate?.didGetLocations(Locations: galeriesList)
            onResult(galeriesList, true)
        } catch {
            print("JSON error: \(error.localizedDescription)")
            onResult(nil, false)
        }
    }
    
    func getDataFromMockJSON() -> Data? {
        guard let path = Bundle.main.path(forResource: "locations", ofType: "json") else {
            return nil
        }
        do {
          let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
      } catch {
        // handle error
        return nil
      }
    }

}


