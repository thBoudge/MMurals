//
//  MuralsServiceTests.swift
//  MMuralsTests
//
//  Created by Thomas Bouges on 2019-07-16.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import XCTest
@testable import MMurals

class MuralsServiceTests: XCTestCase {
    
    func testGetMuralsShouldPostFailedCallback() {
        // Given
        let muralsService = MuralsService(muralSession: URLSessionFake(data: nil, response: nil, error: FakeMuralsResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        muralsService.getMurals { (success, response) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(response)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDeviseShouldPostFailedCallbackIfNoData() {
        // Given
        let muralsService = MuralsService(muralSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        muralsService.getMurals  { (success, response) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(response)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testGetDeviseShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let muralsService = MuralsService(muralSession: URLSessionFake(data: nil, response: FakeMuralsResponseData.responseOk, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        muralsService.getMurals  { (success, response) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(response)
            
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDeviseShouldPostFailedCallbackIfStatusTResponseIsfivehundred() {
        // Given
        let muralsService = MuralsService(muralSession: URLSessionFake(data: FakeMuralsResponseData.responseCorrectData, response: FakeMuralsResponseData.responseNot, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        muralsService.getMurals { (success, response) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(response)
            
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDeviseShouldPostSuccessCallbackIfNoErrorAndCorrectData()  {
        
        
        // Given
        let muralsService = MuralsService(muralSession: URLSessionFake(data: FakeMuralsResponseData.responseCorrectData, response: FakeMuralsResponseData.responseOk, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        muralsService.getMurals  { (success, response) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(response)
            guard let coordinate = response?.features?[1].geometry?.coordinates else {return}
            guard let artist = response?.features?[1].properties?.artiste else {return}
            guard let year = response?.features?[1].properties?.annee else {return}
            guard let address = response?.features?[1].properties?.adresse else {return}
            guard let imageUrl = response?.features?[1].properties?.image else {return}
            print(coordinate)
            
            XCTAssertEqual([-73.558029, 45.506855], coordinate)
            XCTAssertEqual("Simon Bachand et Jasmin Guérard-Alie", artist)
            XCTAssertEqual(2007, year)
            XCTAssertEqual("coin des rues Saint-Laurent et Viger", address)
                    XCTAssertEqual("http://depot.ville.montreal.qc.ca/murales/CDU-MissionOldBrewery–40eExpo67.jpg", imageUrl)
            
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

}
