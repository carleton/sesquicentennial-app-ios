//
//  QuestDataService.swift
//  Carleton150

import Foundation
import SwiftyJSON
import Alamofire

/// Data Service that contains relevant endpoints for the Quest module.
final class QuestDataService {
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
        
        Alamofire.request(.POST, Endpoints.quests, parameters: (parameters as! [String : AnyObject]), encoding: .JSON).responseJSON() {
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