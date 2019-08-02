//
//  MuralRealmTests.swift
//  MMuralsTests
//
//  Created by Thomas Bouges on 2019-07-23.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import XCTest
@testable import MMurals
import RealmSwift

class MuralRealmTests: XCTestCase {

//    let testRealmURL = URL(fileURLWithPath: "...")
    
    override func setUp() {
        super.setUp()

        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "yep")
    }
    
    
    //MARK: - Helper Methods
    private func insertMurals(realm : Realm ) {

        let muralsService = MuralsService(muralSession: URLSessionFake(data: FakeMuralsResponseData.responseCorrectData, response: FakeMuralsResponseData.responseOk, error: nil))

        muralsService.getMurals  { (success, response) in
            
            guard let data = response else {return}
//            print(data)
            MuralRealm.addMurals(mural: data, realm: realm)
            print(realm.objects(MuralRealm.self).count)
        }
    }
    
    func testGetMuralsShouldAddDataToBDRealm() {
        
        
//        let config = Realm.Configuration(fileURL: testRealmURL)
//        let testRealm = try! Realm(configuration: config)
//        let testRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "bdRealm"))
        let testRealm = try! Realm()
        print(testRealm)
//        testRealm.deleteAll()
//        XCTAssertFalse(testRealm.isEmpty)
        
        // Given
        insertMurals(realm: testRealm )

//        // When
//        let expectation = XCTestExpectation(description: "Wait for queue change.")

       
            let mural = testRealm.objects(MuralRealm.self)
            print("plouf")
            print(mural)
            print("plouf")
        
            let artist = mural[1].artist
            
            XCTAssertEqual("Simon Bachand et Jasmin Guérard-Alie", artist)
        
        
        
       
//        expectation.fulfill()
//        wait(for: [expectation], timeout: 1.10)
    }
    
    
}


