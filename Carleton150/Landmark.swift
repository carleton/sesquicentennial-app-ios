//
//  Geotification.swift
//  Carleton150

import UIKit
import MapKit
import GoogleMaps
import CoreLocation

/// A Landmark object for containing location and historical information.
class Landmark: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let identifier: String
	let marker: GMSMarker!
	var data: [Dictionary<String, String>?]!
    let events: [Event]!
	
    init(coordinate: CLLocationCoordinate2D, identifier: String, events: [Event]) {
        self.coordinate = coordinate
        self.identifier = identifier
        self.events = events
		self.marker = GMSMarker(position: self.coordinate)
    }
	
	/**
        Sets up and places a marker for a landmark.
	
        - Parameters:
            - mapView:  The Google Maps view to which we attach the marker.
	*/
	func displayLandmark(mapView: GMSMapView) {
        if let _ = self.events {
            if self.marker.map == nil {
                self.marker.title = self.identifier
                self.marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
                self.marker.map = mapView
                self.marker.icon = UIImage(named: "marker.png")
            }
        }
	}
}

