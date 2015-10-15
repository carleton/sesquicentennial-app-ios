//
//  ViewController.swift
//  Carleton150
//
//  Created by Chet Aldrich on 10/8/15.
//  Copyright © 2015 edu.carleton.carleton150. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var longText: UILabel!
    @IBOutlet weak var latText: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    let currentLocationMarker = GMSMarker()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(44.4619, longitude: -93.1538, zoom: 16)

        let circleCenter: CLLocationCoordinate2D = CLLocationCoordinate2DMake(44.46015, -93.15470)
        let circle: GMSCircle = GMSCircle(position: circleCenter, radius: 40)
        circle.fillColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        circle.map = mapView
 

        // brings text subviews in front of the map.
        mapView.bringSubviewToFront(latText)
        mapView.bringSubviewToFront(longText)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        latText.text = String(format:"%f", location.coordinate.latitude)
        longText.text = String(format:"%f", location.coordinate.longitude)
        
    }

    

}


