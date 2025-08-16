//
//  Location.swift
//  SwiftfulMapApp
//
//  Created by Nick Sarno on 11/27/21.
//

import Foundation
#if !SKIP
    import MapKit
#endif
#if os(Android)
    import SkipFirebaseFirestore
    import SkipFirebaseCore
#else
    import FirebaseFirestoreInternal
    import FirebaseCore
#endif

#if !SKIP
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
#endif
#if SKIP                   // ← Android only
    struct Location: Identifiable, Equatable {
        var id: String
        let name: String
        
        static func == (lhs: Location, rhs: Location) -> Bool { lhs.id == rhs.id }
    }
#endif
