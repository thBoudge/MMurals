//
//  LocationService.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-19.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//
// https://stackoverflow.com/questions/55933283/location-service-as-a-singleton-in-swift-get-stuck-on-when-in-use

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func onLocationUpdate(location: CLLocation)
    func onLocationDidFailWithError(error: Error)
    func onLocationHeadingUpdate(newHeading: CLHeading)
    
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    public static let shared = LocationService()
    
    var delegate: LocationServiceDelegate?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var currentHeading: CLHeading!
    
    private override init() {
        super.init()
        self.initializeLocationServices()
    }
    
    func initializeLocationServices() {
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        // Voir C'est quoi ?
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            // show an alert letting user know how to turn on permissions
            print("User restricted access to location.")
        case .denied:
            // show an alert letting user know how to turn on permissions
            print("User denied access to location.")
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways: break
        case .authorizedWhenInUse:
            
            print("User choosed locatiom when app is in use.")
        default:
            print("Unhandled error occured.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
        locationChanged(location: currentLocation)
    }
    
    private func locationChanged(location: CLLocation) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.onLocationUpdate(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.stopUpdatingLocation()
        locationFailed(error: error)
    }
    
    private func locationFailed(error: Error) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.onLocationDidFailWithError(error: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.currentHeading = newHeading
        headingChanged(heading: currentHeading)
    }
    
    
    private func headingChanged(heading: CLHeading){
        guard let delegate = self.delegate else {
            return
        }
        delegate.onLocationHeadingUpdate(newHeading: heading)
    }
    
    
    
    
}
