//
//  Quest.swift
//  Carleton150

import Foundation

class Quest: NSObject {

	var wayPoints: [WayPoint]
    var name: String
    var questDescription: String
    var completionMessage: String

    /**
        Constructor for a Quest object. 
    
        Parameters: 
            - wayPoints:         A list of waypoints that comprise 
                                 the locations on campus that make up the quest.
     
            - name:              The title of the quest.
     
            - questDescription:  A short summary about the quest.
            
            - completionMessage: The message that shows upon completion of the quest.
     */
	init (wayPoints: [WayPoint], name: String, description: String, completionMessage: String) {
        self.wayPoints = wayPoints
        self.name = name
        self.questDescription = description
        self.completionMessage = completionMessage
    }
}
