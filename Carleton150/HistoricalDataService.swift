//
//  HistoricalDataService.swift
//  Carleton150

import Foundation
import Alamofire
import SwiftyJSON


/// Data Service that contains relevant endpoints for the Historical module.
final class HistoricalDataService {
	
    /**
        Request the historical data.
     
        - Parameters:
            - completion: function that will perform the behavior
                          that you want given a dictionary with all content
                          from the server.
     */
    class func getLandmarks(completion: (success: Bool, result: [String : [Event]]) -> Void) {
        Alamofire.request(.GET, Endpoints.landmarks, parameters: nil).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                let events = json["events"]
                var result: [String : [Event]] = [:]
                if events.count > 0 {
                    for i in 0 ..< events.count {
                        let event = events[i]
                        if let displayDate = event["display_date"].string,
                               startYear = event["start_date"]["year"].int,
                               startMonth = event["start_date"]["month"].int,
                               startDay = event["start_date"]["day"].int,
                               headline = event["text"]["headline"].string,
                               text = event["text"]["text"].string,
                               lat = event["geo"]["lat"].string,
                               lon = event["geo"]["lon"].string,
                               name = event["geo"]["name"].string {
                            
                            let imageURL = event["image"].string ?? nil
                            
                            let c = NSDateComponents()
                            c.year = startYear
                            c.month = startMonth
                            c.day = startDay
                            
                            // Get NSDate given the above date components
                            let startDate = NSCalendar(identifier: NSCalendarIdentifierGregorian)?.dateFromComponents(c)

                            
                            if var landmark = result[name] {
                                landmark.append(Event(
                                    displayDate: displayDate,
                                    startDate: startDate!,
                                    headline: headline,
                                    text: text,
                                    location: CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!),
                                    name: name,
                                    imageURL: imageURL)
                                )
                            } else {
                                result[name] = []
                                result[name]?.append(Event(
                                    displayDate: displayDate,
                                    startDate: startDate!,
                                    headline: headline,
                                    text: text,
                                    location: CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!),
                                    name: name,
                                    imageURL: imageURL)
                                )
                            }
                        } else {
							print("Data returned at endpoint: \(Endpoints.landmarks) is malformed.")
                            completion(success: false, result: [:])
                        }
                    }
                    // finished getting events, send to completion handler
                    completion(success: true, result: result)
                } else {
                    print("No events found.")
                    completion(success: false, result: [:])
                }
            } else {
                print("Connection to server failed.")
                completion(success: false, result: [:])
            }
        }
    }
}
