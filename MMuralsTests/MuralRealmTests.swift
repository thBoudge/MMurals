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

    var realmTest: Realm!
    let configuration = Realm.Configuration( inMemoryIdentifier: "test", schemaVersion: 1 )
    
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
            MuralRealm.addMurals(mural: data, realm: self.realmTest)
        }
     }
    
    func testGetMuralsShouldAddDataToBDRealm() {
        insertMurals()
        let expectation = XCTestExpectation(description: "wait for queue")
        let mural = MuralRealm.all(in: realmTest)
        let artist = mural[1].artist
        expectation.fulfill()
        
        XCTAssertEqual("Simon Bachand et Jasmin Guérard-Alie", artist)
        wait(for: [expectation], timeout: 1)
       
    }
    
    
}


