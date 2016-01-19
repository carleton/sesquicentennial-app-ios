//
//  Geotification.swift
//  Carleton150

import Foundation

import UIKit
import MapKit
import CoreLocation

enum EventType: Int {
    case OnEntry = 0
    case OnExit
}

class Geotification: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
	var active: Bool

    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
		self.active = false
    }
    
}

