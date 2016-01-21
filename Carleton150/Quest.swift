//
//  Quest.swift
//  Carleton150

import Foundation

class Quest: NSObject {

	var wayPoints: [WayPoint]
    var name: String
    var questDescription: String
    var completionMessage: String
	var image: UIImage
	
	init (wayPoints: [WayPoint], name: String, description: String, completionMessage: String, displayImage: UIImage) {
        self.wayPoints = wayPoints
        self.name = name
        self.questDescription = description
        self.completionMessage = completionMessage
		self.image = displayImage
    }
}
