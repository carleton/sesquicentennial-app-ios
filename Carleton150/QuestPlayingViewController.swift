//
//  QuestPlayingViewController.swift
//  Carleton150
//
//  Created by Ibrahim Rabbani on 2/15/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

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
		questMapView.camera = GMSCameraPosition.cameraWithLatitude(44.4619, longitude: -93.1538, zoom: 16)
		questMapView.delegate = self;
		
		// set up tiling
		Utils.setUpTiling(questMapView)
		
		showClueHint()
		questName.text = quest.name
    }
	
	@IBAction func attemptCompletion(sender: AnyObject) {
		if quest.wayPoints[currentWayPointIndex].checkIfTriggered(locationManager.location!.coordinate) {
			// found the waypoint
//			let alert = UIAlertController(title: "You found it!", message: quest.completionMessage, preferredStyle: UIAlertControllerStyle.Alert)
//			let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
//			alert.addAction(alertAction)
			transitionToNextWayPoint()
//			presentViewController(alert, animated: true) { () -> Void in }
		} else {
			// did not find the waypoint
//			let alert = UIAlertController(title: "Not quite there yet!", message: "Keep trying!", preferredStyle: UIAlertControllerStyle.Alert)
//			let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
//			alert.addAction(alertAction)
//			presentViewController(alert, animated: true) { () -> Void in }
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

	func transitionToNextWayPoint() {
		self.currentWayPointIndex!++
		// quest has been completed
		if (currentWayPointIndex == quest.wayPoints.count) {
			print("Quest Completed")
			// diff stuff happens here
		} else if (currentWayPointIndex < quest.wayPoints.count) {
			showClueHint()
			if var startedQuests = NSUserDefaults.standardUserDefaults().objectForKey("startedQuests") as! Dictionary<String,Int>! {
				startedQuests[quest.name] = self.currentWayPointIndex
				NSUserDefaults.standardUserDefaults().setObject(startedQuests,forKey: "startedQuests")
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
			let nextCtrl = segue.destinationViewController as! QuestModalViewController
			// set completion text
			nextCtrl.parentView = self
			if let compText = quest.wayPoints[currentWayPointIndex].completion["text"] as? String {
				nextCtrl.descText = compText
			}
			if let imageData = quest.wayPoints[currentWayPointIndex].completion["image"] as? String {
				nextCtrl.image = UIImage(data: NSData(base64EncodedString: imageData, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
				nextCtrl.hasImage = true
			}
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
	
}
