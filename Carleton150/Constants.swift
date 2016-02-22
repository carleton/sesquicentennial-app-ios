//
//  Constants.swift
//  Carleton150

final class Constants {
    
    /**
        The distance threshold for getting new geofences
     */
    static var geofenceRequestThreshold: Double = 50 // meters
    
    /**
        The radius for the request for geofences.
     */
    static var geofenceRequestRadius: Int = 500 // meters
    
    /**
        The distance threshold for getting new memories
     */
    static var memoriesRequestThreshold: Double = 100 // meters
    
    /**
        The radius for the request for geofences.
     */
    static var memoriesRequestRadius: Int = 500 // meters
    
    /**
        Maximum number of calendar events requested
     */
    static var calendarEventsLimit: Int = 500 // meters
    
    /**
        Maximum number of calendar events requested
     */
    static var questEventsLim: Int = 500 // meters
    
}