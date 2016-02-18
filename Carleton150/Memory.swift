//
//  Memory.swift
//  Carleton150

class Memory {
    
    var title: String!
    var desc: String!
    var timestamp: String!
    var uploader: String!
    var location: CLLocationCoordinate2D!
    var image: UIImage!
    
    init(title: String, desc: String,
         timestamp: String, uploader: String,
         location: CLLocationCoordinate2D, image: UIImage) {
            
        self.title = title
        self.desc = desc
        self.timestamp = timestamp
        self.location = location
        self.image = image
    }
    
    convenience init(memory: Dictionary<String, AnyObject>?) {
        self.init(title: memory!["title"]! as! String, desc: memory!["desc"]! as! String,
                  timestamp: memory!["timestamp"]! as! String, uploader: memory!["uploader"]! as! String,
                  location: memory!["location"]! as! CLLocationCoordinate2D, image: memory!["image"]! as! UIImage)
    }
}