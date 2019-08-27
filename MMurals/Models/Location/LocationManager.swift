//
//  LocationManager.swift
//  MapCompass
//
//  Created by Thomas Bouges on 2019-08-24.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import CoreLocation

/// Protocol that create Location sinmilar to CLLocationManager
protocol LocationManager {
    
    // MARK: - CLLocationManager Properties
    
    var location: CLLocation? { get }
    var delegate: CLLocationManagerDelegate? { get set }
    var distanceFilter: CLLocationDistance { get set }
    
    // MARK: - CLLocationManager Methods
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func startUpdatingHeading()
    func stopUpdatingHeading()
    func requestLocation()
    
    // // MARK: - Wrappers for CLLocationManager class functions.
    func getAuthorizationStatus() -> CLAuthorizationStatus
    func isLocationServicesEnabled() -> Bool
}

// MARK: - Extension CLLocationManager
// Extension CLLocationManager with LocotionManager Protocola
extension CLLocationManager: LocationManager {
    
    /// return CLAuthorizationStatus from LocationManager
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    /// return Bolean from LocationManager to know if user isEnabled or not
    func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
}
