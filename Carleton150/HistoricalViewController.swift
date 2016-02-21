//
//  HistoricalViewController.swift
//  Carleton150

import UIKit
import GoogleMaps
import CoreLocation
import MapKit


class HistoricalViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var momentButton: UIButton!

    @IBOutlet weak var mapView: GMSMapView!
	@IBOutlet weak var Debug: UIButton!
    @IBOutlet weak var longText: UILabel!
    @IBOutlet weak var latText: UILabel!

	let locationManager: CLLocationManager = CLLocationManager()
	let currentLocationMarker: GMSMarker = GMSMarker()

	var geofences: Dictionary<String,Geotification>!
	var minRequestThreshold: Double = 10 // in meters
	var lastRequestLocation: CLLocation!
	var selectedGeofence: String!
	var debugMode: Bool = false
	var circles: [GMSCircle] = [GMSCircle]()

	
    /**
        Set to true to show the debug button for testing, set to false to hide
     */
    let showDebugButton = false
	
    /**
        Upon load of this view, start the location manager and
        set the camera on the map view to focus on Carleton.
     */
    override func viewDidLoad() {
		
		// initialize geofences dictionary
		self.geofences = Dictionary<String,Geotification>()
		
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
		mapView.camera = GMSCameraPosition.cameraWithTarget((self.locationManager.location?.coordinate)!, zoom: 16)
		mapView.delegate = self;
		
		self.lastRequestLocation = self.locationManager.location
		
        // set up the tiling for the map
        Utils.setUpTiling(mapView)
        
        // brings subviews in front of the map.
        if showDebugButton {
            mapView.bringSubviewToFront(Debug)
            mapView.bringSubviewToFront(momentButton)
        }
    }
	
	
	override func viewWillAppear(animated: Bool) {
		self.minRequestThreshold = 10
		self.updateGeofences(locationManager.location!)
		print("The min threshold is \(self.minRequestThreshold)")
	}
	
	override func viewWillDisappear(animated: Bool) {
		self.minRequestThreshold = 1000000
		print("The min threshold is \(self.minRequestThreshold)")
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
            
			let destinationController = (segue.destinationViewController as! TimelineViewController)
			destinationController.parentVC = self
			
			if let geofenceTitle = (sender?.title)! as String! {
				destinationController.selectedGeofence = geofenceTitle
				if let geofence = geofences[geofenceTitle] {
					destinationController.timeline = geofence.data
				}
			}
			

			
            // hide the memories button so it doesn't make the view busy
            self.momentButton.hidden = true
            
        } else if segue.identifier == "showMemories" {
            self.momentButton.hidden = true
			let destinationController = (segue.destinationViewController as! TimelineViewController)
			destinationController.parentVC = self
			destinationController.selectedGeofence = "Memories Near You"
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
		
		self.updateGeofences(curLocation)

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
		if (Utils.getDistance(curLocation.coordinate, point2: self.lastRequestLocation.coordinate) <= minRequestThreshold) {
			self.lastRequestLocation = curLocation
			return true
		}
		return false
	}
	
	func updateGeofenceVisibility(curLocation: CLLocation) {
		for (_,geofence) in self.geofences! {
			if (Utils.getDistance(curLocation.coordinate, point2: geofence.coordinate) <= geofence.radius) {
				geofence.enteredGeofence(self.mapView)
			}
		}
	}
	
	/**
		Checks to see if user has traveled more than the threshold distance, request geofences
		from the server and adds them to the current available geofences. Also changes visibility
		of current geofences
	 */
	func updateGeofences(curLocation: CLLocation) {
		// if the user has traveled far enough
		if (shouldUpdateLocation(curLocation)) {
			// get new geofences from server and save them
			HistoricalDataService.requestNearbyGeofences(curLocation.coordinate) {
				(success: Bool, result: [(name: String, radius: Int, center: CLLocationCoordinate2D)]? ) -> Void in
				if (success) {
					// create geofences
					for geofence in result! {
						if (self.showDebugButton) {
							let circle = GMSCircle( position: geofence.center, radius: Double(geofence.radius))
							circle.fillColor = UIColor.orangeColor().colorWithAlphaComponent(0.1)
							self.circles.append(circle)
						}
						let geotification = Geotification(coordinate: geofence.center, radius: Double(geofence.radius), identifier: geofence.name)
						if self.geofences[geofence.name] == nil {
							self.geofences[geofence.name] = geotification
						}
					}
					self.updateGeofenceVisibility(curLocation)
				} else {
					print("Could not nearby geofences from the server.")
				}
			}
		}
		self.updateGeofenceVisibility(curLocation)
	}
}


