//
//  calendarEvent.swift
//  Carleton150

import Foundation

class CalendarEvent {

    let title: String
    let description: String
    let startDate: Date
    let location: String
    let url: URL
    
    init(title: String, description: String, startDate: Date, location: String, url: URL) {
        self.title = title
        self.description = description
        self.startDate = startDate
        self.location = location
        self.url = url
    }
}

// MARK: Equatable
func ==(lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
    return lhs.startDate.timeIntervalSince(rhs.startDate) == 0
}

// MARK: Comparable
func <(lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
    return lhs.startDate.timeIntervalSince(rhs.startDate) < 0
}
