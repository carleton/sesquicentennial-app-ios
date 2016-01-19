//
//  QuestViewController.swift
//  Carleton150
//

import UIKit
import GoogleMaps
import CoreLocation
import MapKit

class QuestViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
	
	//
	@IBOutlet weak var mapView: GMSMapView!
	let locationManager = CLLocationManager()
	let currentLocationMarker = GMSMarker()
	
    override func viewDidLoad() {
		super.viewDidLoad()
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.requestAlwaysAuthorization()
		mapView.camera = GMSCameraPosition.cameraWithLatitude(44.4619, longitude: -93.1538, zoom: 16)
		mapView.delegate = self;
		// brings subviews in front of the map.
//		mapView.bringSubviewToFront(Debug)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedAlways {
			locationManager.startUpdatingLocation()
			mapView.myLocationEnabled = true
			mapView.settings.myLocationButton = true
		}
	}
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
