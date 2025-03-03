//
//  Location.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 2/26/25.
//

import Foundation
import MapKit
import FirebaseFirestoreInternal

struct Location2: Codable, Identifiable {
    
    var id : String
    let name : String
    let coordinates: GeoPoint
    let description: String
    let points: Int
    let time: Double
}
