//
//  MapViewController.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-07-31.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import MapKit
import RealmSwift

class MapViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties

    let locationServ = LocationService.shared
    let regionRadius: CLLocationDistance = 5000.0
    // create a list of MuralAnnotation
    var muralAnnotationList : [MuralAnnotation] = []
    // Alert Load data
    let appDelegate = AppDelegate()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationServ.delegate = self
        locationServ.authorisationDelegate = self
        appDelegate.authorisationDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.addAnnotation()
        }
    }
    
    // MARK: - ViewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        locationServ.locationManager?.startUpdatingLocation()
    }
    
    // MARK: - IBACTION
    
    // Change Map type fom Standard to satellite
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default: break
        }
    }
    
    // open page CompassViewController
    @IBAction func getDirectionMap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    
    /// Create Annotation from [MuralAnnotation) and Add it to MapView
    private func addAnnotation(){
        muralAnnotationList = MuralAnnotation.getMuralAnnotationsList()
        mapView.addAnnotations(self.muralAnnotationList)
        mapView.register(MuralAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
}

// MARK: - MKMapViewDelegate extension

extension MapViewController: MKMapViewDelegate{
    
    // Methods that Make appear internet site after a tap on annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        MuralAnnotationView.didSelectAnnotation(view: view, pointArray: muralAnnotationList )
    }
}

// MARK: - LocationServiceDelegate Extension 

extension MapViewController: LocationServiceDelegate {
    
    func onLocationHeadingUpdate(newHeading: CLHeading) {}
    
    
    func onLocationUpdate(location: CLLocation) {
        // Create a Region that will be show on MapView only when PageOpen and stop Update Location
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: false)
        locationServ.locationManager?.stopUpdatingLocation()
        
    }
    
    func onLocationDidFailWithError(error: Error) {
        print("Error while trying to update device location : \(error)")
    }
}

// MARK: - alertOn locatlisation Permission issue

extension MapViewController : AlertSelectionDelegate {
    func alertOn(name: String, description: String) {
        let alertMVC = UIAlertController(title: name, message: description, preferredStyle: .alert)
        alertMVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertMVC, animated: true, completion: nil)
    }
}
