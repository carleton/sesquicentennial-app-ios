//
//  WayPoint.swift
//  Carleton150

import Foundation

class WayPoint: NSObject {
    var location: CLLocationCoordinate2D
    var radius: Double
    var clue: String
    var hint: String
    
    init (location: CLLocationCoordinate2D, radius: Double, clue: String, hint: String) {
        self.location = location
        self.radius = radius
        self.clue = clue
        self.hint = hint
    }
    
    func checkIfTriggered(currentLocation: CLLocationCoordinate2D) -> Bool {
        return Utils.getDistance(currentLocation, point2: self.location) <= self.radius
    }
}