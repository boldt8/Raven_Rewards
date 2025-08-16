//
//  LocationsDataService.swift
//  MapTest
//
//  Created by Nick Sarno on 11/26/21.
//

import Foundation
#if !SKIP
    import MapKit
#endif

@MainActor class LocationsDataService {
    public static func fetchLocs(
        
    ) {
        DatabaseManager.shared.getCurrPins(completion: { result in
            switch result {
            case .success(let pinSnapshot):
                locations.append(contentsOf: pinSnapshot.compactMap({
                    ($0)
                }))
                
                
            case .failure:
                print("failure")
                break
            }
        })
    }
    #if !SKIP
    @MainActor static var locations: [Location] = []
    #endif
}
