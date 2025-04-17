//
//  LocationPreviewView.swift
//  SwiftfulMapApp
//
//  Created by Nick Sarno on 11/28/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationPreviewView: View {
    @State private var showAlert = false
    @State private var alertNum = 0
    
    @EnvironmentObject private var vm: LocationsViewModel
    let location: Location
    var userCoords: CLLocationCoordinate2D {
        return vm.userLocation
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
//                imageSection
                checkInButton
            }
            
            VStack(spacing: 8) {
                learnMoreButton
                nextButton
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y: 65)
        )
        .cornerRadius(10)
    }
}

struct LocationPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            LocationPreviewView(location: LocationsDataService.locations.first!)
                .padding()
        }
        .environmentObject(LocationsViewModel())
    }
}

extension LocationPreviewView {
    
//    private var imageSection: some View {
//        ZStack {
//            if let imageName = location.imageNames.first {
//                Image(imageName)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 100, height: 100)
//                    .cornerRadius(10)
//            }
//        }
//        .padding(6)
//        .background(Color.white)
//        .cornerRadius(10)
//    }
    private func startClock() {
        
        let name = AuthManager.shared.currUserID
        let c1 = CLLocation(latitude: location.coordinates.latitude, longitude: location.coordinates.latitude)
        let c2 = CLLocation(latitude: userCoords.latitude, longitude: userCoords.latitude)
        let distance = c1.distance(from: c2)
        DatabaseManager.shared.checkLocEvents(username: name, locID: location.name, completion: { result in
            
            if(distance > location.radius){
                self.showAlert = true
                self.alertNum = 1
            }
            else if (location.endtime.dateValue() < Date()){
                self.showAlert = true
                self.alertNum = 2
            }
            else if (location.starttime.dateValue() > Date()){
                self.showAlert = true
                self.alertNum = 3
            }
            else if (result){
                self.showAlert = true
                self.alertNum = 4
            }
            else {
                self.showAlert = true
                self.alertNum = 0
                
                DatabaseManager.shared.incrPoints(locID: location.name, isLocEvent: true, username: name, points: location.points)
                
            }
            
            
        })
        
        
        
    }
    
    private var checkInButton: some View {
        Button{
            startClock()
        } label: {
            Text("Check in")
                .font(.title2)
                .frame(width: 100, height: 35)
        }
        .buttonStyle(.borderedProminent)
        .alert(isPresented: $showAlert) {
            let c1 = CLLocation(latitude: location.coordinates.latitude, longitude: location.coordinates.latitude)
            let c2 = CLLocation(latitude: userCoords.latitude, longitude: userCoords.latitude)
            let distance = c1.distance(from: c2)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            let locDate = location.starttime.dateValue()
            let currDate = Date().convertToTimeZone(initTimeZone: TimeZone(abbreviation: "UTC") ?? TimeZone.current, timeZone: TimeZone(abbreviation: "GMT-8") ?? TimeZone.current)
            if(self.alertNum == 1){
                return Alert(title: Text("Out of bounds"), message: Text("you are \(distance) meters away from this event, you should be within \(location.radius.truncate(places: 1)) meters"))
            }
            else if(self.alertNum == 2){
                return Alert(title: Text("This event has already ended"), message: Text("You can no longer recieve points for this event, it ended at \(formatter.string(from: locDate))"))
            }
            else if(self.alertNum == 3){
                return Alert(title: Text("Please wait"), message: Text("You may recieve points later, please wait until \(formatter.string(from: locDate))"))
            }
            else if(self.alertNum == 4){
                return Alert(title: Text("Nope"), message: Text("You have already gotten points for this event"))
            }
            else {
                return Alert(title: Text("Success"), message: Text("You got \(location.points) raven points!"))
            }
            
        }
    }
    
    private var learnMoreButton: some View {
        Button {
            vm.sheetLocation = location
        } label: {
            Text("Learn more")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var nextButton: some View {
        Button {
            vm.nextButtonPressed()
        } label: {
            Text("Next")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.bordered)
    }
    
}
