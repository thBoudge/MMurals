//
//  MuralAnnotationTests.swift
//  MMuralsTests
//
//  Created by Thomas Bouges on 2019-08-20.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import XCTest
import CoreLocation
import RealmSwift
@testable import MMurals

class MuralAnnotationTests: XCTestCase {

    // MARK: - Properties

    var muralAnnotationsList : [MuralAnnotation] = []
    var realmTest: Realm!
    let configuration = Realm.Configuration( inMemoryIdentifier: "test", schemaVersion: 1 )
    
    // MARK: - SETUP
    
    override func setUp() {
        super.setUp()
        realmTest = try! Realm()
        guard realmTest.isEmpty else { return }
    }
    //MARK: - Helper Methods
    
    private func insertMurals() {
        
        let muralsService = MuralsService(muralSession: URLSessionFake(data: FakeMuralsResponseData.responseCorrectData, response: FakeMuralsResponseData.responseOk, error: nil))
        
        muralsService.getMurals  { (success, response) in
            guard let data = response else {return}
            MuralPersistentData.addMurals(mural: data, realm: self.realmTest)
        }
    }
    
    // MARK: - Test Methods
    
    func testGetMuralsAnnotationsFromRealmAndReturnListAnnotations() {
        insertMurals()
        let expectation = XCTestExpectation(description: "wait for queue")
        muralAnnotationsList = MuralAnnotation.getMuralAnnotationsList()
        let title = muralAnnotationsList[1].title
        expectation.fulfill()
        
        XCTAssertEqual("Simon Bachand et Jasmin Guérard-Alie", title)
        wait(for: [expectation], timeout: 1)
        
    }

}
