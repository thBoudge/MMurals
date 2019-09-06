//
//  DistanceLocationTests.swift
//  MMuralsTests
//
//  Created by Thomas Bouges on 2019-08-20.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import XCTest
import CoreLocation
@testable import MMurals

class DistanceLocationTests: XCTestCase {
    
    // MARK: - Properties

    private var muralAnnotationsList : [MuralAnnotation] = []
    private let distanceLocation = DistanceLocation()
    
    // MARK: - SETUP
    
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
    
    // MARK: - Test Methods
    
    // Test that method locationsSortedByDistanceFromPreviousLocation return a sorted [MuralAnnotation]
    func testlocationsSortedByDistanceFromPreviousLocationReturnMuralAnnotationSorted() {
        // Given
        let sortedList = distanceLocation.locationsSortedByDistanceFromPreviousLocation(locations: muralAnnotationsList)
        print("sortedList: \(sortedList)")
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
       
            // Then
        XCTAssertNotNil(sortedList)
        XCTAssertEqual(3, sortedList.count)
        guard let title = sortedList[2].title else {return}
        XCTAssertEqual("Phillip Adams et David Guinn", title)
            expectation.fulfill()
        
        
        wait(for: [expectation], timeout: 0.01)
    }

    
    // Test that method calculateDistanceBetweenTwoMurals return distance in meters between 2 MuralAnnotation
    func testMethodcalculateDistanceBetweenTwoMuralsReturnMeters() {
        // Given
        let distance = distanceLocation.calculateDistanceBetweenTwoMurals(murals: [muralAnnotationsList[0],muralAnnotationsList[2]])
        print("sortedList: \(distance)")
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        // Then
        XCTAssertNotNil(distance)
        XCTAssertEqual(1684.2876563618734, distance)
        expectation.fulfill()
        
        
        wait(for: [expectation], timeout: 0.01)
    }
    
}
