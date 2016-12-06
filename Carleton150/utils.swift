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
        return degrees * M_PI / 180
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
    
    /**
        Builds the Carleton tiling on top of Google Maps.
     
        - Parameters: 
            - currentMap: the map view that we want to tile.
     */
    class func setUpTiling(_ currentMap: GMSMapView) {
        // Implement GMSTileURLConstructor
        // Returns a Tile based on the x, y, zoom coordinates
        let urlsBase = { (x: UInt, y: UInt, zoom: UInt) -> URL in
            let url = "https://www.carleton.edu/global_stock/images/campus_map/tiles/base/\(zoom)_\(x)_\(y).png"
            
            return URL(string: url)!
        }
        let urlsLabel = { (x: UInt, y: UInt, zoom: UInt) -> URL in
            let url = "https://www.carleton.edu/global_stock/images/campus_map/tiles/labels/\(zoom)_\(x)_\(y).png"
            
            return URL(string: url)!
        }
        
        // Create the GMSTileLayer
        let layerBase = GMSURLTileLayer(urlConstructor: urlsBase)
        let layerLabel = GMSURLTileLayer(urlConstructor: urlsLabel)
        
        // Display on the map at a specific zIndex
        layerBase.zIndex = 0
        layerBase.tileSize = 256
        layerBase.map = currentMap
        layerLabel.zIndex = 1
        layerLabel.tileSize = 256
        layerLabel.map = currentMap
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
