//
//  LocationService.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-19.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//
// HelpSource : https://stackoverflow.com/questions/55933283/location-service-as-a-singleton-in-swift-get-stuck-on-when-in-use

import Foundation
import CoreLocation

// MARK: - Protocols

//// Protocol for all alert MMurals Application
protocol AlertSelectionDelegate {
    func alertOn (name: String, description: String)
}

//// Protocol to update location + Heading + Error
protocol LocationServiceDelegate {
    /// Method that return present user Location CLLocation
    func onLocationUpdate(location: CLLocation)
    /// Method that return Error if necessary
    func onLocationDidFailWithError(error: Error)
    /// Method that return user Orientation CLHeading
    func onLocationHeadingUpdate(newHeading: CLHeading)
}

// MARK: - Class LocationService

class LocationService: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Singleton
    
    public static let shared = LocationService()
    
    // MARK: - Properties
    
    var delegate: LocationServiceDelegate?
    var locationManager: LocationManager?
    var currentLocation: CLLocation?
    var currentHeading: CLHeading?
    var authorisationDelegate : AlertSelectionDelegate?
    
    // MARK: - init()
    
    init(locationManager: LocationManager = CLLocationManager()) {
        self.locationManager = locationManager
    }
    
    // MARK: - Singleton init()
    
    private override init() {
        super.init()
        self.initializeLocationServices()
    }
    
    // MARK: - Test Convenience init()
    
    convenience init(locationManagerTest: LocationManager ) {
        self.init(locationManager:locationManagerTest)
        self.locationManager?.requestLocation()
        self.locationManager?.delegate = self
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            // show an alert letting user know how to turn on permissions
            authorisationDelegate?.alertOn(name: "Permission to localisation restricted!", description: "Please go to setting , Choose MMurals app's and change localisation to authorizedWhenInUse")
            print("User restricted access to location.")
        case .denied:
            // show an alert letting user know how to turn on permissions
            authorisationDelegate?.alertOn(name: "Permission to localisation denied!", description: "Please go to setting , Choose MMurals app's and change localisation to authorizedWhenInUse")
            print("User denied access to location.")
        case .notDetermined:
            self.locationManager?.requestWhenInUseAuthorization()
        case .authorizedAlways: break
        case .authorizedWhenInUse:
            print("User choosed locatiom when app is in use.")
        default:
            print("Unhandled error occured.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("The location is: \(location)")
        self.currentLocation = location
        locationChanged(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager?.stopUpdatingLocation()
        print("Error: \(error)")
        locationFailed(error: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.currentHeading = newHeading
        guard let heading = currentHeading else {return}
        headingChanged(heading: heading)
    }
    
    // MARK: - Methods
    
    private func locationChanged(location: CLLocation) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.onLocationUpdate(location: location)
    }
    
    private func locationFailed(error: Error) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.onLocationDidFailWithError(error: error)
    }
    
    private func headingChanged(heading: CLHeading){
        guard let delegate = self.delegate else {
            return
        }
        delegate.onLocationHeadingUpdate(newHeading: heading)
    }
    
    private func initializeLocationServices() {
        self.locationManager = CLLocationManager()
        self.locationManager?.distanceFilter = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.delegate = self
        self.locationManager?.startUpdatingLocation()
        self.locationManager?.startUpdatingHeading()
        
    }
}
