//
//  DistanceLocation.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-07.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class DistanceLocation {
    

    
    func locationsSortedByDistanceFromPreviousLocation(locations: [MuralAnnotation]) -> [MuralAnnotation] {
        // take in an array and a starting location
        let startLocation = locations[0]
        var sortedPoint : [MuralAnnotation] = []
        sortedPoint.append(startLocation)
        var i = 1
        
        repeat{
            print("sortedPoint \(i)")
            print(sortedPoint)
            guard let closureLocation = pointBestDistance(muralsLocation: locations, sortedPoint: sortedPoint) else {return []}
            sortedPoint.append(closureLocation)
            i += 1
        } while i < locations.count - 1
        print("final")
        print(sortedPoint)
        return sortedPoint
        
    }
    

    
    private func pointBestDistance(muralsLocation : [MuralAnnotation], sortedPoint : [MuralAnnotation] ) -> MuralAnnotation? {
        
        guard let startLocation = sortedPoint.last?.coordinate else {return nil}
        var distance = 1500000.0
        var closureLocation : MuralAnnotation?
        
        //create a [] without location already sorted
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
        
        
        // Check closure on remain point with startlocation
        for point in muralspoint {
            
            let newDistance = calculateDistance(startLocation: startLocation, destination: point.coordinate)
            
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
    
    func calculateDistanceAndNumberOfMurals(murals: [MuralAnnotation]) -> (Double){
        var newDistance = 0.0
        // Check closure on remain point with startlocation
        for i in 0 ..< murals.count - 1 {
            
            newDistance += calculateDistance(startLocation: murals[i].coordinate, destination: murals[i+1].coordinate)
            
        }
        
        
        return newDistance
    }
    
}
