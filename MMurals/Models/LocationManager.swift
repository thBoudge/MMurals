//
//  LocationManager.swift
//  MapCompass
//
//  Created by Thomas Bouges on 2019-08-24.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManager {
    
    // CLLocationManager Properties
    var location: CLLocation? { get }
//    var heading: CLHeading? { get }
//    var delegate: CLLocationManagerDelegate? { get set }
    var delegate: CLLocationManagerDelegate? { get set }
    var distanceFilter: CLLocationDistance { get set }
//    var pausesLocationUpdatesAutomatically: Bool { get set }
//    var allowsBackgroundLocationUpdates: Bool { get set }
    
    // CLLocationManager Methods
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func startUpdatingHeading()
    func stopUpdatingHeading()
    func requestLocation()
    
    // Wrappers for CLLocationManager class functions.
    func getAuthorizationStatus() -> CLAuthorizationStatus
    func isLocationServicesEnabled() -> Bool
}

extension CLLocationManager: LocationManager {
    
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
}
