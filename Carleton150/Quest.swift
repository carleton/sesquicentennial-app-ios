//
//  Quest.swift
//  Carleton150

import Foundation

class Quest: NSObject {

	var wayPoints: [WayPoint]!
    var name: String
    var questDescription: String
    var completionMessage: String
	var creator: String
	var image: String
	var difficulty: Int
	var audience: String
	
    /**
        Constructor for a Quest object. 
    
        Parameters: 
            - wayPoints:         A list of waypoints that comprise 
                                 the locations on campus that make up the quest.
     
            - name:              The title of the quest.
     
            - questDescription:  A short summary about the quest.
            
            - completionMessage: The message that shows upon completion of the quest.
     */
	init (wayPoints: [WayPoint], name: String, description: String, completionMessage: String, creator: String, image: String, difficulty: Int, audience: String) {
        self.wayPoints = wayPoints
        self.name = name
        self.questDescription = description
        self.completionMessage = completionMessage
		self.creator = creator
		self.image = image
		self.difficulty = difficulty
		self.audience = audience
    }
}
