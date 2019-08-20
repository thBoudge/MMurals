//
//  MuralAnnotationTests.swift
//  MMuralsTests
//
//  Created by Thomas Bouges on 2019-08-20.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import XCTest
@testable import MMurals

class MuralAnnotationTests: XCTestCase {

    let muralAnnotationsList : [MuralAnnotation]
    
    override func setUp() {
        
        let mural1 = MuralAnnotation(coordinate: <#T##CLLocationCoordinate2D#>, title: <#T##String#>, subtitle: <#T##String#>, id: <#T##Int#>)
        let mural1 = MuralAnnotation(coordinate: <#T##CLLocationCoordinate2D#>, title: <#T##String#>, subtitle: <#T##String#>, id: <#T##Int#>)
        let mural1 = MuralAnnotation(coordinate: <#T##CLLocationCoordinate2D#>, title: <#T##String#>, subtitle: <#T##String#>, id: <#T##Int#>)
        let mural1 = MuralAnnotation(coordinate: <#T##CLLocationCoordinate2D#>, title: <#T##String#>, subtitle: <#T##String#>, id: <#T##Int#>)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
