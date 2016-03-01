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
         timestamp: NSDate, uploader: String,
         location: CLLocationCoordinate2D, image: UIImage) {
            
        self.title = title
        self.desc = desc
        self.timestamp = Memory.buildDateString(timestamp)
        self.uploader = uploader
        self.location = location
        self.image = image
    }
   
    /**
        Given the date of the upload, formats it into the server's 
        format for accepting date strings.
     
        - Parameters: 
            - date: The date for this memory (usually the current one).
     */
    class func buildDateString(date: NSDate) -> String {
        let outFormatter = NSDateFormatter()
        outFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        return outFormatter.stringFromDate(date)
    }
    
    
    /**
        Given the date string from the server, formats the date
        into a nice date string with words.
     
        - Parameters: 
            - dateString: The dateString for the memory from the server.
     */
    class func parseDateString(dateString: String) -> String {
        let inFormatter = NSDateFormatter()
        inFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        let currentDate = inFormatter.dateFromString(dateString)
        
        let outFormatter = NSDateFormatter()
        outFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        outFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return outFormatter.stringFromDate(currentDate!)
    }
    
 
    /**
        A convenience initializer that uses a dictionary that contains
        the data.
        
        - Parameters: 
            - memory: The dictionary containing all of the memory information.
     */
    convenience init(memory: Dictionary<String, AnyObject>?) {
        self.init(title: memory!["title"]! as! String, desc: memory!["desc"]! as! String,
                  timestamp: memory!["timestamp"]! as! NSDate, uploader: memory!["uploader"]! as! String,
                  location: memory!["location"]! as! CLLocationCoordinate2D, image: memory!["image"]! as! UIImage)
    }
}