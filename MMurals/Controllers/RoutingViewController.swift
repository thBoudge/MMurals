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
    
    var pointArray : [CLLocationCoordinate2D]?
    var distanceLocation = DistanceLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let points = pointArray else {return}
        let sortedLocations = distanceLocation.locationsSortedByDistanceFromPreviousLocation(locations: points)
        // https://www.youtube.com/watch?v=vUvf_dlr6IU
        getDirections(sortedLocations: sortedLocations)
        // Do any additional setup after loading the view.
    }
    
    private func getDirections(sortedLocations : [CLLocationCoordinate2D]){

        for i in 0 ..< sortedLocations.count - 1 {
           
            var muralsDirection : [CLLocationCoordinate2D] = []
            muralsDirection.append(sortedLocations[i])
            muralsDirection.append(sortedLocations[i + 1])

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
        
        
//        let request = createDirectionRequest(coordinates: sortedLocations)
//        let directions = MKDirections(request: request)
//        directions.calculate { (response, error) in
//            guard let response = response else {return}
//
//            for route in response.routes {
//                self.routingMapView.addOverlay(route.polyline)
//                //show all the map surronding the direction
//                self.routingMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//
//            }
//        }
    }
    
    private func createDirectionRequest(coordinates:[CLLocationCoordinate2D]) -> MKDirections.Request {
       
        let destinationCoordinates = MKPlacemark(coordinate: coordinates[1])
        let startCoordinates = MKPlacemark(coordinate: coordinates[0])
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startCoordinates)
        request.destination = MKMapItem(placemark: destinationCoordinates)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
            
        return request
    }
    
}


extension RoutingViewController: MKMapViewDelegate {
    
    // creat a renderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 8
        return renderer
    }
   
}
