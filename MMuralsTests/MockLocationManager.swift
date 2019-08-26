//
//  MockLocationManager.swift
//  MapCompass
//
//  Created by Thomas Bouges on 2019-08-24.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import CoreLocation
@testable import MMurals

class MockLocationManager: LocationManager {
    
    
    
    var location: CLLocation? = CLLocation(
        latitude: 37.3317,
        longitude: -122.0325086
    )
    // magneticHeading 325.50 trueHeading 311.31 accuracy 15.00 x +11.450 y +15.704 z -50.736 @ 2019-08-24 22:43:23 +0000
//    var heading: CLHeading? = CLHeading().magneticHeading = 325.50
//        
        
//            magneticHeading: CLLocationDirection(exactly: 325.50),
//            trueHeading: CLLocationDirection(311.31),
//            HeadingAccuracy: CLLocationDirection(15.00),
//            x: CLHeadingComponentValue(+11.450),
//            y: CLHeadingComponentValue(+15.704),
//            z: CLHeadingComponentValue(-50.736),
//            timestamp: Date()
//    )
    
//        NSObject(  magneticHeading: 325.50,trueHeading:311.31,HeadingAccuracy:15.00, x: 11.450, y:15.704, z:-50.736,timestamp: Date())

//        (magneticHeading: CLLocationDirection(exactly: 325.50),
//        trueHeading: CLLocationDirection(311.31),
//        HeadingAccuracy: CLLocationDirection(15.00),
//        x: CLHeadingComponentValue(+11.450),
//        y: CLHeadingComponentValue(+15.704),
//        z: CLHeadingComponentValue(-50.736),
//        timestamp: Date()
//    )

    var delegate: CLLocationManagerDelegate?
    var distanceFilter: CLLocationDistance = 10
//    var pausesLocationUpdatesAutomatically = false
//    var allowsBackgroundLocationUpdates = true
    var autho = CLAuthorizationStatus.authorizedWhenInUse
    
    func requestWhenInUseAuthorization() { }
    func startUpdatingLocation() { }
    func stopUpdatingLocation() { }
    func startUpdatingHeading() { }
    func stopUpdatingHeading() { }
    func requestLocation() {}
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return autho
    }
    
    func isLocationServicesEnabled() -> Bool {
        if autho == .authorizedWhenInUse || autho == .authorizedAlways {
             return true
        }
        return false
    }
    
}
