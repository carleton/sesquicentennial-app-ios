//
//  Endpoints.swift
//  Carleton150

/// A class for managing the data service endpoints in the application.
final class Endpoints {
   
    /**
        The current server API URL.
     */
    static var hostServerURL: String = "https://go.carleton.edu"
    
   
    /**
        The current events endpoint in the API.
     */
    static var events: String {
        get {
            return self.hostServerURL + "/appevents"
        }
    }

    
    /**
        The current historical endpoint in the API.
     */
    static var landmarks: String {
        get {
            return self.hostServerURL + "/apphistory"
        }
    }
    
    
    /**
        The current quests endpoint in the API.
     */
    static var quests: String {
        get {
			return self.hostServerURL + "/appquests"
        }
    }
}
