//
//  DataService.swift
//  Carleton150

import Foundation
import SwiftyJSON
import Alamofire

/// A class for making API calls to the Carleton150 server.
final class DataService {
    
    /**
        Request content from the server associated with a landmark on campus.

        - Parameters:
            - geofenceName: Name of the landmark for which to get content.
            - completion: function that will perform the behavior
                          that you want given a dictionary with all content
                          from the server.
     */
    class func requestContent(geofenceName: String,
                              completion: (success: Bool, result: Dictionary<String, String>?) ->Void) {
        let parameters = [
            "geofences": [geofenceName]
        ]
        
        let postEndpoint: String = "https://carl150.carleton.edu/info"
        
        Alamofire.request(.POST, postEndpoint, parameters: parameters, encoding: .JSON).responseJSON() {
            (request, response, result) in
            
            if let result = result.value {
                let json = JSON(result)
                if let answer = json["content"].array {
                    if answer.count > 0 {
                        let type = answer[0]["type"].string!
                        let summary = answer[0]["summary"].string!
                        let data = answer[0]["data"].string!
                        let final_result = ["type": type,
                                            "summary": summary,
                                            "data": data]
                        completion(success: true, result: final_result)
                    }
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
    
    /**
        Request nearby geofences based on current location.

        - Parameters:
            - location: The user's current location.
            - completion: function that will perform the behavior
                          that you want given a list with all geofences
                          from the server.
     */
    class func requestNearbyGeofences(location: CLLocationCoordinate2D,
          completion: (success: Bool, result: [(name: String, radius: Int, center: CLLocationCoordinate2D)]?) -> Void) {
        
        let parameters = [
            "geofence": [
                "location" : [
                    "lat" : location.latitude,
                    "lng" : location.longitude
                ],
                "radius": 2000
            ]
        ]
        
        let postEndpoint: String = "https://carl150.carleton.edu/geofences"
        
        Alamofire.request(.POST, postEndpoint, parameters: parameters, encoding: .JSON).responseJSON() {
            (request, response, result) in
            var final_result: [(name: String, radius: Int, center: CLLocationCoordinate2D)] = []
            
            if let result = result.value {
                let json = JSON(result)
                if let answer = json["content"].array {
                    for i in 0 ..< answer.count {
                        let location = answer[i]["geofence"]["location"]
                        let fenceName = answer[i]["name"].string!
                        let rad = answer[i]["geofence"]["radius"].int!
                        let center = CLLocationCoordinate2D(latitude: location["lat"].double!,longitude: location["lng"].double!)
                        final_result.append((name: fenceName, radius: rad, center: center))
                    }
                    completion(success: true, result: final_result)
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
    
    /**
        Request quests for the game mode.
     
        - Parameters:
            - theme:      A value indicating a specific theme to search for
                          in the selection of quests on the server.
     
            - limit:      A hard limit on the amount of quests returned
                          by the server.
     
            - completion: function that will perform the behavior
                          that you want given a list with all the quests
                          from the server.
     */
    class func requestQuest(theme: String = "", limit: Int = 5, completion:
        (success: Bool, result: [Quest]?) -> Void) {
            
           
        let parameters = [
            "theme": theme,
            "limit": limit
        ]
        
        let postEndpoint: String = "https://carl150.carleton.edu/quest"
        
        Alamofire.request(.POST, postEndpoint, parameters: (parameters as! [String : AnyObject]), encoding: .JSON).responseJSON() {
            (request, response, result) in
            
            var quests: [Quest] = []
            
            if let result = result.value {
                let json = JSON(result)
                
                if let answer = json["content"].array {
                    for i in 0 ..< answer.count {
                        var wayPoints: [WayPoint] = []
                        let points = answer[i]["waypoints"]
                        
                        for i in 0 ..< points.count {
                            let position: String = String(i)
                            let wayPoint = points[position]
                            let geofence = points[position]["geofence"]
                            let location = CLLocationCoordinate2D(
                                    latitude: geofence["lat"].double!,
                                    longitude: geofence["lng"].double!
                            )
                            wayPoints.append(
                                WayPoint(location: location,
                                         radius: geofence["rad"].double!,
                                         clue: wayPoint["clue"].string!,
                                         hint: wayPoint["hint"].string!)
                            )
                        }
                        
                        quests.append(
                            Quest(
                                wayPoints: wayPoints,
                                name: answer[i]["name"].string!,
                                description: answer[i]["desc"].string!,
                                completionMessage: answer[i]["compMsg"].string!)
                        )
                    }
                    completion(success: true, result: quests)
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
