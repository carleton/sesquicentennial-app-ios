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
    
    var schedule: [Dictionary<String, String>] = []

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if !defaults.boolForKey("hasSeenTutorial") {
            defaults.setBool(false, forKey: "hasSeenTutorial")
        }
        
        defaults.synchronize()

        customizeNavigationBar()
        
        if let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        
        if let _ = keys {
            let googleMapsApiKey = keys?["GoogleMaps"] as? String
            GMSServices.provideAPIKey(googleMapsApiKey)
        }
       
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
       
        // gets the calendar for the first time
        CalendarDataService.updateEvents()
		
		customizePageViews()
		
        return true
    }
	
	/**
	 * Performs Ui changes to page views
	 */
	func customizePageViews() {
		let pageController = UIPageControl.appearance()
		pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
		pageController.currentPageIndicatorTintColor = UIColor.blackColor()
		pageController.backgroundColor = UIColor.whiteColor()
	}
	
    /**
        Performs UI changes to the primary top navigation bar in the app.
     */
    func customizeNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 30.0/255.0,
            green: 69.0/255.0, blue: 119.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor(red: 255.0/255.0,
            green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		NSUserDefaults.standardUserDefaults().synchronize()
		print(NSUserDefaults.standardUserDefaults().objectForKey("startedQuests"))
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
    
    
}

extension String {
    
    /**
        Determines if a string contains a certain substring. 
        
        - Parameters:
            - find: The substring to find.
     
        - Returns: True if found inside the string, False otherwise.
     */
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}