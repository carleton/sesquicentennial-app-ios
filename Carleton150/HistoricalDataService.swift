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
    class func getLandmarks(_ completion: @escaping (_ success: Bool, _ result: [String : [Event]]) -> Void) {
        Alamofire.request(Endpoints.landmarks).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                let events = json["events"]
                var result: [String : [Event]] = [:]
                if events.count > 0 {
                    for i in 0 ..< events.count {
                        let event = events[i]
                        if let displayDate = event["display_date"].string,
                               let startYear = event["start_date"]["year"].int,
                               let startMonth = event["start_date"]["month"].int,
                               let startDay = event["start_date"]["day"].int,
                               let headline = event["text"]["headline"].string,
                               let text = event["text"]["text"].string,
                               let lat = event["geo"]["lat"].double,
                               let lon = event["geo"]["lon"].double,
                               let name = event["geo"]["name"].string {
                            
                            let imageURL = event["media"]["url"].string ?? nil
                            let caption = event["media"]["caption"].string ?? nil
                            
                            let c = NSDateComponents()
                            c.year = startYear
                            c.month = startMonth
                            c.day = startDay
                            
                            // Get NSDate given the above date components
                            let startDate = NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: c as DateComponents)

                            if let _ = result[name] {
                                result[name]?.append(Event(
                                    displayDate: displayDate,
                                    startDate: startDate! as NSDate,
                                    headline: headline,
                                    text: text,
                                    location: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                    name: name,
                                    imageURL: imageURL,
                                    caption: caption)
                                )
                            } else {
                                result[name] = []
                                result[name]?.append(Event(
                                    displayDate: displayDate,
                                    startDate: startDate! as NSDate,
                                    headline: headline,
                                    text: text,
                                    location: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                    name: name,
                                    imageURL: imageURL,
                                    caption: caption)
                                )
                            }
                        }
                    }
                    // finished getting events, send to completion handler
                    completion(true, result)
                } else {
                    print("No events found.")
                    completion(false, [:])
                }
            } else {
                print("Connection to server failed.")
                completion(false, [:])
            }
        }
    }
}
