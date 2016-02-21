//
//  Geotification.swift
//  Carleton150

import Foundation

import UIKit
import MapKit
import GoogleMaps
import CoreLocation

enum EventType: Int {
    case OnEntry = 0
    case OnExit
}

/// A geofence object with an activation.
class Geotification: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
	var marker: GMSMarker!
	var data: [Dictionary<String, String>?]!
	var requestingData: Bool = false
	
	init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
		self.marker = GMSMarker(position: self.coordinate)
    }
	
	/**
        Sets up and places a marker upon entering a geofence.
	
        - Parameters:
            - geofence: The geofence that was entered.
	
            - mapView:  The Google Maps view to attach the marker to.
	*/
	func enteredGeofence(mapview: GMSMapView) {
		if self.data == nil && !self.requestingData {
			self.requestingData = true
			HistoricalDataService.requestContent(self.identifier) {
				(success: Bool, result: [Dictionary<String, String>?]) -> Void in
				if (success) {
					if let data = result as [Dictionary<String, String>?]! {
						self.data = data
						self.marker.title = self.identifier
						self.marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
						self.marker.map = mapview
						self.marker.icon = UIImage(named: "marker.png")
					}
				}
				self.requestingData = false
			}
		} else {
			if self.marker.map == nil {
				self.marker.map = mapview
			}
		}
	}
	
	/**
        Takes a geofence off of the map if the geofence is not currently within
        the geofence search radius of the user's location. If there are fewer
        than 4, however, the points remain so that the user doesn't just lose everything
        that they could interact with.
	
        - Parameters:
            - geofence:    The geofence that was exited.
	
            - infoMarkers: The set of markers that are still currently in scope.
	
        - Returns: A new list of the current active geofences.
	
	*/
	func exitedGeofence() {
		self.marker.map = nil
	}
	
}

