//
//  Location.swift
//  SwiftfulMapApp
//
//  Created by Nick Sarno on 11/27/21.
//

import Foundation
import MapKit
import FirebaseFirestoreInternal
import FirebaseCore

struct Location: Identifiable, Equatable {
    
    var id: String 
    let name : String
    let coordinates: GeoPoint
    let description: String
    let points: Int
    let starttime: Timestamp
    let endtime: Timestamp
    let radius: Double
    
    // Identifiable
    
    
    // Equatable
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }

}
