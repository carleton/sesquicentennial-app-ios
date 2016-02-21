//
//  HistoricalViewController.swift
//  Carleton150

import UIKit
import GoogleMaps
import CoreLocation
import MapKit

var selectedGeofence = ""
var landmarksInfo : Dictionary<String,[Dictionary<String, String>?]>? = Dictionary()

class HistoricalViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var momentButton: UIButton!

    @IBOutlet weak var mapView: GMSMapView!
	@IBOutlet weak var Debug: UIButton!
    @IBOutlet weak var longText: UILabel!
    @IBOutlet weak var latText: UILabel!
    
	let locationManager: CLLocationManager = CLLocationManager()
	let currentLocationMarker: GMSMarker = GMSMarker()
	var geofences: [Geotification] = [Geotification]()
	var infoMarkers: [GMSMarker] = [GMSMarker]()
	var circles: [GMSCircle] = [GMSCircle]()
	var debugMode: Bool = false
	var minRequestThreshold: Double = 10 // in meters
	var lastRequestLocation: CLLocation!
    
    /**
        Set to true to show the debug button for testing, set to false to hide
     */
    let showDebugButton = false
	
	
	override func viewWillAppear(animated: Bool) {
		self.minRequestThreshold = 10
		print("The min threshold is \(self.minRequestThreshold)")
	}
	
	override func viewWillDisappear(animated: Bool) {
		self.minRequestThreshold = 1000000
		print("The min threshold is \(self.minRequestThreshold)")
	}
	
    /**
        Upon load of this view, start the location manager and
        set the camera on the map view to focus on Carleton.
     */
    override func viewDidLoad() {
		
        // set up the memories button
        self.momentButton.layer.cornerRadius = 5
        self.momentButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.momentButton.layer.borderWidth = 1
        mapView.bringSubviewToFront(self.momentButton)
        
        // set properties for the navigation bar
        Utils.setUpNavigationBar(self)
        
        // set up the location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
		
        // set up the map view
        mapView.camera = GMSCameraPosition.cameraWithLatitude(44.4619, longitude: -93.1538, zoom: 16)
		mapView.delegate = self;
        
        // set up the tiling for the map
        Utils.setUpTiling(mapView)
        
        // brings subviews in front of the map.
        if showDebugButton {
            mapView.bringSubviewToFront(Debug)
            mapView.bringSubviewToFront(momentButton)
        }
    }
    
    /**
        Prepares for a segue to the detail view for a particular point of
        interest on the map.
     
        Parameters: 
            - segue:  The segue that was triggered by user. If this is not the
                      segue to the landmarkDetail view, then don't perform the
                      segue.
     
            - sender: The sender, in our case, will be one of the Google Maps markers
                      that was pressed, which will in turn have data associated with 
                      it that will given to the landmark detail view.
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showTimeline" {
            
            if let geofenceTitle = (sender?.title)! {
                selectedGeofence = geofenceTitle
            }
            
			let destinationController = (segue.destinationViewController as! TimelineViewController)
			destinationController.mapCtrl = self
            
            // hide the memories button so it doesn't make the view busy
            self.momentButton.hidden = true
            
        } else if segue.identifier == "showMemories" {
            selectedGeofence = "Memories Near You"
            self.momentButton.hidden = true
			let destinationController = (segue.destinationViewController as! TimelineViewController)
			destinationController.mapCtrl = self
            destinationController.showMemories = true
            destinationController.requestMemories()
        }
    }

    /**
        Debug function that shows the current available geofences
        and the current latitude and longitude coordinates.
     
        Parameters: 
            - sender: the button that was pressed to trigger this 
                      function, which is currently the button in the 
                      top right corner of the historical view.
     */
	@IBAction func toggleDebug(sender: AnyObject) {
		if (debugMode) {
			for i in 0 ..< circles.count {
				circles[i].map = nil
			}
			mapView.sendSubviewToBack(latText)
			mapView.sendSubviewToBack(longText)
			debugMode = false
		} else {
			for i in 0 ..< circles.count {
				circles[i].map = mapView
			}
			mapView.bringSubviewToFront(latText)
			mapView.bringSubviewToFront(longText)
			debugMode = true
		}
	}
	
    /**
        The function immediately called by the location manager that 
        begins keeping track of location for the various geofence triggers 
        that occur while walking around campus.
     
        Parameters: 
            - manager:                      The location manager that was
                                            started within this view.
     
            - didChangeAuthorizationStatus: The current authorization status for the user
                                            determining whether we can use location.
     */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
        
    }
    
    /**
        Performs geofence checking upon an update to the current location.
        Parameters: 
            - manager:   The location manager that was started 
                         within this module.
     
            - locations: The past few locations that were detected by 
                         the location manager.
     */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		let curLocation: CLLocation = locationManager.location!
		
		latText.text = String(format:"%f", curLocation.coordinate.latitude)
        longText.text = String(format:"%f", curLocation.coordinate.longitude)
		
		// Get Nearby Geofences (if distance threshold crossed)
		fetchGeofences(curLocation)
		
		// Manage Current Geofences
		for (var i = 0; i < geofences.count; i++) {
            // If a geofence is triggered...
			if (Utils.getDistance(curLocation.coordinate,point2: geofences[i].coordinate) <= geofences[i].radius) {
				if !(geofences[i].active) {
					enteredGeofence(geofences[i], mapView: mapView)
				}
			} else {
				if (geofences[i].active) {
					self.infoMarkers = exitedGeofence(geofences[i], infoMarkers: self.infoMarkers)
//					didExitGeofence(geofences[i])
				}
			}
        }
    }
	
    /**
        Selects a marker and shows the popover upon a tap from the user.
     
        Parameters:
            - mapView: The Google Maps view the marker is attached to.
     
            - didTapMarker: The marker that was tapped by the user.
     
     */
	func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        self.performSegueWithIdentifier("showTimeline", sender: marker)
		return true
	}

	func shouldUpdateLocation(curLocation: CLLocation) -> Bool {
		if self.lastRequestLocation != nil {
			if (Utils.getDistance(curLocation.coordinate, point2: self.lastRequestLocation.coordinate) >= minRequestThreshold) {
				self.lastRequestLocation = curLocation
				return true
			} else {
				return false
			}
		}
		self.lastRequestLocation = curLocation
		return true
	}
	
	/**
	Takes a geofence off of the map if the geofence is not currently within
	the geofence search radius of the user's location. If there are fewer
	than 4, however, the points remain so that the user doesn't just lose everything
	that they could interact with.
	
	Parameters:
	- geofence:    The geofence that was exited.
	
	- infoMarkers: The set of markers that are still currently in scope.
	
	Returns:
	- A new list of the current active geofences.
	
	*/
	func exitedGeofence(geofence: Geotification, infoMarkers:[GMSMarker] ) -> [GMSMarker] {
		var markers = infoMarkers
		if (infoMarkers.count > 10) {
			markers = infoMarkers.filter() {
				(marker: GMSMarker) in
				if marker.title == geofence.identifier {
					marker.map = nil
					return true
				} else {
					return false
				}
			}
		}
		geofence.active = false
		return markers
	}
	
	
	
	/**
	Sets up and places a marker upon entering a geofence.
	
	Parameters:
	- geofence: The geofence that was entered.
	
	- mapView:  The Google Maps view to attach the marker to.
	*/
	func enteredGeofence(geofence: Geotification, mapView: GMSMapView) -> Void {
		HistoricalDataService.requestContent(geofence.identifier) {
			(success: Bool, result: [Dictionary<String, String>?]) -> Void in
			
			if (success) {
				landmarksInfo![geofence.identifier] = result
				var position = CLLocationCoordinate2DMake(44.46013,-93.15470)
				for (var i = 0; i < self.geofences.count; i++) {
					if (self.geofences[i].identifier == geofence.identifier) {
						position = self.geofences[i].coordinate
					}
				}
				let marker = GMSMarker(position: position)
				marker.icon = UIImage(named: "marker.png")
				marker.title = geofence.identifier
				marker.map = self.mapView
				marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
				self.infoMarkers.append(marker)
				geofence.active = true;
			}
		}
	}

	func fetchGeofences (curLocation: CLLocation) -> Void {
		// Get any nearby geofences
		if (shouldUpdateLocation(curLocation)) {
			let position = curLocation.coordinate
			HistoricalDataService.requestNearbyGeofences(position) {
				(success: Bool, result: [(name: String, radius: Int, center: CLLocationCoordinate2D)]? ) -> Void in
				if (success) {
					print("Getting New Historical Data")
					// scrap old geofences
					self.geofences = []
					// create geofences
					for geofence in result! {
						let circle: GMSCircle = GMSCircle(position: geofence.center, radius: Double(geofence.radius))
						circle.fillColor = UIColor.orangeColor().colorWithAlphaComponent(0.1)
						self.circles.append(circle)
						let geotification = Geotification(coordinate: geofence.center, radius: Double(geofence.radius), identifier: geofence.name)
						self.geofences.append(geotification)
					}
				} else {
					print("Could not nearby geofences from the server.")
				}
			}
		}
	}
	
	
}


