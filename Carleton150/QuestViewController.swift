//
//  QuestViewController.swift
//  Carleton150

import UIKit
import CoreLocation
import GoogleMaps

class QuestViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

	var quest: Quest!
    var currentWayPointIndex: Int = 0
	var initialDist: Double!
	let locationManager = CLLocationManager()
	
    @IBOutlet weak var hintText: UILabel!
	@IBOutlet weak var questName: UILabel!
    @IBOutlet weak var clueText: UILabel!
    @IBOutlet weak var QuestInfoStack: UIStackView!
    @IBOutlet var questMapView: GMSMapView!
	@IBOutlet weak var curProgress: UIProgressView!
    @IBOutlet weak var hintButton: UIButton!
   
    /**
        The button that, when pressed, shows or hides the current hint
        depending on the current state of the hint text.
     */
    @IBAction func getHint(sender: AnyObject) {
        hintText.hidden = !hintText.hidden
        hintButton.setTitle(hintText.hidden ? "Show" : "Hide", forState: UIControlState())
    }
    
    /**
        The button that, when pressed, checks to see if you're inside 
        the geofence. If so, you get a message
        and the next location. Otherwise, you get
        a message stating you haven't quite gotten there yet.
     */
    @IBAction func amIThere(sender: UIButton) {
        if quest.wayPoints[currentWayPointIndex].checkIfTriggered(locationManager.location!.coordinate) {
            // found the waypoint
			let alert = UIAlertController(title: "You found it!", message: quest.completionMessage, preferredStyle: UIAlertControllerStyle.Alert)
			let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
			alert.addAction(alertAction)
			presentViewController(alert, animated: true) { () -> Void in }
		} else {
            // did not find the waypoint
			let alert = UIAlertController(title: "Not quite there yet!", message: "Keep trying!", preferredStyle: UIAlertControllerStyle.Alert)
			let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
			alert.addAction(alertAction)
			presentViewController(alert, animated: true) { () -> Void in }
        }
    }
	
    /**
        Upon load of this view, start the location manager and
        set the camera on the map view to focus on Carleton. 
        Additionally, load the initial distance for the progress meter and the 
        clue.
     */
    override func viewDidLoad() {
        // show the logo on the top view
        Utils.showLogo(self)
        
        // set the quest text for the current waypoint
        self.questName.text = quest.name
        self.clueText.text = quest.wayPoints[currentWayPointIndex].clue
        self.hintText.text = quest.wayPoints[currentWayPointIndex].hint
       
        // hide the hint
        self.hintText.hidden = true
        
        // start the location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        
        // center the camera and set the controller delegate for the map
        questMapView.camera = GMSCameraPosition.cameraWithLatitude(44.4619, longitude: -93.1538, zoom: 16)
		questMapView.delegate = self;
        
        // set an initial distance
		initialDist = Utils.getDistance(locationManager.location!.coordinate, point2: self.quest.wayPoints.first!.location)
    }
    
    /**
        Performs a distance check from the waypoint
        to show the amount of progress to the goal
        location.
     
        Parameters: 
            - manager:   The location manager that was started 
                         within this module.
     
            - locations: The past few locations that were detected by 
                         the location manager.
     */
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location: CLLocationCoordinate2D = (locations.last?.coordinate)!
		let curDistance = Utils.getDistance(location, point2: self.quest.wayPoints.first!.location)
		if (curDistance <= 1000) {
			curProgress.progress = 0.5
		} else if (curDistance <= 500) {
			curProgress.progress = 0.8
		} else if (curDistance <= 100) {
			curProgress.progress = 1.0
		}
	}
	
    /**
        The function immediately called by the location manager that 
        begins keeping track of location to determine if the user is
        at a waypoint.
     
        Parameters: 
            - manager:                      The location manager that was
                                            started within this view.
     
            - didChangeAuthorizationStatus: The current authorization status for the user
                                            determining whether we can use location.
     */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
            questMapView.myLocationEnabled = true
            questMapView.settings.myLocationButton = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
