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
    
    class func requestNearbyGeofences(location: CLLocationCoordinate2D) -> [(name: String, radius: Int, center: CLLocationCoordinate2D)] {
        
        let parameters = [
            "geofence": [
                "location" : [
                    "lat" : location.latitude,
                    "lng" : location.longitude
                ],
                "radius": 250
            ],
            "timespan": [
                "startTime":"",
                "endTime":""
            ]
        ]
        
        let postEndpoint: String = "https://carl.localtunnel.me/geofences"
        Alamofire.request(.POST, postEndpoint, parameters: parameters, encoding: .JSON).responseJSON() {
            (request, response, result) in
            
            let json = JSON(result.value!)
            let answer = json["content"]
            var answerArray:[(name: String, radius: Int, CLLcoord: CLLocationCoordinate2D)] = []
            for i in 0 ..< answer.count {
                //print(answer[i]["name"])
                var geofence = answer[i]["geofence"]
                var location = geofence["location"]
                var latitude = location["lat"]
                var longitude = location["lng"]
                answerArray.append((name: answer[i]["name"].string!, radius: Int(answer[i]["geofence"]["radius"].string!)!, CLLcoord: CLLocationCoordinate2D(latitude: latitude.double!,longitude: longitude.double!)))
            }
            print(answerArray)
        }

        
        return [("hello", 1, CLLocationCoordinate2D(latitude: 15.2, longitude: 15.1))]
    }
    
}


