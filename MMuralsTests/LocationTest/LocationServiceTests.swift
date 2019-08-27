//
//  LocationServiceTests.swift
//  MMuralsTests
//
//  Created by Thomas Bouges on 2019-08-26.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import XCTest
import CoreLocation
@testable import MMurals

class LocationServiceTests: XCTestCase {

    // MARK: - Properties

    private let locationManagerTest = MockLocationManager()
    private var currentLocation: CLLocation?
    private var currentHeading: CLHeading?
    private var locationServiceTest : LocationService?
    
    // MARK: - SETUP
    
    override func setUp() {
        locationServiceTest = LocationService(locationManagerTest: locationManagerTest)
        locationServiceTest?.delegate = self
    }
    
    // MARK: - Test Methods
    
    func test_getCurrentLocation_returnsExpectedLocation() {
        let expectation = XCTestExpectation(description: "wait for queue")
        guard let latitudeFirst = locationServiceTest?.currentLocation?.coordinate.latitude else {return}
        guard let latitudeFirstMock = locationManagerTest.location?.coordinate.latitude else {return}
        guard let longitudeFirst = locationServiceTest?.currentLocation?.coordinate.longitude else {return}
        guard let longitudeFirstMock = locationManagerTest.location?.coordinate.longitude else {return}
        let expectedLocation = CLLocation(latitude: 37.3317, longitude: -122.0325086)
        locationServiceTest?.delegate?.onLocationUpdate(location: expectedLocation)
        guard let latitude = currentLocation?.coordinate.latitude else {return}
        guard let longitude = currentLocation?.coordinate.longitude else {return}
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(longitudeFirst,longitudeFirstMock)
        XCTAssertEqual(latitudeFirst,latitudeFirstMock)
        XCTAssertEqual(latitude,expectedLocation.coordinate.latitude)
        XCTAssertEqual(longitude,expectedLocation.coordinate.longitude)
        
        wait(for: [expectation], timeout: 1)
    }
    
    
    func test_CLAuthorizationStatusIsWhenInUse() {
        let expectation = XCTestExpectation(description: "wait for queue")
        locationManagerTest.autho = CLAuthorizationStatus.authorizedAlways
        let isEnabled = locationServiceTest?.locationManager?.isLocationServicesEnabled()
        let status = locationServiceTest?.locationManager?.getAuthorizationStatus()
        expectation.fulfill()
        XCTAssertEqual(status,CLAuthorizationStatus.authorizedAlways)
        XCTAssertEqual(isEnabled,true)
        wait(for: [expectation], timeout: 1)
    }
    
    func test_CLAuthorizationStatusIsDenied() {
        let expectation = XCTestExpectation(description: "wait for queue")
        locationManagerTest.autho = CLAuthorizationStatus.denied
        let isEnabled = locationServiceTest?.locationManager?.isLocationServicesEnabled()
        let status = locationServiceTest?.locationManager?.getAuthorizationStatus()
        expectation.fulfill()
        XCTAssertEqual(status,CLAuthorizationStatus.denied)
        XCTAssertEqual(isEnabled,false)
        wait(for: [expectation], timeout: 1)
    }
    
    func test_CLAuthorizationStatusIsNotDetermined() {
        let expectation = XCTestExpectation(description: "wait for queue")
        locationManagerTest.autho = CLAuthorizationStatus.notDetermined
        let isEnabled = locationServiceTest?.locationManager?.isLocationServicesEnabled()
        let status = locationServiceTest?.locationManager?.getAuthorizationStatus()
        expectation.fulfill()
        XCTAssertEqual(status,CLAuthorizationStatus.notDetermined)
        XCTAssertEqual(isEnabled,false)
        wait(for: [expectation], timeout: 1)
    }
    
    func test_CLAuthorizationStatusIsRestricted() {
        let expectation = XCTestExpectation(description: "wait for queue")
        locationManagerTest.autho = CLAuthorizationStatus.restricted
        let isEnabled = locationServiceTest?.locationManager?.isLocationServicesEnabled()
        let status = locationServiceTest?.locationManager?.getAuthorizationStatus()
        expectation.fulfill()
        XCTAssertEqual(status,CLAuthorizationStatus.restricted)
        XCTAssertEqual(isEnabled,false)
        wait(for: [expectation], timeout: 1)
    }
    
    func test_CLAuthorizationStatusIsAuthorizedAlways() {
        let expectation = XCTestExpectation(description: "wait for queue")
        locationManagerTest.autho = CLAuthorizationStatus.authorizedAlways
        let isEnabled = locationServiceTest?.locationManager?.isLocationServicesEnabled()
        let status = locationServiceTest?.locationManager?.getAuthorizationStatus()
        expectation.fulfill()
        XCTAssertEqual(status,CLAuthorizationStatus.authorizedAlways)
        XCTAssertEqual(isEnabled,true)
        wait(for: [expectation], timeout: 1)
    }
    
}

// MARK: - LocationServiceDelegate Extension

extension LocationServiceTests: LocationServiceDelegate {
    
    func onLocationUpdate(location: CLLocation) {
        currentLocation = location
        print("printSuperlocation = \(location)")
    }
    
    func onLocationDidFailWithError(error: Error) {}
    
    func onLocationHeadingUpdate(newHeading: CLHeading) {
        currentHeading = newHeading
        print("printSupernewHeading = \(newHeading)")
    }
}
