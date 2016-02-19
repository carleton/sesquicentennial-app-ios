//
//  QuestPlayingViewController.swift
//  Carleton150

import UIKit
import CoreLocation
import GoogleMaps

class QuestPlayingViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

	let locationManager = CLLocationManager()
	
	var quest: Quest!
	var currentWayPointIndex: Int!
	var clueShown: Bool = true
	var questCompleted: Bool = false
	
	@IBOutlet weak var questMapView: GMSMapView!
	@IBOutlet weak var clueHintView: UIView!
	@IBOutlet weak var questName: UILabel!
	@IBOutlet weak var clueHintImage: UIImageView!
	@IBOutlet weak var clueHintText: UITextView!
	@IBOutlet weak var clueHintToggle: UIButton!
	@IBOutlet weak var clueHintImgWidthConst: NSLayoutConstraint!
	@IBOutlet weak var attemptCompButton: UIButton!
	@IBOutlet weak var waypointsButton: UIButton!
	

	
    override func viewDidLoad() {
		
		// Loads stored waypoint for the quest from NSUserDefaults
		if let startedQuests = NSUserDefaults.standardUserDefaults().objectForKey("startedQuests") as! Dictionary<String,Int>! {
			if let curSavedIndex = startedQuests[self.quest.name] as Int! {
				self.currentWayPointIndex = curSavedIndex
			} else {
				self.currentWayPointIndex = 0
			}
			
		}
		
		if (self.currentWayPointIndex >= quest.wayPoints.count) {
			questCompleted = true;
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
	
	
	/**
		Upon clicking the attemptCompButton, the quest will either restart
		or perform a segue to the attempt modal
	
		- Parameters:
			- sender: The UI button attemptCompButton
	*/
	@IBAction func attemptCompletion(sender: AnyObject) {
	}
	
	/**
		Upon clicking the show hint / show clue button, the UI shows a clue or a hint
	
		- Parameters:
			- sender: The UI button clueHintToggle
	 */
	@IBAction func toggleClueHint(sender: AnyObject) {
		clueShown = !clueShown
		showClueHint()
	}
	
	/**
		Sets up the entire UI for the ClueHintView. Checks to see if the quest has been completed
		and disables UI elements based on that
		@todo: add a restart quest button
	 */
	func setupUI () {
		// setting up UI
		self.questName.text = quest.name
		if (self.currentWayPointIndex >= quest.wayPoints.count) {
			self.clueHintToggle.enabled = false
			self.clueHintToggle.setTitleColor(UIColor.grayColor(), forState: .Disabled)
			self.attemptCompButton.backgroundColor = UIColor(red: 230/255, green: 159/255, blue: 19/255, alpha: 1)
			self.attemptCompButton.setTitle("Quest Completed: Restart?", forState: UIControlState.Normal)
			self.clueHintImage.image = UIImage(named: "quest_modal_completion_default")
			self.clueHintText.text = "Quest Has been completed!"
		} else if (self.currentWayPointIndex < quest.wayPoints.count) {
			showClueHint()
		}
	}
	
	
	/**
		Creates part of the UI for the ClueHintView. Chooses between the hint and clue based on
		the clueShown bool. If the item on display does not have an image associated
		with it, it sets the width of the imageview to zero by manipulating its width 
		constraint
	 */
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
		Suppress segue to the attempt modal if the quest has been completed. Instead, restart quest
		
		- Parameters:
			- identifier: segue identifier from storyboard
			- sender: the sender, in our case will be either the attemptCompButton or the
					  waypointsButton
		
		- Returns: true if questAttemptModal segue and quest has been completed
	
	 */
	override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
		// restart quest
		if (identifier == "questAttemptModal") {
			// if quest has been completing suppress this segue
			if (questCompleted) {
				self.currentWayPointIndex = 0
				self.attemptCompButton.setTitle("Are We There Yet?", forState: .Normal)
				self.attemptCompButton.backgroundColor = UIColor(red: 254/255, green: 214/255, blue: 70/255, alpha: 1)
				self.clueHintToggle.enabled = true
				showClueHint()
				questCompleted = false

				print("Stopping Segue")
				return false
			}
			return true
		}
		return true
	}
	
	/**
		Prepares for a segue to another view. In the case, there are two possible segues:
		one to the attempt modal triggered by the Are We There Yet? button and the other
		to the completed waypoints modal triggered by the button on the map
		
		Parameters:
			- segue:  The segue that was triggered by user. Either to the attempt modal
					  or the completed waypoints modal
			- sender: The sender, in our case, will be either the attemptCompButton
					  or waypointsButton
	*/
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		/**
		 * Attempt Modal
		 */
		if segue.identifier == "questAttemptModal" {
			// get next controller
			let nextCtrl = segue.destinationViewController as! QuestModalViewController
			nextCtrl.parentVC = self
			// check to see quest status
			if quest.wayPoints[currentWayPointIndex].checkIfTriggered(locationManager.location!.coordinate) {
				nextCtrl.isCorrect = true
				// increment waypointIndex and store it
				currentWayPointIndex!++
				// store the waypoint 
				if var startedQuests = NSUserDefaults.standardUserDefaults().objectForKey("startedQuests") as! Dictionary<String,Int>! {
					startedQuests[quest.name] = currentWayPointIndex
					NSUserDefaults.standardUserDefaults().setObject(startedQuests,forKey: "startedQuests")
				}
				// check to see if quest has been completed
				if (self.currentWayPointIndex >= self.quest.wayPoints.count) {
					self.questCompleted = true
				}
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
		/**
		 * Completed waypoints modal
		 */
		} else if (segue.identifier == "showWaypoints") {
			// get next controller
			let nextCtrl = segue.destinationViewController as! WaypointsModalViewController
			nextCtrl.parentVC = self
			var waypoints = [WayPoint]()
			for (var i = 0; i < currentWayPointIndex; i++) {
				waypoints.append((self.quest?.wayPoints[i])!)
			}
			nextCtrl.waypoints = waypoints
		}
	}
	
	/**
		The function immediately called by the location manager that
		begins keeping track of location to determine if the user is
		at a waypoint.
	
        Parameters:
            - manager: The location manager that was started within this view.
        
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
