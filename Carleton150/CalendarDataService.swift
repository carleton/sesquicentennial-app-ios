//
//  CalendarDataService.swift
//  Carleton150

import Foundation
import Alamofire
import SwiftyJSON

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
        Alamofire.request(.GET, Endpoints.events, parameters: nil).responseString { response in
            if let icsString = response.result.value {
                let events = parseICSString(icsString)
                var result: [NSDate : [CalendarEvent]] = [:]
                for event in events {
                    let roundedDate = NSDate.roundDownToNearestDay(event.startDate)
                    if result[roundedDate] == nil {
                        result[roundedDate] = [event]
                    } else {
                        result[roundedDate]?.append(event)
                    }
                }
                self.schedule = result
            } else {
                NSNotificationCenter
                    .defaultCenter()
                    .postNotificationName("carleton150.calendarUpdateFailure", object: self)
            }
        }
    }

    class func parseICSString(icsString: String) -> [CalendarEvent] {
        var calendarEvents: [CalendarEvent] = []
//        print(icsString)
        let cleanedICSString = icsString.stringByReplacingOccurrencesOfString("\r", withString: "")
        var eventStrings = cleanedICSString.componentsSeparatedByString("BEGIN:VEVENT")
        eventStrings.removeFirst()
        for eventString:String in eventStrings {
            let scanner = NSScanner(string: eventString)

            var s: NSString? = ""
            scanner.scanUpToString("LOCATION:", intoString: nil)
            scanner.scanString("LOCATION:", intoString: nil)
            scanner.scanUpToString("\n", intoString: &s)
            let location: String? = (s as? String)

            s = ""
            scanner.scanLocation = 0
            scanner.scanUpToString("SUMMARY:", intoString: nil)
            scanner.scanString("SUMMARY:", intoString: nil)
            scanner.scanUpToString("\n", intoString: &s)
            let title: String? = (s as? String)

            s = ""
            scanner.scanLocation = 0
            scanner.scanUpToString("DESCRIPTION:", intoString: nil)
            scanner.scanString("DESCRIPTION:", intoString: nil)
            scanner.scanUpToString("\n", intoString: &s)
            let description: String? = (s as? String)

            s = ""
            scanner.scanLocation = 0
            scanner.scanUpToString("URL:", intoString: nil)
            scanner.scanString("URL:", intoString: nil)
            scanner.scanUpToString("\n", intoString: &s)
            var url: NSURL?
            if let urlString = (s as? String) {
                url = NSURL(string: urlString)
            }

            s = ""
            scanner.scanLocation = 0
            scanner.scanUpToString("DTSTART", intoString: nil)
            scanner.scanString("DTSTART", intoString: nil)

            scanner.scanUpToString("\n", intoString: &s)
            var startDate: NSDate?
            
            if let startDateString = (s as? String) {
                startDate = dateFromDTString(startDateString)
                
            }

            let calendarEvent: CalendarEvent = CalendarEvent(
                title: title ?? "No Title",
                description: description ?? "No Event Description",
                startDate: startDate ?? NSDate(),
                location: location ?? "No Location",
                url: url ?? NSURL()
            )
            calendarEvents.append(calendarEvent)
        }

        return calendarEvents
    }

    class func dateFromDTString(dtString: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        
        if (dtString.rangeOfString("VALUE") != nil) {
            dateFormatter.dateFormat = "yyyyMMdd";
            let dateTimeString = dtString.stringByReplacingOccurrencesOfString(";VALUE=DATE:", withString: "")
            if let date = dateFormatter.dateFromString(dateTimeString) {
                return date
            }
        }
        
        else if (dtString.rangeOfString(":") != nil) {
            dateFormatter.dateFormat = "yyyyMMdd HHmmss";
            
            var dateTimeString = dtString.stringByReplacingOccurrencesOfString(":", withString: " ")
            dateTimeString = dateTimeString.stringByReplacingOccurrencesOfString("T", withString: " ")
            let date = dateFormatter.dateFromString(dateTimeString)
            
            if let date = dateFormatter.dateFromString(dateTimeString) {
                return date
            }
        }
        return NSDate()
    }
}