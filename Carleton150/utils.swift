//
//  utils.swift
//  Carleton150

import Foundation
import Darwin
import GoogleMaps

/// A class for utility functions that are required for multiple views.
final class Utils {
    
    /**
        Finds the distance (in meters) between two
        latitude and longitude coordinates.

        - Parameters:
            - point1: First coordinate.
            - point2: Second coordinate.

        - Returns: The distance (in meters) between the two points.
     */
    class func getDistance(_ point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {
        let radius: Double = 6378137
        let Φ_1 = degreesToRadians(point1.latitude)
        let Φ_2 = degreesToRadians(point2.latitude)
        let ΔΦ = degreesToRadians(point1.latitude - point2.latitude)
        let ΔΛ = degreesToRadians(point1.longitude - point2.longitude)
        let a = sin(ΔΦ / 2) * sin(ΔΦ / 2) +
                cos(Φ_1) * cos(Φ_2) *
                sin(ΔΛ / 2) * sin(ΔΛ / 2)
        return (2 * atan2(sqrt(a), sqrt(1 - a))) * radius
    }
    
    /**
        Performs a degree to radian conversion.

        - Parameters:
            - degrees: Quantity (in degrees) to convert.

        - Returns: The equivalent radian quantity for a given number of degrees.
     */
    fileprivate class func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }
    
    /**
        Determines whether the user is off campus.
     
        - Parameters: 
            - location: The user's current location.
     
        - Returns: Whether the user is off campus as a boolean.
     */
    class func userOffCampus(_ location : CLLocationCoordinate2D) -> Bool {
        let centerPoint = CLLocationCoordinate2D(latitude: 44.460421, longitude: -93.152749)
        let distance = Utils.getDistance(centerPoint, point2: location)
        return distance > 7000
    }
    
    class func getUserAgent() -> String {
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let userAgent = "ReunionApp  \(appVersion)";
        print("User agent is \(userAgent)")
        return userAgent
    }
    
    /**
        Sets the translucency of the top navigation bar in the designated view.
     */
    class func setUpNavigationBar(_ currentController: UIViewController) {
        // stop the navigation bar from covering the calendar content
        if let navigator = currentController.navigationController {
            navigator.navigationBar.isTranslucent = false;
        }
    }
    
}
