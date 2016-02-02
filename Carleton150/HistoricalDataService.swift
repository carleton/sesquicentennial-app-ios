//
//  HistoricalDataService.swift
//  Carleton150

import Foundation
import Alamofire
import SwiftyJSON

/// Data Service that contains relevant endpoints for the Historical module.
final class HistoricalDataService {
    
    /**
        Request content from the server associated with a landmark on campus.

        - Parameters:
            - geofenceName: Name of the landmark for which to get content.
            - completion: function that will perform the behavior
                          that you want given a dictionary with all content
                          from the server.
     */
    class func requestContent(geofenceName: String,
                              completion: (success: Bool, result: [Dictionary<String, String>?]) ->Void) {
        let parameters = [
            "geofences": [geofenceName]
        ]
        
        Alamofire.request(.POST, Endpoints.historicalInfo, parameters: parameters, encoding: .JSON).responseJSON() {
            (request, response, result) in
            
            if let result = result.value {
                let json = JSON(result)
                if let answer = json["content"].array {
                    if answer.count > 0 {
                        var historicalEntries : [Dictionary<String, String>?] = []
                        for i in 0 ..< answer.count {
                            if let type = answer[i]["type"].string,
                                   summary = answer[i]["summary"].string,
                                   data = answer[i]["data"].string {
                                let result = ["type": type,
                                              "summary": summary,
                                              "data": data]
                                historicalEntries.append(result)
                            } else {
                                print("Data returned at endpoint: \(Endpoints.historicalInfo) is malformed.")
                                completion(success: false, result: [])
                                return
                            }
                        }
                        completion(success: true, result: historicalEntries)
                    }
                } else {
                    print("No results were found.")
                    completion(success: false, result: [])
                }
            } else {
                print("Connection to server failed.")
                completion(success: false, result: [])
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
        
        Alamofire.request(.POST, Endpoints.geofences, parameters: parameters, encoding: .JSON).responseJSON() {
            (request, response, result) in
            var final_result: [(name: String, radius: Int, center: CLLocationCoordinate2D)] = []
            
            if let result = result.value {
                let json = JSON(result)
                if let answer = json["content"].array {
                    for i in 0 ..< answer.count {
                        let location = answer[i]["geofence"]["location"]
                        if let fenceName = answer[i]["name"].string,
                               rad = answer[i]["geofence"]["radius"].int,
                               latitude = location["lat"].double,
                               longitude = location["lng"].double {
                                
                                let center = CLLocationCoordinate2D(
                                    latitude: latitude,
                                    longitude: longitude
                                )
                                final_result.append((name: fenceName, radius: rad, center: center))
                                
                        } else {
                            print("Data returned at endpoint: \(Endpoints.geofences) is malformed.")
                            completion(success: false, result: nil)
                            return
                        }
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
}
