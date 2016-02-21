//
//  Geotification.swift
//  Carleton150

import Foundation

import UIKit
import MapKit
import GoogleMaps
import CoreLocation

//enum EventType: Int {
//    case OnEntry = 0
//    case OnExit
//}

/// A geofence object with an activation.
class Geotification: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
	var marker: GMSMarker!
	var data: [Dictionary<String, String>?]!
	var isActive: Bool = false
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
		if !self.isActive {
			// set to active
			self.isActive = true
			// if no data or data isn't being requested
			if self.data == nil && !self.requestingData {
				// data being requested flag set
				self.requestingData = true
				// data requested from server
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
			} else if let _ = self.data {
				if self.marker.map == nil {
					self.marker.title = self.identifier
					self.marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
					self.marker.map = mapview
					self.marker.icon = UIImage(named: "marker.png")
				}
			}
		}
	}
//		if self.data == nil {
//			self.isActive = true
//			HistoricalDataService.requestContent(self.identifier) {
//				(success: Bool, result: [Dictionary<String, String>?]) -> Void in
//				if (success) {
//					if let data = result as [Dictionary<String, String>?]! {
//						self.data = data
//						self.marker.title = self.identifier
//						self.marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
//						self.marker.map = mapview
//						self.marker.icon = UIImage(named: "marker.png")
//					}
//				}
//				self.requestingData = false
//			}
//		}
//		}
//		// first time execution
//		if self.data == nil {
//			if self.requestingData == false {
//				self.requestingData = true
//				print(self.identifier)
//				HistoricalDataService.requestContent(self.identifier) {
//					(success: Bool, result: [Dictionary<String, String>?]) -> Void in
//					if (success) {
//						if let data = result as [Dictionary<String, String>?]! {
//							self.data = data
//							self.marker.title = self.identifier
//							self.marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
//							self.marker.map = mapview
//							self.marker.icon = UIImage(named: "marker.png")
//						}
//					}
//					self.requestingData = false
//				}
//			}
//		} else if (self.marker.map == nil && !self.requestingData) {
//			print("The data for \(self.identifier) is")
//			print(self.data)
//			self.marker.title = self.identifier
//			self.marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
//			self.marker.map = mapview
//			self.marker.icon = UIImage(named: "marker.png")
//		}
//	}

////		if self.data == nil && !self.requestingData {
//			self.requestingData = true
//			HistoricalDataService.requestContent(self.identifier) {
//				(success: Bool, result: [Dictionary<String, String>?]) -> Void in
//				if (success) {
//					if let data = result as [Dictionary<String, String>?]! {
//						self.data = data
//						self.marker.title = self.identifier
//						self.marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
//						self.marker.map = mapview
//						self.marker.icon = UIImage(named: "marker.png")
//					}
//				}
//				self.requestingData = false
//			}
//		} e{
//			if self.marker.map == nil {
//				print("The data for \(self.identifier) is")
//				print(self.data)
//				self.marker.title = self.identifier
//				self.marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
//				self.marker.map = mapview
//				self.marker.icon = UIImage(named: "marker.png")
//			}
//		}
//	}
	
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

