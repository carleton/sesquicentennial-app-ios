//
//  HistoricalViewController.swift
//  Carleton150

import UIKit
import GoogleMaps
import CoreLocation
import MapKit
import Reachability

class HistoricalViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var momentButton: UIButton!
	@IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var recenterButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
	@IBOutlet weak var connectionIndicator: UIActivityIndicatorView!
	@IBOutlet weak var connectionLabel: UILabel!
	@IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var storiesButton: UIButton!
	
	let locationManager: CLLocationManager = CLLocationManager()
	var reach: Reachability?
	var networkMonitor: Reachability!
	var landmarks: Dictionary<String,Landmark>!
	
	// variables stored for caching the memories
	var loadedMemories: [Memory]!
	var lastMemReqLocation: CLLocation!
    
    let hideMemoriesFeature = true
	
    /**
        Upon load of this view, start the location manager and
        set the camera on the map view to focus on Carleton.
     */
    override func viewDidLoad() {
       
        // disables memories feature.
        self.momentButton.hidden = hideMemoriesFeature
        
        let defaults = NSUserDefaults.standardUserDefaults()
       
        // if the user is opening the app for the first time,
        if !defaults.boolForKey("hasSeenTutorial") {
            defaults.setBool(true, forKey: "hasSeenTutorial")
            // show the tutorial
            self.performSegueWithIdentifier("showTutorial", sender: nil)
        }
        defaults.synchronize()
		
		// initialize geofences dictionary
		self.landmarks = Dictionary<String,Landmark>()
		
        // set up the stories button
		self.storiesButton.layer.cornerRadius = 5
		self.storiesButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
		self.storiesButton.layer.borderWidth = 1
        
		// set up the memories button and the question button
		self.momentButton.layer.cornerRadius = 5
		self.momentButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
		self.momentButton.layer.borderWidth = 1
       
		mapView.bringSubviewToFront(self.momentButton)
		mapView.bringSubviewToFront(self.questionButton)
        mapView.bringSubviewToFront(self.storiesButton)
        mapView.bringSubviewToFront(self.recenterButton)
		
        // set properties for the navigation bar
        Utils.setUpNavigationBar(self)
        
        // set up the location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
	
        // set up current map location based on the user's location, if possible.
		if let curLocation = self.locationManager.location {
			self.mapView.camera = GMSCameraPosition.cameraWithTarget(curLocation.coordinate, zoom: 16)
		} else {
			mapView.camera = GMSCameraPosition.cameraWithLatitude(44.4619, longitude: -93.1538, zoom: 16)
		}
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		self.networkMonitor = appDelegate.networkMonitor
		
		// set up the map view
		mapView.delegate = self
		
        // set up the tiling for the map
        Utils.setUpTiling(mapView)
        
        loadLandmarks(locationManager.location?.coordinate)
	}
    
    @IBAction func recenterOnCarleton(sender: AnyObject) {
		mapView.camera = GMSCameraPosition.cameraWithLatitude(44.4619, longitude: -93.1538, zoom: 16)
    }
    
    /**
        Requests the geofences from the server. 
     */
    func loadLandmarks(currentLocation: CLLocationCoordinate2D?) {
        if let currentLocation = currentLocation {
            HistoricalDataService.requestNearbyGeofences(currentLocation) {
                (success: Bool, result: [(name: String, radius: Int, center: CLLocationCoordinate2D)]? ) -> Void in
                if (success) {
                    // create geofences
                    for entry in result! {
                        let landmark = Landmark(coordinate: entry.center, identifier: entry.name)
                        if self.landmarks[entry.name] == nil {
                            self.landmarks[entry.name] = landmark
                        }
                    }
                    
                    for entry in self.landmarks {
                        entry.1.displayLandmark(self.mapView)
                    }
                    
                } else {
                    print("Could not nearby landmarks from the server.")
                }
            }
        }
    }
	
    
	/**
		Called by observer every time the internet connection changes.
        Toggles UI elements to show the current state of the connection.
		
		Parameters
			- notification: notification sent by observer
	*/
	func connectionStatusChanged(notification: NSNotification) {
		if self.networkMonitor!.isReachableViaWiFi() || self.networkMonitor!.isReachableViaWWAN()
        {
            self.connectionLabel.hidden = true
            self.connectionIndicator.stopAnimating()
            self.connectionIndicator.hidden = true
            self.connectionView.hidden = true
            self.mapView.sendSubviewToBack(self.connectionView)
            self.loadLandmarks(locationManager.location?.coordinate)
		} else {
			self.connectionLabel.hidden = false
			self.connectionIndicator.startAnimating()
			self.connectionIndicator.hidden = false
			self.connectionView.hidden = false
            self.mapView.bringSubviewToFront(self.connectionView)
		}
	}
	
	
    /**
        If the view is about to appear, lower the threshold
        for requests so that smaller distance differences will
        cause a request to be triggered, and then update the 
        geofences based on the curent location.
     */
	override func viewWillAppear(animated: Bool) {
		// Setup networking monitoring
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: #selector(HistoricalViewController.connectionStatusChanged(_:)),
			name: kReachabilityChangedNotification,
			object: nil
		)
		// check to see if connected
		self.connectionStatusChanged(
			NSNotification(
				name: "Initial Connection Check",
				object: nil
			)
		)
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
			
			if let landmarkName = (sender?.title)! as String! {
				destinationController.selectedGeofence = landmarkName
				if let landmark = landmarks[landmarkName] {
					destinationController.timeline = landmark.data
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
			// memories loading and caching options
			if let curMemories = self.loadedMemories {
				destinationController.memories = curMemories
			}
			if let lastLoc = self.lastMemReqLocation {
				destinationController.lastRequestLocation = lastLoc
			}
        } else if segue.identifier == "showTutorial" {
			let destinationController = (segue.destinationViewController as! TutorialViewController)
			destinationController.parent = self
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
        Selects a marker and shows the popover upon a tap from the user.
     
        Parameters:
            - mapView: The Google Maps view the marker is attached to.
     
            - didTapMarker: The marker that was tapped by the user.
     */
	func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        self.performSegueWithIdentifier("showTimeline", sender: marker)
		return true
	}
}