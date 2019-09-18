//
//  MuralVCVisitMethods.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-09-17.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import MapKit

extension MuralViewController {

    //MARK: Compass Methods
    
    /// Call when MapView Orientation change , get figures, calculate and change label NumberMuralLabel and NtimeVisitLabel
    func addMuralsNumberAndTimeVisit(){
        let pointsSorted = muralsVisitList()
        if pointsSorted.count > 1{
            let distance =  distanceLocation.calculateDistanceBetweenTwoMurals(murals: pointsSorted)
            let time =  Int(distance * 5000 / 3600)
            let timeHour =  time / 3600
            let timeMinutes =  time % 3600 / 60
            numberMuralLabel.text = "Murals: \(pointsSorted.count - 1)"
            timeVisitLabel.text = "Time: \(timeHour)h \(timeMinutes)min"
        }else{
            numberMuralLabel.text = "Murals: none"
            timeVisitLabel.text = ""
        }
    }
    
    /// Methods that will sort MuralAnnotion from [MuralAnnotation] by coordinate in order to create best way to visit Murals
    func muralsVisitList() ->[MuralAnnotation]{
        
        var points : [MuralAnnotation] = []
        guard let userPosition = locationServ.currentLocation?.coordinate else {return []}
        let startPoint = MuralAnnotation(coordinate: userPosition, title: "Start Point", subtitle: "", id: 0)
        points.append(startPoint)
        points += getMuralsToVisit()
        
        let sortedLocations = distanceLocation.locationsSortedByDistanceFromPreviousLocation(locations: points)
        return sortedLocations
    }
    
    /// Method that create CLCircularRegion on top half screen in order to return [MuralAnnotation] (all muralAnnotation that are n that region
    private func getMuralsToVisit() -> [MuralAnnotation]{
        let x = mapView.frame.width / 2.0
        var y : CGFloat
        // if compass one direction or multiple direction we change Region
        if mapToAppear == 1 {
            y = mapView.frame.height / 2.0
        } else {
            y = mapView.frame.height / 4.0
        }
        
        let centerCGPoint = CGPoint(x: x, y: y)
        let centerCoordinate = mapView.convert(centerCGPoint, toCoordinateFrom: mapView)
        let selectedRegion = CLCircularRegion(center: centerCoordinate, radius: 1000, identifier: "selectedRegion")
        
        let muralsSelectedList = muralAnnotationList.filter { (mural) -> Bool in
            if selectedRegion.contains(mural.coordinate){
                return true
            }
            return false
        }
        return muralsSelectedList
    }

}
