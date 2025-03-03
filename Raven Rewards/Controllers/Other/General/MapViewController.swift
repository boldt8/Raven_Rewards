////
////  MapViewController.swift
////  Raven Rewards
////
////  Created by Alexander Boldt on 2/26/25.
////
//
//import SwiftUI
//import CoreLocation
//import MapKit
//import FirebaseFirestoreInternal
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
//    private let locationManager = CLLocationManager()
//        // instance of location manager
//    @Published var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 32.957799, longitude: -117.189537),
//        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//    )
//    // 32.957799, -117.189537
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        //request location permission
//        locationManager.startUpdatingLocation() // fetch location updates
//    }
//}
//
//extension MKPointAnnotation: @retroactive Identifiable{
//    public var id: UUID {
//        UUID()
//    }
//}
//
//
//struct MapViewController: View {
//    @StateObject private var locationManager = LocationManager()
//    @State private var pins:[(Location2)] = [] // call function to get data
//    private func fetchPins() {
//        DatabaseManager.shared.getCurrPins(completion: { result in
//            switch result {
//            case .success(let pinSnapshot):
//                pins.append(contentsOf: pinSnapshot.compactMap({
//                    ($0)
//                }))
//                
//                
//            case .failure:
//                print("failure")
//                break
//            }
//        })
//    }
//    @State private var showAlert = false
//    @State private var alertNum = 0
//    var body: some View {
//        
//        VStack{
//                
//             Button(action: {
//                     let newPin = Location2(
//                         // call function to store data
//                        id: UUID().uuidString, name: "event1",
//                         coordinates:
//                         GeoPoint(latitude: locationManager.region.center.latitude, longitude: locationManager.region.center.longitude),
//                         description: "5 points",
//                         points: 2,
//                         time: Date().timeIntervalSinceNow)
//                 
//                 DatabaseManager.shared.storePin(location: newPin, completion: { result in
//                     switch result{
//                         case true:
//                            showAlert = true
//                            alertNum = 1
//                         
//                         case false:
//                            showAlert = true
//                            alertNum = 0
//                        
//                         print("Failed to upload event")
//                     }
//                 })
//                         pins.append(newPin)
//                }) {
//                    Text("Save event")
//                        .frame(minWidth: 0, maxWidth: 100)
//                        .font(.system(size: 18))
//                        .padding()
//                        .foregroundColor(.black)
//                }
//                .background(Color.pink)
//                .border(Color.black, width: 2)
//                .cornerRadius(25)
//                .alert(isPresented: $showAlert){
//                    if(alertNum == 1){
//                        Alert(
//                                    title: Text("Success!"),
//                                    message: Text("We successfully saved the event")
//                        )
//                    }
//                    else {
//                        Alert(
//                                    title: Text("Failure"),
//                                    message: Text("We failed to save the event")
//                        )
//                    }
//                    
//                }
//            Map(coordinateRegion:$locationManager.region, showsUserLocation: true, annotationItems: pins, annotationContent: { pin in MapAnnotation(coordinate:  CLLocationCoordinate2D(latitude: pin.coordinates.latitude, longitude: pin.coordinates.longitude)) {
//                    // create ui for pin
//                        Text("\(pin.name)")
//                            
//                    }
//                })
//                .onAppear {
//                    fetchPins()
//                }
//                .frame(height:400)
//            
//        }
//       
//    }
//}
