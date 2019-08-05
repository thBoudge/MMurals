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

    var realm: Realm!
    
    override func setUp() {
        super.setUp()
        
        let configuration = Realm.Configuration( inMemoryIdentifier: "test", schemaVersion: 1 )
                realm = try! Realm(configuration: configuration)
                insertMurals()
        
    }

    
    
    //MARK: - Helper Methods
    private func insertMurals() {
        
        let muralsService = MuralsService(muralSession: URLSessionFake(data: FakeMuralsResponseData.responseCorrectData, response: FakeMuralsResponseData.responseOk, error: nil))

        muralsService.getMurals  { (success, response) in
            
            guard let data = response else {return}
            print(data)
            MuralRealm.addMurals(mural: data, realm: self.realm)
            print(self.realm.objects(MuralRealm.self).count)
            
           
        }
        
       
    }
    
    func testGetMuralsShouldAddDataToBDRealm() {
        
        

       // When
       
        let expectation = XCTestExpectation(description: "wait for queue")


            let mural = realm.objects(MuralRealm.self)
            print("plouf")
            print(mural)
            print("plouf")

            let artist = mural[1].artist

            XCTAssertEqual("Simon Bachand et Jasmin Guérard-Alie", artist)

        expectation.fulfill()
        wait(for: [expectation], timeout: 1)
       
    }
    
    
}


