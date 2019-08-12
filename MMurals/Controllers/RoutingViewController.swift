//
//  RoutingViewController.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-05.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import MapKit


class RoutingViewController: UIViewController {
    
    @IBOutlet weak var routingMapView: MKMapView!

    var pointArray : [MuralAnnotation]?
    var distanceLocation = DistanceLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let points = pointArray else {return}
        print(points)
        let sortedLocations = distanceLocation.locationsSortedByDistanceFromPreviousLocation(locations: points)
        // https://www.youtube.com/watch?v=vUvf_dlr6IU
        getDirections(sortedLocations: sortedLocations)
        
        guard let muralsPointList = pointArray else {return}
        var muralAnnotationList : [MuralAnnotation] = []
        for mural in muralsPointList {
            muralAnnotationList.append(mural)
        }
        
        routingMapView.addAnnotations(muralAnnotationList)
        routingMapView.register(MuralAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        routingMapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        routingMapView.delegate = self
    }
    
    private func getDirections(sortedLocations : [MuralAnnotation]){
        
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
                    //show all the map surronding the direction
                    self.routingMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        }
    }

    
    private func createDirectionRequest(coordinates:[CLLocationCoordinate2D]) -> MKDirections.Request {

        let destinationCoordinates = MKPlacemark(coordinate: coordinates[1])
        let startCoordinates = MKPlacemark(coordinate: coordinates[0])

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startCoordinates)
        request.destination = MKMapItem(placemark: destinationCoordinates)
        request.transportType = .walking

        return request
    }
}


extension RoutingViewController: MKMapViewDelegate {
    
    // creat a renderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .purple
        renderer.lineWidth = 8
        return renderer
    }
    
    //Make appear internet site after a tap on annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let muralCoordinate = view.annotation?.coordinate else {return}
        
        guard let muralsPoints = pointArray  else {return}
        
        for coordinatePoint in muralsPoints {
            
            if muralCoordinate.latitude == coordinatePoint.coordinate.latitude && muralCoordinate.longitude == coordinatePoint.coordinate.longitude && coordinatePoint.id != 0 {
                
                guard let urlString = coordinatePoint.imageUrl else {return}
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
            
        }
    }
    
}
