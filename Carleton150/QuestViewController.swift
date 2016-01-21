//
//  QuestViewController.swift
//  Carleton150

import UIKit
import CoreLocation
import GoogleMaps

class QuestViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

	var quest: Quest!
    var currentWayPointIndex: Int = 0
    let locationManager = CLLocationManager()
	
	@IBOutlet weak var questName: UILabel!
    @IBOutlet weak var clueText: UILabel!
    @IBOutlet var questMapView: GMSMapView!
    
    @IBAction func amIThere(sender: UIButton) {
        if quest.wayPoints[currentWayPointIndex].checkIfTriggered(locationManager.location!.coordinate) {
            let alert = UIAlertView(
                title: "You did it!",
                message: self.quest.completionMessage,
                delegate: self,
                cancelButtonTitle: "OK")
            alert.show()
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
