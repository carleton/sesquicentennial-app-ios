//
//  WayPoint.swift
//  Carleton150

import Foundation

class WayPoint: NSObject {
    var location: CLLocationCoordinate2D
    var radius: Double
    var clue: String
    var hint: String
   
    /**
        Constructor for a WayPoint object in a Quest. 
        
        Parameters: 
            - location: The lat/long coordinate location of the waypoint.
            - radius: The size of monitoring for the waypoint.
            - clue: The associated clue to find this waypoint.
            - hint: The associated hint to find this waypoint.
     */
    init (location: CLLocationCoordinate2D, radius: Double, clue: String, hint: String) {
        self.location = location
        self.radius = radius
        self.clue = clue
        self.hint = hint
    }
    
    /**
        Checks to see if the user is within monitoring radius 
        for the waypoint.
        
        Parameters: 
            - currentLocation: The user's current lat/long coordinate location.
     
        Returns: A boolean stating whether the user is within the waypoint.
     */
    func checkIfTriggered(currentLocation: CLLocationCoordinate2D) -> Bool {
        return Utils.getDistance(currentLocation, point2: self.location) <= self.radius
    }
}