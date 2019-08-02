//
//  MapViewController.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-07-31.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private let muralsService = MuralsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMurals()
//       create CLLOcation
        let montrealCenter = CLLocation(latitude: 45.519379, longitude: -73.584781)
        //How close we want to be
        let regionRadius: CLLocationDistance = 1000.0
        // create a region
        let region = MKCoordinateRegion(center: montrealCenter.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        //we pass region to MapView
        mapView.setRegion(region, animated: true)
        
        
        // create a list of murals
        let realm = try! Realm()
        let muralsList = realm.objects(MuralRealm.self)
        // create a list of MuralAnnotation
        var muralAnnotationList : [MuralAnnotation] = []
        for mural in muralsList {
            
            let locatePoint = CLLocation(latitude: mural.latitude, longitude: mural.longitude)
            let newMural = MuralAnnotation(coordinate: locatePoint.coordinate, title: mural.artist, subtitle: String(mural.year), imageUrl: mural.image)
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

        
}
