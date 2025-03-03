//
//  SwiftfulMapAppApp.swift
//  SwiftfulMapApp
//
//  Created by Nick Sarno on 11/27/21.
//

import SwiftUI
import CoreLocation
import MapKit
import FirebaseFirestoreInternal

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
        // instance of location manager and last KnownLocation
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    private var manager = CLLocationManager()
    
    
    func checkLocationAuthorization() {
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
            case .notDetermined://The user choose allow or denny your app to get the location yet
                manager.requestWhenInUseAuthorization()
                
            case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
                print("Location restricted")
                
            case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode
                print("Location denied")
                
            case .authorizedAlways://This authorization allows you to use all location services and receive location events whether or not your app is in use.
                print("Location authorizedAlways")
                
            case .authorizedWhenInUse://This authorization allows you to use all location services and receive location events only when your app is in use
                print("Location authorized when in use")
                lastKnownLocation = manager.location?.coordinate
            
        @unknown default:
            print("Location service disabled")
        
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}



struct SwiftfulMapAppApp: View {
    
    @StateObject private var locationManager = LocationManager()
    
    @StateObject private var vm = LocationsViewModel()
    
    var body: some View {
        VStack{
//            Button(action: {
////                vm.storePin(coord: GeoPoint(latitude: vm.mapRegion.center.latitude, longitude: vm.mapRegion.center.longitude))
//            }) {
//                Text("Save event")
//                    .frame(minWidth: 0, maxWidth: 100)
//                    .font(.system(size: 18))
//                    .padding()
//                    .foregroundColor(.black)
//            }
//            .background(Color.pink)
//            .border(Color.black, width: 2)
//            .cornerRadius(25)
            LocationsView()
                .environmentObject(vm)
        }
        .frame(height: 600)
        .onAppear(perform: {
            locationManager.checkLocationAuthorization()
            vm.userLocation = locationManager.lastKnownLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: -117.189537)
        })
    }
}
