//
//  MuralVCAnimatedRoute.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-09-18.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//
//source : https://medium.com/gett-engineering/animated-routes-with-mkmapview-1b51c6afd3bb

import MapKit

extension MuralViewController {

//    func animate(routesSorted: [CLLocationCoordinate2D], duration: TimeInterval, completion: (() -> Void)?) {
//        guard routesSorted.count > 0 else { return }
//        var currentStep = 1
//        let totalSteps = routesSorted.count
//        let stepDrawDuration = duration/TimeInterval(totalSteps)
//        var previousSegment: MKPolyline?
//        
//        drawingTimer = Timer.scheduledTimer(withTimeInterval: stepDrawDuration, repeats: true) { [weak self] timer in
//            guard let self = self else {
//                // Invalidate animation if we can't retain self
//                timer.invalidate()
//                completion?()
//                return
//            }
//            
//            if let previous = previousSegment {
//                // Remove last drawn segment if needed.
//                self.mapView.removeOverlay(previous)
//                previousSegment = nil
//            }
//            
//            guard currentStep < totalSteps else {
//                // If this is the last animation step...
//                let finalPolyline = MKPolyline(coordinates: routesSorted, count: routesSorted.count)
//                self.mapView.addOverlay(finalPolyline)
//                // Assign the final polyline instance to the class property.
//                self.polyline = finalPolyline
//                timer.invalidate()
//                completion?()
//                return
//            }
//            
//            // Animation step.
//            // The current segment to draw consists of a coordinate array from 0 to the 'currentStep' taken from the route.
//            let subCoordinates = Array(routesSorted.prefix(upTo: currentStep))
//            let currentSegment = MKPolyline(coordinates: subCoordinates, count: subCoordinates.count)
//            self.mapView.addOverlay(currentSegment)
//            
//            previousSegment = currentSegment
//            currentStep += 1
//        }
//    }
}
