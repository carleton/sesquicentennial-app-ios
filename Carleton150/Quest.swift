//
//  Quest.swift
//  Carleton150

import Foundation

class Quest: NSObject {
    var wayPoints: [WayPoint]
    var name: String
    var questDescription: String
    var completionMessage: String
    
    init (wayPoints: [WayPoint], name: String, description: String, completionMessage: String) {
        self.wayPoints = wayPoints
        self.name = name
        self.questDescription = description
        self.completionMessage = completionMessage
    }
}
