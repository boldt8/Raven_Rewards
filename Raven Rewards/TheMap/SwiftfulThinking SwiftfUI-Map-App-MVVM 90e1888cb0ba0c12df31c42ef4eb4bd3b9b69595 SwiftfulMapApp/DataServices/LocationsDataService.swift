//
//  LocationsDataService.swift
//  MapTest
//
//  Created by Nick Sarno on 11/26/21.
//

import Foundation
import MapKit

class LocationsDataService {
    public static func fetchLocs() {
        DatabaseManager.shared.getCurrPins(completion: { result in
            switch result {
            case .success(let pinSnapshot):
                self.locations.append(contentsOf: pinSnapshot.compactMap({
                    ($0)
                }))
                
                
            case .failure:
                print("failure")
                break
            }
        })
    }
    
    static var locations: [Location] = []
}
