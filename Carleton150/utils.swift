//
//  utils.swift
//  Carleton150

import Foundation
import Darwin

/// A class for miscellaneous utility functions relating to location.
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
    
}
