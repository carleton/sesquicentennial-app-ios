//
//  AppDelegate.swift
//  Carleton150
//
//  Created by Chet Aldrich on 10/8/15.
//  Copyright © 2015 edu.carleton.carleton150. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate  {

    var window: UIWindow?
    var keys: NSDictionary?
    let locationManager = CLLocationManager()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        
        if let _ = keys {
            let googleMapsApiKey = keys?["GoogleMaps"] as? String
            GMSServices.provideAPIKey(googleMapsApiKey)
        }
        locationManager.delegate = self                // Add this line
        locationManager.requestAlwaysAuthorization()   // And this one
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func handleRegionEvent(region: CLRegion!) {
        print("enter!")
    }
    
    func handleRegionEvent2(region: CLRegion!) {
        print("exit!")
    }

    //you fire locationManager(_:didEnterRegion:) when the device enters a CLRegion, while you fire locationManager(_:didExitRegion:) when the device exits a CLRegion
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
            handleRegionEvent(region)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent2(region)
        }
    }
    //retrieves the geotification note from the persistence store, given the geotification identifier.



}

