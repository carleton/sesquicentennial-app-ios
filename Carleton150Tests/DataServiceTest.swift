//
//  DataServiceTest.swift
//  Carleton150
//
//  Created by Chet Aldrich on 11/3/15.
//  Copyright © 2015 edu.carleton.carleton150. All rights reserved.
//

import XCTest
@testable import Carleton150
import CoreLocation

class DataServiceTest: XCTestCase {
    
    func testRequestNearbyGeofences() {
        let location = CLLocationCoordinate2D(latitude: 44.4545784, longitude: -93.165487)
        let expected = [("hello", 1, CLLocationCoordinate2D(latitude: 15.2, longitude: 15.1))]
        let result = DataService.requestNearbyGeofences(location)
        XCTAssertEqual(expected[0].0, result[0].0)
        XCTAssertEqual(expected[0].1, result[0].1)
        XCTAssertEqual(expected[0].2.latitude, result[0].2.latitude)
        XCTAssertEqual(expected[0].2.longitude, result[0].2.longitude)
    }
    
}
