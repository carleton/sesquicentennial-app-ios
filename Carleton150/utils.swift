//
//  utils.swift
//  Carleton150
//
//  Created by Chet Aldrich on 11/11/15.
//  Copyright © 2015 edu.carleton.carleton150. All rights reserved.
//

import Foundation
import Darwin

final class Utils {
    
    init () {}
    
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
    
    private class func degreesToRadians(degrees: Double) -> Double {
        return degrees * M_PI / 180
    }
    
}
