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
    
    @IBOutlet weak var timeVisitLabel: UILabel!
    @IBOutlet weak var numberMuralLabel: UILabel!
    @IBOutlet weak var compassMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    //How close we want mapKit to be
    let regionRadius: CLLocationDistance = 3000.0
    // create a list of MuralAnnotation
    var muralAnnotationList : [MuralAnnotation] = []
    var distanceLocation = DistanceLocation()
    
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
        var points = muralsVisitList()
        destinationVC.pointArray = points
        
    }
    
    private func addMuralsAnnotation(){
        muralAnnotationList = MuralAnnotationView.getMuralAnnotationsList()
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
    
    private func muralsVisitList() ->[MuralAnnotation]{
       
        var points : [MuralAnnotation] = []
        if let userPosition = locationManager.location?.coordinate {
            let startPoint = MuralAnnotation(coordinate: userPosition, title: "Start Point", subtitle: "", id: 0)
            points.append(startPoint)
            points += getMuralsToVisit()
        }
        let sortedLocations = distanceLocation.locationsSortedByDistanceFromPreviousLocation(locations: points)
        return sortedLocations
    }
    
}

extension CompassViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        let angle = newHeading.trueHeading * .pi / 180
        //animation to turn map when we turn devise
        UIView.animate(withDuration: 0.5) {
            self.compassMapView.camera.heading = newHeading.magneticHeading
        }
        
        var pointsSorted = muralsVisitList()
        if pointsSorted.count > 1{
       let distance =  distanceLocation.calculateDistanceAndNumberOfMurals(murals: pointsSorted)
        let time =  Int(distance * 5000 / 3600)
        let timeHour =  time / 3600
        let timeMinutes =  time % 3600 / 60
            numberMuralLabel.text = "Murals: \(pointsSorted.count - 1)"
            timeVisitLabel.text = "Distance: \(timeHour)h \(timeMinutes)min"
        }else{
            numberMuralLabel.text = "Murals: none"
            timeVisitLabel.text = ""
        }
    }
    
    
    
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



