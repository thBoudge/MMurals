//
//  MuralAnnotationTests.swift
//  MMuralsTests
//
//  Created by Thomas Bouges on 2019-08-20.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import XCTest
import CoreLocation
@testable import MMurals

class MuralAnnotationTests: XCTestCase {

    var muralAnnotationsList : [MuralAnnotation] = []
    
    override func setUp() {
        
        let mural1 = MuralAnnotation(coordinate: CLLocationCoordinate2D(latitude: 45.506855, longitude: -73.558029), title: "Simon Bachand et Jasmin Guérard-Alie", subtitle: "2007", id: 2)
        let mural2 = MuralAnnotation(coordinate: CLLocationCoordinate2D(latitude: 45.510131, longitude: -73.563033), title: "Simon Bachand et Jasmin Guérard-Alie", subtitle: "2008", id: 6)
        let mural3 = MuralAnnotation(coordinate: CLLocationCoordinate2D(latitude: 45.52159, longitude: -73.552993), title: "Jasmin Guérard-Alie et Simon Bachand ", subtitle: "2008", id:  7)
        let mural4 = MuralAnnotation(coordinate: CLLocationCoordinate2D(latitude: 45.512805, longitude: -73.563467), title: "Phillip Adams et David Guinn", subtitle: "2009", id: 8)
        muralAnnotationsList.append(mural1)
        muralAnnotationsList.append(mural2)
        muralAnnotationsList.append(mural3)
        muralAnnotationsList.append(mural4)
    }

 

}
