//
//  MapViewController.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-07-31.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RealmSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    //MARK: Properties
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 5000.0
    // create a list of MuralAnnotation
    var muralAnnotationList : [MuralAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        addAnnotation()
    }
    
    // chamge Map type fom Standard to satellite
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            mapView.mapType = .standard
        }else{
            mapView.mapType = .satellite
        }
    }
    
    
    @IBAction func getDirectionMap(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "CompassPageSegue", sender: self)
    }
    
    private func addAnnotation(){
        
        muralAnnotationList = MuralAnnotationView.getMuralAnnotationsList()
        mapView.addAnnotations(self.muralAnnotationList)
        mapView.register(MuralAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
    }
    
}


extension MapViewController: MKMapViewDelegate{

    //Make appear internet site after a tap on annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let muralCoordinate = view.annotation?.coordinate else {return}
        
        for coordinatePoint in muralAnnotationList {
            
            if muralCoordinate.latitude == coordinatePoint.coordinate.latitude && muralCoordinate.longitude == coordinatePoint.coordinate.longitude{
                
                guard let urlString = coordinatePoint.imageUrl else {return}
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
            
        }
    }
}

// MARK: Localisation Methods
extension MapViewController : CLLocationManagerDelegate{

    //didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Position Unavailable \(error)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    private func checkLocationServices(){
        
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show an alert letting the user know they have to turn location services On
        }
    }
    
    private func setupLocationManager(){
        locationManager.delegate = self
        //inform type of accuracy we need localisation
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // Ask costumer if he allows us to use This phone to gps
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
   func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse :
            //show user Location
            mapView.showsUserLocation = true
            centerLocation()
        case .denied :
            // show an alert letting user know how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted: break
        // show an alert letting user know how to turn on permissions
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    private func centerLocation(){
        // create a region
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            
            //we pass region to MapView
            mapView.setRegion(region, animated: true)
        }
    }
    
}
