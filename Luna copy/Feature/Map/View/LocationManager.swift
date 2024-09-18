//
//  LocationManager.swift
//  Luna
//
//  Created by Will Polich on 29/1/2022.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase


class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var region = MKCoordinateRegion()
    let manager = CLLocationManager()
    
    override init() {
        super.init()
//        if auth.currentUser != nil {
        manager.delegate = self
//        manager.allowsBackgroundLocationUpdates = true
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.requestWhenInUseAuthorization()
//        manager.requestAlwaysAuthorization()
//        manager.startUpdatingLocation()
//        }
    }
    
    func requestPermissions() {
//        manager.allowsBackgroundLocationUpdates = true
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        guard let uid = auth.currentUser?.uid else {return}
        let status = manager.authorizationStatus
        var statusString = "undetermined"
        if status.rawValue == 0 {
            statusString = "notDetermined"
        } else if status.rawValue == 1 {
            statusString = "appNotAuthorised"
        } else if status.rawValue == 2 {
            statusString = "denied"
        } else if status.rawValue == 3 {
            statusString = "authorisedAlways"
        } else if status.rawValue == 4 {
            statusString = "authorisedWhenInUse"
        }
        db.collection("profiles").document(uid).updateData(["locationStatus" : statusString]) { error in
            if let error = error {
                print("Error writing location authorisation status to db: \(error)")
            }
        }
//        db.collection("profiles").document(uid).updateData(["locationStatus" : String(status)]) { error in
//            if let error = error {
//                print("Error writing location authorisation status to db: \(error)")
//            }
//        }
    }
    
//    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        locations.last.map {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
            
            guard let uid = auth.currentUser?.uid else {return}

            let docRef = db.collection("profiles").document(uid)

            docRef.getDocument { result, error in
                if let error = error {
                    print("Error getting user document for location update: \(error)")
                    return
                }
                
                let oldLat = result?["currLatitude"] ?? 0
                let oldLong = result?["currLongitude"] ?? 0
                let lastUpdate = result?["lastLocationUpdate"] as? Timestamp
                let lastUpdateDate = lastUpdate?.dateValue() ?? Date()
//                Date ?? Calendar.current.date(byAdding: .minute, value: -1, to: Date())!
            
                let barrier = Calendar.current.date(byAdding: .minute, value: -5, to: Date())!

                if lastUpdateDate < barrier {
                    print("passed barrier")

                    docRef.updateData([
                          "oldLatitude" : oldLat,
                          "oldLongitude" : oldLong,
                          "currLatitude" : self.region.center.latitude,
                          "currLongitude" : self.region.center.longitude,
                          "lastLocationUpdate" : Date()
                    ])
                    
                }
                    
            }

            
        }
    }
    
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
