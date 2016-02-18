//
//  Endpoints.swift
//  Carleton150

import Foundation

/// A class for managing the data service endpoints in the application.
final class Endpoints {
   
    /**
        The current server API url.
     */
    static var hostServerURL: String = "https://carl150.carleton.edu"
   
    /**
        The current events endpoint in the API.
     */
    static var calendar: String {
        get {
            return self.hostServerURL + "/events"
        }
    }
    
    /**
        The current geofences endpoint in the API.
     */
    static var geofences: String {
        get {
            return self.hostServerURL + "/geofences"
        }
    }
    
    /**
        The current historical information endpoint in the API.
     */
    static var historicalInfo: String {
        get {
            return self.hostServerURL + "/info"
        }
    }
    
    /**
        The current quests endpoint in the API.
     */
    static var quests: String {
        get {
			return self.hostServerURL + "/quest_re"
        }
    }
    
    /**
        The current memory fetching endpoint in the API.
     */
    static var memoriesInfo: String {
        get {
           return self.hostServerURL + "/memories_fetch"
        }
    }
    
    /**
        The current memory uploading endpoint in the API.
     */
    static var addMemory: String {
        get {
           return self.hostServerURL + "/memories_add"
        }
    }
}
