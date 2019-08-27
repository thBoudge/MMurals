//
//  DistanceLocation.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-07.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import CoreLocation

class DistanceLocation {
    
    // MARK: - Methods

    /// sort [MuralAnnotation] by distance : MuralAnnotation[0] from others MuralAnnotation, and MuralAnnotation nearest slected with others MuralAnnotation ... until no more MuralAnnotation have been selected.
    func locationsSortedByDistanceFromPreviousLocation(locations: [MuralAnnotation]) -> [MuralAnnotation] {
        // take in an array and a starting location
        let startLocation = locations[0]
        var sortedPoint : [MuralAnnotation] = []
        sortedPoint.append(startLocation)
        var i = 1
        
        repeat{
            guard let closureLocation = pointBestDistance(muralsLocation: locations, sortedPoint: sortedPoint) else {return []}
            sortedPoint.append(closureLocation)
            i += 1
        } while i < locations.count - 1
        return sortedPoint
        
    }
    

    /// Methods check nearest MuralAnnotation from SortedPoint.last
    private func pointBestDistance(muralsLocation : [MuralAnnotation], sortedPoint : [MuralAnnotation] ) -> MuralAnnotation? {
        
        guard let startLocation = sortedPoint.last?.coordinate else {return nil}
        var distance = 1500000.0
        var closureLocation : MuralAnnotation?
        
        //create a [MuralAnnotation] without location already sorted
        let muralspoint = muralsLocation.filter { (muralpoint) -> Bool in
            var alreadySorted = false
            for point in sortedPoint{
                if muralpoint.coordinate.latitude == point.coordinate.latitude && muralpoint.coordinate.longitude == point.coordinate.longitude{
                    alreadySorted = true
                }
            }
            if !alreadySorted {
                return true
            }
            return false
        }
        
        // Check nearest MuralAnnotation on remain point not sorted
        for point in muralspoint {
            
            let newDistance = calculateDistance(startLocation: startLocation, destination: point.coordinate)
            
            if newDistance < distance {
                
                distance = newDistance
                closureLocation = point
            }
        }
        return closureLocation
    }
    
    /// Methods that calculate distance between 2 coordinates MuralAnnotation and return distance in meter
    private func calculateDistance(startLocation: CLLocationCoordinate2D, destination:CLLocationCoordinate2D) -> Double {

        let distanceInMeters = CLLocation(latitude: destination.latitude, longitude: destination.longitude).distance(from: CLLocation(latitude: startLocation.latitude, longitude: startLocation.longitude))

        return distanceInMeters
    }
    
    
    /// Methods that calculate distance between 2  MuralAnnotation and return distance in meter
    func calculateDistanceBetweenTwoMurals(murals: [MuralAnnotation]) -> Double{
        var distance = 0.0
        for i in 0 ..< murals.count - 1 {
            distance += calculateDistance(startLocation: murals[i].coordinate, destination: murals[i+1].coordinate)
        }
        return distance
    }
    
}
