//
//  QuestViewController.swift
//  Carleton150

import UIKit
import CoreLocation
import GoogleMaps

class QuestViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

	var quest: Quest!
    var currentWayPointIndex: Int = 0
	var initialDist: Double = 100000.00
	let locationManager = CLLocationManager()
	
	@IBOutlet weak var questName: UILabel!
    @IBOutlet weak var clueText: UILabel!
    @IBOutlet var questMapView: GMSMapView!
	@IBOutlet weak var curProgress: UIProgressView!
	
    @IBAction func amIThere(sender: UIButton) {
        if quest.wayPoints[currentWayPointIndex].checkIfTriggered(locationManager.location!.coordinate) {
			let alert = UIAlertController(title: "You found it!", message: quest.completionMessage, preferredStyle: UIAlertControllerStyle.Alert)
			let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
			alert.addAction(alertAction)
			presentViewController(alert, animated: true) { () -> Void in }
		} else {
			let alert = UIAlertController(title: "Not quite there yet!", message: "Keep trying!", preferredStyle: UIAlertControllerStyle.Alert)
			let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
			alert.addAction(alertAction)
			presentViewController(alert, animated: true) { () -> Void in }
        }
    }
	
    override func viewDidLoad() {
        self.questName.text = quest.name
        self.clueText.text = quest.wayPoints[currentWayPointIndex].clue
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        questMapView.camera = GMSCameraPosition.cameraWithLatitude(44.4619, longitude: -93.1538, zoom: 16)
		questMapView.delegate = self;
		initialDist = Utils.getDistance(locationManager.location!.coordinate, point2: self.quest.wayPoints.first!.location)
    }
	
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
