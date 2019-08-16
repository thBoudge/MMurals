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
    
    let montrealCenter = CLLocation(latitude: 45.519379, longitude: -73.584781)
    let locationManager = CLLocationManager()
    
    // create a list of MuralAnnotation
    var muralAnnotationList : [MuralAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Initialise a New Realm
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
        
        //How close we want to be
        let regionRadius: CLLocationDistance = 1500.0
        // create a region
        let region = MKCoordinateRegion(center: montrealCenter.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        //we pass region to MapView
        compassMapView.setRegion(region, animated: true)
        
        
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        
    }
    
    @IBAction func goToRouteDirection(_ sender: UIButton) {
        self.performSegue(withIdentifier: "RoutingViewSegue", sender: self)
    }
    
    //prepare segue before to perfomr it
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let destinationVC = segue.destination as! RoutingViewController
        //we inform where we send data in other viewController
        let startPoint = MuralAnnotation(coordinate: montrealCenter.coordinate , title: "Start Point", subtitle: "", id: 0)
        var points : [MuralAnnotation] = []
        
        points.append(startPoint)
        points += getMuralsToVisit()
        
        destinationVC.pointArray = points
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
    
    
    
}

