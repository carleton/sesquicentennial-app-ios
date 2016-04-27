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
    class func getDistance(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {
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
    private class func degreesToRadians(degrees: Double) -> Double {
        return degrees * M_PI / 180
    }
    
    /**
        Builds the Carleton tiling on top of Google Maps.
     
        - Parameters: 
            - currentMap: the map view that we want to tile.
     */
    class func setUpTiling(currentMap: GMSMapView) {
        // Implement GMSTileURLConstructor
        // Returns a Tile based on the x, y, zoom coordinates
        let urlsBase = { (x: UInt, y: UInt, zoom: UInt) -> NSURL in
            let url = "https://www.carleton.edu/global_stock/images/campus_map/tiles/base/\(zoom)_\(x)_\(y).png"
            
            return NSURL(string: url)!
        }
        let urlsLabel = { (x: UInt, y: UInt, zoom: UInt) -> NSURL in
            let url = "https://www.carleton.edu/global_stock/images/campus_map/tiles/labels/\(zoom)_\(x)_\(y).png"
            
            return NSURL(string: url)!
        }
        
        // Create the GMSTileLayer
        let layerBase = GMSURLTileLayer(URLConstructor: urlsBase)
        let layerLabel = GMSURLTileLayer(URLConstructor: urlsLabel)
        
        // Display on the map at a specific zIndex
        layerBase.zIndex = 0
        layerBase.tileSize = 256
        layerBase.map = currentMap
        layerLabel.zIndex = 1
        layerLabel.tileSize = 256
        layerLabel.map = currentMap
    }
    
    /**
        Shows the Carleton logo and sets the translucency of 
        the top navigation bar in the designated view.
     */
    class func setUpNavigationBar(currentController: UIViewController) {
        // stop the navigation bar from covering the calendar content
        if let navigator = currentController.navigationController {
            navigator.navigationBar.translucent = false;
        }
    }
    
}
