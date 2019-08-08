//
//  DistanceLocation.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-07.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import MapKit

class DistanceLocation {
    
    func locationsSortedByDistanceFromPreviousLocation(locations: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        // take in an array and a starting location
        let startLocation = locations[0] 
        var sortedPoint : [CLLocationCoordinate2D] = []
        sortedPoint.append(startLocation)
        var i = 0
        
        repeat{
            guard let closureLocation = pointBestDistance(muralsLocation: locations, sortedPoint: sortedPoint) else {return []}
            sortedPoint.append(closureLocation)
            i += 1
        } while i < locations.count - 1
        
        return sortedPoint
        
    }
    
    private func pointBestDistance(muralsLocation : [CLLocationCoordinate2D], sortedPoint : [CLLocationCoordinate2D] ) -> CLLocationCoordinate2D? {
        guard let startLocation = sortedPoint.last else {return nil}
        var distance = 1500000.0
        var closureLocation = CLLocationCoordinate2D()
        
        //create a [] without location already sorted
        let muralspoint = muralsLocation.filter { (muralpoint) -> Bool in
            var alreadySorted = false
            for point in sortedPoint{
                if muralpoint.latitude == point.latitude && muralpoint.longitude == point.longitude{
                    alreadySorted = true
                }
            }
            if !alreadySorted {
                return true
            }
            return false
        }
        
        
        // Check closure on remain point with startlocation
        for point in muralspoint {
            
            let newDistance = calculateDistance(startLocation: startLocation, destination: point)
            
            if newDistance < distance {
            
                distance = newDistance
                closureLocation = point
            }
        }
        return closureLocation
    }
    
    private func calculateDistance(startLocation: CLLocationCoordinate2D, destination:CLLocationCoordinate2D) -> Double {
        
        let distanceInMeters = CLLocation(latitude: destination.latitude, longitude: destination.longitude).distance(from: CLLocation(latitude: startLocation.latitude, longitude: startLocation.longitude))
        
        return distanceInMeters
    }
    
}
