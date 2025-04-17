//
//  LocationsViewModel.swift
//  SwiftfulMapApp
//
//  Created by Nick Sarno on 11/27/21.
//

import Foundation
import MapKit
import SwiftUI
import FirebaseFirestoreInternal
import FirebaseCore

class LocationsViewModel: ObservableObject {
    @State private var showAlert = false
    @State private var alertNum = 0
    func storePin(coord: GeoPoint) {
        let newPin = Location(
            // call function to store data
            id: UUID().uuidString, name: "event1",
            coordinates:
                coord,
            description: "5 points",
            points: 2,
            starttime: Timestamp(date: Date.now),
            endtime: Timestamp(date: Date.now),
            radius: 50)
        
        DatabaseManager.shared.storePin(location: newPin, completion: { result in
            switch result{
            case true:
                self.showAlert = true
                self.alertNum = 1
                
            case false:
                self.showAlert = true
                self.alertNum = 0
                
                print("Failed to upload event")
            }
        })
        locations.append(newPin)
    }
    
    // All loaded locations
    @Published public var locations: [Location] {
        didSet {
            self.mapLocation = locations.first!
            
            self.updateMapRegion(location: locations.first!)
        }
    }
    
    
    // Current event location on map
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    
    // Current user location on map
    @Published var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: -117.189537)
    
    // Current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    
    // Show list of locations
    @Published var showLocationsList: Bool = false
    
    // Show location detail via sheet
    @Published var sheetLocation: Location? = nil
    
    
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
//        if(!LocationsDataService.locations.isEmpty){
//
//        } else {
        if(LocationsDataService.locations.isEmpty){
            let tempLoc = Location(id: "0", name: "Loading ...", coordinates: GeoPoint(latitude: 32.957799, longitude: -117.189537), description: "Loading...", points: 0, starttime: Timestamp(), endtime: Timestamp(), radius: 10)
            self.mapLocation = tempLoc
            
            self.updateMapRegion(location: tempLoc)
        }
        else {
            self.mapLocation = locations.first!
            
            self.updateMapRegion(location: locations.first!)
        }
        
            
        
    }
    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude),
                span: mapSpan)
        }
    }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
//            showLocationsList = !showLocationsList
            showLocationsList.toggle()
        }
    }
    
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
    }
    
    func nextButtonPressed() {
        // Get the current index
        guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation }) else {
            print("Could not find current index in locations array! Should never happen.")
            return
        }
        
        // Check if the currentIndex is valid
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            // Next index is NOT valid
            // Restart from 0
            guard let firstLocation = locations.first else { return }
            showNextLocation(location: firstLocation)
            return
        }
        
        // Next index IS valid
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
    
}
