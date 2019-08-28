//
//  RoutingViewController.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-05.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//
// helpSource: https://www.youtube.com/watch?v=vUvf_dlr6IU

import MapKit

class RoutingViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var routingMapView: MKMapView!

    // MARK: - Properties
    
    let locationServ = LocationService.shared
    var pointArray : [MuralAnnotation]?
    let regionRadius: CLLocationDistance = 1000.0

    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routingMapView.showsUserLocation = true
        setMapViewSize()
        guard let points = pointArray else {return}
        getDirections(sortedLocations: points)
        addMuralsAnnotation()
        routingMapView.delegate = self
    }
    
    // MARK: - IBACTION
    
    // Change Map type fom Standard to satellite to FlyOver
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            routingMapView.mapType = .standard
        }else if sender.selectedSegmentIndex == 1{
            routingMapView.mapType = .satellite
        } else if sender.selectedSegmentIndex == 2{
            routingMapView.mapType = .satelliteFlyover
            guard let coordinate = locationServ.currentLocation?.coordinate else {return}
            let camera = MKMapCamera(lookingAtCenter: coordinate , fromDistance: 300, pitch: 40, heading: 0)
            routingMapView.camera = camera
        }
    }
    
    // Close viewPage
    @IBAction func closeRoutingPage(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ReturnToCompassViewSegue", sender: self)
    }
    
    // MARK: - Methods
    
    /// Create a region size from user localisation yhay define RoutingViewMap
    private func setMapViewSize(){
        guard let locationUser = locationServ.currentLocation?.coordinate else {return}
        let region = MKCoordinateRegion(center: locationUser, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        routingMapView.setRegion(region, animated: true)
    }
    
    /// Create a route polyline between each Mural to visit and show it on MapView
    private func getDirections(sortedLocations : [MuralAnnotation]){
        if sortedLocations.count >= 1 {
            for i in 0 ..< sortedLocations.count - 1 {
                var muralsDirection : [CLLocationCoordinate2D] = []
                muralsDirection.append(sortedLocations[i].coordinate)
                muralsDirection.append(sortedLocations[i + 1].coordinate)
                
                let request = createDirectionRequest(coordinates: muralsDirection)
                let directions = MKDirections(request: request)
                directions.calculate { (response, error) in
                    guard let response = response else {return}
                    
                    for route in response.routes {
                        self.routingMapView.addOverlay(route.polyline)
                    }
                }
            }
        }
    }

    /// Create a request between two points and return it
    private func createDirectionRequest(coordinates:[CLLocationCoordinate2D]) -> MKDirections.Request {

        let destinationCoordinates = MKPlacemark(coordinate: coordinates[1])
        let startCoordinates = MKPlacemark(coordinate: coordinates[0])
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startCoordinates)
        request.destination = MKMapItem(placemark: destinationCoordinates)
        request.transportType = .walking

        return request
    }
    
    /// Create Annotation from [MuralAnnotation) and Add it to compassMapView
    private func addMuralsAnnotation(){
        guard let muralAnnotationList = pointArray else {return}
        routingMapView.addAnnotations(muralAnnotationList)
        routingMapView.register(MuralAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        routingMapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
}

// MARK: - Extension MKMapViewDelegate

extension RoutingViewController: MKMapViewDelegate {
    
    // MARK: - func MKMapViewDelegate
    
    // Create a renderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .purple
        renderer.lineWidth = 5
        return renderer
    }
    
    // Make appear internet site after a tap on annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        MuralAnnotationView.didSelectAnnotation(view: view, pointArray: pointArray)
    }
    
}

