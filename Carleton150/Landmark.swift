//
//  Geotification.swift
//  Carleton150

import Foundation

import UIKit
import MapKit
import GoogleMaps
import CoreLocation

/// A Landmark object for containing location and historical information.
class Landmark: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var identifier: String
	var marker: GMSMarker!
	var data: [Dictionary<String, String>?]!
	
	init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
		self.marker = GMSMarker(position: self.coordinate)
    }
	
	/**
        Sets up and places a marker for a landmark.
	
        - Parameters:
            - geofence: The geofence that was entered.
	
            - mapView:  The Google Maps view to attach the marker to.
	*/
	func displayLandmark(mapview: GMSMapView) {
        if let _ = self.data {
            if self.marker.map == nil {
                self.marker.title = self.identifier
                self.marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
                self.marker.map = mapview
                self.marker.icon = UIImage(named: "marker.png")
            }
        } else {
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
            }
        }
	}
}

