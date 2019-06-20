//
//  AppDelegate.swift
//  Carleton150

import GoogleMaps
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate  {

    var window: UIWindow?
    var keys: NSDictionary?
	var networkMonitor: Reachability?
	let locationManager = CLLocationManager()

    var schedule: [Dictionary<String, String>] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let defaults: UserDefaults = UserDefaults.standard
        // if the user doesn't have this boolean, 
        // that means they've opened the app for the 
        // first time, and we should show the tutorial.
        if !defaults.bool(forKey: "hasSeenTutorial") {
            defaults.set(false, forKey: "hasSeenTutorial")
        }
        
        defaults.synchronize()

        customizeNavigationBar()
		
        customizeTabBar()
		
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        
        if let _ = keys {
            let googleMapsApiKey = keys?["GoogleMaps"] as? String
            GMSServices.provideAPIKey(googleMapsApiKey!)
        }
       
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
		
		customizePageViews()

		// start monitoring network connection
		startNetworkMonitoring()
        
        return true
    }
	
	
	/**
		Setup instance of Reachability for Network Monitoring
	 */
	func startNetworkMonitoring() {
        // Allocate a reachability object
		self.networkMonitor = Reachability()
		// Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
        // This makes no sense to me. Removing -- MR
        //self.networkMonitor!.allowsCellularConnection = false
        do {
            try self.networkMonitor!.startNotifier()
        }catch{
            print("An Error occurred while trying to start the notifier")
        }
	}
	
	/**
        Performs UI changes to page views.
	 */
	func customizePageViews() {
		let pageController = UIPageControl.appearance()
		pageController.pageIndicatorTintColor = UIColor.lightGray
		pageController.currentPageIndicatorTintColor = UIColor.black
		pageController.backgroundColor = UIColor.white
	}

	/**
		Performs UI changes to the tab bar in the app.
     */
	func customizeTabBar() {

		UITabBar.appearance().barStyle = UIBarStyle.black

		let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(
            withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
		UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator

		UITabBar.appearance().barTintColor = UIColor(
			red: 10/255,
			green: 29/255,
			blue: 57/255,
			alpha: 1.0
		)
		
		UITabBar.appearance().tintColor = UIColor(
			red: 238/255,
			green: 177/255,
			blue: 17/255,
			alpha: 1.0
		)
	}
	
    /**
        Performs UI changes to the primary top navigation bar in the app.
     */
    func customizeNavigationBar() {
		
		UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
		UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMask")
		UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrow")
		UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
		
		UINavigationBar.appearance().barTintColor = UIColor(
			red: 10/255,
			green: 29/255,
			blue: 57/255,
			alpha: 1.0
		)

        UINavigationBar.appearance().tintColor = UIColor(red: 255.0/255.0,
            green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
		
		UINavigationBar.appearance().barStyle = UIBarStyle.black
		
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		UserDefaults.standard.synchronize()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Before resuming the active state on the app, reload calendar events
        CalendarDataService.getEvents()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		UserDefaults.standard.synchronize()
    }
    
    
}

extension String {
    
    /**
        Determines if a string contains a certain substring. 
        
        - Parameters:
            - find: The substring to find.
     
        - Returns: True if found inside the string, False otherwise.
     */
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
}

/// An extension to NSDate to provide simpler functions for comparison.
extension NSDate {
    
    /**
        If the current date object is later in time than 
        the other date return true, otherwise return false.
     */
    func isGreaterThanDate(_ dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending
    }
    
    /**
        If the current date object is earlier in time than
        the other date return true, otherwise return false.
     */
    func isLessThanDate(_ dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending
    }
    
    /**
        If the current date object is at the same time as
        the other date return true, otherwise return false.
     */
    func equalToDate(_ dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare as Date) == ComparisonResult.orderedSame
    }
    
    class func areDatesSameDay(_ dateOne: Date, dateTwo: Date) -> Bool {
        let calender = Calendar.current
        let flags: Set<Calendar.Component> = [.day, .month, .year]
        let compOne: DateComponents = calender.dateComponents(flags, from: dateOne)
        let compTwo: DateComponents = calender.dateComponents(flags, from: dateTwo)
        return (compOne.day == compTwo.day && compOne.month == compTwo.month && compOne.year == compTwo.year)
    }
    
    class func roundDownToNearestDay(_ date: Date) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.second = -calendar.component(Calendar.Component.second, from: date)
        components.minute = -calendar.component(Calendar.Component.minute, from: date)
        components.hour = -calendar.component(Calendar.Component.hour, from: date)
        return calendar.date(byAdding: components, to: date)!
    }
}
