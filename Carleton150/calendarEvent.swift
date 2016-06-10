//
//  calendarEvent.swift
//  Carleton150

import Foundation

class CalendarEvent {

    let title: String
    let description: String
    let startDate: NSDate
    let location: String
    let url: NSURL
    
    init(title: String, description: String, startDate: NSDate, location: String, url: NSURL) {
        self.title = title
        self.description = description
        self.startDate = startDate
        self.location = location
        self.url = url
    }
}

// MARK: Equatable
func ==(lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
    return lhs.startDate.equalToDate(rhs.startDate)
}

// MARK: Comparable
func <(lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
    return lhs.startDate.isLessThanDate(rhs.startDate)
}