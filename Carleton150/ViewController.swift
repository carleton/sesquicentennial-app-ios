//
//  ViewController.swift
//  Carleton150

import UIKit
import GoogleMaps
import CoreLocation
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!

	@IBOutlet weak var Debug: UIButton!
    @IBOutlet weak var longText: UILabel!
    @IBOutlet weak var latText: UILabel!
    @IBAction func backFromModal(segue: UIStoryboardSegue) {
        
        // Switch to the first tab (tabs are numbered 0, 1, 2)
        self.tabBarController?.selectedIndex = 1
        
    }
    let locationManager = CLLocationManager()
    let currentLocationMarker = GMSMarker()
    var geofences = [Geotification]()
	var infoMarkers = [GMSMarker]()
	var circles = [GMSCircle]()
	var debugMode = false
	var updateLocation = true
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        mapView.camera = GMSCameraPosition.cameraWithLatitude(44.4619, longitude: -93.1538, zoom: 16)
		mapView.delegate = self;
        // brings subviews in front of the map.
        mapView.bringSubviewToFront(Debug)
        
        
    }
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "landmarkDetail") {
            let yourNextViewController = (segue.destinationViewController as! LandmarkDetailVC)
            let marker = sender as! GMSMarker
            yourNextViewController.nameText = marker.title
            yourNextViewController.descriptionText = marker.snippet
        }
    }

	
	@IBAction func toggleDebug(sender: AnyObject) {
		if (debugMode) {
			for (var i = 0; i < circles.count; i++) {
				circles[i].map = nil
			}
			mapView.sendSubviewToBack(latText)
			mapView.sendSubviewToBack(longText)
			debugMode = false
		} else {
			for (var i = 0; i < circles.count; i++) {
				circles[i].map = mapView
			}
			mapView.bringSubviewToFront(latText)
			mapView.bringSubviewToFront(longText)
			debugMode = true
		}
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
		
		latText.text = String(format:"%f", location.coordinate.latitude)
        longText.text = String(format:"%f", location.coordinate.longitude)
		
		// MARK: Get Nearby Geofences
		if (updateLocation) {
			for place in locationManager.monitoredRegions {
				locationManager.stopMonitoringForRegion(place)
			}
			let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude,longitude: location.coordinate.longitude)
			DataService.requestNearbyGeofences(position, completion:
				{ (success: Bool, result: [(name: String, radius: Int, center: CLLocationCoordinate2D)]? ) -> Void in
					if (success) {
						// scrap old geofences
						self.geofences = []
						// create geofences
						for geofence in result! {
							let circle: GMSCircle = GMSCircle(position: geofence.center, radius: Double(geofence.radius))
							circle.fillColor = UIColor.orangeColor().colorWithAlphaComponent(0.1)
//							circle.map = self.mapView
							self.circles.append(circle)
							let geotification = Geotification(coordinate: geofence.center, radius: Double(geofence.radius), identifier: geofence.name)
							self.geofences.append(geotification)
//							self.startMonitoringGeotification(geotification)
						}
					} else {
						print("Could not fetch data from the server.")
					}
				})
			self.updateLocation = false
		}
		
		// MARK: Check to see if geofence tripped
		for (var i = 0; i < geofences.count; i++) {
			let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude,longitude: location.coordinate.longitude)
			// If geofence triggered
			if (Utils.getDistance(currentLocation,point2: geofences[i].coordinate) <= geofences[i].radius) {
				if !(geofences[i].active) {
					enteredGeofence(geofences[i], mapView: mapView)
				}
			} else {
				if (geofences[i].active) {
					self.infoMarkers = exitedGeofence(geofences[i], infoMarkers: self.infoMarkers)
				}
			}
		}

    }
	
	func exitedGeofence(geofence: Geotification, var infoMarkers:[GMSMarker] ) -> [GMSMarker] {
		print("exited: ",geofence.identifier)
		if (infoMarkers.count > 3) {
			for (var i = 0; i < infoMarkers.count; i++) {
				if (infoMarkers[i].title == geofence.identifier) {
					infoMarkers[i].map = nil
					infoMarkers.removeAtIndex(i)
				}
			}
		}
		geofence.active = false;
		return infoMarkers
	}
	
	func enteredGeofence(geofence: Geotification, mapView: GMSMapView) -> Void {
		print("entered: ",geofence.identifier)
		DataService.requestContent(geofence.identifier,
		completion: { (success: Bool, result: Dictionary<String, String>?) -> Void in
			if (success) {
				var position = CLLocationCoordinate2DMake(44.46013,-93.15470)
				for (var i = 0; i < self.geofences.count; i++) {
					if (self.geofences[i].identifier == geofence.identifier) {
						position = self.geofences[i].coordinate
					}
				}
				let marker = GMSMarker(position: position)
				marker.title = geofence.identifier
//				marker.icon = UIImage(named: "flag_icon")
				marker.map = self.mapView
				marker.snippet = (result!["data"])!
				marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
				self.mapView.selectedMarker = marker
				self.infoMarkers.append(marker)
				geofence.active = true;
			} else {
				print("Didn't get data. Oops!")
			}
		})
	}
	
	func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
		mapView.selectedMarker = marker
		print(marker.title)
		return true
	}

	func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) -> Void {
        	self.performSegueWithIdentifier("landmarkDetail", sender: marker)
		print(marker.title)
	}
    
	
}


