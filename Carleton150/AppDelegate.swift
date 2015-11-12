//
//  AppDelegate.swift
//  Carleton150

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate  {

    var window: UIWindow?
    var keys: NSDictionary?
    let locationManager = CLLocationManager()
    var masterController: UIViewController!
    var alert: UIAlertController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        
        if let _ = keys {
            let googleMapsApiKey = keys?["GoogleMaps"] as? String
            GMSServices.provideAPIKey(googleMapsApiKey)
        }
       
        masterController = self.window!.rootViewController as? ViewController
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
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
    
    
 /**   func handleRegionEntry(region: CLRegion!) {
        let parameters = [
            "geofence": [
                "location" : [
                    "x" : 50,
                    "y" : 50
                ],
                "radius": 100
            ],
            "timespan": [
                "startTime":"",
                "endTime":""
            ]
        ]
		print("MEOW")
        /**Alamofire.request(.POST, "https://f37009fe.ngrok.io/landmarks", parameters: parameters, encoding: .JSON).responseJSON() {
            (request, response, result) in
 
            // given a successful request, we get the JSON object
            // and parse it.
            let json = JSON(result.value!)
            let origin = json["content"][0]["landmarks"][0].string
            if let alertBox = self.alert {
                if !alertBox.isBeingPresented() {
                self.alert = UIAlertController(title: "You found a landmark!", message: origin, preferredStyle: UIAlertControllerStyle.Alert)
                self.alert!.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.Default, handler: nil))
                self.masterController.presentViewController(self.alert!, animated: true, completion: nil)
                }
            }
            else {
                self.alert = UIAlertController(title: "You found a landmark!", message: origin, preferredStyle: UIAlertControllerStyle.Alert)
                self.alert!.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.Default, handler: nil))
                self.masterController.presentViewController(self.alert!, animated: true, completion: nil)
            }
        }**/
    }
    
    func handleRegionExit(region: CLRegion!) {
        print("exit!")
    }

    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // triggers upon entering a CLRegion
        handleRegionEntry(region)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        // triggers upon exiting a CLRegion
        handleRegionExit(region)
    }**/
    
}

