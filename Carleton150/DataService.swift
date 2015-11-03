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
        
        let _ = [
            "geofence": [
                "location" : [
                    "x" : location.latitude,
                    "y" : location.longitude
                ],
                "radius": 0.01
            ],
            "timespan": [
                "startTime":"",
                "endTime":""
            ]
        ]
        
        return [("hello", 1, CLLocationCoordinate2D(latitude: 15.2, longitude: 15.1))]
    }
    
}


