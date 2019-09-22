//
//  MuralVCDelegateMethods.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-09-17.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import MapKit

// MARK: - MKMapViewDelegate extension

extension MuralViewController: MKMapViewDelegate{
    
    // Methods that Make appear internet site after a tap on annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        MuralAnnotationView.didSelectAnnotation(view: view, pointArray: muralAnnotationList )
    }
    
    // Create a renderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .purple
        renderer.lineWidth = 5
        return renderer
    }
}

// MARK: - LocationServiceDelegate Extension

extension MuralViewController: LocationServiceDelegate {
    
    func onLocationHeadingUpdate(newHeading: CLHeading) {
        if mapToAppear == 0 {
            //  let angle = newHeading.trueHeading * .pi / 180
            // Animation to turn map when we turn devise
            UIView.animate(withDuration: 0.5) {
                self.mapView.camera.heading = newHeading.magneticHeading
            }
            addMuralsNumberAndTimeVisit()
        } else {
            locationServ.locationManager?.stopUpdatingHeading()
        }
    }
    
    
    func onLocationUpdate(location: CLLocation) {
        // Create a Region that will be show on MapView only when PageOpen and stop Update Location
        //        if mapToAppear == 2  || mapToAppear == 0 {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: false)
        locationServ.locationManager?.stopUpdatingLocation()
        //        }
    }
    
    func onLocationDidFailWithError(error: Error) {
        print("Error while trying to update device location : \(error)")
    }
    
}

// MARK: - alertOn locatlisation Permission issue

extension MuralViewController : AlertSelectionDelegate {
    func alertOn(name: String, description: String) {
        let alertMVC = UIAlertController(title: name, message: description, preferredStyle: .alert)
        alertMVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertMVC, animated: true, completion: nil)
    }
}

