//
//  MuralVCOverlayMethods.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-09-17.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import MapKit

extension MuralViewController {

    /// Create a route polyline between each Mural to visit and show it on MapView
    func getDirections(sortedLocations : [MuralAnnotation]){
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
                        self.mapView.addOverlay(route.polyline)

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
    
    
}
