//
//  DataService.swift
//  Carleton150

import Foundation
import SwiftyJSON
import Alamofire

/// A class for making API calls to the Carleton150 server.
final class DataService {
    
    
    /**
        Request events for the calendar.
     
        - Parameters:
            - completion: function that will perform the behavior
                          that you want given a list with all the events
                          from the server.
     
            - limit:      A hard limit on the amount of quests returned
                          by the server.
     
            - date:       The earliest date from which to get data.
     
     */
    class func requestEvents(date: NSDate?, limit: Int, completion:
        (success: Bool, result: [Dictionary<String, String>]?) -> Void) {
            
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
           
        var dateString : String = ""
        if let desiredDate = date {
            dateString = dateFormatter.stringFromDate(desiredDate)
        } else {
            let todaysDate = NSDate()
            dateString = dateFormatter.stringFromDate(todaysDate)
        }

        let parameters = [
            "startTime": dateString,
            "limit": limit
        ]
        
        let postEndpoint: String = "https://carl150.carleton.edu/events"
        
        Alamofire.request(.POST, postEndpoint, parameters: (parameters as! [String : AnyObject]), encoding: .JSON).responseJSON() {
            (request, response, result) in
            
            var events : [Dictionary<String, String>] = []
            
            if let result = result.value {
                let json = JSON(result)
                if let answer = json["content"].array {
                    for i in 0 ..< answer.count {
                        let title = answer[i]["title"].string!
                        let description = answer[i]["description"].string!
                        let location = answer[i]["location"].string!
                        let startTime = answer[i]["startTime"].string!
                        let duration = answer[i]["duration"].string!
                        let event = ["title": title,
                                     "description": description,
                                     "location": location,
                                     "startTime": startTime,
                                     "duration": duration]
                        events.append(event)
                    }
                    completion(success: true, result: events)
                } else {
                    print("No results were found.")
                    completion(success: false, result: nil)
                }
            } else {
                print("Connection to server failed.")
                completion(success: false, result: nil)
            }
        }
    }
    
}
