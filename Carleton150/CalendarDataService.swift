//
//  CalendarDataService.swift
//  Carleton150

import Foundation
import Alamofire
import SwiftyJSON
import MXLCalendarManager

/// Data Service that contains relevant endpoints for the Calendar module.
final class CalendarDataService {
   
    /**
        The stored schedule, which upon being updated, alerts the observers
        (in this case, just the calendar view). Currently this is not updated
        periodically, but on app launch.
     */
    private(set) static var schedule: [NSDate : [CalendarEvent]]? {
        didSet {
            NSNotificationCenter
                .defaultCenter()
                .postNotificationName("carleton150.calendarUpdate", object: self)
        }
    }
    
    private class func convertDateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(date)
    }
    
    class func getEvents() {
        let manager = MXLCalendarManager()
        Alamofire.request(.GET, Endpoints.events, parameters: nil).responseString { response in
            if let icsString = response.result.value {
                manager.parseICSString(icsString) { calendar, error in
                    var result: [NSDate : [CalendarEvent]] = [:]
                    for event in calendar.events {
                        let location = event.eventLocation ?? "No Location"
                        let calendarEvent: CalendarEvent = CalendarEvent(
                            title: event.eventSummary ?? "No Title",
                            description: event.eventDescription ?? "No Event Description",
                            startDate: event.eventStartDate,
                            location: location
                        )
                        if result[NSDate.roundDownToNearestDay(calendarEvent.startDate)] == nil {
                            result[NSDate.roundDownToNearestDay(calendarEvent.startDate)] = [calendarEvent]
                        } else {
                            result[NSDate.roundDownToNearestDay(calendarEvent.startDate)]?.append(calendarEvent)
                        }
                    }
                    self.schedule = result
                }
            } else {
                NSNotificationCenter
                    .defaultCenter()
                    .postNotificationName("carleton150.calendarUpdateFailure", object: self)
            }
        }
    }
}