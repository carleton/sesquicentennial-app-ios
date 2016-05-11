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
    private(set) static var schedule: [Dictionary<String, AnyObject?>]? {
        didSet {
            NSNotificationCenter
                .defaultCenter()
                .postNotificationName("carleton150.calendarUpdate", object: self)
        }
    }
    
    class func getEvents() {
        let manager = MXLCalendarManager()
        Alamofire.request(.GET, Endpoints.events, parameters: nil).responseString { response in
            if let icsString = response.result.value {
                manager.parseICSString(icsString) { calendar, error in
                    var result: [Dictionary<String, AnyObject?>] = []
                    for event in calendar.events {
                        var newEvent: [String : AnyObject] = [:]
                        newEvent["title"] = event.eventSummary ?? "No Title"
                        newEvent["location"] = event.eventLocation ?? "No location"
                        newEvent["startTime"] = event.eventStartDate ?? "No start time"
                        newEvent["description"] = event.eventDescription ?? "No event description"
                        result.append(newEvent)
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