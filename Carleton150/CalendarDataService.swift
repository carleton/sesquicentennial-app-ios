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
    fileprivate(set) static var schedule: [Date : [CalendarEvent]]? {
        didSet {
            NotificationCenter.default
                .post(name: Notification.Name(rawValue: "carleton150.calendarUpdate"), object: self)
        }
    }
    
    fileprivate class func convertDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    class func getEvents() {
        Alamofire.request(Endpoints.events).responseString { response in
            if let icsString = response.result.value {
                let events = parseICSString(icsString)
                var result: [Date : [CalendarEvent]] = [:]
                for event in events {
                    let roundedDate = NSDate.roundDownToNearestDay(event.startDate)
                    if result[roundedDate] == nil {
                        result[roundedDate] = [event]
                    } else {
                        result[roundedDate]?.append(event)
                    }
                }
                self.schedule = result as [Date : [CalendarEvent]]?
            } else {
                NotificationCenter.default
                    .post(name: NSNotification.Name(rawValue: "carleton150.calendarUpdateFailure"), object: self)
            }
        }
    }

    class func parseICSString(_ icsString: String) -> [CalendarEvent] {
        var calendarEvents: [CalendarEvent] = []
//        print(icsString)
        let cleanedICSString = icsString.replacingOccurrences(of: "\r", with: "")
        var eventStrings = cleanedICSString.components(separatedBy: "BEGIN:VEVENT")
        eventStrings.removeFirst()
        for eventString:String in eventStrings {
            let scanner = Scanner(string: eventString)

            var s: NSString? = ""
            scanner.scanUpTo("LOCATION:", into: nil)
            scanner.scanString("LOCATION:", into: nil)
            scanner.scanUpTo("\n", into: &s)
            let location: String? = (s as? String)

            s = ""
            scanner.scanLocation = 0
            scanner.scanUpTo("SUMMARY:", into: nil)
            scanner.scanString("SUMMARY:", into: nil)
            scanner.scanUpTo("\n", into: &s)
            let title: String? = (s as? String)

            s = ""
            scanner.scanLocation = 0
            scanner.scanUpTo("DESCRIPTION:", into: nil)
            scanner.scanString("DESCRIPTION:", into: nil)
            scanner.scanUpTo("\n", into: &s)
            let description: String? = (s as? String)

            s = ""
            scanner.scanLocation = 0
            scanner.scanUpTo("URL:", into: nil)
            scanner.scanString("URL:", into: nil)
            scanner.scanUpTo("\n", into: &s)
            var url: URL?
            if let urlString = (s as? String) {
                url = URL(string: urlString)
            }

            s = ""
            scanner.scanLocation = 0
            scanner.scanUpTo("DTSTART:", into: nil)
            scanner.scanString("DTSTART:", into: nil)
            scanner.scanUpTo("\n", into: &s)
            var startDate: Date?
            if let startDateString = (s as? String) {
                startDate = dateFromDTString(startDateString)
            }

            let calendarEvent: CalendarEvent = CalendarEvent(
                title: title ?? "No Title",
                description: description ?? "No Event Description",
                startDate: startDate ?? Date(),
                location: location ?? "No Location",
                url: url ?? URL(string: "")!
            )
            calendarEvents.append(calendarEvent)
        }

        return calendarEvents
    }

    class func dateFromDTString(_ dtString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd HHmmss";
        let dateTimeString = dtString.replacingOccurrences(of: "T", with: " ")
        if let date = dateFormatter.date(from: dateTimeString) {
            return date
        }
        return Date()
    }
}
