//
//  QuestPlayingViewController.swift
//  Carleton150

import UIKit
import CoreLocation
import GoogleMaps

class QuestPlayingViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

	let locationManager = CLLocationManager()
	
	var quest: Quest!
	var currentWayPointIndex: Int! // @todo: Load this up from Core Data
	var clueShown: Bool = true
	
	@IBOutlet weak var questMapView: GMSMapView!
	@IBOutlet weak var clueHintView: UIView!
	@IBOutlet weak var questName: UILabel!
	@IBOutlet weak var clueHintImage: UIImageView!
	@IBOutlet weak var clueHintText: UITextView!
	@IBOutlet weak var clueHintToggle: UIButton!
	@IBOutlet weak var clueHintImgWidthConst: NSLayoutConstraint!
	@IBOutlet weak var attemptCompButton: UIButton!
	@IBOutlet weak var waypointsButton: UIButton!
	
	@IBAction func toggleClueHint(sender: AnyObject) {
		clueShown = !clueShown
		showClueHint()
	}
	
    override func viewDidLoad() {
		
		if let startedQuests = NSUserDefaults.standardUserDefaults().objectForKey("startedQuests") as! Dictionary<String,Int>! {
			if let curSavedIndex = startedQuests[self.quest.name] as Int! {
				self.currentWayPointIndex = curSavedIndex
			} else {
				self.currentWayPointIndex = 0
			}
		}

		// set properties for the navigation bar
		Utils.setUpNavigationBar(self)
		
		// start the location manager
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.requestAlwaysAuthorization()
		
		// center the camera and set the controller delegate for the map
		questMapView.camera = GMSCameraPosition.cameraWithLatitude(44.4619, longitude: -93.1538, zoom: 16) // @todo: Make this current location
		questMapView.delegate = self;
		
		// show waypoints button
		questMapView.bringSubviewToFront(waypointsButton)

		
		// set up tiling
		Utils.setUpTiling(questMapView)
		
		setupUI()
    }

	
	@IBAction func attemptCompletion(sender: AnyObject) {
	}
	
	func setupUI () {
		// setting up UI
		self.questName.text = quest.name
		if (self.currentWayPointIndex >= quest.wayPoints.count) {
			self.clueHintToggle.enabled = false
			self.clueHintToggle.setTitleColor(UIColor.grayColor(), forState: .Disabled)
			self.attemptCompButton.enabled = false
			self.attemptCompButton.backgroundColor = UIColor(red: 230/255, green: 159/255, blue: 19/255, alpha: 1)
			self.attemptCompButton.setTitle("Quest Completed", forState: UIControlState.Disabled)
			self.clueHintImage.image = UIImage(named: "quest_modal_completion_default")
			self.clueHintText.text = "Quest Has been completed!"
		} else if (self.currentWayPointIndex < quest.wayPoints.count) {
			showClueHint()
		}
	}
	
	func showClueHint() {
		if (clueShown) {
			clueHintText.text = quest.wayPoints[currentWayPointIndex].clue["text"] as? String
			clueHintToggle.setTitle("Show Hint", forState: UIControlState.Normal)
			if let imageData = quest.wayPoints[currentWayPointIndex].clue["image"] as? String {
				clueHintImage.image = UIImage(data: NSData(base64EncodedString: imageData, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
				clueHintImage.hidden = false
				clueHintImgWidthConst.constant = 0
			} else {
				clueHintImgWidthConst.constant = -clueHintView.frame.width * clueHintImgWidthConst.multiplier
				clueHintImage.hidden = true
			}
		} else {
			clueHintText.text = quest.wayPoints[currentWayPointIndex].hint["text"] as? String
			clueHintToggle.setTitle("Show Clue", forState: UIControlState.Normal)
			if let imageData = quest.wayPoints[currentWayPointIndex].hint["image"] as? String {
				clueHintImage.image = UIImage(data: NSData(base64EncodedString: imageData, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
				clueHintImage.hidden = false
				clueHintImgWidthConst.constant = 0
			} else {
				clueHintImgWidthConst.constant = -clueHintView.frame.width * clueHintImgWidthConst.multiplier
				clueHintImage.hidden = true
			}
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
		if segue.identifier == "questAttemptModal" {
			// get next controller
			let nextCtrl = segue.destinationViewController as! QuestModalViewController
			nextCtrl.parentView = self
			// check to see quest status
			if quest.wayPoints[currentWayPointIndex].checkIfTriggered(locationManager.location!.coordinate) {
				nextCtrl.isCorrect = true
				// increment waypointIndex and store it
				currentWayPointIndex!++
				if var startedQuests = NSUserDefaults.standardUserDefaults().objectForKey("startedQuests") as! Dictionary<String,Int>! {
					startedQuests[quest.name] = self.currentWayPointIndex
					NSUserDefaults.standardUserDefaults().setObject(startedQuests,forKey: "startedQuests")
				}
				// quest has been complete
				if (currentWayPointIndex == quest.wayPoints.count) {
					nextCtrl.isComplete = true
					if let compText = quest.completionMessage as String! {
						nextCtrl.descText = compText
					}
				// not completed
				} else if (currentWayPointIndex - 1 < quest.wayPoints.count) {
					nextCtrl.isComplete = false
					if let compText = quest.wayPoints[currentWayPointIndex - 1].completion["text"] as? String {
						nextCtrl.descText = compText
					}
					if let imageData = quest.wayPoints[currentWayPointIndex - 1].completion["image"] as? String {
						nextCtrl.image = UIImage(data: NSData(base64EncodedString: imageData, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
					}
					showClueHint()
				}
			} else {
				// this should be taken care of by the default settings in the QuestModalViewController
				nextCtrl.isComplete = false
				nextCtrl.isCorrect = false
			}
		} else if (segue.identifier == "showWaypoints") {
			// get next controller
			let nextCtrl = segue.destinationViewController as! WaypointsModalViewController
			nextCtrl.parentVC = self
			var waypoints = [WayPoint]()
			for (var i = 0; i < currentWayPointIndex; i++) {
				waypoints.append((self.quest?.wayPoints[i])!)
			}
			print(waypoints)
			nextCtrl.waypoints = waypoints
		}
	}
	
	/**
	The function immediately called by the location manager that
	begins keeping track of location to determine if the user is
	at a waypoint.
	
        Parameters:
            - manager: The location manager that was
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
}
