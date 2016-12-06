//
//  Event.swift
//  Carleton150

import Alamofire
import AlamofireImage

/// A container for event information from the timeline.
class Event: Comparable {
    
    let displayDate: String!
    let startDate: NSDate!
    let headline: String!
    let text: String!
    let location: CLLocationCoordinate2D!
    let name: String!
    var image: UIImage?
    let caption: String?
    
    init(displayDate: String, startDate: NSDate, headline: String, text: String, location: CLLocationCoordinate2D, name: String, imageURL: String?, caption: String?) {
        self.displayDate = displayDate
        self.startDate = startDate
        self.headline = headline
        self.text = text
        self.location = location
        self.name = name
        self.caption = caption
        if let imageURL = imageURL {
            Alamofire.request(imageURL).responseImage { response in
                if let image = response.result.value {
                    self.image = image
                }
            }
        }
    }
}

// MARK: Equatable
func ==(lhs: Event, rhs: Event) -> Bool {
    return lhs.startDate.equalToDate(rhs.startDate)
}

// MARK: Comparable
func <(lhs: Event, rhs: Event) -> Bool {
    return lhs.startDate.isLessThanDate(rhs.startDate)
}
