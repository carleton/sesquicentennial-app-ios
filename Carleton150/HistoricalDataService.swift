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
				let answer = json["content"][geofenceName]
				if answer.count > 0 {
					var historicalEntries : [Dictionary<String, String>?] = []
					for i in 0 ..< answer.count {
						// if the result has a defined type
						if let type = answer[i]["type"].string {
							var result = Dictionary<String,AnyObject>()
							// add the type variable
							result["type"] = type
							// if just text returned
							if type == "text" {
								if let summary = answer[i]["summary"].string,
                                       data = answer[i]["data"].string {
									result["summary"] = summary
									result["desc"] = data
                                }
							} else if type == "image" {
								if let desc = answer[i]["desc"].string, data = answer[i]["data"].string, caption = answer[i]["caption"].string {
									result["desc"] = desc
									result["caption"] = caption
									result["data"] = data
								}
							}
							// checking for optional data
							if let year = answer[i]["year"].number {
								result["year"] = year.stringValue
							}
							if let month = answer[i]["month"].string {
								result["month"] = month
							}
							if let day = answer[i]["day"].string {
								result["day"] = day
							}
							historicalEntries.append(result as? Dictionary<String, String>)
						} else {
							print("Data returned at endpoint: \(Endpoints.historicalInfo) is malformed. Geofence name: \(geofenceName)")
							completion(success: false, result: [])
							return
						}
					}
                    completion(success: true, result: historicalEntries)
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
    
    //Dummy data class to make sure the rest of the path is working correctly
    class func requestMemoriesContent_old(location: CLLocationCoordinate2D,
        completion: (success: Bool, result: [Dictionary<String, String>?]) -> Void){
            print("Gonna get moments!")
            var testDictionary : Dictionary<String, String> = Dictionary()
            var testDictionary2 : Dictionary<String, String> = Dictionary()
            testDictionary["type"] = "moment_text"
            testDictionary["summary"] = "Summary Text"
            testDictionary["data"] = "Data Text"
            testDictionary["desc"] = "Desc Text"
            testDictionary["year"] = "2016"
            testDictionary2["type"] = "moment_text"
            testDictionary2["summary"] = "Summary Text"
            testDictionary2["data"] = "Data Text"
            testDictionary2["desc"] = "Desc Text"
            testDictionary2["year"] = "2015"
            print([testDictionary])
            var arrayOfDicts = [Dictionary<String, String>?]()
            arrayOfDicts = [testDictionary, testDictionary2]
            completion(success: true , result: arrayOfDicts)
            
    }
    
    //this gets the moments data near us
    class func requestMemoriesContent(location: CLLocationCoordinate2D,
        completion: (success: Bool, result: [Dictionary<String, String>?]) ->Void) {
            let parameters = [
                "lat" : location.latitude,
                "lng" : location.longitude,
                "rad" : 0.1
            ]
            print(parameters)
            //Nothing seems to execute after this point
            //no print statements run, on succuess or fail? Idk how that's possible without throwing an error here
            Alamofire.request(.POST, Endpoints.memoriesInfo, parameters: parameters, encoding: .JSON).responseJSON() {
                (request, response, result) in
                print("made the request")
                if let result = result.value {
                    let json = JSON(result)
                    //array of memories
                    let answer = json["content"].arrayValue
                    if answer.count > 0 {
                        var memoriesEntries : [Dictionary<String, String>?] = []
                        for i in 0 ..< answer.count {
                            print("Parsing a memory")
                            // if the result has a defined type
                            if let image = answer[i]["image"].string {
                                var result = Dictionary<String,AnyObject>()
                                // add the type variable
                                result["image"] = image
                                // if just text returned
                                if image == "" {
                                    result["type"] = "memories_text"
                                    //may need more code in the future to handle text
                                } else if image != "" {
                                    result["type"] = "memories_image"
                                }
                                let timestamp = answer[i]["timestamp"]
                                if let desc = answer[i]["desc"].string, data = answer[i]["data"].string, caption = answer[i]["caption"].string{
                                    result["desc"] = desc
                                    result["caption"] = caption
                                    result["data"] = data
                                    if let takenDate = timestamp["taken"].string {
                                        result["taken"] = takenDate
                                    }
                                    if let postedDate = timestamp["posted"].string {
                                        result["posted"] = postedDate
                                    }
                                }
                                if let id = answer[i]["id"].string {
                                    result["id"] = id
                                }
                                if let uploader = answer[i]["uploader"].string {
                                    result["uploader"] = uploader
                                }

                                // checking for optional data
                                // do we have more than year?
                                if let year = answer[i]["year"].number {
                                    result["year"] = year.stringValue
                                }
                                if let month = answer[i]["month"].string {
                                    result["month"] = month
                                }
                                if let day = answer[i]["day"].string {
                                    result["day"] = day
                                }
                                memoriesEntries.append(result as? Dictionary<String, String>)
                            } else {
                                print("Data returned at endpoint: \(Endpoints.memoriesInfo) is malformed. Geofence name: moments")
                                completion(success: false, result: [])
                                return
                            }
                        }
                        print("think I've got the answer!")
                        print(memoriesEntries)
                        completion(success: true, result: memoriesEntries)
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

        
        /**(location: CLLocationCoordinate2D,
        completion: (success: Bool, result: [(name: String, radius: Int, center: CLLocationCoordinate2D)]?) -> Void) {
            let parameters = [
                "moments": [
                    "location" : [
                        "lat" : location.latitude,
                        "lng" : location.longitude
                    ],
                    //"was there supposed to be a " ' " here or was it a typo?
                    "radius": 2000
                ]
            ]
            
            
            
            Alamofire.request(.POST, Endpoints.moments, parameters: parameters, encoding: .JSON).responseJSON() {
                (request, response, result) in
                var final_result: [(name: String, radius: Int, center: CLLocationCoordinate2D)] = []
                
                if let result = result.value {
                    let json = JSON(result)
                    if let answer = json["content"].array {
                        for i in 0 ..< answer.count {
                            let location = answer[i]["moment"]["location"]
                            if let momentName = answer[i]["name"].string,
                                rad = answer[i]["moment"]["radius"].int,
                                latitude = location["lat"].double,
                                longitude = location["lng"].double {
                                    
                                    let center = CLLocationCoordinate2D(
                                        latitude: latitude,
                                        longitude: longitude
                                    )
                                    final_result.append((name: momentName, radius: rad, center: center))
                                    
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
    }**/

    
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
                //"was there supposed to be a " ' " here or was it a typo?
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
