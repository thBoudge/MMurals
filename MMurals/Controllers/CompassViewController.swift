//
//  CompassViewController.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-16.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import RealmSwift

class CompassViewController: UIViewController {
    
    @IBOutlet weak var compassMapView: MKMapView!
    
//    var mapCenter : CLLocation?
    let locationManager = CLLocationManager()
    //How close we want to be
    let regionRadius: CLLocationDistance = 3000.0
    
    // create a list of MuralAnnotation
    var muralAnnotationList : [MuralAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        
    }
    
    @IBAction func goToRouteDirection(_ sender: UIButton) {
        self.performSegue(withIdentifier: "RoutingViewSegue", sender: self)
    }
    
    //prepare segue before to perfomr it
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let destinationVC = segue.destination as! RoutingViewController
        //we inform where we send data in other viewController
        if let userPosition = locationManager.location?.coordinate {
        let startPoint = MuralAnnotation(coordinate: userPosition, title: "Start Point", subtitle: "", id: 0)
        
        var points : [MuralAnnotation] = []
        
        points.append(startPoint)
//        points += getMuralsToVisit()
        let muralsPoint = getMuralsToVisit()
            for mural in muralsPoint{
                points.append(mural)
            }
        print("point1")
            print(points)
        destinationVC.pointArray = []
        destinationVC.pointArray = points
        }
    }
    
    private func addMuralsAnnotation(){
        // create a list of murals
        let realm = try! Realm()
        let muralsList = realm.objects(MuralRealm.self)
        
        for mural in muralsList {
            
            let locatePoint = CLLocation(latitude: mural.latitude, longitude: mural.longitude)
            let newMural = MuralAnnotation(coordinate: locatePoint.coordinate, title: mural.artist, subtitle: String(mural.year), id: mural.id)
            muralAnnotationList.append(newMural)
            
        }
        
        compassMapView.addAnnotations(self.muralAnnotationList)
        compassMapView.register(MuralAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        compassMapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    private func getMuralsToVisit() -> [MuralAnnotation]{
        
        let x = compassMapView.frame.width / 2.0
        let y = compassMapView.frame.height / 4.0
        let centerCGPoint = CGPoint(x: x, y: y)
        
        let centerCoordinate = compassMapView.convert(centerCGPoint, toCoordinateFrom: compassMapView)
        
        let selectedRegion = CLCircularRegion(center: centerCoordinate, radius: 1000, identifier: "selectedRegion")
        
        
        let muralsSelectedList = muralAnnotationList.filter { (mural) -> Bool in
            
           if selectedRegion.contains(mural.coordinate){
                return true
            }
            return false
        }
        
        return muralsSelectedList
    }
    
}

extension CompassViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        let angle = newHeading.trueHeading * .pi / 180
        //animation to turn map when we turn devise
        UIView.animate(withDuration: 0.5) {
            self.compassMapView.camera.heading = newHeading.magneticHeading
            
        }
    }
    
////    new
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            mapCenter = locations.last
//        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    private func checkLocationServices(){
        
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
            addMuralsAnnotation()
            locationManager.startUpdatingHeading()
        } else {
            // show an alert letting the user know they have to turn location services On
        }
    }
    
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    private func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse :
            //show user Location
            compassMapView.showsUserLocation = true
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
            compassMapView.setRegion(region, animated: true)
        }
    }
    
    
    
}



