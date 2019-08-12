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
    
    private let muralsService = MuralsService()
//    //       create CLLOcation
//    private var locationManager: CLLocationManager?
//    private var previousLocation: CLLocation?
    //MARK: Properties
    private let locationManager = CLLocationManager()
    var montrealCenter = CLLocation(latitude: 45.519379, longitude: -73.584781)
//    var montrealCenter = CLLocation
//    let region : MKCoordinateRegion?
    // create a list of MuralAnnotation
    var muralAnnotationList : [MuralAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        loadMurals()
        
        //How close we want to be
        let regionRadius: CLLocationDistance = 1000.0
        // create a region
        let region = MKCoordinateRegion(center: montrealCenter.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        //we pass region to MapView
        mapView.setRegion(region, animated: true)
        
        
        // create a list of murals
        let realm = try! Realm()
        let muralsList = realm.objects(MuralRealm.self)
        
        for mural in muralsList {
            
            let locatePoint = CLLocation(latitude: mural.latitude, longitude: mural.longitude)
            let newMural = MuralAnnotation(coordinate: locatePoint.coordinate, title: mural.artist, subtitle: String(mural.year), id: mural.id)
            muralAnnotationList.append(newMural)
            
        }
        
        mapView.addAnnotations(muralAnnotationList)
        mapView.register(MuralAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        mapView.delegate = self
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
        
        self.performSegue(withIdentifier: "RoutingSegue", sender: self)
    }
    
    //prepare segue before to perfomr it
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! RoutingViewController
        //we inform where we send data in other viewController
        var points : [MuralAnnotation] = []
        
        let startPoint = MuralAnnotation(coordinate: montrealCenter.coordinate , title: "Start Point", subtitle: "", id: 0)
        points.append(startPoint)
        points.append(muralAnnotationList[12])
        points.append(muralAnnotationList[120])
        points.append(muralAnnotationList[56])
        points.append(muralAnnotationList[150])
        points.append(muralAnnotationList[34])
        points.append(muralAnnotationList[64])
        
        destinationVC.pointArray = points
    }
    
    
    private func loadMurals(){
        
        muralsService.getMurals { (success, response) in
            if success, let data = response  {
                //                print(data)
                //////////////// tempory need to be done depending data update date \\\\\\\\\\\\\\\\\\\\\\\\
                let realm = try! Realm()
                let numberOfPersistentData = realm.objects(MuralRealm.self).count
                guard let numberOfAPIData = data.features?.count else {return}
                try! realm.write {
                    realm.deleteAll()
                }
                if numberOfAPIData > numberOfPersistentData {
                    // Delete all objects from the realm
                    try! realm.write {
                        realm.deleteAll()
                    }
                    MuralRealm.addMurals(mural: data)
                }
                //                MuralRealm.addMurals(mural: data)
                /////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
            } else {
                
            }
        }
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
    
    func getLocation(){
        
        locationManager.delegate = self
        //inform type of accuracy we need localisation
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // Ask costumer if he allows us to use This phone to gps
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        //if correct data we stop localisation
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }
        print("lattitude : \(location.coordinate.latitude)\n longitude : \(location.coordinate.longitude)")
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        montrealCenter = CLLocation(latitude: latitude, longitude: longitude)
        
    }
    
    
    //didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Position Unavailable")
        
    }
    
    
}
