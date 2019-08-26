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

    
    let locationManagerTest = MockLocationManager()
    var currentLocation: CLLocation?
    var currentHeading: CLHeading?
    var locationServiceTest : LocationService?
    
    
    override func setUp() {
        locationServiceTest = LocationService(locationManagerTest: locationManagerTest)
        locationServiceTest?.delegate = self
    }
    
    func test_getCurrentLocation_returnsExpectedLocation() {
        
        guard let latitudeFirst = locationServiceTest?.currentLocation?.coordinate.latitude else {return}
        guard let latitudeFirstMock = locationManagerTest.location?.coordinate.latitude else {return}
        XCTAssertEqual(latitudeFirst,latitudeFirstMock)
        
        guard let longitudeFirst = locationServiceTest?.currentLocation?.coordinate.longitude else {return}
        guard let longitudeFirstMock = locationManagerTest.location?.coordinate.longitude else {return}
        XCTAssertEqual(longitudeFirst,longitudeFirstMock)
        
        let expectedLocation = CLLocation(latitude: 37.3317, longitude: -122.0325086)
        locationServiceTest?.delegate?.onLocationUpdate(location: expectedLocation)
        
        guard let latitude = currentLocation?.coordinate.latitude else {return}
        guard let longitude = currentLocation?.coordinate.longitude else {return}
        XCTAssertEqual(latitude,expectedLocation.coordinate.latitude)
        XCTAssertEqual(longitude,expectedLocation.coordinate.longitude)
        //        }
        //        wait(for: [completionExpectation], timeout: 1)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_CLAuthorizationStatusIsWhenInUse() {
        locationManagerTest.autho = CLAuthorizationStatus.authorizedAlways
        let isEnabled = locationServiceTest?.locationManager?.isLocationServicesEnabled()
        let status = locationServiceTest?.locationManager?.getAuthorizationStatus()
        
        XCTAssertEqual(status,CLAuthorizationStatus.authorizedAlways)
        
        XCTAssertEqual(isEnabled,true)
    }
    
    func test_CLAuthorizationStatusIsDenied() {
        locationManagerTest.autho = CLAuthorizationStatus.denied
        let isEnabled = locationServiceTest?.locationManager?.isLocationServicesEnabled()
        let status = locationServiceTest?.locationManager?.getAuthorizationStatus()
        
        XCTAssertEqual(status,CLAuthorizationStatus.denied)
        XCTAssertEqual(isEnabled,false)
    }
    
    func test_CLAuthorizationStatusIsNotDetermined() {
        locationManagerTest.autho = CLAuthorizationStatus.notDetermined
        let isEnabled = locationServiceTest?.locationManager?.isLocationServicesEnabled()
        let status = locationServiceTest?.locationManager?.getAuthorizationStatus()
        
        XCTAssertEqual(status,CLAuthorizationStatus.notDetermined)
        XCTAssertEqual(isEnabled,false)
    }
    
    func test_CLAuthorizationStatusIsRestricted() {
        locationManagerTest.autho = CLAuthorizationStatus.restricted
        let isEnabled = locationServiceTest?.locationManager?.isLocationServicesEnabled()
        let status = locationServiceTest?.locationManager?.getAuthorizationStatus()
        
        XCTAssertEqual(status,CLAuthorizationStatus.restricted)
        XCTAssertEqual(isEnabled,false)
    }
    
    func test_CLAuthorizationStatusIsAuthorizedAlways() {
        locationManagerTest.autho = CLAuthorizationStatus.authorizedAlways
        let isEnabled = locationServiceTest?.locationManager?.isLocationServicesEnabled()
        let status = locationServiceTest?.locationManager?.getAuthorizationStatus()
        
        XCTAssertEqual(status,CLAuthorizationStatus.authorizedAlways)
        
        XCTAssertEqual(isEnabled,true)
    }
    
}

extension LocationServiceTests: LocationServiceDelegate {
    
    func onLocationUpdate(location: CLLocation) {
        currentLocation = location
        print("printSuperlocation = \(location)")
    }
    
    func onLocationDidFailWithError(error: Error) {
        
    }
    
    func onLocationHeadingUpdate(newHeading: CLHeading) {
        currentHeading = newHeading
        print("printSupernewHeading = \(newHeading)")
    }
}
