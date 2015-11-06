//
//  Carleton150UITests.swift
//  Carleton150UITests
//
//  Created by Chet Aldrich on 10/8/15.
//  Copyright © 2015 edu.carleton.carleton150. All rights reserved.
//

import XCTest

class Carleton150UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
//    //A geofence event is triggered only when iOS detects a boundary crossing. If the user is already within a geofence at the point of registration, iOS won’t generate an event. If you need to query whether the device location falls within or outside a given geofence, Apple provides a method called requestStateForRegion(_:).
//    func testExample() {
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
    
}
