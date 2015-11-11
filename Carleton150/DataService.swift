//
//  Requests.swift
//  Carleton150
//
//  Created by Chet Aldrich on 11/3/15.
//  Copyright © 2015 edu.carleton.carleton150. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreLocation

final class DataService {
    
    init () {}
    
    
    class func requestContent(geofenceName: String,
                              completion: (success: Bool, result: Dictionary<String, String>?) -> Void) -> Void {
        let parameters = [
            "geofences": ["Bald Spot"]
        ]
        
        let postEndpoint: String = "https://carl.localtunnel.me/info"
        
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
                }
            } else {
                print("Connection to server failed.")
                completion(success: false, result: nil)
            }
        }
    }
    
    class func requestNearbyGeofences(location: CLLocationCoordinate2D) ->
               [(name: String, radius: Int, center: CLLocationCoordinate2D)] {
        
        let parameters = [
            "geofence": [
                "location" : [
                    "lat" : location.latitude,
                    "lng" : location.longitude
                ],
                "radius": 250
            ]
        ]
        
        let geofences: Geofences = Geofences()
        let postEndpoint: String = "https://carl.localtunnel.me/geofences"
        
        Alamofire.request(.POST, postEndpoint, parameters: parameters, encoding: .JSON).responseJSON() {
            (request, response, result) in
            
            if let result = result.value {
                let json = JSON(result)
                if let answer = json["content"].array {
                    for i in 0 ..< answer.count {
                        let location = answer[i]["geofence"]["location"]
                        let fenceName = answer[i]["name"].string!
                        let rad = Int(answer[i]["geofence"]["radius"].string!)!
                        let center = CLLocationCoordinate2D(latitude: location["lat"].double!,longitude: location["long"].double!)
                        geofences.addNewGeofence((name: fenceName, radius: rad, center: center ))
                    }
                }
            }
        }
        return geofences.getGeofences()
    }
    
}

final class Geofences {
    var geofenceArray: [(name: String, radius: Int, center: CLLocationCoordinate2D)]
    
    init () {
        self.geofenceArray = []
    }
    
    func addNewGeofence(element: (name: String, radius: Int, center: CLLocationCoordinate2D)) {
       self.geofenceArray.append(element)
    }
    
    func getGeofences() -> [(name: String, radius: Int, center: CLLocationCoordinate2D)] {
        return self.geofenceArray
    }
    
}
