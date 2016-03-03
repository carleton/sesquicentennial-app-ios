//
//  Constants.swift
//  Carleton150

/// A container for some tunable preferences regarding location.
final class Constants {
    
    /**
        The distance threshold for getting new geofences
     */
    static let geofenceRequestThreshold: Double = 50 // meters
    
    /**
        The radius for the request for geofences.
     */
    static let geofenceRequestRadius: Int = 500 // meters
    
    /**
        The distance threshold for getting new memories.
     */
    static var memoriesRequestThreshold: Double = 100 // meters
    
    /**
        The distance threshold for determining if someone
        is off campus.
     */
    static let offCampusRadius: Double = 7000 // meters
    
    /**
        The radius for the request for memories off campus.
     */
    static var memoriesRequestRadiusOffCampus: Double = 5 // kilometers
    
    /**
        The radius for the request for memories on campus.
     */
    static var memoriesRequestRadiusOnCampus: Double = 0.2 // kilometers
    
    /**
        Maximum number of calendar events requested.
     */
    static let calendarEventsLimit: Int = 500 // meters
    
    /**
        Maximum number of calendar events requested.
     */
    static let questEventsLimit: Int = 500 // meters
    
}