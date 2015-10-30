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
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var longText: UILabel!
    @IBOutlet weak var latText: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    let currentLocationMarker = GMSMarker()
    var geotifications = [Geotification]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(44.4619, longitude: -93.1538, zoom: 16)
 
        // brings text subviews in front of the map.
        mapView.bringSubviewToFront(latText)
        mapView.bringSubviewToFront(longText)
        
        
        loadAllGeotifications(mapView)
        
    }
    
    override func viewDidAppear(animated: Bool) {

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
        
    }
    
    
    func regionWithGeotification(geotification: Geotification) -> CLCircularRegion {
        
        // initialize radius of geofence
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        
        // specify whether geofence events will be triggered
        // when the device enters and leaves the defined geofence
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    func startMonitoringGeotification(geotification: Geotification) {
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            print("Geofencing is not supported on this device!")
            return
        }
        let region = regionWithGeotification(geotification)
        locationManager.startMonitoringForRegion(region)
    }
    
    
    func loadAllGeotifications(mapView:GMSMapView) {
        geotifications = []
        let centers = [CLLocationCoordinate2DMake(44.460131, -93.15472)]
            for circleCenter in centers {
                let circle: GMSCircle = GMSCircle(position: circleCenter, radius: 30)
                circle.fillColor = UIColor.orangeColor().colorWithAlphaComponent(0.5)
                circle.map = mapView
                let geotification = Geotification(coordinate: circleCenter, radius: 30, identifier: "xxx")
                geotifications.append(geotification)
                startMonitoringGeotification(geotification)
            
        }
    }
}


