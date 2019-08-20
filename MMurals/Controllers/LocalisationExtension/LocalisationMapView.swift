//
//  LocalisationMapView.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-19.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import MapKit

//extension MapViewController : CLLocationManagerDelegate{
//    
//    // MARK: - Function from CLLocationManagerDelegate
//    
////    // didFailWithError method here:
////    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
////
////        print("Position Unavailable \(error)")
////
////    }
////
////    // Call when Authorization are changed
////    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
////        checkLocationAuthorization()
////    }
////
//    // MARK: - Methods
//    
//    /// Check if Location autorisation are allowed by user + setUp LocationManager + Start localisation + create region from MapView appearance
////    func checkLocationServices(){
////
////        if CLLocationManager.locationServicesEnabled(){
////            setupLocationManager()
////            checkLocationAuthorization()
////        } else {
////            // show an alert letting the user know they have to turn location services On
////        }
////    }
//    
////    /// Set up of CLLocationManager
////    private func setupLocationManager(){
////        locationManager.delegate = self
////        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
////        // Ask costumer if he allows us to use This phone to gps
////        locationManager.requestWhenInUseAuthorization()
////        locationManager.startUpdatingLocation()
////    }
//    
//    
//    /// Switch that control what is user Location Authorisation and respon to it
////    private func checkLocationAuthorization(){
////        switch CLLocationManager.authorizationStatus(){
////        case .authorizedWhenInUse :
////            //show user Location
////            mapView.showsUserLocation = true
////            centerLocation()
////        case .denied :
////            // show an alert letting user know how to turn on permissions
////            break
////        case .notDetermined:
////            locationManager.requestWhenInUseAuthorization()
////        case .restricted: break
////        // show an alert letting user know how to turn on permissions
////        case .authorizedAlways:
////            break
////        @unknown default:
////            break
////        }
////    }
//    
//    
////    /// Create a Region that will be show on MapView
////    private func centerLocation(){
////        if let location = locationManager.location?.coordinate {
////            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
////            
////            mapView.setRegion(region, animated: true)
////        }
////    }
//
//}
