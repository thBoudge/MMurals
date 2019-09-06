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
    
    // MARK: - Properties

    var location: CLLocation? = CLLocation(
        latitude: 37.3317,
        longitude: -122.0325086
    )

    var delegate: CLLocationManagerDelegate?
    var distanceFilter: CLLocationDistance = 10
    var autho = CLAuthorizationStatus.authorizedWhenInUse
    
    
    // MARK: - Methods CLLocationManger

    
    func requestWhenInUseAuthorization() { }
    func startUpdatingLocation() { }
    func stopUpdatingLocation() { }
    func startUpdatingHeading() { }
    func stopUpdatingHeading() { }
    func requestLocation() {}
    
    // MARK: - Methods implemented
    
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
