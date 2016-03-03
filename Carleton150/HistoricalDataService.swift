//
//  HistoricalDataService.swift
//  Carleton150

import Foundation
import Alamofire
import SwiftyJSON


// 500km = max radius. Will be less if off campus but within max distance
let offCampusRadius : Double = 5000

// radius to be used while on campus. currently at .02km
let onCampusRadius : Double = 0.2

/// Data Service that contains relevant endpoints for the Historical module.
final class HistoricalDataService {
	
	let alamofireManager : Alamofire.Manager?
  
	
	init() {
		let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
		configuration.timeoutIntervalForResource = 2 // seconds
		self.alamofireManager = Alamofire.Manager(configuration: configuration)
	}
    
    /**
        Request content from the server associated with a landmark on campus.

        - Parameters:
            - geofenceName: Name of the landmark for which to get content.
            - completion: function that will perform the behavior
                          that you want given a dictionary with all content
                          from the server.
     */
    class func requestContent(geofenceName: String, completion: (success: Bool, result: [Dictionary<String, String>?]) ->Void) {
        let parameters = [
            "geofences": [geofenceName]
        ]
        Alamofire.request(.POST, Endpoints.historicalInfo, parameters: parameters, encoding: .JSON).responseJSON() {
            (request, response, result) in
            if let result = result.value {
				print("Data Successfully retrieved for the \(geofenceName)")
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
                    print("No results were found for \(geofenceName)")
                    completion(success: false, result: [])
                }
            } else {
                print("Connection to server failed.")
                completion(success: false, result: [])
            }
        }
    }
    
    private class func getRadius(location : CLLocationCoordinate2D) -> Double{
        let lat = location.latitude
        let long = location.longitude
        let latMin = 44.457564
        let latMax = 44.486469
        let longMin = -93.159549
        let longMax = -93.127566
        var nearestLong : Double = long
        var nearestLat : Double = lat
        var nearestPoint : CLLocationCoordinate2D
        var radius : Double = onCampusRadius
        // Carleton campus 44.457564<Lat<44.486469
        // -93.159549<long<-93.127566
        if lat < latMin {
            nearestLat = latMin
        } else if lat > latMax {
            nearestLat = latMax
        }
        if long < longMin {
            nearestLong = longMin
        } else if long > longMax{
            nearestLong = longMax
        }
        nearestPoint = CLLocationCoordinate2D(latitude : nearestLat, longitude: nearestLong)
        
        let distance = Utils.getDistance(nearestPoint, point2: location)
        //let distance = sqrt(pow(longDiff, 2) + pow(latDiff, 2))
        if distance > onCampusRadius && distance < offCampusRadius {
            radius = distance
        } else if distance > onCampusRadius && distance > offCampusRadius {
            radius = offCampusRadius
        }
        return radius
        
        
    }
    
    /**
        Request memories content on the server.

        - Parameters:
            - location: The current location of the user.
            - completion: function that will perform the behavior
                          that you want given a dictionary with all content
                          from the server.
     */
    class func requestMemoriesContent(location: CLLocationCoordinate2D,
        completion: (success: Bool, result: [Memory]) -> Void) {
        let radius = getRadius(location)
            
        let parameters = [
            "lat" : location.latitude,
            "lng" : location.longitude,
            "rad" : radius
        ]
        
        Alamofire.request(.POST, Endpoints.memoriesInfo, parameters: parameters, encoding: .JSON).responseJSON() {
            (request, response, result) in
            if let result = result.value {
                let json = JSON(result)
                let answer = json["content"].arrayValue
                if answer.count > 0 {
                    var memoriesEntries : [Memory] = []
                    for i in 0 ..< answer.count {
                        if let image = answer[i]["image"].string,
                               title = answer[i]["caption"].string,
                               desc = answer[i]["desc"].string,
                               uploader = answer[i]["uploader"].string,
                               takenTimestamp = answer[i]["timestamps"]["taken"].string {
                                
                            let memory: Memory = Memory(
                                title: title,
                                desc: desc,
                                timestamp: takenTimestamp,
                                uploader: uploader,
                                image: Memory.buildImageFromString(image)!
                            )
                                
                            memoriesEntries.append(memory)
                        } else {
                            print("Data returned at endpoint: \(Endpoints.memoriesInfo) is malformed.")
                            completion(success: false, result: [])
                            return
                        }
                    }
                    completion(success: true, result: memoriesEntries)
                } else {
                    print("No results were found for Memories.")
                    completion(success: false, result: [])
                }
            } else {
                print("Connection to server failed.")
                completion(success: false, result: [])
            }
        }
    }
    
   
    /**
        Add a memory to the server!
     
        - Parameters: 
            - memory: The memory and the associated data to upload. 
            
            - completion: The function to be triggered upon
                          completion of the upload
     */
    class func uploadMemory(memory: Memory, completion: (success: Bool) -> Void) {
        // build the base64 representation of the image
        let imageData = UIImageJPEGRepresentation(memory.image, 0.1)
        let base64Image: String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        let parameters: [String : AnyObject] = [
            "title" : memory.title,
            "desc" : memory.desc,
            "timestamp" :  memory.timeString,
            "uploader" : memory.uploader,
            "location" : [
                "lat": memory.location.latitude,
                "lng": memory.location.longitude
            ],
            "image" : base64Image
        ]
        
        
        Alamofire.request(.POST, Endpoints.addMemory, parameters: parameters , encoding: .JSON).responseJSON() {
            (request, response, result) in
            
            
            if let result = result.value {
                let json = JSON(result)
                if json["status"] != nil {
                    if json["status"] == "Success!" {
                        completion(success: true)
                    } else {
                        print("Upload failed.")
                        completion(success: false)
                    }
                } else {
                    print("Upload failed.")
                    completion(success: false)
                }
            } else {
                print("Upload failed.")
                completion(success: false)
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
                "radius": Constants.geofenceRequestRadius
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
					print("Data Successfully retrieved for the Geofences Endpoint")
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
