//
//  Quest.swift
//  Carleton150

import Foundation

class Quest: NSObject {
    var wayPoints: [WayPoint]
    var name: String
    var questDescription: String
    
    init (wayPoints: [WayPoint], name: String, description: String) {
        self.wayPoints = wayPoints
        self.name = name
        self.questDescription = description
    }
}
